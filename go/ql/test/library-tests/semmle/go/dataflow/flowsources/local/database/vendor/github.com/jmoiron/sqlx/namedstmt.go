package sqlx

import (
	"context"
	"database/sql"
)

type NamedStmt struct {
	Params      []string
	QueryString string
	Stmt        *sql.Stmt
}

func (s *NamedStmt) Get(dest interface{}, args ...interface{}) error {
	return nil
}

func (s *NamedStmt) GetContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}

func (s *NamedStmt) QueryRow(args ...interface{}) *Row {
	return nil
}

func (s *NamedStmt) QueryRowContext(ctx context.Context, args ...interface{}) *Row {
	return nil
}

func (s *NamedStmt) Query(args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *NamedStmt) QueryContext(ctx context.Context, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *NamedStmt) QueryRowx(args ...interface{}) *Row {
	return nil
}

func (s *NamedStmt) QueryRowxContext(ctx context.Context, args ...interface{}) *Row {
	return nil
}

func (s *NamedStmt) Queryx(args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *NamedStmt) QueryxContext(ctx context.Context, args ...interface{}) (*Rows, error) {
	return nil, nil
}

func (s *NamedStmt) Select(dest interface{}, args ...interface{}) error {
	return nil
}

func (s *NamedStmt) SelectContext(ctx context.Context, dest interface{}, args ...interface{}) error {
	return nil
}
