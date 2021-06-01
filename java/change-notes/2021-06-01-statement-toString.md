lgtm,codescanning
* The CodeQL predicate `toString()` has been overridden for subclasses of `Stmt` to be more descriptive. Due to this, custom queries and `.expected` files of CodeQL tests for custom queries might have to be adjusted to match the new `toString()` results.
