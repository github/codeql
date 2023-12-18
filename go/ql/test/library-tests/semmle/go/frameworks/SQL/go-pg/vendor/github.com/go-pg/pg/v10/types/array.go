package types

import (
	"fmt"
	"reflect"
)

type Array struct {
	v reflect.Value

	append AppenderFunc
	scan   ScannerFunc
}

var (
	_ ValueAppender = (*Array)(nil)
	_ ValueScanner  = (*Array)(nil)
)

func NewArray(vi interface{}) *Array {
	v := reflect.ValueOf(vi)
	if !v.IsValid() {
		panic(fmt.Errorf("pg: Array(nil)"))
	}

	return &Array{
		v: v,

		append: ArrayAppender(v.Type()),
		scan:   ArrayScanner(v.Type()),
	}
}

func (a *Array) AppendValue(b []byte, flags int) ([]byte, error) {
	if a.append == nil {
		panic(fmt.Errorf("pg: Array(unsupported %s)", a.v.Type()))
	}
	return a.append(b, a.v, flags), nil
}

func (a *Array) ScanValue(rd Reader, n int) error {
	if a.scan == nil {
		return fmt.Errorf("pg: Array(unsupported %s)", a.v.Type())
	}

	if a.v.Kind() != reflect.Ptr {
		return fmt.Errorf("pg: Array(non-pointer %s)", a.v.Type())
	}

	return a.scan(a.v.Elem(), rd, n)
}

func (a *Array) Value() interface{} {
	if a.v.IsValid() {
		return a.v.Interface()
	}
	return nil
}
