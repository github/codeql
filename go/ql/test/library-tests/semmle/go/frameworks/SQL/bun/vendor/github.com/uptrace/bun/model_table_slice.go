package bun

import (
	"context"
	"database/sql"
	"reflect"
	"time"

	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type sliceTableModel struct {
	structTableModel

	slice      reflect.Value
	sliceLen   int
	sliceOfPtr bool
	nextElem   func() reflect.Value
}

var _ TableModel = (*sliceTableModel)(nil)

func newSliceTableModel(
	db *DB, dest interface{}, slice reflect.Value, elemType reflect.Type,
) *sliceTableModel {
	m := &sliceTableModel{
		structTableModel: structTableModel{
			db:    db,
			table: db.Table(elemType),
			dest:  dest,
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

func (m *sliceTableModel) join(name string) *relationJoin {
	return m._join(m.slice, name)
}

func (m *sliceTableModel) ScanRows(ctx context.Context, rows *sql.Rows) (int, error) {
	columns, err := rows.Columns()
	if err != nil {
		return 0, err
	}

	m.columns = columns
	dest := makeDest(m, len(columns))

	if m.slice.IsValid() && m.slice.Len() > 0 {
		m.slice.Set(m.slice.Slice(0, 0))
	}

	var n int

	for rows.Next() {
		m.strct = m.nextElem()
		if m.sliceOfPtr {
			m.strct = m.strct.Elem()
		}
		m.structInited = false

		if err := m.scanRow(ctx, rows, dest); err != nil {
			return 0, err
		}

		n++
	}
	if err := rows.Err(); err != nil {
		return 0, err
	}

	return n, nil
}

var _ schema.BeforeAppendModelHook = (*sliceTableModel)(nil)

func (m *sliceTableModel) BeforeAppendModel(ctx context.Context, query Query) error {
	if !m.table.HasBeforeAppendModelHook() || !m.slice.IsValid() {
		return nil
	}

	sliceLen := m.slice.Len()
	for i := 0; i < sliceLen; i++ {
		strct := m.slice.Index(i)
		if !m.sliceOfPtr {
			strct = strct.Addr()
		}
		err := strct.Interface().(schema.BeforeAppendModelHook).BeforeAppendModel(ctx, query)
		if err != nil {
			return err
		}
	}
	return nil
}

// Inherit these hooks from structTableModel.
var (
	_ schema.BeforeScanRowHook = (*sliceTableModel)(nil)
	_ schema.AfterScanRowHook  = (*sliceTableModel)(nil)
)

func (m *sliceTableModel) updateSoftDeleteField(tm time.Time) error {
	sliceLen := m.slice.Len()
	for i := 0; i < sliceLen; i++ {
		strct := indirect(m.slice.Index(i))
		fv := m.table.SoftDeleteField.Value(strct)
		if err := m.table.UpdateSoftDeleteField(fv, tm); err != nil {
			return err
		}
	}
	return nil
}
