package orm

import (
	"context"
	"reflect"

	"github.com/go-pg/pg/v10/internal"
)

type sliceTableModel struct {
	structTableModel

	slice      reflect.Value
	sliceLen   int
	sliceOfPtr bool
	nextElem   func() reflect.Value
}

var _ TableModel = (*sliceTableModel)(nil)

func newSliceTableModel(slice reflect.Value, elemType reflect.Type) *sliceTableModel {
	m := &sliceTableModel{
		structTableModel: structTableModel{
			table: GetTable(elemType),
			root:  slice,
		},
		slice:    slice,
		sliceLen: slice.Len(),
		nextElem: internal.MakeSliceNextElemFunc(slice),
	}
	m.init(slice.Type())
	return m
}

func (m *sliceTableModel) init(sliceType reflect.Type) {
	switch sliceType.Elem().Kind() {
	case reflect.Ptr, reflect.Interface:
		m.sliceOfPtr = true
	}
}

//nolint
func (*sliceTableModel) useQueryOne() {}

func (m *sliceTableModel) IsNil() bool {
	return false
}

func (m *sliceTableModel) AppendParam(fmter QueryFormatter, b []byte, name string) ([]byte, bool) {
	if field, ok := m.table.FieldsMap[name]; ok {
		b = append(b, "_data."...)
		b = append(b, field.Column...)
		return b, true
	}
	return m.structTableModel.AppendParam(fmter, b, name)
}

func (m *sliceTableModel) Join(name string, apply func(*Query) (*Query, error)) *join {
	return m.join(m.Value(), name, apply)
}

func (m *sliceTableModel) Bind(bind reflect.Value) {
	m.slice = bind.Field(m.index[len(m.index)-1])
}

func (m *sliceTableModel) Kind() reflect.Kind {
	return reflect.Slice
}

func (m *sliceTableModel) Value() reflect.Value {
	return m.slice
}

func (m *sliceTableModel) Init() error {
	if m.slice.IsValid() && m.slice.Len() > 0 {
		m.slice.Set(m.slice.Slice(0, 0))
	}
	return nil
}

func (m *sliceTableModel) NextColumnScanner() ColumnScanner {
	m.strct = m.nextElem()
	m.structInited = false
	return m
}

func (m *sliceTableModel) AddColumnScanner(_ ColumnScanner) error {
	return nil
}

// Inherit these hooks from structTableModel.
var (
	_ BeforeScanHook = (*sliceTableModel)(nil)
	_ AfterScanHook  = (*sliceTableModel)(nil)
)

func (m *sliceTableModel) AfterSelect(ctx context.Context) error {
	if m.table.hasFlag(afterSelectHookFlag) {
		return callAfterSelectHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return nil
}

func (m *sliceTableModel) BeforeInsert(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeInsertHookFlag) {
		return callBeforeInsertHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return ctx, nil
}

func (m *sliceTableModel) AfterInsert(ctx context.Context) error {
	if m.table.hasFlag(afterInsertHookFlag) {
		return callAfterInsertHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return nil
}

func (m *sliceTableModel) BeforeUpdate(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeUpdateHookFlag) && !m.IsNil() {
		return callBeforeUpdateHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return ctx, nil
}

func (m *sliceTableModel) AfterUpdate(ctx context.Context) error {
	if m.table.hasFlag(afterUpdateHookFlag) {
		return callAfterUpdateHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return nil
}

func (m *sliceTableModel) BeforeDelete(ctx context.Context) (context.Context, error) {
	if m.table.hasFlag(beforeDeleteHookFlag) && !m.IsNil() {
		return callBeforeDeleteHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return ctx, nil
}

func (m *sliceTableModel) AfterDelete(ctx context.Context) error {
	if m.table.hasFlag(afterDeleteHookFlag) && !m.IsNil() {
		return callAfterDeleteHookSlice(ctx, m.slice, m.sliceOfPtr)
	}
	return nil
}

func (m *sliceTableModel) setSoftDeleteField() error {
	sliceLen := m.slice.Len()
	for i := 0; i < sliceLen; i++ {
		strct := indirect(m.slice.Index(i))
		fv := m.table.SoftDeleteField.Value(strct)
		if err := m.table.SetSoftDeleteField(fv); err != nil {
			return err
		}
	}
	return nil
}
