import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['ruby-code-quality.qls', 'ruby-security-and-quality.qls', 'ruby-security-extended.qls', 'ruby-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, ruby, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, ruby, check_queries_not_included):
    check_queries_not_included('ruby', well_known_query_suites)
