import platform
import re
import subprocess
import sys

def is_windows():
    '''Whether we appear to be running on Windows'''
    if platform.system() == 'Windows':
        return True
    if platform.system().startswith('CYGWIN'):
        return True
    return False

many_versions = [ '1.4.32', '1.5.31', '1.6.10', '1.6.20' ]

def get_single_version():
    # TODO: `shell=True` is a workaround to get CI working on Windows. It breaks the build on Linux.
    versionOutput = subprocess.run(['kotlinc', '-version'], capture_output=True, text=True, shell=is_windows())
    m = re.match(r'.* kotlinc-jvm ([0-9]+)\.([0-9]+)\.([0-9]+) .*', versionOutput.stderr)
    if m is None:
        raise Exception('Cannot detect version of kotlinc (got ' + str(versionOutput) + ')')
    major = m.group(1)
    minor = m.group(2)
    patch = m.group(3)
    current_version = f'{major}.{minor}.{patch}'
    matching_minor_versions = [ version for version in many_versions if version.startswith(f'{major}.{minor}') ]
    if len(matching_minor_versions) == 0:
        raise Exception(f'Cannot find a matching minor version for kotlinc version {current_version} (got {versionOutput}; know about {str(many_versions)})')

    matching_minor_versions.sort()

    for version in matching_minor_versions:
        if current_version >= version:
            return version

    return matching_minor_versions[-1]

    raise Exception(f'No suitable kotlinc version found for {current_version} (got {versionOutput}; know about {str(many_versions)})')

def get_latest_url():
    version = many_versions[-1]
    url = 'https://github.com/JetBrains/kotlin/releases/download/v' + version + '/kotlin-compiler-' + version + '.zip'
    return url

if __name__ == "__main__":
    args = sys.argv
    if len(args) != 2:
        raise Exception("Bad arguments")
    command = args[1]
    if command == 'latest-url':
        print(get_latest_url())
    else:
        raise Exception("Unknown command: " + command)

