import runs_on

@runs_on.linux
def test(codeql, java, cwd, expected_files, semmle_code_dir):
    query_suites = ['java-code-quality.qls', 'java-security-and-quality.qls', 'java-security-extended.qls', 'java-code-scanning.qls']

    for query_suite in query_suites:
        actual = codeql.resolve.queries(query_suite, _capture=True).strip()
        actual = sorted(actual.split('\n'))
        print(semmle_code_dir)
        index = len(str(semmle_code_dir))
        actual = [line[index:] for line in actual]
        actual_file_name = query_suite + '.actual'
        expected_files.add(actual_file_name)
        (cwd / actual_file_name).write_text('\n'.join(actual)+'\n')
