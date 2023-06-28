package schema

import (
	"database/sql/driver"
	"reflect"
)

var isZeroerType = reflect.TypeOf((*isZeroer)(nil)).Elem()

type isZeroer interface {
	IsZero() bool
}

type IsZeroerFunc func(reflect.Value) bool

func zeroChecker(typ reflect.Type) IsZeroerFunc {
	if typ.Implements(isZeroerType) {
		return isZeroInterface
	}

	kind := typ.Kind()

	if kind != reflect.Ptr {
		ptr := reflect.PtrTo(typ)
		if ptr.Implements(isZeroerType) {
			return addrChecker(isZeroInterface)
		}
	}

	switch kind {
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

	if typ.Implements(driverValuerType) {
		return isZeroDriverValue
	}

	return notZero
}

func addrChecker(fn IsZeroerFunc) IsZeroerFunc {
	return func(v reflect.Value) bool {
		if !v.CanAddr() {
			return false
		}
		return fn(v.Addr())
	}
}

func isZeroInterface(v reflect.Value) bool {
	if v.Kind() == reflect.Ptr && v.IsNil() {
		return true
	}
	return v.Interface().(isZeroer).IsZero()
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

func notZero(v reflect.Value) bool {
	return false
}
