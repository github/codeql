package orm

import "reflect"

type tableParams struct {
	table *Table
	strct reflect.Value
}

func newTableParams(strct interface{}) (*tableParams, bool) {
	v := reflect.ValueOf(strct)
	if !v.IsValid() {
		return nil, false
	}

	v = reflect.Indirect(v)
	if v.Kind() != reflect.Struct {
		return nil, false
	}

	return &tableParams{
		table: GetTable(v.Type()),
		strct: v,
	}, true
}

func (m *tableParams) AppendParam(fmter QueryFormatter, b []byte, name string) ([]byte, bool) {
	return m.table.AppendParam(b, m.strct, name)
}
