if(NOT USE_ROSBUILD)
  include(catkin.cmake)
  return()
endif()
cmake_minimum_required(VERSION 2.4.6)
include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Build hrpsys before rtmbuild_init
rosbuild_find_ros_package(openrtm_aist)
if(EXISTS ${openrtm_aist_PACKAGE_PATH}/bin)
  set(OPENRTM_DIR ${openrtm_aist_PACKAGE_PATH})
else()
  find_package(openrtm_aist)
  set(OPENRTM_DIR ${openrtm_aist_PREFIX}/lib/openrtm_aist)
endif()
execute_process(COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base OPENRTM_DIR=${OPENRTM_DIR}
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Build of hrpsys failed")
endif(_make_failed)

rosbuild_init()

## fix conf file
rosbuild_find_ros_package(openhrp3)
if(NOT EXISTS ${openhrp3_PACKAGE_PATH}/bin) ## openhrp3 is installed via deb
  find_package(openhrp3)
  message("      openhrp3_PREFIX=${openhrp3_PREFIX}")
  file(GLOB _conf_files "${PROJECT_SOURCE_DIR}/share/hrpsys/samples/*/*.conf" "${PROJECT_SOURCE_DIR}/share/hrpsys/samples/*/*.xml")
  message("sed -i s@\$(PROJECT_DIR)@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1/sample/project@g ")
  message("sed -i s@${openhrp3_PREFIX}/share/OpenHRP-3.1@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g ")
  foreach(_conf_file ${_conf_files})
    message(" ... ${_conf_file}")
      execute_process(COMMAND sed -i s@\$\(PROJECT_DIR\)@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1/sample/project@g ${_conf_file})
      execute_process(COMMAND sed -i s@${openhrp3_PREFIX}/share/OpenHRP-3.1@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g ${_conf_file})
  endforeach()
endif()

## sample/samplerobots
set(OPENHRP3_SAMPLE_DIR "${openhrp3_PACKAGE_PATH}/share/OpenHRP-3.1/sample")
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.conf.in ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.conf)
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.xml.in  ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.xml)
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.RobotHardware.conf.in
               ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.RobotHardware.conf)

rosbuild_add_rostest(test/test-hrpsys.test)
rosbuild_add_rostest(test/test-colcheck.test)
rosbuild_add_rostest(test/test-pa10.test)
rosbuild_add_rostest(test/test-simulator.test)
