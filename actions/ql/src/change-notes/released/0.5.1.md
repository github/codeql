## 0.5.1

### Bug Fixes

* The `actions/unversioned-immutable-action` query will no longer report any alerts, since the
  Immutable Actions feature is not yet available for customer use. The query has also been moved
  to the experimental folder and will not be used in code scanning unless it is explicitly added
  to a code scanning configuration. Once the Immutable Actions feature is available, the query will
  be updated to report alerts again.
