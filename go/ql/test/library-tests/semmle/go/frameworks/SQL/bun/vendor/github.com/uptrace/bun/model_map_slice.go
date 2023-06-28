package bun

import (
	"context"
	"database/sql"
	"errors"
	"sort"

	"github.com/uptrace/bun/dialect/feature"
	"github.com/uptrace/bun/schema"
)

type mapSliceModel struct {
	mapModel
	dest *[]map[string]interface{}

	keys []string
}

var _ Model = (*mapSliceModel)(nil)

func newMapSliceModel(db *DB, dest *[]map[string]interface{}) *mapSliceModel {
	return &mapSliceModel{
		mapModel: mapModel{
			db: db,
		},
		dest: dest,
	}
}

func (m *mapSliceModel) Value() interface{} {
	return m.dest
}

func (m *mapSliceModel) SetCap(cap int) {
	if cap > 100 {
		cap = 100
	}
	if slice := *m.dest; len(slice) < cap {
		*m.dest = make([]map[string]interface{}, 0, cap)
	}
}

func (m *mapSliceModel) ScanRows(ctx context.Context, rows *sql.Rows) (int, error) {
	columns, err := rows.Columns()
	if err != nil {
		return 0, err
	}

	m.rows = rows
	m.columns = columns
	dest := makeDest(m, len(columns))

	slice := *m.dest
	if len(slice) > 0 {
		slice = slice[:0]
	}

	var n int

	for rows.Next() {
		m.m = make(map[string]interface{}, len(m.columns))

		m.scanIndex = 0
		if err := rows.Scan(dest...); err != nil {
			return 0, err
		}

		slice = append(slice, m.m)
		n++
	}
	if err := rows.Err(); err != nil {
		return 0, err
	}

	*m.dest = slice
	return n, nil
}

func (m *mapSliceModel) appendColumns(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if err := m.initKeys(); err != nil {
		return nil, err
	}

	for i, k := range m.keys {
		if i > 0 {
			b = append(b, ", "...)
		}
		b = fmter.AppendIdent(b, k)
	}

	return b, nil
}

func (m *mapSliceModel) appendValues(fmter schema.Formatter, b []byte) (_ []byte, err error) {
	if err := m.initKeys(); err != nil {
		return nil, err
	}
	slice := *m.dest

	b = append(b, "VALUES "...)
	if m.db.features.Has(feature.ValuesRow) {
		b = append(b, "ROW("...)
	} else {
		b = append(b, '(')
	}

	if fmter.IsNop() {
		for i := range m.keys {
			if i > 0 {
				b = append(b, ", "...)
			}
			b = append(b, '?')
		}
		return b, nil
	}

	for i, el := range slice {
		if i > 0 {
			b = append(b, "), "...)
			if m.db.features.Has(feature.ValuesRow) {
				b = append(b, "ROW("...)
			} else {
				b = append(b, '(')
			}
		}

		for j, key := range m.keys {
			if j > 0 {
				b = append(b, ", "...)
			}
			b = schema.Append(fmter, b, el[key])
		}
	}

	b = append(b, ')')

	return b, nil
}

func (m *mapSliceModel) initKeys() error {
	if m.keys != nil {
		return nil
	}

	slice := *m.dest
	if len(slice) == 0 {
		return errors.New("bun: map slice is empty")
	}

	first := slice[0]
	keys := make([]string, 0, len(first))

	for k := range first {
		keys = append(keys, k)
	}

	sort.Strings(keys)
	m.keys = keys

	return nil
}
