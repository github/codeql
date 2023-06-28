package bun

import (
	"context"
	"database/sql"
	"fmt"
	"reflect"

	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type m2mModel struct {
	*sliceTableModel
	baseTable *schema.Table
	rel       *schema.Relation

	baseValues map[internal.MapKey][]reflect.Value
	structKey  []interface{}
}

var _ TableModel = (*m2mModel)(nil)

func newM2MModel(j *relationJoin) *m2mModel {
	baseTable := j.BaseModel.Table()
	joinModel := j.JoinModel.(*sliceTableModel)
	baseValues := baseValues(joinModel, baseTable.PKs)
	if len(baseValues) == 0 {
		return nil
	}
	m := &m2mModel{
		sliceTableModel: joinModel,
		baseTable:       baseTable,
		rel:             j.Relation,

		baseValues: baseValues,
	}
	if !m.sliceOfPtr {
		m.strct = reflect.New(m.table.Type).Elem()
	}
	return m
}

func (m *m2mModel) ScanRows(ctx context.Context, rows *sql.Rows) (int, error) {
	columns, err := rows.Columns()
	if err != nil {
		return 0, err
	}

	m.columns = columns
	dest := makeDest(m, len(columns))

	var n int

	for rows.Next() {
		if m.sliceOfPtr {
			m.strct = reflect.New(m.table.Type).Elem()
		} else {
			m.strct.Set(m.table.ZeroValue)
		}
		m.structInited = false

		m.scanIndex = 0
		m.structKey = m.structKey[:0]
		if err := rows.Scan(dest...); err != nil {
			return 0, err
		}

		if err := m.parkStruct(); err != nil {
			return 0, err
		}

		n++
	}
	if err := rows.Err(); err != nil {
		return 0, err
	}

	return n, nil
}

func (m *m2mModel) Scan(src interface{}) error {
	column := m.columns[m.scanIndex]
	m.scanIndex++

	field, ok := m.table.FieldMap[column]
	if !ok {
		return m.scanM2MColumn(column, src)
	}

	if err := field.ScanValue(m.strct, src); err != nil {
		return err
	}

	for _, fk := range m.rel.M2MBaseFields {
		if fk.Name == field.Name {
			m.structKey = append(m.structKey, field.Value(m.strct).Interface())
			break
		}
	}

	return nil
}

func (m *m2mModel) scanM2MColumn(column string, src interface{}) error {
	for _, field := range m.rel.M2MBaseFields {
		if field.Name == column {
			dest := reflect.New(field.IndirectType).Elem()
			if err := field.Scan(dest, src); err != nil {
				return err
			}
			m.structKey = append(m.structKey, dest.Interface())
			break
		}
	}

	_, err := m.scanColumn(column, src)
	return err
}

func (m *m2mModel) parkStruct() error {
	baseValues, ok := m.baseValues[internal.NewMapKey(m.structKey)]
	if !ok {
		return fmt.Errorf(
			"bun: m2m relation=%s does not have base %s with key=%q (check join conditions)",
			m.rel.Field.GoName, m.baseTable, m.structKey)
	}

	for _, v := range baseValues {
		if m.sliceOfPtr {
			v.Set(reflect.Append(v, m.strct.Addr()))
		} else {
			v.Set(reflect.Append(v, m.strct))
		}
	}

	return nil
}
