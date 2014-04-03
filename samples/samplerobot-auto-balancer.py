#!/usr/bin/env python

"""
 this is example file for SampleRobot robot

 $ roslaunch hrpsys samplerobot.launch
 $ rosrun    hrpsys samplerobot-auto-balancer.py

"""
import imp, sys, os

# set path to hrpsys to get import rpy, see <hrpsys>/test/test-samplerobot.py for using HrpsysConfigurator
try: 
    imp.find_module('hrpsys') # catkin installed
    sys.path.append(imp.find_module('hrpsys')[1]) # set path to hrpsys
except: # rosbuild installed
    import rospkg
    rp = rospkg.RosPack()
    sys.path.append(rp.get_path('hrpsys')+'/lib/python2.7/dist-packages/hrpsys')
    sys.path.append(rp.get_path('openrtm_aist_python')+'/lib/python2.7/dist-packages')



import rtm

from rtm import *
from OpenHRP import *

def connectComps():
    connectPorts(bridge.port("q"), [seq.port("qInit"), sh.port("currentQIn")])
    #
    connectPorts(seq.port("qRef"), sh.port("qIn"))
    connectPorts(sh.port("qOut"), abc.port("qRef"))
    connectPorts(abc.port("q"), hgc.port("qIn"))
    #

def activateComps():
    rtm.serializeComponents([bridge, seq, sh, abc])
    seq.start()
    sh.start()
    abc.start()

def createComps():
    global bridge, seq, seq_svc, sh, abc, abc_svc, hgc

    bridge = findRTC("SampleRobot(Robot)0")

    ms.load("SequencePlayer")
    seq = ms.create("SequencePlayer", "seq")
    seq_svc = narrow(seq.service("service0"),"SequencePlayerService")
    ms.load("StateHolder")
    sh = ms.create("StateHolder", "sh")
    ms.load("AutoBalancer")
    abc = ms.create("AutoBalancer", "abc")
    abc_svc = narrow(abc.service("service0"),"AutoBalancerService")

    hgc = findRTC("HGcontroller0")

def init():
    global ms

    ms = rtm.findRTCmanager()

    print "creating components"
    createComps()
      
    print "connecting components"
    connectComps()

    print "activating components"
    activateComps()
    print "initialized successfully"

if __name__ == '__main__':
    initCORBA()
    init()
    # set initial pose from sample/controller/SampleController/etc/Sample.pos
    initial_pose = [-7.779e-005,  -0.378613,  -0.000209793,  0.832038,  -0.452564,  0.000244781,  0.31129,  -0.159481,  -0.115399,  -0.636277,  0,  0,  0,  -7.77902e-005,  -0.378613,  -0.000209794,  0.832038,  -0.452564,  0.000244781,  0.31129,  0.159481,  0.115399,  -0.636277,  0,  0,  0,  0,  0,  0]
    arm_front_pose = [-7.779e-005,  -0.378613,  -0.000209793,  0.832038,  -0.452564,  0.000244781, -0.8,  -0.159481,  -0.115399,  -0.636277,  0,  0,  0,  -7.77902e-005,  -0.378613,  -0.000209794,  0.832038,  -0.452564,  0.000244781,  -0.8,  0.159481,  0.115399,  -0.636277,  0,  0,  0,  0.2,  0,  0]
    seq_svc.setJointAngles(initial_pose, 2.0)
    seq_svc.waitInterpolation()

    # sample for AutoBalancer mode
    #   1. AutoBalancer mode by fixing feet
    abc_svc.startABC([AutoBalancerService.AutoBalancerLimbParam(":rleg", [0,0,0], [0,0,0,0]),
                      AutoBalancerService.AutoBalancerLimbParam(":lleg", [0,0,0], [0,0,0,0])]);
    seq_svc.setJointAngles(arm_front_pose, 1.0)
    seq_svc.waitInterpolation()
    seq_svc.setJointAngles(initial_pose, 1.0)
    seq_svc.waitInterpolation()
    abc_svc.stopABC();
    #   2. AutoBalancer mode by fixing hands and feet
    abc_svc.startABC([AutoBalancerService.AutoBalancerLimbParam(":rleg", [0,0,0], [0,0,0,0]),
                      AutoBalancerService.AutoBalancerLimbParam(":lleg", [0,0,0], [0,0,0,0]),
                      AutoBalancerService.AutoBalancerLimbParam(":rarm", [0,0,0], [0,0,0,0]),
                      AutoBalancerService.AutoBalancerLimbParam(":larm", [0,0,0], [0,0,0,0])])
    seq_svc.setJointAngles(arm_front_pose, 1.0)
    seq_svc.waitInterpolation()
    seq_svc.setJointAngles(initial_pose, 1.0)
    seq_svc.waitInterpolation()
    abc_svc.stopABC();
    #   3. getAutoBalancerParam
    ret = abc_svc.getAutoBalancerParam()
    if ret[0]:
        print "getAutoBalancerParam() => OK"
    #   4. setAutoBalancerParam
    ret[1].default_zmp_offsets = [[0.1,0,0], [0.1,0,0]]
    abc_svc.setAutoBalancerParam(ret[1])
    if ret[0] and ret[1].default_zmp_offsets == [[0.1,0,0], [0.1,0,0]]:
        print "setAutoBalancerParam() => OK"
    abc_svc.startABC([AutoBalancerService.AutoBalancerLimbParam(":rleg", [0,0,0], [0,0,0,0]),
                      AutoBalancerService.AutoBalancerLimbParam(":lleg", [0,0,0], [0,0,0,0])]);
    abc_svc.stopABC();
    ret[1].default_zmp_offsets = [[0,0,0], [0,0,0]]
    abc_svc.setAutoBalancerParam(ret[1])

    # sample for walk pattern generation by AutoBalancer RTC
    #   1. goPos
    abc_svc.goPos(0.1, 0.05, 20)
    abc_svc.waitFootSteps()
    #   2. goVelocity and goStop
    abc_svc.goVelocity(-0.1, -0.05, -20)
    time.sleep(1)
    abc_svc.goStop()
    #   3. setFootSteps
    # abc_svc.setFootSteps([AutoBalancerService.Footstep([0,-0.045,0], [1,0,0,0], ":rleg"), AutoBalancerService.Footstep([0,0.045,0], [1,0,0,0], ":lleg")])
    # abc_svc.waitFootSteps()
    #   4. getGaitGeneratorParam
    ret = abc_svc.getGaitGeneratorParam()
    if ret[0]:
        print "getGaitGeneratorParam() => OK"
    #   5. setGaitGeneratorParam
    ret[1].default_step_time = 0.7
    ret[1].default_step_height = 0.15
    ret[1].default_double_support_ratio = 0.4
    ret = abc_svc.getGaitGeneratorParam()
    if ret[0] and ret[1].default_step_time == 0.7 and ret[1].default_step_height == 0.15 and ret[1].default_double_support_ratio == 0.4:
        print "setGaitGeneratorParam() => OK"
    abc_svc.goVelocity(0,0,0)
    time.sleep(1)
    abc_svc.goStop()
    #   6. walking by fixing 
    # abc_svc.startABC([AutoBalancerService.AutoBalancerLimbParam(":rleg", [0,0,0], [0,0,0,0]),
    #                   AutoBalancerService.AutoBalancerLimbParam(":lleg", [0,0,0], [0,0,0,0]),
    #                   AutoBalancerService.AutoBalancerLimbParam(":rarm", [0,0,0], [0,0,0,0]),
    #                   AutoBalancerService.AutoBalancerLimbParam(":larm", [0,0,0], [0,0,0,0])])
    # abc_svc.goPos(0.1, 0.05, 20)
    # abc_svc.waitFootSteps()
    # abc_svc.stopABC()

## IGNORE ME: this code used for rostest
if [s for s in sys.argv if "--gtest_output=xml:" in s] :
    import unittest, rostest
    rostest.run('hrpsys', 'samplerobot_auto_balancer', unittest.TestCase, sys.argv)






