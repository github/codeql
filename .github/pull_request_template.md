### Pull Request checklist

- [ ] Add a change note if necessary. See [the documentation](https://github.com/github/codeql/blob/main/docs/change-notes.md).
- [ ] If this PR makes significant changes to `.ql`, `.qll`, or `.qhelp` files, make sure that autofixes generated based on these changes are valid. See [the documentation](https://github.com/github/codeql-team/blob/main/docs/best-practices/validating-autofix-for-query-changes.md) (internal access required).
- [ ] All new queries has appropriate `.qhelp`.
- [ ] QL tests are added if necessary.
- [ ] Test your changes in [DCA](https://github.com/github/codeql-dca/) (internal access required).
