#!/usr/bin/python

from create_database_utils import *

# Make a source file to keep codeql happy
srcDir = os.environ['CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR']
srcFile = srcDir + '/Source.java'
os.makedirs(srcDir)
with open(srcFile, 'w') as f:
    pass

for t in ['Test1', 'sun.something.Test2']:
    print('Test ' + t + ' started.')
    sys.stdout.flush()
    runSuccessfully(['java', t])
    print('Test ' + t + ' ended.')
    sys.stdout.flush()

