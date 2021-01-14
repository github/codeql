lgtm,codescanning
* Added support for [the offical Couchbase Go SDK library](https://github.com/couchbase/gocb), v1 and v2. The `go/sql-injection` query (which also handles non-SQL databases such as Couchbase) will now identify Couchbase queries built from untrusted external input.
