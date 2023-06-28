package bun

import (
	"context"
	"database/sql"
	"errors"

	"github.com/uptrace/bun/dialect"
	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type MergeQuery struct {
	baseQuery
	returningQuery

	using schema.QueryWithArgs
	on    schema.QueryWithArgs
	when  []schema.QueryAppender
}

var _ Query = (*MergeQuery)(nil)

func NewMergeQuery(db *DB) *MergeQuery {
	q := &MergeQuery{
		baseQuery: baseQuery{
			db:   db,
			conn: db.DB,
		},
	}
	if !(q.db.dialect.Name() == dialect.MSSQL || q.db.dialect.Name() == dialect.PG) {
		q.err = errors.New("bun: merge not supported for current dialect")
	}
	return q
}

func (q *MergeQuery) Conn(db IConn) *MergeQuery {
	q.setConn(db)
	return q
}

func (q *MergeQuery) Model(model interface{}) *MergeQuery {
	q.setModel(model)
	return q
}

func (q *MergeQuery) Err(err error) *MergeQuery {
	q.setErr(err)
	return q
}

// Apply calls the fn passing the MergeQuery as an argument.
func (q *MergeQuery) Apply(fn func(*MergeQuery) *MergeQuery) *MergeQuery {
	if fn != nil {
		return fn(q)
	}
	return q
}

func (q *MergeQuery) With(name string, query schema.QueryAppender) *MergeQuery {
	q.addWith(name, query, false)
	return q
}

func (q *MergeQuery) WithRecursive(name string, query schema.QueryAppender) *MergeQuery {
	q.addWith(name, query, true)
	return q
}

//------------------------------------------------------------------------------

func (q *MergeQuery) Table(tables ...string) *MergeQuery {
	for _, table := range tables {
		q.addTable(schema.UnsafeIdent(table))
	}
	return q
}

func (q *MergeQuery) TableExpr(query string, args ...interface{}) *MergeQuery {
	q.addTable(schema.SafeQuery(query, args))
	return q
}

func (q *MergeQuery) ModelTableExpr(query string, args ...interface{}) *MergeQuery {
	q.modelTableName = schema.SafeQuery(query, args)
	return q
}

//------------------------------------------------------------------------------

// Returning adds a RETURNING clause to the query.
//
// To suppress the auto-generated RETURNING clause, use `Returning("NULL")`.
// Only for mssql output, postgres not supported returning in merge query
func (q *MergeQuery) Returning(query string, args ...interface{}) *MergeQuery {
	q.addReturning(schema.SafeQuery(query, args))
	return q
}

//------------------------------------------------------------------------------

func (q *MergeQuery) Using(s string, args ...interface{}) *MergeQuery {
	q.using = schema.SafeQuery(s, args)
	return q
}

func (q *MergeQuery) On(s string, args ...interface{}) *MergeQuery {
	q.on = schema.SafeQuery(s, args)
	return q
}

// WhenInsert for when insert clause.
func (q *MergeQuery) WhenInsert(expr string, fn func(q *InsertQuery) *InsertQuery) *MergeQuery {
	sq := NewInsertQuery(q.db)
	// apply the model as default into sub query, since appendColumnsValues required
	if q.model != nil {
		sq = sq.Model(q.model)
	}
	sq = sq.Apply(fn)
	q.when = append(q.when, &whenInsert{expr: expr, query: sq})
	return q
}

// WhenUpdate for when update clause.
func (q *MergeQuery) WhenUpdate(expr string, fn func(q *UpdateQuery) *UpdateQuery) *MergeQuery {
	sq := NewUpdateQuery(q.db)
	// apply the model as default into sub query
	if q.model != nil {
		sq = sq.Model(q.model)
	}
	sq = sq.Apply(fn)
	q.when = append(q.when, &whenUpdate{expr: expr, query: sq})
	return q
}

// WhenDelete for when delete clause.
func (q *MergeQuery) WhenDelete(expr string) *MergeQuery {
	q.when = append(q.when, &whenDelete{expr: expr})
	return q
}

// When for raw expression clause.
func (q *MergeQuery) When(expr string, args ...interface{}) *MergeQuery {
	q.when = append(q.when, schema.SafeQuery(expr, args))
	return q
}

//------------------------------------------------------------------------------

func (q *MergeQuery) Operation() string {
	return "MERGE"
}

func (q *MergeQuery) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}

	fmter = formatterWithModel(fmter, q)

	b, err = q.appendWith(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, "MERGE "...)
	if q.db.dialect.Name() == dialect.PG {
		b = append(b, "INTO "...)
	}

	b, err = q.appendFirstTableWithAlias(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, " USING "...)
	b, err = q.using.AppendQuery(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, " ON "...)
	b, err = q.on.AppendQuery(fmter, b)
	if err != nil {
		return nil, err
	}

	for _, w := range q.when {
		b = append(b, " WHEN "...)
		b, err = w.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	if q.hasFeature(feature.Output) && q.hasReturning() {
		b = append(b, " OUTPUT "...)
		b, err = q.appendOutput(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	// A MERGE statement must be terminated by a semi-colon (;).
	b = append(b, ";"...)

	return b, nil
}

//------------------------------------------------------------------------------

func (q *MergeQuery) Scan(ctx context.Context, dest ...interface{}) error {
	_, err := q.scanOrExec(ctx, dest, true)
	return err
}

func (q *MergeQuery) Exec(ctx context.Context, dest ...interface{}) (sql.Result, error) {
	return q.scanOrExec(ctx, dest, len(dest) > 0)
}

func (q *MergeQuery) scanOrExec(
	ctx context.Context, dest []interface{}, hasDest bool,
) (sql.Result, error) {
	if q.err != nil {
		return nil, q.err
	}

	// Run append model hooks before generating the query.
	if err := q.beforeAppendModel(ctx, q); err != nil {
		return nil, err
	}

	// Generate the query before checking hasReturning.
	queryBytes, err := q.AppendQuery(q.db.fmter, q.db.makeQueryBytes())
	if err != nil {
		return nil, err
	}

	useScan := hasDest || (q.hasReturning() && q.hasFeature(feature.InsertReturning|feature.Output))
	var model Model

	if useScan {
		var err error
		model, err = q.getModel(dest)
		if err != nil {
			return nil, err
		}
	}

	query := internal.String(queryBytes)
	var res sql.Result

	if useScan {
		res, err = q.scan(ctx, q, query, model, true)
		if err != nil {
			return nil, err
		}
	} else {
		res, err = q.exec(ctx, q, query)
		if err != nil {
			return nil, err
		}
	}

	return res, nil
}

func (q *MergeQuery) String() string {
	buf, err := q.AppendQuery(q.db.Formatter(), nil)
	if err != nil {
		panic(err)
	}

	return string(buf)
}

//------------------------------------------------------------------------------

type whenInsert struct {
	expr  string
	query *InsertQuery
}

func (w *whenInsert) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	b = append(b, w.expr...)
	if w.query != nil {
		b = append(b, " THEN INSERT"...)
		b, err = w.query.appendColumnsValues(fmter, b, true)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

type whenUpdate struct {
	expr  string
	query *UpdateQuery
}

func (w *whenUpdate) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	b = append(b, w.expr...)
	if w.query != nil {
		b = append(b, " THEN UPDATE SET "...)
		b, err = w.query.appendSet(fmter, b)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

type whenDelete struct {
	expr string
}

func (w *whenDelete) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	b = append(b, w.expr...)
	b = append(b, " THEN DELETE"...)
	return b, nil
}
