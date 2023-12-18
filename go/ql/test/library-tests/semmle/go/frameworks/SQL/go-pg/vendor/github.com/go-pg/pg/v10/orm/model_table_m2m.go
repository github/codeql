package orm

import (
	"fmt"
	"reflect"

	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/types"
)

type m2mModel struct {
	*sliceTableModel
	baseTable *Table
	rel       *Relation

	buf       []byte
	dstValues map[string][]reflect.Value
	columns   map[string]string
}

var _ TableModel = (*m2mModel)(nil)

func newM2MModel(j *join) *m2mModel {
	baseTable := j.BaseModel.Table()
	joinModel := j.JoinModel.(*sliceTableModel)
	dstValues := dstValues(joinModel, baseTable.PKs)
	if len(dstValues) == 0 {
		return nil
	}
	m := &m2mModel{
		sliceTableModel: joinModel,
		baseTable:       baseTable,
		rel:             j.Rel,

		dstValues: dstValues,
		columns:   make(map[string]string),
	}
	if !m.sliceOfPtr {
		m.strct = reflect.New(m.table.Type).Elem()
	}
	return m
}

func (m *m2mModel) NextColumnScanner() ColumnScanner {
	if m.sliceOfPtr {
		m.strct = reflect.New(m.table.Type).Elem()
	} else {
		m.strct.Set(m.table.zeroStruct)
	}
	m.structInited = false
	return m
}

func (m *m2mModel) AddColumnScanner(_ ColumnScanner) error {
	buf, err := m.modelIDMap(m.buf[:0])
	if err != nil {
		return err
	}
	m.buf = buf

	dstValues, ok := m.dstValues[string(buf)]
	if !ok {
		return fmt.Errorf(
			"pg: relation=%q does not have base %s with id=%q (check join conditions)",
			m.rel.Field.GoName, m.baseTable, buf)
	}

	for _, v := range dstValues {
		if m.sliceOfPtr {
			v.Set(reflect.Append(v, m.strct.Addr()))
		} else {
			v.Set(reflect.Append(v, m.strct))
		}
	}

	return nil
}

func (m *m2mModel) modelIDMap(b []byte) ([]byte, error) {
	for i, col := range m.rel.M2MBaseFKs {
		if i > 0 {
			b = append(b, ',')
		}
		if s, ok := m.columns[col]; ok {
			b = append(b, s...)
		} else {
			return nil, fmt.Errorf("pg: %s does not have column=%q",
				m.sliceTableModel, col)
		}
	}
	return b, nil
}

func (m *m2mModel) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	if n > 0 {
		b, err := rd.ReadFullTemp()
		if err != nil {
			return err
		}

		m.columns[col.Name] = string(b)
		rd = pool.NewBytesReader(b)
	} else {
		m.columns[col.Name] = ""
	}

	if ok, err := m.sliceTableModel.scanColumn(col, rd, n); ok {
		return err
	}
	return nil
}
