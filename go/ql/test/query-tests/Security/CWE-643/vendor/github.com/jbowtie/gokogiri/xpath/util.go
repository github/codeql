package xpath

/*
#cgo pkg-config: libxml-2.0

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <libxml/parser.h>

int getXPathObjectType(xmlXPathObject* o);

*/
import "C"

import (
	"sync"
	"unsafe"
)
import "reflect"
import . "github.com/jbowtie/gokogiri/util"

var (
	contextMap   = make(map[unsafe.Pointer]VariableScope)
	contextMutex sync.Mutex
)

func GetScope(ctxt unsafe.Pointer) VariableScope {
	contextMutex.Lock()
	context := contextMap[ctxt]
	contextMutex.Unlock()
	return context
}

func SetScope(ctxt unsafe.Pointer, v VariableScope) {
	contextMutex.Lock()
	contextMap[ctxt] = v
	contextMutex.Unlock()
}

func ClearScope(ctxt unsafe.Pointer) {
	contextMutex.Lock()
	delete(contextMap, ctxt)
	contextMutex.Unlock()

}

//export go_resolve_variables
func go_resolve_variables(ctxt unsafe.Pointer, name, ns *C.char) (ret C.xmlXPathObjectPtr) {
	if context := GetScope(ctxt); context != nil {
		variable := C.GoString(name)
		namespace := C.GoString(ns)

		val := context.ResolveVariable(variable, namespace)
		return ValueToXPathObject(val)
	}
	return nil
}

// Convert an arbitrary value into a C.xmlXPathObjectPtr
// Unrecognised and nil values are converted to empty node sets.
func ValueToXPathObject(val interface{}) (ret C.xmlXPathObjectPtr) {
	if val == nil {
		//return the empty node set
		ret = C.xmlXPathNewNodeSet(nil)
		return
	}
	switch v := val.(type) {
	case unsafe.Pointer:
		return (C.xmlXPathObjectPtr)(v)
	case []unsafe.Pointer:
		ptrs := v
		if len(ptrs) > 0 {
			//default - return a node set
			ret = C.xmlXPathNewNodeSet(nil)
			for _, p := range ptrs {
				C.xmlXPathNodeSetAdd(ret.nodesetval, (*C.xmlNode)(p))
			}
		} else {
			ret = C.xmlXPathNewNodeSet(nil)
			return
		}
	case float64:
		ret = C.xmlXPathNewFloat(C.double(v))
	case string:
		xpathBytes := GetCString([]byte(v))
		xpathPtr := unsafe.Pointer(&xpathBytes[0])
		ret = C.xmlXPathNewString((*C.xmlChar)(xpathPtr))
	default:
		typ := reflect.TypeOf(val)
		// if a pointer to a struct is passed, get the type of the dereferenced object
		if typ.Kind() == reflect.Ptr {
			typ = typ.Elem()
		}
		//log the unknown type, return an empty node set
		//fmt.Println("go-resolve wrong-type", typ.Kind())
		ret = C.xmlXPathNewNodeSet(nil)
	}
	return
}

//export exec_xpath_function
func exec_xpath_function(ctxt C.xmlXPathParserContextPtr, nargs C.int) {
	function := C.GoString((*C.char)(unsafe.Pointer(ctxt.context.function)))
	namespace := C.GoString((*C.char)(unsafe.Pointer(ctxt.context.functionURI)))

	context := GetScope(unsafe.Pointer(ctxt.context))

	argcount := int(nargs)
	var args []interface{}

	for i := 0; i < argcount; i = i + 1 {
		args = append(args, XPathObjectToValue(C.valuePop(ctxt)))
	}

	// arguments are popped off the stack in reverse order, so
	// we reverse the slice before invoking our callback
	if argcount > 1 {
		for i, j := 0, len(args)-1; i < j; i, j = i+1, j-1 {
			args[i], args[j] = args[j], args[i]
		}
	}

	// push the result onto the stack
	// if for some reason we are unable to resolve the
	// function we push an empty nodeset
	f := context.ResolveFunction(function, namespace)
	if f != nil {
		retval := f(context, args)
		C.valuePush(ctxt, ValueToXPathObject(retval))
	} else {
		ret := C.xmlXPathNewNodeSet(nil)
		C.valuePush(ctxt, ret)
	}

}

//export go_can_resolve_function
func go_can_resolve_function(ctxt unsafe.Pointer, name, ns *C.char) (ret C.int) {
	function := C.GoString(name)
	namespace := C.GoString(ns)
	context := GetScope(ctxt)
	if context != nil && context.IsFunctionRegistered(function, namespace) {
		return C.int(1)
	}
	return C.int(0)
}
