#!/bin/sh

#
# (c) Copyright 1999-2012 PaperCut Software International Pty Ltd
#
# A simple shell script to launch the client software on a Linux/Unix
# system.
#

#
# Make sure our current working dir is set to the location of this script
#
cd `dirname $0`

JAVACMD=

#
# Try to find a known good system Java installation.  We look for an Oracle, Sun
# or OpenJDK Java of version 1.6+.  Distros typically package these with a
# proper font configuration (looks good, includes CJK characters).  IBM Java on
# SuSE did not have a proper font configuration (as of 2012).
#
# Path to "java" binary is assigned to $JAVACMD if found.
#
find_preferred_system_java() {
	system_java_cmd=`which java 2>/dev/null`
	if [ ! -x "${system_java_cmd}" ]; then
		system_java_cmd=
	fi

	if [ -z "${system_java_cmd}" -a -n "${JAVA_HOME}" ]; then
		system_java_cmd="${JAVA_HOME}/bin/java"
		if [ ! -x "${system_java_cmd}" ]; then
			system_java_cmd=
		fi
	fi

	if [ -z "${system_java_cmd}" ]; then
		# Didn't find a system Java.
		return 1
	fi

	# Have system Java, check for Oracle/Sun/OpenJDK.
	if [ `${system_java_cmd} -version 2>&1 | grep -ci "oracle\|openjdk\|sun"` -eq 0 ]; then
		# Not a known Java.
		return 1
	fi

	# Have known system Java, check version is 1.6+.
	java_version=`"${system_java_cmd}" -version 2>&1 | head -1 | cut -d '"' -f2`
	if [ -z "${java_version}" ]; then
		# Couldn't detect system Java version.
		return 1
	fi

	java_version_major=`echo ${java_version} | cut -d '.' -f 1`
	case "${java_version_major}" in
		# couldn't detect major version
		''|*[!0-9]*) return 1 ;;
	esac

	java_version_minor=`echo ${java_version} | cut -d '.' -f 2`
	case "${java_version_minor}" in
		# couldn't detect minor version
		''|*[!0-9]*) return 1 ;;
	esac

	if [ ${java_version_major} -gt 1 ]; then
		: # Have Java >1, use it.
	elif [ ${java_version_minor} -ge 6 ]; then
		: # Have Java 1.6+, use it.
	else
		# Old/unknown Java, don't use it.
		return 1
	fi

	JAVACMD=${system_java_cmd}
	return 0
}

#
# Look for our bundled Java version, preferring 64-bit if available and
# supported by the architecture.  This does not have a distro-specific font
# configuration, so we prefer a system Java install if available.
#
# Path to "java" binary is assigned to $JAVACMD if found.
#
find_bundled_java() {
    system_arch=`uname -m 2>/dev/null`
	if [ "${system_arch}" = "x86_64" -a -x runtime/linux-x64/jre/bin/java ]; then
		JAVACMD=runtime/linux-x64/jre/bin/java
		return 0
	elif [ -x runtime/linux-i686/jre/bin/java ]; then
		JAVACMD=runtime/linux-i686/jre/bin/java
		return 0
	else
		return 1
	fi
}

#
# Look for any available system Java installation (fallback option).
#
# Path to "java" binary is assigned to $JAVACMD if found.
#
find_any_system_java() {
	system_java_cmd=`which java 2>/dev/null`
	if [ ! -x "${system_java_cmd}" ]; then
		system_java_cmd=
	fi

	if [ -z "${system_java_cmd}" -a -n "${JAVA_HOME}" ]; then
		system_java_cmd="${JAVA_HOME}/bin/java"
		if [ ! -x "${system_java_cmd}" ]; then
			system_java_cmd=
		fi
	fi

	if [ -z "${system_java_cmd}" ]; then
		# Didn't find a system Java.
		return 1
	fi

	JAVACMD=${system_java_cmd}
	return 0
}

find_preferred_system_java
if [ -z "${JAVACMD}" ]; then
	find_bundled_java
fi
if [ -z "${JAVACMD}" ]; then
	find_any_system_java
fi

if [ ! -x "${JAVACMD}" ]; then
	echo "Error: Could not find Java." 1>&2 
	echo "Please ensure Java 1.5 / 5.0 or higher is installed and java is on the path" 1>&2
	exit 1
fi

#
# Construct the classpath
#
if [ "X`echo -n`" = "X-n" ]; then
	echo_n() { echo ${1+"$@"}"\c"; }
else
	echo_n() { echo -n ${1+"$@"}; }
fi

#
# Construct our classpath.  The zip file(s) are used for custom messages.  We need to ensure
# these add to the classpath first so they take priority (if they exist).
#
classpath=`(ls lib-ext/client-custom-messages.zip 2>/dev/null; ls lib/*.jar) | while read line
do
	echo_n "${line}:"
done`

#
# Run the program
#
exec "${JAVACMD}" -classpath "${classpath}"  \
	-Dclient.home=. biz.papercut.pcng.client.uit.UserClient "$@"
