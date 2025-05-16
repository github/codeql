import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['python-code-quality.qls', 'python-security-and-quality.qls', 'python-security-extended.qls', 'python-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, python, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, python, check_queries_not_included):
    check_queries_not_included('python', well_known_query_suites)
