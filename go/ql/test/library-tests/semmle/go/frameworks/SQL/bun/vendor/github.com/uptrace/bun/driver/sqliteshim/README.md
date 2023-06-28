# sqliteshim

[![PkgGoDev](https://pkg.go.dev/badge/github.com/uptrace/bun/driver/sqliteshim)](https://pkg.go.dev/github.com/uptrace/bun/driver/sqliteshim)

sqliteshim automatically imports [modernc.org/sqlite](https://modernc.org/sqlite/) or
[mattn/go-sqlite3](https://github.com/mattn/go-sqlite3) depending on your platform.

Currently sqliteshim uses packages in the following order:

- [modernc.org/sqlite](https://modernc.org/sqlite/) on supported platforms.
- [mattn/go-sqlite3](https://github.com/mattn/go-sqlite3) if Cgo is enabled.

Otherwise it registers a driver that returns an error on unsupported platforms.

You can install sqliteshim with:

```shell
go get github.com/uptrace/bun/driver/sqliteshim
```

And then create a `sql.DB`:

```go
sqldb, err := sql.Open(sqliteshim.ShimName, "file::memory:?cache=shared")
```

Alternatively you can also use `sqliteshim.DriverName`:

```go
if sqliteshim.HasDriver() {
	sqldb, err := sql.Open(sqliteshim.DriverName(), "file::memory:?cache=shared")
}
```
