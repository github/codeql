// Package sqliteshim is a shim package that imports an appropriate sqlite
// driver for the build target and registers it under ShimName.
//
// Currently it uses packages in the following order:
//  • modernc.org/sqlite on supported platforms,
//  • github.com/mattn/go-sqlite3 if Cgo is enabled,
// Otherwise registers a driver that returns an error on unsupported platforms.
//
package sqliteshim

import (
	"database/sql"
	"database/sql/driver"
)

func init() {
	sql.Register(ShimName, shimDriver)
}

// ShimName is the name of the shim database/sql driver registration.
const ShimName = "sqliteshim"

// UnsupportedError is returned from driver on unsupported platforms.
type UnsupportedError struct{}

func (e *UnsupportedError) Error() string {
	return "sqlite driver is not available on the current platform"
}

// HasDriver indicates that SQLite driver implementation is available.
func HasDriver() bool {
	return hasDriver
}

// Driver returns the shim driver registered under ShimName name.
func Driver() driver.Driver {
	return shimDriver
}

// DriverName is the name of the database/sql driver. Note that unlike ShimName
// the value depends on the build target. That is, DriverName returns the name
// of the underlying database driver.
func DriverName() string {
	return driverName
}
