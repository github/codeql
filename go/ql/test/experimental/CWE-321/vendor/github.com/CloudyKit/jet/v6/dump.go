package jet

import (
	"bytes"
	"fmt"
	"io"
	"reflect"
)

// dumpAll returns
//  - everything in Runtime.context
//  - everything in Runtime.variables
//  - everything in Runtime.set.globals
//  - everything in Runtime.blocks
func dumpAll(a Arguments, depth int) reflect.Value {
	var b bytes.Buffer
	var vars VarMap

	ctx := a.runtime.context
	fmt.Fprintln(&b, "Context:")
	fmt.Fprintf(&b, "\t%s %#v\n", ctx.Type(), ctx)

	dumpScopeVars(&b, a.runtime.scope, 0)
	dumpScopeVarsToDepth(&b, a.runtime.parent, depth)

	vars = a.runtime.set.globals
	for i, name := range vars.SortedKeys() {
		if i == 0 {
			fmt.Fprintln(&b, "Globals:")
		}
		val := vars[name]
		fmt.Fprintf(&b, "\t%s:=%#v // %s\n", name, val, val.Type())
	}

	blockKeys := a.runtime.scope.sortedBlocks()
	fmt.Fprintln(&b, "Blocks:")
	for _, k := range blockKeys {
		block := a.runtime.blocks[k]
		dumpBlock(&b, block)
	}

	return reflect.ValueOf(b.String())
}

// dumpScopeVarsToDepth prints all variables in the scope, and all parent scopes,
// to the limit of maxDepth.
func dumpScopeVarsToDepth(w io.Writer, scope *scope, maxDepth int) {
	for i := 1; i <= maxDepth; i++ {
		if scope == nil {
			break // do not panic if something bad happens
		}
		dumpScopeVars(w, scope, i)
		scope = scope.parent
	}
}

// dumpScopeVars prints all variables in the scope.
func dumpScopeVars(w io.Writer, scope *scope, lvl int) {
	if scope == nil {
		return // do not panic if something bad happens
	}
	if lvl == 0 {
		fmt.Fprint(w, "Variables in current scope:\n")
	} else {
		fmt.Fprintf(w, "Variables in scope %d level(s) up:\n", lvl)
	}
	vars := scope.variables
	for _, k := range vars.SortedKeys() {
		fmt.Fprintf(w, "\t%s=%#v\n", k, vars[k])
	}
}

// dumpIdentified accepts a runtime and slice of names.
// Then, it prints all variables and blocks in the runtime, with names equal to one of the names
// in the slice.
func dumpIdentified(rnt *Runtime, ids []string) reflect.Value {
	var b bytes.Buffer
	for _, id := range ids {
		dumpFindVar(&b, rnt, id)
		dumpFindBlock(&b, rnt, id)

	}
	return reflect.ValueOf(b.String())
}

// dumpFindBlock finds the block by name, prints the header of the block, and name of the template in which it was defined.
func dumpFindBlock(w io.Writer, rnt *Runtime, name string) {
	if block, ok := rnt.scope.blocks[name]; ok {
		dumpBlock(w, block)
	}
}

// dumpBlock prints header of the block, and template in which the block was first defined.
func dumpBlock(w io.Writer, block *BlockNode) {
	if block == nil {
		return
	}
	fmt.Fprintf(w, "\tblock %s(%s), from %s\n", block.Name, block.Parameters.String(), block.TemplatePath)
}

// dumpFindBlock finds the variable by name, and prints the variable, if it is in the runtime.
func dumpFindVar(w io.Writer, rnt *Runtime, name string) {
	val, err := rnt.resolve(name)
	if err != nil {
		return
	}
	fmt.Fprintf(w, "\t%s:=%#v // %s\n", name, val, val.Type())
}
