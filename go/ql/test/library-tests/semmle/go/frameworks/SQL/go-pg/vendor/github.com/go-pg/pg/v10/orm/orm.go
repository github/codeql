/*
The API in this package is not stable and may change without any notice.
*/
package orm

import (
	"context"
	"io"

	"github.com/go-pg/pg/v10/types"
)

// ColumnScanner is used to scan column values.
type ColumnScanner interface {
	// Scan assigns a column value from a row.
	//
	// An error should be returned if the value can not be stored
	// without loss of information.
	ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error
}

type QueryAppender interface {
	AppendQuery(fmter QueryFormatter, b []byte) ([]byte, error)
}

type TemplateAppender interface {
	AppendTemplate(b []byte) ([]byte, error)
}

type QueryCommand interface {
	QueryAppender
	TemplateAppender
	String() string
	Operation() QueryOp
	Clone() QueryCommand
	Query() *Query
}

// DB is a common interface for pg.DB and pg.Tx types.
type DB interface {
	Model(model ...interface{}) *Query
	ModelContext(c context.Context, model ...interface{}) *Query

	Exec(query interface{}, params ...interface{}) (Result, error)
	ExecContext(c context.Context, query interface{}, params ...interface{}) (Result, error)
	ExecOne(query interface{}, params ...interface{}) (Result, error)
	ExecOneContext(c context.Context, query interface{}, params ...interface{}) (Result, error)
	Query(model, query interface{}, params ...interface{}) (Result, error)
	QueryContext(c context.Context, model, query interface{}, params ...interface{}) (Result, error)
	QueryOne(model, query interface{}, params ...interface{}) (Result, error)
	QueryOneContext(c context.Context, model, query interface{}, params ...interface{}) (Result, error)

	CopyFrom(r io.Reader, query interface{}, params ...interface{}) (Result, error)
	CopyTo(w io.Writer, query interface{}, params ...interface{}) (Result, error)

	Context() context.Context
	Formatter() QueryFormatter
}
