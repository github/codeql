#!/usr/bin/env python3

import glob
import re
from create_database_utils import *

# This is a normal intercepted compilation
runSuccessfully([get_cmd('kotlinc'), 'normal.kt'])

# Find the extractor jar that is being used
trapDir = os.environ['CODEQL_EXTRACTOR_JAVA_TRAP_DIR']
invocationTraps = glob.glob('invocations/*.trap', root_dir = trapDir)
if len(invocationTraps) != 1:
    raise Exception('Expected to find 1 invocation TRAP, but found ' + str(invocationTraps))
invocationTrap = trapDir + '/' + invocationTraps[0]
with open(invocationTrap, 'r') as f:
    content = f.read()
    m = re.search('^// Using extractor: (.*)$', content, flags = re.MULTILINE)
    extractorJar = m.group(1)

def getManualFlags(invocationTrapName):
    return ['-Xplugin=' + extractorJar, '-P', 'plugin:kotlin-extractor:invocationTrapFile=' + trapDir + '/invocations/' + invocationTrapName + '.trap']

# This is both normally intercepted, and it has the extractor flags manually added
runSuccessfully([get_cmd('kotlinc'), 'doubleIntercepted.kt'] + getManualFlags('doubleIntercepted'))
os.environ['CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN'] = 'true'
# We don't see this compilation at all
runSuccessfully([get_cmd('kotlinc'), 'notSeen.kt'])
# This is extracted as it has the extractor flags manually added
runSuccessfully([get_cmd('kotlinc'), 'manual.kt'] + getManualFlags('manual'))
