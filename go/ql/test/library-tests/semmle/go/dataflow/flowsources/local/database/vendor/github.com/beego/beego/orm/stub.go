package orm

import (
	"context"
	"database/sql"
	"sync"
)

type DB struct {
	*sync.RWMutex
	DB *sql.DB
	// contains filtered or unexported fields
}

func (d *DB) Query(query string, args ...interface{}) (*sql.Rows, error) {
	return nil, nil
}
func (d *DB) QueryContext(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error) {
	return nil, nil
}
func (d *DB) QueryRow(query string, args ...interface{}) *sql.Row {
	return nil
}
func (d *DB) QueryRowContext(ctx context.Context, query string, args ...interface{}) *sql.Row {
	return nil
}

type DQL interface {
	Read(md interface{}, cols ...string) error
	ReadWithCtx(ctx context.Context, md interface{}, cols ...string) error

	ReadForUpdate(md interface{}, cols ...string) error
	ReadForUpdateWithCtx(ctx context.Context, md interface{}, cols ...string) error

	ReadOrCreate(md interface{}, col1 string, cols ...string) (bool, int64, error)
	ReadOrCreateWithCtx(ctx context.Context, md interface{}, col1 string, cols ...string) (bool, int64, error)
}

type Ormer interface {
	DQL
}

func NewOrm() Ormer {
	return nil
}
