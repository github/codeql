package sqlx

import (
	"context"
	"database/sql"
)

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
