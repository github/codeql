package orm

import (
	"context"
	"fmt"
	"reflect"
	"strings"

	"github.com/go-pg/pg/v10/types"
)

type structTableModel struct {
	table *Table
	rel   *Relation
	joins []join

	root  reflect.Value
	index []int

	strct         reflect.Value
	structInited  bool
	structInitErr error
}

var _ TableModel = (*structTableModel)(nil)

func newStructTableModel(table *Table) *structTableModel {
	return &structTableModel{
		table: table,
	}
}

func newStructTableModelValue(v reflect.Value) *structTableModel {
	return &structTableModel{
		table: GetTable(v.Type()),
		root:  v,
		strct: v,
	}
}

func (*structTableModel) useQueryOne() bool {
	return true
}

func (m *structTableModel) String() string {
	return m.table.String()
}

func (m *structTableModel) IsNil() bool {
	return !m.strct.IsValid()
}

func (m *structTableModel) Table() *Table {
	return m.table
}

func (m *structTableModel) Relation() *Relation {
	return m.rel
}

func (m *structTableModel) AppendParam(fmter QueryFormatter, b []byte, name string) ([]byte, bool) {
	b, ok := m.table.AppendParam(b, m.strct, name)
	if ok {
		return b, true
	}

	switch name {
	case "TableName":
		b = fmter.FormatQuery(b, string(m.table.SQLName))
		return b, true
	case "TableAlias":
		b = append(b, m.table.Alias...)
		return b, true
	case "TableColumns":
		b = appendColumns(b, m.table.Alias, m.table.Fields)
		return b, true
	case "Columns":
		b = appendColumns(b, "", m.table.Fields)
		return b, true
	case "TablePKs":
		b = appendColumns(b, m.table.Alias, m.table.PKs)
		return b, true
	case "PKs":
		b = appendColumns(b, "", m.table.PKs)
		return b, true
	}

	return b, false
}

func (m *structTableModel) Root() reflect.Value {
	return m.root
}

func (m *structTableModel) Index() []int {
	return m.index
}

func (m *structTableModel) ParentIndex() []int {
	return m.index[:len(m.index)-len(m.rel.Field.Index)]
}

func (m *structTableModel) Kind() reflect.Kind {
	return reflect.Struct
}

func (m *structTableModel) Value() reflect.Value {
	return m.strct
}

func (m *structTableModel) Mount(host reflect.Value) {
	m.strct = host.FieldByIndex(m.rel.Field.Index)
	m.structInited = false
}

func (m *structTableModel) initStruct() error {
	if m.structInited {
		return m.structInitErr
	}
	m.structInited = true

	switch m.strct.Kind() {
	case reflect.Invalid:
		m.structInitErr = errModelNil
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
		switch j.Rel.Type {
		case HasOneRelation, BelongsToRelation:
			j.JoinModel.Mount(m.strct)
		}
	}
}

func (structTableModel) Init() error {
	return nil
}

func (m *structTableModel) NextColumnScanner() ColumnScanner {
	return m
}

func (m *structTableModel) AddColumnScanner(_ ColumnScanner) error {
	return nil
}

var _ BeforeScanHook = (*structTableModel)(nil)

func (m *structTableModel) BeforeScan(ctx context.Context) error {
	if !m.table.hasFlag(beforeScanHookFlag) {
		return nil
	}
	return callBeforeScanHook(ctx, m.strct.Addr())
}

var _ AfterScanHook = (*structTableModel)(nil)

func (m *structTableModel) AfterScan(ctx context.Context) error {
	if !m.table.hasFlag(afterScanHookFlag) || !m.structInited {
		return nil
	}

	var firstErr error

	if err := callAfterScanHook(ctx, m.strct.Addr()); err != nil && firstErr == nil {
		firstErr = err
	}

	for _, j := range m.joins {
		switch j.Rel.Type {
		case HasOneRelation, BelongsToRelation:
			if err := j.JoinModel.AfterScan(ctx); err != nil && firstErr == nil {
				firstErr = err
			}
		}
	}

	return firstErr
}

func (m *structTableModel) AfterSelect(ctx context.Context) error {
	if m.table.hasFlag(afterSelectHookFlag) {
		return callAfterSelectHook(ctx, m.strct.Addr())
	}
	return nil
}

func (m *structTableModel) BeforeInsert(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeInsertHookFlag) {
		return callBeforeInsertHook(ctx, m.strct.Addr())
	}
	return ctx, nil
}

func (m *structTableModel) AfterInsert(ctx context.Context) error {
	if m.table.hasFlag(afterInsertHookFlag) {
		return callAfterInsertHook(ctx, m.strct.Addr())
	}
	return nil
}

func (m *structTableModel) BeforeUpdate(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeUpdateHookFlag) && !m.IsNil() {
		return callBeforeUpdateHook(ctx, m.strct.Addr())
	}
	return ctx, nil
}

func (m *structTableModel) AfterUpdate(ctx context.Context) error {
	if m.table.hasFlag(afterUpdateHookFlag) && !m.IsNil() {
		return callAfterUpdateHook(ctx, m.strct.Addr())
	}
	return nil
}

func (m *structTableModel) BeforeDelete(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeDeleteHookFlag) && !m.IsNil() {
		return callBeforeDeleteHook(ctx, m.strct.Addr())
	}
	return ctx, nil
}

func (m *structTableModel) AfterDelete(ctx context.Context) error {
	if m.table.hasFlag(afterDeleteHookFlag) && !m.IsNil() {
		return callAfterDeleteHook(ctx, m.strct.Addr())
	}
	return nil
}

func (m *structTableModel) ScanColumn(
	col types.ColumnInfo, rd types.Reader, n int,
) error {
	ok, err := m.scanColumn(col, rd, n)
	if ok {
		return err
	}
	if m.table.hasFlag(discardUnknownColumnsFlag) || col.Name[0] == '_' {
		return nil
	}
	return fmt.Errorf(
		"pg: can't find column=%s in %s "+
			"(prefix the column with underscore or use discard_unknown_columns)",
		col.Name, m.table,
	)
}

func (m *structTableModel) scanColumn(col types.ColumnInfo, rd types.Reader, n int) (bool, error) {
	// Don't init nil struct if value is NULL.
	if n == -1 &&
		!m.structInited &&
		m.strct.Kind() == reflect.Ptr &&
		m.strct.IsNil() {
		return true, nil
	}

	if err := m.initStruct(); err != nil {
		return true, err
	}

	joinName, fieldName := splitColumn(col.Name)
	if joinName != "" {
		if join := m.GetJoin(joinName); join != nil {
			joinCol := col
			joinCol.Name = fieldName
			return join.JoinModel.scanColumn(joinCol, rd, n)
		}
		if m.table.ModelName == joinName {
			joinCol := col
			joinCol.Name = fieldName
			return m.scanColumn(joinCol, rd, n)
		}
	}

	field, ok := m.table.FieldsMap[col.Name]
	if !ok {
		return false, nil
	}

	return true, field.ScanValue(m.strct, rd, n)
}

func (m *structTableModel) GetJoin(name string) *join {
	for i := range m.joins {
		j := &m.joins[i]
		if j.Rel.Field.GoName == name || j.Rel.Field.SQLName == name {
			return j
		}
	}
	return nil
}

func (m *structTableModel) GetJoins() []join {
	return m.joins
}

func (m *structTableModel) AddJoin(j join) *join {
	m.joins = append(m.joins, j)
	return &m.joins[len(m.joins)-1]
}

func (m *structTableModel) Join(name string, apply func(*Query) (*Query, error)) *join {
	return m.join(m.Value(), name, apply)
}

func (m *structTableModel) join(
	bind reflect.Value, name string, apply func(*Query) (*Query, error),
) *join {
	path := strings.Split(name, ".")
	index := make([]int, 0, len(path))

	currJoin := join{
		BaseModel: m,
		JoinModel: m,
	}
	var lastJoin *join
	var hasColumnName bool

	for _, name := range path {
		rel, ok := currJoin.JoinModel.Table().Relations[name]
		if !ok {
			hasColumnName = true
			break
		}

		currJoin.Rel = rel
		index = append(index, rel.Field.Index...)

		if j := currJoin.JoinModel.GetJoin(name); j != nil {
			currJoin.BaseModel = j.BaseModel
			currJoin.JoinModel = j.JoinModel

			lastJoin = j
		} else {
			model, err := newTableModelIndex(m.table.Type, bind, index, rel)
			if err != nil {
				return nil
			}

			currJoin.Parent = lastJoin
			currJoin.BaseModel = currJoin.JoinModel
			currJoin.JoinModel = model

			lastJoin = currJoin.BaseModel.AddJoin(currJoin)
		}
	}

	// No joins with such name.
	if lastJoin == nil {
		return nil
	}
	if apply != nil {
		lastJoin.ApplyQuery = apply
	}

	if hasColumnName {
		column := path[len(path)-1]
		if column == "_" {
			if lastJoin.Columns == nil {
				lastJoin.Columns = make([]string, 0)
			}
		} else {
			lastJoin.Columns = append(lastJoin.Columns, column)
		}
	}

	return lastJoin
}

func (m *structTableModel) setSoftDeleteField() error {
	fv := m.table.SoftDeleteField.Value(m.strct)
	return m.table.SetSoftDeleteField(fv)
}

func splitColumn(s string) (string, string) {
	ind := strings.Index(s, "__")
	if ind == -1 {
		return "", s
	}
	return s[:ind], s[ind+2:]
}
