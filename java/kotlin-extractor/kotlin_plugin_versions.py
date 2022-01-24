import re
import subprocess

many_versions = [ '1.4.32', '1.5.31', '1.6.10' ]

def get_single_version():
    versionOutput = subprocess.run(['kotlinc', '-version'], capture_output=True, text=True)
    m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.)[0-9]+ .*', versionOutput.stderr)
    if m is None:
        raise Exception('Cannot detect version of kotlinc')
    prefix = m.group(1)
    for version in many_versions:
        if version.startswith(prefix):
            return version
    raise Exception('No suitable kotlinc version found for ' + prefix)
