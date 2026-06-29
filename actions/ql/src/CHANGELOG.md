## 0.6.30

### Query Metadata Changes

* The name, description, and alert message of `actions/untrusted-checkout/medium` have been corrected to describe a non-privileged context.

## 0.6.29

### Query Metadata Changes

* Reversed adjustment of the name of `actions/untrusted-checkout/high`, but kept the portion of the previous change for the word "trusted" to "privileged". Added a missing "a" to phrasing in `actions/untrusted-checkout/high` and `actions/untrusted-checkout/medium`.

### Major Analysis Improvements

* Adjusted `actions/untrusted-checkout/critical` to align more with other untrusted resource queries, where the alert location is the location where the artifact is obtained from (the checkout point). This aligns with the other 2 related queries. This will cause the same alerts to re-open for closed alerts of this query.

### Minor Analysis Improvements

* Altered the alert message for clarity for queries: `actions/untrusted-checkout/critical`, `actions/untrusted-checkout/high`.
* The `actions/unpinned-tag` query now recognizes 64-character SHA-256 commit hashes as properly pinned references, in addition to 40-character SHA-1 hashes.

### Bug Fixes

* Adjusted (minor) help file descriptions for queries: `actions/untrusted-checkout/critical`, `actions/untrusted-checkout/high`, `actions/untrusted-checkout/medium`. Clarified wording on a minor point, added one more listed resource and added one more recommendation for things to check.

## 0.6.28

### Query Metadata Changes

* Adjusted the name of `actions/untrusted-checkout/high` to more clearly describe which parts of the scenario are in a privileged context.

### Minor Analysis Improvements

* The `actions/unpinned-tag` query now analyzes composite action metadata (`action.yml`/`action.yaml` files) in addition to workflow files, providing more comprehensive detection of unpinned action references across the entire Actions ecosystem.

### Bug Fixes

* Fixed help file descriptions for queries: `actions/untrusted-checkout/critical`, `actions/untrusted-checkout/high`, `actions/untrusted-checkout/medium`. Previously the messages were unclear as to why and how the vulnerabilities could occur. 

## 0.6.27

No user-facing changes.

## 0.6.26

### Major Analysis Improvements

* Fixed alert messages in `actions/artifact-poisoning/critical` and `actions/artifact-poisoning/medium` as they previously included a redundant placeholder in the alert message that would on occasion contain a long block of yml that makes the alert difficult to understand. Also improved the wording to make it clearer that it is not the artifact that is being poisoned, but instead a potentially untrusted artifact that is consumed. Finally, changed the alert location to be the source, to align more with other queries reporting an artifact (e.g. zipslip) which is more useful.

### Minor Analysis Improvements

* The query `actions/missing-workflow-permissions` no longer produces false positive results on reusable workflows where all callers set permissions.

## 0.6.25

No user-facing changes.

## 0.6.24

No user-facing changes.

## 0.6.23

No user-facing changes.

## 0.6.22

No user-facing changes.

## 0.6.21

No user-facing changes.

## 0.6.20

No user-facing changes.

## 0.6.19

No user-facing changes.

## 0.6.18

No user-facing changes.

## 0.6.17

No user-facing changes.

## 0.6.16

No user-facing changes.

## 0.6.15

No user-facing changes.

## 0.6.14

No user-facing changes.

## 0.6.13

No user-facing changes.

## 0.6.12

No user-facing changes.

## 0.6.11

No user-facing changes.

## 0.6.10

No user-facing changes.

## 0.6.9

### Minor Analysis Improvements

* Actions analysis now reports file coverage information on the CodeQL status page.

## 0.6.8

No user-facing changes.

## 0.6.7

No user-facing changes.

## 0.6.6

No user-facing changes.

## 0.6.5

No user-facing changes.

## 0.6.4

No user-facing changes.

## 0.6.3

No user-facing changes.

## 0.6.2

### Minor Analysis Improvements

* The query `actions/missing-workflow-permissions` is now aware of the minimal permissions needed for the actions `deploy-pages`, `delete-package-versions`, `ai-inference`. This should lead to better alert messages and better fix suggestions.

## 0.6.1

No user-facing changes.

## 0.6.0

### Breaking Changes

* The following queries have been removed from the `security-and-quality` suite.
  They are not intended to produce user-facing
  alerts describing vulnerabilities.
  Any existing alerts for these queries will be closed automatically.
  * `actions/composite-action-sinks`
  * `actions/composite-action-sources`
  * `actions/composite-action-summaries`
  * `actions/reusable-workflow-sinks`
    (renamed from `actions/reusable-wokflow-sinks`)
  * `actions/reusable-workflow-sources`
  * `actions/reusable-workflow-summaries`

### Bug Fixes

* Assigned a `security-severity` to the query `actions/excessive-secrets-exposure`.

## 0.5.4

### New Features

* CodeQL and Copilot Autofix support for GitHub Actions is now Generally Available.

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
