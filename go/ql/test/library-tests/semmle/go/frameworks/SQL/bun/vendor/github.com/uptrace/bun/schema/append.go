package schema

import (
	"fmt"
	"reflect"
	"strconv"
	"time"

	"github.com/uptrace/bun/dialect"
)

func Append(fmter Formatter, b []byte, v interface{}) []byte {
	switch v := v.(type) {
	case nil:
		return dialect.AppendNull(b)
	case bool:
		return dialect.AppendBool(b, v)
	case int:
		return strconv.AppendInt(b, int64(v), 10)
	case int32:
		return strconv.AppendInt(b, int64(v), 10)
	case int64:
		return strconv.AppendInt(b, v, 10)
	case uint:
		return strconv.AppendInt(b, int64(v), 10)
	case uint32:
		return fmter.Dialect().AppendUint32(b, v)
	case uint64:
		return fmter.Dialect().AppendUint64(b, v)
	case float32:
		return dialect.AppendFloat32(b, v)
	case float64:
		return dialect.AppendFloat64(b, v)
	case string:
		return fmter.Dialect().AppendString(b, v)
	case time.Time:
		return fmter.Dialect().AppendTime(b, v)
	case []byte:
		return fmter.Dialect().AppendBytes(b, v)
	case QueryAppender:
		return AppendQueryAppender(fmter, b, v)
	default:
		vv := reflect.ValueOf(v)
		if vv.Kind() == reflect.Ptr && vv.IsNil() {
			return dialect.AppendNull(b)
		}
		appender := Appender(fmter.Dialect(), vv.Type())
		return appender(fmter, b, vv)
	}
}

//------------------------------------------------------------------------------

func In(slice interface{}) QueryAppender {
	v := reflect.ValueOf(slice)
	if v.Kind() != reflect.Slice {
		return &inValues{
			err: fmt.Errorf("bun: In(non-slice %T)", slice),
		}
	}
	return &inValues{
		slice: v,
	}
}

type inValues struct {
	slice reflect.Value
	err   error
}

var _ QueryAppender = (*inValues)(nil)

func (in *inValues) AppendQuery(fmter Formatter, b []byte) (_ []byte, err error) {
	if in.err != nil {
		return nil, in.err
	}
	return appendIn(fmter, b, in.slice), nil
}

func appendIn(fmter Formatter, b []byte, slice reflect.Value) []byte {
	sliceLen := slice.Len()

	if sliceLen == 0 {
		return append(b, "NULL"...)
	}

	for i := 0; i < sliceLen; i++ {
		if i > 0 {
			b = append(b, ", "...)
		}

		elem := slice.Index(i)
		if elem.Kind() == reflect.Interface {
			elem = elem.Elem()
		}

		if elem.Kind() == reflect.Slice && elem.Type() != bytesType {
			b = append(b, '(')
			b = appendIn(fmter, b, elem)
			b = append(b, ')')
		} else {
			b = fmter.AppendValue(b, elem)
		}
	}
	return b
}
