// Copyright 2016 José Santos <henrique_1609@me.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package jet

import (
	"encoding/json"
	"errors"
	"fmt"
	"html"
	"io"
	"io/ioutil"
	"net/url"
	"reflect"
	"strings"
	"text/template"
)

var defaultVariables map[string]reflect.Value

func init() {
	defaultVariables = map[string]reflect.Value{
		"lower":     reflect.ValueOf(strings.ToLower),
		"upper":     reflect.ValueOf(strings.ToUpper),
		"hasPrefix": reflect.ValueOf(strings.HasPrefix),
		"hasSuffix": reflect.ValueOf(strings.HasSuffix),
		"repeat":    reflect.ValueOf(strings.Repeat),
		"replace":   reflect.ValueOf(strings.Replace),
		"split":     reflect.ValueOf(strings.Split),
		"trimSpace": reflect.ValueOf(strings.TrimSpace),
		"html":      reflect.ValueOf(html.EscapeString),
		"url":       reflect.ValueOf(url.QueryEscape),
		"safeHtml":  reflect.ValueOf(SafeWriter(template.HTMLEscape)),
		"safeJs":    reflect.ValueOf(SafeWriter(template.JSEscape)),
		"raw":       reflect.ValueOf(SafeWriter(unsafePrinter)),
		"unsafe":    reflect.ValueOf(SafeWriter(unsafePrinter)),
		"writeJson": reflect.ValueOf(jsonRenderer),
		"json":      reflect.ValueOf(json.Marshal),
		"map":       reflect.ValueOf(newMap),
		"slice":     reflect.ValueOf(newSlice),
		"array":     reflect.ValueOf(newSlice),
		"isset": reflect.ValueOf(Func(func(a Arguments) reflect.Value {
			a.RequireNumOfArguments("isset", 1, -1)
			for i := 0; i < a.NumOfArguments(); i++ {
				if !a.IsSet(i) {
					return valueBoolFALSE
				}
			}
			return valueBoolTRUE
		})),
		"len": reflect.ValueOf(Func(func(a Arguments) reflect.Value {
			a.RequireNumOfArguments("len", 1, 1)

			expression := a.Get(0)
			if !expression.IsValid() {
				a.Panicf("len(): argument is not a valid value")
			}
			if expression.Kind() == reflect.Ptr || expression.Kind() == reflect.Interface {
				expression = expression.Elem()
			}

			switch expression.Kind() {
			case reflect.Array, reflect.Chan, reflect.Slice, reflect.Map, reflect.String:
				return reflect.ValueOf(expression.Len())
			case reflect.Struct:
				return reflect.ValueOf(expression.NumField())
			}

			a.Panicf("len(): invalid value type %s", expression.Type())
			return reflect.Value{}
		})),
		"includeIfExists": reflect.ValueOf(Func(func(a Arguments) reflect.Value {
			a.RequireNumOfArguments("includeIfExists", 1, 2)
			t, err := a.runtime.set.GetTemplate(a.Get(0).String())
			// If template exists but returns an error then panic instead of failing silently
			if t != nil && err != nil {
				panic(fmt.Errorf("including %s: %w", a.Get(0).String(), err))
			}
			if err != nil {
				return hiddenFalse
			}

			a.runtime.newScope()
			defer a.runtime.releaseScope()

			a.runtime.blocks = t.processedBlocks
			root := t.Root
			if t.extends != nil {
				root = t.extends.Root
			}

			if a.NumOfArguments() > 1 {
				c := a.runtime.context
				defer func() { a.runtime.context = c }()
				a.runtime.context = a.Get(1)
			}

			a.runtime.executeList(root)

			return hiddenTrue
		})),
		"exec": reflect.ValueOf(Func(func(a Arguments) (result reflect.Value) {
			a.RequireNumOfArguments("exec", 1, 2)
			t, err := a.runtime.set.GetTemplate(a.Get(0).String())
			if err != nil {
				panic(fmt.Errorf("exec(%s, %v): %w", a.Get(0), a.Get(1), err))
			}

			a.runtime.newScope()
			defer a.runtime.releaseScope()

			w := a.runtime.Writer
			defer func() { a.runtime.Writer = w }()
			a.runtime.Writer = ioutil.Discard

			a.runtime.blocks = t.processedBlocks
			root := t.Root
			if t.extends != nil {
				root = t.extends.Root
			}

			if a.NumOfArguments() > 1 {
				c := a.runtime.context
				defer func() { a.runtime.context = c }()
				a.runtime.context = a.Get(1)
			}
			result = a.runtime.executeList(root)

			return result
		})),
		"ints": reflect.ValueOf(Func(func(a Arguments) (result reflect.Value) {
			var from, to int64
			err := a.ParseInto(&from, &to)
			if err != nil {
				panic(err)
			}
			// check to > from
			if to <= from {
				panic(errors.New("invalid range for ints ranger: 'from' must be smaller than 'to'"))
			}
			return reflect.ValueOf(newIntsRanger(from, to))
		})),
		"dump": reflect.ValueOf(Func(func(a Arguments) (result reflect.Value) {
			switch numArgs := a.NumOfArguments(); numArgs {
			case 0:
				// no arguments were provided, dump all; do not recurse over parents
				return dumpAll(a, 0)
			case 1:
				if arg := a.Get(0); arg.Kind() == reflect.Float64 {
					// dump all, maybe walk into parents
					return dumpAll(a, int(arg.Float()))
				}
				fallthrough
			default:
				// one or more arguments were provided, grab them and check they are all strings
				ids := make([]string, numArgs)
				for i := range ids {
					arg := a.Get(i)
					if arg.Kind() != reflect.String {
						panic(fmt.Errorf("dump: expected argument %d to be a string, but got a %T", i, arg.Interface()))
					}
					ids = append(ids, arg.String())
				}
				return dumpIdentified(a.runtime, ids)
			}
		})),
	}
}

type hiddenBool bool

func (m hiddenBool) Render(r *Runtime) { /* render nothing -> hidden */ }

var hiddenTrue = reflect.ValueOf(hiddenBool(true))
var hiddenFalse = reflect.ValueOf(hiddenBool(false))

func jsonRenderer(v interface{}) RendererFunc {
	return func(r *Runtime) {
		err := json.NewEncoder(r.Writer).Encode(v)
		if err != nil {
			panic(err)
		}
	}
}

func unsafePrinter(w io.Writer, b []byte) {
	w.Write(b)
}

// SafeWriter is a function that writes bytes directly to the render output, without going through Jet's auto-escaping phase.
// Use/implement this if content should be escaped differently or not at all (see raw/unsafe builtins).
type SafeWriter func(io.Writer, []byte)

var stringType = reflect.TypeOf("")

var newMap = Func(func(a Arguments) reflect.Value {
	if a.NumOfArguments()%2 > 0 {
		panic("map(): incomplete key-value pair (even number of arguments required)")
	}

	m := reflect.ValueOf(make(map[string]interface{}, a.NumOfArguments()/2))

	for i := 0; i < a.NumOfArguments(); i += 2 {
		key := a.Get(i)
		if !key.IsValid() {
			a.Panicf("map(): key argument at position %d is not a valid value!", i)
		}
		if !key.Type().ConvertibleTo(stringType) {
			a.Panicf("map(): can't use %+v as string key: %s is not convertible to string", key, key.Type())
		}
		key = key.Convert(stringType)
		m.SetMapIndex(a.Get(i), a.Get(i+1))
	}

	return m
})

var newSlice = Func(func(a Arguments) reflect.Value {
	arr := make([]interface{}, a.NumOfArguments())
	for i := 0; i < a.NumOfArguments(); i++ {
		arr[i] = a.Get(i).Interface()
	}
	return reflect.ValueOf(arr)
})
