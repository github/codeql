def test(codeql, java, check_diagnostics):
    codeql.database.create(_assert_failure=True)
    # Drop the specific output line here because it varies from version to version of Maven.
    check_diagnostics.replacements = [('Relevant output line: [^"]*', "")]
