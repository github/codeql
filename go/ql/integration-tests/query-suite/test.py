import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['go-code-quality.qls', 'go-security-and-quality.qls', 'go-security-extended.qls', 'go-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, go, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, go, check_queries_not_included):
    check_queries_not_included('go', well_known_query_suites)
