package types

import (
	"fmt"
	"reflect"
)

type Hstore struct {
	v reflect.Value

	append AppenderFunc
	scan   ScannerFunc
}

var (
	_ ValueAppender = (*Hstore)(nil)
	_ ValueScanner  = (*Hstore)(nil)
)

func NewHstore(vi interface{}) *Hstore {
	v := reflect.ValueOf(vi)
	if !v.IsValid() {
		panic(fmt.Errorf("pg.Hstore(nil)"))
	}

	typ := v.Type()
	if typ.Kind() == reflect.Ptr {
		typ = typ.Elem()
	}
	if typ.Kind() != reflect.Map {
		panic(fmt.Errorf("pg.Hstore(unsupported %s)", typ))
	}

	return &Hstore{
		v: v,

		append: HstoreAppender(typ),
		scan:   HstoreScanner(typ),
	}
}

func (h *Hstore) Value() interface{} {
	if h.v.IsValid() {
		return h.v.Interface()
	}
	return nil
}

func (h *Hstore) AppendValue(b []byte, flags int) ([]byte, error) {
	return h.append(b, h.v, flags), nil
}

func (h *Hstore) ScanValue(rd Reader, n int) error {
	if h.v.Kind() != reflect.Ptr {
		return fmt.Errorf("pg: Hstore(non-pointer %s)", h.v.Type())
	}

	return h.scan(h.v.Elem(), rd, n)
}
