---
category: queryMetadata
---
* The following queries have been removed from the `code-scanning` and `security-extended` suites:
  * `actions/if-expression-always-true/critical`
  * `actions/if-expression-always-true/high`
  * `actions/unnecessary-use-of-advanced-config`
* The following queries have been moved from the `code-scanning` suite to the `security-extended`
  suite:
  * `actions/unpinned-tag`
* The following queries have been added to the `security-extended` suite:
  * `actions/unversioned-immutable-action`
  * `actions/envpath-injection/medium`
  * `actions/envvar-injection/medium`
  * `actions/code-injection/medium`
  * `actions/artifact-poisoning/medium`
  * `actions/untrusted-checkout/medium`
