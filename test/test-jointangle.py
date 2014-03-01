#!/usr/bin/env python

PKG = 'hrpsys'
NAME = 'test-hostname'

import os
import sys
import time
import unittest
import yaml

import rostest
from hrpsys import rtm
from hrpsys.hrpsys_config import *
import OpenHRP

rtm.nsport = 2809

class PA10(HrpsysConfigurator):
    def getRTCList(self):
        return [
            ['seq', "SequencePlayer"],
            ['sh', "StateHolder"],
            ['fk', "ForwardKinematics"],
            ]



class TestJointAngle(unittest.TestCase):

    @classmethod
    def setUpClass(self):
        h = PA10()
        h.init()

    def test_get_joint_angles(self):
        h = PA10()
        h.findComps()
        print >>sys.stderr,  h.getJointAngles()
        self.assertEqual(len(h.getJointAngles()), int(9))

    def test_set_joint_angles(self):
        h = PA10()
        h.findComps()
        self.assertTrue(h.setJointAngles(h.getJointAngles(),1))
        self.assertEqual(h.waitInterpolation(), None)

#unittest.main()
if __name__ == '__main__':
    rostest.run(PKG, NAME, TestJointAngle, sys.argv)


