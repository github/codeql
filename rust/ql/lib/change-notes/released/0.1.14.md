## 0.1.14

### Minor Analysis Improvements

* [`let` chains in `if` and `while`](https://doc.rust-lang.org/edition-guide/rust-2024/let-chains.html) are now supported, as well as [`if let` guards in `match` expressions](https://rust-lang.github.io/rfcs/2294-if-let-guard.html).
* Added more detail to models of `postgres`, `rusqlite`, `sqlx` and `tokio-postgres`. This may improve query results, particularly for `rust/sql-injection` and `rust/cleartext-storage-database`.
