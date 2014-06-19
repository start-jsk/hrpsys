#!/usr/bin/env python

"""
 this is example file for SampleRobot robot

 $ roslaunch hrpsys samplerobot.launch
 $ rosrun    hrpsys samplerobot-stabilizer.py

"""

pkg = 'hrpsys'
import imp
try:
    imp.find_module(pkg)
except:
    import roslib
    roslib.load_manifest(pkg)

from hrpsys.hrpsys_config import *
import OpenHRP


def getRTCList ():
    return [
            ['seq', "SequencePlayer"],
            ['sh', "StateHolder"],
            ['fk', "ForwardKinematics"],
            ['kf', "KalmanFilter"],
            ['rmfo', "RemoveForceSensorLinkOffset"],
            ['abc', "AutoBalancer"],
            ['st', "Stabilizer"],
            ]

def init ():
    global hcf
    hcf = HrpsysConfigurator()
    hcf.getRTCList = getRTCList
    hcf.init ("SampleRobot(Robot)0")

if __name__ == '__main__':
    init()
    # set initial pose from sample/controller/SampleController/etc/Sample.pos
    initial_pose = [-7.779e-005,  -0.378613,  -0.000209793,  0.832038,  -0.452564,  0.000244781,  0.31129,  -0.159481,  -0.115399,  -0.636277,  0,  0,  0,  -7.77902e-005,  -0.378613,  -0.000209794,  0.832038,  -0.452564,  0.000244781,  0.31129,  0.159481,  0.115399,  -0.636277,  0,  0,  0,  0,  0,  0]
    hcf.seq_svc.setJointAngles(initial_pose, 2.0)
    hcf.seq_svc.waitInterpolation()

    # s
    hcf.st_svc.setParameter(OpenHRP.StabilizerService.stParam([0.5,0.5], [5.0, 5.0], [0.0,0.0], [0.1, 0.1], [0,0], [0,0], [0,0], [0,0], 0,0,0,0))
    hcf.st_svc.startStabilizer ()
    hcf.abc_svc.goPos(0.5, 0.1, 10)
    hcf.abc_svc.waitFootSteps()
    hcf.st_svc.stopStabilizer ()

## IGNORE ME: this code used for rostest
if [s for s in sys.argv if "--gtest_output=xml:" in s] :
    import unittest, rostest
    rostest.run('hrpsys', 'samplerobot_stabilizer', unittest.TestCase, sys.argv)






