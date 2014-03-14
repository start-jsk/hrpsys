if(NOT USE_ROSBUILD)
  include(catkin.cmake)
  return()
endif()
cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Build hrpsys before rtmbuild_init
execute_process(COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Build of hrpsys failed")
endif(_make_failed)

rosbuild_init()

rosbuild_add_rostest(test/test-hrpsys.test)
rosbuild_add_rostest(test/test-colcheck.test)
rosbuild_add_rostest(test/test-pa10.test)
rosbuild_add_rostest(test/test-simulator.test)
