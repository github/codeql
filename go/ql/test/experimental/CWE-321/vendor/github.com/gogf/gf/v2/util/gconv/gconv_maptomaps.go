// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gconv

import (
	"reflect"

	"github.com/gogf/gf/v2/errors/gcode"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/internal/json"
)

// MapToMaps converts any slice type variable `params` to another map slice type variable `pointer`.
// See doMapToMaps.
func MapToMaps(params interface{}, pointer interface{}, mapping ...map[string]string) error {
	return doMapToMaps(params, pointer, mapping...)
}

// doMapToMaps converts any map type variable `params` to another map slice variable `pointer`.
//
// The parameter `params` can be type of []map, []*map, []struct, []*struct.
//
// The parameter `pointer` should be type of []map, []*map.
//
// The optional parameter `mapping` is used for struct attribute to map key mapping, which makes
// sense only if the item of `params` is type struct.
func doMapToMaps(params interface{}, pointer interface{}, mapping ...map[string]string) (err error) {
	// If given `params` is JSON, it then uses json.Unmarshal doing the converting.
	switch r := params.(type) {
	case []byte:
		if json.Valid(r) {
			if rv, ok := pointer.(reflect.Value); ok {
				if rv.Kind() == reflect.Ptr {
					return json.UnmarshalUseNumber(r, rv.Interface())
				}
			} else {
				return json.UnmarshalUseNumber(r, pointer)
			}
		}
	case string:
		if paramsBytes := []byte(r); json.Valid(paramsBytes) {
			if rv, ok := pointer.(reflect.Value); ok {
				if rv.Kind() == reflect.Ptr {
					return json.UnmarshalUseNumber(paramsBytes, rv.Interface())
				}
			} else {
				return json.UnmarshalUseNumber(paramsBytes, pointer)
			}
		}
	}
	// Params and its element type check.
	var (
		paramsRv   reflect.Value
		paramsKind reflect.Kind
	)
	if v, ok := params.(reflect.Value); ok {
		paramsRv = v
	} else {
		paramsRv = reflect.ValueOf(params)
	}
	paramsKind = paramsRv.Kind()
	if paramsKind == reflect.Ptr {
		paramsRv = paramsRv.Elem()
		paramsKind = paramsRv.Kind()
	}
	if paramsKind != reflect.Array && paramsKind != reflect.Slice {
		return gerror.NewCode(gcode.CodeInvalidParameter, "params should be type of slice, eg: []map/[]*map/[]struct/[]*struct")
	}
	var (
		paramsElem     = paramsRv.Type().Elem()
		paramsElemKind = paramsElem.Kind()
	)
	if paramsElemKind == reflect.Ptr {
		paramsElem = paramsElem.Elem()
		paramsElemKind = paramsElem.Kind()
	}
	if paramsElemKind != reflect.Map && paramsElemKind != reflect.Struct && paramsElemKind != reflect.Interface {
		return gerror.NewCodef(gcode.CodeInvalidParameter, "params element should be type of map/*map/struct/*struct, but got: %s", paramsElemKind)
	}
	// Empty slice, no need continue.
	if paramsRv.Len() == 0 {
		return nil
	}
	// Pointer and its element type check.
	var (
		pointerRv   = reflect.ValueOf(pointer)
		pointerKind = pointerRv.Kind()
	)
	for pointerKind == reflect.Ptr {
		pointerRv = pointerRv.Elem()
		pointerKind = pointerRv.Kind()
	}
	if pointerKind != reflect.Array && pointerKind != reflect.Slice {
		return gerror.NewCode(gcode.CodeInvalidParameter, "pointer should be type of *[]map/*[]*map")
	}
	var (
		pointerElemType = pointerRv.Type().Elem()
		pointerElemKind = pointerElemType.Kind()
	)
	if pointerElemKind == reflect.Ptr {
		pointerElemKind = pointerElemType.Elem().Kind()
	}
	if pointerElemKind != reflect.Map {
		return gerror.NewCode(gcode.CodeInvalidParameter, "pointer element should be type of map/*map")
	}
	defer func() {
		// Catch the panic, especially the reflection operation panics.
		if exception := recover(); exception != nil {
			if v, ok := exception.(error); ok && gerror.HasStack(v) {
				err = v
			} else {
				err = gerror.NewCodeSkipf(gcode.CodeInternalError, 1, "%+v", exception)
			}
		}
	}()
	var (
		pointerSlice = reflect.MakeSlice(pointerRv.Type(), paramsRv.Len(), paramsRv.Len())
	)
	for i := 0; i < paramsRv.Len(); i++ {
		var item reflect.Value
		if pointerElemType.Kind() == reflect.Ptr {
			item = reflect.New(pointerElemType.Elem())
			if err = MapToMap(paramsRv.Index(i).Interface(), item, mapping...); err != nil {
				return err
			}
			pointerSlice.Index(i).Set(item)
		} else {
			item = reflect.New(pointerElemType)
			if err = MapToMap(paramsRv.Index(i).Interface(), item, mapping...); err != nil {
				return err
			}
			pointerSlice.Index(i).Set(item.Elem())
		}
	}
	pointerRv.Set(pointerSlice)
	return
}
