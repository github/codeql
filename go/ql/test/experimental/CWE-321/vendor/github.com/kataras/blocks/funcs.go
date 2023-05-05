package blocks

import "html/template"

var builtins = template.FuncMap{
	"partial": func(v *Blocks) interface{} {
		return v.PartialFunc
	},
}

// Register register a function map
// that will be available across all Blocks view engines.
// The values (functions) should be compatible
// with a standard html/template function, however
// as a special feature, the function input's can be a type of
// func(*Blocks) (fn interface{}) or func(*Blocks) template.FuncMap as well,
// so it can use the current engine's methods such as `ParseTemplate`.
// It's legal to override previous functions.
//
// It is used like the `database/sql.Register` function.
//
// Usage:
//
//		package myFuncsCollection1
//		func init() {
//		  blocks.Register(a_funcMap)
//		}
//
//		package myFuncsCollection2
//		func init() {
//		  blocks.Register(anothrer_funcMap)
//		}
//
//		package main
//		import _ "myFuncsCollection1"
//		import _ "myFuncsCollection2"
//
//		func main() {
//		  views := blocks.New("./views")
//		}
//	 Views contains the functions of both collections.
func Register(funcMap template.FuncMap) {
	for name, fn := range funcMap {
		builtins[name] = fn
	}
}

func translateFuncs(v *Blocks, funcMap template.FuncMap) template.FuncMap { // used on `New`.
	funcs := make(template.FuncMap)
	for name, fn := range funcMap {
		if fn == nil {
			continue
		}

		switch f := fn.(type) {
		case func(*Blocks) interface{}:
			funcs[name] = f(v)
		case func(*Blocks) template.FuncMap:
			for deepName, deepFn := range translateFuncs(v, f(v)) {
				funcs[deepName] = deepFn
			}
		default:
			funcs[name] = fn
		}

	}
	return funcs
}
