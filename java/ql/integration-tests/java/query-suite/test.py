import os
import runs_on
import pytest

@runs_on.linux
@pytest.mark.parametrize("query_suite", ['java-code-quality.qls', 'java-security-and-quality.qls', 'java-security-extended.qls', 'java-code-scanning.qls'])
def test(codeql, java, cwd, expected_files, semmle_code_dir, query_suite):
        actual = codeql.resolve.queries(query_suite, _capture=True).strip()
        actual = sorted(actual.splitlines())
        actual = [os.path.relpath(q, semmle_code_dir) for q in actual]
        actual_file_name = query_suite + '.actual'
        expected_files.add(actual_file_name)
        (cwd / actual_file_name).write_text('\n'.join(actual)+'\n')
