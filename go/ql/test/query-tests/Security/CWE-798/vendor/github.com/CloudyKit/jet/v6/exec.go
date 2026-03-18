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

// Jet is a fast and dynamic template engine for the Go programming language, set of features
// includes very fast template execution, a dynamic and flexible language, template inheritance, low number of allocations,
// special interfaces to allow even further optimizations.

package jet

import (
	"io"
	"reflect"
	"sort"
)

type VarMap map[string]reflect.Value

// SortedKeys returns a sorted slice of VarMap keys
func (scope VarMap) SortedKeys() []string {
	keys := make([]string, 0, len(scope))
	for k := range scope {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

func (scope VarMap) Set(name string, v interface{}) VarMap {
	scope[name] = reflect.ValueOf(v)
	return scope
}

func (scope VarMap) SetFunc(name string, v Func) VarMap {
	scope[name] = reflect.ValueOf(v)
	return scope
}

func (scope VarMap) SetWriter(name string, v SafeWriter) VarMap {
	scope[name] = reflect.ValueOf(v)
	return scope
}

// Execute executes the template into w.
func (t *Template) Execute(w io.Writer, variables VarMap, data interface{}) (err error) {
	st := pool_State.Get().(*Runtime)
	defer st.recover(&err)

	st.blocks = t.processedBlocks
	st.variables = variables
	st.set = t.set
	st.Writer = w

	// resolve extended template
	for t.extends != nil {
		t = t.extends
	}

	if data != nil {
		st.context = reflect.ValueOf(data)
	}

	st.executeList(t.Root)
	return
}
