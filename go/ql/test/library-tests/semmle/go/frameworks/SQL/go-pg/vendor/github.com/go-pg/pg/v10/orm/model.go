package orm

import (
	"database/sql"
	"errors"
	"fmt"
	"reflect"

	"github.com/go-pg/pg/v10/types"
)

var errModelNil = errors.New("pg: Model(nil)")

type useQueryOne interface {
	useQueryOne() bool
}

type HooklessModel interface {
	// Init is responsible to initialize/reset model state.
	// It is called only once no matter how many rows were returned.
	Init() error

	// NextColumnScanner returns a ColumnScanner that is used to scan columns
	// from the current row. It is called once for every row.
	NextColumnScanner() ColumnScanner

	// AddColumnScanner adds the ColumnScanner to the model.
	AddColumnScanner(ColumnScanner) error
}

type Model interface {
	HooklessModel

	AfterScanHook
	AfterSelectHook

	BeforeInsertHook
	AfterInsertHook

	BeforeUpdateHook
	AfterUpdateHook

	BeforeDeleteHook
	AfterDeleteHook
}

func NewModel(value interface{}) (Model, error) {
	return newModel(value, false)
}

func newScanModel(values []interface{}) (Model, error) {
	if len(values) > 1 {
		return Scan(values...), nil
	}
	return newModel(values[0], true)
}

func newModel(value interface{}, scan bool) (Model, error) {
	switch value := value.(type) {
	case Model:
		return value, nil
	case HooklessModel:
		return newModelWithHookStubs(value), nil
	case types.ValueScanner, sql.Scanner:
		if !scan {
			return nil, fmt.Errorf("pg: Model(unsupported %T)", value)
		}
		return Scan(value), nil
	}

	v := reflect.ValueOf(value)
	if !v.IsValid() {
		return nil, errModelNil
	}
	if v.Kind() != reflect.Ptr {
		return nil, fmt.Errorf("pg: Model(non-pointer %T)", value)
	}

	if v.IsNil() {
		typ := v.Type().Elem()
		if typ.Kind() == reflect.Struct {
			return newStructTableModel(GetTable(typ)), nil
		}
		return nil, errModelNil
	}

	v = v.Elem()

	if v.Kind() == reflect.Interface {
		if !v.IsNil() {
			v = v.Elem()
			if v.Kind() != reflect.Ptr {
				return nil, fmt.Errorf("pg: Model(non-pointer %s)", v.Type().String())
			}
		}
	}

	switch v.Kind() {
	case reflect.Struct:
		if v.Type() != timeType {
			return newStructTableModelValue(v), nil
		}
	case reflect.Slice:
		elemType := sliceElemType(v)
		switch elemType.Kind() {
		case reflect.Struct:
			if elemType != timeType {
				return newSliceTableModel(v, elemType), nil
			}
		case reflect.Map:
			if err := validMap(elemType); err != nil {
				return nil, err
			}
			slicePtr := v.Addr().Interface().(*[]map[string]interface{})
			return newMapSliceModel(slicePtr), nil
		}
		return newSliceModel(v, elemType), nil
	case reflect.Map:
		typ := v.Type()
		if err := validMap(typ); err != nil {
			return nil, err
		}
		mapPtr := v.Addr().Interface().(*map[string]interface{})
		return newMapModel(mapPtr), nil
	}

	if !scan {
		return nil, fmt.Errorf("pg: Model(unsupported %T)", value)
	}
	return Scan(value), nil
}

type modelWithHookStubs struct {
	hookStubs
	HooklessModel
}

func newModelWithHookStubs(m HooklessModel) Model {
	return modelWithHookStubs{
		HooklessModel: m,
	}
}

func validMap(typ reflect.Type) error {
	if typ.Key().Kind() != reflect.String || typ.Elem().Kind() != reflect.Interface {
		return fmt.Errorf("pg: Model(unsupported %s, expected *map[string]interface{})",
			typ.String())
	}
	return nil
}
