## 0.4.37

### Minor Analysis Improvements

* The GitHub Actions analysis now recognizes more Bash regex checks that restrict a value to alphanumeric characters, include regexes like `^[0-9a-zA-Z]{40}([0-9a-zA-Z]{24})?$` which check for a sha1 or sha256 hash. This may reduce false positive results where command output is validated with grouped or optional alphanumeric patterns before being used.

## 0.4.36

### Minor Analysis Improvements

* Altered 2 patterns in the `poisonable_steps` modelling. Extra sinks are detected in the following cases: scripts executed via python modules and `go run` in directories are detected as potential mechanisms of injection. For the go execution pattern, the pattern is updated to now ignore flags that occur between go and the specific command. This change may lead to more results being detected by the following queries: `actions/untrusted-checkout/high`, `actions/untrusted-checkout/critical`, `actions/untrusted-checkout-toctou/high`, `actions/untrusted-checkout-toctou/critical`, `actions/cache-poisoning/poisonable-step`, `actions/cache-poisoning/direct-cache` and `actions/artifact-poisoning/path-traversal`.

## 0.4.35

No user-facing changes.

## 0.4.34

### Minor Analysis Improvements

* Removed false positive injection sink models for the `context` input of `docker/build-push-action` and the `allowed-endpoints` input of `step-security/harden-runner`.

## 0.4.33

No user-facing changes.

## 0.4.32

No user-facing changes.

## 0.4.31

No user-facing changes.

## 0.4.30

No user-facing changes.

## 0.4.29

No user-facing changes.

## 0.4.28

No user-facing changes.

## 0.4.27

### Bug Fixes

* Fixed a crash when analysing a `${{ ... }}` expression over around 300 characters in length.

## 0.4.26

### Major Analysis Improvements

* The query `actions/code-injection/medium` has been updated to include results which were incorrectly excluded while filtering out results that are reported by `actions/code-injection/critical`.

## 0.4.25

No user-facing changes.

## 0.4.24

No user-facing changes.

## 0.4.23

No user-facing changes.

## 0.4.22

No user-facing changes.

## 0.4.21

No user-facing changes.

## 0.4.20

No user-facing changes.

## 0.4.19

No user-facing changes.

## 0.4.18

No user-facing changes.

## 0.4.17

No user-facing changes.

## 0.4.16

No user-facing changes.

## 0.4.15

No user-facing changes.

## 0.4.14

No user-facing changes.

## 0.4.13

### Bug Fixes

* The `actions/artifact-poisoning/critical` and `actions/artifact-poisoning/medium` queries now exclude artifacts downloaded to `$[{ runner.temp }}` in addition to `/tmp`.

## 0.4.12

### Minor Analysis Improvements

* Fixed performance issues in the parsing of Bash scripts in workflow files,
  which led to out-of-disk errors when analysing certain workflow files with
  complex interpolations of shell commands or quoted strings.

## 0.4.11

No user-facing changes.

## 0.4.10

No user-facing changes.

## 0.4.9

No user-facing changes.

## 0.4.8

No user-facing changes.

## 0.4.7

### New Features

* CodeQL and Copilot Autofix support for GitHub Actions is now Generally Available.

## 0.4.6

### Bug Fixes

* The query `actions/code-injection/medium` now produces alerts for injection
  vulnerabilities on `pull_request` events.

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
