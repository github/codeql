// Return error if both Cgo and modernc sqlite implementations are unavailable.
// That includes the case where cgosqlite is set but Cgo is disabled.

// +build !cgo
// +build cgosqlite !darwin !amd64
// +build cgosqlite !darwin !arm64
// +build cgosqlite !linux !386
// +build cgosqlite !linux !amd64
// +build cgosqlite !linux !arm
// +build cgosqlite !linux !arm64
// +build cgosqlite !windows !amd64

package sqliteshim

import "database/sql/driver"

const (
	hasDriver  = false
	driverName = ShimName
)

var shimDriver = (*errorDriver)(nil)

type errorDriver struct{}

func (*errorDriver) Open(dsn string) (driver.Conn, error) {
	return nil, &errUnsupported
}

var errUnsupported UnsupportedError
