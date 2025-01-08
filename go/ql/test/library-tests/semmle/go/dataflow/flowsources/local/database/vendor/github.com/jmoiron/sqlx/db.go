package sqlx

import (
	"context"
	"database/sql"
)

type DB struct {
	*sql.DB

	// Mapper *reflectx.Mapper
}

func (db *DB) Get(dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (db *DB) GetContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (db *DB) QueryRowx(query string, args ...interface{}) *Row {
	return nil
}

func (db *DB) QueryRowxContext(ctx context.Context, query string, args ...interface{}) *Row {
	return nil
}

func (db *DB) Queryx(query string, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (db *DB) QueryxContext(ctx context.Context, query string, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (db *DB) Select(dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (db *DB) SelectContext(ctx context.Context, dest interface{}, query string, args ...interface{}) error {
	return nil
}

func (db *DB) NamedQuery(query string, arg interface{}) (*Rows, error) {
	return nil, nil
}

func (db *DB) NamedQueryContext(ctx context.Context, query string, arg interface{}) (*Rows, error) {
	return nil, nil
}
