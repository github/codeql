## 0.9.9

### New Queries

* Added a new query, `cpp/type-confusion`, to detect casts to invalid types.

### Query Metadata Changes

* `@precision medium` metadata was added to the `cpp/boost/tls-settings-misconfiguration` and `cpp/boost/use-of-deprecated-hardcoded-security-protocol` queries, and these queries are now included in the security-extended suite. The `@name` metadata of these queries were also updated.

### Minor Analysis Improvements

* The "Missing return-value check for a 'scanf'-like function" query (`cpp/missing-check-scanf`) has been converted to a `path-problem` query.
* The "Potentially uninitialized local variable" query (`cpp/uninitialized-local`) has been converted to a `path-problem` query.
* Added models for `GLib` allocation and deallocation functions.
