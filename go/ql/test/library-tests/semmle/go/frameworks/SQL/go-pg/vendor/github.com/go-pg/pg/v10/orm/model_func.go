package orm

import (
	"fmt"
	"reflect"
)

var errorType = reflect.TypeOf((*error)(nil)).Elem()

type funcModel struct {
	Model
	fnv  reflect.Value
	fnIn []reflect.Value
}

var _ Model = (*funcModel)(nil)

func newFuncModel(fn interface{}) *funcModel {
	m := &funcModel{
		fnv: reflect.ValueOf(fn),
	}

	fnt := m.fnv.Type()
	if fnt.Kind() != reflect.Func {
		panic(fmt.Errorf("ForEach expects a %s, got a %s",
			reflect.Func, fnt.Kind()))
	}

	if fnt.NumIn() < 1 {
		panic(fmt.Errorf("ForEach expects at least 1 arg, got %d", fnt.NumIn()))
	}

	if fnt.NumOut() != 1 {
		panic(fmt.Errorf("ForEach must return 1 error value, got %d", fnt.NumOut()))
	}
	if fnt.Out(0) != errorType {
		panic(fmt.Errorf("ForEach must return an error, got %T", fnt.Out(0)))
	}

	if fnt.NumIn() > 1 {
		initFuncModelScan(m, fnt)
		return m
	}

	t0 := fnt.In(0)
	var v0 reflect.Value
	if t0.Kind() == reflect.Ptr {
		t0 = t0.Elem()
		v0 = reflect.New(t0)
	} else {
		v0 = reflect.New(t0).Elem()
	}

	m.fnIn = []reflect.Value{v0}

	model, ok := v0.Interface().(Model)
	if ok {
		m.Model = model
		return m
	}

	if v0.Kind() == reflect.Ptr {
		v0 = v0.Elem()
	}
	if v0.Kind() != reflect.Struct {
		panic(fmt.Errorf("ForEach accepts a %s, got %s",
			reflect.Struct, v0.Kind()))
	}
	m.Model = newStructTableModelValue(v0)

	return m
}

func initFuncModelScan(m *funcModel, fnt reflect.Type) {
	m.fnIn = make([]reflect.Value, fnt.NumIn())
	for i := 0; i < fnt.NumIn(); i++ {
		m.fnIn[i] = reflect.New(fnt.In(i)).Elem()
	}
	m.Model = scanReflectValues(m.fnIn)
}

func (m *funcModel) AddColumnScanner(_ ColumnScanner) error {
	out := m.fnv.Call(m.fnIn)
	errv := out[0]
	if !errv.IsNil() {
		return errv.Interface().(error)
	}
	return nil
}
