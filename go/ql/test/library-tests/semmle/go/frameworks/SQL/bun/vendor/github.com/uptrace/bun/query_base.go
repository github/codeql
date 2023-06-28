package bun

import (
	"context"
	"database/sql"
	"database/sql/driver"
	"errors"
	"fmt"
	"time"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

const (
	forceDeleteFlag internal.Flag = 1 << iota
	deletedFlag
	allWithDeletedFlag
)

type withQuery struct {
	name      string
	query     schema.QueryAppender
	recursive bool
}

// IConn is a common interface for *sql.DB, *sql.Conn, and *sql.Tx.
type IConn interface {
	QueryContext(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error)
	ExecContext(ctx context.Context, query string, args ...interface{}) (sql.Result, error)
	QueryRowContext(ctx context.Context, query string, args ...interface{}) *sql.Row
}

var (
	_ IConn = (*sql.DB)(nil)
	_ IConn = (*sql.Conn)(nil)
	_ IConn = (*sql.Tx)(nil)
	_ IConn = (*DB)(nil)
	_ IConn = (*Conn)(nil)
	_ IConn = (*Tx)(nil)
)

// IDB is a common interface for *bun.DB, bun.Conn, and bun.Tx.
type IDB interface {
	IConn
	Dialect() schema.Dialect

	NewValues(model interface{}) *ValuesQuery
	NewSelect() *SelectQuery
	NewInsert() *InsertQuery
	NewUpdate() *UpdateQuery
	NewDelete() *DeleteQuery
	NewRaw(query string, args ...interface{}) *RawQuery
	NewCreateTable() *CreateTableQuery
	NewDropTable() *DropTableQuery
	NewCreateIndex() *CreateIndexQuery
	NewDropIndex() *DropIndexQuery
	NewTruncateTable() *TruncateTableQuery
	NewAddColumn() *AddColumnQuery
	NewDropColumn() *DropColumnQuery

	BeginTx(ctx context.Context, opts *sql.TxOptions) (Tx, error)
	RunInTx(ctx context.Context, opts *sql.TxOptions, f func(ctx context.Context, tx Tx) error) error
}

var (
	_ IDB = (*DB)(nil)
	_ IDB = (*Conn)(nil)
	_ IDB = (*Tx)(nil)
)

// QueryBuilder is used for common query methods
type QueryBuilder interface {
	Query
	Where(query string, args ...interface{}) QueryBuilder
	WhereGroup(sep string, fn func(QueryBuilder) QueryBuilder) QueryBuilder
	WhereOr(query string, args ...interface{}) QueryBuilder
	WhereDeleted() QueryBuilder
	WhereAllWithDeleted() QueryBuilder
	WherePK(cols ...string) QueryBuilder
	Unwrap() interface{}
}

var (
	_ QueryBuilder = (*selectQueryBuilder)(nil)
	_ QueryBuilder = (*updateQueryBuilder)(nil)
	_ QueryBuilder = (*deleteQueryBuilder)(nil)
)

type baseQuery struct {
	db   *DB
	conn IConn

	model Model
	err   error

	tableModel TableModel
	table      *schema.Table

	with           []withQuery
	modelTableName schema.QueryWithArgs
	tables         []schema.QueryWithArgs
	columns        []schema.QueryWithArgs

	flags internal.Flag
}

func (q *baseQuery) DB() *DB {
	return q.db
}

func (q *baseQuery) GetConn() IConn {
	return q.conn
}

func (q *baseQuery) GetModel() Model {
	return q.model
}

func (q *baseQuery) GetTableName() string {
	if q.table != nil {
		return q.table.Name
	}

	for _, wq := range q.with {
		if v, ok := wq.query.(Query); ok {
			if model := v.GetModel(); model != nil {
				return v.GetTableName()
			}
		}
	}

	if q.modelTableName.Query != "" {
		return q.modelTableName.Query
	}

	if len(q.tables) > 0 {
		b, _ := q.tables[0].AppendQuery(q.db.fmter, nil)
		if len(b) < 64 {
			return string(b)
		}
	}

	return ""
}

func (q *baseQuery) setConn(db IConn) {
	// Unwrap Bun wrappers to not call query hooks twice.
	switch db := db.(type) {
	case *DB:
		q.conn = db.DB
	case Conn:
		q.conn = db.Conn
	case Tx:
		q.conn = db.Tx
	default:
		q.conn = db
	}
}

func (q *baseQuery) setModel(modeli interface{}) {
	model, err := newSingleModel(q.db, modeli)
	if err != nil {
		q.setErr(err)
		return
	}

	q.model = model
	if tm, ok := model.(TableModel); ok {
		q.tableModel = tm
		q.table = tm.Table()
	}
}

func (q *baseQuery) setErr(err error) {
	if q.err == nil {
		q.err = err
	}
}

func (q *baseQuery) getModel(dest []interface{}) (Model, error) {
	if len(dest) > 0 {
		return newModel(q.db, dest)
	}
	if q.model != nil {
		return q.model, nil
	}
	return nil, errNilModel
}

func (q *baseQuery) beforeAppendModel(ctx context.Context, query Query) error {
	if q.tableModel != nil {
		return q.tableModel.BeforeAppendModel(ctx, query)
	}
	return nil
}

func (q *baseQuery) hasFeature(feature feature.Feature) bool {
	return q.db.features.Has(feature)
}

//------------------------------------------------------------------------------

func (q *baseQuery) checkSoftDelete() error {
	if q.table == nil {
		return errors.New("bun: can't use soft deletes without a table")
	}
	if q.table.SoftDeleteField == nil {
		return fmt.Errorf("%s does not have a soft delete field", q.table)
	}
	if q.tableModel == nil {
		return errors.New("bun: can't use soft deletes without a table model")
	}
	return nil
}

// Deleted adds `WHERE deleted_at IS NOT NULL` clause for soft deleted models.
func (q *baseQuery) whereDeleted() {
	if err := q.checkSoftDelete(); err != nil {
		q.setErr(err)
		return
	}
	q.flags = q.flags.Set(deletedFlag)
	q.flags = q.flags.Remove(allWithDeletedFlag)
}

// AllWithDeleted changes query to return all rows including soft deleted ones.
func (q *baseQuery) whereAllWithDeleted() {
	if err := q.checkSoftDelete(); err != nil {
		q.setErr(err)
		return
	}
	q.flags = q.flags.Set(allWithDeletedFlag).Remove(deletedFlag)
}

func (q *baseQuery) isSoftDelete() bool {
	if q.table != nil {
		return q.table.SoftDeleteField != nil &&
			!q.flags.Has(allWithDeletedFlag) &&
			(!q.flags.Has(forceDeleteFlag) || q.flags.Has(deletedFlag))
	}
	return false
}

//------------------------------------------------------------------------------

func (q *baseQuery) addWith(name string, query schema.QueryAppender, recursive bool) {
	q.with = append(q.with, withQuery{
		name:      name,
		query:     query,
		recursive: recursive,
	})
}

func (q *baseQuery) appendWith(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if len(q.with) == 0 {
		return b, nil
	}

	b = append(b, "WITH "...)
	for i, with := range q.with {
		if i > 0 {
			b = append(b, ", "...)
		}

		if with.recursive {
			b = append(b, "RECURSIVE "...)
		}

		b, err = q.appendCTE(fmter, b, with)
		if err != nil {
			return nil, err
		}
	}
	b = append(b, ' ')
	return b, nil
}

func (q *baseQuery) appendCTE(
	fmter schema.Formatter, b []byte, cte withQuery,
) (_ []byte, err error) {
	if !fmter.Dialect().Features().Has(feature.WithValues) {
		if values, ok := cte.query.(*ValuesQuery); ok {
			return q.appendSelectFromValues(fmter, b, cte, values)
		}
	}

	b = fmter.AppendIdent(b, cte.name)

	if q, ok := cte.query.(schema.ColumnsAppender); ok {
		b = append(b, " ("...)
		b, err = q.AppendColumns(fmter, b)
		if err != nil {
			return nil, err
		}
		b = append(b, ")"...)
	}

	b = append(b, " AS ("...)

	b, err = cte.query.AppendQuery(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, ")"...)
	return b, nil
}

func (q *baseQuery) appendSelectFromValues(
	fmter schema.Formatter, b []byte, cte withQuery, values *ValuesQuery,
) (_ []byte, err error) {
	b = fmter.AppendIdent(b, cte.name)
	b = append(b, " AS (SELECT * FROM ("...)

	b, err = cte.query.AppendQuery(fmter, b)
	if err != nil {
		return nil, err
	}

	b = append(b, ") AS t"...)
	if q, ok := cte.query.(schema.ColumnsAppender); ok {
		b = append(b, " ("...)
		b, err = q.AppendColumns(fmter, b)
		if err != nil {
			return nil, err
		}
		b = append(b, ")"...)
	}
	b = append(b, ")"...)

	return b, nil
}

//------------------------------------------------------------------------------

func (q *baseQuery) addTable(table schema.QueryWithArgs) {
	q.tables = append(q.tables, table)
}

func (q *baseQuery) addColumn(column schema.QueryWithArgs) {
	q.columns = append(q.columns, column)
}

func (q *baseQuery) excludeColumn(columns []string) {
	if q.table == nil {
		q.setErr(errNilModel)
		return
	}

	if q.columns == nil {
		for _, f := range q.table.Fields {
			q.columns = append(q.columns, schema.UnsafeIdent(f.Name))
		}
	}

	if len(columns) == 1 && columns[0] == "*" {
		q.columns = make([]schema.QueryWithArgs, 0)
		return
	}

	for _, column := range columns {
		if !q._excludeColumn(column) {
			q.setErr(fmt.Errorf("bun: can't find column=%q", column))
			return
		}
	}
}

func (q *baseQuery) _excludeColumn(column string) bool {
	for i, col := range q.columns {
		if col.Args == nil && col.Query == column {
			q.columns = append(q.columns[:i], q.columns[i+1:]...)
			return true
		}
	}
	return false
}

//------------------------------------------------------------------------------

func (q *baseQuery) modelHasTableName() bool {
	if !q.modelTableName.IsZero() {
		return q.modelTableName.Query != ""
	}
	return q.table != nil
}

func (q *baseQuery) hasTables() bool {
	return q.modelHasTableName() || len(q.tables) > 0
}

func (q *baseQuery) appendTables(
	fmter schema.Formatter, b []byte,
) (_ []byte, err error) {
	return q._appendTables(fmter, b, false)
}

func (q *baseQuery) appendTablesWithAlias(
	fmter schema.Formatter, b []byte,
) (_ []byte, err error) {
	return q._appendTables(fmter, b, true)
}

func (q *baseQuery) _appendTables(
	fmter schema.Formatter, b []byte, withAlias bool,
) (_ []byte, err error) {
	startLen := len(b)

	if q.modelHasTableName() {
		if !q.modelTableName.IsZero() {
			b, err = q.modelTableName.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
		} else {
			b = fmter.AppendQuery(b, string(q.table.SQLNameForSelects))
			if withAlias && q.table.SQLAlias != q.table.SQLNameForSelects {
				b = append(b, " AS "...)
				b = append(b, q.table.SQLAlias...)
			}
		}
	}

	for _, table := range q.tables {
		if len(b) > startLen {
			b = append(b, ", "...)
		}
		b, err = table.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *baseQuery) appendFirstTable(fmter schema.Formatter, b []byte) ([]byte, error) {
	return q._appendFirstTable(fmter, b, false)
}

func (q *baseQuery) appendFirstTableWithAlias(
	fmter schema.Formatter, b []byte,
) ([]byte, error) {
	return q._appendFirstTable(fmter, b, true)
}

func (q *baseQuery) _appendFirstTable(
	fmter schema.Formatter, b []byte, withAlias bool,
) ([]byte, error) {
	if !q.modelTableName.IsZero() {
		return q.modelTableName.AppendQuery(fmter, b)
	}

	if q.table != nil {
		b = fmter.AppendQuery(b, string(q.table.SQLName))
		if withAlias {
			b = append(b, " AS "...)
			b = append(b, q.table.SQLAlias...)
		}
		return b, nil
	}

	if len(q.tables) > 0 {
		return q.tables[0].AppendQuery(fmter, b)
	}

	return nil, errors.New("bun: query does not have a table")
}

func (q *baseQuery) hasMultiTables() bool {
	if q.modelHasTableName() {
		return len(q.tables) >= 1
	}
	return len(q.tables) >= 2
}

func (q *baseQuery) appendOtherTables(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	tables := q.tables
	if !q.modelHasTableName() {
		tables = tables[1:]
	}
	for i, table := range tables {
		if i > 0 {
			b = append(b, ", "...)
		}
		b, err = table.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

//------------------------------------------------------------------------------

func (q *baseQuery) appendColumns(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	for i, f := range q.columns {
		if i > 0 {
			b = append(b, ", "...)
		}
		b, err = f.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

func (q *baseQuery) getFields() ([]*schema.Field, error) {
	if len(q.columns) == 0 {
		if q.table == nil {
			return nil, errNilModel
		}
		return q.table.Fields, nil
	}
	return q._getFields(false)
}

func (q *baseQuery) getDataFields() ([]*schema.Field, error) {
	if len(q.columns) == 0 {
		if q.table == nil {
			return nil, errNilModel
		}
		return q.table.DataFields, nil
	}
	return q._getFields(true)
}

func (q *baseQuery) _getFields(omitPK bool) ([]*schema.Field, error) {
	fields := make([]*schema.Field, 0, len(q.columns))
	for _, col := range q.columns {
		if col.Args != nil {
			continue
		}

		field, err := q.table.Field(col.Query)
		if err != nil {
			return nil, err
		}

		if omitPK && field.IsPK {
			continue
		}

		fields = append(fields, field)
	}
	return fields, nil
}

func (q *baseQuery) scan(
	ctx context.Context,
	iquery Query,
	query string,
	model Model,
	hasDest bool,
) (sql.Result, error) {
	ctx, event := q.db.beforeQuery(ctx, iquery, query, nil, query, q.model)

	rows, err := q.conn.QueryContext(ctx, query)
	if err != nil {
		q.db.afterQuery(ctx, event, nil, err)
		return nil, err
	}
	defer rows.Close()

	numRow, err := model.ScanRows(ctx, rows)
	if err != nil {
		q.db.afterQuery(ctx, event, nil, err)
		return nil, err
	}

	if numRow == 0 && hasDest && isSingleRowModel(model) {
		err = sql.ErrNoRows
	}

	res := driver.RowsAffected(numRow)
	q.db.afterQuery(ctx, event, res, err)

	return res, err
}

func (q *baseQuery) exec(
	ctx context.Context,
	iquery Query,
	query string,
) (sql.Result, error) {
	ctx, event := q.db.beforeQuery(ctx, iquery, query, nil, query, q.model)
	res, err := q.conn.ExecContext(ctx, query)
	q.db.afterQuery(ctx, event, nil, err)
	return res, err
}

//------------------------------------------------------------------------------

func (q *baseQuery) AppendNamedArg(fmter schema.Formatter, b []byte, name string) ([]byte, bool) {
	if q.table == nil {
		return b, false
	}

	if m, ok := q.tableModel.(*structTableModel); ok {
		if b, ok := m.AppendNamedArg(fmter, b, name); ok {
			return b, ok
		}
	}

	switch name {
	case "TableName":
		b = fmter.AppendQuery(b, string(q.table.SQLName))
		return b, true
	case "TableAlias":
		b = fmter.AppendQuery(b, string(q.table.SQLAlias))
		return b, true
	case "PKs":
		b = appendColumns(b, "", q.table.PKs)
		return b, true
	case "TablePKs":
		b = appendColumns(b, q.table.SQLAlias, q.table.PKs)
		return b, true
	case "Columns":
		b = appendColumns(b, "", q.table.Fields)
		return b, true
	case "TableColumns":
		b = appendColumns(b, q.table.SQLAlias, q.table.Fields)
		return b, true
	}

	return b, false
}

//------------------------------------------------------------------------------

func (q *baseQuery) Dialect() schema.Dialect {
	return q.db.Dialect()
}

func (q *baseQuery) NewValues(model interface{}) *ValuesQuery {
	return NewValuesQuery(q.db, model).Conn(q.conn)
}

func (q *baseQuery) NewSelect() *SelectQuery {
	return NewSelectQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewInsert() *InsertQuery {
	return NewInsertQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewUpdate() *UpdateQuery {
	return NewUpdateQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewDelete() *DeleteQuery {
	return NewDeleteQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewRaw(query string, args ...interface{}) *RawQuery {
	return NewRawQuery(q.db, query, args...).Conn(q.conn)
}

func (q *baseQuery) NewCreateTable() *CreateTableQuery {
	return NewCreateTableQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewDropTable() *DropTableQuery {
	return NewDropTableQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewCreateIndex() *CreateIndexQuery {
	return NewCreateIndexQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewDropIndex() *DropIndexQuery {
	return NewDropIndexQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewTruncateTable() *TruncateTableQuery {
	return NewTruncateTableQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewAddColumn() *AddColumnQuery {
	return NewAddColumnQuery(q.db).Conn(q.conn)
}

func (q *baseQuery) NewDropColumn() *DropColumnQuery {
	return NewDropColumnQuery(q.db).Conn(q.conn)
}

//------------------------------------------------------------------------------

func appendColumns(b []byte, table schema.Safe, fields []*schema.Field) []byte {
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		if len(table) > 0 {
			b = append(b, table...)
			b = append(b, '.')
		}
		b = append(b, f.SQLName...)
	}
	return b
}

func formatterWithModel(fmter schema.Formatter, model schema.NamedArgAppender) schema.Formatter {
	if fmter.IsNop() {
		return fmter
	}
	return fmter.WithArg(model)
}

//------------------------------------------------------------------------------

type whereBaseQuery struct {
	baseQuery

	where       []schema.QueryWithSep
	whereFields []*schema.Field
}

func (q *whereBaseQuery) addWhere(where schema.QueryWithSep) {
	q.where = append(q.where, where)
}

func (q *whereBaseQuery) addWhereGroup(sep string, where []schema.QueryWithSep) {
	if len(where) == 0 {
		return
	}

	q.addWhere(schema.SafeQueryWithSep("", nil, sep))
	q.addWhere(schema.SafeQueryWithSep("", nil, "("))

	where[0].Sep = ""
	q.where = append(q.where, where...)

	q.addWhere(schema.SafeQueryWithSep("", nil, ")"))
}

func (q *whereBaseQuery) addWhereCols(cols []string) {
	if q.table == nil {
		err := fmt.Errorf("bun: got %T, but WherePK requires a struct or slice-based model", q.model)
		q.setErr(err)
		return
	}
	if q.whereFields != nil {
		err := errors.New("bun: WherePK can only be called once")
		q.setErr(err)
		return
	}

	if cols == nil {
		if err := q.table.CheckPKs(); err != nil {
			q.setErr(err)
			return
		}
		q.whereFields = q.table.PKs
		return
	}

	q.whereFields = make([]*schema.Field, len(cols))
	for i, col := range cols {
		field, err := q.table.Field(col)
		if err != nil {
			q.setErr(err)
			return
		}
		q.whereFields[i] = field
	}
}

func (q *whereBaseQuery) mustAppendWhere(
	fmter schema.Formatter, b []byte, withAlias bool,
) ([]byte, error) {
	if len(q.where) == 0 && q.whereFields == nil && !q.flags.Has(deletedFlag) {
		err := errors.New("bun: Update and Delete queries require at least one Where")
		return nil, err
	}
	return q.appendWhere(fmter, b, withAlias)
}

func (q *whereBaseQuery) appendWhere(
	fmter schema.Formatter, b []byte, withAlias bool,
) (_ []byte, err error) {
	if len(q.where) == 0 && q.whereFields == nil && !q.isSoftDelete() {
		return b, nil
	}

	b = append(b, " WHERE "...)
	startLen := len(b)

	if len(q.where) > 0 {
		b, err = appendWhere(fmter, b, q.where)
		if err != nil {
			return nil, err
		}
	}

	if q.isSoftDelete() {
		if len(b) > startLen {
			b = append(b, " AND "...)
		}

		if withAlias {
			b = append(b, q.tableModel.Table().SQLAlias...)
		} else {
			b = append(b, q.tableModel.Table().SQLName...)
		}
		b = append(b, '.')

		field := q.tableModel.Table().SoftDeleteField
		b = append(b, field.SQLName...)

		if field.IsPtr || field.NullZero {
			if q.flags.Has(deletedFlag) {
				b = append(b, " IS NOT NULL"...)
			} else {
				b = append(b, " IS NULL"...)
			}
		} else {
			if q.flags.Has(deletedFlag) {
				b = append(b, " != "...)
			} else {
				b = append(b, " = "...)
			}
			b = fmter.Dialect().AppendTime(b, time.Time{})
		}
	}

	if q.whereFields != nil {
		if len(b) > startLen {
			b = append(b, " AND "...)
		}
		b, err = q.appendWhereFields(fmter, b, q.whereFields, withAlias)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func appendWhere(
	fmter schema.Formatter, b []byte, where []schema.QueryWithSep,
) (_ []byte, err error) {
	for i, where := range where {
		if i > 0 {
			b = append(b, where.Sep...)
		}

		if where.Query == "" {
			continue
		}

		b = append(b, '(')
		b, err = where.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
		b = append(b, ')')
	}
	return b, nil
}

func (q *whereBaseQuery) appendWhereFields(
	fmter schema.Formatter, b []byte, fields []*schema.Field, withAlias bool,
) (_ []byte, err error) {
	if q.table == nil {
		err := fmt.Errorf("bun: got %T, but WherePK requires struct or slice-based model", q.model)
		return nil, err
	}

	switch model := q.tableModel.(type) {
	case *structTableModel:
		return q.appendWhereStructFields(fmter, b, model, fields, withAlias)
	case *sliceTableModel:
		return q.appendWhereSliceFields(fmter, b, model, fields, withAlias)
	default:
		return nil, fmt.Errorf("bun: WhereColumn does not support %T", q.tableModel)
	}
}

func (q *whereBaseQuery) appendWhereStructFields(
	fmter schema.Formatter,
	b []byte,
	model *structTableModel,
	fields []*schema.Field,
	withAlias bool,
) (_ []byte, err error) {
	if !model.strct.IsValid() {
		return nil, errNilModel
	}

	isTemplate := fmter.IsNop()
	b = append(b, '(')
	for i, f := range fields {
		if i > 0 {
			b = append(b, " AND "...)
		}
		if withAlias {
			b = append(b, q.table.SQLAlias...)
			b = append(b, '.')
		}
		b = append(b, f.SQLName...)
		b = append(b, " = "...)
		if isTemplate {
			b = append(b, '?')
		} else {
			b = f.AppendValue(fmter, b, model.strct)
		}
	}
	b = append(b, ')')
	return b, nil
}

func (q *whereBaseQuery) appendWhereSliceFields(
	fmter schema.Formatter,
	b []byte,
	model *sliceTableModel,
	fields []*schema.Field,
	withAlias bool,
) (_ []byte, err error) {
	if len(fields) > 1 {
		b = append(b, '(')
	}
	if withAlias {
		b = appendColumns(b, q.table.SQLAlias, fields)
	} else {
		b = appendColumns(b, "", fields)
	}
	if len(fields) > 1 {
		b = append(b, ')')
	}

	b = append(b, " IN ("...)

	isTemplate := fmter.IsNop()
	slice := model.slice
	sliceLen := slice.Len()
	for i := 0; i < sliceLen; i++ {
		if i > 0 {
			if isTemplate {
				break
			}
			b = append(b, ", "...)
		}

		el := indirect(slice.Index(i))

		if len(fields) > 1 {
			b = append(b, '(')
		}
		for i, f := range fields {
			if i > 0 {
				b = append(b, ", "...)
			}
			if isTemplate {
				b = append(b, '?')
			} else {
				b = f.AppendValue(fmter, b, el)
			}
		}
		if len(fields) > 1 {
			b = append(b, ')')
		}
	}

	b = append(b, ')')

	return b, nil
}

//------------------------------------------------------------------------------

type returningQuery struct {
	returning       []schema.QueryWithArgs
	returningFields []*schema.Field
}

func (q *returningQuery) addReturning(ret schema.QueryWithArgs) {
	q.returning = append(q.returning, ret)
}

func (q *returningQuery) addReturningField(field *schema.Field) {
	if len(q.returning) > 0 {
		return
	}
	for _, f := range q.returningFields {
		if f == field {
			return
		}
	}
	q.returningFields = append(q.returningFields, field)
}

func (q *returningQuery) appendReturning(
	fmter schema.Formatter, b []byte,
) (_ []byte, err error) {
	return q._appendReturning(fmter, b, "")
}

func (q *returningQuery) appendOutput(
	fmter schema.Formatter, b []byte,
) (_ []byte, err error) {
	return q._appendReturning(fmter, b, "INSERTED")
}

func (q *returningQuery) _appendReturning(
	fmter schema.Formatter, b []byte, table string,
) (_ []byte, err error) {
	for i, f := range q.returning {
		if i > 0 {
			b = append(b, ", "...)
		}
		b, err = f.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	if len(q.returning) > 0 {
		return b, nil
	}

	b = appendColumns(b, schema.Safe(table), q.returningFields)
	return b, nil
}

func (q *returningQuery) hasReturning() bool {
	if len(q.returning) == 1 {
		if ret := q.returning[0]; len(ret.Args) == 0 {
			switch ret.Query {
			case "", "null", "NULL":
				return false
			}
		}
	}
	return len(q.returning) > 0 || len(q.returningFields) > 0
}

//------------------------------------------------------------------------------

type columnValue struct {
	column string
	value  schema.QueryWithArgs
}

type customValueQuery struct {
	modelValues map[string]schema.QueryWithArgs
	extraValues []columnValue
}

func (q *customValueQuery) addValue(
	table *schema.Table, column string, value string, args []interface{},
) {
	ok := false
	if table != nil {
		_, ok = table.FieldMap[column]
	}

	if ok {
		if q.modelValues == nil {
			q.modelValues = make(map[string]schema.QueryWithArgs)
		}
		q.modelValues[column] = schema.SafeQuery(value, args)
	} else {
		q.extraValues = append(q.extraValues, columnValue{
			column: column,
			value:  schema.SafeQuery(value, args),
		})
	}
}

//------------------------------------------------------------------------------

type setQuery struct {
	set []schema.QueryWithArgs
}

func (q *setQuery) addSet(set schema.QueryWithArgs) {
	q.set = append(q.set, set)
}

func (q setQuery) appendSet(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	for i, f := range q.set {
		if i > 0 {
			b = append(b, ", "...)
		}
		b, err = f.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

//------------------------------------------------------------------------------

type cascadeQuery struct {
	cascade  bool
	restrict bool
}

func (q cascadeQuery) appendCascade(fmter schema.Formatter, b []byte) []byte {
	if !fmter.HasFeature(feature.TableCascade) {
		return b
	}
	if q.cascade {
		b = append(b, " CASCADE"...)
	}
	if q.restrict {
		b = append(b, " RESTRICT"...)
	}
	return b
}

//------------------------------------------------------------------------------

type idxHintsQuery struct {
	use    *indexHints
	ignore *indexHints
	force  *indexHints
}

type indexHints struct {
	names      []schema.QueryWithArgs
	forJoin    []schema.QueryWithArgs
	forOrderBy []schema.QueryWithArgs
	forGroupBy []schema.QueryWithArgs
}

func (ih *idxHintsQuery) lazyUse() *indexHints {
	if ih.use == nil {
		ih.use = new(indexHints)
	}
	return ih.use
}

func (ih *idxHintsQuery) lazyIgnore() *indexHints {
	if ih.ignore == nil {
		ih.ignore = new(indexHints)
	}
	return ih.ignore
}

func (ih *idxHintsQuery) lazyForce() *indexHints {
	if ih.force == nil {
		ih.force = new(indexHints)
	}
	return ih.force
}

func (ih *idxHintsQuery) appendIndexes(hints []schema.QueryWithArgs, indexes ...string) []schema.QueryWithArgs {
	for _, idx := range indexes {
		hints = append(hints, schema.UnsafeIdent(idx))
	}
	return hints
}

func (ih *idxHintsQuery) addUseIndex(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyUse().names = ih.appendIndexes(ih.use.names, indexes...)
}

func (ih *idxHintsQuery) addUseIndexForJoin(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyUse().forJoin = ih.appendIndexes(ih.use.forJoin, indexes...)
}

func (ih *idxHintsQuery) addUseIndexForOrderBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyUse().forOrderBy = ih.appendIndexes(ih.use.forOrderBy, indexes...)
}

func (ih *idxHintsQuery) addUseIndexForGroupBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyUse().forGroupBy = ih.appendIndexes(ih.use.forGroupBy, indexes...)
}

func (ih *idxHintsQuery) addIgnoreIndex(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyIgnore().names = ih.appendIndexes(ih.ignore.names, indexes...)
}

func (ih *idxHintsQuery) addIgnoreIndexForJoin(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyIgnore().forJoin = ih.appendIndexes(ih.ignore.forJoin, indexes...)
}

func (ih *idxHintsQuery) addIgnoreIndexForOrderBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyIgnore().forOrderBy = ih.appendIndexes(ih.ignore.forOrderBy, indexes...)
}

func (ih *idxHintsQuery) addIgnoreIndexForGroupBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyIgnore().forGroupBy = ih.appendIndexes(ih.ignore.forGroupBy, indexes...)
}

func (ih *idxHintsQuery) addForceIndex(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyForce().names = ih.appendIndexes(ih.force.names, indexes...)
}

func (ih *idxHintsQuery) addForceIndexForJoin(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyForce().forJoin = ih.appendIndexes(ih.force.forJoin, indexes...)
}

func (ih *idxHintsQuery) addForceIndexForOrderBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyForce().forOrderBy = ih.appendIndexes(ih.force.forOrderBy, indexes...)
}

func (ih *idxHintsQuery) addForceIndexForGroupBy(indexes ...string) {
	if len(indexes) == 0 {
		return
	}
	ih.lazyForce().forGroupBy = ih.appendIndexes(ih.force.forGroupBy, indexes...)
}

func (ih *idxHintsQuery) appendIndexHints(
	fmter schema.Formatter, b []byte,
) ([]byte, error) {
	type IdxHint struct {
		Name   string
		Values []schema.QueryWithArgs
	}

	var hints []IdxHint
	if ih.use != nil {
		hints = append(hints, []IdxHint{
			{
				Name:   "USE INDEX",
				Values: ih.use.names,
			},
			{
				Name:   "USE INDEX FOR JOIN",
				Values: ih.use.forJoin,
			},
			{
				Name:   "USE INDEX FOR ORDER BY",
				Values: ih.use.forOrderBy,
			},
			{
				Name:   "USE INDEX FOR GROUP BY",
				Values: ih.use.forGroupBy,
			},
		}...)
	}

	if ih.ignore != nil {
		hints = append(hints, []IdxHint{
			{
				Name:   "IGNORE INDEX",
				Values: ih.ignore.names,
			},
			{
				Name:   "IGNORE INDEX FOR JOIN",
				Values: ih.ignore.forJoin,
			},
			{
				Name:   "IGNORE INDEX FOR ORDER BY",
				Values: ih.ignore.forOrderBy,
			},
			{
				Name:   "IGNORE INDEX FOR GROUP BY",
				Values: ih.ignore.forGroupBy,
			},
		}...)
	}

	if ih.force != nil {
		hints = append(hints, []IdxHint{
			{
				Name:   "FORCE INDEX",
				Values: ih.force.names,
			},
			{
				Name:   "FORCE INDEX FOR JOIN",
				Values: ih.force.forJoin,
			},
			{
				Name:   "FORCE INDEX FOR ORDER BY",
				Values: ih.force.forOrderBy,
			},
			{
				Name:   "FORCE INDEX FOR GROUP BY",
				Values: ih.force.forGroupBy,
			},
		}...)
	}

	var err error
	for _, h := range hints {
		b, err = ih.bufIndexHint(h.Name, h.Values, fmter, b)
		if err != nil {
			return nil, err
		}
	}
	return b, nil
}

func (ih *idxHintsQuery) bufIndexHint(
	name string,
	hints []schema.QueryWithArgs,
	fmter schema.Formatter, b []byte,
) ([]byte, error) {
	var err error
	if len(hints) == 0 {
		return b, nil
	}
	b = append(b, fmt.Sprintf(" %s (", name)...)
	for i, f := range hints {
		if i > 0 {
			b = append(b, ", "...)
		}
		b, err = f.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}
	b = append(b, ")"...)
	return b, nil
}
