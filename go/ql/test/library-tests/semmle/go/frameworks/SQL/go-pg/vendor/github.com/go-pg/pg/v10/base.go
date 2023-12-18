package pg

import (
	"context"
	"io"
	"time"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/orm"
	"github.com/go-pg/pg/v10/types"
)

type baseDB struct {
	db   orm.DB
	opt  *Options
	pool pool.Pooler

	fmter      *orm.Formatter
	queryHooks []QueryHook
}

// PoolStats contains the stats of a connection pool.
type PoolStats pool.Stats

// PoolStats returns connection pool stats.
func (db *baseDB) PoolStats() *PoolStats {
	stats := db.pool.Stats()
	return (*PoolStats)(stats)
}

func (db *baseDB) clone() *baseDB {
	return &baseDB{
		db:   db.db,
		opt:  db.opt,
		pool: db.pool,

		fmter:      db.fmter,
		queryHooks: copyQueryHooks(db.queryHooks),
	}
}

func (db *baseDB) withPool(p pool.Pooler) *baseDB {
	cp := db.clone()
	cp.pool = p
	return cp
}

func (db *baseDB) WithTimeout(d time.Duration) *baseDB {
	newopt := *db.opt
	newopt.ReadTimeout = d
	newopt.WriteTimeout = d

	cp := db.clone()
	cp.opt = &newopt
	return cp
}

func (db *baseDB) WithParam(param string, value interface{}) *baseDB {
	cp := db.clone()
	cp.fmter = db.fmter.WithParam(param, value)
	return cp
}

// Param returns value for the param.
func (db *baseDB) Param(param string) interface{} {
	return db.fmter.Param(param)
}

func (db *baseDB) retryBackoff(retry int) time.Duration {
	return internal.RetryBackoff(retry, db.opt.MinRetryBackoff, db.opt.MaxRetryBackoff)
}

func (db *baseDB) getConn(ctx context.Context) (*pool.Conn, error) {
	cn, err := db.pool.Get(ctx)
	if err != nil {
		return nil, err
	}

	if cn.Inited {
		return cn, nil
	}

	if err := db.initConn(ctx, cn); err != nil {
		db.pool.Remove(ctx, cn, err)
		// It is safe to reset StickyConnPool if conn can't be initialized.
		if p, ok := db.pool.(*pool.StickyConnPool); ok {
			_ = p.Reset(ctx)
		}
		if err := internal.Unwrap(err); err != nil {
			return nil, err
		}
		return nil, err
	}

	return cn, nil
}

func (db *baseDB) initConn(ctx context.Context, cn *pool.Conn) error {
	if cn.Inited {
		return nil
	}
	cn.Inited = true

	if db.opt.TLSConfig != nil {
		err := db.enableSSL(ctx, cn, db.opt.TLSConfig)
		if err != nil {
			return err
		}
	}

	err := db.startup(ctx, cn, db.opt.User, db.opt.Password, db.opt.Database, db.opt.ApplicationName)
	if err != nil {
		return err
	}

	if db.opt.OnConnect != nil {
		p := pool.NewSingleConnPool(db.pool, cn)
		return db.opt.OnConnect(ctx, newConn(ctx, db.withPool(p)))
	}

	return nil
}

func (db *baseDB) releaseConn(ctx context.Context, cn *pool.Conn, err error) {
	if bad, code := isBadConn(err, false); bad {
		if code != "25P02" { // canceling statement if it is a bad conn expect 25P02 (current transaction is aborted)
			err := db.cancelRequest(cn.ProcessID, cn.SecretKey)
			if err != nil {
				internal.Logger.Printf(ctx, "cancelRequest failed: %s", err)
			}
		}
		db.pool.Remove(ctx, cn, err)
	} else {
		db.pool.Put(ctx, cn)
	}
}

func (db *baseDB) withConn(
	ctx context.Context, fn func(context.Context, *pool.Conn) error,
) error {
	cn, err := db.getConn(ctx)
	if err != nil {
		return err
	}

	var fnDone chan struct{}
	if ctx != nil && ctx.Done() != nil {
		fnDone = make(chan struct{})
		go func() {
			select {
			case <-fnDone: // fn has finished, skip cancel
			case <-ctx.Done():
				err := db.cancelRequest(cn.ProcessID, cn.SecretKey)
				if err != nil {
					internal.Logger.Printf(ctx, "cancelRequest failed: %s", err)
				}
				// Signal end of conn use.
				fnDone <- struct{}{}
			}
		}()
	}

	defer func() {
		if fnDone == nil {
			db.releaseConn(ctx, cn, err)
			return
		}

		select {
		case <-fnDone: // wait for cancel to finish request
			// Looks like the canceled connection must be always removed from the pool.
			db.pool.Remove(ctx, cn, err)
		case fnDone <- struct{}{}: // signal fn finish, skip cancel goroutine
			db.releaseConn(ctx, cn, err)
		}
	}()

	err = fn(ctx, cn)
	return err
}

func (db *baseDB) shouldRetry(err error) bool {
	switch err {
	case io.EOF, io.ErrUnexpectedEOF:
		return true
	case nil, context.Canceled, context.DeadlineExceeded:
		return false
	}

	if pgerr, ok := err.(Error); ok {
		switch pgerr.Field('C') {
		case "40001", // serialization_failure
			"53300", // too_many_connections
			"55000": // attempted to delete invisible tuple
			return true
		case "57014": // statement_timeout
			return db.opt.RetryStatementTimeout
		default:
			return false
		}
	}

	if _, ok := err.(timeoutError); ok {
		return true
	}

	return false
}

// Close closes the database client, releasing any open resources.
//
// It is rare to Close a DB, as the DB handle is meant to be
// long-lived and shared between many goroutines.
func (db *baseDB) Close() error {
	return db.pool.Close()
}

// Exec executes a query ignoring returned rows. The params are for any
// placeholders in the query.
func (db *baseDB) Exec(query interface{}, params ...interface{}) (res Result, err error) {
	return db.exec(db.db.Context(), query, params...)
}

func (db *baseDB) ExecContext(c context.Context, query interface{}, params ...interface{}) (Result, error) {
	return db.exec(c, query, params...)
}

func (db *baseDB) exec(ctx context.Context, query interface{}, params ...interface{}) (Result, error) {
	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, db.fmter, query, params...); err != nil {
		return nil, err
	}

	ctx, evt, err := db.beforeQuery(ctx, db.db, nil, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	var res Result
	var lastErr error
	for attempt := 0; attempt <= db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			if err := internal.Sleep(ctx, db.retryBackoff(attempt-1)); err != nil {
				return nil, err
			}
		}

		lastErr = db.withConn(ctx, func(ctx context.Context, cn *pool.Conn) error {
			res, err = db.simpleQuery(ctx, cn, wb)
			return err
		})
		if !db.shouldRetry(lastErr) {
			break
		}
	}

	if err := db.afterQuery(ctx, evt, res, lastErr); err != nil {
		return nil, err
	}
	return res, lastErr
}

// ExecOne acts like Exec, but query must affect only one row. It
// returns ErrNoRows error when query returns zero rows or
// ErrMultiRows when query returns multiple rows.
func (db *baseDB) ExecOne(query interface{}, params ...interface{}) (Result, error) {
	return db.execOne(db.db.Context(), query, params...)
}

func (db *baseDB) ExecOneContext(ctx context.Context, query interface{}, params ...interface{}) (Result, error) {
	return db.execOne(ctx, query, params...)
}

func (db *baseDB) execOne(c context.Context, query interface{}, params ...interface{}) (Result, error) {
	res, err := db.ExecContext(c, query, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// Query executes a query that returns rows, typically a SELECT.
// The params are for any placeholders in the query.
func (db *baseDB) Query(model, query interface{}, params ...interface{}) (res Result, err error) {
	return db.query(db.db.Context(), model, query, params...)
}

func (db *baseDB) QueryContext(c context.Context, model, query interface{}, params ...interface{}) (Result, error) {
	return db.query(c, model, query, params...)
}

func (db *baseDB) query(ctx context.Context, model, query interface{}, params ...interface{}) (Result, error) {
	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, db.fmter, query, params...); err != nil {
		return nil, err
	}

	ctx, evt, err := db.beforeQuery(ctx, db.db, model, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	var res Result
	var lastErr error
	for attempt := 0; attempt <= db.opt.MaxRetries; attempt++ {
		if attempt > 0 {
			if err := internal.Sleep(ctx, db.retryBackoff(attempt-1)); err != nil {
				return nil, err
			}
		}

		lastErr = db.withConn(ctx, func(ctx context.Context, cn *pool.Conn) error {
			res, err = db.simpleQueryData(ctx, cn, model, wb)
			return err
		})
		if !db.shouldRetry(lastErr) {
			break
		}
	}

	if err := db.afterQuery(ctx, evt, res, lastErr); err != nil {
		return nil, err
	}
	return res, lastErr
}

// QueryOne acts like Query, but query must return only one row. It
// returns ErrNoRows error when query returns zero rows or
// ErrMultiRows when query returns multiple rows.
func (db *baseDB) QueryOne(model, query interface{}, params ...interface{}) (Result, error) {
	return db.queryOne(db.db.Context(), model, query, params...)
}

func (db *baseDB) QueryOneContext(
	ctx context.Context, model, query interface{}, params ...interface{},
) (Result, error) {
	return db.queryOne(ctx, model, query, params...)
}

func (db *baseDB) queryOne(ctx context.Context, model, query interface{}, params ...interface{}) (Result, error) {
	res, err := db.QueryContext(ctx, model, query, params...)
	if err != nil {
		return nil, err
	}

	if err := internal.AssertOneRow(res.RowsAffected()); err != nil {
		return nil, err
	}
	return res, nil
}

// CopyFrom copies data from reader to a table.
func (db *baseDB) CopyFrom(r io.Reader, query interface{}, params ...interface{}) (res Result, err error) {
	c := db.db.Context()
	err = db.withConn(c, func(c context.Context, cn *pool.Conn) error {
		res, err = db.copyFrom(c, cn, r, query, params...)
		return err
	})
	return res, err
}

// TODO: don't get/put conn in the pool.
func (db *baseDB) copyFrom(
	ctx context.Context, cn *pool.Conn, r io.Reader, query interface{}, params ...interface{},
) (res Result, err error) {
	var evt *QueryEvent

	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, db.fmter, query, params...); err != nil {
		return nil, err
	}

	var model interface{}
	if len(params) > 0 {
		model, _ = params[len(params)-1].(orm.TableModel)
	}

	ctx, evt, err = db.beforeQuery(ctx, db.db, model, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	// Note that afterQuery uses the err.
	defer func() {
		if afterQueryErr := db.afterQuery(ctx, evt, res, err); afterQueryErr != nil {
			err = afterQueryErr
		}
	}()

	err = cn.WithWriter(ctx, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		return writeQueryMsg(wb, db.fmter, query, params...)
	})
	if err != nil {
		return nil, err
	}

	err = cn.WithReader(ctx, db.opt.ReadTimeout, readCopyInResponse)
	if err != nil {
		return nil, err
	}

	for {
		err = cn.WithWriter(ctx, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
			return writeCopyData(wb, r)
		})
		if err != nil {
			if err == io.EOF {
				break
			}
			return nil, err
		}
	}

	err = cn.WithWriter(ctx, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeCopyDone(wb)
		return nil
	})
	if err != nil {
		return nil, err
	}

	err = cn.WithReader(ctx, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		res, err = readReadyForQuery(rd)
		return err
	})
	if err != nil {
		return nil, err
	}

	return res, nil
}

// CopyTo copies data from a table to writer.
func (db *baseDB) CopyTo(w io.Writer, query interface{}, params ...interface{}) (res Result, err error) {
	c := db.db.Context()
	err = db.withConn(c, func(c context.Context, cn *pool.Conn) error {
		res, err = db.copyTo(c, cn, w, query, params...)
		return err
	})
	return res, err
}

func (db *baseDB) copyTo(
	ctx context.Context, cn *pool.Conn, w io.Writer, query interface{}, params ...interface{},
) (res Result, err error) {
	var evt *QueryEvent

	wb := pool.GetWriteBuffer()
	defer pool.PutWriteBuffer(wb)

	if err := writeQueryMsg(wb, db.fmter, query, params...); err != nil {
		return nil, err
	}

	var model interface{}
	if len(params) > 0 {
		model, _ = params[len(params)-1].(orm.TableModel)
	}

	ctx, evt, err = db.beforeQuery(ctx, db.db, model, query, params, wb.Query())
	if err != nil {
		return nil, err
	}

	// Note that afterQuery uses the err.
	defer func() {
		if afterQueryErr := db.afterQuery(ctx, evt, res, err); afterQueryErr != nil {
			err = afterQueryErr
		}
	}()

	err = cn.WithWriter(ctx, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		return writeQueryMsg(wb, db.fmter, query, params...)
	})
	if err != nil {
		return nil, err
	}

	err = cn.WithReader(ctx, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		err := readCopyOutResponse(rd)
		if err != nil {
			return err
		}

		res, err = readCopyData(rd, w)
		return err
	})
	if err != nil {
		return nil, err
	}

	return res, nil
}

// Ping verifies a connection to the database is still alive,
// establishing a connection if necessary.
func (db *baseDB) Ping(ctx context.Context) error {
	_, err := db.ExecContext(ctx, "SELECT 1")
	return err
}

// Model returns new query for the model.
func (db *baseDB) Model(model ...interface{}) *Query {
	return orm.NewQuery(db.db, model...)
}

func (db *baseDB) ModelContext(c context.Context, model ...interface{}) *Query {
	return orm.NewQueryContext(c, db.db, model...)
}

func (db *baseDB) Formatter() orm.QueryFormatter {
	return db.fmter
}

func (db *baseDB) cancelRequest(processID, secretKey int32) error {
	c := context.TODO()

	cn, err := db.pool.NewConn(c)
	if err != nil {
		return err
	}
	defer func() {
		_ = db.pool.CloseConn(cn)
	}()

	return cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeCancelRequestMsg(wb, processID, secretKey)
		return nil
	})
}

func (db *baseDB) simpleQuery(
	c context.Context, cn *pool.Conn, wb *pool.WriteBuffer,
) (*result, error) {
	if err := cn.WriteBuffer(c, db.opt.WriteTimeout, wb); err != nil {
		return nil, err
	}

	var res *result
	if err := cn.WithReader(c, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		var err error
		res, err = readSimpleQuery(rd)
		return err
	}); err != nil {
		return nil, err
	}

	return res, nil
}

func (db *baseDB) simpleQueryData(
	c context.Context, cn *pool.Conn, model interface{}, wb *pool.WriteBuffer,
) (*result, error) {
	if err := cn.WriteBuffer(c, db.opt.WriteTimeout, wb); err != nil {
		return nil, err
	}

	var res *result
	if err := cn.WithReader(c, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		var err error
		res, err = readSimpleQueryData(c, rd, model)
		return err
	}); err != nil {
		return nil, err
	}

	return res, nil
}

// Prepare creates a prepared statement for later queries or
// executions. Multiple queries or executions may be run concurrently
// from the returned statement.
func (db *baseDB) Prepare(q string) (*Stmt, error) {
	return prepareStmt(db.withPool(pool.NewStickyConnPool(db.pool)), q)
}

func (db *baseDB) prepare(
	c context.Context, cn *pool.Conn, q string,
) (string, []types.ColumnInfo, error) {
	name := cn.NextID()
	err := cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeParseDescribeSyncMsg(wb, name, q)
		return nil
	})
	if err != nil {
		return "", nil, err
	}

	var columns []types.ColumnInfo
	err = cn.WithReader(c, db.opt.ReadTimeout, func(rd *pool.ReaderContext) error {
		columns, err = readParseDescribeSync(rd)
		return err
	})
	if err != nil {
		return "", nil, err
	}

	return name, columns, nil
}

func (db *baseDB) closeStmt(c context.Context, cn *pool.Conn, name string) error {
	err := cn.WithWriter(c, db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		writeCloseMsg(wb, name)
		writeFlushMsg(wb)
		return nil
	})
	if err != nil {
		return err
	}

	err = cn.WithReader(c, db.opt.ReadTimeout, readCloseCompleteMsg)
	return err
}
