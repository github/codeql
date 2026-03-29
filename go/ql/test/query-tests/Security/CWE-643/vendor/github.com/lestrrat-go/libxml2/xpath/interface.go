package xpath

import (
	"github.com/lestrrat-go/libxml2/clib"
	"github.com/lestrrat-go/libxml2/types"
)

const (
	UndefinedType   = clib.XPathUndefinedType
	NodeSetType     = clib.XPathNodeSetType
	BooleanType     = clib.XPathBooleanType
	NumberType      = clib.XPathNumberType
	StringType      = clib.XPathStringType
	PointType       = clib.XPathPointType
	RangeType       = clib.XPathRangeType
	LocationSetType = clib.XPathLocationSetType
	UsersType       = clib.XPathUsersType
	XSLTTreeType    = clib.XPathXSLTTreeType
)

// Object is the concrete implementation of Result (types.XPathResult).
// This struct contains the result of evaluating an XPath expression.
type Object struct {
	ptr uintptr // *C.xmlObject
	// This flag controls if the StringValue should use the *contents* (literal value)
	// of the nodeset instead of stringifying the node
	ForceLiteral bool
}

// Context holds the current XPath context. You may register namespaces and
// context nodes to evaluate your XPath expressions with it.
type Context struct {
	ptr uintptr // *C.xmlContext
}

// Expression is a compiled XPath expression
type Expression struct {
	ptr uintptr // *C.xmlCompExpr
	// This exists mainly for debugging purposes
	expr string
}

// Result is an alias to types.XPathResult
type Result types.XPathResult
