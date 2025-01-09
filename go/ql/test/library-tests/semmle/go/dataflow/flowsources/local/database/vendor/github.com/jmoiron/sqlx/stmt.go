package sqlx

import (
	"context"
	"database/sql"
)

type Stmt struct {
	*sql.Stmt
}

func (s *Stmt) Get(dest interface{}, args ...interface{}) error {
	return nil
}

func (s *Stmt) GetContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}

func (s *Stmt) QueryRowx(args ...interface{}) *Row {
	return nil
}

func (s *Stmt) QueryRowxContext(ctx context.Context, args ...interface{}) *Row {
	return nil
}

func (s *Stmt) Queryx(args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *Stmt) QueryxContext(ctx context.Context, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *Stmt) Select(dest interface{}, args ...interface{}) error {
	return nil
}

func (s *Stmt) SelectContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}
