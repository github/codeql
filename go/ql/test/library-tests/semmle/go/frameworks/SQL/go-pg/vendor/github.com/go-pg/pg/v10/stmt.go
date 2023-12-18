package pg

import (
	"context"
	"errors"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/orm"
	"github.com/go-pg/pg/v10/types"
)

var errStmtClosed = errors.New("pg: statement is closed")

// Stmt is a prepared statement. Stmt is safe for concurrent use by
// multiple goroutines.
type Stmt struct {
	db        *baseDB
	stickyErr error

	q       string
	name    string
	columns []types.ColumnInfo
}

func prepareStmt(db *baseDB, q string) (*Stmt, error) {
	stmt := &Stmt{
		db: db,

		q: q,
	}

	err := stmt.prepare(context.TODO(), q)
	if err != nil {
		_ = stmt.Close()
		return nil, err
	}
	return stmt, nil
}

func (stmt *Stmt) prepare(ctx context.Context, q string) error {
	var lastErr error
	for attempt := 0; attempt <= stmt.db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			if err := internal.Sleep(ctx, stmt.db.retryBackoff(attempt-1)); err != nil {
				return err
			}

			err := stmt.db.pool.(*pool.StickyConnPool).Reset(ctx)
			if err != nil {
				return err
			}
		}

		lastErr = stmt.withConn(ctx, func(ctx context.Context, cn *pool.Conn) error {
			var err error
			stmt.name, stmt.columns, err = stmt.db.prepare(ctx, cn, q)
			return err
		})
		if !stmt.db.shouldRetry(lastErr) {
			break
		}
	}
	return lastErr
}

func (stmt *Stmt) withConn(c context.Context, fn func(context.Context, *pool.Conn) error) error {
	if stmt.stickyErr != nil {
		return stmt.stickyErr
	}
	err := stmt.db.withConn(c, fn)
	if err == pool.ErrClosed {
		return errStmtClosed
	}
	return err
}

// Exec executes a prepared statement with the given parameters.
func (stmt *Stmt) Exec(params ...interface{}) (Result, error) {
	return stmt.exec(context.TODO(), params...)
}

// ExecContext executes a prepared statement with the given parameters.
func (stmt *Stmt) ExecContext(c context.Context, params ...interface{}) (Result, error) {
	return stmt.exec(c, params...)
}

func (stmt *Stmt) exec(ctx context.Context, params ...interface{}) (Result, error) {
	ctx, evt, err := stmt.db.beforeQuery(ctx, stmt.db.db, nil, stmt.q, params, nil)
	if err != nil {
		return nil, err
	}

	var res Result
	var lastErr error
	for attempt := 0; attempt <= stmt.db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			lastErr = internal.Sleep(ctx, stmt.db.retryBackoff(attempt-1))
			if lastErr != nil {
				break
			}
		}

		lastErr = stmt.withConn(ctx, func(c context.Context, cn *pool.Conn) error {
			res, err = stmt.extQuery(ctx, cn, stmt.name, params...)
			return err
		})
		if !stmt.db.shouldRetry(lastErr) {
			break
		}
	}

	if err := stmt.db.afterQuery(ctx, evt, res, lastErr); err != nil {
		return nil, err
	}
	return res, lastErr
}

// ExecOne acts like Exec, but query must affect only one row. It
// returns ErrNoRows error when query returns zero rows or
// ErrMultiRows when query returns multiple rows.
func (stmt *Stmt) ExecOne(params ...interface{}) (Result, error) {
	return stmt.execOne(context.Background(), params...)
}

// ExecOneContext acts like ExecOne but additionally receives a context.
func (stmt *Stmt) ExecOneContext(c context.Context, params ...interface{}) (Result, error) {
	return stmt.execOne(c, params...)
}

func (stmt *Stmt) execOne(c context.Context, params ...interface{}) (Result, error) {
	res, err := stmt.ExecContext(c, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// Query executes a prepared query statement with the given parameters.
func (stmt *Stmt) Query(model interface{}, params ...interface{}) (Result, error) {
	return stmt.query(context.Background(), model, params...)
}

// QueryContext acts like Query but additionally receives a context.
func (stmt *Stmt) QueryContext(c context.Context, model interface{}, params ...interface{}) (Result, error) {
	return stmt.query(c, model, params...)
}

func (stmt *Stmt) query(ctx context.Context, model interface{}, params ...interface{}) (Result, error) {
	ctx, evt, err := stmt.db.beforeQuery(ctx, stmt.db.db, model, stmt.q, params, nil)
	if err != nil {
		return nil, err
	}

	var res Result
	var lastErr error
	for attempt := 0; attempt <= stmt.db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			lastErr = internal.Sleep(ctx, stmt.db.retryBackoff(attempt-1))
			if lastErr != nil {
				break
			}
		}

		lastErr = stmt.withConn(ctx, func(c context.Context, cn *pool.Conn) error {
			res, err = stmt.extQueryData(ctx, cn, stmt.name, model, stmt.columns, params...)
			return err
		})
		if !stmt.db.shouldRetry(lastErr) {
			break
		}
	}

	if err := stmt.db.afterQuery(ctx, evt, res, lastErr); err != nil {
		return nil, err
	}
	return res, lastErr
}

// QueryOne acts like Query, but query must return only one row. It
// returns ErrNoRows error when query returns zero rows or
// ErrMultiRows when query returns multiple rows.
func (stmt *Stmt) QueryOne(model interface{}, params ...interface{}) (Result, error) {
	return stmt.queryOne(context.Background(), model, params...)
}

// QueryOneContext acts like QueryOne but additionally receives a context.
func (stmt *Stmt) QueryOneContext(c context.Context, model interface{}, params ...interface{}) (Result, error) {
	return stmt.queryOne(c, model, params...)
}

func (stmt *Stmt) queryOne(c context.Context, model interface{}, params ...interface{}) (Result, error) {
	mod, err := orm.NewModel(model)
	if err != nil {
		return nil, err
	}

	res, err := stmt.QueryContext(c, mod, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// Close closes the statement.
func (stmt *Stmt) Close() error {
	var firstErr error

	if stmt.name != "" {
		firstErr = stmt.closeStmt()
	}

	err := stmt.db.Close()
	if err != nil && firstErr == nil {
		firstErr = err
	}

	return firstErr
}

func (stmt *Stmt) extQuery(
	c context.Context, cn *pool.Conn, name string, params ...interface{},
) (Result, error) {
	err := cn.WithWriter(c, stmt.db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		return writeBindExecuteMsg(wb, name, params...)
	})
	if err != nil {
		return nil, err
	}

	var res Result
	err = cn.WithReader(c, stmt.db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		res, err = readExtQuery(rd)
		return err
	})
	if err != nil {
		return nil, err
	}

	return res, nil
}

func (stmt *Stmt) extQueryData(
	c context.Context,
	cn *pool.Conn,
	name string,
	model interface{},
	columns []types.ColumnInfo,
	params ...interface{},
) (Result, error) {
	err := cn.WithWriter(c, stmt.db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		return writeBindExecuteMsg(wb, name, params...)
	})
	if err != nil {
		return nil, err
	}

	var res *result
	err = cn.WithReader(c, stmt.db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		res, err = readExtQueryData(c, rd, model, columns)
		return err
	})
	if err != nil {
		return nil, err
	}

	return res, nil
}

func (stmt *Stmt) closeStmt() error {
	return stmt.withConn(context.TODO(), func(c context.Context, cn *pool.Conn) error {
		return stmt.db.closeStmt(c, cn, stmt.name)
	})
}
