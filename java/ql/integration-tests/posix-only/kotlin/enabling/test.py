from create_database_utils import *

for var in ['CODEQL_EXTRACTOR_JAVA_AGENT_ENABLE_KOTLIN',
            'CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN']:
    if var in os.environ:
        del(os.environ[var])

run_codeql_database_create(['"%s" build.py' % sys.executable], lang="java")

