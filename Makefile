EXTRA_CMAKE_FLAGS = -DUSE_ROSBUILD:BOOL=1
include $(shell rospack find mk)/cmake.mk

##
## hrpsys-base (http://hrpsys-base.googlecode.com/svn/trunk/)
## revision newer than 83 is required
##
CPU_NUM=$(shell grep -c processor /proc/cpuinfo)
PARALLEL_JOB=$(shell if `expr $(CPU_NUM) \> 12 > /dev/null`;then echo 12; else echo ${CPU_NUM}; fi)
wipe: clean
	# make -f Makefile.hrpsys-base wipe
	rm -fr build share patched
	touch wiped

clean: Makefile.hrpsys-base
	make -f Makefile.hrpsys-base clean
	-rm -fr installed include bin lib idl idl_gen msg msg_gen srv srv_gen src_gen

download:
	make -f Makefile.hrpsys-base download -j${PARALLEL_JOB}
