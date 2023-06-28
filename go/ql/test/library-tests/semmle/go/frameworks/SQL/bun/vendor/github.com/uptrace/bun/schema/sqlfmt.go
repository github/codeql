package schema

import (
	"strings"

	"github.com/uptrace/bun/internal"
)

type QueryAppender interface {
	AppendQuery(fmter Formatter, b []byte) ([]byte, error)
}

type ColumnsAppender interface {
	AppendColumns(fmter Formatter, b []byte) ([]byte, error)
}

//------------------------------------------------------------------------------

// Safe represents a safe SQL query.
type Safe string

var _ QueryAppender = (*Safe)(nil)

func (s Safe) AppendQuery(fmter Formatter, b []byte) ([]byte, error) {
	return append(b, s...), nil
}

//------------------------------------------------------------------------------

// Ident represents a SQL identifier, for example, table or column name.
type Ident string

var _ QueryAppender = (*Ident)(nil)

func (s Ident) AppendQuery(fmter Formatter, b []byte) ([]byte, error) {
	return fmter.AppendIdent(b, string(s)), nil
}

//------------------------------------------------------------------------------

type QueryWithArgs struct {
	Query string
	Args  []interface{}
}

var _ QueryAppender = QueryWithArgs{}

func SafeQuery(query string, args []interface{}) QueryWithArgs {
	if args == nil {
		args = make([]interface{}, 0)
	} else if len(query) > 0 && strings.IndexByte(query, '?') == -1 {
		internal.Warn.Printf("query %q has %v args, but no placeholders", query, args)
	}
	return QueryWithArgs{
		Query: query,
		Args:  args,
	}
}

func UnsafeIdent(ident string) QueryWithArgs {
	return QueryWithArgs{Query: ident}
}

func (q QueryWithArgs) IsZero() bool {
	return q.Query == "" && q.Args == nil
}

func (q QueryWithArgs) AppendQuery(fmter Formatter, b []byte) ([]byte, error) {
	if q.Args == nil {
		return fmter.AppendIdent(b, q.Query), nil
	}
	return fmter.AppendQuery(b, q.Query, q.Args...), nil
}

//------------------------------------------------------------------------------

type QueryWithSep struct {
	QueryWithArgs
	Sep string
}

func SafeQueryWithSep(query string, args []interface{}, sep string) QueryWithSep {
	return QueryWithSep{
		QueryWithArgs: SafeQuery(query, args),
		Sep:           sep,
	}
}
