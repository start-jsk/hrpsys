#!/usr/bin/env python

PKG = 'hrpsys'
NAME = 'test-pkgconfig'

code = """
#include <sys/types.h> /* iob.h need this */
#include "io/iob.h"
int main (int argc, char** argv)
{
  open_iob();
  close_iob();
  return 0;
}
"""
import unittest, os, sys
from subprocess import call, check_output, Popen, PIPE, STDOUT

class TestHrpsysPkgconfig(unittest.TestCase):

    def test_compile_iob(self):
        global PID
        cmd = "pkg-config hrpsys-base --cflags --libs"
        print "`"+cmd+"` =",check_output(cmd, shell=True, stderr=STDOUT)
        ret = call("gcc -o hrpsys-sample-pkg-config /tmp/%d-hrpsys-sample.cpp `%s` -lhrpIo"%(PID,cmd), shell=True)
        self.assertTrue(ret==0)

    def test_idlfile(self):
        cmd = "pkg-config hrpsys-base --variable=idldir"
        print "`"+cmd+"`/RobotHardwareService.idl = ",os.path.join(check_output(cmd, shell=True, stderr=STDOUT).rstrip(), "RobotHardwareService.idl")
        self.assertTrue(os.path.exists(os.path.join(check_output(cmd, shell=True).rstrip(), "RobotHardwareService.idl")))

#unittest.main()
if __name__ == '__main__':
    import rostest
    global PID
    PID = os.getpid()
    f = open("/tmp/%d-hrpsys-sample.cpp"%(PID),'w')
    f.write(code)
    f.close()
    rostest.run(PKG, NAME, TestHrpsysPkgconfig, sys.argv)
