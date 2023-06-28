package bun

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/uptrace/bun/dialect"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type UpdateQuery struct {
	whereBaseQuery
	returningQuery
	customValueQuery
	setQuery
	idxHintsQuery

	omitZero bool
}

var _ Query = (*UpdateQuery)(nil)

func NewUpdateQuery(db *DB) *UpdateQuery {
	q := &UpdateQuery{
		whereBaseQuery: whereBaseQuery{
			baseQuery: baseQuery{
				db:   db,
				conn: db.DB,
			},
		},
	}
	return q
}

func (q *UpdateQuery) Conn(db IConn) *UpdateQuery {
	q.setConn(db)
	return q
}

func (q *UpdateQuery) Model(model interface{}) *UpdateQuery {
	q.setModel(model)
	return q
}

func (q *UpdateQuery) Err(err error) *UpdateQuery {
	q.setErr(err)
	return q
}

// Apply calls the fn passing the SelectQuery as an argument.
func (q *UpdateQuery) Apply(fn func(*UpdateQuery) *UpdateQuery) *UpdateQuery {
	if fn != nil {
		return fn(q)
	}
	return q
}

func (q *UpdateQuery) With(name string, query schema.QueryAppender) *UpdateQuery {
	q.addWith(name, query, false)
	return q
}

func (q *UpdateQuery) WithRecursive(name string, query schema.QueryAppender) *UpdateQuery {
	q.addWith(name, query, true)
	return q
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) Table(tables ...string) *UpdateQuery {
	for _, table := range tables {
		q.addTable(schema.UnsafeIdent(table))
	}
	return q
}

func (q *UpdateQuery) TableExpr(query string, args ...interface{}) *UpdateQuery {
	q.addTable(schema.SafeQuery(query, args))
	return q
}

func (q *UpdateQuery) ModelTableExpr(query string, args ...interface{}) *UpdateQuery {
	q.modelTableName = schema.SafeQuery(query, args)
	return q
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) Column(columns ...string) *UpdateQuery {
	for _, column := range columns {
		q.addColumn(schema.UnsafeIdent(column))
	}
	return q
}

func (q *UpdateQuery) ExcludeColumn(columns ...string) *UpdateQuery {
	q.excludeColumn(columns)
	return q
}

func (q *UpdateQuery) Set(query string, args ...interface{}) *UpdateQuery {
	q.addSet(schema.SafeQuery(query, args))
	return q
}

func (q *UpdateQuery) SetColumn(column string, query string, args ...interface{}) *UpdateQuery {
	if q.db.HasFeature(feature.UpdateMultiTable) {
		column = q.table.Alias + "." + column
	}
	q.addSet(schema.SafeQuery(column+" = "+query, args))
	return q
}

// Value overwrites model value for the column.
func (q *UpdateQuery) Value(column string, query string, args ...interface{}) *UpdateQuery {
	if q.table == nil {
		q.err = errNilModel
		return q
	}
	q.addValue(q.table, column, query, args)
	return q
}

func (q *UpdateQuery) OmitZero() *UpdateQuery {
	q.omitZero = true
	return q
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) WherePK(cols ...string) *UpdateQuery {
	q.addWhereCols(cols)
	return q
}

func (q *UpdateQuery) Where(query string, args ...interface{}) *UpdateQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " AND "))
	return q
}

func (q *UpdateQuery) WhereOr(query string, args ...interface{}) *UpdateQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " OR "))
	return q
}

func (q *UpdateQuery) WhereGroup(sep string, fn func(*UpdateQuery) *UpdateQuery) *UpdateQuery {
	saved := q.where
	q.where = nil

	q = fn(q)

	where := q.where
	q.where = saved

	q.addWhereGroup(sep, where)

	return q
}

func (q *UpdateQuery) WhereDeleted() *UpdateQuery {
	q.whereDeleted()
	return q
}

func (q *UpdateQuery) WhereAllWithDeleted() *UpdateQuery {
	q.whereAllWithDeleted()
	return q
}

//------------------------------------------------------------------------------

// Returning adds a RETURNING clause to the query.
//
// To suppress the auto-generated RETURNING clause, use `Returning("NULL")`.
func (q *UpdateQuery) Returning(query string, args ...interface{}) *UpdateQuery {
	q.addReturning(schema.SafeQuery(query, args))
	return q
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) Operation() string {
	return "UPDATE"
}

func (q *UpdateQuery) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}

	fmter = formatterWithModel(fmter, q)

	b, err = q.appendWith(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, "UPDATE "...)

	if fmter.HasFeature(feature.UpdateMultiTable) {
		b, err = q.appendTablesWithAlias(fmter, b)
	} else if fmter.HasFeature(feature.UpdateTableAlias) {
		b, err = q.appendFirstTableWithAlias(fmter, b)
	} else {
		b, err = q.appendFirstTable(fmter, b)
	}
	if err != nil {
		return nil, err
	}

	b, err = q.appendIndexHints(fmter, b)
	if err != nil {
		return nil, err
	}

	b, err = q.mustAppendSet(fmter, b)
	if err != nil {
		return nil, err
	}

	if !fmter.HasFeature(feature.UpdateMultiTable) {
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

	b, err = q.mustAppendWhere(fmter, b, q.hasTableAlias(fmter))
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

func (q *UpdateQuery) mustAppendSet(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	b = append(b, " SET "...)

	if len(q.set) > 0 {
		return q.appendSet(fmter, b)
	}

	if m, ok := q.model.(*mapModel); ok {
		return m.appendSet(fmter, b), nil
	}

	if q.tableModel == nil {
		return nil, errNilModel
	}

	switch model := q.tableModel.(type) {
	case *structTableModel:
		b, err = q.appendSetStruct(fmter, b, model)
		if err != nil {
			return nil, err
		}
	case *sliceTableModel:
		return nil, errors.New("bun: to bulk Update, use CTE and VALUES")
	default:
		return nil, fmt.Errorf("bun: Update does not support %T", q.tableModel)
	}

	return b, nil
}

func (q *UpdateQuery) appendSetStruct(
	fmter schema.Formatter, b []byte, model *structTableModel,
) ([]byte, error) {
	fields, err := q.getDataFields()
	if err != nil {
		return nil, err
	}

	isTemplate := fmter.IsNop()
	pos := len(b)
	for _, f := range fields {
		if f.SkipUpdate() {
			continue
		}

		app, hasValue := q.modelValues[f.Name]

		if !hasValue && q.omitZero && f.HasZeroValue(model.strct) {
			continue
		}

		if len(b) != pos {
			b = append(b, ", "...)
			pos = len(b)
		}

		b = append(b, f.SQLName...)
		b = append(b, " = "...)

		if isTemplate {
			b = append(b, '?')
			continue
		}

		if hasValue {
			b, err = app.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
		} else {
			b = f.AppendValue(fmter, b, model.strct)
		}
	}

	for i, v := range q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}

		b = append(b, v.column...)
		b = append(b, " = "...)

		b, err = v.value.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *UpdateQuery) appendOtherTables(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if !q.hasMultiTables() {
		return b, nil
	}

	b = append(b, " FROM "...)

	b, err = q.whereBaseQuery.appendOtherTables(fmter, b)
	if err != nil {
		return nil, err
	}

	return b, nil
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) Bulk() *UpdateQuery {
	model, ok := q.model.(*sliceTableModel)
	if !ok {
		q.setErr(fmt.Errorf("bun: Bulk requires a slice, got %T", q.model))
		return q
	}

	set, err := q.updateSliceSet(q.db.fmter, model)
	if err != nil {
		q.setErr(err)
		return q
	}

	values := q.db.NewValues(model)
	values.customValueQuery = q.customValueQuery

	return q.With("_data", values).
		Model(model).
		TableExpr("_data").
		Set(set).
		Where(q.updateSliceWhere(q.db.fmter, model))
}

func (q *UpdateQuery) updateSliceSet(
	fmter schema.Formatter, model *sliceTableModel,
) (string, error) {
	fields, err := q.getDataFields()
	if err != nil {
		return "", err
	}

	var b []byte
	pos := len(b)
	for _, field := range fields {
		if field.SkipUpdate() {
			continue
		}
		if len(b) != pos {
			b = append(b, ", "...)
			pos = len(b)
		}
		if fmter.HasFeature(feature.UpdateMultiTable) {
			b = append(b, model.table.SQLAlias...)
			b = append(b, '.')
		}
		b = append(b, field.SQLName...)
		b = append(b, " = _data."...)
		b = append(b, field.SQLName...)
	}
	return internal.String(b), nil
}

func (q *UpdateQuery) updateSliceWhere(fmter schema.Formatter, model *sliceTableModel) string {
	var b []byte
	for i, pk := range model.table.PKs {
		if i > 0 {
			b = append(b, " AND "...)
		}
		if q.hasTableAlias(fmter) {
			b = append(b, model.table.SQLAlias...)
		} else {
			b = append(b, model.table.SQLName...)
		}
		b = append(b, '.')
		b = append(b, pk.SQLName...)
		b = append(b, " = _data."...)
		b = append(b, pk.SQLName...)
	}
	return internal.String(b)
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) Scan(ctx context.Context, dest ...interface{}) error {
	_, err := q.scanOrExec(ctx, dest, true)
	return err
}

func (q *UpdateQuery) Exec(ctx context.Context, dest ...interface{}) (sql.Result, error) {
	return q.scanOrExec(ctx, dest, len(dest) > 0)
}

func (q *UpdateQuery) scanOrExec(
	ctx context.Context, dest []interface{}, hasDest bool,
) (sql.Result, error) {
	if q.err != nil {
		return nil, q.err
	}

	if q.table != nil {
		if err := q.beforeUpdateHook(ctx); err != nil {
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
		if err := q.afterUpdateHook(ctx); err != nil {
			return nil, err
		}
	}

	return res, nil
}

func (q *UpdateQuery) beforeUpdateHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(BeforeUpdateHook); ok {
		if err := hook.BeforeUpdate(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

func (q *UpdateQuery) afterUpdateHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(AfterUpdateHook); ok {
		if err := hook.AfterUpdate(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

// FQN returns a fully qualified column name, for example, table_name.column_name or
// table_alias.column_alias.
func (q *UpdateQuery) FQN(column string) Ident {
	if q.table == nil {
		panic("UpdateQuery.FQN requires a model")
	}
	if q.hasTableAlias(q.db.fmter) {
		return Ident(q.table.Alias + "." + column)
	}
	return Ident(q.table.Name + "." + column)
}

func (q *UpdateQuery) hasTableAlias(fmter schema.Formatter) bool {
	return fmter.HasFeature(feature.UpdateMultiTable | feature.UpdateTableAlias)
}

func (q *UpdateQuery) String() string {
	buf, err := q.AppendQuery(q.db.Formatter(), nil)
	if err != nil {
		panic(err)
	}

	return string(buf)
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) QueryBuilder() QueryBuilder {
	return &updateQueryBuilder{q}
}

func (q *UpdateQuery) ApplyQueryBuilder(fn func(QueryBuilder) QueryBuilder) *UpdateQuery {
	return fn(q.QueryBuilder()).Unwrap().(*UpdateQuery)
}

type updateQueryBuilder struct {
	*UpdateQuery
}

func (q *updateQueryBuilder) WhereGroup(
	sep string, fn func(QueryBuilder) QueryBuilder,
) QueryBuilder {
	q.UpdateQuery = q.UpdateQuery.WhereGroup(sep, func(qs *UpdateQuery) *UpdateQuery {
		return fn(q).(*updateQueryBuilder).UpdateQuery
	})
	return q
}

func (q *updateQueryBuilder) Where(query string, args ...interface{}) QueryBuilder {
	q.UpdateQuery.Where(query, args...)
	return q
}

func (q *updateQueryBuilder) WhereOr(query string, args ...interface{}) QueryBuilder {
	q.UpdateQuery.WhereOr(query, args...)
	return q
}

func (q *updateQueryBuilder) WhereDeleted() QueryBuilder {
	q.UpdateQuery.WhereDeleted()
	return q
}

func (q *updateQueryBuilder) WhereAllWithDeleted() QueryBuilder {
	q.UpdateQuery.WhereAllWithDeleted()
	return q
}

func (q *updateQueryBuilder) WherePK(cols ...string) QueryBuilder {
	q.UpdateQuery.WherePK(cols...)
	return q
}

func (q *updateQueryBuilder) Unwrap() interface{} {
	return q.UpdateQuery
}

//------------------------------------------------------------------------------

func (q *UpdateQuery) UseIndex(indexes ...string) *UpdateQuery {
	if q.db.dialect.Name() == dialect.MySQL {
		q.addUseIndex(indexes...)
	}
	return q
}

func (q *UpdateQuery) IgnoreIndex(indexes ...string) *UpdateQuery {
	if q.db.dialect.Name() == dialect.MySQL {
		q.addIgnoreIndex(indexes...)
	}
	return q
}

func (q *UpdateQuery) ForceIndex(indexes ...string) *UpdateQuery {
	if q.db.dialect.Name() == dialect.MySQL {
		q.addForceIndex(indexes...)
	}
	return q
}
