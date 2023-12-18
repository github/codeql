package orm

import (
	"reflect"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/types"
)

type sliceModel struct {
	Discard
	slice    reflect.Value
	nextElem func() reflect.Value
	scan     func(reflect.Value, types.Reader, int) error
}

var _ Model = (*sliceModel)(nil)

func newSliceModel(slice reflect.Value, elemType reflect.Type) *sliceModel {
	return &sliceModel{
		slice: slice,
		scan:  types.Scanner(elemType),
	}
}

func (m *sliceModel) Init() error {
	if m.slice.IsValid() && m.slice.Len() > 0 {
		m.slice.Set(m.slice.Slice(0, 0))
	}
	return nil
}

func (m *sliceModel) NextColumnScanner() ColumnScanner {
	return m
}

func (m *sliceModel) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	if m.nextElem == nil {
		m.nextElem = internal.MakeSliceNextElemFunc(m.slice)
	}
	v := m.nextElem()
	return m.scan(v, rd, n)
}
