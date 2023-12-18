package types

import (
	"fmt"
	"reflect"
)

type inOp struct {
	slice     reflect.Value
	stickyErr error
}

var _ ValueAppender = (*inOp)(nil)

func InMulti(values ...interface{}) ValueAppender {
	return &inOp{
		slice: reflect.ValueOf(values),
	}
}

func In(slice interface{}) ValueAppender {
	v := reflect.ValueOf(slice)
	if v.Kind() != reflect.Slice {
		return &inOp{
			stickyErr: fmt.Errorf("pg: In(non-slice %T)", slice),
		}
	}

	return &inOp{
		slice: v,
	}
}

func (in *inOp) AppendValue(b []byte, flags int) ([]byte, error) {
	if in.stickyErr != nil {
		return nil, in.stickyErr
	}
	return appendIn(b, in.slice, flags), nil
}

func appendIn(b []byte, slice reflect.Value, flags int) []byte {
	sliceLen := slice.Len()
	for i := 0; i < sliceLen; i++ {
		if i > 0 {
			b = append(b, ',')
		}

		elem := slice.Index(i)
		if elem.Kind() == reflect.Interface {
			elem = elem.Elem()
		}

		if elem.Kind() == reflect.Slice {
			b = append(b, '(')
			b = appendIn(b, elem, flags)
			b = append(b, ')')
		} else {
			b = appendValue(b, elem, flags)
		}
	}
	return b
}
