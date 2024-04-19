// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.
//

// Package gcmd provides console operations, like options/arguments reading and command running.
package gcmd

import (
	"github.com/gogf/gf/container/gvar"
	"github.com/gogf/gf/internal/command"
	"os"
	"strings"
)

var (
	defaultCommandFuncMap = make(map[string]func())
)

// Custom initialization.
func Init(args ...string) {
	command.Init(args...)
}

// GetOpt returns the option value named <name>.
func GetOpt(name string, def ...string) string {
	Init()
	return command.GetOpt(name, def...)
}

// GetOptVar returns the option value named <name> as gvar.Var.
func GetOptVar(name string, def ...string) *gvar.Var {
	Init()
	return gvar.New(GetOpt(name, def...))
}

// GetOptAll returns all parsed options.
func GetOptAll() map[string]string {
	Init()
	return command.GetOptAll()
}

// ContainsOpt checks whether option named <name> exist in the arguments.
func ContainsOpt(name string) bool {
	Init()
	return command.ContainsOpt(name)
}

// GetArg returns the argument at <index>.
func GetArg(index int, def ...string) string {
	Init()
	return command.GetArg(index, def...)
}

// GetArgVar returns the argument at <index> as gvar.Var.
func GetArgVar(index int, def ...string) *gvar.Var {
	Init()
	return gvar.New(GetArg(index, def...))
}

// GetArgAll returns all parsed arguments.
func GetArgAll() []string {
	Init()
	return command.GetArgAll()
}

// GetWithEnv is alias of GetOptWithEnv.
// Deprecated, use GetOptWithEnv instead.
func GetWithEnv(key string, def ...interface{}) *gvar.Var {
	return GetOptWithEnv(key, def...)
}

// GetOptWithEnv returns the command line argument of the specified <key>.
// If the argument does not exist, then it returns the environment variable with specified <key>.
// It returns the default value <def> if none of them exists.
//
// Fetching Rules:
// 1. Command line arguments are in lowercase format, eg: gf.<package name>.<variable name>;
// 2. Environment arguments are in uppercase format, eg: GF_<package name>_<variable name>；
func GetOptWithEnv(key string, def ...interface{}) *gvar.Var {
	cmdKey := strings.ToLower(strings.Replace(key, "_", ".", -1))
	if ContainsOpt(cmdKey) {
		return gvar.New(GetOpt(cmdKey))
	} else {
		envKey := strings.ToUpper(strings.Replace(key, ".", "_", -1))
		if r, ok := os.LookupEnv(envKey); ok {
			return gvar.New(r)
		} else {
			if len(def) > 0 {
				return gvar.New(def[0])
			}
		}
	}
	return gvar.New(nil)
}

// BuildOptions builds the options as string.
func BuildOptions(m map[string]string, prefix ...string) string {
	options := ""
	leadStr := "-"
	if len(prefix) > 0 {
		leadStr = prefix[0]
	}
	for k, v := range m {
		if len(options) > 0 {
			options += " "
		}
		options += leadStr + k
		if v != "" {
			options += "=" + v
		}
	}
	return options
}
