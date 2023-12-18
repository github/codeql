package pg

import (
	"context"
	"io"
	"strconv"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/orm"
	"github.com/go-pg/pg/v10/types"
)

// Discard is used with Query and QueryOne to discard rows.
var Discard orm.Discard

// NullTime is a time.Time wrapper that marshals zero time as JSON null and
// PostgreSQL NULL.
type NullTime = types.NullTime

// Scan returns ColumnScanner that copies the columns in the
// row into the values.
func Scan(values ...interface{}) orm.ColumnScanner {
	return orm.Scan(values...)
}

// Safe represents a safe SQL query.
type Safe = types.Safe

// Ident represents a SQL identifier, e.g. table or column name.
type Ident = types.Ident

// SafeQuery replaces any placeholders found in the query.
func SafeQuery(query string, params ...interface{}) *orm.SafeQueryAppender {
	return orm.SafeQuery(query, params...)
}

// In accepts a slice and returns a wrapper that can be used with PostgreSQL
// IN operator:
//
//    Where("id IN (?)", pg.In([]int{1, 2, 3, 4}))
//
// produces
//
//    WHERE id IN (1, 2, 3, 4)
func In(slice interface{}) types.ValueAppender {
	return types.In(slice)
}

// InMulti accepts multiple values and returns a wrapper that can be used
// with PostgreSQL IN operator:
//
//    Where("(id1, id2) IN (?)", pg.InMulti([]int{1, 2}, []int{3, 4}))
//
// produces
//
//    WHERE (id1, id2) IN ((1, 2), (3, 4))
func InMulti(values ...interface{}) types.ValueAppender {
	return types.InMulti(values...)
}

// Array accepts a slice and returns a wrapper for working with PostgreSQL
// array data type.
//
// For struct fields you can use array tag:
//
//    Emails  []string `pg:",array"`
func Array(v interface{}) *types.Array {
	return types.NewArray(v)
}

// Hstore accepts a map and returns a wrapper for working with hstore data type.
// Supported map types are:
//   - map[string]string
//
// For struct fields you can use hstore tag:
//
//    Attrs map[string]string `pg:",hstore"`
func Hstore(v interface{}) *types.Hstore {
	return types.NewHstore(v)
}

// SetLogger sets the logger to the given one.
func SetLogger(logger internal.Logging) {
	internal.Logger = logger
}

//------------------------------------------------------------------------------

type Query = orm.Query

// Model returns a new query for the optional model.
func Model(model ...interface{}) *Query {
	return orm.NewQuery(nil, model...)
}

// ModelContext returns a new query for the optional model with a context.
func ModelContext(c context.Context, model ...interface{}) *Query {
	return orm.NewQueryContext(c, nil, model...)
}

// DBI is a DB interface implemented by *DB and *Tx.
type DBI interface {
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

	Begin() (*Tx, error)
	RunInTransaction(ctx context.Context, fn func(*Tx) error) error

	CopyFrom(r io.Reader, query interface{}, params ...interface{}) (Result, error)
	CopyTo(w io.Writer, query interface{}, params ...interface{}) (Result, error)
}

var (
	_ DBI = (*DB)(nil)
	_ DBI = (*Tx)(nil)
)

//------------------------------------------------------------------------------

// Strings is a type alias for a slice of strings.
type Strings []string

var (
	_ orm.HooklessModel   = (*Strings)(nil)
	_ types.ValueAppender = (*Strings)(nil)
)

// Init initializes the Strings slice.
func (strings *Strings) Init() error {
	if s := *strings; len(s) > 0 {
		*strings = s[:0]
	}
	return nil
}

// NextColumnScanner ...
func (strings *Strings) NextColumnScanner() orm.ColumnScanner {
	return strings
}

// AddColumnScanner ...
func (Strings) AddColumnScanner(_ orm.ColumnScanner) error {
	return nil
}

// ScanColumn scans the columns and appends them to `strings`.
func (strings *Strings) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	b := make([]byte, n)
	_, err := io.ReadFull(rd, b)
	if err != nil {
		return err
	}

	*strings = append(*strings, internal.BytesToString(b))
	return nil
}

// AppendValue appends the values from `strings` to the given byte slice.
func (strings Strings) AppendValue(dst []byte, quote int) ([]byte, error) {
	if len(strings) == 0 {
		return dst, nil
	}

	for _, s := range strings {
		dst = types.AppendString(dst, s, 1)
		dst = append(dst, ',')
	}
	dst = dst[:len(dst)-1]
	return dst, nil
}

//------------------------------------------------------------------------------

// Ints is a type alias for a slice of int64 values.
type Ints []int64

var (
	_ orm.HooklessModel   = (*Ints)(nil)
	_ types.ValueAppender = (*Ints)(nil)
)

// Init initializes the Int slice.
func (ints *Ints) Init() error {
	if s := *ints; len(s) > 0 {
		*ints = s[:0]
	}
	return nil
}

// NewColumnScanner ...
func (ints *Ints) NextColumnScanner() orm.ColumnScanner {
	return ints
}

// AddColumnScanner ...
func (Ints) AddColumnScanner(_ orm.ColumnScanner) error {
	return nil
}

// ScanColumn scans the columns and appends them to `ints`.
func (ints *Ints) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	num, err := types.ScanInt64(rd, n)
	if err != nil {
		return err
	}

	*ints = append(*ints, num)
	return nil
}

// AppendValue appends the values from `ints` to the given byte slice.
func (ints Ints) AppendValue(dst []byte, quote int) ([]byte, error) {
	if len(ints) == 0 {
		return dst, nil
	}

	for _, v := range ints {
		dst = strconv.AppendInt(dst, v, 10)
		dst = append(dst, ',')
	}
	dst = dst[:len(dst)-1]
	return dst, nil
}

//------------------------------------------------------------------------------

// IntSet is a set of int64 values.
type IntSet map[int64]struct{}

var _ orm.HooklessModel = (*IntSet)(nil)

// Init initializes the IntSet.
func (set *IntSet) Init() error {
	if len(*set) > 0 {
		*set = make(map[int64]struct{})
	}
	return nil
}

// NextColumnScanner ...
func (set *IntSet) NextColumnScanner() orm.ColumnScanner {
	return set
}

// AddColumnScanner ...
func (IntSet) AddColumnScanner(_ orm.ColumnScanner) error {
	return nil
}

// ScanColumn scans the columns and appends them to `IntSet`.
func (set *IntSet) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	num, err := types.ScanInt64(rd, n)
	if err != nil {
		return err
	}

	setVal := *set
	if setVal == nil {
		*set = make(IntSet)
		setVal = *set
	}

	setVal[num] = struct{}{}
	return nil
}
