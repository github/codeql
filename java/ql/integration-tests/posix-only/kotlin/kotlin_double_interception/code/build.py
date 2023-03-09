#!/usr/bin/env python3

import glob
import os
import re
from create_database_utils import *

def say(s):
    print(s)
    sys.stdout.flush()

say('Doing normal compilation')
# This is a normal intercepted compilation
runSuccessfully([get_cmd('kotlinc'), 'normal.kt'])

say('Identifying extractor jar')
# Find the extractor jar that is being used
trapDir = os.environ['CODEQL_EXTRACTOR_JAVA_TRAP_DIR']
invocationTrapDir = os.path.join(trapDir, 'invocations')
invocationTraps = os.listdir(invocationTrapDir)
if len(invocationTraps) != 1:
    raise Exception('Expected to find 1 invocation TRAP, but found ' + str(invocationTraps))
invocationTrap = os.path.join(invocationTrapDir, invocationTraps[0])
with open(invocationTrap, 'r') as f:
    content = f.read()
    m = re.search('^// Using extractor: (.*)$', content, flags = re.MULTILINE)
    extractorJar = m.group(1)

def getManualFlags(invocationTrapName):
    return ['-Xplugin=' + extractorJar, '-P', 'plugin:kotlin-extractor:invocationTrapFile=' + os.path.join(trapDir, 'invocations', invocationTrapName + '.trap')]

# This is both normally intercepted, and it has the extractor flags manually added
say('Doing double-interception compilation')
runSuccessfully([get_cmd('kotlinc'), 'doubleIntercepted.kt'] + getManualFlags('doubleIntercepted'))
os.environ['CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN'] = 'true'
# We don't see this compilation at all
say('Doing unseen compilation')
runSuccessfully([get_cmd('kotlinc'), 'notSeen.kt'])
# This is extracted as it has the extractor flags manually added
say('Doing manual compilation')
runSuccessfully([get_cmd('kotlinc'), 'manual.kt'] + getManualFlags('manual'))
