from create_database_utils import *

runSuccessfully(['xcodebuild', 'clean'])
runSuccessfully(['swift', 'package', 'clean'])
run_codeql_database_create([], lang='swift', keep_trap=True)
