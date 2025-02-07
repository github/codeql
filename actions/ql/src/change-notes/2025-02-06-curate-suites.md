---
category: breaking
---
* The following queries have been removed from the `code-scanning` and `security-extended` suites.
  Any existing alerts for these queries will be closed automatically.
  * `actions/if-expression-always-true/critical`
  * `actions/if-expression-always-true/high`
  * `actions/unnecessary-use-of-advanced-config`
  
* The following query has been moved from the `code-scanning` suite to the `security-extended`
  suite. Any existing alerts for this query will be closed automatically unless the analysis is
  configured to use the `security-extended` suite.
  * `actions/unpinned-tag`
* The following queries have been added to the `security-extended` suite.
  * `actions/unversioned-immutable-action`
  * `actions/envpath-injection/medium`
  * `actions/envvar-injection/medium`
  * `actions/code-injection/medium`
  * `actions/artifact-poisoning/medium`
  * `actions/untrusted-checkout/medium`
