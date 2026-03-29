package xpath

/*
#cgo pkg-config: libxml-2.0

#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <libxml/parser.h>

xmlNode* fetchNode(xmlNodeSet *nodeset, int index) {
    return nodeset->nodeTab[index];
}

xmlXPathObjectPtr go_resolve_variables(void* ctxt, char* name, char* ns);
int go_can_resolve_function(void* ctxt, char* name, char* ns);
void exec_xpath_function(xmlXPathParserContextPtr ctxt, int nargs);

xmlXPathFunction go_resolve_function(void* ctxt, char* name, char* ns) {
    if (go_can_resolve_function(ctxt, name, ns))
        return exec_xpath_function;

    return 0;
}

static void set_var_lookup(xmlXPathContext* c, void* data) {
    c->varLookupFunc = (void *)go_resolve_variables;
    c->varLookupData = data;
}

static void set_function_lookup(xmlXPathContext* c, void* data) {
    c->funcLookupFunc = (void *)go_resolve_function;
    c->funcLookupData = data;
}

int getXPathObjectType(xmlXPathObject* o) {
    if(o == 0)
        return 0;
    return o->type;
}
*/
import "C"

import "unsafe"
import . "github.com/jbowtie/gokogiri/util"
import "runtime"
import "errors"

type XPath struct {
	ContextPtr *C.xmlXPathContext
	ResultPtr  *C.xmlXPathObject
}

type XPathObjectType int

const (
	XPATH_UNDEFINED   XPathObjectType = 0
	XPATH_NODESET                     = 1
	XPATH_BOOLEAN                     = 2
	XPATH_NUMBER                      = 3
	XPATH_STRING                      = 4
	XPATH_POINT                       = 5
	XPATH_RANGE                       = 6
	XPATH_LOCATIONSET                 = 7
	XPATH_USERS                       = 8
	XPATH_XSLT_TREE                   = 9 // An XSLT value tree, non modifiable
)

type XPathFunction func(context VariableScope, args []interface{}) interface{}

// Types that provide the VariableScope interface know how to resolve
// XPath variable names into values.
//
//This interface exist primarily for the benefit of XSLT processors.
type VariableScope interface {
	ResolveVariable(string, string) interface{}
	IsFunctionRegistered(string, string) bool
	ResolveFunction(string, string) XPathFunction
}

func NewXPath(docPtr unsafe.Pointer) (xpath *XPath) {
	if docPtr == nil {
		return
	}
	xpath = &XPath{ContextPtr: C.xmlXPathNewContext((*C.xmlDoc)(docPtr)), ResultPtr: nil}
	runtime.SetFinalizer(xpath, (*XPath).Free)
	return
}

func (xpath *XPath) RegisterNamespace(prefix, href string) bool {
	var prefixPtr unsafe.Pointer = nil
	if len(prefix) > 0 {
		prefixBytes := AppendCStringTerminator([]byte(prefix))
		prefixPtr = unsafe.Pointer(&prefixBytes[0])
	}

	var hrefPtr unsafe.Pointer = nil
	if len(href) > 0 {
		hrefBytes := AppendCStringTerminator([]byte(href))
		hrefPtr = unsafe.Pointer(&hrefBytes[0])
	}

	result := C.xmlXPathRegisterNs(xpath.ContextPtr, (*C.xmlChar)(prefixPtr), (*C.xmlChar)(hrefPtr))
	return result == 0
}

// Evaluate an XPath and attempt to consume the result as a nodeset.
func (xpath *XPath) EvaluateAsNodeset(nodePtr unsafe.Pointer, xpathExpr *Expression) (nodes []unsafe.Pointer, err error) {
	if nodePtr == nil {
		//evaluating xpath on a  nil node returns no result.
		return
	}

	err = xpath.Evaluate(nodePtr, xpathExpr)
	if err != nil {
		return
	}

	nodes, err = xpath.ResultAsNodeset()
	return
}

// Evaluate an XPath. The returned result is stored in the struct. Call ReturnType to
// discover the type of result, and call one of the ResultAs* functions to return a
// copy of the result as a particular type.
func (xpath *XPath) Evaluate(nodePtr unsafe.Pointer, xpathExpr *Expression) (err error) {
	if nodePtr == nil {
		//evaluating xpath on a nil node returns no result.
		return
	}

	oldXPContextDoc := xpath.ContextPtr.doc
	oldXPContextNode := xpath.ContextPtr.node
	oldXPProximityPosition := xpath.ContextPtr.proximityPosition
	oldXPContextSize := xpath.ContextPtr.contextSize
	oldXPNsNr := xpath.ContextPtr.nsNr
	oldXPNamespaces := xpath.ContextPtr.namespaces

	xpath.ContextPtr.node = (*C.xmlNode)(nodePtr)
	if xpath.ResultPtr != nil {
		C.xmlXPathFreeObject(xpath.ResultPtr)
	}
	xpath.ResultPtr = C.xmlXPathCompiledEval(xpathExpr.Ptr, xpath.ContextPtr)

	xpath.ContextPtr.doc = oldXPContextDoc
	xpath.ContextPtr.node = oldXPContextNode
	xpath.ContextPtr.proximityPosition = oldXPProximityPosition
	xpath.ContextPtr.contextSize = oldXPContextSize
	xpath.ContextPtr.nsNr = oldXPNsNr
	xpath.ContextPtr.namespaces = oldXPNamespaces

	if xpath.ResultPtr == nil {
		err = errors.New("err in evaluating xpath: " + xpathExpr.String())
		return
	}
	return
}

// Determine the actual return type of the XPath evaluation.
func (xpath *XPath) ReturnType() XPathObjectType {
	return XPathObjectType(C.getXPathObjectType(xpath.ResultPtr))
}

// Get the XPath result as a nodeset.
func (xpath *XPath) ResultAsNodeset() (nodes []unsafe.Pointer, err error) {
	if xpath.ResultPtr == nil {
		return
	}

	if xpath.ReturnType() != XPATH_NODESET {
		err = errors.New("Cannot convert XPath result to nodeset")
	}

	if nodesetPtr := xpath.ResultPtr.nodesetval; nodesetPtr != nil {
		if nodesetSize := int(nodesetPtr.nodeNr); nodesetSize > 0 {
			nodes = make([]unsafe.Pointer, nodesetSize)
			for i := 0; i < nodesetSize; i++ {
				nodes[i] = unsafe.Pointer(C.fetchNode(nodesetPtr, C.int(i)))
			}
		}
	}
	return
}

// Coerce the result into a string
func (xpath *XPath) ResultAsString() (val string, err error) {
	if xpath.ReturnType() != XPATH_STRING {
		xpath.ResultPtr = C.xmlXPathConvertString(xpath.ResultPtr)
	}
	val = C.GoString((*C.char)(unsafe.Pointer(xpath.ResultPtr.stringval)))
	return
}

// Coerce the result into a number
func (xpath *XPath) ResultAsNumber() (val float64, err error) {
	if xpath.ReturnType() != XPATH_NUMBER {
		xpath.ResultPtr = C.xmlXPathConvertNumber(xpath.ResultPtr)
	}
	val = float64(xpath.ResultPtr.floatval)
	return
}

// Coerce the result into a boolean
func (xpath *XPath) ResultAsBoolean() (val bool, err error) {
	xpath.ResultPtr = C.xmlXPathConvertBoolean(xpath.ResultPtr)
	val = xpath.ResultPtr.boolval != 0
	return
}

// Add a variable resolver.
func (xpath *XPath) SetResolver(v VariableScope) {
	SetScope(unsafe.Pointer(xpath.ContextPtr), v)
	C.set_var_lookup(xpath.ContextPtr, unsafe.Pointer(xpath.ContextPtr))
	C.set_function_lookup(xpath.ContextPtr, unsafe.Pointer(xpath.ContextPtr))
}

// SetContextPosition sets the internal values needed to
// determine the values of position() and last() for the
// current context node.
func (xpath *XPath) SetContextPosition(position, size int) {
	xpath.ContextPtr.proximityPosition = C.int(position)
	xpath.ContextPtr.contextSize = C.int(size)
}

// GetContextPosition retrieves the internal values used to
// determine the values of position() and last() for the
// current context node.
//
// This allows values to saved and restored during processing
// of a document.
func (xpath *XPath) GetContextPosition() (position, size int) {
	position = int(xpath.ContextPtr.proximityPosition)
	size = int(xpath.ContextPtr.contextSize)
	return
}

func (xpath *XPath) Free() {
	if xpath.ContextPtr != nil {
		ClearScope(unsafe.Pointer(xpath.ContextPtr))
		C.xmlXPathFreeContext(xpath.ContextPtr)
		xpath.ContextPtr = nil
	}
	if xpath.ResultPtr != nil {
		C.xmlXPathFreeObject(xpath.ResultPtr)
		xpath.ResultPtr = nil
	}
}

func XPathObjectToValue(obj C.xmlXPathObjectPtr) (result interface{}) {
	rt := XPathObjectType(C.getXPathObjectType(obj))
	switch rt {
	case XPATH_NODESET, XPATH_XSLT_TREE:
		if nodesetPtr := obj.nodesetval; nodesetPtr != nil {
			if nodesetSize := int(nodesetPtr.nodeNr); nodesetSize > 0 {
				nodes := make([]unsafe.Pointer, nodesetSize)
				for i := 0; i < nodesetSize; i++ {
					nodes[i] = unsafe.Pointer(C.fetchNode(nodesetPtr, C.int(i)))
				}
				result = nodes
				return
			}
		}
		result = nil
	case XPATH_NUMBER:
		obj = C.xmlXPathConvertNumber(obj)
		result = float64(obj.floatval)
	case XPATH_BOOLEAN:
		obj = C.xmlXPathConvertBoolean(obj)
		result = obj.boolval != 0
	default:
		obj = C.xmlXPathConvertString(obj)
		result = C.GoString((*C.char)(unsafe.Pointer(obj.stringval)))
	}
	return
}
