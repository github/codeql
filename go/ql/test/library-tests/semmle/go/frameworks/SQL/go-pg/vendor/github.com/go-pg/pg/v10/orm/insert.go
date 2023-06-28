package orm

import (
	"fmt"
	"reflect"
	"sort"

	"github.com/go-pg/pg/v10/types"
)

type InsertQuery struct {
	q               *Query
	returningFields []*Field
	placeholder     bool
}

var _ QueryCommand = (*InsertQuery)(nil)

func NewInsertQuery(q *Query) *InsertQuery {
	return &InsertQuery{
		q: q,
	}
}

func (q *InsertQuery) String() string {
	b, err := q.AppendQuery(defaultFmter, nil)
	if err != nil {
		panic(err)
	}
	return string(b)
}

func (q *InsertQuery) Operation() QueryOp {
	return InsertOp
}

func (q *InsertQuery) Clone() QueryCommand {
	return &InsertQuery{
		q:           q.q.Clone(),
		placeholder: q.placeholder,
	}
}

func (q *InsertQuery) Query() *Query {
	return q.q
}

var _ TemplateAppender = (*InsertQuery)(nil)

func (q *InsertQuery) AppendTemplate(b []byte) ([]byte, error) {
	cp := q.Clone().(*InsertQuery)
	cp.placeholder = true
	return cp.AppendQuery(dummyFormatter{}, b)
}

var _ QueryAppender = (*InsertQuery)(nil)

func (q *InsertQuery) AppendQuery(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if q.q.stickyErr != nil {
		return nil, q.q.stickyErr
	}

	if len(q.q.with) > 0 {
		b, err = q.q.appendWith(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	b = append(b, "INSERT INTO "...)
	if q.q.onConflict != nil {
		b, err = q.q.appendFirstTableWithAlias(fmter, b)
	} else {
		b, err = q.q.appendFirstTable(fmter, b)
	}
	if err != nil {
		return nil, err
	}

	b, err = q.appendColumnsValues(fmter, b)
	if err != nil {
		return nil, err
	}

	if q.q.onConflict != nil {
		b = append(b, " ON CONFLICT "...)
		b, err = q.q.onConflict.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}

		if q.q.onConflictDoUpdate() {
			if len(q.q.set) > 0 {
				b, err = q.q.appendSet(fmter, b)
				if err != nil {
					return nil, err
				}
			} else {
				fields, err := q.q.getDataFields()
				if err != nil {
					return nil, err
				}

				if len(fields) == 0 {
					fields = q.q.tableModel.Table().DataFields
				}

				b = q.appendSetExcluded(b, fields)
			}

			if len(q.q.updWhere) > 0 {
				b = append(b, " WHERE "...)
				b, err = q.q.appendUpdWhere(fmter, b)
				if err != nil {
					return nil, err
				}
			}
		}
	}

	if len(q.q.returning) > 0 {
		b, err = q.q.appendReturning(fmter, b)
		if err != nil {
			return nil, err
		}
	} else if len(q.returningFields) > 0 {
		b = appendReturningFields(b, q.returningFields)
	}

	return b, q.q.stickyErr
}

func (q *InsertQuery) appendColumnsValues(fmter QueryFormatter, b []byte) (_ []byte, err error) {
	if q.q.hasMultiTables() {
		if q.q.columns != nil {
			b = append(b, " ("...)
			b, err = q.q.appendColumns(fmter, b)
			if err != nil {
				return nil, err
			}
			b = append(b, ")"...)
		}

		b = append(b, " SELECT * FROM "...)
		b, err = q.q.appendOtherTables(fmter, b)
		if err != nil {
			return nil, err
		}

		return b, nil
	}

	if m, ok := q.q.model.(*mapModel); ok {
		return q.appendMapColumnsValues(b, m.m), nil
	}

	if !q.q.hasTableModel() {
		return nil, errModelNil
	}

	fields, err := q.q.getFields()
	if err != nil {
		return nil, err
	}

	if len(fields) == 0 {
		fields = q.q.tableModel.Table().Fields
	}
	value := q.q.tableModel.Value()

	b = append(b, " ("...)
	b = q.appendColumns(b, fields)
	b = append(b, ") VALUES ("...)
	if m, ok := q.q.tableModel.(*sliceTableModel); ok {
		if m.sliceLen == 0 {
			err = fmt.Errorf("pg: can't bulk-insert empty slice %s", value.Type())
			return nil, err
		}
		b, err = q.appendSliceValues(fmter, b, fields, value)
		if err != nil {
			return nil, err
		}
	} else {
		b, err = q.appendValues(fmter, b, fields, value)
		if err != nil {
			return nil, err
		}
	}
	b = append(b, ")"...)

	return b, nil
}

func (q *InsertQuery) appendMapColumnsValues(b []byte, m map[string]interface{}) []byte {
	keys := make([]string, 0, len(m))

	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	b = append(b, " ("...)

	for i, k := range keys {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = types.AppendIdent(b, k, 1)
	}

	b = append(b, ") VALUES ("...)

	for i, k := range keys {
		if i > 0 {
			b = append(b, ", "...)
		}
		if q.placeholder {
			b = append(b, '?')
		} else {
			b = types.Append(b, m[k], 1)
		}
	}

	b = append(b, ")"...)

	return b
}

func (q *InsertQuery) appendValues(
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
			q.addReturningField(f)
			continue
		}

		switch {
		case q.placeholder:
			b = append(b, '?')
		case (f.Default != "" || f.NullZero()) && f.HasZeroValue(strct):
			b = append(b, "DEFAULT"...)
			q.addReturningField(f)
		default:
			b = f.AppendValue(b, strct, 1)
		}
	}

	for i, v := range q.q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}

		b, err = v.value.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) appendSliceValues(
	fmter QueryFormatter, b []byte, fields []*Field, slice reflect.Value,
) (_ []byte, err error) {
	if q.placeholder {
		return q.appendValues(fmter, b, fields, reflect.Value{})
	}

	sliceLen := slice.Len()
	for i := 0; i < sliceLen; i++ {
		if i > 0 {
			b = append(b, "), ("...)
		}
		el := indirect(slice.Index(i))
		b, err = q.appendValues(fmter, b, fields, el)
		if err != nil {
			return nil, err
		}
	}

	for i, v := range q.q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}

		b, err = v.value.AppendQuery(fmter, b)
		if err != nil {
			return nil, err
		}
	}

	return b, nil
}

func (q *InsertQuery) addReturningField(field *Field) {
	if len(q.q.returning) > 0 {
		return
	}
	for _, f := range q.returningFields {
		if f == field {
			return
		}
	}
	q.returningFields = append(q.returningFields, field)
}

func (q *InsertQuery) appendSetExcluded(b []byte, fields []*Field) []byte {
	b = append(b, " SET "...)
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = append(b, f.Column...)
		b = append(b, " = EXCLUDED."...)
		b = append(b, f.Column...)
	}
	return b
}

func (q *InsertQuery) appendColumns(b []byte, fields []*Field) []byte {
	b = appendColumns(b, "", fields)
	for i, v := range q.q.extraValues {
		if i > 0 || len(fields) > 0 {
			b = append(b, ", "...)
		}
		b = types.AppendIdent(b, v.column, 1)
	}
	return b
}

func appendReturningFields(b []byte, fields []*Field) []byte {
	b = append(b, " RETURNING "...)
	b = appendColumns(b, "", fields)
	return b
}
