import runs_on
import pytest
from query_suites import *

well_known_query_suites = ['csharp-code-quality.qls', 'csharp-code-quality-extended.qls', 'csharp-security-and-quality.qls', 'csharp-security-extended.qls', 'csharp-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, csharp, check_query_suite, query_suite):
    check_query_suite(query_suite)

@runs_on.posix
def test_not_included_queries(codeql, csharp, check_queries_not_included):
    check_queries_not_included('csharp', well_known_query_suites)
