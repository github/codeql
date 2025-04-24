## 0.5.4

### Bug Fixes

* Alerts produced by the query `actions/missing-workflow-permissions` now include a minimal set of recommended permissions in the alert message, based on well-known actions seen within the workflow file.

## 0.5.3

### Bug Fixes

* Fixed typos in the query and alert titles for the queries
  `actions/envpath-injection/critical`, `actions/envpath-injection/medium`,
  `actions/envvar-injection/critical`, and `actions/envvar-injection/medium`.

## 0.5.2

No user-facing changes.

## 0.5.1

### Bug Fixes

* The `actions/unversioned-immutable-action` query will no longer report any alerts, since the
  Immutable Actions feature is not yet available for customer use. The query has also been moved
  to the experimental folder and will not be used in code scanning unless it is explicitly added
  to a code scanning configuration. Once the Immutable Actions feature is available, the query will
  be updated to report alerts again.

## 0.5.0

### Breaking Changes

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

### Minor Analysis Improvements

* Fixed false positives in the query `actions/unpinned-tag` (CWE-829), which will no longer flag uses of Docker-based GitHub actions pinned by the container's SHA256 digest.

## 0.4.2

No user-facing changes.

## 0.4.1

No user-facing changes.

## 0.4.0

### New Queries

* Initial public preview release
