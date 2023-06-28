package bun

import (
	"fmt"
	"reflect"
	"strconv"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/schema"
)

type ValuesQuery struct {
	baseQuery
	customValueQuery

	withOrder bool
}

var (
	_ Query                   = (*ValuesQuery)(nil)
	_ schema.NamedArgAppender = (*ValuesQuery)(nil)
)

func NewValuesQuery(db *DB, model interface{}) *ValuesQuery {
	q := &ValuesQuery{
		baseQuery: baseQuery{
			db:   db,
			conn: db.DB,
		},
	}
	q.setModel(model)
	return q
}

func (q *ValuesQuery) Conn(db IConn) *ValuesQuery {
	q.setConn(db)
	return q
}

func (q *ValuesQuery) Err(err error) *ValuesQuery {
	q.setErr(err)
	return q
}

func (q *ValuesQuery) Column(columns ...string) *ValuesQuery {
	for _, column := range columns {
		q.addColumn(schema.UnsafeIdent(column))
	}
	return q
}

// Value overwrites model value for the column.
func (q *ValuesQuery) Value(column string, expr string, args ...interface{}) *ValuesQuery {
	if q.table == nil {
		q.err = errNilModel
		return q
	}
	q.addValue(q.table, column, expr, args)
	return q
}

func (q *ValuesQuery) WithOrder() *ValuesQuery {
	q.withOrder = true
	return q
}

func (q *ValuesQuery) AppendNamedArg(fmter schema.Formatter, b []byte, name string) ([]byte, bool) {
	switch name {
	case "Columns":
		bb, err := q.AppendColumns(fmter, b)
		if err != nil {
			q.setErr(err)
			return b, true
		}
		return bb, true
	}
	return b, false
}

// AppendColumns appends the table columns. It is used by CTE.
func (q *ValuesQuery) AppendColumns(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}
	if q.model == nil {
		return nil, errNilModel
	}

	if q.tableModel != nil {
		fields, err := q.getFields()
		if err != nil {
			return nil, err
		}

		b = appendColumns(b, "", fields)

		if q.withOrder {
			b = append(b, ", _order"...)
		}

		return b, nil
	}

	switch model := q.model.(type) {
	case *mapSliceModel:
		return model.appendColumns(fmter, b)
	}

	return nil, fmt.Errorf("bun: Values does not support %T", q.model)
}

func (q *ValuesQuery) Operation() string {
	return "VALUES"
}

func (q *ValuesQuery) AppendQuery(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if q.err != nil {
		return nil, q.err
	}
	if q.model == nil {
		return nil, errNilModel
	}

	fmter = formatterWithModel(fmter, q)

	if q.tableModel != nil {
		fields, err := q.getFields()
		if err != nil {
			return nil, err
		}
		return q.appendQuery(fmter, b, fields)
	}

	switch model := q.model.(type) {
	case *mapSliceModel:
		return model.appendValues(fmter, b)
	}

	return nil, fmt.Errorf("bun: Values does not support %T", q.model)
}

func (q *ValuesQuery) appendQuery(
	fmter schema.Formatter,
	b []byte,
	fields []*schema.Field,
) (_ []byte, err error) {
	b = append(b, "VALUES "...)
	if q.db.features.Has(feature.ValuesRow) {
		b = append(b, "ROW("...)
	} else {
		b = append(b, '(')
	}

	switch model := q.tableModel.(type) {
	case *structTableModel:
		b, err = q.appendValues(fmter, b, fields, model.strct)
		if err != nil {
			return nil, err
		}

		if q.withOrder {
			b = append(b, ", "...)
			b = strconv.AppendInt(b, 0, 10)
		}
	case *sliceTableModel:
		slice := model.slice
		sliceLen := slice.Len()
		for i := 0; i < sliceLen; i++ {
			if i > 0 {
				b = append(b, "), "...)
				if q.db.features.Has(feature.ValuesRow) {
					b = append(b, "ROW("...)
				} else {
					b = append(b, '(')
				}
			}

			b, err = q.appendValues(fmter, b, fields, slice.Index(i))
			if err != nil {
				return nil, err
			}

			if q.withOrder {
				b = append(b, ", "...)
				b = strconv.AppendInt(b, int64(i), 10)
			}
		}
	default:
		return nil, fmt.Errorf("bun: Values does not support %T", q.model)
	}

	b = append(b, ')')

	return b, nil
}

func (q *ValuesQuery) appendValues(
	fmter schema.Formatter, b []byte, fields []*schema.Field, strct reflect.Value,
) (_ []byte, err error) {
	isTemplate := fmter.IsNop()
	for i, f := range fields {
		if i > 0 {
			b = append(b, ", "...)
		}

		app, ok := q.modelValues[f.Name]
		if ok {
			b, err = app.AppendQuery(fmter, b)
			if err != nil {
				return nil, err
			}
			continue
		}

		if isTemplate {
			b = append(b, '?')
		} else {
			b = f.AppendValue(fmter, b, indirect(strct))
		}

		if fmter.HasFeature(feature.DoubleColonCast) {
			b = append(b, "::"...)
			b = append(b, f.UserSQLType...)
		}
	}
	return b, nil
}
