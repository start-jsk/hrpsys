#!/usr/bin/env python

"""
 this is example file for SampleRobot robot

 $ roslaunch hrpsys samplerobot.launch
 $ rosrun    hrpsys samplerobot-walk.py

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
    connectPorts(bridge.port("q"), seq.port("qInit"))
    #
    connectPorts(seq.port("qRef"), hgc.port("qIn"))
    #

def activateComps():
    rtm.serializeComponents([bridge, seq])
    seq.start()

def createComps():
    global bridge, seq, seq_svc, hgc

    bridge = findRTC("SampleRobot(Robot)0")

    ms.load("SequencePlayer")
    seq = ms.create("SequencePlayer", "seq")
    seq_svc = narrow(seq.service("service0"),"SequencePlayerService")

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

def loadPattern(basename, tm=1.0):
    seq_svc.loadPattern(basename, tm)
    seq_svc.waitInterpolation()

if __name__ == '__main__':
    initCORBA()
    init()

    from subprocess import check_output
    openhrp3_path = check_output(['rospack','find','openhrp3']).rstrip() # for rosbuild
    PKG_CONFIG_PATH=""
    if os.path.exists(os.path.join(openhrp3_path, "bin")) :
        PKG_CONFIG_PATH='PKG_CONFIG_PATH=%s/lib/pkgconfig:$PKG_CONFIG_PATH'%(openhrp3_path)

    cmd = "%s pkg-config openhrp3.1 --variable=idl_dir"%(PKG_CONFIG_PATH)
    os.path.join(check_output(cmd, shell=True).rstrip(), "../sample/controller/SampleController/etc/Sample")
    loadPattern(os.path.join(check_output(cmd, shell=True).rstrip(), "../sample/controller/SampleController/etc/Sample"))

## IGNORE ME: this code used for rostest
if [s for s in sys.argv if "--gtest_output=xml:" in s] :
    import unittest, rostest
    rostest.run('hrpsys', 'samplerobot_walk', unittest.TestCase, sys.argv)






