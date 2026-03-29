/*
Package clib holds all of the dirty C interaction for go-libxml2.

Although this package is visible to the outside world, the API in this
package is in NO WAY guaranteed to be stable. This package was
initially meant to be placed in an internal package so that the
API was not available to the outside world.

The only reason this is visible is so that the REALLY advanced users
can abuse the quasi-direct-C-API to overcome shortcomings of the
"public" API, if any (and of course, you WILL send me a pull request
later... won't you?)

Please DO NOT rely on this API and expect that it will keep backcompat.
When the need arises, it WILL be changed, and if you are not ready
for it, your code WILL break in horrible ways. You have been
warned.
*/
package clib

/*
#cgo pkg-config: libxml-2.0
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>
#include <libxml/HTMLparser.h>
#include <libxml/HTMLtree.h>
#include <libxml/globals.h>
#include <libxml/parser.h>
#include <libxml/parserInternals.h>
#include <libxml/tree.h>
#include <libxml/xmlerror.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <libxml/c14n.h>
#include <libxml/xmlschemas.h>
#include <libxml/schemasInternals.h>

static inline void MY_nilErrorHandler(void *ctx, const char *msg, ...) {}

static inline void MY_xmlSilenceParseErrors() {
	xmlSetGenericErrorFunc(NULL, MY_nilErrorHandler);
}

static inline void MY_xmlDefaultParseErrors() {
	// Checked in the libxml2 source code that using NULL in the second
	// argument restores the default error handler
	xmlSetGenericErrorFunc(NULL, NULL);
}

// Macro wrapper function. cgo cannot detect function-like macros,
// so this is how we avoid it
static inline void MY_xmlFree(void *p) {
	xmlFree(p);
}

// Macro wrapper function. cgo cannot detect function-like macros,
// so this is how we avoid it
static inline xmlError* MY_xmlLastError() {
	return (xmlError*) xmlGetLastError();
}

// Macro wrapper function. cgo cannot detect function-like macros,
// so this is how we avoid it
static inline xmlError* MY_xmlCtxtLastError(void *ctx) {
	return (xmlError*) xmlCtxtGetLastError(ctx);
}

// Change xmlIndentTreeOutput global, return old value, so caller can
// change it back to old value later
static inline int MY_setXmlIndentTreeOutput(int i) {
	int old = xmlIndentTreeOutput;
	xmlIndentTreeOutput = i;
	return old;
}

// Parse a single char out of cur
// Stolen from XML::LibXML
static inline int
MY_parseChar( xmlChar *cur, int *len )
{
	unsigned char c;
	unsigned int val;

	// We are supposed to handle UTF8, check it's valid
	// From rfc2044: encoding of the Unicode values on UTF-8:
	//
	// UCS-4 range (hex.)           UTF-8 octet sequence (binary)
	// 0000 0000-0000 007F   0xxxxxxx
	// 0000 0080-0000 07FF   110xxxxx 10xxxxxx
	// 0000 0800-0000 FFFF   1110xxxx 10xxxxxx 10xxxxxx
	//
	// Check for the 0x110000 limit too

	if ( cur == NULL || *cur == 0 ) {
		*len = 0;
		return(0);
	}

	c = *cur;
	if ( (c & 0x80) == 0 ) {
		*len = 1;
		return((int)c);
	}

	if ((c & 0xe0) == 0xe0) {
		if ((c & 0xf0) == 0xf0) {
			// 4-byte code
			*len = 4;
			val = (cur[0] & 0x7) << 18;
			val |= (cur[1] & 0x3f) << 12;
			val |= (cur[2] & 0x3f) << 6;
			val |= cur[3] & 0x3f;
		} else {
			// 3-byte code
			*len = 3;
			val = (cur[0] & 0xf) << 12;
			val |= (cur[1] & 0x3f) << 6;
			val |= cur[2] & 0x3f;
		}
	} else {
		// 2-byte code
		*len = 2;
		val = (cur[0] & 0x1f) << 6;
		val |= cur[1] & 0x3f;
	}

	if ( !IS_CHAR(val) ) {
		*len = -1;
		return 0;
	}
	return val;
}

// Checks if the given name is a valid name in XML
// stolen from XML::LibXML
static inline int
MY_test_node_name( xmlChar * name )
{
	xmlChar * cur = name;
	int tc  = 0;
	int len = 0;

	if ( cur == NULL || *cur == 0 ) {
		return 0;
	}

	tc = MY_parseChar( cur, &len );

	if ( !( IS_LETTER( tc ) || (tc == '_') || (tc == ':')) ) {
		return 0;
	}

	tc  =  0;
	cur += len;

	while (*cur != 0 ) {
		tc = MY_parseChar( cur, &len );

		if (!(IS_LETTER(tc) || IS_DIGIT(tc) || (tc == '_') ||
				(tc == '-') || (tc == ':') || (tc == '.') ||
				IS_COMBINING(tc) || IS_EXTENDER(tc)) )
		{
			return 0;
		}
		tc = 0;
		cur += len;
	}

	return(1);
}

// optimization
static xmlNode*
MY_xmlCreateElement(xmlDoc *doc, xmlChar *name) {
	if (MY_test_node_name(name) == 0) {
		return NULL;
	}

	xmlNode *ptr = xmlNewNode(NULL, name);
	if (ptr == NULL) {
		return NULL;
	}

	ptr->doc = doc;
	return ptr;
}

static
xmlNode *
MY_xmlCreateElementNS(xmlDoc *doc, xmlChar *nsuri, xmlChar *name) {
	xmlChar *local = name;
	xmlChar *prefix = NULL;
	xmlNode *node = NULL;
	int i;

	if (MY_test_node_name(name) == 0) {
		return NULL;
	}

	for (i = 0; i < xmlStrlen(name); i++) {
		local++;
		// XXX boundary check!
		if (*local == ':') {
			local++;
			break;
		}
	}

	if (local != name) {
		prefix = (xmlChar *) malloc(sizeof(xmlChar) * (local - name));
		memcpy(prefix, name, local - name - 1);
		prefix[(local - name - 1)] = '\0';
	}

	xmlNode *root = xmlDocGetRootElement(doc);
	xmlNs *ns;
	if (root == NULL) {
		// No document element
		ns = xmlNewNs(NULL, nsuri, prefix);
	} else if (prefix != NULL) {
		// Prefix exists, check if this is declared
		ns = xmlSearchNs(doc, root, prefix);
		if (ns == NULL) { // Not declared, create a new one
			ns = xmlNewNs(NULL, nsuri, prefix);
		} else { // Declared. Does the uri match?
			if (xmlStrcmp(ns->href, nsuri) != 0) {
				// Cleanup prefix
				goto CLEANUP;
			}
			// Namespace is already registered, we don't need to provide a
			// namespace element to xmlNewDocNode
			ns = NULL;
			local = name;
		}
	} else {
		// If the name does not contain a prefix, check for the
		// existence of this namespace via the URI
		ns = xmlSearchNsByHref(doc, root, nsuri);
		if (ns == NULL) {
			ns = xmlNewNs(NULL, nsuri, NULL);
		}
	}

	node = xmlNewDocNode(doc, ns, local, NULL);
	if (ns != NULL) {
		node->nsDef = ns;
	}

CLEANUP:
	if (prefix != NULL) {
		free(prefix);
	}

	return node;
}

#define GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE 32
typedef struct go_libxml2_errwarn_accumulator {
	char *errors[GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE];
	char *warnings[GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE];
	int erridx;
	int warnidx;
} go_libxml2_errwarn_accumulator;

static
go_libxml2_errwarn_accumulator*
MY_createErrWarnAccumulator() {
	int i;
	go_libxml2_errwarn_accumulator *ctx;
	ctx = (go_libxml2_errwarn_accumulator *) malloc(sizeof(go_libxml2_errwarn_accumulator));
	for (i = 0; i < GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE; i++) {
		ctx->errors[i] = NULL;
		ctx->warnings[i] = NULL;
	}
	ctx->erridx = 0;
	ctx->warnidx = 0;
	return ctx;
}

static
void
MY_freeErrWarnAccumulator(go_libxml2_errwarn_accumulator* ctx) {
	int i = 0;
	for (i = 0; i < GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE; i++) {
		if (ctx->errors[i] != NULL) {
			free(ctx->errors[i]);
		}
		if (ctx->warnings[i] != NULL) {
			free(ctx->errors[i]);
		}
	}
	free(ctx);
}

static
void
MY_accumulateErr(void *ctx, const char *msg, ...) {
  char buf[1024];
  va_list args;
	go_libxml2_errwarn_accumulator *accum;
	int len;

	accum = (go_libxml2_errwarn_accumulator *) ctx;
	if (accum->erridx >= GO_LIBXML2_ERRWARN_ACCUMULATOR_SIZE) {
		return;
	}

  va_start(args, msg);
  len = vsnprintf(buf, sizeof(buf), msg, args);
  va_end(args);

	if (len == 0) {
		return;
	}

	char *out = (char *) calloc(sizeof(char), len);
	if (buf[len-1] == '\n') {
		// don't want newlines in my error values
		buf[len-1] = '\0';
		len--;
	}
	memcpy(out, buf, len);

  int i = accum->erridx++;
	accum->errors[i] = out;
}

static
void
MY_setErrWarnAccumulator(xmlSchemaValidCtxtPtr ctxt, go_libxml2_errwarn_accumulator *accum) {
	xmlSchemaSetValidErrors(ctxt, MY_accumulateErr, NULL, accum);
}
*/
import "C"
import (
	"fmt"
	"strings"
	"unicode"
	"unicode/utf8"
	"unsafe"

	"github.com/lestrrat-go/libxml2/internal/debug"
	"github.com/lestrrat-go/libxml2/internal/option"
	"github.com/pkg/errors"
)

const _XPathObjectTypeName = "XPathUndefinedXPathNodeSetXPathBooleanXPathNumberXPathStringXPathPointXPathRangeXPathLocationSetXPathUSersXPathXsltTree"

var _XPathObjectTypeIndex = [...]uint8{0, 14, 26, 38, 49, 60, 70, 80, 96, 106, 119}

// String returns the stringified version of XPathObjectType
func (i XPathObjectType) String() string {
	if i < 0 || i+1 >= XPathObjectType(len(_XPathObjectTypeIndex)) {
		return fmt.Sprintf("XPathObjectType(%d)", i)
	}
	return _XPathObjectTypeName[_XPathObjectTypeIndex[i]:_XPathObjectTypeIndex[i+1]]
}

func validDocumentPtr(doc PtrSource) (*C.xmlDoc, error) {
	if doc == nil {
		return nil, ErrInvalidDocument
	}

	if dptr := doc.Pointer(); dptr != 0 {
		return (*C.xmlDoc)(unsafe.Pointer(dptr)), nil
	}
	return nil, ErrInvalidDocument
}

func validParserCtxtPtr(s PtrSource) (*C.xmlParserCtxt, error) {
	if s == nil {
		return nil, ErrInvalidParser
	}

	if ptr := s.Pointer(); ptr != 0 {
		return (*C.xmlParserCtxt)(unsafe.Pointer(ptr)), nil
	}
	return nil, ErrInvalidParser
}

func validNodePtr(n PtrSource) (*C.xmlNode, error) {
	if n == nil {
		return nil, ErrInvalidNode
	}

	nptr := n.Pointer()
	if nptr == 0 {
		return nil, ErrInvalidNode
	}

	return (*C.xmlNode)(unsafe.Pointer(nptr)), nil
}

func validAttributePtr(n PtrSource) (*C.xmlAttr, error) {
	if n == nil {
		return nil, ErrInvalidAttribute
	}

	if nptr := n.Pointer(); nptr != 0 {
		return (*C.xmlAttr)(unsafe.Pointer(nptr)), nil
	}

	return nil, ErrInvalidAttribute
}

func validXPathContextPtr(x PtrSource) (*C.xmlXPathContext, error) {
	if x == nil {
		return nil, ErrInvalidXPathContext
	}

	if xptr := x.Pointer(); xptr != 0 {
		return (*C.xmlXPathContext)(unsafe.Pointer(xptr)), nil
	}
	return nil, ErrInvalidXPathContext
}

func validXPathExpressionPtr(x PtrSource) (*C.xmlXPathCompExpr, error) {
	if x == nil {
		return nil, ErrInvalidXPathExpression
	}

	if xptr := x.Pointer(); xptr != 0 {
		return (*C.xmlXPathCompExpr)(unsafe.Pointer(xptr)), nil
	}
	return nil, ErrInvalidXPathExpression
}

func validXPathObjectPtr(x PtrSource) (*C.xmlXPathObject, error) {
	if x == nil {
		return nil, ErrInvalidXPathObject
	}

	if xptr := x.Pointer(); xptr != 0 {
		return (*C.xmlXPathObject)(unsafe.Pointer(xptr)), nil
	}
	return nil, ErrInvalidXPathObject
}

var _XMLNodeTypeIndex = [...]uint8{0, 11, 24, 32, 48, 61, 71, 77, 88, 100, 116, 132, 144, 160, 167, 178, 191, 201, 214, 227, 238, 254}

const _XMLNodeTypeName = `ElementNodeAttributeNodeTextNodeCDataSectionNodeEntityRefNodeEntityNodePiNodeCommentNodeDocumentNodeDocumentTypeNodeDocumentFragNodeNotationNodeHTMLDocumentNodeDTDNodeElementDeclAttributeDeclEntityDeclNamespaceDeclXIncludeStartXIncludeEndDocbDocumentNode`

// String returns the string representation of this XMLNodeType
func (i XMLNodeType) String() string {
	x := i - 1
	if x < 0 || x+1 >= XMLNodeType(len(_XMLNodeTypeIndex)) {
		return fmt.Sprintf("XMLNodeType(%d)", x+1)
	}
	return _XMLNodeTypeName[_XMLNodeTypeIndex[x]:_XMLNodeTypeIndex[x+1]]
}

// ReportErrors *globally* changes the behavior of reporting errors.
// By default libxml2 spews out lots of data to stderr. When you call
// this function with a `false` value, all those messages are suppressed.
// When you call this function a `true` value, the default behavior is
// restored
func ReportErrors(b bool) {
	if b {
		C.MY_xmlDefaultParseErrors()
	} else {
		C.MY_xmlSilenceParseErrors()
	}
}

func xmlCtxtLastError(ctx PtrSource) error {
	return xmlCtxtLastErrorRaw(ctx.Pointer())
}

func xmlCtxtLastErrorRaw(ctx uintptr) error {
	e := C.MY_xmlCtxtLastError(unsafe.Pointer(ctx))
	if e == nil {
		return errors.New(`unknown error`)
	}
	msg := strings.TrimSuffix(C.GoString(e.message), "\n")
	return errors.Errorf("Entity: line %v: parser error : %v", e.line, msg)
}

func xmlCharToString(s *C.xmlChar) string {
	return C.GoString((*C.char)(unsafe.Pointer(s)))
}

// stringToXMLChar creates a new *C.xmlChar from a Go string.
// Remember to always free this data, as C.CString creates a copy
// of the byte buffer contained in the string
func stringToXMLChar(s string) *C.xmlChar {
	return (*C.xmlChar)(unsafe.Pointer(C.CString(s)))
}

func XMLSchemaParseFromFile(path string) (uintptr, error) {
	parserCtx := C.xmlSchemaNewParserCtxt(C.CString(path))
	if parserCtx == nil {
		return 0, errors.New("failed to create parser")
	}
	defer C.xmlSchemaFreeParserCtxt(parserCtx)

	s := C.xmlSchemaParse(parserCtx)
	if s == nil {
		return 0, errors.New("failed to parse schema")
	}

	return uintptr(unsafe.Pointer(s)), nil
}

func XMLCreateMemoryParserCtxt(s string, o int) (uintptr, error) {
	cs := C.CString(s)
	defer C.free(unsafe.Pointer(cs))
	ctx := C.xmlCreateMemoryParserCtxt(cs, C.int(len(s)))
	if ctx == nil {
		return 0, errors.New("error creating parser")
	}
	C.xmlCtxtUseOptions(ctx, C.int(o))

	return uintptr(unsafe.Pointer(ctx)), nil
}

func XMLParseDocument(ctx PtrSource) error {
	ctxptr, err := validParserCtxtPtr(ctx)
	if err != nil {
		return err
	}

	if C.xmlParseDocument(ctxptr) != C.int(0) {
		return errors.Errorf("parse failed: %v", xmlCtxtLastError(ctx))
	}
	return nil
}

func XMLFreeParserCtxt(ctx PtrSource) error {
	ctxptr, err := validParserCtxtPtr(ctx)
	if err != nil {
		return err
	}

	C.xmlFreeParserCtxt(ctxptr)
	return nil
}

func HTMLReadDoc(content, url, encoding string, opts int) (uintptr, error) {
	// TODO: use htmlCtxReadDoc later, so we can get the error
	ccontent := C.CString(content)
	curl := C.CString(url)
	cencoding := C.CString(encoding)
	defer C.free(unsafe.Pointer(ccontent))
	defer C.free(unsafe.Pointer(curl))
	defer C.free(unsafe.Pointer(cencoding))

	doc := C.htmlReadDoc(
		(*C.xmlChar)(unsafe.Pointer(ccontent)),
		curl,
		cencoding,
		C.int(opts),
	)

	if doc == nil {
		return 0, errors.New("failed to parse document")
	}

	return uintptr(unsafe.Pointer(doc)), nil
}

func XMLCreateDocument(version, encoding string) uintptr {
	cver := stringToXMLChar(version)
	defer C.free(unsafe.Pointer(cver))

	doc := C.xmlNewDoc(cver)
	if encoding != "" {
		cenc := stringToXMLChar(encoding)
		defer C.free(unsafe.Pointer(cenc))

		doc.encoding = C.xmlStrdup(cenc)
	}
	return uintptr(unsafe.Pointer(doc))
}

func XMLEncodeEntitiesReentrant(docptr *C.xmlDoc, s string) (*C.xmlChar, error) {
	cent := stringToXMLChar(s)
	defer C.free(unsafe.Pointer(cent))

	return C.xmlEncodeEntitiesReentrant(docptr, cent), nil
}

func isSafeName(name string) error {
	if utf8.ValidString(name) { // UTF-8, we can do everything in go
		if len(name) > MaxValueBufferSize {
			return ErrValueTooLong
		}
		p := name
		r, n := utf8.DecodeRuneInString(p)
		p = p[n:]
		if !unicode.IsLetter(r) && r != '_' && r != ':' {
			return ErrInvalidNodeName
		}

		for len(p) > 0 {
			r, n = utf8.DecodeRuneInString(p)
			p = p[n:]
			if !unicode.IsLetter(r) && !unicode.IsNumber(r) && r != '_' && r != ':' {
				return ErrInvalidNodeName
			}
		}

		return nil
	}

	// Need to call out to C
	var buf [MaxValueBufferSize]C.xmlChar
	for i := 0; i < len(name); i++ {
		buf[i] = C.xmlChar(name[i])
	}
	bufptr := (uintptr)(unsafe.Pointer(&buf[0]))
	if C.MY_test_node_name((*C.xmlChar)(unsafe.Pointer(bufptr))) == 0 {
		return ErrInvalidNodeName
	}
	return nil
}

func validNamespacePtr(s PtrSource) (*C.xmlNs, error) {
	if s == nil {
		return nil, ErrInvalidNamespace
	}

	if ptr := s.Pointer(); ptr != 0 {
		return (*C.xmlNs)(unsafe.Pointer(ptr)), nil
	}
	return nil, ErrInvalidNamespace
}

func XMLNewNode(ns PtrSource, name string) (uintptr, error) {
	nsptr, err := validNamespacePtr(ns)
	if err != nil {
		return 0, err
	}

	if err := isSafeName(name); err != nil {
		return 0, err
	}

	var cname [MaxElementNameLength]C.xmlChar
	if len(name) > MaxElementNameLength {
		return 0, ErrElementNameTooLong
	}
	for i := 0; i < len(name); i++ {
		cname[i] = C.xmlChar(name[i])
	}
	cnameptr := (uintptr)(unsafe.Pointer(&cname[0]))

	n := C.xmlNewNode(
		(*C.xmlNs)(unsafe.Pointer(nsptr)),
		(*C.xmlChar)(unsafe.Pointer(cnameptr)),
	)
	return uintptr(unsafe.Pointer(n)), nil
}

func XMLNewDocProp(doc PtrSource, k, v string) (uintptr, error) {
	docptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	if err := isSafeName(k); err != nil {
		return 0, err
	}

	if len(k) > MaxAttributeNameLength {
		return 0, ErrAttributeNameTooLong
	}

	var kx [MaxAttributeNameLength]C.xmlChar
	for i := 0; i < len(k); i++ {
		kx[i] = C.xmlChar(k[i])
	}
	// Taking the pointer as uintptr somehow fools the go compiler
	// to not think this escapes to heap
	kxptr := uintptr(unsafe.Pointer(&kx[0]))

	ent, err := XMLEncodeEntitiesReentrant(docptr, v)
	if err != nil {
		return 0, err
	}
	attr := C.xmlNewDocProp(docptr, (*C.xmlChar)(unsafe.Pointer(kxptr)), ent)
	return uintptr(unsafe.Pointer(attr)), nil
}

func XMLSearchNsByHref(doc PtrSource, _ PtrSource, uri string) (uintptr, error) {
	docptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	nptr, err := validNodePtr(doc)
	if err != nil {
		return 0, err
	}

	if len(uri) > MaxNamespaceURILength {
		return 0, ErrNamespaceURITooLong
	}

	var xcuri [MaxNamespaceURILength]C.xmlChar
	for i := 0; i < len(uri); i++ {
		xcuri[i] = C.xmlChar(uri[i])
	}
	xcuriptr := (uintptr)(unsafe.Pointer(&xcuri[0]))

	ns := C.xmlSearchNsByHref(
		(*C.xmlDoc)(unsafe.Pointer(docptr)),
		(*C.xmlNode)(unsafe.Pointer(nptr)),
		(*C.xmlChar)(unsafe.Pointer(xcuriptr)),
	)
	if ns == nil {
		return 0, ErrNamespaceNotFound{Target: uri}
	}
	return uintptr(unsafe.Pointer(ns)), nil
}

func XMLSearchNs(doc PtrSource, n PtrSource, prefix string) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	docptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	cprefix := stringToXMLChar(prefix)
	defer C.free(unsafe.Pointer(cprefix))

	ns := C.xmlSearchNs(docptr, nptr, cprefix)
	if ns == nil {
		return 0, ErrNamespaceNotFound{Target: prefix}
	}
	return uintptr(unsafe.Pointer(ns)), nil
}

func XMLNewDocNode(doc PtrSource, ns PtrSource, local, content string) (uintptr, error) {
	docptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	nsptr, err := validNamespacePtr(ns)
	if err != nil {
		return 0, err
	}

	var c *C.xmlChar
	if len(content) > 0 {
		c = stringToXMLChar(content)
		defer C.free(unsafe.Pointer(c))
	}

	clocal := stringToXMLChar(local)
	defer C.free(unsafe.Pointer(c))

	ptr := C.xmlNewDocNode(docptr, nsptr, clocal, c)
	if ptr == nil {
		return 0, errors.New("failed to create node")
	}
	return uintptr(unsafe.Pointer(ptr)), nil
}

func XMLNewNs(n PtrSource, nsuri, prefix string) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	var cprefix *C.xmlChar

	cnsuri := stringToXMLChar(nsuri)
	if prefix != "" {
		cprefix = stringToXMLChar(prefix)
		defer C.free(unsafe.Pointer(cprefix))
	}
	defer C.free(unsafe.Pointer(cnsuri))

	nsptr := C.xmlNewNs(nptr, cnsuri, cprefix)
	if nsptr == nil {
		return 0, errors.New("failed to create namespace")
	}
	return uintptr(unsafe.Pointer(nsptr)), nil
}

func XMLSetNs(n PtrSource, ns PtrSource) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	nsptr, err := validNamespacePtr(ns)
	if err != nil {
		return err
	}

	C.xmlSetNs(nptr, nsptr)
	return nil
}

func XMLNewCDataBlock(doc PtrSource, txt string) (uintptr, error) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}
	ctxt := stringToXMLChar(txt)
	defer C.free(unsafe.Pointer(ctxt))

	ptr := C.xmlNewCDataBlock(dptr, ctxt, C.int(len(txt)))
	if ptr == nil {
		return 0, errors.New("failed to create CDATA block")
	}
	return uintptr(unsafe.Pointer(ptr)), nil
}

func XMLNewComment(txt string) (uintptr, error) {
	ctxt := stringToXMLChar(txt)
	defer C.free(unsafe.Pointer(ctxt))

	ptr := C.xmlNewComment(ctxt)
	if ptr == nil {
		return 0, errors.New("failed to create comment node")
	}
	return uintptr(unsafe.Pointer(ptr)), nil
}

func XMLNewText(txt string) (uintptr, error) {
	ctxt := stringToXMLChar(txt)
	defer C.free(unsafe.Pointer(ctxt))

	ptr := C.xmlNewText(ctxt)
	if ptr == nil {
		return 0, errors.New("failed to create text node")
	}
	return uintptr(unsafe.Pointer(ptr)), nil
}

func XMLNodeName(n PtrSource) (string, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return "", err
	}

	var s string
	switch XMLNodeType(nptr._type) {
	case XIncludeStart, XIncludeEnd, EntityRefNode, EntityNode, DTDNode, EntityDecl, DocumentTypeNode, NotationNode, NamespaceDecl:
		s = xmlCharToString(nptr.name)
	case CommentNode:
		s = "#comment"
	case CDataSectionNode:
		s = "#cdata-section"
	case TextNode:
		s = "#text"
	case DocumentNode, HTMLDocumentNode, DocbDocumentNode:
		s = "#document"
	case DocumentFragNode:
		s = "#document-fragment"
	case ElementNode, AttributeNode:
		if ns := nptr.ns; ns != nil {
			if nsstr := xmlCharToString(ns.prefix); nsstr != "" {
				s = fmt.Sprintf("%s:%s", xmlCharToString(ns.prefix), xmlCharToString(nptr.name))
			}
		}

		if s == "" {
			s = xmlCharToString(nptr.name)
		}
	case ElementDecl, AttributeDecl:
		panic("unimplemented")
	default:
		panic("unknown")
	}

	return s, nil
}

func XMLNodeValue(n PtrSource) (string, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return "", err
	}

	var s string
	switch XMLNodeType(nptr._type) {
	case AttributeNode, ElementNode, TextNode, CommentNode, PiNode, EntityRefNode:
		xc := C.xmlXPathCastNodeToString(nptr)
		s = xmlCharToString(xc)
		C.MY_xmlFree(unsafe.Pointer(xc))
	case CDataSectionNode, EntityDecl:
		if nptr.content != nil {
			xc := C.xmlStrdup(nptr.content)
			s = xmlCharToString(xc)
			C.MY_xmlFree(unsafe.Pointer(xc))
		}
	default:
		panic("unimplmented")
	}

	return s, nil
}

func XMLAddChild(n PtrSource, child PtrSource) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	cptr, err := validNodePtr(child)
	if err != nil {
		return err
	}

	if C.xmlAddChild(nptr, cptr) == nil {
		return errors.New("failed to add child")
	}
	return nil
}

func XMLOwnerDocument(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	if nptr.doc == nil {
		return 0, ErrInvalidDocument
	}
	return uintptr(unsafe.Pointer(nptr.doc)), nil
}

func XMLFirstChild(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	if !XMLHasChildNodes(n) {
		return 0, errors.New("no children")
	}

	return uintptr(unsafe.Pointer(nptr.children)), nil
}

func XMLHasChildNodes(n PtrSource) bool {
	nptr, err := validNodePtr(n)
	if err != nil {
		return false
	}
	return nptr.children != nil
}

func XMLLastChild(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}
	return uintptr(unsafe.Pointer(nptr.last)), nil
}

func XMLLocalName(n PtrSource) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}

	switch XMLNodeType(nptr._type) {
	case ElementNode, AttributeNode, ElementDecl, AttributeDecl:
		return xmlCharToString(nptr.name)
	}
	return ""
}

func XMLNamespaceURI(n PtrSource) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}

	switch XMLNodeType(nptr._type) {
	case ElementNode, AttributeNode, PiNode:
		if ns := nptr.ns; ns != nil && ns.href != nil {
			return xmlCharToString(ns.href)
		}
	}
	return ""
}

func XMLNextSibling(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}
	return uintptr(unsafe.Pointer(nptr.next)), nil
}

func XMLParentNode(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}
	return uintptr(unsafe.Pointer(nptr.parent)), nil
}

func XMLPrefix(n PtrSource) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}

	switch XMLNodeType(nptr._type) {
	case ElementNode, AttributeNode, PiNode:
		if ns := nptr.ns; ns != nil && ns.prefix != nil {
			return xmlCharToString(ns.prefix)
		}
	}
	return ""
}

func XMLPreviousSibling(n PtrSource) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}
	return uintptr(unsafe.Pointer(nptr.prev)), nil
}

func XMLSetNodeName(n PtrSource, name string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}
	cname := stringToXMLChar(name)
	defer C.free(unsafe.Pointer(cname))
	C.xmlNodeSetName(nptr, cname)
	return nil
}

func XMLSetNodeValue(n PtrSource, value string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}
	cvalue := stringToXMLChar(value)
	defer C.free(unsafe.Pointer(cvalue))

	// TODO: Implement this in C
	if XMLNodeType(nptr._type) != AttributeNode {
		C.xmlNodeSetContent(nptr, cvalue)
		return nil
	}

	if nptr.children != nil {
		nptr.last = nil
		C.xmlFreeNodeList(nptr.children)
	}

	nptr.children = C.xmlNewText(cvalue)
	nptr.children.parent = nptr
	nptr.children.doc = nptr.doc
	nptr.last = nptr.children
	return nil
}

func XMLTextContent(n PtrSource) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}
	return xmlCharToString(C.xmlXPathCastNodeToString(nptr))
}

func XMLToString(n PtrSource, format int, _ bool) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}

	buffer := C.xmlBufferCreate()
	defer C.xmlBufferFree(buffer)

	if format <= 0 {
		C.xmlNodeDump(buffer, nptr.doc, nptr, 0, 0)
	} else {
		oIndentTreeOutput := C.MY_setXmlIndentTreeOutput(1)
		C.xmlNodeDump(buffer, nptr.doc, nptr, 0, C.int(format))
		C.MY_setXmlIndentTreeOutput(oIndentTreeOutput)
	}
	return xmlCharToString(C.xmlBufferContent(buffer))
}

func XMLLookupNamespacePrefix(n PtrSource, href string) (string, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return "", err
	}

	if href == "" {
		return "", ErrNamespaceNotFound{Target: href}
	}

	chref := stringToXMLChar(href)
	defer C.free(unsafe.Pointer(chref))
	ns := C.xmlSearchNsByHref(nptr.doc, nptr, chref)
	if ns == nil {
		return "", ErrNamespaceNotFound{Target: href}
	}

	return xmlCharToString(ns.prefix), nil
}

func XMLLookupNamespaceURI(n PtrSource, prefix string) (string, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return "", err
	}

	if prefix == "" {
		return "", ErrNamespaceNotFound{Target: prefix}
	}

	cprefix := stringToXMLChar(prefix)
	defer C.free(unsafe.Pointer(cprefix))
	ns := C.xmlSearchNs(nptr.doc, nptr, cprefix)
	if ns == nil {
		return "", ErrNamespaceNotFound{Target: prefix}
	}

	return xmlCharToString(ns.href), nil
}

func XMLGetNodeTypeRaw(n uintptr) XMLNodeType {
	nptr := (*C.xmlNode)(unsafe.Pointer(n))
	return XMLNodeType(nptr._type)
}

func XMLGetNodeType(n PtrSource) XMLNodeType {
	nptr, err := validNodePtr(n)
	if err != nil {
		return XMLNodeType(0)
	}
	return XMLNodeType(nptr._type)
}

func XMLChildNodes(n PtrSource) ([]uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid node for XMLChildNodes")
	}

	ret := []uintptr(nil)
	for chld := nptr.children; chld != nil; chld = chld.next {
		ret = append(ret, uintptr(unsafe.Pointer(chld)))
	}
	return ret, nil
}

type stringer interface {
	String() string
}

func XMLRemoveChild(n PtrSource, t PtrSource) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return errors.Wrap(err, "failed to get valid node for XMLRemoveChild")
	}

	tptr, err := validNodePtr(t)
	if err != nil {
		return errors.Wrap(err, "failed to get valid node for XMLRemoveChild")
	}

	switch XMLNodeType(tptr._type) {
	case AttributeNode, NamespaceDecl:
		return nil
	}

	if tptr.parent != nptr {
		return nil /* not a child! */
	}

	unlinkNode(tptr)
	if XMLNodeType(tptr._type) == ElementNode {
		reconcileNs(tptr)
	}

	return nil
}

func unlinkNode(nptr *C.xmlNode) {
	if nptr == nil || (nptr.prev == nil && nptr.next == nil && nptr.parent == nil) {
		return
	}

	if XMLNodeType(nptr._type) == DTDNode {
		/* This clears the doc->intSubset pointer. */
		C.xmlUnlinkNode(nptr)
		return
	}

	if nptr.prev != nil {
		nptr.prev.next = nptr.next
	}

	if nptr.next != nil {
		nptr.next.prev = nptr.prev
	}

	if nptr.parent != nil {
		if nptr == nptr.parent.last {
			nptr.parent.last = nptr.prev
		}

		if nptr == nptr.parent.children {
			nptr.parent.children = nptr.next
		}
	}

	nptr.prev = nil
	nptr.next = nil
	nptr.parent = nil
}

func reconcileNs(tree *C.xmlNode) {
	var unused *C.xmlNs
	reconcileNsSave(tree, &unused)
	if unused != nil {
		C.xmlFreeNsList(unused)
	}
}

func addNsChain(n *C.xmlNs, ns *C.xmlNs) *C.xmlNs {
	if n == nil {
		return ns
	}

	for i := n; i != nil && i != ns; i = i.next {
		if i == nil {
			ns.next = n
			return ns
		}
	}

	return n
}

func addNsDef(tree *C.xmlNode, ns *C.xmlNs) {
	i := tree.nsDef
	//nolint:revive
	for ; i != nil && i != ns; i = i.next {
	}

	if i == nil {
		ns.next = tree.nsDef
		tree.nsDef = ns
	}
}

func removeNsDef(tree *C.xmlNode, ns *C.xmlNs) bool {
	if ns == tree.nsDef {
		tree.nsDef = tree.nsDef.next
		ns.next = nil
		return true
	}

	for i := tree.nsDef; i != nil; i = i.next {
		if i.next == ns {
			i.next = ns.next
			ns.next = nil
			return true
		}
	}

	return false
}

func reconcileNsSave(tree *C.xmlNode, unused **C.xmlNs) {
	if tree.ns != nil && (XMLNodeType(tree._type) == ElementNode || XMLNodeType(tree._type) == AttributeNode) {
		ns := C.xmlSearchNs(tree.doc, tree.parent, tree.ns.prefix)
		if ns != nil && ns.href != nil && tree.ns.href != nil && C.xmlStrcmp(ns.href, tree.ns.href) == 0 {
			/* Remove the declaration (if present) */
			if removeNsDef(tree, tree.ns) {
				/* Queue the namespace for freeing */

				*unused = addNsChain(*unused, tree.ns)
			}
			/* Replace the namespace with the one found */

			tree.ns = ns
		} else {
			/* If the declaration is here, we don't need to do anything */
			if removeNsDef(tree, tree.ns) {
				addNsDef(tree, tree.ns)
			} else {
				/* Restart the namespace at this point */
				tree.ns = C.xmlCopyNamespace(tree.ns)
				addNsDef(tree, tree.ns)
			}
		}
	}
}

func SplitPrefixLocal(s string) (string, string) {
	i := strings.IndexByte(s, ':')
	if i == -1 {
		return "", s
	}
	return s[:i], s[i+1:]
}

func XMLNamespaceHref(n PtrSource) string {
	nsptr, err := validNamespacePtr(n)
	if err != nil {
		return ""
	}
	return xmlCharToString(nsptr.href)
}

func XMLNamespacePrefix(n PtrSource) string {
	nsptr, err := validNamespacePtr(n)
	if err != nil {
		return ""
	}
	return xmlCharToString(nsptr.prefix)
}

func XMLNamespaceFree(n PtrSource) {
	nsptr, err := validNamespacePtr(n)
	if err != nil {
		return
	}
	C.MY_xmlFree(unsafe.Pointer(nsptr))
}

func XMLCreateAttributeNS(doc PtrSource, uri, k, v string) (uintptr, error) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	rootptr := C.xmlDocGetRootElement(dptr)
	if rootptr == nil {
		return 0, errors.New("no document element found")
	}

	if err := isSafeName(k); err != nil {
		return 0, err
	}

	prefix, local := SplitPrefixLocal(k)

	if len(uri) > MaxNamespaceURILength {
		return 0, ErrNamespaceURITooLong
	}

	var xcuri [MaxNamespaceURILength]C.xmlChar
	for i := 0; i < len(uri); i++ {
		xcuri[i] = C.xmlChar(uri[i])
	}
	xcuriptr := (uintptr)(unsafe.Pointer(&xcuri[0]))

	ns := C.xmlSearchNsByHref(
		(*C.xmlDoc)(unsafe.Pointer(dptr)),
		(*C.xmlNode)(unsafe.Pointer(rootptr)),
		(*C.xmlChar)(unsafe.Pointer(xcuriptr)),
	)
	if ns == nil {
		if len(prefix) > MaxAttributeNameLength {
			return 0, ErrAttributeNameTooLong
		}
		var xcprefix [MaxAttributeNameLength]C.xmlChar
		for i := 0; i < len(prefix); i++ {
			xcprefix[i] = C.xmlChar(prefix[i])
		}
		xcprefixptr := (uintptr)(unsafe.Pointer(&xcprefix))

		ns = C.xmlNewNs(
			rootptr,
			(*C.xmlChar)(unsafe.Pointer(xcuriptr)),
			(*C.xmlChar)(unsafe.Pointer(xcprefixptr)),
		)
		if ns == nil {
			return 0, errors.New("failed to create namespace")
		}
	}

	xcv := stringToXMLChar(v)
	defer C.free(unsafe.Pointer(xcv))

	ent := C.xmlEncodeEntitiesReentrant(dptr, xcv)
	if ent == nil {
		return 0, errors.New("failed to encode value")
	}

	xclocal := stringToXMLChar(local)
	defer C.free(unsafe.Pointer(xclocal))

	attr := C.xmlNewDocProp(dptr, xclocal, ent)

	C.xmlSetNs((*C.xmlNode)(unsafe.Pointer(attr)), ns)

	return uintptr(unsafe.Pointer(attr)), nil
}

func XMLCreateElement(d PtrSource, name string) (uintptr, error) {
	dptr, err := validDocumentPtr(d)
	if err != nil {
		return 0, err
	}

	var xcname [MaxElementNameLength]C.xmlChar
	if len(name) > MaxElementNameLength {
		return 0, ErrElementNameTooLong
	}
	for i := 0; i < len(name); i++ {
		xcname[i] = C.xmlChar(name[i])
	}
	xcnameptr := (uintptr)(unsafe.Pointer(&xcname[0]))

	nptr := C.MY_xmlCreateElement(dptr, (*C.xmlChar)(unsafe.Pointer(xcnameptr)))
	if nptr == nil {
		return 0, errors.New("element creation failed")
	}

	return uintptr(unsafe.Pointer(nptr)), nil
}

func XMLCreateElementNS(doc PtrSource, nsuri, name string) (uintptr, error) {
	if nsuri == "" {
		return XMLCreateElement(doc, name)
	}

	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	if len(nsuri) > MaxNamespaceURILength {
		return 0, ErrNamespaceURITooLong
	}

	var xcnsuri [MaxNamespaceURILength]C.xmlChar
	for i := 0; i < len(nsuri); i++ {
		xcnsuri[i] = C.xmlChar(nsuri[i])
	}
	xcnsuriptr := (uintptr)(unsafe.Pointer(&xcnsuri[0]))

	var xcname [MaxElementNameLength]C.xmlChar
	for i := 0; i < len(name); i++ {
		xcname[i] = C.xmlChar(name[i])
	}
	xcnameptr := (uintptr)(unsafe.Pointer(&xcname[0]))

	nptr := C.MY_xmlCreateElementNS(
		dptr,
		(*C.xmlChar)(unsafe.Pointer(xcnsuriptr)),
		(*C.xmlChar)(unsafe.Pointer(xcnameptr)),
	)
	if nptr == nil {
		return 0, errors.New("failed to create element")
	}

	return uintptr(unsafe.Pointer(nptr)), nil
}

func XMLDocumentEncoding(doc PtrSource) string {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return ""
	}
	return xmlCharToString(dptr.encoding)
}

func XMLDocumentStandalone(doc PtrSource) int {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0
	}
	return int(dptr.standalone)
}

func XMLDocumentURI(doc PtrSource) string {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return ""
	}
	return xmlCharToString(dptr.URL)
}

func XMLDocumentVersion(doc PtrSource) string {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return ""
	}
	return xmlCharToString(dptr.version)
}

func XMLDocumentElement(doc PtrSource) (uintptr, error) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return 0, err
	}

	ptr := C.xmlDocGetRootElement(dptr)
	if ptr == nil {
		return 0, errors.New("no document element found")
	}
	return uintptr(unsafe.Pointer(ptr)), nil
}

func XMLFreeDoc(doc PtrSource) error {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return err
	}
	C.xmlFreeDoc(dptr)
	return nil
}

func XMLDocumentString(doc PtrSource, encoding string, format bool) string {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return ""
	}

	var intformat C.int
	if format {
		intformat = C.int(1)
	} else {
		intformat = C.int(0)
	}

	// Ideally this shouldn't happen, but you never know.
	if encoding == "" {
		encoding = "utf-8"
	}

	var xcencoding [MaxEncodingLength]C.char
	for i := 0; i < len(encoding); i++ {
		xcencoding[i] = C.char(encoding[i])
	}
	xcencodingptr := (uintptr)(unsafe.Pointer(&xcencoding[0]))

	var i C.int
	var xc *C.xmlChar
	C.xmlDocDumpFormatMemoryEnc(dptr, &xc, &i, (*C.char)(unsafe.Pointer(xcencodingptr)), intformat)

	defer C.MY_xmlFree(unsafe.Pointer(xc))
	return xmlCharToString(xc)
}

func XMLNodeSetBase(doc PtrSource, s string) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return
	}

	cs := stringToXMLChar(s)
	defer C.free(unsafe.Pointer(cs))
	C.xmlNodeSetBase((*C.xmlNode)(unsafe.Pointer(dptr)), cs)
}

func XMLSetDocumentElement(doc PtrSource, n PtrSource) error {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return err
	}

	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	C.xmlDocSetRootElement(dptr, nptr)
	return nil
}

func XMLSetDocumentEncoding(doc PtrSource, e string) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return
	}

	if dptr.encoding != nil {
		C.MY_xmlFree(unsafe.Pointer(dptr.encoding))
	}

	// note: this doesn't need to be dup'ed, as
	// C.CString is already duped/malloc'ed
	dptr.encoding = stringToXMLChar(e)
}

func XMLSetDocumentStandalone(doc PtrSource, v int) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return
	}
	dptr.standalone = C.int(v)
}

func XMLSetDocumentVersion(doc PtrSource, v string) {
	dptr, err := validDocumentPtr(doc)
	if err != nil {
		return
	}

	if dptr.version != nil {
		C.MY_xmlFree(unsafe.Pointer(dptr.version))
	}

	// note: this doesn't need to be dup'ed, as
	// C.CString is already duped/malloc'ed
	dptr.version = stringToXMLChar(v)
}

func XMLSetProp(n PtrSource, name, value string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	if len(name) > MaxAttributeNameLength {
		return ErrAttributeNameTooLong
	}

	var xcname [MaxAttributeNameLength]C.xmlChar
	for i := 0; i < len(name); i++ {
		xcname[i] = C.xmlChar(name[i])
	}
	xcnameptr := (uintptr)(unsafe.Pointer(&xcname[0]))

	if len(value) > MaxValueBufferSize {
		return ErrValueTooLong
	}
	var xcvalue [MaxValueBufferSize]C.xmlChar
	for i := 0; i < len(value); i++ {
		xcvalue[i] = C.xmlChar(value[i])
	}
	xcvalueptr := (uintptr)(unsafe.Pointer(&xcvalue[0]))

	C.xmlSetProp(
		nptr,
		(*C.xmlChar)(unsafe.Pointer(xcnameptr)),
		(*C.xmlChar)(unsafe.Pointer(xcvalueptr)),
	)
	return nil
}

func XMLElementAttributes(n PtrSource) ([]uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid node for XMLElementAttributes")
	}

	attrs := []uintptr{}
	for attr := nptr.properties; attr != nil; attr = attr.next {
		attrs = append(attrs, uintptr(unsafe.Pointer(attr)))
	}
	return attrs, nil
}

func XMLElementNamespaces(n PtrSource) ([]uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid node for XMLElementNamespaces")
	}

	ret := []uintptr{}
	for ns := nptr.nsDef; ns != nil; ns = ns.next {
		if ns.prefix == nil && ns.href == nil {
			continue
		}
		// ALERT! Allocating new C struct here
		newns := C.xmlCopyNamespace(ns)
		if newns == nil { // XXX this is an error, no?
			continue
		}

		ret = append(ret, uintptr(unsafe.Pointer(newns)))
	}
	return ret, nil
}

func XMLElementGetAttributeNode(n PtrSource, name string) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	// if this is "xmlns", look for the first namespace without
	// the prefix
	if name == "xmlns" {
		for nsdef := nptr.nsDef; nsdef != nil; nsdef = nsdef.next {
			if nsdef.prefix != nil {
				continue
			}
			if debug.Enabled {
				debug.Printf("nsdef.href -> %s", xmlCharToString(nsdef.href))
			}
		}
	}

	cname := stringToXMLChar(name)
	defer C.free(unsafe.Pointer(cname))

	prop := C.xmlHasNsProp(nptr, cname, nil)
	if debug.Enabled {
		debug.Printf("prop = %v", prop)
	}

	if prop == nil {
		prefix, local := SplitPrefixLocal(name)
		if debug.Enabled {
			debug.Printf("prefix = %s, local = %s", prefix, local)
		}
		if local != "" {
			cprefix := stringToXMLChar(prefix)
			defer C.free(unsafe.Pointer(cprefix))
			if ns := C.xmlSearchNs(nptr.doc, nptr, cprefix); ns != nil {
				clocal := stringToXMLChar(local)
				defer C.free(unsafe.Pointer(clocal))

				prop = C.xmlHasNsProp(nptr, clocal, ns.href)
			}
		}
	}

	if prop == nil || XMLNodeType(prop._type) != AttributeNode {
		return 0, ErrAttributeNotFound
	}

	return uintptr(unsafe.Pointer(prop)), nil
}

func XMLFreeProp(attr PtrSource) error {
	nptr, err := validAttributePtr(attr)
	if err != nil {
		return err
	}
	C.xmlFreeProp(nptr)
	return nil
}

func XMLFreeNode(n PtrSource) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}
	C.xmlFreeNode(nptr)
	return nil
}

func XMLUnsetProp(n PtrSource, name string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	cname := stringToXMLChar(name)
	defer C.free(unsafe.Pointer(cname))

	i := C.xmlUnsetProp(nptr, cname)
	if i == C.int(0) {
		return errors.New("failed to unset prop")
	}
	return nil
}

func XMLUnsetNsProp(n PtrSource, ns PtrSource, name string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	nsptr, err := validNamespacePtr(ns)
	if err != nil {
		return err
	}

	cname := stringToXMLChar(name)
	defer C.free(unsafe.Pointer(cname))

	i := C.xmlUnsetNsProp(
		nptr,
		nsptr,
		cname,
	)
	if i == C.int(0) {
		return errors.New("failed to unset prop")
	}
	return nil
}

func XMLC14NDocDumpMemory(d PtrSource, mode int, withComments bool) (string, error) {
	dptr, err := validDocumentPtr(d)
	if err != nil {
		return "", err
	}

	var result *C.xmlChar

	var withCommentsInt C.int
	if withComments {
		withCommentsInt = 1
	}

	modeInt := C.int(mode)

	written := C.xmlC14NDocDumpMemory(
		dptr,
		nil,
		modeInt,
		nil,
		withCommentsInt,
		&result,
	)
	if written < 0 {
		e := C.MY_xmlLastError()
		return "", errors.New("c14n dump failed: " + C.GoString(e.message))
	}
	defer C.MY_xmlFree(unsafe.Pointer(result))
	return xmlCharToString(result), nil
}

func XMLAppendText(n PtrSource, s string) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	cs := stringToXMLChar(s)
	defer C.free(unsafe.Pointer(cs))

	txt := C.xmlNewText(cs)
	if txt == nil {
		return errors.New("failed to create text node")
	}

	if C.xmlAddChild(nptr, (*C.xmlNode)(txt)) == nil {
		return errors.New("failed to create text node")
	}
	return nil
}

func XMLDocCopyNode(n PtrSource, d PtrSource, extended int) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	dptr, err := validDocumentPtr(d)
	if err != nil {
		return 0, err
	}

	ret := C.xmlDocCopyNode(nptr, dptr, C.int(extended))
	if ret == nil {
		return 0, errors.New("copy node failed")
	}

	return uintptr(unsafe.Pointer(ret)), nil
}

func XMLSetTreeDoc(n PtrSource, d PtrSource) error {
	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	dptr, err := validDocumentPtr(d)
	if err != nil {
		return err
	}

	C.xmlSetTreeDoc(nptr, dptr)
	return nil
}

func XMLParseInNodeContext(n PtrSource, data string, o int) (uintptr, error) {
	nptr, err := validNodePtr(n)
	if err != nil {
		return 0, err
	}

	var ret C.xmlNodePtr
	cdata := C.CString(data)
	defer C.free(unsafe.Pointer(cdata))
	if C.xmlParseInNodeContext(nptr, cdata, C.int(len(data)), C.int(o), &ret) != 0 {
		return 0, errors.New("XXX PLACE HOLDER XXX")
	}

	return uintptr(unsafe.Pointer(ret)), nil
}

func XMLXPathNewContext(n PtrSource) (uintptr, error) {
	ctx := C.xmlXPathNewContext(nil)
	ctx.namespaces = nil

	nptr, err := validNodePtr(n)
	if err == nil {
		ctx.node = (*C.xmlNode)(unsafe.Pointer(nptr))
	}

	return uintptr(unsafe.Pointer(ctx)), nil
}

func XMLXPathContextSetContextNode(x PtrSource, n PtrSource) error {
	xptr, err := validXPathContextPtr(x)
	if err != nil {
		return err
	}

	nptr, err := validNodePtr(n)
	if err != nil {
		return err
	}

	xptr.node = nptr
	return nil
}

func XMLXPathCompile(s string) (uintptr, error) {
	if len(s) > MaxXPathExpressionLength {
		return 0, ErrXPathExpressionTooLong
	}

	var xcs [MaxXPathExpressionLength]C.xmlChar
	for i := 0; i < len(s); i++ {
		xcs[i] = C.xmlChar(s[i])
	}
	xcsptr := (uintptr)(unsafe.Pointer(&xcs[0]))

	if p := C.xmlXPathCompile((*C.xmlChar)(unsafe.Pointer(xcsptr))); p != nil {
		return uintptr(unsafe.Pointer(p)), nil
	}
	return 0, ErrXPathCompileFailure
}

func XMLXPathFreeCompExpr(x PtrSource) error {
	xptr, err := validXPathExpressionPtr(x)
	if err != nil {
		return err
	}
	C.xmlXPathFreeCompExpr(xptr)
	return nil
}

func XMLXPathFreeContext(x PtrSource) error {
	xptr, err := validXPathContextPtr(x)
	if err != nil {
		return err
	}
	C.xmlXPathFreeContext(xptr)
	return nil
}

func XMLXPathNSLookup(x PtrSource, prefix string) (string, error) {
	xptr, err := validXPathContextPtr(x)
	if err != nil {
		return "", err
	}

	cprefix := stringToXMLChar(prefix)
	defer C.free(unsafe.Pointer(cprefix))

	if s := C.xmlXPathNsLookup(xptr, cprefix); s != nil {
		return xmlCharToString(s), nil
	}

	return "", ErrNamespaceNotFound{Target: prefix}
}

func XMLXPathRegisterNS(x PtrSource, prefix, nsuri string) error {
	xptr, err := validXPathContextPtr(x)
	if err != nil {
		return err
	}

	if len(prefix) > MaxElementNameLength {
		return ErrElementNameTooLong
	}
	var cprefix [MaxElementNameLength]C.xmlChar
	for i := 0; i < len(prefix); i++ {
		cprefix[i] = C.xmlChar(prefix[i])
	}
	cprefixptr := (uintptr)(unsafe.Pointer(&cprefix[0]))

	if len(nsuri) > MaxNamespaceURILength {
		return ErrNamespaceURITooLong
	}
	var cnsuri [MaxNamespaceURILength]C.xmlChar
	for i := 0; i < len(nsuri); i++ {
		cnsuri[i] = C.xmlChar(nsuri[i])
	}
	cnsuriptr := (uintptr)(unsafe.Pointer(&cnsuri[0]))

	if res := C.xmlXPathRegisterNs(xptr, (*C.xmlChar)(unsafe.Pointer(cprefixptr)), (*C.xmlChar)(unsafe.Pointer(cnsuriptr))); res == -1 {
		return ErrXPathNamespaceRegisterFailure
	}
	return nil
}

func XMLEvalXPath(x PtrSource, expr PtrSource) (uintptr, error) {
	xptr, err := validXPathContextPtr(x)
	if err != nil {
		return 0, err
	}

	exprptr, err := validXPathExpressionPtr(expr)
	if err != nil {
		return 0, err
	}

	// If there is no document associated with this context,
	// then xmlXPathCompiledEval() just fails to match
	if xptr.node != nil && xptr.node.doc != nil {
		xptr.doc = xptr.node.doc
	}

	if xptr.doc == nil {
		var xcv [3]C.xmlChar = [3]C.xmlChar{'1', '.', '0'}
		xcvptr := (uintptr)(unsafe.Pointer(&xcv[0]))
		xptr.doc = C.xmlNewDoc((*C.xmlChar)(unsafe.Pointer(xcvptr)))

		defer C.xmlFreeDoc(xptr.doc)
	}

	res := C.xmlXPathCompiledEval(exprptr, xptr)
	if res == nil {
		return 0, ErrXPathEmptyResult
	}

	return uintptr(unsafe.Pointer(res)), nil
}

func XMLXPathFreeObject(x PtrSource) {
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return
	}
	C.xmlXPathFreeObject(xptr)
	//	if xptr.nodesetval != nil {
	//		C.xmlXPathFreeNodeSet(xptr.nodesetval)
	//	}
}

func XMLXPathObjectNodeListLen(x PtrSource) int {
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return 0
	}

	if xptr.nodesetval == nil {
		return 0
	}

	return int(xptr.nodesetval.nodeNr)
}

func XMLXPathObjectType(x PtrSource) XPathObjectType {
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return XPathUndefinedType
	}
	return XPathObjectType(xptr._type)
}

func XMLXPathObjectFloat64(x PtrSource) float64 {
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return float64(0)
	}

	return float64(xptr.floatval)
}

func XMLXPathObjectBool(x PtrSource) bool {
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return false
	}

	return xptr.boolval == 1
}

func XMLXPathObjectNodeList(x PtrSource) ([]uintptr, error) {
	// Probably needs NodeList iterator
	xptr, err := validXPathObjectPtr(x)
	if err != nil {
		return nil, errors.Wrap(err, "failed to get valid xpath object for XMLXPathObjectNodeList")
	}

	nodeset := xptr.nodesetval
	if nodeset == nil {
		return nil, errors.Wrap(ErrInvalidNode, "failed to get valid node for XMLXPathObjectNodeList")
	}

	if nodeset.nodeNr == 0 {
		return nil, errors.Wrap(ErrInvalidNode, "failed to get valid node for XMLXPathObjectNodeList")
	}

	nodes := unsafe.Slice(nodeset.nodeTab, nodeset.nodeNr)

	ret := make([]uintptr, nodeset.nodeNr)
	for i := 0; i < int(nodeset.nodeNr); i++ {
		ret[i] = uintptr(unsafe.Pointer(nodes[i]))
	}

	return ret, nil
}

func XMLTextData(n PtrSource) string {
	nptr, err := validNodePtr(n)
	if err != nil {
		return ""
	}
	return xmlCharToString(nptr.content)
}

func XMLSchemaParse(buf []byte, options ...option.Interface) (uintptr, error) {
	var uri string
	var encoding string
	var coptions int
	//nolint:forcetypeassert
	for _, opt := range options {
		switch opt.Name() {
		case option.OptKeyWithURI:
			uri = opt.Value().(string)
		}
	}

	docctx := C.xmlCreateMemoryParserCtxt((*C.char)(unsafe.Pointer(&buf[0])), C.int(len(buf)))
	if docctx == nil {
		return 0, errors.New("error creating doc parser")
	}

	var curi *C.char
	if uri != "" {
		curi = C.CString(uri)
		defer C.free(unsafe.Pointer(curi))
	}

	var cencoding *C.char
	if encoding != "" {
		cencoding = C.CString(encoding)
		defer C.free(unsafe.Pointer(cencoding))
	}

	doc := C.xmlCtxtReadMemory(docctx, (*C.char)(unsafe.Pointer(&buf[0])), C.int(len(buf)), curi, cencoding, C.int(coptions))
	if doc == nil {
		return 0, errors.Errorf("failed to read schema from memory: %v",
			xmlCtxtLastErrorRaw(uintptr(unsafe.Pointer(docctx))))
	}

	parserCtx := C.xmlSchemaNewDocParserCtxt((*C.xmlDoc)(unsafe.Pointer(doc)))
	if parserCtx == nil {
		return 0, errors.New("failed to create parser")
	}
	defer C.xmlSchemaFreeParserCtxt(parserCtx)

	s := C.xmlSchemaParse(parserCtx)
	if s == nil {
		return 0, errors.New("failed to parse schema")
	}

	return uintptr(unsafe.Pointer(s)), nil
}

func XMLSchemaValidateDocument(schema PtrSource, document PtrSource, options ...int) []error {
	sptr, err := validSchemaPtr(schema)
	if err != nil {
		return []error{err}
	}

	dptr, err := validDocumentPtr(document)
	if err != nil {
		return []error{err}
	}

	ctx := C.xmlSchemaNewValidCtxt(sptr)
	if ctx == nil {
		return []error{errors.New("failed to build validator")}
	}
	defer C.xmlSchemaFreeValidCtxt(ctx)

	accum := C.MY_createErrWarnAccumulator()
	defer C.MY_freeErrWarnAccumulator(accum)

	C.MY_setErrWarnAccumulator(ctx, accum)

	for _, option := range options {
		C.xmlSchemaSetValidOptions(ctx, C.int(option))
	}

	if C.xmlSchemaValidateDoc(ctx, dptr) == 0 {
		return nil
	}

	errs := make([]error, accum.erridx)
	for i := 0; i < int(accum.erridx); i++ {
		errs[i] = errors.New(C.GoString(accum.errors[i]))
	}
	return errs
}

func validSchemaPtr(schema PtrSource) (*C.xmlSchema, error) {
	if schema == nil {
		return nil, ErrInvalidSchema
	}
	sptr := schema.Pointer()
	if sptr == 0 {
		return nil, ErrInvalidSchema
	}

	return (*C.xmlSchema)(unsafe.Pointer(sptr)), nil
}

func XMLSchemaFree(s PtrSource) error {
	sptr, err := validSchemaPtr(s)
	if err != nil {
		return err
	}

	C.xmlSchemaFree(sptr)
	return nil
}

func XMLCtxtReadMemory(ctx PtrSource, file string, baseURL string, encoding string, options int) (uintptr, error) {
	ctxptr, err := validParserCtxtPtr(ctx)
	if err != nil {
		return 0, errors.Wrap(err, "not a valid pointer")
	}

	var cfile, cbaseURL, cencoding *C.char
	if file != "" {
		cfile = C.CString(file)
		defer C.free(unsafe.Pointer(cfile))
	}

	if baseURL != "" {
		cbaseURL = C.CString(baseURL)
		defer C.free(unsafe.Pointer(cbaseURL))
	}

	if encoding != "" {
		cencoding = C.CString(encoding)
		defer C.free(unsafe.Pointer(cencoding))
	}

	doc := C.xmlCtxtReadMemory(ctxptr, cfile, C.int(len(file)), cbaseURL, cencoding, C.int(options))
	if doc == nil {
		return 0, errors.Errorf("failed to read document from memory: %v", xmlCtxtLastError(ctx))
	}
	return uintptr(unsafe.Pointer(doc)), nil
}
