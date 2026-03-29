package xml

//#include "helper.h"
//#include <string.h>
import "C"

import (
	"errors"
	"strconv"
	"sync"
	"unsafe"

	. "github.com/jbowtie/gokogiri/util"
	"github.com/jbowtie/gokogiri/xpath"
)

var (
	ERR_UNDEFINED_COERCE_PARAM               = errors.New("unexpected parameter type in coerce")
	ERR_UNDEFINED_SET_CONTENT_PARAM          = errors.New("unexpected parameter type in SetContent")
	ERR_UNDEFINED_SEARCH_PARAM               = errors.New("unexpected parameter type in Search")
	ERR_CANNOT_MAKE_DUCMENT_AS_CHILD         = errors.New("cannot add a document node as a child")
	ERR_CANNOT_COPY_TEXT_NODE_WHEN_ADD_CHILD = errors.New("cannot copy a text node when adding it")
)

// NodeType is an enumeration that indicates the type of XmlNode.
type NodeType int

const (
	XML_ELEMENT_NODE NodeType = iota + 1
	XML_ATTRIBUTE_NODE
	XML_TEXT_NODE
	XML_CDATA_SECTION_NODE
	XML_ENTITY_REF_NODE
	XML_ENTITY_NODE
	XML_PI_NODE
	XML_COMMENT_NODE
	XML_DOCUMENT_NODE
	XML_DOCUMENT_TYPE_NODE
	XML_DOCUMENT_FRAG_NODE
	XML_NOTATION_NODE
	XML_HTML_DOCUMENT_NODE
	XML_DTD_NODE
	XML_ELEMENT_DECL
	XML_ATTRIBUTE_DECL
	XML_ENTITY_DECL
	XML_NAMESPACE_DECL
	XML_XINCLUDE_START
	XML_XINCLUDE_END
	XML_DOCB_DOCUMENT_NODE
)

// SerializationOption is a set of flags used to control how a node is written out.
type SerializationOption int

const (
	XML_SAVE_FORMAT   SerializationOption = 1 << iota // format save output
	XML_SAVE_NO_DECL                                  //drop the xml declaration
	XML_SAVE_NO_EMPTY                                 //no empty tags
	XML_SAVE_NO_XHTML                                 //disable XHTML1 specific rules
	XML_SAVE_XHTML                                    //force XHTML1 specific rules
	XML_SAVE_AS_XML                                   //force XML serialization on HTML doc
	XML_SAVE_AS_HTML                                  //force HTML serialization on XML doc
	XML_SAVE_WSNONSIG                                 //format with non-significant whitespace
)

// NamespaceDeclaration represents a namespace declaration, providing both the prefix and the URI of the namespace.
// It is returned by the DeclaredNamespaces function.
type NamespaceDeclaration struct {
	Prefix string
	Uri    string
}

type Node interface {
	NodePtr() unsafe.Pointer
	ResetNodePtr()
	MyDocument() Document

	IsValid() bool

	ParseFragment([]byte, []byte, ParseOption) (*DocumentFragment, error)
	LineNumber() int

	//
	NodeType() NodeType
	NextSibling() Node
	PreviousSibling() Node

	Parent() Node
	FirstChild() Node
	LastChild() Node
	CountChildren() int
	Attributes() map[string]*AttributeNode
	AttributeList() []*AttributeNode

	Coerce(interface{}) ([]Node, error)

	AddChild(interface{}) error
	AddPreviousSibling(interface{}) error
	AddNextSibling(interface{}) error
	InsertBefore(interface{}) error
	InsertAfter(interface{}) error
	InsertBegin(interface{}) error
	InsertEnd(interface{}) error
	SetInnerHtml(interface{}) error
	SetChildren(interface{}) error
	Replace(interface{}) error
	Wrap(string) error

	SetContent(interface{}) error

	Name() string
	SetName(string)

	Attr(string) string
	SetAttr(string, string) string
	SetNsAttr(string, string, string) string
	Attribute(string) *AttributeNode

	Path() string

	Duplicate(int) Node
	DuplicateTo(Document, int) Node

	Search(interface{}) ([]Node, error)
	SearchWithVariables(interface{}, xpath.VariableScope) ([]Node, error)
	EvalXPath(interface{}, xpath.VariableScope) (interface{}, error)
	EvalXPathAsBoolean(interface{}, xpath.VariableScope) bool

	Unlink()
	Remove()
	ResetChildren()

	SerializeWithFormat(SerializationOption, []byte, []byte) ([]byte, int)
	ToXml([]byte, []byte) ([]byte, int)
	ToUnformattedXml() string
	ToHtml([]byte, []byte) ([]byte, int)
	ToBuffer([]byte) []byte
	String() string
	Content() string
	InnerHtml() string

	RecursivelyRemoveNamespaces() error
	Namespace() string
	SetNamespace(string, string)
	DeclareNamespace(string, string)
	RemoveDefaultNamespace()
	DeclaredNamespaces() []NamespaceDeclaration
}

//run out of memory
var ErrTooLarge = errors.New("Output buffer too large")

//pre-allocate a buffer for serializing the document
const initialOutputBufferSize = 10 //100K

/*
XmlNode implements the Node interface, and as such is the heart of the API.
*/
type XmlNode struct {
	Ptr *C.xmlNode
	Document
	valid bool
}

type WriteBuffer struct {
	Node   *XmlNode
	Buffer []byte
	Offset int
}

// NewNode takes a C pointer from the libxml2 library and returns a Node instance of
// the appropriate type.
func NewNode(nodePtr unsafe.Pointer, document Document) (node Node) {
	if nodePtr == nil {
		return nil
	}
	xmlNode := &XmlNode{
		Ptr:      (*C.xmlNode)(nodePtr),
		Document: document,
		valid:    true,
	}
	nodeType := NodeType(C.getNodeType((*C.xmlNode)(nodePtr)))

	switch nodeType {
	default:
		node = xmlNode
	case XML_ATTRIBUTE_NODE:
		node = &AttributeNode{XmlNode: xmlNode}
	case XML_ELEMENT_NODE:
		node = &ElementNode{XmlNode: xmlNode}
	case XML_CDATA_SECTION_NODE:
		node = &CDataNode{XmlNode: xmlNode}
	case XML_COMMENT_NODE:
		node = &CommentNode{XmlNode: xmlNode}
	case XML_PI_NODE:
		node = &ProcessingInstructionNode{XmlNode: xmlNode}
	case XML_TEXT_NODE:
		node = &TextNode{XmlNode: xmlNode}
	}
	return
}

func (xmlNode *XmlNode) coerce(data interface{}) (nodes []Node, err error) {
	switch t := data.(type) {
	default:
		err = ERR_UNDEFINED_COERCE_PARAM
	case []Node:
		nodes = t
	case *DocumentFragment:
		nodes = t.Children()
	case string:
		f, err := xmlNode.MyDocument().ParseFragment([]byte(t), nil, DefaultParseOption)
		if err == nil {
			nodes = f.Children()
		}
	case []byte:
		f, err := xmlNode.MyDocument().ParseFragment(t, nil, DefaultParseOption)
		if err == nil {
			nodes = f.Children()
		}
	}
	return
}

func (xmlNode *XmlNode) Coerce(data interface{}) (nodes []Node, err error) {
	return xmlNode.coerce(data)
}

// Add a node as a child of the current node.
// Passing in a nodeset will add all the nodes as children of the current node.
func (xmlNode *XmlNode) AddChild(data interface{}) (err error) {
	switch t := data.(type) {
	default:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for _, node := range nodes {
				if err = xmlNode.addChild(node); err != nil {
					break
				}
			}
		}
	case *DocumentFragment:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for _, node := range nodes {
				if err = xmlNode.addChild(node); err != nil {
					break
				}
			}
		}
	case Node:
		err = xmlNode.addChild(t)
	}
	return
}

// Insert a node immediately before this node in the document.
// Passing in a nodeset will add all the nodes, in order.
func (xmlNode *XmlNode) AddPreviousSibling(data interface{}) (err error) {
	switch t := data.(type) {
	default:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for _, node := range nodes {
				if err = xmlNode.addPreviousSibling(node); err != nil {
					break
				}
			}
		}
	case *DocumentFragment:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for _, node := range nodes {
				if err = xmlNode.addPreviousSibling(node); err != nil {
					break
				}
			}
		}
	case Node:
		err = xmlNode.addPreviousSibling(t)
	}
	return
}

// Insert a node immediately after this node in the document.
// Passing in a nodeset will add all the nodes, in order.
func (xmlNode *XmlNode) AddNextSibling(data interface{}) (err error) {
	switch t := data.(type) {
	default:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for i := len(nodes) - 1; i >= 0; i-- {
				node := nodes[i]
				if err = xmlNode.addNextSibling(node); err != nil {
					break
				}
			}
		}
	case *DocumentFragment:
		if nodes, err := xmlNode.coerce(data); err == nil {
			for i := len(nodes) - 1; i >= 0; i-- {
				node := nodes[i]
				if err = xmlNode.addNextSibling(node); err != nil {
					break
				}
			}
		}
	case Node:
		err = xmlNode.addNextSibling(t)
	}
	return
}

func (xmlNode *XmlNode) ResetNodePtr() {
	xmlNode.Ptr = nil
	return
}

// Returns true if the node is valid. Nodes become
// invalid when Remove() is called.
func (xmlNode *XmlNode) IsValid() bool {
	return xmlNode.valid
}

// Return the document containing this node. Removed or unlinked
// nodes still have a document associated with them.
func (xmlNode *XmlNode) MyDocument() (document Document) {
	document = xmlNode.Document.DocRef()
	return
}

// NodePtr returns a pointer to the underlying C struct.
func (xmlNode *XmlNode) NodePtr() (p unsafe.Pointer) {
	p = unsafe.Pointer(xmlNode.Ptr)
	return
}

func (xmlNode *XmlNode) NodeType() (nodeType NodeType) {
	nodeType = NodeType(C.getNodeType(xmlNode.Ptr))
	return
}

// Path returns an XPath expression that can be used to
// select this node in the document.
func (xmlNode *XmlNode) Path() (path string) {
	pathPtr := C.xmlGetNodePath(xmlNode.Ptr)
	if pathPtr != nil {
		p := (*C.char)(unsafe.Pointer(pathPtr))
		defer C.xmlFreeChars(p)
		path = C.GoString(p)
	}
	return
}

// NextSibling returns the next sibling (if any) of the current node.
// It is often used when iterating over the children of a node.
func (xmlNode *XmlNode) NextSibling() Node {
	siblingPtr := (*C.xmlNode)(xmlNode.Ptr.next)
	return NewNode(unsafe.Pointer(siblingPtr), xmlNode.Document)
}

// PreviousSibling returns the previous sibling (if any) of the current node.
// It is often used when iterating over the children of a node in reverse.
func (xmlNode *XmlNode) PreviousSibling() Node {
	siblingPtr := (*C.xmlNode)(xmlNode.Ptr.prev)
	return NewNode(unsafe.Pointer(siblingPtr), xmlNode.Document)
}

// CountChildren returns the number of child nodes.
func (xmlNode *XmlNode) CountChildren() int {
	return int(C.xmlLsCountNode(xmlNode.Ptr))
}

func (xmlNode *XmlNode) FirstChild() Node {
	return NewNode(unsafe.Pointer(xmlNode.Ptr.children), xmlNode.Document)
}

func (xmlNode *XmlNode) LastChild() Node {
	return NewNode(unsafe.Pointer(xmlNode.Ptr.last), xmlNode.Document)
}

/*
Parent returns the parent of the current node (or nil if there isn't one).
This will always be an element or document node, as those are the only node types
that can have children.
*/
func (xmlNode *XmlNode) Parent() Node {
	if C.xmlNodePtrCheck(unsafe.Pointer(xmlNode.Ptr.parent)) == C.int(0) {
		return nil
	}
	return NewNode(unsafe.Pointer(xmlNode.Ptr.parent), xmlNode.Document)
}

func (xmlNode *XmlNode) ResetChildren() {
	var p unsafe.Pointer
	for childPtr := xmlNode.Ptr.children; childPtr != nil; {
		nextPtr := childPtr.next
		p = unsafe.Pointer(childPtr)
		C.xmlUnlinkNodeWithCheck((*C.xmlNode)(p))
		xmlNode.Document.AddUnlinkedNode(p)
		childPtr = nextPtr
	}
}

var (
	contentNode  *XmlNode
	contentMutex sync.Mutex
)

func (xmlNode *XmlNode) SetContent(content interface{}) (err error) {
	switch data := content.(type) {
	default:
		err = ERR_UNDEFINED_SET_CONTENT_PARAM
	case string:
		contentMutex.Lock()
		contentNode = xmlNode
		C.xmlSetContent(unsafe.Pointer(xmlNode.Ptr), C.CString(data))
		contentNode = nil
		contentMutex.Unlock()
	case []byte:
		err = xmlNode.SetContent(string(data))
	}
	return
}

func (xmlNode *XmlNode) InsertBefore(data interface{}) (err error) {
	err = xmlNode.AddPreviousSibling(data)
	return
}

func (xmlNode *XmlNode) InsertAfter(data interface{}) (err error) {
	err = xmlNode.AddNextSibling(data)
	return
}

func (xmlNode *XmlNode) InsertBegin(data interface{}) (err error) {
	if parent := xmlNode.Parent(); parent != nil {
		if last := parent.LastChild(); last != nil {
			err = last.AddPreviousSibling(data)
		}
	}
	return
}

func (xmlNode *XmlNode) InsertEnd(data interface{}) (err error) {
	if parent := xmlNode.Parent(); parent != nil {
		if first := parent.FirstChild(); first != nil {
			err = first.AddPreviousSibling(data)
		}
	}
	return
}

func (xmlNode *XmlNode) SetChildren(data interface{}) (err error) {
	nodes, err := xmlNode.coerce(data)
	if err != nil {
		return
	}
	xmlNode.ResetChildren()
	err = xmlNode.AddChild(nodes)
	return nil
}

func (xmlNode *XmlNode) SetInnerHtml(data interface{}) (err error) {
	err = xmlNode.SetChildren(data)
	return
}

func (xmlNode *XmlNode) Replace(data interface{}) (err error) {
	err = xmlNode.AddPreviousSibling(data)
	if err != nil {
		return
	}
	xmlNode.Remove()
	return
}

// Return a document-ordered list of attribute nodes.
func (xmlNode *XmlNode) AttributeList() (attributes []*AttributeNode) {
	for prop := xmlNode.Ptr.properties; prop != nil; prop = prop.next {
		if prop.name != nil {
			attrPtr := unsafe.Pointer(prop)
			attributeNode := NewNode(attrPtr, xmlNode.Document)
			if attr, ok := attributeNode.(*AttributeNode); ok {
				attributes = append(attributes, attr)
			}
		}
	}
	return
}

// Return the attribute nodes indexed by name.
func (xmlNode *XmlNode) Attributes() (attributes map[string]*AttributeNode) {
	attributes = make(map[string]*AttributeNode)
	for prop := xmlNode.Ptr.properties; prop != nil; prop = prop.next {
		if prop.name != nil {
			namePtr := unsafe.Pointer(prop.name)
			name := C.GoString((*C.char)(namePtr))
			attrPtr := unsafe.Pointer(prop)
			attributeNode := NewNode(attrPtr, xmlNode.Document)
			if attr, ok := attributeNode.(*AttributeNode); ok {
				attributes[name] = attr
			}
		}
	}
	return
}

// Return the attribute node, or nil if the attribute does not exist.
func (xmlNode *XmlNode) Attribute(name string) (attribute *AttributeNode) {
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}
	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])
	attrPtr := C.xmlHasNsProp(xmlNode.Ptr, (*C.xmlChar)(namePtr), nil)
	if attrPtr == nil {
		return
	} else {
		node := NewNode(unsafe.Pointer(attrPtr), xmlNode.Document)
		if node, ok := node.(*AttributeNode); ok {
			attribute = node
		}
	}
	return
}

// Attr returns the value of an attribute.
//
// If you need to check for the existence of an attribute,
// use Attribute.
func (xmlNode *XmlNode) Attr(name string) (val string) {
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}
	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])
	valPtr := C.xmlGetProp(xmlNode.Ptr, (*C.xmlChar)(namePtr))
	if valPtr == nil {
		return
	}
	p := unsafe.Pointer(valPtr)
	defer C.xmlFreeChars((*C.char)(p))
	val = C.GoString((*C.char)(p))
	return
}

// SetAttr sets the value of an attribute. If the attribute is in a namespace,
// use SetNsAttr instead.
//
// While this call accepts QNames for the name parameter, it does not check
// their validity.
//
// Attributes such as "xml:lang" or "xml:space" are not is a formal namespace
// and should be set by calling SetAttr with the prefix as part of the name.
func (xmlNode *XmlNode) SetAttr(name, value string) (val string) {
	val = value
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}
	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])

	valueBytes := GetCString([]byte(value))
	valuePtr := unsafe.Pointer(&valueBytes[0])

	C.xmlSetProp(xmlNode.Ptr, (*C.xmlChar)(namePtr), (*C.xmlChar)(valuePtr))
	return
}

// SetNsAttr sets the value of a namespaced attribute.
//
// Attributes such as "xml:lang" or "xml:space" are not is a formal namespace
// and should be set by calling SetAttr with the xml prefix as part of the name.
//
// The namespace should already be declared and in-scope when SetNsAttr is called.
// This restriction will be lifted in a future version.
func (xmlNode *XmlNode) SetNsAttr(href, name, value string) (val string) {
	val = value
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}
	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])

	valueBytes := GetCString([]byte(value))
	valuePtr := unsafe.Pointer(&valueBytes[0])

	hrefBytes := GetCString([]byte(href))
	hrefPtr := unsafe.Pointer(&hrefBytes[0])

	ns := C.xmlSearchNsByHref((*C.xmlDoc)(xmlNode.Document.DocPtr()), xmlNode.Ptr, (*C.xmlChar)(hrefPtr))
	if ns == nil {
		return
	}

	C.xmlSetNsProp(xmlNode.Ptr, ns, (*C.xmlChar)(namePtr), (*C.xmlChar)(valuePtr))
	return
}

// Search for nodes that match an XPath. This is the simplest way to look for nodes.
func (xmlNode *XmlNode) Search(data interface{}) (result []Node, err error) {
	switch data := data.(type) {
	default:
		err = ERR_UNDEFINED_SEARCH_PARAM
	case string:
		if xpathExpr := xpath.Compile(data); xpathExpr != nil {
			defer xpathExpr.Free()
			result, err = xmlNode.Search(xpathExpr)
		} else {
			err = errors.New("cannot compile xpath: " + data)
		}
	case []byte:
		result, err = xmlNode.Search(string(data))
	case *xpath.Expression:
		xpathCtx := xmlNode.Document.DocXPathCtx()
		nodePtrs, err := xpathCtx.EvaluateAsNodeset(unsafe.Pointer(xmlNode.Ptr), data)
		if nodePtrs == nil || err != nil {
			return nil, err
		}
		for _, nodePtr := range nodePtrs {
			result = append(result, NewNode(nodePtr, xmlNode.Document))
		}
	}
	return
}

// As the Search function, but passing a VariableScope that can be used to reolve variable
// names or registered function references in the XPath being evaluated.
func (xmlNode *XmlNode) SearchWithVariables(data interface{}, v xpath.VariableScope) (result []Node, err error) {
	switch data := data.(type) {
	default:
		err = ERR_UNDEFINED_SEARCH_PARAM
	case string:
		if xpathExpr := xpath.Compile(data); xpathExpr != nil {
			defer xpathExpr.Free()
			result, err = xmlNode.SearchWithVariables(xpathExpr, v)
		} else {
			err = errors.New("cannot compile xpath: " + data)
		}
	case []byte:
		result, err = xmlNode.SearchWithVariables(string(data), v)
	case *xpath.Expression:
		xpathCtx := xmlNode.Document.DocXPathCtx()
		xpathCtx.SetResolver(v)
		nodePtrs, err := xpathCtx.EvaluateAsNodeset(unsafe.Pointer(xmlNode.Ptr), data)
		if nodePtrs == nil || err != nil {
			return nil, err
		}
		for _, nodePtr := range nodePtrs {
			result = append(result, NewNode(nodePtr, xmlNode.Document))
		}
	}
	return
}

// Evaluate an XPath and return a result of the appropriate type.
// If a non-nil VariableScope is provided, any variables or functions present
// in the xpath will be resolved.
//
// If the result is a nodeset (or the empty nodeset), a nodeset will be returned.
//
// If the result is a number, a float64 will be returned.
//
// If the result is a boolean, a bool will be returned.
//
// In any other cases, the result will be coerced to a string.
func (xmlNode *XmlNode) EvalXPath(data interface{}, v xpath.VariableScope) (result interface{}, err error) {
	switch data := data.(type) {
	case string:
		if xpathExpr := xpath.Compile(data); xpathExpr != nil {
			defer xpathExpr.Free()
			result, err = xmlNode.EvalXPath(xpathExpr, v)
		} else {
			err = errors.New("cannot compile xpath: " + data)
		}
	case []byte:
		result, err = xmlNode.EvalXPath(string(data), v)
	case *xpath.Expression:
		xpathCtx := xmlNode.Document.DocXPathCtx()
		xpathCtx.SetResolver(v)
		err := xpathCtx.Evaluate(unsafe.Pointer(xmlNode.Ptr), data)
		if err != nil {
			return nil, err
		}
		rt := xpathCtx.ReturnType()
		switch rt {
		case xpath.XPATH_NODESET, xpath.XPATH_XSLT_TREE:
			nodePtrs, err := xpathCtx.ResultAsNodeset()
			if err != nil {
				return nil, err
			}
			var output []Node
			for _, nodePtr := range nodePtrs {
				output = append(output, NewNode(nodePtr, xmlNode.Document))
			}
			result = output
		case xpath.XPATH_NUMBER:
			result, _ = xpathCtx.ResultAsNumber()
		case xpath.XPATH_BOOLEAN:
			result, _ = xpathCtx.ResultAsBoolean()
		default:
			result, _ = xpathCtx.ResultAsString()
		}
	default:
		err = ERR_UNDEFINED_SEARCH_PARAM
	}
	return
}

// Evaluate an XPath and coerce the result to a boolean according to the
// XPath rules. In the presence of an error, this function will return false
// even if the expression cannot actually be evaluated.
//
// In most cases you are better advised to call EvalXPath; this function is
// intended for packages that implement XML standards and that are fully aware
// of the consequences of suppressing a compilation error.
//
// If a non-nil VariableScope is provided, any variables or registered functions present
// in the xpath will be resolved.
func (xmlNode *XmlNode) EvalXPathAsBoolean(data interface{}, v xpath.VariableScope) (result bool) {
	switch data := data.(type) {
	case string:
		if xpathExpr := xpath.Compile(data); xpathExpr != nil {
			defer xpathExpr.Free()
			result = xmlNode.EvalXPathAsBoolean(xpathExpr, v)
		} else {
			//err = errors.New("cannot compile xpath: " + data)
		}
	case []byte:
		result = xmlNode.EvalXPathAsBoolean(string(data), v)
	case *xpath.Expression:
		xpathCtx := xmlNode.Document.DocXPathCtx()
		xpathCtx.SetResolver(v)
		err := xpathCtx.Evaluate(unsafe.Pointer(xmlNode.Ptr), data)
		if err != nil {
			return false
		}
		result, _ = xpathCtx.ResultAsBoolean()
	default:
		//err = ERR_UNDEFINED_SEARCH_PARAM
	}
	return
}

// The local name of the node. Use Namespace() to get the namespace.
func (xmlNode *XmlNode) Name() (name string) {
	if xmlNode.Ptr.name != nil {
		p := unsafe.Pointer(xmlNode.Ptr.name)
		name = C.GoString((*C.char)(p))
	}
	return
}

// The namespace of the node. This is the empty string if there
// no associated namespace.
func (xmlNode *XmlNode) Namespace() (href string) {
	if xmlNode.Ptr.ns != nil {
		p := unsafe.Pointer(xmlNode.Ptr.ns.href)
		href = C.GoString((*C.char)(p))
	}
	return
}

// Set the local name of the node. The namespace is set via SetNamespace().
func (xmlNode *XmlNode) SetName(name string) {
	if len(name) > 0 {
		nameBytes := GetCString([]byte(name))
		namePtr := unsafe.Pointer(&nameBytes[0])
		C.xmlNodeSetName(xmlNode.Ptr, (*C.xmlChar)(namePtr))
	}
}

func (xmlNode *XmlNode) Duplicate(level int) Node {
	return xmlNode.DuplicateTo(xmlNode.Document, level)
}

func (xmlNode *XmlNode) DuplicateTo(doc Document, level int) (dup Node) {
	if xmlNode.valid {
		dupPtr := C.xmlDocCopyNode(xmlNode.Ptr, (*C.xmlDoc)(doc.DocPtr()), C.int(level))
		if dupPtr != nil {
			dup = NewNode(unsafe.Pointer(dupPtr), xmlNode.Document)
		}
	}
	return
}

func (xmlNode *XmlNode) serialize(format SerializationOption, encoding, outputBuffer []byte) ([]byte, int) {
	nodePtr := unsafe.Pointer(xmlNode.Ptr)
	var encodingPtr unsafe.Pointer
	if len(encoding) == 0 {
		encoding = xmlNode.Document.OutputEncoding()
	}
	if len(encoding) > 0 {
		encodingPtr = unsafe.Pointer(&(encoding[0]))
	} else {
		encodingPtr = nil
	}

	wbufferMutex.Lock()
	defer wbufferMutex.Unlock()
	if outputBuffer == nil {
		outputBuffer = make([]byte, 0)
	}
	wbuffer = &WriteBuffer{Node: xmlNode, Buffer: outputBuffer}

	ret := int(C.xmlSaveNode(nodePtr, encodingPtr, C.int(format)))
	if ret < 0 {
		panic("output error in xml node serialization: " + strconv.Itoa(ret))
	}
	b, o := wbuffer.Buffer, wbuffer.Offset
	wbuffer = nil

	return b, o
}

// SerializeWithFormat allows you to control the serialization flags passed to libxml.
// In most cases ToXml() and ToHtml() provide sensible defaults and should be preferred.
//
// The format parameter should be a set of SerializationOption constants or'd together.
// If encoding is nil, the document's output encoding is used - this defaults to UTF-8.
// If outputBuffer is nil, one will be created for you.
func (xmlNode *XmlNode) SerializeWithFormat(format SerializationOption, encoding, outputBuffer []byte) ([]byte, int) {
	return xmlNode.serialize(format, encoding, outputBuffer)
}

// ToXml generates an indented XML document with an XML declaration.
// It is not guaranteed to be well formed unless xmlNode is an element node,
// or a document node with only one element child.
//
// If you need finer control over the formatting, call SerializeWithFormat.
//
// If encoding is nil, the document's output encoding is used - this defaults to UTF-8.
// If outputBuffer is nil, one will be created for you.
func (xmlNode *XmlNode) ToXml(encoding, outputBuffer []byte) ([]byte, int) {
	return xmlNode.serialize(XML_SAVE_AS_XML|XML_SAVE_FORMAT, encoding, outputBuffer)
}

// ToUnformattedXml generates an unformatted XML document without an XML declaration.
// This is useful for conforming to various standards and for unit testing, although
// the output is not guaranteed to be well formed unless xmlNode is an element node.
func (xmlNode *XmlNode) ToUnformattedXml() string {
	var b []byte
	var size int
	b, size = xmlNode.serialize(XML_SAVE_AS_XML|XML_SAVE_NO_DECL, nil, nil)
	if b == nil {
		return ""
	}
	return string(b[:size])
}

// ToHtml generates an indented XML document that conforms to HTML 4.0 rules; meaning
// that some elements may be unclosed or forced to use end tags even when empty.
//
// If you want to output XHTML, call SerializeWithFormat and enable the XML_SAVE_XHTML
// flag as part of the format.
//
// If encoding is nil, the document's output encoding is used - this defaults to UTF-8.
// If outputBuffer is nil, one will be created for you.
func (xmlNode *XmlNode) ToHtml(encoding, outputBuffer []byte) ([]byte, int) {
	return xmlNode.serialize(XML_SAVE_AS_HTML|XML_SAVE_FORMAT, encoding, outputBuffer)
}

func (xmlNode *XmlNode) ToBuffer(outputBuffer []byte) []byte {
	var b []byte
	var size int
	if docType := xmlNode.Document.DocType(); docType == XML_HTML_DOCUMENT_NODE {
		b, size = xmlNode.ToHtml(nil, outputBuffer)
	} else {
		b, size = xmlNode.ToXml(nil, outputBuffer)
	}
	return b[:size]
}

func (xmlNode *XmlNode) String() string {
	b := xmlNode.ToBuffer(nil)
	if b == nil {
		return ""
	}
	return string(b)
}

func (xmlNode *XmlNode) Content() string {
	contentPtr := C.xmlNodeGetContent(xmlNode.Ptr)
	charPtr := (*C.char)(unsafe.Pointer(contentPtr))
	defer C.xmlFreeChars(charPtr)
	return C.GoString(charPtr)
}

func (xmlNode *XmlNode) InnerHtml() string {
	out := ""

	for child := xmlNode.FirstChild(); child != nil; child = child.NextSibling() {
		out += child.String()
	}
	return out
}

func (xmlNode *XmlNode) Unlink() {
	if int(C.xmlUnlinkNodeWithCheck(xmlNode.Ptr)) != 0 {
		xmlNode.Document.AddUnlinkedNode(unsafe.Pointer(xmlNode.Ptr))
	}
}

func (xmlNode *XmlNode) Remove() {
	if xmlNode.valid && unsafe.Pointer(xmlNode.Ptr) != xmlNode.Document.DocPtr() {
		xmlNode.Unlink()
		xmlNode.valid = false
	}
}

func (xmlNode *XmlNode) addChild(node Node) (err error) {
	nodeType := node.NodeType()
	if nodeType == XML_DOCUMENT_NODE || nodeType == XML_HTML_DOCUMENT_NODE {
		err = ERR_CANNOT_MAKE_DUCMENT_AS_CHILD
		return
	}
	nodePtr := node.NodePtr()
	if xmlNode.NodePtr() == nodePtr {
		return
	}
	ret := xmlNode.isAccestor(nodePtr)
	if ret < 0 {
		return
	} else if ret == 0 {
		if !xmlNode.Document.RemoveUnlinkedNode(nodePtr) {
			C.xmlUnlinkNodeWithCheck((*C.xmlNode)(nodePtr))
		}
		C.xmlAddChild(xmlNode.Ptr, (*C.xmlNode)(nodePtr))
	} else if ret > 0 {
		node.Remove()
	}

	return
}

func (xmlNode *XmlNode) addPreviousSibling(node Node) (err error) {
	nodeType := node.NodeType()
	if nodeType == XML_DOCUMENT_NODE || nodeType == XML_HTML_DOCUMENT_NODE {
		err = ERR_CANNOT_MAKE_DUCMENT_AS_CHILD
		return
	}
	nodePtr := node.NodePtr()
	if xmlNode.NodePtr() == nodePtr {
		return
	}
	ret := xmlNode.isAccestor(nodePtr)
	if ret < 0 {
		return
	} else if ret == 0 {
		if !xmlNode.Document.RemoveUnlinkedNode(nodePtr) {
			C.xmlUnlinkNodeWithCheck((*C.xmlNode)(nodePtr))
		}
		C.xmlAddPrevSibling(xmlNode.Ptr, (*C.xmlNode)(nodePtr))
	} else if ret > 0 {
		node.Remove()
	}
	return
}

func (xmlNode *XmlNode) addNextSibling(node Node) (err error) {
	nodeType := node.NodeType()
	if nodeType == XML_DOCUMENT_NODE || nodeType == XML_HTML_DOCUMENT_NODE {
		err = ERR_CANNOT_MAKE_DUCMENT_AS_CHILD
		return
	}
	nodePtr := node.NodePtr()
	if xmlNode.NodePtr() == nodePtr {
		return
	}
	ret := xmlNode.isAccestor(nodePtr)
	if ret < 0 {
		return
	} else if ret == 0 {
		if !xmlNode.Document.RemoveUnlinkedNode(nodePtr) {
			C.xmlUnlinkNodeWithCheck((*C.xmlNode)(nodePtr))
		}
		C.xmlAddNextSibling(xmlNode.Ptr, (*C.xmlNode)(nodePtr))
	} else if ret > 0 {
		node.Remove()
	}
	return
}

func (xmlNode *XmlNode) Wrap(data string) (err error) {
	newNodes, err := xmlNode.coerce(data)
	if err == nil && len(newNodes) > 0 {
		newParent := newNodes[0]
		xmlNode.addNextSibling(newParent)
		newParent.AddChild(xmlNode)
	}
	return
}

func (xmlNode *XmlNode) ParseFragment(input, url []byte, options ParseOption) (fragment *DocumentFragment, err error) {
	fragment, err = parsefragment(xmlNode.Document, xmlNode, input, url, options)
	return
}

var (
	wbuffer      *WriteBuffer
	wbufferMutex sync.Mutex
)

//export xmlNodeWriteCallback
// NOTE: wbufferMutex is locked
func xmlNodeWriteCallback(data unsafe.Pointer, data_len C.int) {
	offset := wbuffer.Offset

	if offset > len(wbuffer.Buffer) {
		panic("fatal error in xmlNodeWriteCallback")
	}

	buffer := wbuffer.Buffer[:offset]
	dataLen := int(data_len)

	if dataLen > 0 {
		if len(buffer)+dataLen > cap(buffer) {
			newBuffer := grow(buffer, dataLen)
			wbuffer.Buffer = newBuffer
		}
		destBufPtr := unsafe.Pointer(&(wbuffer.Buffer[offset]))
		C.memcpy(destBufPtr, data, C.size_t(dataLen))
		wbuffer.Offset += dataLen
	}
}

//export xmlUnlinkNodeCallback
// NOTE: contentMutex is locked
func xmlUnlinkNodeCallback(nodePtr unsafe.Pointer) {
	contentNode.Document.AddUnlinkedNode(nodePtr)
}

func grow(buffer []byte, n int) (newBuffer []byte) {
	newBuffer = makeSlice(2*cap(buffer) + n)
	copy(newBuffer, buffer)
	return
}

func makeSlice(n int) []byte {
	// If the make fails, give a known error.
	defer func() {
		if recover() != nil {
			panic(ErrTooLarge)
		}
	}()
	return make([]byte, n)
}

func (xmlNode *XmlNode) isAccestor(nodePtr unsafe.Pointer) int {
	parentPtr := xmlNode.Ptr.parent

	if C.xmlNodePtrCheck(unsafe.Pointer(parentPtr)) == C.int(0) {
		return -1
	}
	for ; parentPtr != nil; parentPtr = parentPtr.parent {
		if C.xmlNodePtrCheck(unsafe.Pointer(parentPtr)) == C.int(0) {
			return -1
		}
		p := unsafe.Pointer(parentPtr)
		if p == nodePtr {
			return 1
		}
	}
	return 0
}

func (xmlNode *XmlNode) RecursivelyRemoveNamespaces() (err error) {
	nodePtr := xmlNode.Ptr
	C.xmlSetNs(nodePtr, nil)

	for child := xmlNode.FirstChild(); child != nil; {
		child.RecursivelyRemoveNamespaces()
		child = child.NextSibling()
	}

	nodeType := xmlNode.NodeType()

	if ((nodeType == XML_ELEMENT_NODE) ||
		(nodeType == XML_XINCLUDE_START) ||
		(nodeType == XML_XINCLUDE_END)) &&
		(nodePtr.nsDef != nil) {
		C.xmlFreeNsList((*C.xmlNs)(nodePtr.nsDef))
		nodePtr.nsDef = nil
	}

	if nodeType == XML_ELEMENT_NODE && nodePtr.properties != nil {
		property := nodePtr.properties
		for property != nil {
			if property.ns != nil {
				property.ns = nil
			}
			property = property.next
		}
	}
	return
}

func (xmlNode *XmlNode) RemoveDefaultNamespace() {
	nodePtr := xmlNode.Ptr
	C.xmlRemoveDefaultNamespace(nodePtr)
}

// Returns a list of all the namespace declarations that exist on this node.
//
// You can add a namespace declaration by calling DeclareNamespace.
// Calling SetNamespace will automatically add a declaration if required.
//
// Calling SetNsAttr does *not* automatically create a declaration. This will
// fixed in a future version.
func (xmlNode *XmlNode) DeclaredNamespaces() (result []NamespaceDeclaration) {
	nodePtr := xmlNode.Ptr
	for ns := nodePtr.nsDef; ns != nil; ns = (*C.xmlNs)(ns.next) {
		prefixPtr := unsafe.Pointer(ns.prefix)
		prefix := C.GoString((*C.char)(prefixPtr))
		hrefPtr := unsafe.Pointer(ns.href)
		uri := C.GoString((*C.char)(hrefPtr))
		decl := NamespaceDeclaration{prefix, uri}
		result = append(result, decl)
	}
	return
}

// Add a namespace declaration to an element.
//
// This is typically done on the root element or node high up in the tree
// to avoid duplication. The declaration is not created if the namespace
// is already declared in this scope with the same prefix.
func (xmlNode *XmlNode) DeclareNamespace(prefix, href string) {
	//can only declare namespaces on elements
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}
	hrefBytes := GetCString([]byte(href))
	hrefPtr := unsafe.Pointer(&hrefBytes[0])

	//if the namespace is already declared using this prefix, just return
	_ns := C.xmlSearchNsByHref((*C.xmlDoc)(xmlNode.Document.DocPtr()), xmlNode.Ptr, (*C.xmlChar)(hrefPtr))
	if _ns != nil {
		_prefixPtr := unsafe.Pointer(_ns.prefix)
		_prefix := C.GoString((*C.char)(_prefixPtr))
		if prefix == _prefix {
			return
		}
	}

	prefixBytes := GetCString([]byte(prefix))
	prefixPtr := unsafe.Pointer(&prefixBytes[0])
	if prefix == "" {
		prefixPtr = nil
	}

	//this adds the namespace declaration to the node
	_ = C.xmlNewNs(xmlNode.Ptr, (*C.xmlChar)(hrefPtr), (*C.xmlChar)(prefixPtr))
}

// Set the namespace of an element.
func (xmlNode *XmlNode) SetNamespace(prefix, href string) {
	if xmlNode.NodeType() != XML_ELEMENT_NODE {
		return
	}

	prefixBytes := GetCString([]byte(prefix))
	prefixPtr := unsafe.Pointer(&prefixBytes[0])
	if prefix == "" {
		prefixPtr = nil
	}

	hrefBytes := GetCString([]byte(href))
	hrefPtr := unsafe.Pointer(&hrefBytes[0])

	// use the existing namespace declaration if there is one
	_ns := C.xmlSearchNsByHref((*C.xmlDoc)(xmlNode.Document.DocPtr()), xmlNode.Ptr, (*C.xmlChar)(hrefPtr))
	if _ns != nil {
		_prefixPtr := unsafe.Pointer(_ns.prefix)
		_prefix := C.GoString((*C.char)(_prefixPtr))
		if prefix == _prefix {
			C.xmlSetNs(xmlNode.Ptr, _ns)
			return
		}
	}

	ns := C.xmlNewNs(xmlNode.Ptr, (*C.xmlChar)(hrefPtr), (*C.xmlChar)(prefixPtr))
	C.xmlSetNs(xmlNode.Ptr, ns)
}

// Returns the line number on which the node appears, or a -1 if the
// line number cannot be determined.
func (xmlNode *XmlNode) LineNumber() int {
	return int(C.xmlGetLineNo(xmlNode.Ptr))
}
