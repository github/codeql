import platform
import re
import subprocess

def is_windows():
    '''Whether we appear to be running on Windows'''
    if platform.system() == 'Windows':
        return True
    if platform.system().startswith('CYGWIN'):
        return True
    return False

many_versions = [ '1.4.32', '1.5.31', '1.6.10' ]

def get_single_version():
    # TODO: `shell=True` is a workaround to get CI working on Windows. It break the build on Linux.
    versionOutput = subprocess.run(['kotlinc', '-version'], capture_output=True, text=True, shell=is_windows())
    m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.)[0-9]+ .*', versionOutput.stderr)
    if m is None:
        raise Exception('Cannot detect version of kotlinc (got ' + str(versionOutput) + ')')
    prefix = m.group(1)
    for version in many_versions:
        if version.startswith(prefix):
            return version
    raise Exception('No suitable kotlinc version found for ' + prefix + ' (got ' + str(versionOutput) + '; know about ' + str(many_versions) + ')')
