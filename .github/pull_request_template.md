### Pull Request checklist

#### All query authors

- [ ] A change note is added if necessary. See [the documentation](https://github.com/github/codeql/blob/main/docs/change-notes.md) in this repository.
- [ ] All new queries have appropriate `.qhelp`. See [the documentation](https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md) in this repository.
- [ ] QL tests are added if necessary. See [Testing custom queries](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/testing-custom-queries) in the GitHub documentation.
- [ ] New and changed queries have correct query metadata. See [the documentation](https://github.com/github/codeql/blob/main/docs/query-metadata-style-guide.md) in this repository.

#### Internal query authors only

- [ ] Autofixes generated based on these changes are valid, only needed if this PR makes significant changes to `.ql`, `.qll`, or `.qhelp` files. See [the documentation](https://github.com/github/codeql-team/blob/main/docs/best-practices/validating-autofix-for-query-changes.md) (internal access required).
- [ ] Changes are validated [at scale](https://github.com/github/codeql-dca/) (internal access required).
- [ ] Adding a new query? Consider also [adding the query to autofix](https://github.com/github/codeml-autofix/blob/main/docs/updating-query-support.md#adding-a-new-query-to-the-query-suite).
