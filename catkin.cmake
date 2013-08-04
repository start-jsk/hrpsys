# http://ros.org/doc/groovy/api/catkin/html/user_guide/supposed.html
cmake_minimum_required(VERSION 2.8.3)
project(hrpsys)

# Build hrpsys
#find_package(openrtm_aist REQUIRED) # do not call find_package
#set(ENV{OPENRTM_DIR} ${openrtm_aist_SOURCE_PREFIX})
set(ENV{PKG_CONFIG_PATH} ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig)
set(ENV{OPENRTM_DIR} ${CMAKE_SOURCE_DIR}/openrtm_aist)
execute_process(COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Build of hrpsys-base failed")
endif(_make_failed)

##
##


# Load catkin and all dependencies required for this package
# TODO: remove all from COMPONENTS that are not catkin packages.
find_package(catkin REQUIRED COMPONENTS openhrp3)

# include_directories(include ${Boost_INCLUDE_DIR} ${catkin_INCLUDE_DIRS})
# CATKIN_MIGRATION: removed during catkin migration
# cmake_minimum_required(VERSION 2.4.6)

# CATKIN_MIGRATION: removed during catkin migration
# include($ENV{ROS_ROOT}/core/rosbuild/rosbuild.cmake)

# Set the build type.  Options are:
#  Coverage       : w/ debug symbols, w/o optimization, w/ code-coverage
#  Debug          : w/ debug symbols, w/o optimization
#  Release        : w/o debug symbols, w/ optimization
#  RelWithDebInfo : w/ debug symbols, w/ optimization
#  MinSizeRel     : w/o debug symbols, w/ optimization, stripped binaries
#set(ROS_BUILD_TYPE RelWithDebInfo)

## Uncomment this if the package has a setup.py. This macro ensures
## modules and global scripts declared therein get installed
## See http://ros.org/doc/api/catkin/html/user_guide/setup_dot_py.html
catkin_python_setup()

#set the default path for built executables to the "bin" directory
#set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
#set the default path for built libraries to the "lib" directory
#set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

#uncomment if you have defined messages
#add_message_files(
#  FILES
  # TODO: List your msg files here
#)
#uncomment if you have defined services
#add_service_files(
#  FILES
  # TODO: List your msg files here
#)

#common commands for building c++ executables and libraries
#add_library(${PROJECT_NAME} src/example.cpp)
#target_link_libraries(${PROJECT_NAME} another_library)
#
# CATKIN_MIGRATION: removed during catkin migration
# rosbuild_add_boost_directories()
#find_package(Boost REQUIRED COMPONENTS thread)
#include_directories(${Boost_INCLUDE_DIRS})
#target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES})
#add_executable(example examples/example.cpp)
#target_link_libraries(example ${PROJECT_NAME})
## Generate added messages and services with any dependencies listed here
#generate_messages(
  #TODO DEPENDENCIES geometry_msgs std_msgs
#)
# TODO: fill in what other packages will need to use this package
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
    DEPENDS jython libxml2 sdl opencv2 libqhull libglew-dev libirrlicht-dev boost doxygen
    CATKIN-DEPENDS openhrp3
    INCLUDE_DIRS include
    # LIBRARIES # TODO
)

# bin goes lib/hrpsys so that it can be invoked from rosrun
install(DIRECTORY bin
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/${PROJECT_NAME}
  USE_SOURCE_PERMISSIONS  # set executable
)
# libhrpsysUtil.so go to lib, plugins ges to share/hrpsys/lib
file(GLOB lib_files RELATIVE "${PROJECT_SOURCE_DIR}/lib" "lib/*")
foreach(_file ${lib_files})
  if(EXISTS "${PROJECT_SOURCE_DIR}/lib/${_file}/") # check if directory
    install(DIRECTORY lib/${_file} DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
  elseif(${_file} STREQUAL "libhrpsysUtil.so" OR
         ${_file} STREQUAL "libhrpsysBaseStub.so")
    install(FILES lib/${_file} DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
  else()
    install(FILES lib/${_file} DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib)
  endif()
endforeach()

install(DIRECTORY include
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)
install(DIRECTORY share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
