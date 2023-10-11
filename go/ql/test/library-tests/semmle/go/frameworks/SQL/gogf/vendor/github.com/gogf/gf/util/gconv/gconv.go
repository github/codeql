// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

// Package gconv implements powerful and convenient converting functionality for any types of variables.
//
// This package should keep much less dependencies with other packages.
package gconv

import (
	"fmt"
	"github.com/gogf/gf/internal/json"
	"github.com/gogf/gf/os/gtime"
	"math"
	"reflect"
	"strconv"
	"strings"
	"time"

	"github.com/gogf/gf/encoding/gbinary"
)

type (
	// errorStack is the interface for Stack feature.
	errorStack interface {
		Error() string
		Stack() string
	}
)

var (
	// Empty strings.
	emptyStringMap = map[string]struct{}{
		"":      {},
		"0":     {},
		"no":    {},
		"off":   {},
		"false": {},
	}

	// StructTagPriority defines the default priority tags for Map*/Struct* functions.
	// Note, the "gconv", "param", "params" tags are used by old version of package.
	// It is strongly recommended using short tag "c" or "p" instead in the future.
	StructTagPriority = []string{"gconv", "param", "params", "c", "p", "json"}
)

type doConvertInput struct {
	FromValue  interface{}   // Value that is converted from.
	ToTypeName string        // Target value type name in string.
	ReferValue interface{}   // Referred value, a value in type `ToTypeName`.
	Extra      []interface{} // Extra values for implementing the converting.
}

// doConvert does commonly used types converting.
func doConvert(input doConvertInput) interface{} {
	switch input.ToTypeName {
	case "int":
		return Int(input.FromValue)
	case "*int":
		if _, ok := input.FromValue.(*int); ok {
			return input.FromValue
		}
		v := Int(input.FromValue)
		return &v

	case "int8":
		return Int8(input.FromValue)
	case "*int8":
		if _, ok := input.FromValue.(*int8); ok {
			return input.FromValue
		}
		v := Int8(input.FromValue)
		return &v

	case "int16":
		return Int16(input.FromValue)
	case "*int16":
		if _, ok := input.FromValue.(*int16); ok {
			return input.FromValue
		}
		v := Int16(input.FromValue)
		return &v

	case "int32":
		return Int32(input.FromValue)
	case "*int32":
		if _, ok := input.FromValue.(*int32); ok {
			return input.FromValue
		}
		v := Int32(input.FromValue)
		return &v

	case "int64":
		return Int64(input.FromValue)
	case "*int64":
		if _, ok := input.FromValue.(*int64); ok {
			return input.FromValue
		}
		v := Int64(input.FromValue)
		return &v

	case "uint":
		return Uint(input.FromValue)
	case "*uint":
		if _, ok := input.FromValue.(*uint); ok {
			return input.FromValue
		}
		v := Uint(input.FromValue)
		return &v

	case "uint8":
		return Uint8(input.FromValue)
	case "*uint8":
		if _, ok := input.FromValue.(*uint8); ok {
			return input.FromValue
		}
		v := Uint8(input.FromValue)
		return &v

	case "uint16":
		return Uint16(input.FromValue)
	case "*uint16":
		if _, ok := input.FromValue.(*uint16); ok {
			return input.FromValue
		}
		v := Uint16(input.FromValue)
		return &v

	case "uint32":
		return Uint32(input.FromValue)
	case "*uint32":
		if _, ok := input.FromValue.(*uint32); ok {
			return input.FromValue
		}
		v := Uint32(input.FromValue)
		return &v

	case "uint64":
		return Uint64(input.FromValue)
	case "*uint64":
		if _, ok := input.FromValue.(*uint64); ok {
			return input.FromValue
		}
		v := Uint64(input.FromValue)
		return &v

	case "float32":
		return Float32(input.FromValue)
	case "*float32":
		if _, ok := input.FromValue.(*float32); ok {
			return input.FromValue
		}
		v := Float32(input.FromValue)
		return &v

	case "float64":
		return Float64(input.FromValue)
	case "*float64":
		if _, ok := input.FromValue.(*float64); ok {
			return input.FromValue
		}
		v := Float64(input.FromValue)
		return &v

	case "bool":
		return Bool(input.FromValue)
	case "*bool":
		if _, ok := input.FromValue.(*bool); ok {
			return input.FromValue
		}
		v := Bool(input.FromValue)
		return &v

	case "string":
		return String(input.FromValue)
	case "*string":
		if _, ok := input.FromValue.(*string); ok {
			return input.FromValue
		}
		v := String(input.FromValue)
		return &v

	case "[]byte":
		return Bytes(input.FromValue)
	case "[]int":
		return Ints(input.FromValue)
	case "[]int32":
		return Int32s(input.FromValue)
	case "[]int64":
		return Int64s(input.FromValue)
	case "[]uint":
		return Uints(input.FromValue)
	case "[]uint8":
		return Bytes(input.FromValue)
	case "[]uint32":
		return Uint32s(input.FromValue)
	case "[]uint64":
		return Uint64s(input.FromValue)
	case "[]float32":
		return Float32s(input.FromValue)
	case "[]float64":
		return Float64s(input.FromValue)
	case "[]string":
		return Strings(input.FromValue)

	case "Time", "time.Time":
		if len(input.Extra) > 0 {
			return Time(input.FromValue, String(input.Extra[0]))
		}
		return Time(input.FromValue)
	case "*time.Time":
		var v interface{}
		if len(input.Extra) > 0 {
			v = Time(input.FromValue, String(input.Extra[0]))
		} else {
			if _, ok := input.FromValue.(*time.Time); ok {
				return input.FromValue
			}
			v = Time(input.FromValue)
		}
		return &v

	case "GTime", "gtime.Time":
		if len(input.Extra) > 0 {
			if v := GTime(input.FromValue, String(input.Extra[0])); v != nil {
				return *v
			} else {
				return *gtime.New()
			}
		}
		if v := GTime(input.FromValue); v != nil {
			return *v
		} else {
			return *gtime.New()
		}
	case "*gtime.Time":
		if len(input.Extra) > 0 {
			if v := GTime(input.FromValue, String(input.Extra[0])); v != nil {
				return v
			} else {
				return gtime.New()
			}
		}
		if v := GTime(input.FromValue); v != nil {
			return v
		} else {
			return gtime.New()
		}

	case "Duration", "time.Duration":
		return Duration(input.FromValue)
	case "*time.Duration":
		if _, ok := input.FromValue.(*time.Duration); ok {
			return input.FromValue
		}
		v := Duration(input.FromValue)
		return &v

	case "map[string]string":
		return MapStrStr(input.FromValue)

	case "map[string]interface{}":
		return Map(input.FromValue)

	case "[]map[string]interface{}":
		return Maps(input.FromValue)

	default:
		if input.ReferValue != nil {
			var (
				referReflectValue reflect.Value
			)
			if v, ok := input.ReferValue.(reflect.Value); ok {
				referReflectValue = v
			} else {
				referReflectValue = reflect.ValueOf(input.ReferValue)
			}
			input.ToTypeName = referReflectValue.Kind().String()
			input.ReferValue = nil
			return reflect.ValueOf(doConvert(input)).Convert(referReflectValue.Type()).Interface()
		}
		return input.FromValue
	}
}

// Convert converts the variable `fromValue` to the type `toTypeName`, the type `toTypeName` is specified by string.
// The optional parameter `extraParams` is used for additional necessary parameter for this conversion.
// It supports common types conversion as its conversion based on type name string.
func Convert(fromValue interface{}, toTypeName string, extraParams ...interface{}) interface{} {
	return doConvert(doConvertInput{
		FromValue:  fromValue,
		ToTypeName: toTypeName,
		ReferValue: nil,
		Extra:      extraParams,
	})
}

// Byte converts `any` to byte.
func Byte(any interface{}) byte {
	if v, ok := any.(byte); ok {
		return v
	}
	return Uint8(any)
}

// Bytes converts `any` to []byte.
func Bytes(any interface{}) []byte {
	if any == nil {
		return nil
	}
	switch value := any.(type) {
	case string:
		return []byte(value)
	case []byte:
		return value
	default:
		if f, ok := value.(apiBytes); ok {
			return f.Bytes()
		}
		var (
			reflectValue = reflect.ValueOf(any)
			reflectKind  = reflectValue.Kind()
		)
		for reflectKind == reflect.Ptr {
			reflectValue = reflectValue.Elem()
			reflectKind = reflectValue.Kind()
		}
		switch reflectKind {
		case reflect.Array, reflect.Slice:
			var (
				ok    = true
				bytes = make([]byte, reflectValue.Len())
			)
			for i, _ := range bytes {
				int32Value := Int32(reflectValue.Index(i).Interface())
				if int32Value < 0 || int32Value > math.MaxUint8 {
					ok = false
					break
				}
				bytes[i] = byte(int32Value)
			}
			if ok {
				return bytes
			}
		}
		return gbinary.Encode(any)
	}
}

// Rune converts `any` to rune.
func Rune(any interface{}) rune {
	if v, ok := any.(rune); ok {
		return v
	}
	return Int32(any)
}

// Runes converts `any` to []rune.
func Runes(any interface{}) []rune {
	if v, ok := any.([]rune); ok {
		return v
	}
	return []rune(String(any))
}

// String converts `any` to string.
// It's most commonly used converting function.
func String(any interface{}) string {
	if any == nil {
		return ""
	}
	switch value := any.(type) {
	case int:
		return strconv.Itoa(value)
	case int8:
		return strconv.Itoa(int(value))
	case int16:
		return strconv.Itoa(int(value))
	case int32:
		return strconv.Itoa(int(value))
	case int64:
		return strconv.FormatInt(value, 10)
	case uint:
		return strconv.FormatUint(uint64(value), 10)
	case uint8:
		return strconv.FormatUint(uint64(value), 10)
	case uint16:
		return strconv.FormatUint(uint64(value), 10)
	case uint32:
		return strconv.FormatUint(uint64(value), 10)
	case uint64:
		return strconv.FormatUint(value, 10)
	case float32:
		return strconv.FormatFloat(float64(value), 'f', -1, 32)
	case float64:
		return strconv.FormatFloat(value, 'f', -1, 64)
	case bool:
		return strconv.FormatBool(value)
	case string:
		return value
	case []byte:
		return string(value)
	case time.Time:
		if value.IsZero() {
			return ""
		}
		return value.String()
	case *time.Time:
		if value == nil {
			return ""
		}
		return value.String()
	case gtime.Time:
		if value.IsZero() {
			return ""
		}
		return value.String()
	case *gtime.Time:
		if value == nil {
			return ""
		}
		return value.String()
	default:
		// Empty checks.
		if value == nil {
			return ""
		}
		if f, ok := value.(apiString); ok {
			// If the variable implements the String() interface,
			// then use that interface to perform the conversion
			return f.String()
		}
		if f, ok := value.(apiError); ok {
			// If the variable implements the Error() interface,
			// then use that interface to perform the conversion
			return f.Error()
		}
		// Reflect checks.
		var (
			rv   = reflect.ValueOf(value)
			kind = rv.Kind()
		)
		switch kind {
		case reflect.Chan,
			reflect.Map,
			reflect.Slice,
			reflect.Func,
			reflect.Ptr,
			reflect.Interface,
			reflect.UnsafePointer:
			if rv.IsNil() {
				return ""
			}
		case reflect.String:
			return rv.String()
		}
		if kind == reflect.Ptr {
			return String(rv.Elem().Interface())
		}
		// Finally, we use json.Marshal to convert.
		if jsonContent, err := json.Marshal(value); err != nil {
			return fmt.Sprint(value)
		} else {
			return string(jsonContent)
		}
	}
}

// Bool converts `any` to bool.
// It returns false if `any` is: false, "", 0, "false", "off", "no", empty slice/map.
func Bool(any interface{}) bool {
	if any == nil {
		return false
	}
	switch value := any.(type) {
	case bool:
		return value
	case []byte:
		if _, ok := emptyStringMap[strings.ToLower(string(value))]; ok {
			return false
		}
		return true
	case string:
		if _, ok := emptyStringMap[strings.ToLower(value)]; ok {
			return false
		}
		return true
	default:
		if f, ok := value.(apiBool); ok {
			return f.Bool()
		}
		rv := reflect.ValueOf(any)
		switch rv.Kind() {
		case reflect.Ptr:
			return !rv.IsNil()
		case reflect.Map:
			fallthrough
		case reflect.Array:
			fallthrough
		case reflect.Slice:
			return rv.Len() != 0
		case reflect.Struct:
			return true
		default:
			s := strings.ToLower(String(any))
			if _, ok := emptyStringMap[s]; ok {
				return false
			}
			return true
		}
	}
}

// Int converts `any` to int.
func Int(any interface{}) int {
	if any == nil {
		return 0
	}
	if v, ok := any.(int); ok {
		return v
	}
	return int(Int64(any))
}

// Int8 converts `any` to int8.
func Int8(any interface{}) int8 {
	if any == nil {
		return 0
	}
	if v, ok := any.(int8); ok {
		return v
	}
	return int8(Int64(any))
}

// Int16 converts `any` to int16.
func Int16(any interface{}) int16 {
	if any == nil {
		return 0
	}
	if v, ok := any.(int16); ok {
		return v
	}
	return int16(Int64(any))
}

// Int32 converts `any` to int32.
func Int32(any interface{}) int32 {
	if any == nil {
		return 0
	}
	if v, ok := any.(int32); ok {
		return v
	}
	return int32(Int64(any))
}

// Int64 converts `any` to int64.
func Int64(any interface{}) int64 {
	if any == nil {
		return 0
	}
	switch value := any.(type) {
	case int:
		return int64(value)
	case int8:
		return int64(value)
	case int16:
		return int64(value)
	case int32:
		return int64(value)
	case int64:
		return value
	case uint:
		return int64(value)
	case uint8:
		return int64(value)
	case uint16:
		return int64(value)
	case uint32:
		return int64(value)
	case uint64:
		return int64(value)
	case float32:
		return int64(value)
	case float64:
		return int64(value)
	case bool:
		if value {
			return 1
		}
		return 0
	case []byte:
		return gbinary.DecodeToInt64(value)
	default:
		if f, ok := value.(apiInt64); ok {
			return f.Int64()
		}
		s := String(value)
		isMinus := false
		if len(s) > 0 {
			if s[0] == '-' {
				isMinus = true
				s = s[1:]
			} else if s[0] == '+' {
				s = s[1:]
			}
		}
		// Hexadecimal
		if len(s) > 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X') {
			if v, e := strconv.ParseInt(s[2:], 16, 64); e == nil {
				if isMinus {
					return -v
				}
				return v
			}
		}
		// Octal
		if len(s) > 1 && s[0] == '0' {
			if v, e := strconv.ParseInt(s[1:], 8, 64); e == nil {
				if isMinus {
					return -v
				}
				return v
			}
		}
		// Decimal
		if v, e := strconv.ParseInt(s, 10, 64); e == nil {
			if isMinus {
				return -v
			}
			return v
		}
		// Float64
		return int64(Float64(value))
	}
}

// Uint converts `any` to uint.
func Uint(any interface{}) uint {
	if any == nil {
		return 0
	}
	if v, ok := any.(uint); ok {
		return v
	}
	return uint(Uint64(any))
}

// Uint8 converts `any` to uint8.
func Uint8(any interface{}) uint8 {
	if any == nil {
		return 0
	}
	if v, ok := any.(uint8); ok {
		return v
	}
	return uint8(Uint64(any))
}

// Uint16 converts `any` to uint16.
func Uint16(any interface{}) uint16 {
	if any == nil {
		return 0
	}
	if v, ok := any.(uint16); ok {
		return v
	}
	return uint16(Uint64(any))
}

// Uint32 converts `any` to uint32.
func Uint32(any interface{}) uint32 {
	if any == nil {
		return 0
	}
	if v, ok := any.(uint32); ok {
		return v
	}
	return uint32(Uint64(any))
}

// Uint64 converts `any` to uint64.
func Uint64(any interface{}) uint64 {
	if any == nil {
		return 0
	}
	switch value := any.(type) {
	case int:
		return uint64(value)
	case int8:
		return uint64(value)
	case int16:
		return uint64(value)
	case int32:
		return uint64(value)
	case int64:
		return uint64(value)
	case uint:
		return uint64(value)
	case uint8:
		return uint64(value)
	case uint16:
		return uint64(value)
	case uint32:
		return uint64(value)
	case uint64:
		return value
	case float32:
		return uint64(value)
	case float64:
		return uint64(value)
	case bool:
		if value {
			return 1
		}
		return 0
	case []byte:
		return gbinary.DecodeToUint64(value)
	default:
		if f, ok := value.(apiUint64); ok {
			return f.Uint64()
		}
		s := String(value)
		// Hexadecimal
		if len(s) > 2 && s[0] == '0' && (s[1] == 'x' || s[1] == 'X') {
			if v, e := strconv.ParseUint(s[2:], 16, 64); e == nil {
				return v
			}
		}
		// Octal
		if len(s) > 1 && s[0] == '0' {
			if v, e := strconv.ParseUint(s[1:], 8, 64); e == nil {
				return v
			}
		}
		// Decimal
		if v, e := strconv.ParseUint(s, 10, 64); e == nil {
			return v
		}
		// Float64
		return uint64(Float64(value))
	}
}

// Float32 converts `any` to float32.
func Float32(any interface{}) float32 {
	if any == nil {
		return 0
	}
	switch value := any.(type) {
	case float32:
		return value
	case float64:
		return float32(value)
	case []byte:
		return gbinary.DecodeToFloat32(value)
	default:
		if f, ok := value.(apiFloat32); ok {
			return f.Float32()
		}
		v, _ := strconv.ParseFloat(String(any), 64)
		return float32(v)
	}
}

// Float64 converts `any` to float64.
func Float64(any interface{}) float64 {
	if any == nil {
		return 0
	}
	switch value := any.(type) {
	case float32:
		return float64(value)
	case float64:
		return value
	case []byte:
		return gbinary.DecodeToFloat64(value)
	default:
		if f, ok := value.(apiFloat64); ok {
			return f.Float64()
		}
		v, _ := strconv.ParseFloat(String(any), 64)
		return v
	}
}
