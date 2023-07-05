package jade

import "io/ioutil"

//go:generate stringer -type=itemType,NodeType -trimprefix=item -output=config_string.go

var TabSize = 4
var ReadFunc = ioutil.ReadFile

var (
	golang_mode  = false
	tag__bgn     = "<%s%s>"
	tag__end     = "</%s>"
	tag__void    = "<%s%s/>"
	tag__arg_esc = ` %s="{{ print %s }}"`
	tag__arg_une = ` %s="{{ print %s }}"`
	tag__arg_str = ` %s="%s"`
	tag__arg_add = `%s " " %s`
	tag__arg_bgn = ""
	tag__arg_end = ""

	cond__if     = "{{ if %s }}"
	cond__unless = "{{ if not %s }}"
	cond__case   = "{{/* switch %s */}}"
	cond__while  = "{{ range %s }}"
	cond__for    = "{{/* %s, %s */}}{{ range %s }}"
	cond__end    = "{{ end }}"

	cond__for_if   = "{{ if gt len %s 0 }}{{/* %s, %s */}}{{ range %s }}"
	code__for_else = "{{ end }}{{ else }}"

	code__longcode  = "{{/* %s */}}"
	code__buffered  = "{{ %s }}"
	code__unescaped = "{{ %s }}"
	code__else      = "{{ else }}"
	code__else_if   = "{{ else if %s }}"
	code__case_when = "{{/* case %s: */}}"
	code__case_def  = "{{/* default: */}}"
	code__mix_block = "{{/* block */}}"

	text__str     = "%s"
	text__comment = "<!--%s -->"

	mixin__bgn           = "\n%s"
	mixin__end           = ""
	mixin__var_bgn       = ""
	mixin__var           = "{{ $%s := %s }}"
	mixin__var_rest      = "{{ $%s := %#v }}"
	mixin__var_end       = "\n"
	mixin__var_block_bgn = ""
	mixin__var_block     = ""
	mixin__var_block_end = ""
)

type ReplaseTokens struct {
	GolangMode bool
	TagBgn     string
	TagEnd     string
	TagVoid    string
	TagArgEsc  string
	TagArgUne  string
	TagArgStr  string
	TagArgAdd  string
	TagArgBgn  string
	TagArgEnd  string

	CondIf     string
	CondUnless string
	CondCase   string
	CondWhile  string
	CondFor    string
	CondEnd    string
	CondForIf  string

	CodeForElse   string
	CodeLongcode  string
	CodeBuffered  string
	CodeUnescaped string
	CodeElse      string
	CodeElseIf    string
	CodeCaseWhen  string
	CodeCaseDef   string
	CodeMixBlock  string

	TextStr     string
	TextComment string

	MixinBgn         string
	MixinEnd         string
	MixinVarBgn      string
	MixinVar         string
	MixinVarRest     string
	MixinVarEnd      string
	MixinVarBlockBgn string
	MixinVarBlock    string
	MixinVarBlockEnd string
}

func Config(c ReplaseTokens) {
	golang_mode = c.GolangMode
	if c.TagBgn != "" {
		tag__bgn = c.TagBgn
	}
	if c.TagEnd != "" {
		tag__end = c.TagEnd
	}
	if c.TagVoid != "" {
		tag__void = c.TagVoid
	}
	if c.TagArgEsc != "" {
		tag__arg_esc = c.TagArgEsc
	}
	if c.TagArgUne != "" {
		tag__arg_une = c.TagArgUne
	}
	if c.TagArgStr != "" {
		tag__arg_str = c.TagArgStr
	}
	if c.TagArgAdd != "" {
		tag__arg_add = c.TagArgAdd
	}
	if c.TagArgBgn != "" {
		tag__arg_bgn = c.TagArgBgn
	}
	if c.TagArgEnd != "" {
		tag__arg_end = c.TagArgEnd
	}
	if c.CondIf != "" {
		cond__if = c.CondIf
	}
	if c.CondUnless != "" {
		cond__unless = c.CondUnless
	}
	if c.CondCase != "" {
		cond__case = c.CondCase
	}
	if c.CondWhile != "" {
		cond__while = c.CondWhile
	}
	if c.CondFor != "" {
		cond__for = c.CondFor
	}
	if c.CondEnd != "" {
		cond__end = c.CondEnd
	}
	if c.CondForIf != "" {
		cond__for_if = c.CondForIf
	}
	if c.CodeForElse != "" {
		code__for_else = c.CodeForElse
	}
	if c.CodeLongcode != "" {
		code__longcode = c.CodeLongcode
	}
	if c.CodeBuffered != "" {
		code__buffered = c.CodeBuffered
	}
	if c.CodeUnescaped != "" {
		code__unescaped = c.CodeUnescaped
	}
	if c.CodeElse != "" {
		code__else = c.CodeElse
	}
	if c.CodeElseIf != "" {
		code__else_if = c.CodeElseIf
	}
	if c.CodeCaseWhen != "" {
		code__case_when = c.CodeCaseWhen
	}
	if c.CodeCaseDef != "" {
		code__case_def = c.CodeCaseDef
	}
	if c.CodeMixBlock != "" {
		code__mix_block = c.CodeMixBlock
	}
	if c.TextStr != "" {
		text__str = c.TextStr
	}
	if c.TextComment != "" {
		text__comment = c.TextComment
	}
	if c.MixinBgn != "" {
		mixin__bgn = c.MixinBgn
	}
	if c.MixinEnd != "" {
		mixin__end = c.MixinEnd
	}
	if c.MixinVarBgn != "" {
		mixin__var_bgn = c.MixinVarBgn
	}
	if c.MixinVar != "" {
		mixin__var = c.MixinVar
	}
	if c.MixinVarRest != "" {
		mixin__var_rest = c.MixinVarRest
	}
	if c.MixinVarEnd != "" {
		mixin__var_end = c.MixinVarEnd
	}
	if c.MixinVarBlockBgn != "" {
		mixin__var_block_bgn = c.MixinVarBlockBgn
	}
	if c.MixinVarBlock != "" {
		mixin__var_block = c.MixinVarBlock
	}
	if c.MixinVarBlockEnd != "" {
		mixin__var_block_end = c.MixinVarBlockEnd
	}
}

//

type goFilter struct {
	Name, Args, Import string
}

var goFlt goFilter

// global variable access (goFlt)
func UseGoFilter() *goFilter { return &goFlt }

//

type itemType int8

const (
	itemError itemType = iota // error occurred; value is text of error
	itemEOF

	itemEndL
	itemIdent
	itemEmptyLine // empty line

	itemText // plain text

	itemComment // html comment
	itemHTMLTag // html <tag>
	itemDoctype // Doctype tag

	itemDiv           // html div for . or #
	itemTag           // html tag
	itemTagInline     // inline tags
	itemTagEnd        // for <tag />
	itemTagVoid       // self-closing tags
	itemTagVoidInline // inline + self-closing tags

	itemID    // id    attribute
	itemClass // class attribute

	itemAttrStart
	itemAttrEnd
	itemAttr
	itemAttrSpace
	itemAttrComma
	itemAttrEqual
	itemAttrEqualUn

	itemFilter
	itemFilterSubf
	itemFilterArgs
	itemFilterText

	// itemKeyword // used only to delimit the keywords

	itemInclude
	itemExtends
	itemBlock
	itemBlockAppend
	itemBlockPrepend
	itemMixin
	itemMixinCall
	itemMixinBlock

	itemCode
	itemCodeBuffered
	itemCodeUnescaped

	itemIf
	itemElse
	itemElseIf
	itemUnless

	itemEach
	itemWhile
	itemFor
	itemForIfNotContain
	itemForElse

	itemCase
	itemCaseWhen
	itemCaseDefault
)

var key = map[string]itemType{
	"include": itemInclude,
	"extends": itemExtends,
	"block":   itemBlock,
	"append":  itemBlockAppend,
	"prepend": itemBlockPrepend,
	"mixin":   itemMixin,

	"if":      itemIf,
	"else":    itemElse,
	"unless":  itemUnless,
	"for":     itemFor,
	"each":    itemEach,
	"while":   itemWhile,
	"case":    itemCase,
	"when":    itemCaseWhen,
	"default": itemCaseDefault,

	"doctype": itemDoctype,

	"a":       itemTagInline,
	"abbr":    itemTagInline,
	"acronym": itemTagInline,
	"b":       itemTagInline,
	"code":    itemTagInline,
	"em":      itemTagInline,
	"font":    itemTagInline,
	"i":       itemTagInline,
	"ins":     itemTagInline,
	"kbd":     itemTagInline,
	"map":     itemTagInline,
	"samp":    itemTagInline,
	"small":   itemTagInline,
	"span":    itemTagInline,
	"strong":  itemTagInline,
	"sub":     itemTagInline,
	"sup":     itemTagInline,

	"area":    itemTagVoid,
	"base":    itemTagVoid,
	"col":     itemTagVoid,
	"command": itemTagVoid,
	"embed":   itemTagVoid,
	"hr":      itemTagVoid,
	"input":   itemTagVoid,
	"keygen":  itemTagVoid,
	"link":    itemTagVoid,
	"meta":    itemTagVoid,
	"param":   itemTagVoid,
	"source":  itemTagVoid,
	"track":   itemTagVoid,
	"wbr":     itemTagVoid,

	"br":  itemTagVoidInline,
	"img": itemTagVoidInline,
}

//

// nodeType identifies the type of a parse tree node.
type nodeType int8

// Type returns itself and provides an easy default implementation
// for embedding in a Node. Embedded in all non-trivial Nodes.
func (t nodeType) Type() nodeType {
	return t
}

const (
	nodeText nodeType = iota
	nodeList
	nodeTag
	nodeCode
	nodeCond
	nodeString
	nodeDoctype
	nodeMixin
	nodeBlock
)
