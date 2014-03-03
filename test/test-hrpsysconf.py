#!/usr/bin/env python

PKG = 'hrpsys'
NAME = 'test-waitinput'

import roslib; roslib.load_manifest('hrpsys')
from hrpsys import hrpsys_config

import unittest, sys

class TestHrpsysConfig(unittest.TestCase):

    def test_import_waitinput(self):
        # https://github.com/start-jsk/rtmros_hironx/blob/groovy-devel/hironx_ros_bridge/src/hironx_ros_bridge/hironx_client.py
        from waitInput import waitInputConfirm, waitInputSelect
        self.assertTrue(True)

if __name__ == '__main__':
    import rostest
    rostest.run(PKG, NAME, TestHrpsysConfig, sys.argv)
