package sqlx

import (
	"context"
	"database/sql"
)

type ColScanner interface {
	Columns() ([]string, error)
	Scan(dest ...interface{}) error
	Err() error
}

type Execer interface {
	Exec(query string, args ...interface{}) (sql.Result, error)
}

type ExecerContext interface {
	ExecContext(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
}

type Ext interface {
	Queryer
	Execer
}

type ExtContext interface {
	QueryerContext
	ExecerContext
	// contains filtered or unexported methods
}

type Queryer interface {
	Query(query string, args ...interface{}) (*sql.Rows, error)
	Queryx(query string, args ...interface{}) (*Rows, error)
	QueryRowx(query string, args ...interface{}) *Row
}

type QueryerContext interface {
	QueryContext(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error)
	QueryxContext(ctx context.Context, query string, args ...interface{}) (*Rows, error)
	QueryRowxContext(ctx context.Context, query string, args ...interface{}) *Row
}

func NamedQuery(e Ext, query string, arg interface{}) (*Rows, error) {
	return e.Queryx(query, arg)
}

func NamedQueryContext(ctx context.Context, e ExtContext, query string, arg interface{}) (*Rows, error) {
	return e.QueryxContext(ctx, query, arg)
}

func Get(q Queryer, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func GetContext(ctx context.Context, q QueryerContext, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func Select(q Queryer, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func SelectContext(ctx context.Context, q QueryerContext, dest interface{}, query string, args ...interface{}) error {
	return nil
}
