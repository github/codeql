package bun

import (
	"context"
	"database/sql"
	"fmt"
	"reflect"
	"strings"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type InsertQuery struct {
	whereBaseQuery
	returningQuery
	customValueQuery

	on schema.QueryWithArgs
	setQuery

	ignore  bool
	replace bool
}

var _ Query = (*InsertQuery)(nil)

func NewInsertQuery(db *DB) *InsertQuery {
	q := &InsertQuery{
		whereBaseQuery: whereBaseQuery{
			baseQuery: baseQuery{
				db:   db,
				conn: db.DB,
			},
		},
	}
	return q
}

func (q *InsertQuery) Conn(db IConn) *InsertQuery {
	q.setConn(db)
	return q
}

func (q *InsertQuery) Model(model interface{}) *InsertQuery {
	q.setModel(model)
	return q
}

func (q *InsertQuery) Err(err error) *InsertQuery {
	q.setErr(err)
	return q
}

// Apply calls the fn passing the SelectQuery as an argument.
func (q *InsertQuery) Apply(fn func(*InsertQuery) *InsertQuery) *InsertQuery {
	if fn != nil {
		return fn(q)
	}
	return q
}

func (q *InsertQuery) With(name string, query schema.QueryAppender) *InsertQuery {
	q.addWith(name, query, false)
	return q
}

func (q *InsertQuery) WithRecursive(name string, query schema.QueryAppender) *InsertQuery {
	q.addWith(name, query, true)
	return q
}

//------------------------------------------------------------------------------

func (q *InsertQuery) Table(tables ...string) *InsertQuery {
	for _, table := range tables {
		q.addTable(schema.UnsafeIdent(table))
	}
	return q
}

func (q *InsertQuery) TableExpr(query string, args ...interface{}) *InsertQuery {
	q.addTable(schema.SafeQuery(query, args))
	return q
}

func (q *InsertQuery) ModelTableExpr(query string, args ...interface{}) *InsertQuery {
	q.modelTableName = schema.SafeQuery(query, args)
	return q
}

//------------------------------------------------------------------------------

func (q *InsertQuery) Column(columns ...string) *InsertQuery {
	for _, column := range columns {
		q.addColumn(schema.UnsafeIdent(column))
	}
	return q
}

func (q *InsertQuery) ColumnExpr(query string, args ...interface{}) *InsertQuery {
	q.addColumn(schema.SafeQuery(query, args))
	return q
}

func (q *InsertQuery) ExcludeColumn(columns ...string) *InsertQuery {
	q.excludeColumn(columns)
	return q
}

// Value overwrites model value for the column.
func (q *InsertQuery) Value(column string, expr string, args ...interface{}) *InsertQuery {
	if q.table == nil {
		q.err = errNilModel
		return q
	}
	q.addValue(q.table, column, expr, args)
	return q
}

func (q *InsertQuery) Where(query string, args ...interface{}) *InsertQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " AND "))
	return q
}

func (q *InsertQuery) WhereOr(query string, args ...interface{}) *InsertQuery {
	q.addWhere(schema.SafeQueryWithSep(query, args, " OR "))
	return q
}

//------------------------------------------------------------------------------

// Returning adds a RETURNING clause to the query.
//
// To suppress the auto-generated RETURNING clause, use `Returning("")`.
func (q *InsertQuery) Returning(query string, args ...interface{}) *InsertQuery {
	q.addReturning(schema.SafeQuery(query, args))
	return q
}

//------------------------------------------------------------------------------

// Ignore generates different queries depending on the DBMS:
//   - On MySQL, it generates `INSERT IGNORE INTO`.
//   - On PostgreSQL, it generates `ON CONFLICT DO NOTHING`.
func (q *InsertQuery) Ignore() *InsertQuery {
	if q.db.fmter.HasFeature(feature.InsertOnConflict) {
		return q.On("CONFLICT DO NOTHING")
	}
	if q.db.fmter.HasFeature(feature.InsertIgnore) {
		q.ignore = true
	}
	return q
}

// Replaces generates a `REPLACE INTO` query (MySQL and MariaDB).
func (q *InsertQuery) Replace() *InsertQuery {
	q.replace = true
	return q
}

//------------------------------------------------------------------------------

func (q *InsertQuery) Operation() string {
	return "INSERT"
}

func (q *InsertQuery) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}

	fmter = formatterWithModel(fmter, q)

	b, err = q.appendWith(fmter, b)
	if err != nil {
		return nil, err
	}

	if q.replace {
		b = append(b, "REPLACE "...)
	} else {
		b = append(b, "INSERT "...)
		if q.ignore {
			b = append(b, "IGNORE "...)
		}
	}
	b = append(b, "INTO "...)

	if q.db.features.Has(feature.InsertTableAlias) && !q.on.IsZero() {
		b, err = q.appendFirstTableWithAlias(fmter, b)
	} else {
		b, err = q.appendFirstTable(fmter, b)
	}
	if err != nil {
		return nil, err
	}

	b, err = q.appendColumnsValues(fmter, b, false)
	if err != nil {
		return nil, err
	}

	b, err = q.appendOn(fmter, b)
	if err != nil {
		return nil, err
	}

	if q.hasFeature(feature.InsertReturning) && q.hasReturning() {
		b = append(b, " RETURNING "...)
		b, err = q.appendReturning(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) appendColumnsValues(
	fmter schema.Formatter, b []byte, skipOutput bool,
) (_ []byte, err error) {
	if q.hasMultiTables() {
		if q.columns != nil {
			b = append(b, " ("...)
			b, err = q.appendColumns(fmter, b)
			if err != nil {
				return nil, err
			}
			b = append(b, ")"...)
		}

		if q.hasFeature(feature.Output) && q.hasReturning() {
			b = append(b, " OUTPUT "...)
			b, err = q.appendOutput(fmter, b)
			if err != nil {
				return nil, err
			}
		}

		b = append(b, " SELECT "...)

		if q.columns != nil {
			b, err = q.appendColumns(fmter, b)
			if err != nil {
				return nil, err
			}
		} else {
			b = append(b, "*"...)
		}

		b = append(b, " FROM "...)
		b, err = q.appendOtherTables(fmter, b)
		if err != nil {
			return nil, err
		}

		return b, nil
	}

	if m, ok := q.model.(*mapModel); ok {
		return m.appendColumnsValues(fmter, b), nil
	}
	if _, ok := q.model.(*mapSliceModel); ok {
		return nil, fmt.Errorf("Insert(*[]map[string]interface{}) is not supported")
	}

	if q.model == nil {
		return nil, errNilModel
	}

	// Build fields to populate RETURNING clause.
	fields, err := q.getFields()
	if err != nil {
		return nil, err
	}

	b = append(b, " ("...)
	b = q.appendFields(fmter, b, fields)
	b = append(b, ")"...)

	if q.hasFeature(feature.Output) && q.hasReturning() && !skipOutput {
		b = append(b, " OUTPUT "...)
		b, err = q.appendOutput(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	b = append(b, " VALUES ("...)

	switch model := q.tableModel.(type) {
	case *structTableModel:
		b, err = q.appendStructValues(fmter, b, fields, model.strct)
		if err != nil {
			return nil, err
		}
	case *sliceTableModel:
		b, err = q.appendSliceValues(fmter, b, fields, model.slice)
		if err != nil {
			return nil, err
		}
	default:
		return nil, fmt.Errorf("bun: Insert does not support %T", q.tableModel)
	}

	b = append(b, ')')

	return b, nil
}

func (q *InsertQuery) appendStructValues(
	fmter schema.Formatter, b []byte, fields []*schema.Field, strct reflect.Value,
) (_ []byte, err error) {
	isTemplate := fmter.IsNop()
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		app, ok := q.modelValues[f.Name]
		if ok {
			b, err = app.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
			q.addReturningField(f)
			continue
		}

		switch {
		case isTemplate:
			b = append(b, '?')
		case (f.IsPtr && f.HasNilValue(strct)) || (f.NullZero && f.HasZeroValue(strct)):
			if q.db.features.Has(feature.DefaultPlaceholder) {
				b = append(b, "DEFAULT"...)
			} else if f.SQLDefault != "" {
				b = append(b, f.SQLDefault...)
			} else {
				b = append(b, "NULL"...)
			}
			q.addReturningField(f)
		default:
			b = f.AppendValue(fmter, b, strct)
		}
	}

	for i, v := range q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}

		b, err = v.value.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) appendSliceValues(
	fmter schema.Formatter, b []byte, fields []*schema.Field, slice reflect.Value,
) (_ []byte, err error) {
	if fmter.IsNop() {
		return q.appendStructValues(fmter, b, fields, reflect.Value{})
	}

	sliceLen := slice.Len()
	for i := 0; i < sliceLen; i++ {
		if i > 0 {
			b = append(b, "), ("...)
		}
		el := indirect(slice.Index(i))
		b, err = q.appendStructValues(fmter, b, fields, el)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) getFields() ([]*schema.Field, error) {
	hasIdentity := q.db.features.Has(feature.Identity)

	if len(q.columns) > 0 || q.db.features.Has(feature.DefaultPlaceholder) && !hasIdentity {
		return q.baseQuery.getFields()
	}

	var strct reflect.Value

	switch model := q.tableModel.(type) {
	case *structTableModel:
		strct = model.strct
	case *sliceTableModel:
		if model.sliceLen == 0 {
			return nil, fmt.Errorf("bun: Insert(empty %T)", model.slice.Type())
		}
		strct = indirect(model.slice.Index(0))
	default:
		return nil, errNilModel
	}

	fields := make([]*schema.Field, 0, len(q.table.Fields))

	for _, f := range q.table.Fields {
		if hasIdentity && f.AutoIncrement {
			q.addReturningField(f)
			continue
		}
		if f.NotNull && f.SQLDefault == "" {
			if (f.IsPtr && f.HasNilValue(strct)) || (f.NullZero && f.HasZeroValue(strct)) {
				q.addReturningField(f)
				continue
			}
		}
		fields = append(fields, f)
	}

	return fields, nil
}

func (q *InsertQuery) appendFields(
	fmter schema.Formatter, b []byte, fields []*schema.Field,
) []byte {
	b = appendColumns(b, "", fields)
	for i, v := range q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}
		b = fmter.AppendIdent(b, v.column)
	}
	return b
}

//------------------------------------------------------------------------------

func (q *InsertQuery) On(s string, args ...interface{}) *InsertQuery {
	q.on = schema.SafeQuery(s, args)
	return q
}

func (q *InsertQuery) Set(query string, args ...interface{}) *InsertQuery {
	q.addSet(schema.SafeQuery(query, args))
	return q
}

func (q *InsertQuery) appendOn(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.on.IsZero() {
		return b, nil
	}

	b = append(b, " ON "...)
	b, err = q.on.AppendQuery(fmter, b)
	if err != nil {
		return nil, err
	}

	if len(q.set) > 0 {
		if fmter.HasFeature(feature.InsertOnDuplicateKey) {
			b = append(b, ' ')
		} else {
			b = append(b, " SET "...)
		}

		b, err = q.appendSet(fmter, b)
		if err != nil {
			return nil, err
		}
	} else if q.onConflictDoUpdate() {
		fields, err := q.getDataFields()
		if err != nil {
			return nil, err
		}

		if len(fields) == 0 {
			fields = q.tableModel.Table().DataFields
		}

		b = q.appendSetExcluded(b, fields)
	} else if q.onDuplicateKeyUpdate() {
		fields, err := q.getDataFields()
		if err != nil {
			return nil, err
		}

		if len(fields) == 0 {
			fields = q.tableModel.Table().DataFields
		}

		b = q.appendSetValues(b, fields)
	}

	if len(q.where) > 0 {
		b = append(b, " WHERE "...)

		b, err = appendWhere(fmter, b, q.where)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) onConflictDoUpdate() bool {
	return strings.HasSuffix(strings.ToUpper(q.on.Query), " DO UPDATE")
}

func (q *InsertQuery) onDuplicateKeyUpdate() bool {
	return strings.ToUpper(q.on.Query) == "DUPLICATE KEY UPDATE"
}

func (q *InsertQuery) appendSetExcluded(b []byte, fields []*schema.Field) []byte {
	b = append(b, " SET "...)
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = append(b, f.SQLName...)
		b = append(b, " = EXCLUDED."...)
		b = append(b, f.SQLName...)
	}
	return b
}

func (q *InsertQuery) appendSetValues(b []byte, fields []*schema.Field) []byte {
	b = append(b, " "...)
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = append(b, f.SQLName...)
		b = append(b, " = VALUES("...)
		b = append(b, f.SQLName...)
		b = append(b, ")"...)
	}
	return b
}

//------------------------------------------------------------------------------

func (q *InsertQuery) Scan(ctx context.Context, dest ...interface{}) error {
	_, err := q.scanOrExec(ctx, dest, true)
	return err
}

func (q *InsertQuery) Exec(ctx context.Context, dest ...interface{}) (sql.Result, error) {
	return q.scanOrExec(ctx, dest, len(dest) > 0)
}

func (q *InsertQuery) scanOrExec(
	ctx context.Context, dest []interface{}, hasDest bool,
) (sql.Result, error) {
	if q.err != nil {
		return nil, q.err
	}

	if q.table != nil {
		if err := q.beforeInsertHook(ctx); err != nil {
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
		res, err = q.scan(ctx, q, query, model, hasDest)
		if err != nil {
			return nil, err
		}
	} else {
		res, err = q.exec(ctx, q, query)
		if err != nil {
			return nil, err
		}

		if err := q.tryLastInsertID(res, dest); err != nil {
			return nil, err
		}
	}

	if q.table != nil {
		if err := q.afterInsertHook(ctx); err != nil {
			return nil, err
		}
	}

	return res, nil
}

func (q *InsertQuery) beforeInsertHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(BeforeInsertHook); ok {
		if err := hook.BeforeInsert(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

func (q *InsertQuery) afterInsertHook(ctx context.Context) error {
	if hook, ok := q.table.ZeroIface.(AfterInsertHook); ok {
		if err := hook.AfterInsert(ctx, q); err != nil {
			return err
		}
	}
	return nil
}

func (q *InsertQuery) tryLastInsertID(res sql.Result, dest []interface{}) error {
	if q.db.features.Has(feature.Returning) ||
		q.db.features.Has(feature.Output) ||
		q.table == nil ||
		len(q.table.PKs) != 1 ||
		!q.table.PKs[0].AutoIncrement {
		return nil
	}

	id, err := res.LastInsertId()
	if err != nil {
		return err
	}
	if id == 0 {
		return nil
	}

	model, err := q.getModel(dest)
	if err != nil {
		return err
	}

	pk := q.table.PKs[0]
	switch model := model.(type) {
	case *structTableModel:
		if err := pk.ScanValue(model.strct, id); err != nil {
			return err
		}
	case *sliceTableModel:
		sliceLen := model.slice.Len()
		for i := 0; i < sliceLen; i++ {
			strct := indirect(model.slice.Index(i))
			if err := pk.ScanValue(strct, id); err != nil {
				return err
			}
			id++
		}
	}

	return nil
}

func (q *InsertQuery) String() string {
	buf, err := q.AppendQuery(q.db.Formatter(), nil)
	if err != nil {
		panic(err)
	}

	return string(buf)
}
