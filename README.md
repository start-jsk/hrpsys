Introduction  [![Build Status](https://travis-ci.org/start-jsk/hrpsys.png)](https://travis-ci.org/start-jsk/hrpsys)
--------------------------------------------------------------------------------------------------------------------------

An OpenRTM-aist-based robot controller. This package is the most tailored for humanoid (dual-arm and/or biped) robots for historical reason.

Test Status
================
[Hydro](http://jenkins.ros.org/job/devel-hydro-hrpsys/) [![Build Status](http://jenkins.ros.org/job/devel-hydro-hrpsys/badge/icon)](http://jenkins.ros.org/job/devel-hydro-hrpsys/)

[![Hydro Test Satus](http://jenkins.ros.org/job/devel-hydro-hrpsys/test/trend)](http://jenkins.ros.org/job/devel-hydro-hrpsys/)

[Groovy](http://jenkins.ros.org/job/devel-groovy-hrpsys/) [![Build Status](http://jenkins.ros.org/job/devel-groovy-hrpsys/badge/icon)](http://jenkins.ros.org/job/devel-groovy-hrpsys/)

[![Groovy Test Satus](http://jenkins.ros.org/job/devel-groovy-hrpsys/test/trend)](http://jenkins.ros.org/job/devel-groovy-hrpsys/)

For developers
===============

How to release new version
---------------------------

As a 3rd party package to ROS we need some extra chores to release. Discussed `here <https://github.com/start-jsk/hrpsys/pull/99#issuecomment-49831482>`_. NOTE for 2 different repositories are involved:

 * `Upstream source repository (fkanehiro/hrpsys-base) <https://github.com/fkanehiro/hrpsys-base/issues>`_
 * `ROS repository (start-jsk/hrpsys) <https://github.com/start-jsk/hrpsys/blob/master/CHANGELOG.rst>`_

Steps:

 1. Send a pull request to `fkanehiro/hrpsys-base <https://github.com/fkanehiro/hrpsys-base/issues>`_ to update a tag in `CMakeLists.txt <https://github.com/fkanehiro/hrpsys-base/blob/master/CMakeLists.txt>`_. `Example <https://github.com/fkanehiro/hrpsys-base/pull/231>`_. This way community will decide if we're ready for the next release.
 2. Send a pull request to update `start-jsk/hrpsys/Makefile.hrpsys-base <https://github.com/start-jsk/hrpsys/blob/master/Makefile.hrpsys-base>`_. `Example2 <https://github.com/start-jsk/hrpsys/pull/88/files>`_.
 3. Send a pull request to update `start-jsk/hrpsys/changelog.rst <https://github.com/start-jsk/hrpsys/blob/master/changelog.rst>`_.

  3-1. Use this script [generate_changelog_upstream_] to copy commit messages from upstream `fkanehiro/hrpsys-base`. A file should be created under `/tmp`.

  3-2. Summarize commit messages into user-meaningful content (`discussion <https://github.com/start-jsk/hrpsys/pull/99#issuecomment-49596002>`_). 

  3-3. To include updates in `ROS repository (start-jsk/hrpsys) <https://github.com/start-jsk/hrpsys/blob/master/CHANGELOG.rst>`_, add change logs into the one created in 3-2 by following.

     3-3-1. Generate changelog by a command from `catkin`:

     ::

       $ roscd hrpsys
       $ catkin_generate_changelog

     3-3-2. Open a generated/updated `CHANGELOG.rst` file. Then manually merge with the artifact from 3-1.

 4. After here follow the normal release manner: Update tags and `package.xml` by using `catkin_prepare_release`.

Notice that we're sending pull requests to two different repositories; one is the source upstream repository that isn't ROS-dependent, another repository is used to release a DEB using ROS infrastructure.

.. _generate_changelog_upstream:

Generate changelog from the upstream
-------------------------------------

`hrpsys` distributed in ROS ecosystem consists of resources from two repositories as package.xml[1_]. Particularly we need to generate changelog from the upstream[2_], which is not covered by ROS' convenient tool `catkin_generate_changelog` (that only takes care of the catkin packages, like `start-jsk/hrpsys` (where you are now)). Here our custom script `create_changelog.sh <https://github.com/start-jsk/hrpsys/blob/master/create_changelog.sh>`_ helps you. To use is it.

1. Clone this repository into your catkin workspace if you haven't done so:

::

  $ cd %CATKIN_WORKSPACE% && cd src
  $ git clone https://github.com/start-jsk/hrpsys.git

2. Run `catkin_make`.

::

  $ cd %CATKIN_WORKSPACE%
  $ catkin_make     (this takes minutes depending on your machine power and internet connection)
  $ source devel/setup.bash

3. Run the command `create_changelog.sh`:

::

  $ rosrun hrpsys create_changelog.sh


.. _1: https://github.com/start-jsk/hrpsys/blob/master/package.xml
.. _2: https://github.com/fkanehiro/hrpsys-base
