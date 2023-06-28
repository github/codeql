package pg

import (
	"context"
	"errors"
	"io"
	"sync"
	"sync/atomic"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/orm"
)

// ErrTxDone is returned by any operation that is performed on a transaction
// that has already been committed or rolled back.
var ErrTxDone = errors.New("pg: transaction has already been committed or rolled back")

// Tx is an in-progress database transaction. It is safe for concurrent use
// by multiple goroutines.
//
// A transaction must end with a call to Commit or Rollback.
//
// After a call to Commit or Rollback, all operations on the transaction fail
// with ErrTxDone.
//
// The statements prepared for a transaction by calling the transaction's
// Prepare or Stmt methods are closed by the call to Commit or Rollback.
type Tx struct {
	db  *baseDB
	ctx context.Context

	stmtsMu sync.Mutex
	stmts   []*Stmt

	_closed int32
}

var _ orm.DB = (*Tx)(nil)

// Context returns the context.Context of the transaction.
func (tx *Tx) Context() context.Context {
	return tx.ctx
}

// Begin starts a transaction. Most callers should use RunInTransaction instead.
func (db *baseDB) Begin() (*Tx, error) {
	return db.BeginContext(db.db.Context())
}

func (db *baseDB) BeginContext(ctx context.Context) (*Tx, error) {
	tx := &Tx{
		db:  db.withPool(pool.NewStickyConnPool(db.pool)),
		ctx: ctx,
	}

	err := tx.begin(ctx)
	if err != nil {
		tx.close()
		return nil, err
	}

	return tx, nil
}

// RunInTransaction runs a function in a transaction. If function
// returns an error transaction is rolled back, otherwise transaction
// is committed.
func (db *baseDB) RunInTransaction(ctx context.Context, fn func(*Tx) error) error {
	tx, err := db.BeginContext(ctx)
	if err != nil {
		return err
	}
	return tx.RunInTransaction(ctx, fn)
}

// Begin returns current transaction. It does not start new transaction.
func (tx *Tx) Begin() (*Tx, error) {
	return tx, nil
}

// RunInTransaction runs a function in the transaction. If function
// returns an error transaction is rolled back, otherwise transaction
// is committed.
func (tx *Tx) RunInTransaction(ctx context.Context, fn func(*Tx) error) error {
	defer func() {
		if err := recover(); err != nil {
			if err := tx.RollbackContext(ctx); err != nil {
				internal.Logger.Printf(ctx, "tx.Rollback panicked: %s", err)
			}
			panic(err)
		}
	}()

	if err := fn(tx); err != nil {
		if err := tx.RollbackContext(ctx); err != nil {
			internal.Logger.Printf(ctx, "tx.Rollback failed: %s", err)
		}
		return err
	}
	return tx.CommitContext(ctx)
}

func (tx *Tx) withConn(c context.Context, fn func(context.Context, *pool.Conn) error) error {
	err := tx.db.withConn(c, fn)
	if tx.closed() && err == pool.ErrClosed {
		return ErrTxDone
	}
	return err
}

// Stmt returns a transaction-specific prepared statement
// from an existing statement.
func (tx *Tx) Stmt(stmt *Stmt) *Stmt {
	stmt, err := tx.Prepare(stmt.q)
	if err != nil {
		return &Stmt{stickyErr: err}
	}
	return stmt
}

// Prepare creates a prepared statement for use within a transaction.
//
// The returned statement operates within the transaction and can no longer
// be used once the transaction has been committed or rolled back.
//
// To use an existing prepared statement on this transaction, see Tx.Stmt.
func (tx *Tx) Prepare(q string) (*Stmt, error) {
	tx.stmtsMu.Lock()
	defer tx.stmtsMu.Unlock()

	db := tx.db.withPool(pool.NewStickyConnPool(tx.db.pool))
	stmt, err := prepareStmt(db, q)
	if err != nil {
		return nil, err
	}
	tx.stmts = append(tx.stmts, stmt)

	return stmt, nil
}

// Exec is an alias for DB.Exec.
func (tx *Tx) Exec(query interface{}, params ...interface{}) (Result, error) {
	return tx.exec(tx.ctx, query, params...)
}

// ExecContext acts like Exec but additionally receives a context.
func (tx *Tx) ExecContext(c context.Context, query interface{}, params ...interface{}) (Result, error) {
	return tx.exec(c, query, params...)
}

func (tx *Tx) exec(ctx context.Context, query interface{}, params ...interface{}) (Result, error) {
	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, tx.db.fmter, query, params...); err != nil {
		return nil, err
	}

	ctx, evt, err := tx.db.beforeQuery(ctx, tx, nil, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	var res Result
	lastErr := tx.withConn(ctx, func(ctx context.Context, cn *pool.Conn) error {
		res, err = tx.db.simpleQuery(ctx, cn, wb)
		return err
	})

	if err := tx.db.afterQuery(ctx, evt, res, lastErr); err != nil {
		return nil, err
	}
	return res, lastErr
}

// ExecOne is an alias for DB.ExecOne.
func (tx *Tx) ExecOne(query interface{}, params ...interface{}) (Result, error) {
	return tx.execOne(tx.ctx, query, params...)
}

// ExecOneContext acts like ExecOne but additionally receives a context.
func (tx *Tx) ExecOneContext(c context.Context, query interface{}, params ...interface{}) (Result, error) {
	return tx.execOne(c, query, params...)
}

func (tx *Tx) execOne(c context.Context, query interface{}, params ...interface{}) (Result, error) {
	res, err := tx.ExecContext(c, query, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// Query is an alias for DB.Query.
func (tx *Tx) Query(model interface{}, query interface{}, params ...interface{}) (Result, error) {
	return tx.query(tx.ctx, model, query, params...)
}

// QueryContext acts like Query but additionally receives a context.
func (tx *Tx) QueryContext(
	c context.Context,
	model interface{},
	query interface{},
	params ...interface{},
) (Result, error) {
	return tx.query(c, model, query, params...)
}

func (tx *Tx) query(
	ctx context.Context,
	model interface{},
	query interface{},
	params ...interface{},
) (Result, error) {
	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, tx.db.fmter, query, params...); err != nil {
		return nil, err
	}

	ctx, evt, err := tx.db.beforeQuery(ctx, tx, model, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	var res *result
	lastErr := tx.withConn(ctx, func(ctx context.Context, cn *pool.Conn) error {
		res, err = tx.db.simpleQueryData(ctx, cn, model, wb)
		return err
	})

	if err := tx.db.afterQuery(ctx, evt, res, err); err != nil {
		return nil, err
	}
	return res, lastErr
}

// QueryOne is an alias for DB.QueryOne.
func (tx *Tx) QueryOne(model interface{}, query interface{}, params ...interface{}) (Result, error) {
	return tx.queryOne(tx.ctx, model, query, params...)
}

// QueryOneContext acts like QueryOne but additionally receives a context.
func (tx *Tx) QueryOneContext(
	c context.Context,
	model interface{},
	query interface{},
	params ...interface{},
) (Result, error) {
	return tx.queryOne(c, model, query, params...)
}

func (tx *Tx) queryOne(
	c context.Context,
	model interface{},
	query interface{},
	params ...interface{},
) (Result, error) {
	mod, err := orm.NewModel(model)
	if err != nil {
		return nil, err
	}

	res, err := tx.QueryContext(c, mod, query, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// Model is an alias for DB.Model.
func (tx *Tx) Model(model ...interface{}) *Query {
	return orm.NewQuery(tx, model...)
}

// ModelContext acts like Model but additionally receives a context.
func (tx *Tx) ModelContext(c context.Context, model ...interface{}) *Query {
	return orm.NewQueryContext(c, tx, model...)
}

// CopyFrom is an alias for DB.CopyFrom.
func (tx *Tx) CopyFrom(r io.Reader, query interface{}, params ...interface{}) (res Result, err error) {
	err = tx.withConn(tx.ctx, func(c context.Context, cn *pool.Conn) error {
		res, err = tx.db.copyFrom(c, cn, r, query, params...)
		return err
	})
	return res, err
}

// CopyTo is an alias for DB.CopyTo.
func (tx *Tx) CopyTo(w io.Writer, query interface{}, params ...interface{}) (res Result, err error) {
	err = tx.withConn(tx.ctx, func(c context.Context, cn *pool.Conn) error {
		res, err = tx.db.copyTo(c, cn, w, query, params...)
		return err
	})
	return res, err
}

// Formatter is an alias for DB.Formatter.
func (tx *Tx) Formatter() orm.QueryFormatter {
	return tx.db.Formatter()
}

func (tx *Tx) begin(ctx context.Context) error {
	var lastErr error
	for attempt := 0; attempt <= tx.db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			if err := internal.Sleep(ctx, tx.db.retryBackoff(attempt-1)); err != nil {
				return err
			}

			err := tx.db.pool.(*pool.StickyConnPool).Reset(ctx)
			if err != nil {
				return err
			}
		}

		_, lastErr = tx.ExecContext(ctx, "BEGIN")
		if !tx.db.shouldRetry(lastErr) {
			break
		}
	}
	return lastErr
}

func (tx *Tx) Commit() error {
	return tx.CommitContext(tx.ctx)
}

// Commit commits the transaction.
func (tx *Tx) CommitContext(ctx context.Context) error {
	_, err := tx.ExecContext(internal.UndoContext(ctx), "COMMIT")
	tx.close()
	return err
}

func (tx *Tx) Rollback() error {
	return tx.RollbackContext(tx.ctx)
}

// Rollback aborts the transaction.
func (tx *Tx) RollbackContext(ctx context.Context) error {
	_, err := tx.ExecContext(internal.UndoContext(ctx), "ROLLBACK")
	tx.close()
	return err
}

func (tx *Tx) Close() error {
	return tx.CloseContext(tx.ctx)
}

// Close calls Rollback if the tx has not already been committed or rolled back.
func (tx *Tx) CloseContext(ctx context.Context) error {
	if tx.closed() {
		return nil
	}
	return tx.RollbackContext(ctx)
}

func (tx *Tx) close() {
	if !atomic.CompareAndSwapInt32(&tx._closed, 0, 1) {
		return
	}

	tx.stmtsMu.Lock()
	defer tx.stmtsMu.Unlock()

	for _, stmt := range tx.stmts {
		_ = stmt.Close()
	}
	tx.stmts = nil

	_ = tx.db.Close()
}

func (tx *Tx) closed() bool {
	return atomic.LoadInt32(&tx._closed) == 1
}
