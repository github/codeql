package schema

import (
	"database/sql/driver"
	"encoding/json"
	"net"
	"reflect"
	"time"
)

var (
	bytesType          = reflect.TypeOf((*[]byte)(nil)).Elem()
	timePtrType        = reflect.TypeOf((*time.Time)(nil))
	timeType           = timePtrType.Elem()
	ipType             = reflect.TypeOf((*net.IP)(nil)).Elem()
	ipNetType          = reflect.TypeOf((*net.IPNet)(nil)).Elem()
	jsonRawMessageType = reflect.TypeOf((*json.RawMessage)(nil)).Elem()

	driverValuerType  = reflect.TypeOf((*driver.Valuer)(nil)).Elem()
	queryAppenderType = reflect.TypeOf((*QueryAppender)(nil)).Elem()
	jsonMarshalerType = reflect.TypeOf((*json.Marshaler)(nil)).Elem()
)

func indirectType(t reflect.Type) reflect.Type {
	if t.Kind() == reflect.Ptr {
		t = t.Elem()
	}
	return t
}

func fieldByIndex(v reflect.Value, index []int) (_ reflect.Value, ok bool) {
	if len(index) == 1 {
		return v.Field(index[0]), true
	}

	for i, idx := range index {
		if i > 0 {
			if v.Kind() == reflect.Ptr {
				if v.IsNil() {
					return v, false
				}
				v = v.Elem()
			}
		}
		v = v.Field(idx)
	}
	return v, true
}

func fieldByIndexAlloc(v reflect.Value, index []int) reflect.Value {
	if len(index) == 1 {
		return v.Field(index[0])
	}

	for i, idx := range index {
		if i > 0 {
			v = indirectNil(v)
		}
		v = v.Field(idx)
	}
	return v
}

func indirectNil(v reflect.Value) reflect.Value {
	if v.Kind() == reflect.Ptr {
		if v.IsNil() {
			v.Set(reflect.New(v.Type().Elem()))
		}
		v = v.Elem()
	}
	return v
}
