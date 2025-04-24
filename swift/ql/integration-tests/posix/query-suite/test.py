import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['swift-code-quality.qls', 'swift-security-and-quality.qls', 'swift-security-extended.qls', 'swift-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, swift, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, swift, check_queries_not_included):
    check_queries_not_included('swift', well_known_query_suites)
