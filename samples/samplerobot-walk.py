#!/usr/bin/env python

"""
 this is example file for SampleRobot robot

 $ roslaunch hrpsys samplerobot.launch
 $ rosrun    hrpsys samplerobot-walk.py

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
        ['fk', "ForwardKinematics"]
        ]

def init ():
    global hcf
    hcf = HrpsysConfigurator()
    hcf.getRTCList = getRTCList
    hcf.init ("SampleRobot(Robot)0")

def loadPattern(basename, tm=1.0):
    hcf.seq_svc.loadPattern(basename, tm)
    hcf.seq_svc.waitInterpolation()

if __name__ == '__main__':
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






