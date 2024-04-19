package jade

import (
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func (t *tree) topParse() {
	t.Root = t.newList(t.peek().pos)
	var (
		ext   bool
		token = t.nextNonSpace()
	)
	if token.typ == itemExtends {
		ext = true
		t.Root.append(t.parseSubFile(token.val))
		token = t.nextNonSpace()
	}
	for {
		switch token.typ {
		case itemInclude:
			t.Root.append(t.parseInclude(token))
		case itemBlock, itemBlockPrepend, itemBlockAppend:
			if ext {
				t.parseBlock(token)
			} else {
				t.Root.append(t.parseBlock(token))
			}
		case itemMixin:
			t.mixin[token.val] = t.parseMixin(token)
		case itemEOF:
			return
		case itemExtends:
			t.errorf(`Declaration of template inheritance ("extends") should be the first thing in the file. There can only be one extends statement per file.`)
		case itemError:
			t.errorf("%s line: %d\n", token.val, token.line)
		default:
			if ext {
				t.errorf(`Only import, named blocks and mixins can appear at the top level of an extending template`)
			}
			t.Root.append(t.hub(token))
		}
		token = t.nextNonSpace()
	}
}

func (t *tree) hub(token item) (n node) {
	for {
		switch token.typ {
		case itemDiv:
			token.val = "div"
			fallthrough
		case itemTag, itemTagInline, itemTagVoid, itemTagVoidInline:
			return t.parseTag(token)
		case itemText, itemComment, itemHTMLTag:
			return t.newText(token.pos, []byte(token.val), token.typ)
		case itemCode, itemCodeBuffered, itemCodeUnescaped, itemMixinBlock:
			return t.newCode(token.pos, token.val, token.typ)
		case itemIf, itemUnless:
			return t.parseIf(token)
		case itemFor, itemEach, itemWhile:
			return t.parseFor(token)
		case itemCase:
			return t.parseCase(token)
		case itemBlock, itemBlockPrepend, itemBlockAppend:
			return t.parseBlock(token)
		case itemMixinCall:
			return t.parseMixinUse(token)
		case itemInclude:
			return t.parseInclude(token)
		case itemDoctype:
			return t.newDoctype(token.pos, token.val)
		case itemFilter:
			return t.parseFilter(token)
		case itemError:
			t.errorf("Error lex: %s line: %d\n", token.val, token.line)
		default:
			t.errorf(`Error hub(): unexpected token  "%s"  type  "%s"`, token.val, token.typ)
		}
	}
}

func (t *tree) parseFilter(tk item) node {
	var subf, args, text string
Loop:
	for {
		switch token := t.nextNonSpace(); token.typ {
		case itemFilterSubf:
			subf = token.val
		case itemFilterArgs:
			args = strings.Trim(token.val, " \t\r\n")
		case itemFilterText:
			text = strings.Trim(token.val, " \t\r\n")
		default:
			break Loop
		}
	}
	t.backup()
	switch tk.val {
	case "go":
		filterGo(subf, args, text)
	case "markdown", "markdown-it":
		// TODO: filterMarkdown(subf, args, text)
	}
	return t.newList(tk.pos) // for return nothing
}

func filterGo(subf, args, text string) {
	switch subf {
	case "func":
		goFlt.Name = ""
		switch args {
		case "name":
			goFlt.Name = text
		case "arg", "args":
			if goFlt.Args != "" {
				goFlt.Args += ", " + strings.Trim(text, "()")
			} else {
				goFlt.Args = strings.Trim(text, "()")
			}
		default:
			fn := strings.Split(text, "(")
			if len(fn) == 2 {
				goFlt.Name = strings.Trim(fn[0], " \t\n)")
				goFlt.Args = strings.Trim(fn[1], " \t\n)")
			} else {
				log.Fatal(":go:func filter error in " + text)
			}
		}
	case "import":
		goFlt.Import = text
	}
}

func (t *tree) parseTag(tk item) node {
	var (
		deep = tk.depth
		tag  = t.newTag(tk.pos, tk.val, tk.typ)
	)
Loop:
	for {
		switch token := t.nextNonSpace(); {
		case token.depth > deep:
			if tag.tagType == itemTagVoid || tag.tagType == itemTagVoidInline {
				break Loop
			}
			tag.append(t.hub(token))
		case token.depth == deep:
			switch token.typ {
			case itemClass:
				tag.attr("class", `"`+token.val+`"`, false)
			case itemID:
				tag.attr("id", `"`+token.val+`"`, false)
			case itemAttrStart:
				t.parseAttributes(tag, `"`)
			case itemTagEnd:
				tag.tagType = itemTagVoid
				return tag
			default:
				break Loop
			}
		default:
			break Loop
		}
	}
	t.backup()
	return tag
}

type pAttr interface {
	attr(string, string, bool)
}

func (t *tree) parseAttributes(tag pAttr, qw string) {
	var (
		aname string
		equal bool
		unesc bool
		stack = make([]string, 0, 4)
	)
	for {
		switch token := t.next(); token.typ {
		case itemAttrSpace:
			// skip
		case itemAttr:
			switch {
			case aname == "":
				aname = token.val
			case aname != "" && !equal:
				tag.attr(aname, qw+aname+qw, unesc)
				aname = token.val
			case aname != "" && equal:
				stack = append(stack, token.val)
			}
		case itemAttrEqual, itemAttrEqualUn:
			if token.typ == itemAttrEqual {
				unesc = false
			} else {
				unesc = true
			}
			equal = true
			switch len_stack := len(stack); {
			case len_stack == 0 && aname != "":
				// skip
			case len_stack > 1 && aname != "":
				tag.attr(aname, strings.Join(stack[:len(stack)-1], " "), unesc)

				aname = stack[len(stack)-1]
				stack = stack[:0]
			case len_stack == 1 && aname == "":
				aname = stack[0]
				stack = stack[:0]
			default:
				t.errorf("unexpected '='")
			}
		case itemAttrComma:
			equal = false
			switch len_stack := len(stack); {
			case len_stack > 0 && aname != "":
				tag.attr(aname, strings.Join(stack, " "), unesc)
				aname = ""
				stack = stack[:0]
			case len_stack == 0 && aname != "":
				tag.attr(aname, qw+aname+qw, unesc)
				aname = ""
			}
		case itemAttrEnd:
			switch len_stack := len(stack); {
			case len_stack > 0 && aname != "":
				tag.attr(aname, strings.Join(stack, " "), unesc)
			case len_stack > 0 && aname == "":
				for _, a := range stack {
					tag.attr(a, a, unesc)
				}
			case len_stack == 0 && aname != "":
				tag.attr(aname, qw+aname+qw, unesc)
			}
			return
		default:
			t.errorf("unexpected %s", token.val)
		}
	}
}

func (t *tree) parseIf(tk item) node {
	var (
		deep = tk.depth
		cond = t.newCond(tk.pos, tk.val, tk.typ)
	)
Loop:
	for {
		switch token := t.nextNonSpace(); {
		case token.depth > deep:
			cond.append(t.hub(token))
		case token.depth == deep:
			switch token.typ {
			case itemElse:
				ni := t.peek()
				if ni.typ == itemIf {
					token = t.next()
					cond.append(t.newCode(token.pos, token.val, itemElseIf))
				} else {
					cond.append(t.newCode(token.pos, token.val, token.typ))
				}
			default:
				break Loop
			}
		default:
			break Loop
		}
	}
	t.backup()
	return cond
}

func (t *tree) parseFor(tk item) node {
	var (
		deep = tk.depth
		cond = t.newCond(tk.pos, tk.val, tk.typ)
	)
Loop:
	for {
		switch token := t.nextNonSpace(); {
		case token.depth > deep:
			cond.append(t.hub(token))
		case token.depth == deep:
			if token.typ == itemElse {
				cond.condType = itemForIfNotContain
				cond.append(t.newCode(token.pos, token.val, itemForElse))
			} else {
				break Loop
			}
		default:
			break Loop
		}
	}
	t.backup()
	return cond
}

func (t *tree) parseCase(tk item) node {
	var (
		deep  = tk.depth
		iCase = t.newCond(tk.pos, tk.val, tk.typ)
	)
	for {
		if token := t.nextNonSpace(); token.depth > deep {
			switch token.typ {
			case itemCaseWhen, itemCaseDefault:
				iCase.append(t.newCode(token.pos, token.val, token.typ))
			default:
				iCase.append(t.hub(token))
			}
		} else {
			break
		}
	}
	t.backup()
	return iCase
}

func (t *tree) parseMixin(tk item) *mixinNode {
	var (
		deep  = tk.depth
		mixin = t.newMixin(tk.pos)
	)
Loop:
	for {
		switch token := t.nextNonSpace(); {
		case token.depth > deep:
			mixin.append(t.hub(token))
		case token.depth == deep:
			if token.typ == itemAttrStart {
				t.parseAttributes(mixin, "")
			} else {
				break Loop
			}
		default:
			break Loop
		}
	}
	t.backup()
	return mixin
}

func (t *tree) parseMixinUse(tk item) node {
	tMix, ok := t.mixin[tk.val]
	if !ok {
		t.errorf(`Mixin "%s" must be declared before use.`, tk.val)
	}
	var (
		deep  = tk.depth
		mixin = tMix.CopyMixin()
	)
Loop:
	for {
		switch token := t.nextNonSpace(); {
		case token.depth > deep:
			mixin.appendToBlock(t.hub(token))
		case token.depth == deep:
			if token.typ == itemAttrStart {
				t.parseAttributes(mixin, "")
			} else {
				break Loop
			}
		default:
			break Loop
		}
	}
	t.backup()

	use := len(mixin.AttrName)
	tpl := len(tMix.AttrName)
	switch {
	case use < tpl:
		i := 0
		diff := tpl - use
		mixin.AttrCode = append(mixin.AttrCode, make([]string, diff)...) // Extend slice
		for index := 0; index < diff; index++ {
			i = tpl - index - 1
			if tMix.AttrName[i] != tMix.AttrCode[i] {
				mixin.AttrCode[i] = tMix.AttrCode[i]
			} else {
				mixin.AttrCode[i] = `""`
			}
		}
		mixin.AttrName = tMix.AttrName
	case use > tpl:
		if tpl <= 0 {
			break
		}
		if strings.HasPrefix(tMix.AttrName[tpl-1], "...") {
			mixin.AttrRest = mixin.AttrCode[tpl-1:]
		}
		mixin.AttrCode = mixin.AttrCode[:tpl]
		mixin.AttrName = tMix.AttrName
	case use == tpl:
		mixin.AttrName = tMix.AttrName
	}
	return mixin
}

func (t *tree) parseBlock(tk item) *blockNode {
	block := t.newList(tk.pos)
	for {
		token := t.nextNonSpace()
		if token.depth > tk.depth {
			block.append(t.hub(token))
		} else {
			break
		}
	}
	t.backup()
	var suf string
	switch tk.typ {
	case itemBlockPrepend:
		suf = "_prepend"
	case itemBlockAppend:
		suf = "_append"
	}
	t.block[tk.val+suf] = block
	return t.newBlock(tk.pos, tk.val, tk.typ)
}

func (t *tree) parseInclude(tk item) *listNode {
	switch ext := filepath.Ext(tk.val); ext {
	case ".jade", ".pug", "":
		return t.parseSubFile(tk.val)
	case ".js", ".css", ".tpl", ".md":
		ln := t.newList(tk.pos)
		ln.append(t.newText(tk.pos, t.read(tk.val), itemText))
		return ln
	default:
		t.errorf(`file extension  "%s"  is not supported`, ext)
		return nil
	}
}

func (t *tree) parseSubFile(path string) *listNode {
	var incTree = New(t.resolvePath(path))

	incTree.block = t.block
	incTree.mixin = t.mixin
	incTree.fs = t.fs

	_, err := incTree.Parse(t.read(path))
	if err != nil {
		d, _ := os.Getwd()
		t.errorf(`in '%s' subtemplate '%s': parseSubFile() error: %s`, d, path, err)
	}

	return incTree.Root
}

func (t *tree) read(path string) []byte {
	path = t.resolvePath(path)
	bb, err := readFile(path, t.fs)

	if os.IsNotExist(err) {

		if ext := filepath.Ext(path); ext == "" {
			if _, er := os.Stat(path + ".jade"); os.IsNotExist(er) {
				if _, er = os.Stat(path + ".pug"); os.IsNotExist(er) {
					wd, _ := os.Getwd()
					t.errorf("in '%s' subtemplate '%s': file path error: '.jade' or '.pug' file required", wd, path)
				} else {
					ext = ".pug"
				}
			} else {
				ext = ".jade"
			}
			bb, err = readFile(path+ext, t.fs)
		}
	}
	if err != nil {
		wd, _ := os.Getwd()
		t.errorf(`%s  work dir: %s `, err, wd)
	}
	return bb
}

func (t *tree) resolvePath(path string) string {
	currentTmplDir, _ := filepath.Split(t.Name)
	path = filepath.Join(currentTmplDir, path)
	return filepath.ToSlash(path)
}

func readFile(fname string, fs http.FileSystem) ([]byte, error) {
	if fs == nil {
		return ReadFunc(fname)
	}

	file, err := fs.Open(fname)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	return ioutil.ReadAll(file)
}
