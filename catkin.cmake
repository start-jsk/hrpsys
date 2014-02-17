# http://ros.org/doc/groovy/api/catkin/html/user_guide/supposed.html
cmake_minimum_required(VERSION 2.8.3)
project(hrpsys)

# Load catkin and all dependencies required for this package
find_package(catkin REQUIRED COMPONENTS)

# Build hrpsys
find_package(PkgConfig)
pkg_check_modules(openrtm_aist openrtm-aist REQUIRED)
set(OPENRTM_DIR ${openrtm_aist_PREFIX}/lib/openrtm_aist)
set(ENV{PKG_CONFIG_PATH} $ENV{PKG_CONFIG_PATH}:${CATKIN_DEVEL_PREFIX}/lib/pkgconfig)
execute_process(
  COMMAND sh -c "test -e ${CATKIN_DEVEL_PREFIX}/share/hrpsys/ || rm -f ${PROJECT_SOURCE_DIR}/installed ${PROJECT_SOURCE_DIR}/build/hrpsys-base/CMakeCache.txt"
  COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base OPENRTM_DIR=${OPENRTM_DIR} PKG_CONFIG_PATH_SETUP= INSTALL_DIR=${CATKIN_DEVEL_PREFIX} build/hrpsys-base-source
                RESULT_VARIABLE _checkout_failed)
if (_checkout_failed)
  message(FATAL_ERROR "Download hrpsys failed")
endif(_checkout_failed)
execute_process(
  COMMAND sed -i s@{OPENHRP_DIR}/share/OpenHRP-3.1/idl/@{OPENHRP_DIR}/share/openhrp3/share/OpenHRP-3.1/idl/@ ${PROJECT_SOURCE_DIR}/build/hrpsys-base-source/idl/CMakeLists.txt
  COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base OPENRTM_DIR=${OPENRTM_DIR} INSTALL_DIR=${CATKIN_DEVEL_PREFIX} installed
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Compile hrpsys failed")
endif(_make_failed)

# binary files intentionally goes to ${CATKIN_PACKAGE_BIN_DESTINATION}/lib
execute_process(
  COMMAND sh -c "test -e ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME} || (mkdir -p ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}; mv ${CATKIN_DEVEL_PREFIX}/bin/* ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/)"
  RESULT_VARIABLE _make_failed
  OUTPUT_VARIABLE _copy_bin)
message("copy binary files ${_copy_bin}")
if (_make_failed)
  message(FATAL_ERROR "Copy hrpsys/bin failed: ${_make_failed}")
endif(_make_failed)

# shared files intentionally goes to ${CATKIN_PACKAGE_SHARE_DESTINATION}
execute_process(
  COMMAND sh -c "test -e ${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME}/share/${PROJECT_NAME} || (mkdir -p ${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME}/share/${PROJECT_NAME}; mv -v ${CATKIN_DEVEL_PREFIX}/share/hrpsys/idl ${CATKIN_DEVEL_PREFIX}/share/hrpsys/samples ${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME}/share/${PROJECT_NAME})"
  RESULT_VARIABLE _make_failed
  OUTPUT_VARIABLE _copy_share)
message("copy shared files ${_copy_share}")
if (_make_failed)
  message(FATAL_ERROR "Copy hrpsys/share failed: ${_make_failed}")
endif(_make_failed)

# plugin lib files intentionally goes to ${CATKIN_PACKAGE_SHARE_DESTINATION}
execute_process(
  COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR}/build/hrpsys-base/rtc cmake -DCMAKE_INSTALL_PREFIX=${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME} -P cmake_install.cmake
  RESULT_VARIABLE _make_failed
  OUTPUT_VARIABLE _copy_lib)
message("copy plugin library files ${_copy_lib}")
if (_make_failed)
  message(FATAL_ERROR "Copy hrpsys plugin libraries failed: ${_make_failed}")
endif(_make_failed)

# ec files intentionally goes to ${CATKIN_PACKAGE_SHARE_DESTINATION}
execute_process(
  COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR}/build/hrpsys-base/ec cmake -DCMAKE_INSTALL_PREFIX=${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME} -P cmake_install.cmake
  RESULT_VARIABLE _make_failed
  OUTPUT_VARIABLE _copy_lib)
message("copy ec library files ${_copy_lib}")
if (_make_failed)
  message(FATAL_ERROR "Copy hrpsys ec libraries failed: ${_make_failed}")
endif(_make_failed)

# remove original plugin/ec lib files, (since they are intentionally goes to ${CATKIN_PACKAGE_SHARE_DESTINATION})
execute_process(
  COMMAND cmake -E remove_directory ${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME}/bin
  COMMAND sh -c "(cd ${CATKIN_DEVEL_PREFIX}/share/${PROJECT_NAME}/lib; find -iname \"*.so\" -exec rm ${CATKIN_DEVEL_PREFIX}/lib/{} \;)"
  RESULT_VARIABLE _make_failed
  OUTPUT_VARIABLE _copy_lib)
message("remove original plugin library files ${_copy_lib}")
if (_make_failed)
  message(FATAL_ERROR "Remove original hrpsys plugin libraries failed: ${_make_failed}")
endif(_make_failed)

# fix PA10 sample file
execute_process(
  COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${CATKIN_DEVEL_PREFIX}/share/hrpsys/lib@ ${CATKIN_DEVEL_PREFIX}/share/hrpsys/share/hrpsys/samples/PA10/hrpsys.sh
  COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${CATKIN_DEVEL_PREFIX}/share/hrpsys/lib@ ${CATKIN_DEVEL_PREFIX}/share/hrpsys/share/hrpsys/samples/PA10/rtc.conf
  COMMAND sed -i s@localhost:15005@localhost:2809@ ${CATKIN_DEVEL_PREFIX}/share/hrpsys/share/hrpsys/samples/PA10/rtc.conf
  COMMAND sed -i s@OpenHRP-3.1@openhrp3/share/OpenHRP-3.1@ ${CATKIN_DEVEL_PREFIX}/share/hrpsys/share/hrpsys/samples/PA10/RobotHardware.conf
  COMMAND sed -i s@$(PROJECT_DIR)/..@/opt/ros/groovy/share/openhrp3/share/OpenHRP-3.1/sample@ ${CATKIN_DEVEL_PREFIX}/share/hrpsys/share/hrpsys/samples/PA10/PA10monitor.xml
                RESULT_VARIABLE _sed_failed)
if (_sed_failed)
  message(FATAL_ERROR "Fix hrpsys sample file failed")
endif(_sed_failed)

#
catkin_package(
    DEPENDS jython libxml2 sdl opencv2 libqhull libglew-dev libirrlicht-dev boost doxygen openhrp3
    CATKIN-DEPENDS
    INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
    SKIP_CMAKE_CONFIG_GENERATION
    SKIP_PKG_CONFIG_GENERATION
    # LIBRARIES # TODO
)


install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/bin/
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable
)

install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable
)

install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/hrpsys/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)
install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/share/hrpsys/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable for hrpsys/lib
)

install(CODE
  "execute_process(COMMAND echo \"fix hrpsys-base.pc ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # basic
")
