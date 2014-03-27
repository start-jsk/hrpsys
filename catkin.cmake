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
    PKG_CONFIG_PATH=${openhrp3_PREFIX}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH} # for openrtm3.1.pc
    installed
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "Compile hrpsys failed")
  endif(_make_failed)

  # move programs
  # bin -> lib/hrpsys/
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
  # lib -> {source}/lib
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
      if ("${_lib_file_name}" MATCHES "libhrp.*so")     # libhrpsys*.so and libhrpIo.so remains in global directory
      else()                                            # RTC components goto `rospack find hrpsys`/lib directory
        execute_process(
          COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/lib/${_lib_file_name} ${PROJECT_SOURCE_DIR}/lib/${_lib_file_name}
          RESULT_VARIABLE _rename_failed)
        message("move library files ${PROJECT_SOURCE_DIR}/lib/${_lib_file_name}")
      endif()
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
  if(EXISTS ${CATKIN_DEVEL_PREFIX}/share/doc)
    execute_process(
      COMMAND cmake -E rename ${CATKIN_DEVEL_PREFIX}/share/doc ${PROJECT_SOURCE_DIR}/share/doc
      RESULT_VARIABLE _make_failed)
    message("move doc directory ${CATKIN_DEVEL_PREFIX}/share/doc ${PROJECT_SOURCE_DIR}/share/doc")
    if (_make_failed)
      message(FATAL_ERROR "Move share/doc failed: ${_make_failed}")
    endif(_make_failed)
  endif()

  message("openhrp3_SOURCE_DIR=${openhrp3_SOURCE_DIR}")
  message("    openhrp3_PREFIX=${openhrp3_PREFIX}")
  file(GLOB _conf_files "${PROJECT_SOURCE_DIR}/share/hrpsys/samples/*/*.conf" "${PROJECT_SOURCE_DIR}/share/hrpsys/samples/*/*.xml")
  foreach(_conf_file ${_conf_files})
    if (EXISTS ${openhrp3_SOURCE_DIR})
      message("sed -i s@\$(PROJECT_DIR)@${openhrp3_SOURCE_DIR}/share/OpenHRP-3.1/sample/project@g ${_conf_file}")
      execute_process(COMMAND sed -i s@\$\(PROJECT_DIR\)@${openhrp3_SOURCE_DIR}/share/OpenHRP-3.1/sample/project@g ${_conf_file})
      message("sed -i s@${CATKIN_DEVEL_PREFIX}/share/OpenHRP-3.1@${openhrp3_SOURCE_DIR}/share/OpenHRP-3.1@g ${_conf_file}")
      execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/share/OpenHRP-3.1@${openhrp3_SOURCE_DIR}/share/OpenHRP-3.1@g ${_conf_file})
    else()
      message("sed -i s@\$(PROJECT_DIR)@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1/sample/project@g ${_conf_file}")
      execute_process(COMMAND sed -i s@\$\(PROJECT_DIR\)@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1/sample/project@g ${_conf_file})
      message("sed -i s@${openhrp3_PREFIX}/share/OpenHRP-3.1@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g ${_conf_file}")
      execute_process(COMMAND sed -i s@${openhrp3_PREFIX}/share/OpenHRP-3.1@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g ${_conf_file})
    endif()
    message("sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${PROJECT_SOURCE_DIR}/lib@s ${_conf_file} ")
    execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/lib@${PROJECT_SOURCE_DIR}/lib@g ${_conf_file})
    message("sed -i s@${CATKIN_DEVEL_PREFIX}/share@${PROJECT_SOURCE_DIR}/share@s ${_conf_file} ")
    execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}/share@${PROJECT_SOURCE_DIR}/share@g ${_conf_file})
  endforeach()

  message("fix ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/hrpsys-base.pc")
  execute_process(COMMAND sed -i s@\${prefix}/share@${PROJECT_SOURCE_DIR}/share@g ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/hrpsys-base.pc) # basic

endif(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)


# #
catkin_package(
)

## sample/samplerobots
set(ENV{PKG_CONFIG_PATH} ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH})
execute_process(COMMAND pkg-config openhrp3.1   --variable=idl_dir      OUTPUT_VARIABLE hrp_idldir   OUTPUT_STRIP_TRAILING_WHITESPACE)
get_filename_component(OPENHRP3_SAMPLE_DIR "${hrp_idldir}/../sample" ABSOLUTE)
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.conf.in ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.conf)
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.xml.in  ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.xml)
configure_file(${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.RobotHardware.conf.in
               ${PROJECT_SOURCE_DIR}/samples/samplerobot/SampleRobot.RobotHardware.conf)

# #
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/hrpsys
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION})
install(
  FILES ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/hrpsys-base.pc
  DESTINATION ${CATKIN_GLOBAL_LIB_DESTINATION}/pkgconfig)
install(DIRECTORY lib/
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/lib
  USE_SOURCE_PERMISSIONS)
install(DIRECTORY test share samples
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS)

## copy CATKIN_DEVEL_PREFIX/lib directory
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
  install(PROGRAMS ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/${_bin_file_name} DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/${PROJECT_NAME})
endforeach()
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
  if ("${_lib_file}" MATCHES "lib/python*")
    # install all python code
    string(REGEX REPLACE "${CATKIN_DEVEL_PREFIX}/lib" "" _py_file ${_lib_file})
    get_filename_component(_py_file_dir ${_py_file} PATH)
    #install(PROGRAMS ${CATKIN_DEVEL_PREFIX}/lib/${_py_file} DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/${_py_file_dir})
    install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/${_py_file_dir}/ DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/${_py_file_dir})
  elseif ("${_lib_file_name}" MATCHES "libhrp.*so")     # libhrpsys*.so and libhrpIo.so remains in global directory
    install(PROGRAMS ${CATKIN_DEVEL_PREFIX}/lib/${_lib_file_name} DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
  endif()
endforeach()
## done copy libs

install(CODE
  "execute_process(COMMAND echo \"fix ${_conf_file} ${PROJECT_SOURCE_DIR} -> ${CMAKE_INSTALL_PREFIX}\")
   if (EXISTS ${openhrp3_SOURCE_DIR})
     execute_process(COMMAND echo \"                  ${openhrp3_SOURCE_DIR} -> ${openhrp3_PREFIX}/share/openhrp3\")
   endif()
   execute_process(COMMAND echo \"                  ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   file(GLOB _conf_files \"\$ENV{DISTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/share/hrpsys/samples/*/*.*\")
   file(GLOB _sample_files \"\$ENV{DISTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/samples/samplerobot/*.*\")
   foreach(_conf_file \${_conf_files} \${_sample_files})
     execute_process(COMMAND echo \"fix \${_conf_file}\")
     if (EXISTS ${openhrp3_SOURCE_DIR})
       execute_process(COMMAND sed -i s@${openhrp3_SOURCE_DIR}/share/OpenHRP-3.1@${openhrp3_PREFIX}/share/openhrp3/share/OpenHRP-3.1@g \${_conf_file})
     endif()
     execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}/lib@${CMAKE_INSTALL_PREFIX}/share/hrpsys/lib@g \${_conf_file})
     execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \${_conf_file})
   endforeach()
  ")

install(CODE
  "# check if hrpsys-base.pc exists
   if (NOT EXISTS \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc )
    message(FATAL_ERROR \"FATAL_ERROR \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc is not exists\")
   endif()
   execute_process(COMMAND echo \"fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
   execute_process(COMMAND sed -i s@{prefix}/bin@${prefix}/lib/hrpsys@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
   execute_process(COMMAND sed -i s@${PROJECT_SOURCE_DIR}/share@\\\${prefix}/share/hrpsys/share@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/hrpsys-base.pc) # basic
")

add_rostest(test/test-hrpsys.test)
add_rostest(test/test-colcheck.test)
add_rostest(test/test-pa10.test)
add_rostest(test/test-simulator.test)



