## 0.4.5

No user-facing changes.

## 0.4.4

No user-facing changes.

## 0.4.3

### New Features

* The "Unpinned tag for a non-immutable Action in workflow" query (`actions/unpinned-tag`) now supports expanding the trusted action owner list using data extensions (`extensible: trustedActionsOwnerDataModel`). If you trust an Action publisher, you can include the owner name/organization in a model pack to add it to the allow list for this query. This addition will prevent security alerts when using unpinned tags for Actions published by that owner. For more information on creating a model pack, see [Creating a CodeQL Model Pack](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack).

## 0.4.2

### Bug Fixes

* Fixed data for vulnerable versions of `actions/download-artifact` and `rlespinasse/github-slug-action` (following GHSA-cxww-7g56-2vh6 and GHSA-6q4m-7476-932w).
* Improved `untrustedGhCommandDataModel` regex for `gh pr view` and Bash taint analysis in GitHub Actions.

## 0.4.1

No user-facing changes.

## 0.4.0

### New Features

* Initial public preview release
