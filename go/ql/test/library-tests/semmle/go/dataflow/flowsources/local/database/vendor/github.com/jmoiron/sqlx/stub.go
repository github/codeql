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

type Row struct {
	// Mapper *reflectx.Mapper
}

// stub Row::MapScan, Row::StructScan, Row::SliceScan, Row::Scan

func (r *Row) MapScan(dest map[string]interface{}) error {
	return nil
}

func (r *Row) StructScan(dest interface{}) error {
	return nil
}

func (r *Row) SliceScan(dest []interface{}) error {
	return nil
}

func (r *Row) Scan(dest ...interface{}) error {
	return nil
}

type Rows struct {
	*sql.Rows

	// Mapper *reflectx.Mapper
	// contains filtered or unexported fields
}

func (r *Rows) MapScan(dest map[string]interface{}) error {
	return nil
}

func (r *Rows) StructScan(dest interface{}) error {
	return nil
}

func (r *Rows) SliceScan(dest []interface{}) error {
	return nil
}

func (r *Rows) Scan(dest ...interface{}) error {
	return nil
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

type Conn struct {
	*sql.Conn
}

func (c *Conn) GetContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (c *Conn) SelectContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (c *Conn) QueryRowxContext(ctx context.Context, query string, args ...interface{}) *Row {
	return nil
}

func (c *Conn) QueryxContext(ctx context.Context, query string, args ...interface{}) (*Rows, error) {
	return nil, nil
}
