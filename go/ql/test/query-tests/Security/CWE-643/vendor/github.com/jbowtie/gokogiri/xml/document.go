package xml

/*
#cgo pkg-config: libxml-2.0

#include "helper.h"
*/
import "C"

import (
	"errors"
	"github.com/jbowtie/gokogiri/help"
	. "github.com/jbowtie/gokogiri/util"
	"github.com/jbowtie/gokogiri/xpath"
	"os"
	"unsafe"
)

type Document interface {
	/* Nokogiri APIs */
	CreateElementNode(string) *ElementNode
	CreateCDataNode(string) *CDataNode
	CreateTextNode(string) *TextNode
	CreateCommentNode(string) *CommentNode
	CreatePINode(string, string) *ProcessingInstructionNode
	ParseFragment([]byte, []byte, ParseOption) (*DocumentFragment, error)

	DocPtr() unsafe.Pointer
	DocType() NodeType
	DocRef() Document
	InputEncoding() []byte
	OutputEncoding() []byte
	DocXPathCtx() *xpath.XPath
	AddUnlinkedNode(unsafe.Pointer)
	RemoveUnlinkedNode(unsafe.Pointer) bool
	Free()
	String() string
	Root() *ElementNode
	NodeById(string) *ElementNode
	BookkeepFragment(*DocumentFragment)

	RecursivelyRemoveNamespaces() error
	UnparsedEntityURI(string) string
	Uri() string
}

// ParseOption values allow you to tune the behaviour of the parsing engine.
type ParseOption int

const (
	XML_PARSE_RECOVER    ParseOption = 1 << iota // recover on errors
	XML_PARSE_NOENT                              // substitute entities
	XML_PARSE_DTDLOAD                            // load the external subset
	XML_PARSE_DTDATTR                            // default DTD attributes
	XML_PARSE_DTDVALID                           // validate with the DTD
	XML_PARSE_NOERROR                            // suppress error reports
	XML_PARSE_NOWARNING                          // suppress warning reports
	XML_PARSE_PEDANTIC                           // pedantic error reporting
	XML_PARSE_NOBLANKS                           // remove blank nodes
	XML_PARSE_SAX1                               // use the SAX1 interface internally
	XML_PARSE_XINCLUDE                           // Implement XInclude substitition
	XML_PARSE_NONET                              // Forbid network access
	XML_PARSE_NODICT                             // Do not reuse the context dictionnary
	XML_PARSE_NSCLEAN                            // remove redundant namespaces declarations
	XML_PARSE_NOCDATA                            // merge CDATA as text nodes
	XML_PARSE_NOXINCNODE                         // do not generate XINCLUDE START/END nodes
	XML_PARSE_COMPACT                            // compact small text nodes; makes tree read-only
	XML_PARSE_OLD10                              // parse using XML-1.0 before update 5
	XML_PARSE_NOBASEFIX                          // do not fixup XINCLUDE xml//base uris
	XML_PARSE_HUGE                               // relax any hardcoded limit from the parser
	XML_PARSE_OLDSAX                             // parse using SAX2 interface before 2.7.0
	XML_PARSE_IGNORE_ENC                         // ignore internal document encoding hint
	XML_PARSE_BIG_LINES                          // Store big lines numbers in text PSVI field
)

//DefaultParseOption provides liberal parsing highly tolerant of invalid documents. Errors and warnings
// are suppressed and the DTD is not processed.
const DefaultParseOption ParseOption = XML_PARSE_RECOVER |
	XML_PARSE_NONET |
	XML_PARSE_NOERROR |
	XML_PARSE_NOWARNING

//StrictParseOption provides standard-compliant parsing. The DTD is processed, entity
// substitions are made, and errors and warnings are reported back.
const StrictParseOption ParseOption = XML_PARSE_NOENT |
	XML_PARSE_DTDLOAD |
	XML_PARSE_DTDATTR |
	XML_PARSE_NOCDATA

//DefaultEncoding is UTF-8, which is also the default for both libxml2 and Go strings.
const DefaultEncoding = "utf-8"

var ERR_FAILED_TO_PARSE_XML = errors.New("failed to parse xml input")

/*
XmlDocument is the primary interface for working with XML documents.
*/
type XmlDocument struct {
	Ptr *C.xmlDoc
	Me  Document
	Node
	InEncoding    []byte
	OutEncoding   []byte
	UnlinkedNodes map[*C.xmlNode]bool
	XPathCtx      *xpath.XPath
	Type          NodeType
	InputLen      int

	fragments []*DocumentFragment //save the pointers to free them when the doc is freed
}

//DefaultEncodingBytes allows us to conveniently pass the DefaultEncoding to various functions that
// expect the encoding as a byte array.
var DefaultEncodingBytes = []byte(DefaultEncoding)

const initialFragments = 2

//NewDocument wraps the pointer to the C struct.
//
// TODO: this should probably not be exported.
func NewDocument(p unsafe.Pointer, contentLen int, inEncoding, outEncoding []byte) (doc *XmlDocument) {
	inEncoding = AppendCStringTerminator(inEncoding)
	outEncoding = AppendCStringTerminator(outEncoding)

	xmlNode := &XmlNode{Ptr: (*C.xmlNode)(p)}
	docPtr := (*C.xmlDoc)(p)
	doc = &XmlDocument{Ptr: docPtr, Node: xmlNode, InEncoding: inEncoding, OutEncoding: outEncoding, InputLen: contentLen}
	doc.UnlinkedNodes = make(map[*C.xmlNode]bool)
	doc.XPathCtx = xpath.NewXPath(p)
	doc.Type = xmlNode.NodeType()
	doc.fragments = make([]*DocumentFragment, 0, initialFragments)
	doc.Me = doc
	xmlNode.Document = doc
	//runtime.SetFinalizer(doc, (*XmlDocument).Free)
	return
}

// Parse creates an XmlDocument from some pre-existing content where the input encoding is known. Byte arrays created from
// a Go string are utf-8 encoded (you can pass DefaultEncodingBytes in this scenario).
//
// If you want to build up a document programmatically, calling CreateEmptyDocument and building it up using the xml.Node
// interface is a better approach than building a string and calling Parse.
//
// If you have an XML file, then ReadFile will automatically determine the encoding according to the XML specification.
func Parse(content, inEncoding, url []byte, options ParseOption, outEncoding []byte) (doc *XmlDocument, err error) {
	inEncoding = AppendCStringTerminator(inEncoding)
	outEncoding = AppendCStringTerminator(outEncoding)

	var docPtr *C.xmlDoc
	contentLen := len(content)

	if contentLen > 0 {
		var contentPtr, urlPtr, encodingPtr unsafe.Pointer
		contentPtr = unsafe.Pointer(&content[0])

		if len(url) > 0 {
			url = AppendCStringTerminator(url)
			urlPtr = unsafe.Pointer(&url[0])
		}
		if len(inEncoding) > 0 {
			encodingPtr = unsafe.Pointer(&inEncoding[0])
		}

		docPtr = C.xmlParse(contentPtr, C.int(contentLen), urlPtr, encodingPtr, C.int(options), nil, 0)

		if docPtr == nil {
			err = ERR_FAILED_TO_PARSE_XML
		} else {
			doc = NewDocument(unsafe.Pointer(docPtr), contentLen, inEncoding, outEncoding)
		}

	} else {
		doc = CreateEmptyDocument(inEncoding, outEncoding)
	}
	return
}

// ReadFile loads an XmlDocument from a filename. The encoding declared in the document will be
// used as the input encoding. If no encoding is declared, the library will use the alogrithm
// in the XML standard to determine if the document is encoded with UTF-8 or UTF-16.
func ReadFile(filename string, options ParseOption) (doc *XmlDocument, err error) {
	// verify the file exists and can be read before we invoke C API
	_, err = os.Stat(filename)
	if err != nil {
		return
	}

	dataBytes := GetCString([]byte(filename))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	var docPtr *C.xmlDoc
	docPtr = C.xmlReadFile((*C.char)(dataPtr), nil, C.int(options))
	if docPtr == nil {
		err = ERR_FAILED_TO_PARSE_XML
	} else {
		var encoding []byte
		// capture the detected input encoding
		p := docPtr.encoding
		if p != nil {
			encoding = []byte(C.GoString((*C.char)(unsafe.Pointer(p))))
		}
		doc = NewDocument(unsafe.Pointer(docPtr), 0, encoding, DefaultEncodingBytes)
	}
	return
}

// Create an empty XML document and return an XmlDocument. The root element, along with
// any top-level comments or processing instructions, can be added by calling
// AddChild() on the document itself.
func CreateEmptyDocument(inEncoding, outEncoding []byte) (doc *XmlDocument) {
	help.LibxmlInitParser()
	docPtr := C.newEmptyXmlDoc()
	doc = NewDocument(unsafe.Pointer(docPtr), 0, inEncoding, outEncoding)
	return
}

// DocPtr provides access to the libxml2 structure underlying the document.
func (document *XmlDocument) DocPtr() (ptr unsafe.Pointer) {
	ptr = unsafe.Pointer(document.Ptr)
	return
}

// DocType returns one of the node type constants, usually XML_DOCUMENT_NODE. This
// may be of use if you are working with the C API.
func (document *XmlDocument) DocType() (t NodeType) {
	t = document.Type
	return
}

// DocRef returns the embedded Document interface.
func (document *XmlDocument) DocRef() (d Document) {
	d = document.Me
	return
}

// InputEncoding is the original encoding of the document.
func (document *XmlDocument) InputEncoding() (encoding []byte) {
	encoding = document.InEncoding
	return
}

// OutputEncoding is the encoding that will be used when the document is written out.
// This can be overridden by explicitly specifying an encoding as an argument to any of the
// output functions.
func (document *XmlDocument) OutputEncoding() (encoding []byte) {
	encoding = document.OutEncoding
	return
}

// Returns an XPath context that can be used to compile and evaluate XPath
// expressions.
//
// In most cases, you should call the Search or EvalXPath functions instead of
// handling the context directly.
func (document *XmlDocument) DocXPathCtx() (ctx *xpath.XPath) {
	ctx = document.XPathCtx
	return
}

func (document *XmlDocument) AddUnlinkedNode(nodePtr unsafe.Pointer) {
	p := (*C.xmlNode)(nodePtr)
	document.UnlinkedNodes[p] = true
}

func (document *XmlDocument) RemoveUnlinkedNode(nodePtr unsafe.Pointer) bool {
	p := (*C.xmlNode)(nodePtr)
	if document.UnlinkedNodes[p] {
		delete(document.UnlinkedNodes, p)
		return true
	}
	return false
}

func (document *XmlDocument) BookkeepFragment(fragment *DocumentFragment) {
	document.fragments = append(document.fragments, fragment)
}

// Root returns the root node of the document. Newly created documents do not
// have a root node until an element node is added a child of the document.
//
// Documents that have multiple root nodes are invalid and the behaviour is
// not well defined.
func (document *XmlDocument) Root() (element *ElementNode) {
	nodePtr := C.xmlDocGetRootElement(document.Ptr)
	if nodePtr != nil {
		element = NewNode(unsafe.Pointer(nodePtr), document).(*ElementNode)
	}
	return
}

// Get an element node by the value of its ID attribute. By convention this attribute
// is named id, but the actual name of the attribute is set by the document's DTD or schema.
//
// The value for an ID attribute is guaranteed to be unique within a valid document.
func (document *XmlDocument) NodeById(id string) (element *ElementNode) {
	dataBytes := GetCString([]byte(id))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	nodePtr := C.xmlGetID(document.Ptr, (*C.xmlChar)(dataPtr))
	if nodePtr != nil {
		idattr := NewNode(unsafe.Pointer(nodePtr), document).(*AttributeNode)
		element = idattr.Parent().(*ElementNode)
	}
	return
}

/*
CreateElementNode creates an element node with the specified tag name. It can be
added as a child of any other element, or as a child of the document itself.

Use SetNamespace if the element node needs to be in a namespace.

Note that valid documents have only one child element, referred to as the root node.
*/
func (document *XmlDocument) CreateElementNode(tag string) (element *ElementNode) {
	tagBytes := GetCString([]byte(tag))
	tagPtr := unsafe.Pointer(&tagBytes[0])
	newNodePtr := C.xmlNewNode(nil, (*C.xmlChar)(tagPtr))
	newNode := NewNode(unsafe.Pointer(newNodePtr), document)
	element = newNode.(*ElementNode)
	return
}

//CreateTextNode creates a text node. It can be added as a child of an element.
//
// The data argument is XML-escaped and used as the content of the node.
func (document *XmlDocument) CreateTextNode(data string) (text *TextNode) {
	dataBytes := GetCString([]byte(data))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	nodePtr := C.xmlNewText((*C.xmlChar)(dataPtr))
	if nodePtr != nil {
		nodePtr.doc = (*C.xmlDoc)(document.DocPtr())
		text = NewNode(unsafe.Pointer(nodePtr), document).(*TextNode)
	}
	return
}

//CreateCDataNode creates a CDATA node. CDATA nodes can
// only be children of an element.
//
// The data argument will become the content of the newly created node.
func (document *XmlDocument) CreateCDataNode(data string) (cdata *CDataNode) {
	dataLen := len(data)
	dataBytes := GetCString([]byte(data))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	nodePtr := C.xmlNewCDataBlock(document.Ptr, (*C.xmlChar)(dataPtr), C.int(dataLen))
	if nodePtr != nil {
		cdata = NewNode(unsafe.Pointer(nodePtr), document).(*CDataNode)
	}
	return
}

//CreateCommentNode creates a comment node. Comment nodes can
// be children of an element or of the document itself.
//
// The data argument will become the content of the comment.
func (document *XmlDocument) CreateCommentNode(data string) (comment *CommentNode) {
	dataBytes := GetCString([]byte(data))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	nodePtr := C.xmlNewComment((*C.xmlChar)(dataPtr))
	if nodePtr != nil {
		comment = NewNode(unsafe.Pointer(nodePtr), document).(*CommentNode)
	}
	return
}

//CreatePINode creates a processing instruction node with the specified name and data.
// Processing instruction nodes can be children of an element or of the document itself.
//
// While it's common to use an attribute-like syntax for processing instructions, the data
// is actually an arbitrary string that you will need to generate or parse yourself.
func (document *XmlDocument) CreatePINode(name, data string) (pi *ProcessingInstructionNode) {
	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])
	dataBytes := GetCString([]byte(data))
	dataPtr := unsafe.Pointer(&dataBytes[0])
	nodePtr := C.xmlNewDocPI(document.Ptr, (*C.xmlChar)(namePtr), (*C.xmlChar)(dataPtr))
	if nodePtr != nil {
		pi = NewNode(unsafe.Pointer(nodePtr), document).(*ProcessingInstructionNode)
	}
	return
}

func (document *XmlDocument) ParseFragment(input, url []byte, options ParseOption) (fragment *DocumentFragment, err error) {
	root := document.Root()
	if root == nil {
		fragment, err = parsefragment(document, nil, input, url, options)
	} else {
		fragment, err = parsefragment(document, root.XmlNode, input, url, options)
	}
	return
}

// Return the value of an NDATA entity declared in the DTD. If there is no such entity or
// the value cannot be encoded as a valid URI, an empty string is returned.
//
// Note that this library assumes you already know the name of entity and does not
// expose any way of getting the list of entities.
func (document *XmlDocument) UnparsedEntityURI(name string) (val string) {
	if name == "" {
		return
	}

	nameBytes := GetCString([]byte(name))
	namePtr := unsafe.Pointer(&nameBytes[0])
	entity := C.xmlGetDocEntity(document.Ptr, (*C.xmlChar)(namePtr))
	if entity == nil {
		return
	}

	// unlike entity.content (which returns the raw, unprocessed string value of the entity),
	// it looks like entity.URI includes any escaping needed to treat the value as a URI.
	valPtr := unsafe.Pointer(entity.URI)
	if valPtr == nil {
		return
	}

	val = C.GoString((*C.char)(valPtr))
	return
}

// Free the C structures associated with this document.
func (document *XmlDocument) Free() {
	//must free the xpath context before freeing the fragments or unlinked nodes
	//otherwise, it causes memory leaks and crashes when dealing with very large documents (a few MB)
	if document.XPathCtx != nil {
		document.XPathCtx.Free()
		document.XPathCtx = nil
	}
	//must clear the fragments first
	//because the nodes are put in the unlinked list
	if document.fragments != nil {
		for _, fragment := range document.fragments {
			fragment.Remove()
		}
	}
	document.fragments = nil
	var p *C.xmlNode
	if document.UnlinkedNodes != nil {
		for p = range document.UnlinkedNodes {
			C.xmlFreeNode(p)
		}
	}
	document.UnlinkedNodes = nil
	if document.Ptr != nil {
		C.xmlFreeDoc(document.Ptr)
		document.Ptr = nil
	}
}

/* Uri returns the URI of the document - typically this is the filename if ReadFile was used to parse
the document.
*/
func (document *XmlDocument) Uri() (val string) {
	val = C.GoString((*C.char)(unsafe.Pointer(document.Ptr.URL)))
	return
}
