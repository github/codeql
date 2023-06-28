package orm

import (
	"fmt"
	"reflect"

	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/types"
)

func compositeScanner(typ reflect.Type) types.ScannerFunc {
	if typ.Kind() == reflect.Ptr {
		typ = typ.Elem()
	}

	var table *Table
	return func(v reflect.Value, rd types.Reader, n int) error {
		if n == -1 {
			v.Set(reflect.Zero(v.Type()))
			return nil
		}

		if table == nil {
			table = GetTable(typ)
		}
		if v.Kind() == reflect.Ptr {
			if v.IsNil() {
				v.Set(reflect.New(v.Type().Elem()))
			}
			v = v.Elem()
		}

		p := newCompositeParser(rd)
		var elemReader *pool.BytesReader

		var firstErr error
		for i := 0; ; i++ {
			elem, err := p.NextElem()
			if err != nil {
				if err == errEndOfComposite {
					break
				}
				return err
			}

			if i >= len(table.Fields) {
				if firstErr == nil {
					firstErr = fmt.Errorf(
						"pg: %s has %d fields, but composite requires at least %d values",
						table, len(table.Fields), i)
				}
				continue
			}

			if elemReader == nil {
				elemReader = pool.NewBytesReader(elem)
			} else {
				elemReader.Reset(elem)
			}

			field := table.Fields[i]
			if elem == nil {
				err = field.ScanValue(v, elemReader, -1)
			} else {
				err = field.ScanValue(v, elemReader, len(elem))
			}
			if err != nil && firstErr == nil {
				firstErr = err
			}
		}

		return firstErr
	}
}

func compositeAppender(typ reflect.Type) types.AppenderFunc {
	if typ.Kind() == reflect.Ptr {
		typ = typ.Elem()
	}

	var table *Table
	return func(b []byte, v reflect.Value, quote int) []byte {
		if table == nil {
			table = GetTable(typ)
		}
		if v.Kind() == reflect.Ptr {
			v = v.Elem()
		}

		b = append(b, "ROW("...)
		for i, f := range table.Fields {
			if i > 0 {
				b = append(b, ',')
			}
			b = f.AppendValue(b, v, quote)
		}
		b = append(b, ')')
		return b
	}
}
