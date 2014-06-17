^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package hrpsys
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

315.2.2 (2014-06-17)
--------------------
* (catkin.cmake) add code to check if hrpsys is installed correctly
* manifest.xml/package.xml: depends on cv_bridge instad of opencv (https://github.com/ros/rosdistro/pull/4763)
* add patch to use opencv2.pc for last resort
* (catkin.cmake) install src directory for custom iob
* fix for hrp4c.launch
* update to hrpsys version 315.2.2
* (catkin.cmake) install src directory for custom iob, see https://github.com/start-jsk/rtmros_gazebo/issues/35 for discussion
* (hrp4c_model_download.sh) set rw permissions to all users for hrp4c model
* (catkin.cmkae) use sed to fis install dir
* sample/samplerobot-remove-force-offset.py : add sample code for RMFO rtc
* (catkin.cmake) add disable ssl
* Contributors: Kei Okada, Shunichi Nozawa

315.2.1 (2014-05-12)
--------------------
* Merge pull request `#83 <https://github.com/start-jsk/hrpsys/issues/83>`_ from k-okada/add_git
  add build_depend to git
* Contributors: Kei Okada

315.2.0 (2014-05-11)
--------------------
* update in fkanehiro/hrpsys-base repository
* 53de9aa (hrpsys_config.py) fix getRTCList only for stable RTC
* 69b153e (KalmanFilter, Stabilizer) adds options to disable building KalmanFilter and Stabilizer
* 1c6a1dd (hrpsys_config.py) add DataLogger clear in setupLogger to start log data with same starting time
* ad5401f (rtm.py) use % operator instead of format ;; format cannot be used in python < 2.6
* 7eec546 (KalmanFilter) avoid devision by zero
* d6db569 (CMakeLists.txt) add Boost patch (remove -mt suffix)
* 5dc9883 (ImpedanceController) add time stamp to output port, which are copied from m_q input time stamp
* 917c8f1 (AutoBalancer) add time stamp to output ports, which are copied from m_q input time stamp
* 9f09a3e (AutoBalancer) add baseTform to output transformation of base link
* eaf85c2 (VideoCapture) enters ERROR state when a video devices doesn't exist
* 8034945 (VideoCapture) opens video devices at onActivate()
* b3e253b (SORFilter) adds a new component, SORFilter(PCL is required)
* ec32ed0 (VideoCapture) enables to specify camera device ids by using a configuration variable, devIds
* d651827 (AutoBalancer) fix first foot steps ;; this update is discussed in https://github.com/jsk-ros-pkg/jsk_control/issues/1
* e889719 (RemoveForceSensorLinkOffset) remove unused files commited at previous commit
* 430aa95 rename rtc ;; AbsoluteForceSensor -> RemoveForceSensorLinkOffset
* 72fff04 (AutoBalancerService.idl, AutoBalancer) update start and stop function for AutoBalancer mode ;; use string sequence instead of deprecated type's sequence ;; rename function
* 811c573 (AutoBalancerService.idl) update comments for AutoBalancer idl
* fb155c6 (hrpsys_config.py, SequencePlayer) adds an input data port, zmpRefInit to SequencePlayer(by notheworld)
* 47677b7 (util/PortHandler.cpp) updates an error message
* 9417846 (315.1.10:sample/HRP4C/HRP4C.py) fix HRP4C.py: use `__main__` to call demo() and it also call initCORBA, see Issue 195
* d30a9f6 (315.1.10:sample/PA10/PA10.py) log is already started in activateComps()
* d09f1b9 (315.1.10:rtm.py) print error message when roonc is not defined in findRTCmanager and findObject, it also set hostname from set.gethostname if not defined in findRTCmanager(), see Issue #173
* d196165 (315.1.10:sample/PA10/PA10.py) use `__main__` to call demo() and it also call initCORBA, see Issue 195
* ed59880 (AutoBalancer) set current footstep pos and rot even if not ABC mode
* 6b84d09 (Range2PointCloud) supports unsymmetric scan angles
* 12ff024 (lib/util/PortHandler.cpp) sets RangerConfig
* 25df3dd (python/waitInput.py) executes waitInputMenuMain() in a thread
* 76f5762 (rtm.py) fixes a typo
* c0d8a92 (rtm.py) adds the second argument to load()
* d7b2646 (ImageData2CameraImage) initialize error_code
* b54cb47 (RangeDataViewer) adds a new component, RangeDataViewer
* 1e6360e (315.1.10:ProjectGenerator) do not pass non-openrtm arg to Manager::init(), see Issue #193
* de4b353 (415.1.10:ProjectGenerator) clean up debug message see Issue #193
* 03ec80d (lib/util/VectorConvert.h) adds operator>> for hrp::dvector and hrp::Vector3
* 77af006 (SequencePlayer/interpolator.cpp) enable user to change DEFAULT_AVG_VEL, see Issue 189 (interpolators[WRENCHES])
* 1859064 (SequencePlayerService.idl) add setWrenches, interpolate wrench in seq, see Issue 153
* 848bbfc (hrpsys_config.py) add function documents, many thanks to isaac
* e203012 (hrpsys_config.py) add to call setSelfGroups in init()
* 73f80e2 (hrpsys_config.py) move common code for real robots, see issue https://github.com/start-jsk/rtmros_common/issues/289
* 2182a35 (TorqueController) show error message every 100 loops
* 90a8bfc (hrpsys_config.py) do not raise error when component is not found in findComp
* 9fd098e (hrpsys_config.py) add findComps, see https://github.com/start-jsk/rtmros_common/issues/340
* ccf60e3 (hrpsys_config.py) fix wrong commit on r976/Issue #179
* bd4e92f (CMakeLists.txt) add more message when library is not found
* f966a06 (CMakeLists.txt) add message when library is not found
* 3feb6b3 (SequencePlayer) adds a misc. change
* 5741b9f (SequencePlayer) revert rpy loading according to discussion in https://code.google.com/p/hrpsys-base/source/detail?r=896 ;; load RPY from .hip file and load pos and RPY from .waist file
* 0a1ee15 (CaptureController) add a new component CaptureController
* 67b6b7d (hrpsys-base.pc.in) add idldir to hrpsys-base.pc.in
* 24bd8fa (FindOpenHRP.cmake) use OPENHRP_IDL_DIR for openhrp3 idl file location
* 87e91e5 (hrpsys_config.py) support  setTargetPose(self, gname, pos, rpy, tm, frame_name=None), fixed Issue 184
* 2936ce6 (ImpedanceController) more user friendly error message
* a386425 (rtm.py) fixes a problem in readDataPort() and adds an option, disconnect to writeDataPort
* 576a969 (rpy.py) More human friendly error message upon connection error, see Issue 183
* 6539ee3 (Range2PointCloud) supports multiple lines
* a585b54 (VideoCapture) fixes a bug in oneshot mode
* 9d6517f (rtm.py) add more user friendly error message
* a66c478 (CMakeLists.txt, rtc) set tag version to compoent profile version, see Issue 181
* 1a284f7 (Range2PointCloud) adds a port for sensor pose input
* 08a2dc1 (lib/util/PortHandler.cpp) sets angularRes in RangeData
* bff42b8 (ExtractCameraImage) add a new component, ExtractCameraImage
* 26dc4e4 (ImageData2CameraImage) add a component ImageData2TimedcameraImage
* f1f90d8 (sample/visionTest.py) installs visionTest.py
* d5c79c2 (VideoCapture) fixes a problem in oneshot mode
* 1446d24 (hrpsys_config.py) fix confusing variable names pos->angles, see Issue 179
* d6c56f8 (sample/visionTest.py)adds a sample script to use vision related RTCs
* 099bd22 (JpegDecoder) supports grayscale images
* d5e5096 (Img.idl) adds new image formats
* 520a3d4 (VideoCapture) added a service port for CameraCaptureService to VideoCapture component
* 2219c36 (ResizeImage) add a component ResizeImage(not tested yet)
* 58fe438 (RGB2Gray) added a component RGB2Gray
* 556d65c (JpegEncoder) added a component JpegEncoder
* c39d7a3 (VideoCapture) changes data type of outport depending on the number of cameras
* 7f9d2f5 (CameraImageViewer) corrects description
* 
* update to hrpsys version 315.2.0, remove patches
* use hrpsys_config.py according to https://github.com/start-jsk/hrpsys/pull/79 discussion ;; support latest autoablancer idl
* import imp package and roslib
* pass EXTRA RTC setting by string
* fix Makefile.hrpsys-base, git checkout $(GIT_REVISION) after git reset --hard
* use hrpsys_config.py for creating RTCs, connecting of ports, and activation
* (package.xml) Add version semantics clarification.
* use http://github.com/fkanehiro/hrpsys-base
* remove installed file if openhrp3_FOUND is not found
  Add auto balancer samples
* add sample code for auto balancer
* add AutoBalancer parameter to SampleRobot.conf.in
* add conf setting for StateHolder and AutoBalancer
* Merge pull request `#63 <https://github.com/start-jsk/hrpsys/issues/63>`_ from k-okada/315_1_10
  update to 315.1.10
  - ProjectGenerator : clean up debug message  (https://code.google.com/p/hrpsys-base/issues/detail?id=193)
  - PA10.py : call initCORBA() in `__main__`,log is already started in activateComps() so comment out setupLogger()  (https://code.google.com/p/hrpsys-base/issues/detail?id=195)
  - rtm.py : add debug messages if function called without initCORBA ()https://code.google.com/p/hrpsys-base/issues/detail?id=173
* qhull.patch only requres for arch package
* samples/{pa10,hrp4c,samplerobot}.launch: add sample programs
* test-pkg-config.py: add test code to check if file exists, test-joint-angle.py: add more test on setJointAngle
* move to 315.1.10
* Update README.md
* (test-hostname.py) add more debug message when test failed
* start_omninames.sh: fix typo
* add rosbash : temporarily until openrtm_aist_core provides rosbash
* `test-*.py`: use imp.find_module to check if we need to use roslib.load_manifest()
* (test-hostname.py): add more debug message when test failed
* add start_omninames.sh start omniNames for test code
* add Isaac to maintainer
* add python-tk to run_depend
* (CMakeLists.txt) fix conf file path for deb/rosbuild environment
* fix rosbuild compile option for working both deb/source
* add PKG_CONFIG_PATH for rosbuild environment
* (.travis.yml) add rosbuild/deb test
* Contributors: Isaac IY Saito, Kei Okada, Ryohei Ueda, Shunichi Nozawa

315.1.9 (2014-03-15)
--------------------
* "315.1.9"
* prepare for release 315.1.9
* Merge pull request `#53 <https://github.com/start-jsk/hrpsys/issues/53>`_ from k-okada/failed_to_compile_using_rosbuild_52
  - add test codes
  - merge `#39 <https://github.com/start-jsk/hrpsys/issues/39>`_
  - fix PKG_CONFIG_PATH before rostest
  - use load_manifest for rosbuild
* use load_manifest for rosbuild
* set PKG_CONFIG_PATH before rosmake test to find openhrp3.1.pc and hrpsys-base.pc
* use := instead of ?= because ?= does not work if PKG_CONFIG_PATH exists and openrtm.pc or openhrp3.pc are not included in PKG_CONFIG_PATH ;; I does not work groovy+rosbuild environment
* add test codes
* add rosbuild/roslang to depend
* rename manifest.xml for rosdep, see https://github.com/jsk-ros-pkg/jsk_common/issues/301
* add retry for test, see https://code.google.com/p/hrpsys-base/issues/detail?id=192 for the problem
* add groovy/catkin/deb
* fix openhrp3 path for deb environment
* (manifeset.xml) add restest to rosdep
* check rosdep until it succeeded
* fix print LastTest.log
* Add python patch for Arch
* Add Boost patch (remove -mt suffix).
* Fix qhull paths.
* (manifeset.xml) add restest to rosdep
* check rosdep until it succeeded
* check rosbuild/catkin deb/source with travis
* clean up test code for hrpsys (use findComps(), add DataLogger, test hrpsys_config.py, cleanup test name)
* start using 315.1.9, do not release until 315.1.9 is finally fixed
* added -l option as well as -j
* compile hrpsys in parallel, but it's up to 12 parallel jobs
* (hrpsys_config.py) wait (at most 10sec) if findComp found target component, check if  RobotHardware is active, see Issue #191
* (hrpsys_config.py) add max_timeout_count to findComps, if findComp could not find RTC  (for 10 seconds), successor RTC only check for 1 time
* Contributors: Benjamin Chrétien, Kei Okada, Ryohei Ueda, Shunichi Nozawa

315.1.8 (2014-03-06)
--------------------
* Do not pollute src directory, https://github.com/start-jsk/hrpsys/issues/3
* Utilize .travis.yml
* Initial commit of CHANGELOG.rst
* Contributors: Kei Okada, Atsushi Tsuda, Isaac Isao Saito, chen.jsk, Ryohei Ueda, Iori Kumagai, Manabu Saito, Takuya Nakaoka, Shunichi Nozawa, Yohei Kakiuchi
