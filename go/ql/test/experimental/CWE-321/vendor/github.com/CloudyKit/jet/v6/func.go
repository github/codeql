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
	"fmt"
	"reflect"
	"time"
)

// Arguments holds the arguments passed to jet.Func.
type Arguments struct {
	runtime  *Runtime
	args     CallArgs
	pipedVal *reflect.Value
}

// IsSet checks whether an argument is set or not. It behaves like the build-in isset function.
func (a *Arguments) IsSet(argumentIndex int) bool {
	if argumentIndex < len(a.args.Exprs) {
		if a.args.Exprs[argumentIndex].Type() == NodeUnderscore {
			return a.pipedVal != nil
		}
		return a.runtime.isSet(a.args.Exprs[argumentIndex])
	}
	if len(a.args.Exprs) == 0 && argumentIndex == 0 {
		return a.pipedVal != nil
	}
	return false
}

// Get gets an argument by index.
func (a *Arguments) Get(argumentIndex int) reflect.Value {
	if argumentIndex < len(a.args.Exprs) {
		if a.args.Exprs[argumentIndex].Type() == NodeUnderscore {
			return *a.pipedVal
		}
		return a.runtime.evalPrimaryExpressionGroup(a.args.Exprs[argumentIndex])
	}
	if len(a.args.Exprs) == 0 && argumentIndex == 0 {
		return *a.pipedVal
	}
	return reflect.Value{}
}

// Panicf panics with formatted error message.
func (a *Arguments) Panicf(format string, v ...interface{}) {
	panic(fmt.Errorf(format, v...))
}

// RequireNumOfArguments panics if the number of arguments is not in the range specified by min and max.
// In case there is no minimum pass -1, in case there is no maximum pass -1 respectively.
func (a *Arguments) RequireNumOfArguments(funcname string, min, max int) {
	num := a.NumOfArguments()
	if min >= 0 && num < min {
		a.Panicf("unexpected number of arguments in a call to %s", funcname)
	} else if max >= 0 && num > max {
		a.Panicf("unexpected number of arguments in a call to %s", funcname)
	}
}

// NumOfArguments returns the number of arguments
func (a *Arguments) NumOfArguments() int {
	num := len(a.args.Exprs)
	if a.pipedVal != nil && !a.args.HasPipeSlot {
		return num + 1
	}
	return num
}

// Runtime get the Runtime context
func (a *Arguments) Runtime() *Runtime {
	return a.runtime
}

// ParseInto parses the arguments into the provided pointers. It returns an error if the number of pointers passed in does not
// equal the number of arguments, if any argument's value is invalid according to Go's reflect package, if an argument can't
// be used as the value the pointer passed in at the corresponding position points to, or if an unhandled pointer type is encountered.
// Allowed pointer types are pointers to interface{}, int, int64, float64, bool, string,  time.Time, reflect.Value, []interface{},
// map[string]interface{}. If a pointer to a reflect.Value is passed in, the argument be assigned as-is to the value pointed to. For
// pointers to int or float types, type conversion is performed automatically if necessary.
func (a *Arguments) ParseInto(ptrs ...interface{}) error {
	if len(ptrs) < a.NumOfArguments() {
		return fmt.Errorf("have %d arguments, but only %d pointers to parse into", a.NumOfArguments(), len(ptrs))
	}

	for i := 0; i < a.NumOfArguments(); i++ {
		arg, ptr := indirectEface(a.Get(i)), ptrs[i]
		ok := false

		if !arg.IsValid() {
			return fmt.Errorf("argument at position %d is not a valid value", i)
		}

		switch p := ptr.(type) {
		case *reflect.Value:
			*p, ok = arg, true
		case *int:
			switch arg.Kind() {
			case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
				*p, ok = int(arg.Int()), true
			case reflect.Float32, reflect.Float64:
				*p, ok = int(arg.Float()), true
			default:
				return fmt.Errorf("could not parse %v (%s) into %v (%T)", arg, arg.Type(), ptr, ptr)
			}
		case *int64:
			switch arg.Kind() {
			case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
				*p, ok = arg.Int(), true
			case reflect.Float32, reflect.Float64:
				*p, ok = int64(arg.Float()), true
			default:
				return fmt.Errorf("could not parse %v (%s) into %v (%T)", arg, arg.Type(), ptr, ptr)
			}
		case *float64:
			switch arg.Kind() {
			case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
				*p, ok = float64(arg.Int()), true
			case reflect.Float32, reflect.Float64:
				*p, ok = arg.Float(), true
			default:
				return fmt.Errorf("could not parse %v (%s) into %v (%T)", arg, arg.Type(), ptr, ptr)
			}
		}

		if ok {
			continue
		}

		if !arg.CanInterface() {
			return fmt.Errorf("argument at position %d can't be accessed via Interface()", i)
		}
		val := arg.Interface()

		switch p := ptr.(type) {
		case *interface{}:
			*p, ok = val, true
		case *bool:
			*p, ok = val.(bool)
		case *string:
			*p, ok = val.(string)
		case *time.Time:
			*p, ok = val.(time.Time)
		case *[]interface{}:
			*p, ok = val.([]interface{})
		case *map[string]interface{}:
			*p, ok = val.(map[string]interface{})
		default:
			return fmt.Errorf("trying to parse %v into %v: unhandled value type %T", arg, p, val)
		}

		if !ok {
			return fmt.Errorf("could not parse %v (%s) into %v (%T)", arg, arg.Type(), ptr, ptr)
		}
	}

	return nil
}

// Func function implementing this type is called directly, which is faster than calling through reflect.
// If a function is being called many times in the execution of a template, you may consider implementing
// a wrapper for that function implementing a Func.
type Func func(Arguments) reflect.Value
