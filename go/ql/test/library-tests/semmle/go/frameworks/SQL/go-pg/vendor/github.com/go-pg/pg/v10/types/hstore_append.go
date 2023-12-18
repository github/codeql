package types

import (
	"fmt"
	"reflect"
)

var mapStringStringType = reflect.TypeOf(map[string]string(nil))

func HstoreAppender(typ reflect.Type) AppenderFunc {
	if typ.Key() == stringType && typ.Elem() == stringType {
		return appendMapStringStringValue
	}

	return func(b []byte, v reflect.Value, flags int) []byte {
		err := fmt.Errorf("pg.Hstore(unsupported %s)", v.Type())
		return AppendError(b, err)
	}
}

func appendMapStringString(b []byte, m map[string]string, flags int) []byte {
	if m == nil {
		return AppendNull(b, flags)
	}

	if hasFlag(flags, quoteFlag) {
		b = append(b, '\'')
	}

	for key, value := range m {
		b = appendString2(b, key, flags)
		b = append(b, '=', '>')
		b = appendString2(b, value, flags)
		b = append(b, ',')
	}
	if len(m) > 0 {
		b = b[:len(b)-1] // Strip trailing comma.
	}

	if hasFlag(flags, quoteFlag) {
		b = append(b, '\'')
	}

	return b
}

func appendMapStringStringValue(b []byte, v reflect.Value, flags int) []byte {
	m := v.Convert(mapStringStringType).Interface().(map[string]string)
	return appendMapStringString(b, m, flags)
}
