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

class Version:
    def __init__(self, major, minor, patch, tag):
        self.major = major
        self.minor = minor
        self.patch = patch
        self.tag = tag

    def toTupleWithTag(self):
        return [self.major, self.minor, self.patch, self.tag]

    def toTupleNoTag(self):
        return [self.major, self.minor, self.patch]

    def lessThan(self, other):
        return self.toTupleNoTag() < other.toTupleNoTag()

    def lessThanOrEqual(self, other):
        return self.toTupleNoTag() <= other.toTupleNoTag()

    def toString(self):
        return f'{self.major}.{self.minor}.{self.patch}{self.tag}'

    def toLanguageVersionString(self):
        return f'{self.major}.{self.minor}'

def version_string_to_version(version):
    m = re.match(r'([0-9]+)\.([0-9]+)\.([0-9]+)(.*)', version)
    return Version(int(m.group(1)), int(m.group(2)), int(m.group(3)), m.group(4))

# Version number used by CI.
ci_version = '1.9.0'

many_versions = [ '1.5.0', '1.5.10', '1.5.20', '1.5.30', '1.6.0', '1.6.20', '1.7.0', '1.7.20', '1.8.0', '1.9.0-Beta', '1.9.20-Beta', '2.0.0-Beta1' ]

many_versions_versions = [version_string_to_version(v) for v in many_versions]
many_versions_versions_asc  = sorted(many_versions_versions, key = lambda v: v.toTupleWithTag())
many_versions_versions_desc = reversed(many_versions_versions_asc)

class KotlincNotFoundException(Exception):
    pass

def get_single_version(fakeVersionOutput = None):
    # kotlinc might be kotlinc.bat or kotlinc.cmd on Windows, so we use `which` to find out what it is
    kotlinc = shutil.which('kotlinc')
    if kotlinc is None:
        raise KotlincNotFoundException()
    versionOutput = subprocess.run([kotlinc, '-version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True).stderr if fakeVersionOutput is None else fakeVersionOutput
    m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z][a-zA-Z0-9]*)?) .*', versionOutput)
    if m is None:
        raise Exception('Cannot detect version of kotlinc (got ' + str(versionOutput) + ')')
    current_version = version_string_to_version(m.group(1))

    for version in many_versions_versions_desc:
        if version.lessThanOrEqual(current_version):
            return version.toString()

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

