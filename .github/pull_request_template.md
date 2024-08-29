### Pull Request checklist

#### All query authors

- [ ] Add a change note if necessary. See [the documentation](https://github.com/github/codeql/blob/main/docs/change-notes.md) in this repository.
- [ ] All new queries have appropriate `.qhelp`. See [the documentation](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md) in this repository.
- [ ] QL tests are added if necessary. See [Testing custom queries](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/testing-custom-queries) in the GitHub documentation.
- [ ] New and changed queries have correct query metadata. See [the documentation](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md) in this repository.

#### Internal query authors only

- [ ] If this PR makes significant changes to `.ql`, `.qll`, or `.qhelp` files, make sure that autofixes generated based on these changes are valid. See [the documentation](https://github.com/github/codeql-team/blob/main/docs/best-practices/validating-autofix-for-query-changes.md) (internal access required).
- [ ] Test your changes [at scale](https://github.com/github/codeql-dca/) (internal access required).
