# http://ros.org/doc/groovy/api/catkin/html/user_guide/supposed.html
cmake_minimum_required(VERSION 2.8.3)
project(hrpsys)

# Load catkin and all dependencies required for this package
find_package(catkin REQUIRED COMPONENTS rostest mk openrtm_aist openhrp3)

# Build hrpsys
# <devel>/lib/<package>/bin/RobotHardware
# <src>/lib/RobotHardware.so # so that `rospack find hrspsys`/lib can find .so
# <src>/<package>/share
# <install>/lib/<package>/RobotHardware # rosrun hrpsys RobtoHardware works
# <install>/lib/RobotHardware.so # so that `rospack find hrspsys`/lib can find .so
# <install>/<package>/share
if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)
  set(ENV{PATH} ${openrtm_aist_PREFIX}/lib/openrtm_aist/bin/:$ENV{PATH}) #update PATH for rtm-config
  execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR}
    make -f ${PROJECT_SOURCE_DIR}/Makefile.hrpsys-base
    INSTALL_DIR=${CATKIN_DEVEL_PREFIX}
    OPENRTM_DIR='' # keep blank so that FindOpenRTM.cmake uses rtm-config
    MK_DIR=${mk_PREFIX}/share/mk
    PKG_CONFIG_PATH_SETUP="PKG_CONFIG_PATH=${openhrp3_PREFIX}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}" # for openrtm3.1.pc
    installed
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "Compile hrpsys failed")
  endif(_make_failed)

  # move programs
  if(NOT EXISTS ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME})
    execute_process(
      COMMAND cmake -E make_directory ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}
      RESULT_VARIABLE _make_failed)
    if (_make_failed)
      message(FATAL_ERROR "make_directory ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME} failed: ${_make_failed}")
    endif(_make_failed)
  endif()
  execute_process(
    COMMAND grep ${CATKIN_DEVEL_PREFIX}/bin ${CMAKE_CURRENT_BINARY_DIR}/build/hrpsys-base/install_manifest.txt
    OUTPUT_VARIABLE _bin_files
    RESULT_VARIABLE _grep_failed)
  if (_grep_failed)
    message(FATAL_ERROR "grep : ${CMAKE_CURRENT_BINARY_DIR}/build/hrpsys-base/install_manifest.txt ${_make_failed}")
  endif(_grep_failed)
  string(REGEX REPLACE "\n" ";" _bin_files ${_bin_files})
  foreach(_bin_file ${_bin_files})
    get_filename_component(_bin_file_name ${_bin_file} NAME)
    execute_process(
      COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/bin/${_bin_file_name} ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/${_bin_file_name}
      RESULT_VARIABLE _rename_failed)
    message("move binary files ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/${_bin_file_name}")
    if (_rename_failed)
      message(FATAL_ERROR "Move hrpsys/bin failed: ${_make_failed}")
    endif(_rename_failed)
  endforeach()

  # move libraries
  if(NOT EXISTS ${PROJECT_SOURCE_DIR}/lib/)
    execute_process(
      COMMAND cmake -E make_directory ${PROJECT_SOURCE_DIR}/lib/
      RESULT_VARIABLE _make_failed)
    if (_make_failed)
      message(FATAL_ERROR "make_directory ${PROJECT_SOURCE_DIR}/lib/ failed: ${_make_failed}")
    endif(_make_failed)
  endif()
  execute_process(
    COMMAND grep ${CATKIN_DEVEL_PREFIX}/lib/ ${CMAKE_CURRENT_BINARY_DIR}/build/hrpsys-base/install_manifest.txt
    OUTPUT_VARIABLE _lib_files
    RESULT_VARIABLE _grep_failed)
  if (_grep_failed)
    message(FATAL_ERROR "grep : ${CMAKE_CURRENT_BINARY_DIR}/build/hrpsys-base/install_manifest.txt ${_grep_failed}")
  endif(_grep_failed)
  string(REGEX REPLACE "\n" ";" _lib_files ${_lib_files})
  foreach(_lib_file ${_lib_files})
    get_filename_component(_lib_file_name ${_lib_file} NAME)
    if(EXISTS ${CATKIN_DEVEL_PREFIX}/lib/${_lib_file_name})
      execute_process(
        COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/lib/${_lib_file_name} ${PROJECT_SOURCE_DIR}/lib/${_lib_file_name}
        RESULT_VARIABLE _rename_failed)
      message("move library files ${PROJECT_SOURCE_DIR}/lib/${_lib_file_name}")
      if (_rename_failed)
        message(FATAL_ERROR "Move hrpsys/lib failed: ${_rename_failed}")
      endif(_rename_failed)
    endif()
  endforeach()

  # move share directory
  if(EXISTS ${PROJECT_SOURCE_DIR}/share/)
    execute_process(
      COMMAND cmake -E remove_directory ${PROJECT_SOURCE_DIR}/share/
      RESULT_VARIABLE _make_failed)
    if (_make_failed)
      message(FATAL_ERROR "remove_directory ${PROJECT_SOURCE_DIR}/share/share failed: ${_make_failed}")
    endif(_make_failed)
  endif()
  execute_process(
    COMMAND cmake -E make_directory ${PROJECT_SOURCE_DIR}/share/
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "make_directory ${PROJECT_SOURCE_DIR}/share/share failed: ${_make_failed}")
  endif(_make_failed)
  execute_process(
    COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/share/hrpsys ${PROJECT_SOURCE_DIR}/share/hrpsys
    RESULT_VARIABLE _make_failed)
    message("move share directory ${CATKIN_DEVEL_PREFIX}/share/hrpsys ${PROJECT_SOURCE_DIR}/share/hrpsys")
  if (_make_failed)
    message(FATAL_ERROR "Move share/hrpsys failed: ${_make_failed}")
  endif(_make_failed)
  execute_process(
    COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/share/doc ${PROJECT_SOURCE_DIR}/share/doc
    RESULT_VARIABLE _make_failed)
    message("move share directory ${CATKIN_DEVEL_PREFIX}/share/doc ${PROJECT_SOURCE_DIR}/share/doc
")
  if (_make_failed)
    message(FATAL_ERROR "Move share/hrpsys failed: ${_make_failed}")
  endif(_make_failed)

  file(GLOB _conf_files "${PROJECT_SOURCE_DIR}/share/hrpsys/samples/*/*.conf")
  foreach(_conf_file ${_conf_files})
    message("sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${PROJECT_SOURCE_DIR}/lib@s ${_conf_file} ")
    execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${PROJECT_SOURCE_DIR}/lib@g ${_conf_file})
  endforeach()

  message("fix ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/hrpsys-base.pc")
  execute_process(COMMAND sed -i s@\${prefix}/share@${PROJECT_SOURCE_DIR}/share@g ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # basic

endif(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)


# #
catkin_package(
)

# #
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/hrpsys
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION})
install(DIRECTORY lib/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib
  USE_SOURCE_PERMISSIONS)
install(DIRECTORY test share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS)

install(CODE
  "execute_process(COMMAND echo \"fix ${_conf_file} ${PROJECT_SOURCE_DIR} -> ${CMAKE_INSTALL_PREFIX}\")
   file(GLOB _conf_files \"\$ENV{DISTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/share/hrpsys/samples/*/*.conf\")
   foreach(_conf_file \${_conf_files})
     execute_process(COMMAND echo \"fix \${_conf_file}\")
     #execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}/share/OpenHRP-3.1@${CMAKE_INSTALL_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g \${_conf_file})
     execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}/lib@${CMAKE_INSTALL_PREFIX}/share/hrpsys/lib@g \${_conf_file})
     #execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}@g \${_conf_file})
   endforeach()
  ")

install(CODE
  "execute_process(COMMAND echo \"fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
   execute_process(COMMAND sed -i s@{prefix}/bin@${prefix}/lib/hrpsys@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
   execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}/share@\\\${prefix}/share/hrpsys/share@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
")

add_rostest(test/test-hrpsys.test)
add_rostest(test/test-colcheck.test)
