## 0.8.6

### Minor Analysis Improvements

* The `Call::getArgumentForParameter` predicate has been reworked to add support for arguments passed to `params` parameters.
* The dataflow models for the `System.Text.StringBuilder` class have been reworked. New summaries have been added for `Append` and `AppendLine`. With the changes, we expect queries that use taint tracking to find more results when interpolated strings or `StringBuilder` instances are passed to `Append` or `AppendLine`.
* Additional support for `Amazon.Lambda` SDK
