import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['rust-code-quality.qls', 'rust-security-and-quality.qls', 'rust-security-extended.qls', 'rust-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, rust, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, rust, check_queries_not_included):
    check_queries_not_included('rust', well_known_query_suites)
