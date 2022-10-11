#!/usr/bin/env python3

from create_database_utils import *

runSuccessfully(["kotlinc", "KotlinDefault.kt"])
os.environ['CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN'] = 'true'
runSuccessfully(["kotlinc", "KotlinDisabled.kt"])
del(os.environ['CODEQL_EXTRACTOR_JAVA_AGENT_DISABLE_KOTLIN'])
os.environ['CODEQL_EXTRACTOR_JAVA_AGENT_ENABLE_KOTLIN'] = 'true'
runSuccessfully(["kotlinc", "KotlinEnabled.kt"])
