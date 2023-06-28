package types

import (
	"reflect"
	"strconv"
	"sync"
)

var (
	stringType      = reflect.TypeOf((*string)(nil)).Elem()
	sliceStringType = reflect.TypeOf([]string(nil))

	intType      = reflect.TypeOf((*int)(nil)).Elem()
	sliceIntType = reflect.TypeOf([]int(nil))

	int64Type      = reflect.TypeOf((*int64)(nil)).Elem()
	sliceInt64Type = reflect.TypeOf([]int64(nil))

	float64Type      = reflect.TypeOf((*float64)(nil)).Elem()
	sliceFloat64Type = reflect.TypeOf([]float64(nil))
)

var arrayAppendersMap sync.Map

func ArrayAppender(typ reflect.Type) AppenderFunc {
	if v, ok := arrayAppendersMap.Load(typ); ok {
		return v.(AppenderFunc)
	}
	fn := arrayAppender(typ)
	arrayAppendersMap.Store(typ, fn)
	return fn
}

func arrayAppender(typ reflect.Type) AppenderFunc {
	kind := typ.Kind()
	if kind == reflect.Ptr {
		typ = typ.Elem()
		kind = typ.Kind()
	}

	switch kind {
	case reflect.Slice, reflect.Array:
		// ok:
	default:
		return nil
	}

	elemType := typ.Elem()

	if kind == reflect.Slice {
		switch elemType {
		case stringType:
			return appendSliceStringValue
		case intType:
			return appendSliceIntValue
		case int64Type:
			return appendSliceInt64Value
		case float64Type:
			return appendSliceFloat64Value
		}
	}

	appendElem := appender(elemType, true)
	return func(b []byte, v reflect.Value, flags int) []byte {
		flags |= arrayFlag

		kind := v.Kind()
		switch kind {
		case reflect.Ptr, reflect.Slice:
			if v.IsNil() {
				return AppendNull(b, flags)
			}
		}

		if kind == reflect.Ptr {
			v = v.Elem()
		}

		quote := shouldQuoteArray(flags)
		if quote {
			b = append(b, '\'')
		}

		flags |= subArrayFlag

		b = append(b, '{')
		for i := 0; i < v.Len(); i++ {
			elem := v.Index(i)
			b = appendElem(b, elem, flags)
			b = append(b, ',')
		}
		if v.Len() > 0 {
			b[len(b)-1] = '}' // Replace trailing comma.
		} else {
			b = append(b, '}')
		}

		if quote {
			b = append(b, '\'')
		}

		return b
	}
}

func appendSliceStringValue(b []byte, v reflect.Value, flags int) []byte {
	ss := v.Convert(sliceStringType).Interface().([]string)
	return appendSliceString(b, ss, flags)
}

func appendSliceString(b []byte, ss []string, flags int) []byte {
	if ss == nil {
		return AppendNull(b, flags)
	}

	quote := shouldQuoteArray(flags)
	if quote {
		b = append(b, '\'')
	}

	b = append(b, '{')
	for _, s := range ss {
		b = appendString2(b, s, flags)
		b = append(b, ',')
	}
	if len(ss) > 0 {
		b[len(b)-1] = '}' // Replace trailing comma.
	} else {
		b = append(b, '}')
	}

	if quote {
		b = append(b, '\'')
	}

	return b
}

func appendSliceIntValue(b []byte, v reflect.Value, flags int) []byte {
	ints := v.Convert(sliceIntType).Interface().([]int)
	return appendSliceInt(b, ints, flags)
}

func appendSliceInt(b []byte, ints []int, flags int) []byte {
	if ints == nil {
		return AppendNull(b, flags)
	}

	quote := shouldQuoteArray(flags)
	if quote {
		b = append(b, '\'')
	}

	b = append(b, '{')
	for _, n := range ints {
		b = strconv.AppendInt(b, int64(n), 10)
		b = append(b, ',')
	}
	if len(ints) > 0 {
		b[len(b)-1] = '}' // Replace trailing comma.
	} else {
		b = append(b, '}')
	}

	if quote {
		b = append(b, '\'')
	}

	return b
}

func appendSliceInt64Value(b []byte, v reflect.Value, flags int) []byte {
	ints := v.Convert(sliceInt64Type).Interface().([]int64)
	return appendSliceInt64(b, ints, flags)
}

func appendSliceInt64(b []byte, ints []int64, flags int) []byte {
	if ints == nil {
		return AppendNull(b, flags)
	}

	quote := shouldQuoteArray(flags)
	if quote {
		b = append(b, '\'')
	}

	b = append(b, '{')
	for _, n := range ints {
		b = strconv.AppendInt(b, n, 10)
		b = append(b, ',')
	}
	if len(ints) > 0 {
		b[len(b)-1] = '}' // Replace trailing comma.
	} else {
		b = append(b, '}')
	}

	if quote {
		b = append(b, '\'')
	}

	return b
}

func appendSliceFloat64Value(b []byte, v reflect.Value, flags int) []byte {
	floats := v.Convert(sliceFloat64Type).Interface().([]float64)
	return appendSliceFloat64(b, floats, flags)
}

func appendSliceFloat64(b []byte, floats []float64, flags int) []byte {
	if floats == nil {
		return AppendNull(b, flags)
	}

	quote := shouldQuoteArray(flags)
	if quote {
		b = append(b, '\'')
	}

	b = append(b, '{')
	for _, n := range floats {
		b = appendFloat2(b, n, flags)
		b = append(b, ',')
	}
	if len(floats) > 0 {
		b[len(b)-1] = '}' // Replace trailing comma.
	} else {
		b = append(b, '}')
	}

	if quote {
		b = append(b, '\'')
	}

	return b
}
