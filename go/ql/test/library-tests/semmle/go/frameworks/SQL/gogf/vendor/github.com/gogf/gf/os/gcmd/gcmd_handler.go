// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.
//

package gcmd

import (
	"github.com/gogf/gf/errors/gcode"
	"github.com/gogf/gf/errors/gerror"
)

// BindHandle registers callback function <f> with <cmd>.
func BindHandle(cmd string, f func()) error {
	if _, ok := defaultCommandFuncMap[cmd]; ok {
		return gerror.NewCode(gcode.CodeInvalidOperation, "duplicated handle for command:"+cmd)
	} else {
		defaultCommandFuncMap[cmd] = f
	}
	return nil
}

// BindHandleMap registers callback function with map <m>.
func BindHandleMap(m map[string]func()) error {
	var err error
	for k, v := range m {
		if err = BindHandle(k, v); err != nil {
			return err
		}
	}
	return err
}

// RunHandle executes the callback function registered by <cmd>.
func RunHandle(cmd string) error {
	if handle, ok := defaultCommandFuncMap[cmd]; ok {
		handle()
	} else {
		return gerror.NewCode(gcode.CodeMissingConfiguration, "no handle found for command:"+cmd)
	}
	return nil
}

// AutoRun automatically recognizes and executes the callback function
// by value of index 0 (the first console parameter).
func AutoRun() error {
	if cmd := GetArg(1); cmd != "" {
		if handle, ok := defaultCommandFuncMap[cmd]; ok {
			handle()
		} else {
			return gerror.NewCode(gcode.CodeMissingConfiguration, "no handle found for command:"+cmd)
		}
	} else {
		return gerror.NewCode(gcode.CodeMissingParameter, "no command found")
	}
	return nil
}
