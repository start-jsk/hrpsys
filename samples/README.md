========================================================================================================================
Examples
========================================================================================================================

This directory is for hrpsys examples.  
These examples import [hrpsys-base/samples/SampleRobot](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot).  
To learn more about API, please see [API DOC in hrpsys-base](http://fkanehiro.github.io/hrpsys-base/).

# samplerobot-walk.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-walk.py
 ```
 This example imports 
 [hrpsys-base samplerobot_walk.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_walk.py.in).

# samplerobot-data-logger.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-data-logger.py
 ```
 This example imports 
 [hrpsys-base samplerobot_data_logger.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_data_logger.py.in).  
3. RTC explanation 
 - DataLogger  
 DataLogger is hrpsys-base RTC for data logging of hrpsys-base RTCs.  
 - Data structure  
 DataLogger has a ring buffer for data. DataLogger stores data to the ring buffer in onExecute function. Users can change ring buffer length through ``maxLength()`` function.  
 - Configure logging data  
 Stored data should be data ports. By using ``add()`` function, DataLogger create a data port. After this, by connecting the new DataLogger's data port and the data port which users want to store, DataLogger starts to store data. 
 These are written in 
 [hrpsys-base hrpsys_config.py's setupLogger function](https://github.com/fkanehiro/hrpsys-base/blob/master/python/hrpsys_config.py).
 - Save log  
 By using ``save()`` function, DataLogger saves data ports values in a ring buffer into several files. If data ports are connected by ``connectLoggerPort`` in [hrpsys-base hrpsys_config.py](https://github.com/fkanehiro/hrpsys-base/blob/master/python/hrpsys_config.py), file extensions are determined by RTC names and data port names.  
 In the above example, files are saved as ``/tmp/test-samplerobot-log.**``. 
 The log file for StateHolder RTC's ``qOut`` data port is written as ``/tmp/test-samplerobot-log.sh_qOut``. 
 ``sh`` is the comonent name for StateHolder, which is specified in
 [hrpsys-base hrpsys_config.py's getRTCList function](https://github.com/fkanehiro/hrpsys-base/blob/master/python/hrpsys_config.py). 


# samplerobot-remove-force-offset.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-remove-force-offset.py
 ```
 This example imports 
 [hrpsys-base samplerobot_remove_force_offset.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_remove_force_offset.py.in).  
3. RTC explanation  
 - RemoveForceSensorLinkOffset  
 RemoveForceSensorLinkOffset is hrpsys-base RTC to remove hands or feet from force sensor values.  
 - Original wrench  
 Original wrench are provided by RobotHadware RTC or hrpsys-simulator's RTC, which is SampleRobot(Robot)0.rtc in the above example. 
 Original wrench should be wrench data ports named as sensor names. 
 In the above example, ``rhsensor``, ``rfsensor``, ``lhsensor``, and ``lfsensor`` are determined, 
 which correspond to right hand sensor, right foot sensor, left hand sensor, and left foot sensor. 
 - Feature of original wrench  
 Original wrench is influenced by the weight of hands and feet of a robot. 
 - Feature of RemoveForceSensorLinkOffset RTC
 RemoveForceSensorLinkOffset removes the link's weight offset from force and moment. 
 Out data ports are automatically generated according to input original wrench data ports. 
 In the above example, ``off_rhsensor``, ``off_rfsensor``, ``off_lhsensor``, and ``off_lfsensor`` are generated according to 
 ``rhsensor``, ``rfsensor``, ``lhsensor``, and ``lfsensor``.  
 Offsetting values are zero by default, e.g., ``off_rhsensor`` equals to ``rhsensor`` by default. 
 - Offsetting  
 In the above example, the initial wrench values are larger than zero:

    ```
    # 1. force and moment are large because of link offsets
    fm=numpy.linalg.norm(rtm.readDataPort(hcf.rmfo.port("off_rhsensor")).data)
    print "no-offset-removed force moment (rhsensor) ", fm, "=> ", fm > 1e-2
    fm=numpy.linalg.norm(rtm.readDataPort(hcf.rmfo.port("off_lhsensor")).data)
    print "no-offset-removed force moment (lhsensor) ", fm, "=> ", fm > 1e-2
    ```
 This is because these values include hand link weight force and weight moment.  
 After offsetting by ``setForceMomentOffsetParam()`` function, 
 wrench values become almost zero:

    ```
    # 3. force and moment are reduced
    fm=numpy.linalg.norm(rtm.readDataPort(hcf.rmfo.port("off_rhsensor")).data)
    print "no-offset-removed force moment (rhsensor) ", fm, "=> ", fm < 1e-2
    fm=numpy.linalg.norm(rtm.readDataPort(hcf.rmfo.port("off_lhsensor")).data)
    print "no-offset-removed force moment (lhsensor) ", fm, "=> ", fm < 1e-2
    ```

# samplerobot-impedance-controller.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-impedance-controller.py
 ```
 This example imports 
 [hrpsys-base samplerobot_impedance_controller.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_impedance_controller.py.in).  
3. RTC explanation  
 - ImpedanceController  
 ImpedanceController is hrpsys-base RTC for cartesian impedance control.  
 - Cartesian impedance control  
 ImpedanceController RTC controls cartesian impedance. 
 This means, ImpedanceController modifies end-effector's position or orientation based on force or moments.  
 In ``onExecute``, ImpedanceController receives reference joint angles from InPort ``qRef`` and wrench values. 
 After this, it calculates reference end-effector position and orientation and 
 modifies end-effector's position or orientation based on force or moments. 
 It solves Inverse Kinematics based on modified end-effector position and orientation,
 obtains jonint angles, and outputs the joint angles as OutPort ``q``. 
 - Mode  
 ImpedanceController has modes by JointGroup such as ``rarm`` and ``rleg``. 
 By default, ImpedanceController is idle mode, in which it do not modify joint angles. 
 When ``setImpedanceControllerParam()`` are called in idle mode,  it switches to 
 controlling mode, in which it modifies joint angles. 
 When ``deleteImpedanceController()`` are called in controlling mode, 
 it switches to idle mode. 
 
# samplerobot-auto-balancer.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-auto-balancer.py
 ```
 This example imports 
 [hrpsys-base samplerobot_auto_balancer.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_auto_balancer.py.in).  
3. RTC explanation  
 - AutoBalancer  
 AutoBalancer is hrpsys-base RTC to generate walking pattern and control Center Of Gravity for legged robots.  
 - Feature  
 AutoBalancer RTC has two feature: Center Of Gravity (COG) control and walking pattern generation. 
 - COG control
 AutoBalancer modifies joint angles to track reference COG position.  
 In ``onExecute``, AutoBalancer receives reference joint angles from InPort ``qRef``. 
 After this, it solves Inverse Kinematics (or something) to track reference COG position, 
 obtains jonint angles, and outputs the joint angles as OutPort ``q``.  
 In this calculation, AutoBalancer tracks reference XY COG position,
 reference Z base position, and reference base orientation.  
 In the above example, these values are tracked:

    ```
    #   5. change base height, base rot x, base rot y, and upper body while AutoBalancer mode
    hcf.abc_svc.startAutoBalancer(["rleg", "lleg"]);
    testPoseList(pose_list, initial_pose)
    hcf.abc_svc.stopAutoBalancer();
    ```

 - Mode  
 AutoBalancer has modes. 
 By default, AutoBalancer is idle mode (``MODE_IDLE``), in which it do not modify joint angles. 
 When ``startAutoBalancer()`` are called in IDLE mode,  it switches to 
 controlling mode (``MODE_ABC``), in which it modifies joint angles. 
 When ``stopAutoBalancer()`` are called in controlling mode, it switches to idle mode. 
 - Controlled end-effectors  
 User can specify which end-effector is controlled.
 In the above example, when ``startAutoBalancer(["rleg", "lleg"])`` are called,
 it controlles reference end-effector 
 position and orientation for "rleg" and "lleg".
 When ``startAutoBalancer(["rleg", "lleg", "rarm", "larm"])`` are called, 
 it controlles reference end-effector for "rleg", "lleg", "rarm", "larm". 
 In this case, the robot seems to keep both feet and hands position and orientation. 
 - Walking pattern generation  
 AutoBalancer RTC has also the feature as walking pattern generation, named as GaitGenerator. 
 When ``goPos()``, ``goVelocity()``, ``setFootSteps()`` are called, 
 AutoBalancer starts to use reference XY COG position from GaitGenerator. 
 For ``goPos()`` and ``setFootSteps()``, 
 AutoBalancer stops to use it after completing walking command. 
 After ``goVelocity()`` is called, AutoBalancer continuously generates walking pattern. 
 When ``goStop()`` are called in this case, 
 AutoBalancer stops to use it after completing walking command.

# samplerobot-stabilizer.py
1. Launch hrpsys-simulator

 ```
rtmlaunch hrpsys samplerobot.launch
 ```
2. python example

 ```
rosrun hrpsys samplerobot-stabilizer.py
 ```
 This example imports 
 [hrpsys-base samplerobot_stabilizer.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_stabilizer.py.in).  
3. RTC explanation  
 - Stabilizer  
 Stabilizer is hrpsys-base RTC to maintain full-body balance based on sensor feedback.  
 - Feature  
 Stabilizer modifies joint angles to control COG, ZMP, and so on. 
 In ``onExecute``, Stabilizer receives reference joint angles from InPort ``qRef``. 
 After this, it solves Inverse Kinematics (or something) based on sensor feedback,
 obtains jonint angles, and outputs the joint angles as OutPort ``q``.  
 - Mode  
 Stabilizer has modes. 
 By default, Stabilizer is idle mode (``MODE_IDLE``), in which it do not modify joint angles. 
 When ``startStabilizer()`` are called in IDLE mode,  it switches to 
 controlling mode (``MODE_ST``), in which it modifies joint angles. 
 When ``stopStabilizer()`` are called in controlling mode, it switches to idle mode. 
 When the robot is put off to the air, it switches to idle mode (``MODE_IDLE``). 
 When the robot is put on the ground and the original mode are controlling mode (``MODE_ST``),
 it switches to controlling mode (``MODE_ST``). 

# samplerobot-terrain-walk.py
1. Example for slope walking  
 1-1. Launch hrpsys-simulator
 ```
rtmlaunch hrpsys samplerobot.launch CONTROLLER_PERIOD:=200 PROJECT_FILE:=`rospack find hrpsys`/share/hrpsys/samples/SampleRobot/SampleRobot.TerrainFloor.SlopeUpDown.xml
 ```
 1-2. python example
 ```
rosrun hrpsys samplerobot-terrain-walk.py --SlopeUpDown
 ```
 This example imports 
 [hrpsys-base samplerobot_terrain_walk.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_terrain_walk.py.in).

2. Example for stair climbing-up  
 2-1. Launch hrpsys-simulator
 ```
rtmlaunch hrpsys samplerobot.launch CONTROLLER_PERIOD:=200 PROJECT_FILE:=`rospack find hrpsys`/share/hrpsys/samples/SampleRobot/SampleRobot.TerrainFloor.StairUp.xml
 ```
 2-2. python example
 ```
rosrun hrpsys samplerobot-terrain-walk.py --StairUp
 ```
 This example imports 
 [hrpsys-base samplerobot_terrain_walk.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_terrain_walk.py.in).

3. Example for stair climbing-down  
 3-1. Launch hrpsys-simulator
 ```
rtmlaunch hrpsys samplerobot.launch CONTROLLER_PERIOD:=200 PROJECT_FILE:=`rospack find hrpsys`/share/hrpsys/samples/SampleRobot/SampleRobot.TerrainFloor.StairDown.xml
 ```
 2-2. python example
 ```
rosrun hrpsys samplerobot-terrain-walk.py --StairDown
 ```
 This example imports 
 [hrpsys-base samplerobot_terrain_walk.py](https://github.com/fkanehiro/hrpsys-base/blob/master/sample/SampleRobot/samplerobot_terrain_walk.py.in).
