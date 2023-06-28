package zerochecker

import (
	"database/sql/driver"
	"reflect"
)

var driverValuerType = reflect.TypeOf((*driver.Valuer)(nil)).Elem()
var appenderType = reflect.TypeOf((*valueAppender)(nil)).Elem()
var isZeroerType = reflect.TypeOf((*isZeroer)(nil)).Elem()

type isZeroer interface {
	IsZero() bool
}

type valueAppender interface {
	AppendValue(b []byte, flags int) ([]byte, error)
}

type Func func(reflect.Value) bool

func Checker(typ reflect.Type) Func {
	if typ.Implements(isZeroerType) {
		return isZeroInterface
	}

	switch typ.Kind() {
	case reflect.Array:
		if typ.Elem().Kind() == reflect.Uint8 {
			return isZeroBytes
		}
		return isZeroLen
	case reflect.String:
		return isZeroLen
	case reflect.Bool:
		return isZeroBool
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		return isZeroInt
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		return isZeroUint
	case reflect.Float32, reflect.Float64:
		return isZeroFloat
	case reflect.Interface, reflect.Ptr, reflect.Slice, reflect.Map:
		return isNil
	}

	if typ.Implements(appenderType) {
		return isZeroAppenderValue
	}
	if typ.Implements(driverValuerType) {
		return isZeroDriverValue
	}

	return isZeroFalse
}

func isZeroInterface(v reflect.Value) bool {
	if v.Kind() == reflect.Ptr && v.IsNil() {
		return true
	}
	return v.Interface().(isZeroer).IsZero()
}

func isZeroAppenderValue(v reflect.Value) bool {
	if v.Kind() == reflect.Ptr {
		return v.IsNil()
	}

	appender := v.Interface().(valueAppender)
	value, err := appender.AppendValue(nil, 0)
	if err != nil {
		return false
	}
	return value == nil
}

func isZeroDriverValue(v reflect.Value) bool {
	if v.Kind() == reflect.Ptr {
		return v.IsNil()
	}

	valuer := v.Interface().(driver.Valuer)
	value, err := valuer.Value()
	if err != nil {
		return false
	}
	return value == nil
}

func isZeroLen(v reflect.Value) bool {
	return v.Len() == 0
}

func isNil(v reflect.Value) bool {
	return v.IsNil()
}

func isZeroBool(v reflect.Value) bool {
	return !v.Bool()
}

func isZeroInt(v reflect.Value) bool {
	return v.Int() == 0
}

func isZeroUint(v reflect.Value) bool {
	return v.Uint() == 0
}

func isZeroFloat(v reflect.Value) bool {
	return v.Float() == 0
}

func isZeroBytes(v reflect.Value) bool {
	b := v.Slice(0, v.Len()).Bytes()
	for _, c := range b {
		if c != 0 {
			return false
		}
	}
	return true
}

func isZeroFalse(v reflect.Value) bool {
	return false
}
