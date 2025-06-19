import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['javascript-code-quality.qls', 'javascript-code-quality-extended.qls', 'javascript-security-and-quality.qls', 'javascript-security-extended.qls', 'javascript-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, javascript, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, javascript, check_queries_not_included):
    check_queries_not_included('javascript', well_known_query_suites)
