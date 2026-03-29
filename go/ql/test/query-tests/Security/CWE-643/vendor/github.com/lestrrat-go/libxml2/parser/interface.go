package parser

import "errors"

var (
	// ErrMalformedXML is returned when the XML source is malformed
	ErrMalformedXML = errors.New("malformed XML")
)

// HTMLOption represents the HTML parser options that
// can be used when parsing HTML
type HTMLOption int

const (
	// HTMLParseRecover enables relaxed parsing
	HTMLParseRecover HTMLOption = 1 << 0
	// HTMLParseNoDefDTD disables using a default doctype when absent
	HTMLParseNoDefDTD = 1 << 2
	// HTMLParseNoError suppresses error reports
	HTMLParseNoError = 1 << 5
	// HTMLParseNoWarning suppresses warning reports
	HTMLParseNoWarning = 1 << 6
	// HTMLParsePedantic enables pedantic error reporting
	HTMLParsePedantic = 1 << 7
	// HTMLParseNoBlanks removes blank nodes
	HTMLParseNoBlanks = 1 << 8
	// HTMLParseNoNet forbids network access during parsing
	HTMLParseNoNet = 1 << 11
	// HTMLParseNoImplied disables implied html/body elements
	HTMLParseNoImplied = 1 << 13
	// HTMLParseCompact enables compaction of small text nodes
	HTMLParseCompact = 1 << 16
	// HTMLParseIgnoreEnc ignores internal document encoding hints
	HTMLParseIgnoreEnc = 1 << 21
)

// DefaultHTMLOptions represents the default set of options
// used in the ParseHTML* functions
const DefaultHTMLOptions = HTMLParseCompact | HTMLParseNoBlanks | HTMLParseNoError | HTMLParseNoWarning

// Option represents the parser option bit
type Option int

const (
	XMLParseRecover    Option = 1 << iota /* recover on errors */
	XMLParseNoEnt                         /* substitute entities */
	XMLParseDTDLoad                       /* load the external subset */
	XMLParseDTDAttr                       /* default DTD attributes */
	XMLParseDTDValid                      /* validate with the DTD */
	XMLParseNoError                       /* suppress error reports */
	XMLParseNoWarning                     /* suppress warning reports */
	XMLParsePedantic                      /* pedantic error reporting */
	XMLParseNoBlanks                      /* remove blank nodes */
	XMLParseSAX1                          /* use the SAX1 interface internally */
	XMLParseXInclude                      /* Implement XInclude substitution  */
	XMLParseNoNet                         /* Forbid network access */
	XMLParseNoDict                        /* Do not reuse the context dictionary */
	XMLParseNsclean                       /* remove redundant namespaces declarations */
	XMLParseNoCDATA                       /* merge CDATA as text nodes */
	XMLParseNoXIncNode                    /* do not generate XINCLUDE START/END nodes */
	XMLParseCompact                       /* compact small text nodes; no modification of the tree allowed afterwards (will possibly crash if you try to modify the tree) */
	XMLParseOld10                         /* parse using XML-1.0 before update 5 */
	XMLParseNoBaseFix                     /* do not fixup XINCLUDE xml:base uris */
	XMLParseHuge                          /* relax any hardcoded limit from the parser */
	XMLParseOldSAX                        /* parse using SAX2 interface before 2.7.0 */
	XMLParseIgnoreEnc                     /* ignore internal document encoding hint */
	XMLParseBigLines                      /* Store big lines numbers in text PSVI field */
	XMLParseMax
	XMLParseEmptyOption Option = 0
)

// Ctxt represents the Parser context. You normally should be using
// Parser, but if you for some reason need to do more low-level
// magic you will have to tinker with this struct
type Ctxt struct {
	ptr uintptr // *C.xmlParserCtxt
}

// Parser represents the high-level parser.
type Parser struct {
	Options Option
}
