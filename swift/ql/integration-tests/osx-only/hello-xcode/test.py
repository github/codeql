from create_database_utils import *

run_codeql_database_create([
    'xcodebuild clean',
    'xcodebuild build '
    '-project codeql-swift-autobuild-test.xcodeproj '
    '-target codeql-swift-autobuild-test '
    'CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO',
], lang='swift', keep_trap=True)
