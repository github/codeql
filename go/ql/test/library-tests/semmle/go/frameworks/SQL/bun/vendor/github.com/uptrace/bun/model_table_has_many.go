package bun

import (
	"context"
	"database/sql"
	"fmt"
	"reflect"

	"github.com/uptrace/bun/internal"
	"github.com/uptrace/bun/schema"
)

type hasManyModel struct {
	*sliceTableModel
	baseTable *schema.Table
	rel       *schema.Relation

	baseValues map[internal.MapKey][]reflect.Value
	structKey  []interface{}
}

var _ TableModel = (*hasManyModel)(nil)

func newHasManyModel(j *relationJoin) *hasManyModel {
	baseTable := j.BaseModel.Table()
	joinModel := j.JoinModel.(*sliceTableModel)
	baseValues := baseValues(joinModel, j.Relation.BaseFields)
	if len(baseValues) == 0 {
		return nil
	}
	m := hasManyModel{
		sliceTableModel: joinModel,
		baseTable:       baseTable,
		rel:             j.Relation,

		baseValues: baseValues,
	}
	if !m.sliceOfPtr {
		m.strct = reflect.New(m.table.Type).Elem()
	}
	return &m
}

func (m *hasManyModel) ScanRows(ctx context.Context, rows *sql.Rows) (int, error) {
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

func (m *hasManyModel) Scan(src interface{}) error {
	column := m.columns[m.scanIndex]
	m.scanIndex++

	field, err := m.table.Field(column)
	if err != nil {
		return err
	}

	if err := field.ScanValue(m.strct, src); err != nil {
		return err
	}

	for _, f := range m.rel.JoinFields {
		if f.Name == field.Name {
			m.structKey = append(m.structKey, field.Value(m.strct).Interface())
			break
		}
	}

	return nil
}

func (m *hasManyModel) parkStruct() error {
	baseValues, ok := m.baseValues[internal.NewMapKey(m.structKey)]
	if !ok {
		return fmt.Errorf(
			"bun: has-many relation=%s does not have base %s with id=%q (check join conditions)",
			m.rel.Field.GoName, m.baseTable, m.structKey)
	}

	for i, v := range baseValues {
		if !m.sliceOfPtr {
			v.Set(reflect.Append(v, m.strct))
			continue
		}

		if i == 0 {
			v.Set(reflect.Append(v, m.strct.Addr()))
			continue
		}

		clone := reflect.New(m.strct.Type()).Elem()
		clone.Set(m.strct)
		v.Set(reflect.Append(v, clone.Addr()))
	}

	return nil
}

func baseValues(model TableModel, fields []*schema.Field) map[internal.MapKey][]reflect.Value {
	fieldIndex := model.Relation().Field.Index
	m := make(map[internal.MapKey][]reflect.Value)
	key := make([]interface{}, 0, len(fields))
	walk(model.rootValue(), model.parentIndex(), func(v reflect.Value) {
		key = modelKey(key[:0], v, fields)
		mapKey := internal.NewMapKey(key)
		m[mapKey] = append(m[mapKey], v.FieldByIndex(fieldIndex))
	})
	return m
}

func modelKey(key []interface{}, strct reflect.Value, fields []*schema.Field) []interface{} {
	for _, f := range fields {
		key = append(key, f.Value(strct).Interface())
	}
	return key
}
