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
  COMMAND sh -c "test -e ${CATKIN_DEVEL_PREFIX}/share/hrpsys/ || rm -f ${PROJECT_SOURCE_DIR}/installed"
  COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.hrpsys-base OPENRTM_DIR=${OPENRTM_DIR} installed
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Compile hrpsys failed")
endif(_make_failed)
execute_process(
  COMMAND sh -c "test -e ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/bin || (mkdir -p ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}; mv ${CATKIN_DEVEL_PREFIX}/bin/* ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/)"
  OUTPUT_VARIABLE _copy_bin)
message("${_copy_bin}")


catkin_package(
    DEPENDS jython libxml2 sdl opencv2 libqhull libglew-dev libirrlicht-dev boost doxygen openhrp3
    CATKIN-DEPENDS
    INCLUDE_DIRS include
    SKIP_CMAKE_CONFIG_GENERATION
    SKIP_PKG_CONFIG_GENERATION
    # LIBRARIES # TODO
)


install(DIRECTORY bin
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable
)

install(DIRECTORY lib/
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
)
install(DIRECTORY include
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)
install(DIRECTORY share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(CODE
  "execute_process(COMMAND echo \"fix hrpsys-base.pc ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # basic
   execute_process(COMMAND sed -i s@{prefix}/include@{prefix}/include/${PROJECT_NAME}/include@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # for --libs
")
