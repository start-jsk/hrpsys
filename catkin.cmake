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


install(DIRECTORY bin/
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable
)

install(DIRECTORY lib/
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  FILES_MATCHING
  PATTERN "lib*.so"
  PATTERN "*.py"
  PATTERN "*.pyc"
  PATTERN "hrpsys-base.pc"
)
#install(CODE
#  "execute_process(COMMAND \"cp lib/* ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib\")"
#)

install(DIRECTORY lib/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib
  PATTERN "lib*.so" EXCLUDE
  PATTERN "*.py" EXCLUDE
  PATTERN "*.pyc" EXCLUDE
  PATTERN "hrpsys-base.pc" EXCLUDE
)
install(DIRECTORY include
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)
install(DIRECTORY share/hrpsys/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(CODE
  "execute_process(COMMAND echo \"fix hrpsys-base.pc ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # basic
")
