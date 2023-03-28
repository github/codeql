import sys

from create_database_utils import *

run_codeql_database_create(["mvn clean package -P tomcat8Jsp"], lang="java", extra_env = {"CODEQL_EXTRACTOR_JAVA_JSP": "true"})
