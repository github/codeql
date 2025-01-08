package gorm

import (
	"context"
	"database/sql"
)

type DB struct{}

func (db *DB) Find(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) FindInBatches(dest interface{}, batchSize int, fc func(tx *DB, batch int) error) *DB {
	return db
}

func (db *DB) FirstOrCreate(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) FirstOrInit(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) First(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) Model(value interface{}) *DB {
	return db
}

func (db *DB) Last(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) Pluck(column string, dest interface{}) *DB {
	return db
}

func (db *DB) Take(dest interface{}, conds ...interface{}) *DB {
	return db
}

func (db *DB) Scan(dest interface{}) *DB {
	return db
}

func (db *DB) ScanRows(rows *sql.Rows, result interface{}) error {
	return nil
}

func (db *DB) Row() *sql.Row {
	return nil
}

func (db *DB) Rows() (*sql.Rows, error) {
	return nil, nil
}

type Association struct {
	DB *DB
}

func (a *Association) Find(dest interface{}) *Association {
	return a
}

type ConnPool interface {
	PrepareContext(ctx context.Context, query string) (*sql.Stmt, error)
	ExecContext(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
	QueryContext(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error)
	QueryRowContext(ctx context.Context, query string, args ...interface{}) *sql.Row
}

type Model interface{}
