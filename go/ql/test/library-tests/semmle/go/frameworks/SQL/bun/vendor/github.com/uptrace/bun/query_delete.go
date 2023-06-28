package bun

import (
	"context"
	"database/sql"
	"time"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type DeleteQuery struct {
	whereBaseQuery
	returningQuery
}

var _ Query = (*DeleteQuery)(nil)

func NewDeleteQuery(db *DB) *DeleteQuery {
	q := &DeleteQuery{
		whereBaseQuery: whereBaseQuery{
			baseQuery: baseQuery{
				db:   db,
				conn: db.DB,
			},
		},
	}
	return q
}

func (q *DeleteQuery) Conn(db IConn) *DeleteQuery {
	q.setConn(db)
	return q
}

func (q *DeleteQuery) Model(model interface{}) *DeleteQuery {
	q.setModel(model)
	return q
}

func (q *DeleteQuery) Err(err error) *DeleteQuery {
	q.setErr(err)
	return q
}

// Apply calls the fn passing the DeleteQuery as an argument.
func (q *DeleteQuery) Apply(fn func(*DeleteQuery) *DeleteQuery) *DeleteQuery {
	if fn != nil {
		return fn(q)
	}
	return q
}

func (q *DeleteQuery) With(name string, query schema.QueryAppender) *DeleteQuery {
	q.addWith(name, query, false)
	return q
}

func (q *DeleteQuery) WithRecursive(name string, query schema.QueryAppender) *DeleteQuery {
	q.addWith(name, query, true)
	return q
}

func (q *DeleteQuery) Table(tables ...string) *DeleteQuery {
	for _, table := range tables {
		q.addTable(schema.UnsafeIdent(table))
	}
	return q
}

func (q *DeleteQuery) TableExpr(query string, args ...interface{}) *DeleteQuery {
	q.addTable(schema.SafeQuery(query, args))
	return q
}

func (q *DeleteQuery) ModelTableExpr(query string, args ...interface{}) *DeleteQuery {
	q.modelTableName = schema.SafeQuery(query, args)
	return q
}

//------------------------------------------------------------------------------

func (q *DeleteQuery) WherePK(cols ...string) *DeleteQuery {
	q.addWhereCols(cols)
	return q
}

func (q *DeleteQuery) Where(query string, args ...interface{}) *DeleteQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " AND "))
	return q
}

func (q *DeleteQuery) WhereOr(query string, args ...interface{}) *DeleteQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " OR "))
	return q
}

func (q *DeleteQuery) WhereGroup(sep string, fn func(*DeleteQuery) *DeleteQuery) *DeleteQuery {
	saved := q.where
	q.where = nil

	q = fn(q)

	where := q.where
	q.where = saved

	q.addWhereGroup(sep, where)

	return q
}

func (q *DeleteQuery) WhereDeleted() *DeleteQuery {
	q.whereDeleted()
	return q
}

func (q *DeleteQuery) WhereAllWithDeleted() *DeleteQuery {
	q.whereAllWithDeleted()
	return q
}

func (q *DeleteQuery) ForceDelete() *DeleteQuery {
	q.flags = q.flags.Set(forceDeleteFlag)
	return q
}

//------------------------------------------------------------------------------

// Returning adds a RETURNING clause to the query.
//
// To suppress the auto-generated RETURNING clause, use `Returning("NULL")`.
func (q *DeleteQuery) Returning(query string, args ...interface{}) *DeleteQuery {
	q.addReturning(schema.SafeQuery(query, args))
	return q
}

//------------------------------------------------------------------------------

func (q *DeleteQuery) Operation() string {
	return "DELETE"
}

func (q *DeleteQuery) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}

	fmter = formatterWithModel(fmter, q)

	if q.isSoftDelete() {
		now := time.Now()

		if err := q.tableModel.updateSoftDeleteField(now); err != nil {
			return nil, err
		}

		upd := &UpdateQuery{
			whereBaseQuery: q.whereBaseQuery,
			returningQuery: q.returningQuery,
		}
		upd.Set(q.softDeleteSet(fmter, now))

		return upd.AppendQuery(fmter, b)
	}

	withAlias := q.db.features.Has(feature.DeleteTableAlias)

	b, err = q.appendWith(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, "DELETE FROM "...)

	if withAlias {
		b, err = q.appendFirstTableWithAlias(fmter, b)
	} else {
		b, err = q.appendFirstTable(fmter, b)
	}
	if err != nil {
		return nil, err
	}

	if q.hasMultiTables() {
		b = append(b, " USING "...)
		b, err = q.appendOtherTables(fmter, b)
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

	b, err = q.mustAppendWhere(fmter, b, withAlias)
	if err != nil {
		return nil, err
	}

	if q.hasFeature(feature.Returning) && q.hasReturning() {
		b = append(b, " RETURNING "...)
		b, err = q.appendReturning(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *DeleteQuery) isSoftDelete() bool {
	return q.tableModel != nil && q.table.SoftDeleteField != nil && !q.flags.Has(forceDeleteFlag)
}

func (q *DeleteQuery) softDeleteSet(fmter schema.Formatter, tm time.Time) string {
	b := make([]byte, 0, 32)
	if fmter.HasFeature(feature.UpdateMultiTable) {
		b = append(b, q.table.SQLAlias...)
		b = append(b, '.')
	}
	b = append(b, q.table.SoftDeleteField.SQLName...)
	b = append(b, " = "...)
	b = schema.Append(fmter, b, tm)
	return internal.String(b)
}

//------------------------------------------------------------------------------

func (q *DeleteQuery) Scan(ctx context.Context, dest ...interface{}) error {
	_, err := q.scanOrExec(ctx, dest, true)
	return err
}

func (q *DeleteQuery) Exec(ctx context.Context, dest ...interface{}) (sql.Result, error) {
	return q.scanOrExec(ctx, dest, len(dest) > 0)
}

func (q *DeleteQuery) scanOrExec(
	ctx context.Context, dest []interface{}, hasDest bool,
) (sql.Result, error) {
	if q.err != nil {
		return nil, q.err
	}

	if q.table != nil {
		if err := q.beforeDeleteHook(ctx); err != nil {
			return nil, err
		}
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

	useScan := hasDest || (q.hasReturning() && q.hasFeature(feature.Returning|feature.Output))
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
		res, err = q.scan(ctx, q, query, model, hasDest)
		if err != nil {
			return nil, err
		}
	} else {
		res, err = q.exec(ctx, q, query)
		if err != nil {
			return nil, err
		}
	}

	if q.table != nil {
		if err := q.afterDeleteHook(ctx); err != nil {
			return nil, err
		}
	}

	return res, nil
}

func (q *DeleteQuery) beforeDeleteHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(BeforeDeleteHook); ok {
		if err := hook.BeforeDelete(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

func (q *DeleteQuery) afterDeleteHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(AfterDeleteHook); ok {
		if err := hook.AfterDelete(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

func (q *DeleteQuery) String() string {
	buf, err := q.AppendQuery(q.db.Formatter(), nil)
	if err != nil {
		panic(err)
	}

	return string(buf)
}

//------------------------------------------------------------------------------

func (q *DeleteQuery) QueryBuilder() QueryBuilder {
	return &deleteQueryBuilder{q}
}

func (q *DeleteQuery) ApplyQueryBuilder(fn func(QueryBuilder) QueryBuilder) *DeleteQuery {
	return fn(q.QueryBuilder()).Unwrap().(*DeleteQuery)
}

type deleteQueryBuilder struct {
	*DeleteQuery
}

func (q *deleteQueryBuilder) WhereGroup(
	sep string, fn func(QueryBuilder) QueryBuilder,
) QueryBuilder {
	q.DeleteQuery = q.DeleteQuery.WhereGroup(sep, func(qs *DeleteQuery) *DeleteQuery {
		return fn(q).(*deleteQueryBuilder).DeleteQuery
	})
	return q
}

func (q *deleteQueryBuilder) Where(query string, args ...interface{}) QueryBuilder {
	q.DeleteQuery.Where(query, args...)
	return q
}

func (q *deleteQueryBuilder) WhereOr(query string, args ...interface{}) QueryBuilder {
	q.DeleteQuery.WhereOr(query, args...)
	return q
}

func (q *deleteQueryBuilder) WhereDeleted() QueryBuilder {
	q.DeleteQuery.WhereDeleted()
	return q
}

func (q *deleteQueryBuilder) WhereAllWithDeleted() QueryBuilder {
	q.DeleteQuery.WhereAllWithDeleted()
	return q
}

func (q *deleteQueryBuilder) WherePK(cols ...string) QueryBuilder {
	q.DeleteQuery.WherePK(cols...)
	return q
}

func (q *deleteQueryBuilder) Unwrap() interface{} {
	return q.DeleteQuery
}
