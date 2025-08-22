import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['cpp-code-quality.qls', 'cpp-code-quality-extended.qls', 'cpp-security-and-quality.qls', 'cpp-security-extended.qls', 'cpp-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, cpp, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, cpp, check_queries_not_included):
    check_queries_not_included('cpp', well_known_query_suites)
