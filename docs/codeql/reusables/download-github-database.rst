GitHub stores CodeQL databases for over 200,000 repos on GitHub.com, which you can download using the REST API. The list of repos is constantly growing and evolving to make sure that it includes the most interesting codebases for security research.

To download a database from GitHub.com using the `GitHub CLI <https://cli.github.com/manual/gh_api>`__, use the following command:: 

   gh api /repos/<owner>/<repo>/code-scanning/codeql/databases/<language> -H 'Accept: application/zip' > path/to/local/database.zip
