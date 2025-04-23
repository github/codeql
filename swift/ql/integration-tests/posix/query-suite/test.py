import runs_on
import pytest
import sys

def get_test_module(semmle_code_dir):
    import importlib.util
    spec = importlib.util.spec_from_file_location('test-module', semmle_code_dir / 'ql' / 'misc' / 'pytest' / 'lib' / 'query-suite-test.py')
    mod = importlib.util.module_from_spec(spec)
    sys.modules["test-module"] = mod
    spec.loader.exec_module(mod)
    return mod


well_known_query_suites = ['swift-code-quality.qls', 'swift-security-and-quality.qls', 'swift-security-extended.qls', 'swift-code-scanning.qls']

@runs_on.posix
@pytest.mark.parametrize("query_suite", well_known_query_suites)
def test(codeql, swift, cwd, expected_files, semmle_code_dir, query_suite):
    get_test_module(semmle_code_dir).test(codeql, cwd, expected_files, semmle_code_dir, query_suite)

@runs_on.posix
def test_not_included_queries(codeql, swift, cwd, expected_files, semmle_code_dir):
    get_test_module(semmle_code_dir).test_not_included_queries(codeql, 'swift', cwd, expected_files, semmle_code_dir, well_known_query_suites)
