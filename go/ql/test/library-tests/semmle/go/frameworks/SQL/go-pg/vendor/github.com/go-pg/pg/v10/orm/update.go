package orm

import (
	"fmt"
	"reflect"
	"sort"

	"github.com/go-pg/pg/v10/types"
)

type UpdateQuery struct {
	q           *Query
	omitZero    bool
	placeholder bool
}

var (
	_ QueryAppender = (*UpdateQuery)(nil)
	_ QueryCommand  = (*UpdateQuery)(nil)
)

func NewUpdateQuery(q *Query, omitZero bool) *UpdateQuery {
	return &UpdateQuery{
		q:        q,
		omitZero: omitZero,
	}
}

func (q *UpdateQuery) String() string {
	b, err := q.AppendQuery(defaultFmter, nil)
	if err != nil {
		panic(err)
	}
	return string(b)
}

func (q *UpdateQuery) Operation() QueryOp {
	return UpdateOp
}

func (q *UpdateQuery) Clone() QueryCommand {
	return &UpdateQuery{
		q:           q.q.Clone(),
		omitZero:    q.omitZero,
		placeholder: q.placeholder,
	}
}

func (q *UpdateQuery) Query() *Query {
	return q.q
}

func (q *UpdateQuery) AppendTemplate(b []byte) ([]byte, error) {
	cp := q.Clone().(*UpdateQuery)
	cp.placeholder = true
	return cp.AppendQuery(dummyFormatter{}, b)
}

func (q *UpdateQuery) AppendQuery(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if q.q.stickyErr != nil {
		return nil, q.q.stickyErr
	}

	if len(q.q.with) > 0 {
		b, err = q.q.appendWith(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	b = append(b, "UPDATE "...)

	b, err = q.q.appendFirstTableWithAlias(fmter, b)
	if err != nil {
		return nil, err
	}

	b, err = q.mustAppendSet(fmter, b)
	if err != nil {
		return nil, err
	}

	isSliceModelWithData := q.q.isSliceModelWithData()
	if isSliceModelWithData || q.q.hasMultiTables() {
		b = append(b, " FROM "...)
		b, err = q.q.appendOtherTables(fmter, b)
		if err != nil {
			return nil, err
		}

		if isSliceModelWithData {
			b, err = q.appendSliceModelData(fmter, b)
			if err != nil {
				return nil, err
			}
		}
	}

	b, err = q.mustAppendWhere(fmter, b, isSliceModelWithData)
	if err != nil {
		return nil, err
	}

	if len(q.q.returning) > 0 {
		b, err = q.q.appendReturning(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, q.q.stickyErr
}

func (q *UpdateQuery) mustAppendWhere(
	fmter QueryFormatter, b []byte, isSliceModelWithData bool,
) (_ []byte, err error) {
	b = append(b, " WHERE "...)

	if !isSliceModelWithData {
		return q.q.mustAppendWhere(fmter, b)
	}

	if len(q.q.where) > 0 {
		return q.q.appendWhere(fmter, b)
	}

	table := q.q.tableModel.Table()
	err = table.checkPKs()
	if err != nil {
		return nil, err
	}

	b = appendWhereColumnAndColumn(b, table.Alias, table.PKs)
	return b, nil
}

func (q *UpdateQuery) mustAppendSet(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if len(q.q.set) > 0 {
		return q.q.appendSet(fmter, b)
	}

	b = append(b, " SET "...)

	if m, ok := q.q.model.(*mapModel); ok {
		return q.appendMapSet(b, m.m), nil
	}

	if !q.q.hasTableModel() {
		return nil, errModelNil
	}

	value := q.q.tableModel.Value()
	if value.Kind() == reflect.Struct {
		b, err = q.appendSetStruct(fmter, b, value)
	} else {
		if value.Len() > 0 {
			b, err = q.appendSetSlice(b)
		} else {
			err = fmt.Errorf("pg: can't bulk-update empty slice %s", value.Type())
		}
	}
	if err != nil {
		return nil, err
	}

	return b, nil
}

func (q *UpdateQuery) appendMapSet(b []byte, m map[string]interface{}) []byte {
	keys := make([]string, 0, len(m))

	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	for i, k := range keys {
		if i > 0 {
			b = append(b, ", "...)
		}

		b = types.AppendIdent(b, k, 1)
		b = append(b, " = "...)
		if q.placeholder {
			b = append(b, '?')
		} else {
			b = types.Append(b, m[k], 1)
		}
	}

	return b
}

func (q *UpdateQuery) appendSetStruct(fmter QueryFormatter, b []byte, strct reflect.Value) ([]byte, error) {
	fields, err := q.q.getFields()
	if err != nil {
		return nil, err
	}

	if len(fields) == 0 {
		fields = q.q.tableModel.Table().DataFields
	}

	pos := len(b)
	for _, f := range fields {
		if q.omitZero && f.NullZero() && f.HasZeroValue(strct) {
			continue
		}

		if len(b) != pos {
			b = append(b, ", "...)
			pos = len(b)
		}

		b = append(b, f.Column...)
		b = append(b, " = "...)

		if q.placeholder {
			b = append(b, '?')
			continue
		}

		app, ok := q.q.modelValues[f.SQLName]
		if ok {
			b, err = app.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
		} else {
			b = f.AppendValue(b, strct, 1)
		}
	}

	for i, v := range q.q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}

		b = append(b, v.column...)
		b = append(b, " = "...)

		b, err = v.value.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *UpdateQuery) appendSetSlice(b []byte) ([]byte, error) {
	fields, err := q.q.getFields()
	if err != nil {
		return nil, err
	}

	if len(fields) == 0 {
		fields = q.q.tableModel.Table().DataFields
	}

	var table *Table
	if q.omitZero {
		table = q.q.tableModel.Table()
	}

	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		b = append(b, f.Column...)
		b = append(b, " = "...)
		if q.omitZero && table != nil {
			b = append(b, "COALESCE("...)
		}
		b = append(b, "_data."...)
		b = append(b, f.Column...)
		if q.omitZero && table != nil {
			b = append(b, ", "...)
			if table.Alias != table.SQLName {
				b = append(b, table.Alias...)
				b = append(b, '.')
			}
			b = append(b, f.Column...)
			b = append(b, ")"...)
		}
	}

	return b, nil
}

func (q *UpdateQuery) appendSliceModelData(fmter QueryFormatter, b []byte) ([]byte, error) {
	columns, err := q.q.getDataFields()
	if err != nil {
		return nil, err
	}

	if len(columns) > 0 {
		columns = append(columns, q.q.tableModel.Table().PKs...)
	} else {
		columns = q.q.tableModel.Table().Fields
	}

	return q.appendSliceValues(fmter, b, columns, q.q.tableModel.Value())
}

func (q *UpdateQuery) appendSliceValues(
	fmter QueryFormatter, b []byte, fields []*Field, slice reflect.Value,
) (_ []byte, err error) {
	b = append(b, "(VALUES ("...)

	if q.placeholder {
		b, err = q.appendValues(fmter, b, fields, reflect.Value{})
		if err != nil {
			return nil, err
		}
	} else {
		sliceLen := slice.Len()
		for i := 0; i < sliceLen; i++ {
			if i > 0 {
				b = append(b, "), ("...)
			}
			b, err = q.appendValues(fmter, b, fields, slice.Index(i))
			if err != nil {
				return nil, err
			}
		}
	}

	b = append(b, ")) AS _data("...)
	b = appendColumns(b, "", fields)
	b = append(b, ")"...)

	return b, nil
}

func (q *UpdateQuery) appendValues(
	fmter QueryFormatter, b []byte, fields []*Field, strct reflect.Value,
) (_ []byte, err error) {
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		app, ok := q.q.modelValues[f.SQLName]
		if ok {
			b, err = app.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
			continue
		}

		if q.placeholder {
			b = append(b, '?')
		} else {
			b = f.AppendValue(b, indirect(strct), 1)
		}

		b = append(b, "::"...)
		b = append(b, f.SQLType...)
	}
	return b, nil
}

func appendWhereColumnAndColumn(b []byte, alias types.Safe, fields []*Field) []byte {
	for i, f := range fields {
		if i > 0 {
			b = append(b, " AND "...)
		}
		b = append(b, alias...)
		b = append(b, '.')
		b = append(b, f.Column...)
		b = append(b, " = _data."...)
		b = append(b, f.Column...)
	}
	return b
}
