#!/usr/bin/env python

PKG = 'hrpsys'
NAME = 'test-colcheck'

import roslib; roslib.load_manifest('hrpsys')
from hrpsys import hrpsys_config

import socket
import rtm

import unittest
import rostest
import sys

class TestHrpsysColcheck(unittest.TestCase):

    def test_dummy(self):
        pass

#unittest.main()
if __name__ == '__main__':
    rostest.run(PKG, NAME, TestHrpsysColcheck, sys.argv)
