package bun

import (
	"context"
	"database/sql"
	"fmt"
	"reflect"
	"strings"
	"time"

	"github.com/uptrace/bun/schema"
)

type structTableModel struct {
	db    *DB
	table *schema.Table

	rel   *schema.Relation
	joins []relationJoin

	dest  interface{}
	root  reflect.Value
	index []int

	strct         reflect.Value
	structInited  bool
	structInitErr error

	columns   []string
	scanIndex int
}

var _ TableModel = (*structTableModel)(nil)

func newStructTableModel(db *DB, dest interface{}, table *schema.Table) *structTableModel {
	return &structTableModel{
		db:    db,
		table: table,
		dest:  dest,
	}
}

func newStructTableModelValue(db *DB, dest interface{}, v reflect.Value) *structTableModel {
	return &structTableModel{
		db:    db,
		table: db.Table(v.Type()),
		dest:  dest,
		root:  v,
		strct: v,
	}
}

func (m *structTableModel) Value() interface{} {
	return m.dest
}

func (m *structTableModel) Table() *schema.Table {
	return m.table
}

func (m *structTableModel) Relation() *schema.Relation {
	return m.rel
}

func (m *structTableModel) initStruct() error {
	if m.structInited {
		return m.structInitErr
	}
	m.structInited = true

	switch m.strct.Kind() {
	case reflect.Invalid:
		m.structInitErr = errNilModel
		return m.structInitErr
	case reflect.Interface:
		m.strct = m.strct.Elem()
	}

	if m.strct.Kind() == reflect.Ptr {
		if m.strct.IsNil() {
			m.strct.Set(reflect.New(m.strct.Type().Elem()))
			m.strct = m.strct.Elem()
		} else {
			m.strct = m.strct.Elem()
		}
	}

	m.mountJoins()

	return nil
}

func (m *structTableModel) mountJoins() {
	for i := range m.joins {
		j := &m.joins[i]
		switch j.Relation.Type {
		case schema.HasOneRelation, schema.BelongsToRelation:
			j.JoinModel.mount(m.strct)
		}
	}
}

var _ schema.BeforeAppendModelHook = (*structTableModel)(nil)

func (m *structTableModel) BeforeAppendModel(ctx context.Context, query Query) error {
	if !m.table.HasBeforeAppendModelHook() || !m.strct.IsValid() {
		return nil
	}
	return m.strct.Addr().Interface().(schema.BeforeAppendModelHook).BeforeAppendModel(ctx, query)
}

var _ schema.BeforeScanRowHook = (*structTableModel)(nil)

func (m *structTableModel) BeforeScanRow(ctx context.Context) error {
	if m.table.HasBeforeScanRowHook() {
		return m.strct.Addr().Interface().(schema.BeforeScanRowHook).BeforeScanRow(ctx)
	}
	if m.table.HasBeforeScanHook() {
		return m.strct.Addr().Interface().(schema.BeforeScanHook).BeforeScan(ctx)
	}
	return nil
}

var _ schema.AfterScanRowHook = (*structTableModel)(nil)

func (m *structTableModel) AfterScanRow(ctx context.Context) error {
	if !m.structInited {
		return nil
	}

	if m.table.HasAfterScanRowHook() {
		firstErr := m.strct.Addr().Interface().(schema.AfterScanRowHook).AfterScanRow(ctx)

		for _, j := range m.joins {
			switch j.Relation.Type {
			case schema.HasOneRelation, schema.BelongsToRelation:
				if err := j.JoinModel.AfterScanRow(ctx); err != nil && firstErr == nil {
					firstErr = err
				}
			}
		}

		return firstErr
	}

	if m.table.HasAfterScanHook() {
		firstErr := m.strct.Addr().Interface().(schema.AfterScanHook).AfterScan(ctx)

		for _, j := range m.joins {
			switch j.Relation.Type {
			case schema.HasOneRelation, schema.BelongsToRelation:
				if err := j.JoinModel.AfterScanRow(ctx); err != nil && firstErr == nil {
					firstErr = err
				}
			}
		}

		return firstErr
	}

	return nil
}

func (m *structTableModel) getJoin(name string) *relationJoin {
	for i := range m.joins {
		j := &m.joins[i]
		if j.Relation.Field.Name == name || j.Relation.Field.GoName == name {
			return j
		}
	}
	return nil
}

func (m *structTableModel) getJoins() []relationJoin {
	return m.joins
}

func (m *structTableModel) addJoin(j relationJoin) *relationJoin {
	m.joins = append(m.joins, j)
	return &m.joins[len(m.joins)-1]
}

func (m *structTableModel) join(name string) *relationJoin {
	return m._join(m.strct, name)
}

func (m *structTableModel) _join(bind reflect.Value, name string) *relationJoin {
	path := strings.Split(name, ".")
	index := make([]int, 0, len(path))

	currJoin := relationJoin{
		BaseModel: m,
		JoinModel: m,
	}
	var lastJoin *relationJoin

	for _, name := range path {
		relation, ok := currJoin.JoinModel.Table().Relations[name]
		if !ok {
			return nil
		}

		currJoin.Relation = relation
		index = append(index, relation.Field.Index...)

		if j := currJoin.JoinModel.getJoin(name); j != nil {
			currJoin.BaseModel = j.BaseModel
			currJoin.JoinModel = j.JoinModel

			lastJoin = j
		} else {
			model, err := newTableModelIndex(m.db, m.table, bind, index, relation)
			if err != nil {
				return nil
			}

			currJoin.Parent = lastJoin
			currJoin.BaseModel = currJoin.JoinModel
			currJoin.JoinModel = model

			lastJoin = currJoin.BaseModel.addJoin(currJoin)
		}
	}

	return lastJoin
}

func (m *structTableModel) rootValue() reflect.Value {
	return m.root
}

func (m *structTableModel) parentIndex() []int {
	return m.index[:len(m.index)-len(m.rel.Field.Index)]
}

func (m *structTableModel) mount(host reflect.Value) {
	m.strct = host.FieldByIndex(m.rel.Field.Index)
	m.structInited = false
}

func (m *structTableModel) updateSoftDeleteField(tm time.Time) error {
	if !m.strct.IsValid() {
		return nil
	}
	fv := m.table.SoftDeleteField.Value(m.strct)
	return m.table.UpdateSoftDeleteField(fv, tm)
}

func (m *structTableModel) ScanRows(ctx context.Context, rows *sql.Rows) (int, error) {
	if !rows.Next() {
		return 0, rows.Err()
	}

	var n int

	if err := m.ScanRow(ctx, rows); err != nil {
		return 0, err
	}
	n++

	// And discard the rest. This is especially important for SQLite3, which can return
	// a row like it was inserted sucessfully and then return an actual error for the next row.
	// See issues/100.
	for rows.Next() {
		n++
	}
	if err := rows.Err(); err != nil {
		return 0, err
	}

	return n, nil
}

func (m *structTableModel) ScanRow(ctx context.Context, rows *sql.Rows) error {
	columns, err := rows.Columns()
	if err != nil {
		return err
	}

	m.columns = columns
	dest := makeDest(m, len(columns))

	return m.scanRow(ctx, rows, dest)
}

func (m *structTableModel) scanRow(ctx context.Context, rows *sql.Rows, dest []interface{}) error {
	if err := m.BeforeScanRow(ctx); err != nil {
		return err
	}

	m.scanIndex = 0
	if err := rows.Scan(dest...); err != nil {
		return err
	}

	if err := m.AfterScanRow(ctx); err != nil {
		return err
	}

	return nil
}

func (m *structTableModel) Scan(src interface{}) error {
	column := m.columns[m.scanIndex]
	m.scanIndex++

	return m.ScanColumn(unquote(column), src)
}

func (m *structTableModel) ScanColumn(column string, src interface{}) error {
	if ok, err := m.scanColumn(column, src); ok {
		return err
	}
	if column == "" || column[0] == '_' || m.db.flags.Has(discardUnknownColumns) {
		return nil
	}
	return fmt.Errorf("bun: %s does not have column %q", m.table.TypeName, column)
}

func (m *structTableModel) scanColumn(column string, src interface{}) (bool, error) {
	if src != nil {
		if err := m.initStruct(); err != nil {
			return true, err
		}
	}

	if field, ok := m.table.FieldMap[column]; ok {
		if src == nil && m.isNil() {
			return true, nil
		}
		return true, field.ScanValue(m.strct, src)
	}

	if joinName, column := splitColumn(column); joinName != "" {
		if join := m.getJoin(joinName); join != nil {
			return true, join.JoinModel.ScanColumn(column, src)
		}

		if m.table.ModelName == joinName {
			return true, m.ScanColumn(column, src)
		}
	}

	return false, nil
}

func (m *structTableModel) isNil() bool {
	return m.strct.Kind() == reflect.Ptr && m.strct.IsNil()
}

func (m *structTableModel) AppendNamedArg(
	fmter schema.Formatter, b []byte, name string,
) ([]byte, bool) {
	return m.table.AppendNamedArg(fmter, b, name, m.strct)
}

// sqlite3 sometimes does not unquote columns.
func unquote(s string) string {
	if s == "" {
		return s
	}
	if s[0] == '"' && s[len(s)-1] == '"' {
		return s[1 : len(s)-1]
	}
	return s
}

func splitColumn(s string) (string, string) {
	if i := strings.Index(s, "__"); i >= 0 {
		return s[:i], s[i+2:]
	}
	return "", s
}
