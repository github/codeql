#!/usr/bin/python

import platform
import re
import shutil
import subprocess
import sys

def is_windows():
    '''Whether we appear to be running on Windows'''
    if platform.system() == 'Windows':
        return True
    if platform.system().startswith('CYGWIN'):
        return True
    return False

def version_tuple_to_string(version):
    return f'{version[0]}.{version[1]}.{version[2]}{version[3]}'

def version_string_to_tuple(version):
    m = re.match(r'([0-9]+)\.([0-9]+)\.([0-9]+)(.*)', version)
    return tuple([int(m.group(i)) for i in range(1, 4)] + [m.group(4)])

# Version number used by CI.
ci_version = '1.8.10'

# Version numbers in the list need to be in semantically increasing order
many_versions = [ '1.4.32', '1.5.0', '1.5.10', '1.5.20', '1.5.30', '1.6.0', '1.6.20', '1.7.0', '1.7.20', '1.8.0' ]

many_versions_tuples = [version_string_to_tuple(v) for v in many_versions]

class KotlincNotFoundException(Exception):
    pass

def get_single_version(fakeVersionOutput = None):
    # kotlinc might be kotlinc.bat or kotlinc.cmd on Windows, so we use `which` to find out what it is
    kotlinc = shutil.which('kotlinc')
    if kotlinc is None:
        raise KotlincNotFoundException()
    versionOutput = subprocess.run([kotlinc, '-version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).stderr if fakeVersionOutput is None else fakeVersionOutput
    m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.[0-9]+-?[a-zA-Z]*) .*', versionOutput)
    if m is None:
        raise Exception('Cannot detect version of kotlinc (got ' + str(versionOutput) + ')')
    current_version = version_string_to_tuple(m.group(1))
    matching_minor_versions = [ version for version in many_versions_tuples if version[0:2] == current_version[0:2] ]
    if len(matching_minor_versions) == 0:
        raise Exception(f'Cannot find a matching minor version for kotlinc version {current_version} (got {versionOutput}; know about {str(many_versions)})')

    matching_minor_versions.sort(reverse = True)

    for version in matching_minor_versions:
        if version[0:3] <= current_version[0:3]:
            return version_tuple_to_string(version)

    return version_tuple_to_string(matching_minor_versions[-1])

    raise Exception(f'No suitable kotlinc version found for {current_version} (got {versionOutput}; know about {str(many_versions)})')

def get_latest_url():
    url = 'https://github.com/JetBrains/kotlin/releases/download/v' + ci_version + '/kotlin-compiler-' + ci_version + '.zip'
    return url

if __name__ == "__main__":
    args = sys.argv
    if len(args) < 2:
        raise Exception("Bad arguments")
    command = args[1]
    if command == 'latest-url':
        print(get_latest_url())
    elif command == 'single-version':
        print(get_single_version(*args[2:]))
    else:
        raise Exception("Unknown command: " + command)

