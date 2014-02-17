#!/usr/bin/env python

PKG = 'hrpsys'
NAME = 'test-hostname'

import roslib; roslib.load_manifest('hrpsys')
from hrpsys import hrpsys_config

import socket
import rtm

import unittest
import rostest
import sys

class TestHrpsysHostname(unittest.TestCase):

    def check_initCORBA(self, nshost, nsport=2809):
        try:
            ms = rh = None
            rtm.nshost = nshost
            rtm.nsport = nsport
            rtm.initCORBA()
            ms = rtm.findRTCmanager()
            rh = rtm.findRTC("RobotHardware0")
            self.assertTrue(ms and rh)
        except Exception as e:
            print "{0}, RTCmanager={1}, RTC(RobotHardware0)={2}".format(str(e),ms,rh)
            self.fail()
            pass

    def test_gethostname(self):
        self.check_initCORBA(socket.gethostname())
    def test_localhost(self):
        self.check_initCORBA('localhost')
    def test_127_0_0_1(self):
        self.check_initCORBA('127.0.0.1')
    def test_None(self):
        self.check_initCORBA(None)

    @unittest.expectedFailure
    def test_X_unknown(self):
        self.check_initCORBA('unknown')

    @unittest.expectedFailure
    def test_X_123_45_67_89(self):
        self.check_initCORBA('123.45.67.89')

#unittest.main()
if __name__ == '__main__':
    rostest.run(PKG, NAME, TestHrpsysHostname, sys.argv)
