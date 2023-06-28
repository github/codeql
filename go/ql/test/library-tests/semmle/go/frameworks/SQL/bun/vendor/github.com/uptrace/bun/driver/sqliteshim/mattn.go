// Use Cgo sqlite if Cgo is enabled and either modernc is unavailable or Cgo was
// explicitly requested via build tag.

// +build cgo,cgosqlite cgo
// +build cgosqlite !darwin !amd64
// +build cgosqlite !darwin !arm64
// +build cgosqlite !linux !386
// +build cgosqlite !linux !amd64
// +build cgosqlite !linux !arm
// +build cgosqlite !linux !arm64
// +build cgosqlite !windows !amd64

package sqliteshim

import "github.com/mattn/go-sqlite3"

const (
	hasDriver  = true
	driverName = "sqlite3"
)

var shimDriver = &sqlite3.SQLiteDriver{}
