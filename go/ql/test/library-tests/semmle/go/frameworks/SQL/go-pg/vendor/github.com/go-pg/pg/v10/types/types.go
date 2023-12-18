package types

import (
	"github.com/go-pg/pg/v10/internal/pool"
)

type Reader = pool.Reader

type ValueScanner interface {
	ScanValue(rd Reader, n int) error
}

type ValueAppender interface {
	AppendValue(b []byte, flags int) ([]byte, error)
}

//------------------------------------------------------------------------------

// Safe represents a safe SQL query.
type Safe string

var _ ValueAppender = (*Safe)(nil)

func (q Safe) AppendValue(b []byte, flags int) ([]byte, error) {
	return append(b, q...), nil
}

//------------------------------------------------------------------------------

// Ident represents a SQL identifier, e.g. table or column name.
type Ident string

var _ ValueAppender = (*Ident)(nil)

func (f Ident) AppendValue(b []byte, flags int) ([]byte, error) {
	return AppendIdent(b, string(f), flags), nil
}
