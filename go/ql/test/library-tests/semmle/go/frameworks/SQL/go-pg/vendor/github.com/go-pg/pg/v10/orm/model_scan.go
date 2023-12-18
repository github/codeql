package orm

import (
	"fmt"
	"reflect"

	"github.com/go-pg/pg/v10/types"
)

type scanValuesModel struct {
	Discard
	values []interface{}
}

var _ Model = scanValuesModel{}

//nolint
func Scan(values ...interface{}) scanValuesModel {
	return scanValuesModel{
		values: values,
	}
}

func (scanValuesModel) useQueryOne() bool {
	return true
}

func (m scanValuesModel) NextColumnScanner() ColumnScanner {
	return m
}

func (m scanValuesModel) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	if int(col.Index) >= len(m.values) {
		return fmt.Errorf("pg: no Scan var for column index=%d name=%q",
			col.Index, col.Name)
	}
	return types.Scan(m.values[col.Index], rd, n)
}

//------------------------------------------------------------------------------

type scanReflectValuesModel struct {
	Discard
	values []reflect.Value
}

var _ Model = scanReflectValuesModel{}

func scanReflectValues(values []reflect.Value) scanReflectValuesModel {
	return scanReflectValuesModel{
		values: values,
	}
}

func (scanReflectValuesModel) useQueryOne() bool {
	return true
}

func (m scanReflectValuesModel) NextColumnScanner() ColumnScanner {
	return m
}

func (m scanReflectValuesModel) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	if int(col.Index) >= len(m.values) {
		return fmt.Errorf("pg: no Scan var for column index=%d name=%q",
			col.Index, col.Name)
	}
	return types.ScanValue(m.values[col.Index], rd, n)
}
