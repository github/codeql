import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['actions-code-quality.qls', 'actions-code-quality-extended.qls', 'actions-security-and-quality.qls', 'actions-security-extended.qls', 'actions-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, actions, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, actions, check_queries_not_included):
    check_queries_not_included('actions', well_known_query_suites)
