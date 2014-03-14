^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package hrpsys
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

315.1.9 (2014-03-15)
--------------------
* (hrpsys_config.py) wait (at most 10sec) if findComp found target component, check if  RobotHardware is active, see Issue #191
* (hrpsys_config.py) add max_timeout_count to findComps, if findComp could not find RTC  (for 10 seconds), successor RTC only check for 1 time
* Contributors: Kei Okada, Ryohei Ueda, Shunichi Nozawa

315.1.8 (2014-03-06)
--------------------
* Do not pollute src directory, https://github.com/start-jsk/hrpsys/issues/3
* Utilize .travis.yml
* Initial commit of CHANGELOG.rst
* Contributors: Kei Okada, Atsushi Tsuda, Isaac Isao Saito, chen.jsk, Ryohei Ueda, Iori Kumagai, Manabu Saito, Takuya Nakaoka, Shunichi Nozawa, Yohei Kakiuchi
