GitHub stores CodeQL databases for over 200,000 repos on GitHub.com, which you can download using the REST API. The list of repos is constantly growing and evolving to make sure that it includes the most interesting codebases for security research.

You can check if a repository has any CodeQL databases available for download using the ``/repos/<owner>/<repo>/code-scanning/codeql/databases`` endpoint.
For example, to check for CodeQL databases using the `GitHub CLI <https://cli.github.com/manual/gh_api>`__ you would run::

   gh api /repos/<owner>/<repo>/code-scanning/codeql/databases

This command returns information about any CodeQL databases that are available for a repository, including the language the database represents, and when the database was last updated. If no CodeQL databases are available, the response is empty.

When you have confirmed that a CodeQL database exists for the language you are interested in, you can download it using the following command::

   gh api /repos/<owner>/<repo>/code-scanning/codeql/databases/<language> -H 'Accept: application/zip' > path/to/local/database.zip

For more information, see the documentation for the `Get CodeQL database <https://docs.github.com/en/rest/code-scanning#get-a-codeql-database-for-a-repository>`__ endpoint in the GitHub REST API documentation.
