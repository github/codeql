// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gconv

import "github.com/gogf/gf/internal/json"

// SliceMap is alias of Maps.
func SliceMap(any interface{}) []map[string]interface{} {
	return Maps(any)
}

// SliceMapDeep is alias of MapsDeep.
func SliceMapDeep(any interface{}) []map[string]interface{} {
	return MapsDeep(any)
}

// SliceStruct is alias of Structs.
func SliceStruct(params interface{}, pointer interface{}, mapping ...map[string]string) (err error) {
	return Structs(params, pointer, mapping...)
}

// Maps converts `value` to []map[string]interface{}.
// Note that it automatically checks and converts json string to []map if `value` is string/[]byte.
func Maps(value interface{}, tags ...string) []map[string]interface{} {
	if value == nil {
		return nil
	}
	switch r := value.(type) {
	case string:
		list := make([]map[string]interface{}, 0)
		if len(r) > 0 && r[0] == '[' && r[len(r)-1] == ']' {
			if err := json.UnmarshalUseNumber([]byte(r), &list); err != nil {
				return nil
			}
			return list
		} else {
			return nil
		}

	case []byte:
		list := make([]map[string]interface{}, 0)
		if len(r) > 0 && r[0] == '[' && r[len(r)-1] == ']' {
			if err := json.UnmarshalUseNumber(r, &list); err != nil {
				return nil
			}
			return list
		} else {
			return nil
		}

	case []map[string]interface{}:
		return r

	default:
		array := Interfaces(value)
		if len(array) == 0 {
			return nil
		}
		list := make([]map[string]interface{}, len(array))
		for k, v := range array {
			list[k] = Map(v, tags...)
		}
		return list
	}
}

// MapsDeep converts `value` to []map[string]interface{} recursively.
//
// TODO completely implement the recursive converting for all types.
func MapsDeep(value interface{}, tags ...string) []map[string]interface{} {
	if value == nil {
		return nil
	}
	switch r := value.(type) {
	case string:
		list := make([]map[string]interface{}, 0)
		if len(r) > 0 && r[0] == '[' && r[len(r)-1] == ']' {
			if err := json.UnmarshalUseNumber([]byte(r), &list); err != nil {
				return nil
			}
			return list
		} else {
			return nil
		}

	case []byte:
		list := make([]map[string]interface{}, 0)
		if len(r) > 0 && r[0] == '[' && r[len(r)-1] == ']' {
			if err := json.UnmarshalUseNumber(r, &list); err != nil {
				return nil
			}
			return list
		} else {
			return nil
		}

	case []map[string]interface{}:
		list := make([]map[string]interface{}, len(r))
		for k, v := range r {
			list[k] = MapDeep(v, tags...)
		}
		return list

	default:
		array := Interfaces(value)
		if len(array) == 0 {
			return nil
		}
		list := make([]map[string]interface{}, len(array))
		for k, v := range array {
			list[k] = MapDeep(v, tags...)
		}
		return list
	}
}
