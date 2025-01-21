package sqlx

import (
	"context"
	"database/sql"
)

type Tx struct {
	*sql.Tx
}

func (tx *Tx) Get(dest interface{}, args ...interface{}) error {
	return nil
}

func (tx *Tx) GetContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}

func (tx *Tx) QueryRowx(args ...interface{}) *Row {
	return nil
}

func (tx *Tx) QueryRowxContext(ctx context.Context, args ...interface{}) *Row {

	return nil
}

func (tx *Tx) Queryx(args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (tx *Tx) QueryxContext(ctx context.Context, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (tx *Tx) Select(dest interface{}, args ...interface{}) error {
	return nil
}

func (tx *Tx) SelectContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}

func (tx *Tx) NamedQuery(query string, arg interface{}) (*Rows, error) {
	return nil, nil
}
