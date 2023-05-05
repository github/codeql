package jade

import (
	"bytes"
	"fmt"
	"go/parser"
	"html"
	"io"
	"log"
	"regexp"
	"strings"
)

type tagNode struct {
	nodeType
	pos
	tr       *tree
	Nodes    []node
	AttrName []string
	AttrCode []string
	AttrUesc []bool
	TagName  string
	tagType  itemType
}

func (t *tree) newTag(pos pos, name string, tagType itemType) *tagNode {
	return &tagNode{tr: t, nodeType: nodeTag, pos: pos, TagName: name, tagType: tagType}
}

func (l *tagNode) append(n node) {
	l.Nodes = append(l.Nodes, n)
}

func (l *tagNode) tree() *tree {
	return l.tr
}

func (l *tagNode) attr(a, b string, c bool) {
	for k, v := range l.AttrName {
		// add to existing attribute
		if v == a {
			l.AttrCode[k] = fmt.Sprintf(tag__arg_add, l.AttrCode[k], b)
			return
		}
	}

	l.AttrName = append(l.AttrName, a)
	l.AttrCode = append(l.AttrCode, b)
	l.AttrUesc = append(l.AttrUesc, c)
}

func (l *tagNode) ifAttrArgBollean() {
	for k, v := range l.AttrCode {
		if v == "true" {
			l.AttrCode[k] = `"` + l.AttrName[k] + `"`
		} else if v == "false" {
			l.AttrName = append(l.AttrName[:k], l.AttrName[k+1:]...)
			l.AttrCode = append(l.AttrCode[:k], l.AttrCode[k+1:]...)
			l.AttrUesc = append(l.AttrUesc[:k], l.AttrUesc[k+1:]...)
		}
	}
}

// `"aaa'a" + 'b\"bb"b' + 'c'` >>> `"aaa'a" + "b\"bb\"b" + "c"`
func filterString(in string) string {
	var (
		rs         = []rune(in)
		flag, prev rune
		psn        int
	)
	for k, r := range rs {
		// fmt.Println(string(r), " ", r)
		switch r {
		case '"':
			if flag == '\'' && prev != '\\' {
				rs[k] = 0 // bookmark for replace
			}
			if flag == 0 {
				flag = '"'
				psn = k
			} else if r == flag && prev != '\\' {
				flag = 0
			}
		case '\'':
			if flag == 0 {
				flag = '\''
				psn = k
			} else if r == flag && prev != '\\' {
				// if k-(psn+1) != 1 {
				rs[psn] = '"'
				rs[k] = '"'
				// }
				flag = 0
			}
		case '`':
			if flag == 0 {
				flag = '`'
				psn = k
			} else if r == flag {
				flag = 0
			}
		}
		prev = r
	}
	filterPlus(rs)
	filterJsEsc(rs)
	out := strings.Replace(string(rs), string(rune(0)), `\"`, -1)
	out = strings.Replace(out, string(rune(1)), ``, -1)
	out = strings.Replace(out, string([]rune{2, 2}), "`+", -1)
	out = strings.Replace(out, string(rune(3)), "+`", -1)
	return out
}

// "aaa" +  "bbb" >>> "aaabbb"
func filterPlus(rs []rune) {
	var (
		flag, prev rune
		psn        int
	)
	for k, r := range rs {
		switch r {
		case '"':
			if flag == 0 {
				flag = '"'
				if psn > 0 {
					for i := psn; i < k+1; i++ {
						// fmt.Println(string(rs[i]), rs[i])
						rs[i] = 1
					}
				}
			} else if r == flag && prev != '\\' {
				psn = k
				flag = 0
			}
		case '`':
			if flag == 0 {
				flag = '`'
			} else if r == flag {
				flag = 0
			}
		case ' ', '+':
		default:
			psn = 0
		}
		prev = r
	}
}

// `aaa ${bbb} ccc` >>> `aaa `+bbb+` ccc`
func filterJsEsc(rs []rune) {
	var (
		flag, prev rune
		code       bool
	)
	for k, r := range rs {
		switch r {
		case '`':
			if flag == 0 {
				flag = '`'
			} else if r == flag {
				flag = 0
			}
		case '{':
			if flag == '`' && prev == '$' {
				rs[k-1] = 2
				rs[k] = 2
				code = true
			}
		case '}':
			if flag == '`' && code {
				rs[k] = 3
			}
		}
		prev = r
	}
}

func ifAttrArgString(a string, unesc bool) (string, bool) {
	var (
		str   = []rune(a)
		lng   = len(str)
		first = str[0]
		last  = str[lng-1]
	)

	switch first {
	case '"', '\'':
		if first == last {
			for k, v := range str[1 : lng-1] {
				if v == first && str[k] != '\\' {
					return "", false
				}
			}
			if unesc {
				return string(str[1 : lng-1]), true
			}
			return html.EscapeString(string(str[1 : lng-1])), true
		}
	case '`':
		if first == last {
			if !strings.ContainsAny(string(str[1:lng-1]), "`") {
				if unesc {
					return string(str[1 : lng-1]), true
				}
				return html.EscapeString(string(str[1 : lng-1])), true
			}
		}
	}
	return "", false
}

func ternary(a string) (string, bool) {
	var (
		re    = regexp.MustCompile(`^(.+)\?(.+):(.+)$`)
		match = re.FindStringSubmatch(a)
	)
	if len(match) == 4 {
		for _, v := range match[1:4] {
			if _, err := parser.ParseExpr(v); err != nil {
				return "", false
			}
		}
		return "ternary(" + match[1] + ", " + match[2] + ", " + match[3] + ")", true
	}
	return "", false
}

func (l *tagNode) String() string {
	var b = new(bytes.Buffer)
	l.WriteIn(b)
	return b.String()
}
func (l *tagNode) WriteIn(b io.Writer) {
	var (
		attr = new(bytes.Buffer)
	)
	l.ifAttrArgBollean()

	if len(l.AttrName) > 0 {
		fmt.Fprint(attr, tag__arg_bgn)
		for k, name := range l.AttrName {
			attrStr := filterString(l.AttrCode[k])

			if arg, ok := ifAttrArgString(attrStr, l.AttrUesc[k]); ok {
				fmt.Fprintf(attr, tag__arg_str, name, arg)

			} else if !golang_mode {
				fmt.Fprintf(attr, tag__arg_esc, name, attrStr)

			} else if _, err := parser.ParseExpr(attrStr); err == nil {
				if l.AttrUesc[k] {
					fmt.Fprintf(attr, tag__arg_une, name, l.pos, attrStr)
				} else {
					fmt.Fprintf(attr, tag__arg_esc, name, l.pos, attrStr)
				}

			} else if arg, ok := ternary(attrStr); ok {
				if l.AttrUesc[k] {
					fmt.Fprintf(attr, tag__arg_une, name, l.pos, arg)
				} else {
					fmt.Fprintf(attr, tag__arg_esc, name, l.pos, arg)
				}

			} else {
				log.Fatalln("Error tag attribute value ==> ", attrStr)
			}
		}
		fmt.Fprint(attr, tag__arg_end)
	}
	switch l.tagType {
	case itemTagVoid:
		fmt.Fprintf(b, tag__void, l.TagName, attr)
	case itemTagVoidInline:
		fmt.Fprintf(b, tag__void, l.TagName, attr)
	default:
		fmt.Fprintf(b, tag__bgn, l.TagName, attr)
		for _, inner := range l.Nodes {
			inner.WriteIn(b)
		}
		fmt.Fprintf(b, tag__end, l.TagName)
	}
}

func (l *tagNode) CopyTag() *tagNode {
	if l == nil {
		return l
	}
	n := l.tr.newTag(l.pos, l.TagName, l.tagType)
	n.AttrCode = l.AttrCode
	n.AttrName = l.AttrName
	n.AttrUesc = l.AttrUesc
	for _, elem := range l.Nodes {
		n.append(elem.Copy())
	}
	return n
}

func (l *tagNode) Copy() node {
	return l.CopyTag()
}

//
//

type condNode struct {
	nodeType
	pos
	tr       *tree
	Nodes    []node
	cond     string
	condType itemType
}

func (t *tree) newCond(pos pos, cond string, condType itemType) *condNode {
	return &condNode{tr: t, nodeType: nodeCond, pos: pos, cond: cond, condType: condType}
}

func (l *condNode) append(n node) {
	l.Nodes = append(l.Nodes, n)
}

func (l *condNode) tree() *tree {
	return l.tr
}

func (l *condNode) String() string {
	var b = new(bytes.Buffer)
	l.WriteIn(b)
	return b.String()
}
func (l *condNode) WriteIn(b io.Writer) {
	switch l.condType {
	case itemIf:
		fmt.Fprintf(b, cond__if, l.cond)
	case itemUnless:
		fmt.Fprintf(b, cond__unless, l.cond)
	case itemCase:
		fmt.Fprintf(b, cond__case, l.cond)
	case itemWhile:
		fmt.Fprintf(b, cond__while, l.cond)
	case itemFor, itemEach:
		if k, v, name, ok := l.parseForArgs(); ok {
			fmt.Fprintf(b, cond__for, k, v, name)
		} else {
			fmt.Fprintf(b, "\n{{ Error malformed each: %s }}", l.cond)
		}
	case itemForIfNotContain:
		if k, v, name, ok := l.parseForArgs(); ok {
			fmt.Fprintf(b, cond__for_if, name, k, v, name)
		} else {
			fmt.Fprintf(b, "\n{{ Error malformed each: %s }}", l.cond)
		}
	default:
		fmt.Fprintf(b, "{{ Error Cond %s }}", l.cond)
	}

	for _, n := range l.Nodes {
		n.WriteIn(b)
	}

	fmt.Fprint(b, cond__end)
}

func (l *condNode) parseForArgs() (k, v, name string, ok bool) {
	sp := strings.SplitN(l.cond, " in ", 2)
	if len(sp) != 2 {
		return
	}
	name = strings.Trim(sp[1], " ")
	re := regexp.MustCompile(`^(\w+)\s*,\s*(\w+)$`)
	kv := re.FindAllStringSubmatch(strings.Trim(sp[0], " "), -1)
	if len(kv) == 1 && len(kv[0]) == 3 {
		k = kv[0][2]
		v = kv[0][1]
		ok = true
		return
	}
	r2 := regexp.MustCompile(`^\w+$`)
	kv2 := r2.FindAllString(strings.Trim(sp[0], " "), -1)
	if len(kv2) == 1 {
		k = "_"
		v = kv2[0]
		ok = true
		return
	}
	return
}

func (l *condNode) CopyCond() *condNode {
	if l == nil {
		return l
	}
	n := l.tr.newCond(l.pos, l.cond, l.condType)
	for _, elem := range l.Nodes {
		n.append(elem.Copy())
	}
	return n
}

func (l *condNode) Copy() node {
	return l.CopyCond()
}

//
//

type codeNode struct {
	nodeType
	pos
	tr       *tree
	codeType itemType
	Code     []byte // The text; may span newlines.
}

func (t *tree) newCode(pos pos, text string, codeType itemType) *codeNode {
	return &codeNode{tr: t, nodeType: nodeCode, pos: pos, Code: []byte(text), codeType: codeType}
}

func (t *codeNode) String() string {
	var b = new(bytes.Buffer)
	t.WriteIn(b)
	return b.String()
}
func (t *codeNode) WriteIn(b io.Writer) {
	switch t.codeType {
	case itemCodeBuffered:
		if !golang_mode {
			fmt.Fprintf(b, code__buffered, filterString(string(t.Code)))
			return
		}
		if code, ok := ifAttrArgString(string(t.Code), false); ok {
			fmt.Fprintf(b, code__buffered, t.pos, `"`+code+`"`)
		} else {
			fmt.Fprintf(b, code__buffered, t.pos, filterString(string(t.Code)))
		}
	case itemCodeUnescaped:
		if !golang_mode {
			fmt.Fprintf(b, code__unescaped, filterString(string(t.Code)))
			return
		}
		fmt.Fprintf(b, code__unescaped, t.pos, filterString(string(t.Code)))
	case itemCode:
		fmt.Fprintf(b, code__longcode, filterString(string(t.Code)))
	case itemElse:
		fmt.Fprintf(b, code__else)
	case itemElseIf:
		fmt.Fprintf(b, code__else_if, filterString(string(t.Code)))
	case itemForElse:
		fmt.Fprintf(b, code__for_else)
	case itemCaseWhen:
		fmt.Fprintf(b, code__case_when, filterString(string(t.Code)))
	case itemCaseDefault:
		fmt.Fprintf(b, code__case_def)
	case itemMixinBlock:
		fmt.Fprintf(b, code__mix_block)
	default:
		fmt.Fprintf(b, "{{ Error Code %s }}", t.Code)
	}
}

func (t *codeNode) tree() *tree {
	return t.tr
}

func (t *codeNode) Copy() node {
	return &codeNode{tr: t.tr, nodeType: nodeCode, pos: t.pos, codeType: t.codeType, Code: append([]byte{}, t.Code...)}
}

//
//

type blockNode struct {
	nodeType
	pos
	tr        *tree
	blockType itemType
	Name      string
}

func (t *tree) newBlock(pos pos, name string, textType itemType) *blockNode {
	return &blockNode{tr: t, nodeType: nodeBlock, pos: pos, Name: name, blockType: textType}
}

func (bn *blockNode) String() string {
	var b = new(bytes.Buffer)
	bn.WriteIn(b)
	return b.String()
}
func (bn *blockNode) WriteIn(b io.Writer) {
	var (
		out_blk         = bn.tr.block[bn.Name]
		out_pre, ok_pre = bn.tr.block[bn.Name+"_prepend"]
		out_app, ok_app = bn.tr.block[bn.Name+"_append"]
	)
	if ok_pre {
		out_pre.WriteIn(b)
	}
	out_blk.WriteIn(b)

	if ok_app {
		out_app.WriteIn(b)
	}
}

func (bn *blockNode) tree() *tree {
	return bn.tr
}

func (bn *blockNode) Copy() node {
	return &blockNode{tr: bn.tr, nodeType: nodeBlock, pos: bn.pos, blockType: bn.blockType, Name: bn.Name}
}

//
//

type textNode struct {
	nodeType
	pos
	tr       *tree
	textType itemType
	Text     []byte // The text; may span newlines.
}

func (t *tree) newText(pos pos, text []byte, textType itemType) *textNode {
	return &textNode{tr: t, nodeType: nodeText, pos: pos, Text: text, textType: textType}
}

func (t *textNode) String() string {
	var b = new(bytes.Buffer)
	t.WriteIn(b)
	return b.String()
}
func (t *textNode) WriteIn(b io.Writer) {
	switch t.textType {
	case itemComment:
		fmt.Fprintf(b, text__comment, t.Text)
	default:
		if !golang_mode {
			fmt.Fprintf(b, text__str, t.Text)
		} else {
			fmt.Fprintf(b, text__str, bytes.Replace(t.Text, []byte("`"), []byte("`+\"`\"+`"), -1))
		}
	}
}

func (t *textNode) tree() *tree {
	return t.tr
}

func (t *textNode) Copy() node {
	return &textNode{tr: t.tr, nodeType: nodeText, pos: t.pos, textType: t.textType, Text: append([]byte{}, t.Text...)}
}

//
//

type mixinNode struct {
	nodeType
	pos
	tr        *tree
	Nodes     []node
	AttrName  []string
	AttrCode  []string
	AttrRest  []string
	MixinName string
	block     []node
	tagType   itemType
}

func (t *tree) newMixin(pos pos) *mixinNode {
	return &mixinNode{tr: t, nodeType: nodeMixin, pos: pos}
}

func (l *mixinNode) append(n node) {
	l.Nodes = append(l.Nodes, n)
}
func (l *mixinNode) appendToBlock(n node) {
	l.block = append(l.block, n)
}

func (l *mixinNode) attr(a, b string, c bool) {
	l.AttrName = append(l.AttrName, a)
	l.AttrCode = append(l.AttrCode, b)
}

func (l *mixinNode) tree() *tree {
	return l.tr
}

func (l *mixinNode) String() string {
	var b = new(bytes.Buffer)
	l.WriteIn(b)
	return b.String()
}
func (l *mixinNode) WriteIn(b io.Writer) {
	var (
		attr = new(bytes.Buffer)
		an   = len(l.AttrName)
		rest = len(l.AttrRest)
	)

	if an > 0 {
		fmt.Fprintf(attr, mixin__var_bgn)
		if rest > 0 {
			// TODO
			// fmt.Println("-------- ", mixin__var_rest, l.AttrName[an-1], l.AttrRest)
			fmt.Fprintf(attr, mixin__var_rest, strings.TrimLeft(l.AttrName[an-1], "."), l.AttrRest)
			l.AttrName = l.AttrName[:an-1]
		}
		for k, name := range l.AttrName {
			fmt.Fprintf(attr, mixin__var, name, filterString(l.AttrCode[k]))
		}
		fmt.Fprintf(attr, mixin__var_end)
	}
	fmt.Fprintf(b, mixin__bgn, attr)

	if len(l.block) > 0 {
		b.Write([]byte(mixin__var_block_bgn))
		for _, n := range l.block {
			n.WriteIn(b)
		}
		b.Write([]byte(mixin__var_block_end))
	} else {
		b.Write([]byte(mixin__var_block))
	}

	for _, n := range l.Nodes {
		n.WriteIn(b)
	}
	fmt.Fprintf(b, mixin__end)
}

func (l *mixinNode) CopyMixin() *mixinNode {
	if l == nil {
		return l
	}
	n := l.tr.newMixin(l.pos)
	for _, elem := range l.Nodes {
		n.append(elem.Copy())
	}
	return n
}

func (l *mixinNode) Copy() node {
	return l.CopyMixin()
}

//
//

type doctypeNode struct {
	nodeType
	pos
	tr      *tree
	doctype string
}

func (t *tree) newDoctype(pos pos, text string) *doctypeNode {
	doc := ""
	txt := strings.Trim(text, " ")
	if len(txt) > 0 {
		sls := strings.SplitN(txt, " ", 2)
		switch sls[0] {
		case "5", "html":
			doc = `<!DOCTYPE html%s>`
		case "xml":
			doc = `<?xml version="1.0" encoding="utf-8"%s ?>`
		case "1.1", "xhtml":
			doc = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"%s>`
		case "basic":
			doc = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd"%s>`
		case "strict":
			doc = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"%s>`
		case "frameset":
			doc = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"%s>`
		case "transitional":
			doc = `<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"%s>`
		case "mobile":
			doc = `<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd"%s>`
		case "4", "4strict":
			doc = `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"%s>`
		case "4frameset":
			doc = `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"%s>`
		case "4transitional":
			doc = `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"%s>`
		}
		if doc == "" {
			doc = fmt.Sprintf("<!DOCTYPE %s>", txt)
		} else if doc != "" && len(sls) == 2 {
			doc = fmt.Sprintf(doc, " "+sls[1])
		} else {
			doc = fmt.Sprintf(doc, "")
		}
	} else {
		doc = `<!DOCTYPE html>`
	}
	return &doctypeNode{tr: t, nodeType: nodeDoctype, pos: pos, doctype: doc}
}
func (d *doctypeNode) String() string {
	return fmt.Sprintf(text__str, d.doctype)
}
func (d *doctypeNode) WriteIn(b io.Writer) {
	fmt.Fprintf(b, text__str, d.doctype)
	// b.Write([]byte(d.doctype))
}
func (d *doctypeNode) tree() *tree {
	return d.tr
}
func (d *doctypeNode) Copy() node {
	return &doctypeNode{tr: d.tr, nodeType: nodeDoctype, pos: d.pos, doctype: d.doctype}
}
