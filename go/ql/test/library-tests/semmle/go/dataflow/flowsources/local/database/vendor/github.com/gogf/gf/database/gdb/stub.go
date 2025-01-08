package gdb

import (
	"context"
	"database/sql"
)

type DB interface {
	Query(sql string, args ...interface{}) (*sql.Rows, error)
	Exec(sql string, args ...interface{}) (sql.Result, error)

	DoGetAll(ctx context.Context, link Link, sql string, args ...interface{}) (result Result, err error)
	DoUpdate(ctx context.Context, link Link, table string, data interface{}, condition string, args ...interface{}) (result sql.Result, err error)
	DoDelete(ctx context.Context, link Link, table string, condition string, args ...interface{}) (result sql.Result, err error)
	DoQuery(ctx context.Context, link Link, sql string, args ...interface{}) (rows *sql.Rows, err error)
	DoExec(ctx context.Context, link Link, sql string, args ...interface{}) (result sql.Result, err error)
	DoCommit(ctx context.Context, link Link, sql string, args []interface{}) (newSql string, newArgs []interface{}, err error)

	GetAll(sql string, args ...interface{}) (Result, error)
	GetOne(sql string, args ...interface{}) (Record, error)
	GetValue(sql string, args ...interface{}) (Value, error)
	GetArray(sql string, args ...interface{}) ([]Value, error)
	GetCount(sql string, args ...interface{}) (int, error)
	GetScan(objPointer interface{}, sql string, args ...interface{}) error
	Union(unions ...*Model) *Model
	UnionAll(unions ...*Model) *Model

	Master(schema ...string) (*sql.DB, error)
	Slave(schema ...string) (*sql.DB, error)

	PingMaster() error
	PingSlave() error

	Begin() (*TX, error)
	Transaction(ctx context.Context, f func(ctx context.Context, tx *TX) error) error
}

func New(group ...string) (DB, error) {
	return nil, nil
}

type Link interface {
	Query(sql string, args ...interface{}) (*sql.Rows, error)
	Exec(sql string, args ...interface{}) (sql.Result, error)
	Prepare(sql string) (*sql.Stmt, error)
	QueryContext(ctx context.Context, sql string, args ...interface{}) (*sql.Rows, error)
	ExecContext(ctx context.Context, sql string, args ...interface{}) (sql.Result, error)
	PrepareContext(ctx context.Context, sql string) (*sql.Stmt, error)
	IsTransaction() bool
}

type Model struct{}

type Record map[string]Value

type Result []Record

type Value interface{}

type TX struct{}
