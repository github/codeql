import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['java-code-quality.qls', 'java-security-and-quality.qls', 'java-security-extended.qls', 'java-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, java, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, java, check_queries_not_included):
    check_queries_not_included('java', well_known_query_suites)
