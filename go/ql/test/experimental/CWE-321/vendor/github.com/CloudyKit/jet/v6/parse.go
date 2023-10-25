// Copyright 2016 José Santos <henrique_1609@me.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package jet

import (
	"bytes"
	"fmt"
	"runtime"
	"strconv"
	"strings"
)

func unquote(text string) (string, error) {
	return strconv.Unquote(text)
}

// Template is the representation of a single parsed template.
type Template struct {
	Name      string // name of the template represented by the tree.
	ParseName string // name of the top-level template during parsing, for error messages.

	set     *Set
	extends *Template
	imports []*Template

	processedBlocks map[string]*BlockNode
	passedBlocks    map[string]*BlockNode
	Root            *ListNode // top-level root of the tree.

	text string // text parsed to create the template (or its parent)

	// Parsing only; cleared after parse.
	lex       *lexer
	token     [3]item // three-token lookahead for parser.
	peekCount int
}

func (t *Template) String() (template string) {
	if t.extends != nil {
		if len(t.Root.Nodes) > 0 && len(t.imports) == 0 {
			template += fmt.Sprintf("{{extends %q}}", t.extends.ParseName)
		} else {
			template += fmt.Sprintf("{{extends %q}}", t.extends.ParseName)
		}
	}

	for k, _import := range t.imports {
		if t.extends == nil && k == 0 {
			template += fmt.Sprintf("{{import %q}}", _import.ParseName)
		} else {
			template += fmt.Sprintf("\n{{import %q}}", _import.ParseName)
		}
	}

	if t.extends != nil || len(t.imports) > 0 {
		if len(t.Root.Nodes) > 0 {
			template += "\n" + t.Root.String()
		}
	} else {
		template += t.Root.String()
	}
	return
}

func (t *Template) addBlocks(blocks map[string]*BlockNode) {
	if len(blocks) == 0 {
		return
	}
	if t.processedBlocks == nil {
		t.processedBlocks = make(map[string]*BlockNode)
	}
	for key, value := range blocks {
		t.processedBlocks[key] = value
	}
}

// next returns the next token.
func (t *Template) next() item {
	if t.peekCount > 0 {
		t.peekCount--
	} else {
		t.token[0] = t.lex.nextItem()
	}
	return t.token[t.peekCount]
}

// backup backs the input stream up one token.
func (t *Template) backup() {
	t.peekCount++
}

// backup2 backs the input stream up two tokens.
// The zeroth token is already there.
func (t *Template) backup2(t1 item) {
	t.token[1] = t1
	t.peekCount = 2
}

// backup3 backs the input stream up three tokens
// The zeroth token is already there.
func (t *Template) backup3(t2, t1 item) {
	// Reverse order: we're pushing back.
	t.token[1] = t1
	t.token[2] = t2
	t.peekCount = 3
}

// peek returns but does not consume the next token.
func (t *Template) peek() item {
	if t.peekCount > 0 {
		return t.token[t.peekCount-1]
	}
	t.peekCount = 1
	t.token[0] = t.lex.nextItem()
	return t.token[0]
}

// nextNonSpace returns the next non-space token.
func (t *Template) nextNonSpace() (token item) {
	for {
		token = t.next()
		if token.typ != itemSpace {
			break
		}
	}
	return token
}

// peekNonSpace returns but does not consume the next non-space token.
func (t *Template) peekNonSpace() (token item) {
	for {
		token = t.next()
		if token.typ != itemSpace {
			break
		}
	}
	t.backup()
	return token
}

// errorf formats the error and terminates processing.
func (t *Template) errorf(format string, args ...interface{}) {
	t.Root = nil
	format = fmt.Sprintf("template: %s:%d: %s", t.ParseName, t.lex.lineNumber(), format)
	panic(fmt.Errorf(format, args...))
}

// error terminates processing.
func (t *Template) error(err error) {
	t.errorf("%s", err)
}

// expect consumes the next token and guarantees it has the required type.
func (t *Template) expect(expectedType itemType, context, expected string) item {
	token := t.nextNonSpace()
	if token.typ != expectedType {
		t.unexpected(token, context, expected)
	}
	return token
}

func (t *Template) expectRightDelim(context string) item {
	return t.expect(itemRightDelim, context, "closing delimiter")
}

// expectOneOf consumes the next token and guarantees it has one of the required types.
func (t *Template) expectOneOf(expected1, expected2 itemType, context, expectedAs string) item {
	token := t.nextNonSpace()
	if token.typ != expected1 && token.typ != expected2 {
		t.unexpected(token, context, expectedAs)
	}
	return token
}

// unexpected complains about the token and terminates processing.
func (t *Template) unexpected(token item, context, expected string) {
	switch {
	case token.typ == itemImport,
		token.typ == itemExtends:
		t.errorf("parsing %s: unexpected keyword '%s' ('%s' statements must be at the beginning of the template)", context, token.val, token.val)
	case token.typ > itemKeyword:
		t.errorf("parsing %s: unexpected keyword '%s' (expected %s)", context, token.val, expected)
	default:
		t.errorf("parsing %s: unexpected token '%s' (expected %s)", context, token.val, expected)
	}
}

// recover is the handler that turns panics into returns from the top level of Parse.
func (t *Template) recover(errp *error) {
	e := recover()
	if e != nil {
		if _, ok := e.(runtime.Error); ok {
			panic(e)
		}
		if t != nil {
			t.lex.drain()
			t.stopParse()
		}
		*errp = e.(error)
	}
	return
}

func (s *Set) parse(name, text string, cacheAfterParsing bool) (t *Template, err error) {
	t = &Template{
		Name:         name,
		ParseName:    name,
		text:         text,
		set:          s,
		passedBlocks: make(map[string]*BlockNode),
	}
	defer t.recover(&err)

	lexer := lex(name, text, false)
	lexer.setDelimiters(s.leftDelim, s.rightDelim)
	lexer.run()
	t.startParse(lexer)
	t.parseTemplate(cacheAfterParsing)
	t.stopParse()

	if t.extends != nil {
		t.addBlocks(t.extends.processedBlocks)
	}

	for _, _import := range t.imports {
		t.addBlocks(_import.processedBlocks)
	}

	t.addBlocks(t.passedBlocks)

	return t, err
}

func (t *Template) expectString(context string) string {
	token := t.expectOneOf(itemString, itemRawString, context, "string literal")
	s, err := unquote(token.val)
	if err != nil {
		t.error(err)
	}
	return s
}

// parse is the top-level parser for a template, essentially the same
// It runs to EOF.
func (t *Template) parseTemplate(cacheAfterParsing bool) (next Node) {
	t.Root = t.newList(t.peek().pos)
	// {{ extends|import stringLiteral }}
	for t.peek().typ != itemEOF {
		delim := t.next()
		if delim.typ == itemText && strings.TrimSpace(delim.val) == "" {
			continue //skips empty text nodes
		}
		if delim.typ == itemLeftDelim {
			token := t.nextNonSpace()
			if token.typ == itemExtends || token.typ == itemImport {
				s := t.expectString("extends|import")
				if token.typ == itemExtends {
					if t.extends != nil {
						t.errorf("Unexpected extends clause: each template can only extend one template")
					} else if len(t.imports) > 0 {
						t.errorf("Unexpected extends clause: the 'extends' clause should come before all import clauses")
					}
					var err error
					t.extends, err = t.set.getSiblingTemplate(s, t.Name, cacheAfterParsing)
					if err != nil {
						t.error(err)
					}
				} else {
					tt, err := t.set.getSiblingTemplate(s, t.Name, cacheAfterParsing)
					if err != nil {
						t.error(err)
					}
					t.imports = append(t.imports, tt)
				}
				t.expect(itemRightDelim, "extends|import", "closing delimiter")
			} else {
				t.backup2(delim)
				break
			}
		} else {
			t.backup()
			break
		}
	}

	for t.peek().typ != itemEOF {
		switch n := t.textOrAction(); n.Type() {
		case nodeEnd, nodeElse, nodeContent:
			t.errorf("unexpected %s", n)
		default:
			t.Root.append(n)
		}
	}
	return nil
}

// startParse initializes the parser, using the lexer.
func (t *Template) startParse(lex *lexer) {
	t.Root = nil
	t.lex = lex
}

// stopParse terminates parsing.
func (t *Template) stopParse() {
	t.lex = nil
}

// IsEmptyTree reports whether this tree (node) is empty of everything but space.
func IsEmptyTree(n Node) bool {
	switch n := n.(type) {
	case nil:
		return true
	case *ActionNode:
	case *IfNode:
	case *ListNode:
		for _, node := range n.Nodes {
			if !IsEmptyTree(node) {
				return false
			}
		}
		return true
	case *RangeNode:
	case *IncludeNode:
	case *TextNode:
		return len(bytes.TrimSpace(n.Text)) == 0
	case *BlockNode:
	case *YieldNode:
	default:
		panic("unknown node: " + n.String())
	}
	return false
}

func (t *Template) blockParametersList(isDeclaring bool, context string) *BlockParameterList {
	block := &BlockParameterList{}

	t.expect(itemLeftParen, context, "opening parenthesis")
	for {
		var expression Expression
		next := t.nextNonSpace()
		if next.typ == itemIdentifier {
			identifier := next.val
			next2 := t.nextNonSpace()
			switch next2.typ {
			case itemComma, itemRightParen:
				block.List = append(block.List, BlockParameter{Identifier: identifier})
				next = next2
			case itemAssign:
				expression, next = t.parseExpression(context)
				block.List = append(block.List, BlockParameter{Identifier: identifier, Expression: expression})
			default:
				if !isDeclaring {
					switch next2.typ {
					case itemComma, itemRightParen:
					default:
						t.backup2(next)
						expression, next = t.parseExpression(context)
						block.List = append(block.List, BlockParameter{Expression: expression})
					}
				} else {
					t.unexpected(next2, context, "comma, assignment, or closing parenthesis")
				}
			}
		} else if !isDeclaring {
			switch next.typ {
			case itemComma, itemRightParen:
			default:
				t.backup()
				expression, next = t.parseExpression(context)
				block.List = append(block.List, BlockParameter{Expression: expression})
			}
		}

		if next.typ != itemComma {
			t.backup()
			break
		}
	}
	t.expect(itemRightParen, context, "closing parenthesis")
	return block
}

func (t *Template) parseBlock() Node {
	const context = "block clause"
	var pipe Expression

	name := t.expect(itemIdentifier, context, "name")
	bplist := t.blockParametersList(true, context)

	if t.peekNonSpace().typ != itemRightDelim {
		pipe = t.expression(context, "context")
	}

	t.expectRightDelim(context)

	list, end := t.itemList(nodeContent, nodeEnd)
	var contentList *ListNode

	if end.Type() == nodeContent {
		contentList, end = t.itemList(nodeEnd)
	}

	block := t.newBlock(name.pos, t.lex.lineNumber(), name.val, bplist, pipe, list, contentList)
	t.passedBlocks[block.Name] = block
	return block
}

func (t *Template) parseYield() Node {
	const context = "yield clause"

	var (
		pipe    Expression
		name    item
		bplist  *BlockParameterList
		content *ListNode
	)

	// parse block name
	name = t.nextNonSpace()
	if name.typ == itemContent {
		// content yield {{yield content}}
		if t.peekNonSpace().typ != itemRightDelim {
			pipe = t.expression(context, "content context")
		}
		t.expectRightDelim(context)
		return t.newYield(name.pos, t.lex.lineNumber(), "", nil, pipe, nil, true)
	} else if name.typ != itemIdentifier {
		t.unexpected(name, context, "block name")
	}

	// parse block parameters
	bplist = t.blockParametersList(false, context)

	// parse optional context & content
	typ := t.peekNonSpace().typ
	if typ == itemRightDelim {
		t.expectRightDelim(context)
	} else {
		if typ != itemContent {
			// parse context expression
			pipe = t.expression("yield", "context")
			typ = t.peekNonSpace().typ
		}
		if typ == itemRightDelim {
			t.expectRightDelim(context)
		} else if typ == itemContent {
			// parse content from following nodes (until {{end}})
			t.nextNonSpace()
			t.expectRightDelim(context)
			content, _ = t.itemList(nodeEnd)
		} else {
			t.unexpected(t.nextNonSpace(), context, "content keyword or closing delimiter")
		}
	}

	return t.newYield(name.pos, t.lex.lineNumber(), name.val, bplist, pipe, content, false)
}

func (t *Template) parseInclude() Node {
	var context Expression
	name := t.expression("include", "template name")
	if t.peekNonSpace().typ != itemRightDelim {
		context = t.expression("include", "context")
	}
	t.expectRightDelim("include invocation")
	return t.newInclude(name.Position(), t.lex.lineNumber(), name, context)
}

func (t *Template) parseReturn() Node {
	value := t.expression("return", "value")
	t.expectRightDelim("return")
	return t.newReturn(value.Position(), t.lex.lineNumber(), value)
}

// itemList:
//	textOrAction*
// Terminates at any of the given nodes, returned separately.
func (t *Template) itemList(terminatedBy ...NodeType) (list *ListNode, next Node) {
	list = t.newList(t.peekNonSpace().pos)
	for t.peekNonSpace().typ != itemEOF {
		n := t.textOrAction()
		for _, terminatorType := range terminatedBy {
			if n.Type() == terminatorType {
				return list, n
			}
		}
		list.append(n)
	}
	t.errorf("unexpected EOF")
	return
}

// textOrAction:
//	text | action
func (t *Template) textOrAction() Node {
	switch token := t.nextNonSpace(); token.typ {
	case itemText:
		return t.newText(token.pos, token.val)
	case itemLeftDelim:
		return t.action()
	default:
		t.unexpected(token, "input", "text or action")
	}
	return nil
}

func (t *Template) action() (n Node) {
	switch token := t.nextNonSpace(); token.typ {
	case itemInclude:
		return t.parseInclude()
	case itemBlock:
		return t.parseBlock()
	case itemEnd:
		return t.endControl()
	case itemYield:
		return t.parseYield()
	case itemContent:
		return t.contentControl()
	case itemIf:
		return t.ifControl()
	case itemElse:
		return t.elseControl()
	case itemRange:
		return t.rangeControl()
	case itemTry:
		return t.parseTry()
	case itemCatch:
		return t.parseCatch()
	case itemReturn:
		return t.parseReturn()
	}

	t.backup()
	action := t.newAction(t.peek().pos, t.lex.lineNumber())

	expr := t.assignmentOrExpression("command")
	if expr.Type() == NodeSet {
		action.Set = expr.(*SetNode)
		expr = nil
		if t.expectOneOf(itemSemicolon, itemRightDelim, "command", "semicolon or right delimiter").typ == itemSemicolon {
			expr = t.expression("command", "pipeline base expression")
		}
	}
	if expr != nil {
		action.Pipe = t.pipeline("command", expr)
	}
	return action
}

func (t *Template) logicalExpression(context string) (Expression, item) {
	left, endtoken := t.comparativeExpression(context)
	for endtoken.typ == itemAnd || endtoken.typ == itemOr {
		right, rightendtoken := t.comparativeExpression(context)
		left, endtoken = t.newLogicalExpr(left.Position(), t.lex.lineNumber(), left, right, endtoken), rightendtoken
	}
	return left, endtoken
}

func (t *Template) parseExpression(context string) (Expression, item) {
	expression, endtoken := t.logicalExpression(context)
	if endtoken.typ == itemTernary {
		var left, right Expression
		left, endtoken = t.parseExpression(context)
		if endtoken.typ != itemColon {
			t.unexpected(endtoken, "ternary expression", "colon in ternary expression")
		}
		right, endtoken = t.parseExpression(context)
		expression = t.newTernaryExpr(expression.Position(), t.lex.lineNumber(), expression, left, right)
	}
	return expression, endtoken
}

func (t *Template) comparativeExpression(context string) (Expression, item) {
	left, endtoken := t.numericComparativeExpression(context)
	for endtoken.typ == itemEquals || endtoken.typ == itemNotEquals {
		right, rightendtoken := t.numericComparativeExpression(context)
		left, endtoken = t.newComparativeExpr(left.Position(), t.lex.lineNumber(), left, right, endtoken), rightendtoken
	}
	return left, endtoken
}

func (t *Template) numericComparativeExpression(context string) (Expression, item) {
	left, endtoken := t.additiveExpression(context)
	for endtoken.typ >= itemGreat && endtoken.typ <= itemLessEquals {
		right, rightendtoken := t.additiveExpression(context)
		left, endtoken = t.newNumericComparativeExpr(left.Position(), t.lex.lineNumber(), left, right, endtoken), rightendtoken
	}
	return left, endtoken
}

func (t *Template) additiveExpression(context string) (Expression, item) {
	left, endtoken := t.multiplicativeExpression(context)
	for endtoken.typ == itemAdd || endtoken.typ == itemMinus {
		right, rightendtoken := t.multiplicativeExpression(context)
		left, endtoken = t.newAdditiveExpr(left.Position(), t.lex.lineNumber(), left, right, endtoken), rightendtoken
	}
	return left, endtoken
}

func (t *Template) multiplicativeExpression(context string) (left Expression, endtoken item) {
	left, endtoken = t.unaryExpression(context)
	for endtoken.typ >= itemMul && endtoken.typ <= itemMod {
		right, rightendtoken := t.unaryExpression(context)
		left, endtoken = t.newMultiplicativeExpr(left.Position(), t.lex.lineNumber(), left, right, endtoken), rightendtoken
	}

	return left, endtoken
}

func (t *Template) unaryExpression(context string) (Expression, item) {
	next := t.nextNonSpace()
	switch next.typ {
	case itemNot:
		expr, endToken := t.comparativeExpression(context)
		return t.newNotExpr(expr.Position(), t.lex.lineNumber(), expr), endToken
	case itemMinus, itemAdd:
		return t.newAdditiveExpr(next.pos, t.lex.lineNumber(), nil, t.operand("additive expression"), next), t.nextNonSpace()
	default:
		t.backup()
	}
	operand := t.operand(context)
	return operand, t.nextNonSpace()
}

func (t *Template) assignmentOrExpression(context string) (operand Expression) {
	t.peekNonSpace()
	line := t.lex.lineNumber()
	var right, left []Expression

	var isSet bool
	var isLet bool
	var returned item
	operand, returned = t.parseExpression(context)
	pos := operand.Position()
	if returned.typ == itemComma || returned.typ == itemAssign {
		isSet = true
	} else {
		if operand == nil {
			t.unexpected(returned, context, "operand")
		}
		t.backup()
		return operand
	}

	if isSet {
	leftloop:
		for {
			switch operand.Type() {
			case NodeField, NodeChain, NodeIdentifier, NodeUnderscore:
				left = append(left, operand)
			default:
				t.errorf("unexpected node in assign")
			}

			switch returned.typ {
			case itemComma:
				operand, returned = t.parseExpression(context)
			case itemAssign:
				isLet = returned.val == ":="
				break leftloop
			default:
				t.unexpected(returned, "assignment", "comma or assignment")
			}
		}

		if isLet {
			for _, operand := range left {
				if operand.Type() != NodeIdentifier && operand.Type() != NodeUnderscore {
					t.errorf("unexpected node type %s in variable declaration", operand)
				}
			}
		}

		for {
			operand, returned = t.parseExpression("assignment")
			right = append(right, operand)
			if returned.typ != itemComma {
				t.backup()
				break
			}
		}

		var isIndexExprGetLookup bool

		if context == "range" {
			if len(left) > 2 || len(right) > 1 {
				t.errorf("unexpected number of operands in assign on range")
			}
		} else {
			if len(left) != len(right) {
				if len(left) == 2 && len(right) == 1 && right[0].Type() == NodeIndexExpr {
					isIndexExprGetLookup = true
				} else {
					t.errorf("unexpected number of operands in assign on range")
				}
			}
		}
		operand = t.newSet(pos, line, isLet, isIndexExprGetLookup, left, right)
		return

	}
	return
}

func (t *Template) expression(context, as string) Expression {
	expr, tk := t.parseExpression(context)
	if expr == nil {
		t.unexpected(tk, context, as)
	}
	t.backup()
	return expr
}

func (t *Template) pipeline(context string, baseExprMutate Expression) (pipe *PipeNode) {
	pos := t.peekNonSpace().pos
	pipe = t.newPipeline(pos, t.lex.lineNumber())

	if baseExprMutate == nil {
		pipe.errorf("parsing pipeline: first expression cannot be nil")
	}
	pipe.append(t.command(baseExprMutate))

	for {
		token := t.expectOneOf(itemPipe, itemRightDelim, "pipeline", "pipe or right delimiter")
		if token.typ == itemRightDelim {
			break
		}
		token = t.nextNonSpace()
		switch token.typ {
		case itemField, itemIdentifier:
			t.backup()
			pipe.append(t.command(nil))
		default:
			t.unexpected(token, "pipeline", "field or identifier")
		}
	}

	return
}

func (t *Template) command(baseExpr Expression) *CommandNode {
	cmd := t.newCommand(t.peekNonSpace().pos)

	if baseExpr == nil {
		baseExpr = t.expression("command", "name")
	}

	if baseExpr.Type() == NodeCallExpr {
		call := baseExpr.(*CallExprNode)
		cmd.CallExprNode = *call
		return cmd
	}

	cmd.BaseExpr = baseExpr

	next := t.nextNonSpace()
	switch next.typ {
	case itemColon:
		cmd.CallArgs = t.parseArguments()
	default:
		t.backup()
	}

	if cmd.BaseExpr == nil {
		t.errorf("empty command")
	}

	return cmd
}

// operand:
//	term .Field*
// An operand is a space-separated component of a command,
// a term possibly followed by field accesses.
// A nil return means the next item is not an operand.
func (t *Template) operand(context string) Expression {
	node := t.term()
	if node == nil {
		t.unexpected(t.next(), context, "term")
	}
RESET:
	if t.peek().typ == itemField {
		chain := t.newChain(t.peek().pos, node)
		for t.peekNonSpace().typ == itemField {
			chain.Add(t.next().val)
		}
		// Compatibility with original API: If the term is of type NodeField
		// or NodeVariable, just put more fields on the original.
		// Otherwise, keep the Chain node.
		// Obvious parsing errors involving literal values are detected here.
		// More complex error cases will have to be handled at execution time.
		switch node.Type() {
		case NodeField:
			node = t.newField(chain.Position(), chain.String())
		case NodeBool, NodeString, NodeNumber, NodeNil:
			t.errorf("unexpected . after term %q", node.String())
		default:
			node = chain
		}
	}
	nodeTYPE := node.Type()
	if nodeTYPE == NodeIdentifier ||
		nodeTYPE == NodeCallExpr ||
		nodeTYPE == NodeField ||
		nodeTYPE == NodeChain ||
		nodeTYPE == NodeIndexExpr {
		switch t.nextNonSpace().typ {
		case itemLeftParen:
			callExpr := t.newCallExpr(node.Position(), t.lex.lineNumber(), node)
			callExpr.CallArgs = t.parseArguments()
			t.expect(itemRightParen, "call expression", "closing parenthesis")
			node = callExpr
			goto RESET
		case itemLeftBrackets:
			base := node
			var index Expression
			var next item

			//found colon is slice expression
			if t.peekNonSpace().typ != itemColon {
				index, next = t.parseExpression("index|slice expression")
			} else {
				next = t.nextNonSpace()
			}

			switch next.typ {
			case itemColon:
				var endIndex Expression
				if t.peekNonSpace().typ != itemRightBrackets {
					endIndex = t.expression("slice expression", "end indexß")
				}
				node = t.newSliceExpr(node.Position(), node.line(), base, index, endIndex)
			case itemRightBrackets:
				node = t.newIndexExpr(node.Position(), node.line(), base, index)
				fallthrough
			default:
				t.backup()
			}

			t.expect(itemRightBrackets, "index expression", "closing bracket")
			goto RESET
		default:
			t.backup()
		}
	}
	return node
}

func (t *Template) parseArguments() (args CallArgs) {
	context := "call expression argument list"
	args.Exprs = []Expression{}
loop:
	for {
		peek := t.peekNonSpace()
		if peek.typ == itemRightParen {
			break
		}
		var (
			expr     Expression
			endtoken item
		)
		expr, endtoken = t.parseExpression(context)
		if expr.Type() == NodeUnderscore {
			// slot for piped argument
			if args.HasPipeSlot {
				t.errorf("found two pipe slot markers ('_') for the same function call")
			}
			args.HasPipeSlot = true
		}
		args.Exprs = append(args.Exprs, expr)
		switch endtoken.typ {
		case itemComma:
			// continue with closing parens (allowed because of multiline syntax) or next arg
		default:
			t.backup()
			break loop
		}
	}
	return
}

func (t *Template) parseControl(allowElseIf bool, context string) (pos Pos, line int, set *SetNode, expression Expression, list, elseList *ListNode) {
	line = t.lex.lineNumber()

	expression = t.assignmentOrExpression(context)
	pos = expression.Position()
	if expression.Type() == NodeSet {
		set = expression.(*SetNode)
		if context != "range" {
			t.expect(itemSemicolon, context, "semicolon between assignment and expression")
			expression = t.expression(context, "expression after assignment")
		} else {
			expression = nil
		}
	}

	t.expectRightDelim(context)
	var next Node
	list, next = t.itemList(nodeElse, nodeEnd)
	if next.Type() == nodeElse {
		if allowElseIf && t.peek().typ == itemIf {
			// Special case for "else if". If the "else" is followed immediately by an "if",
			// the elseControl will have left the "if" token pending. Treat
			//	{{if a}}_{{else if b}}_{{end}}
			// as
			//	{{if a}}_{{else}}{{if b}}_{{end}}{{end}}.
			// To do this, parse the if as usual and stop at it {{end}}; the subsequent{{end}}
			// is assumed. This technique works even for long if-else-if chains.
			t.next() // Consume the "if" token.
			elseList = t.newList(next.Position())
			elseList.append(t.ifControl())
			// Do not consume the next item - only one {{end}} required.
		} else {
			elseList, next = t.itemList(nodeEnd)
		}
	}
	return pos, line, set, expression, list, elseList
}

// If:
//	{{if expression}} itemList {{end}}
//	{{if expression}} itemList {{else}} itemList {{end}}
// If keyword is past.
func (t *Template) ifControl() Node {
	return t.newIf(t.parseControl(true, "if"))
}

// Range:
//	{{range expression}} itemList {{end}}
//	{{range expression}} itemList {{else}} itemList {{end}}
// Range keyword is past.
func (t *Template) rangeControl() Node {
	return t.newRange(t.parseControl(false, "range"))
}

// End:
//	{{end}}
// End keyword is past.
func (t *Template) endControl() Node {
	return t.newEnd(t.expectRightDelim("end").pos)
}

// Content:
//	{{content}}
// Content keyword is past.
func (t *Template) contentControl() Node {
	return t.newContent(t.expectRightDelim("content").pos)
}

// Else:
//	{{else}}
// Else keyword is past.
func (t *Template) elseControl() Node {
	// Special case for "else if".
	peek := t.peekNonSpace()
	if peek.typ == itemIf {
		// We see "{{else if ... " but in effect rewrite it to {{else}}{{if ... ".
		return t.newElse(peek.pos, t.lex.lineNumber())
	}
	return t.newElse(t.expectRightDelim("else").pos, t.lex.lineNumber())
}

// Try-catch:
//	{{try}}
//    itemList
//  {{catch <ident>}}
//    itemList
//  {{end}}
// try keyword is past.
func (t *Template) parseTry() *TryNode {
	var recov *catchNode
	line := t.lex.lineNumber()
	pos := t.expectRightDelim("try").pos
	list, next := t.itemList(nodeCatch, nodeEnd)
	if next.Type() == nodeCatch {
		recov = next.(*catchNode)
	}

	return t.newTry(pos, line, list, recov)
}

// catch:
//  {{catch <ident>}}
//    itemList
//  {{end}}
// catch keyword is past.
func (t *Template) parseCatch() *catchNode {
	line := t.lex.lineNumber()
	var errVar *IdentifierNode
	peek := t.peekNonSpace()
	if peek.typ != itemRightDelim {
		_errVar := t.term()
		if typ := _errVar.Type(); typ != NodeIdentifier {
			t.errorf("unexpected node type '%s' in catch", typ)
		}
		errVar = _errVar.(*IdentifierNode)
	}
	t.expectRightDelim("catch")
	list, _ := t.itemList(nodeEnd)
	return t.newCatch(peek.pos, line, errVar, list)
}

// term:
//	literal (number, string, nil, boolean)
//	function (identifier)
//	.
//	.Field
//	variable
//	'(' expression ')'
// A term is a simple "expression".
// A nil return means the next item is not a term.
func (t *Template) term() Node {
	switch token := t.nextNonSpace(); token.typ {
	case itemError:
		t.errorf("%s", token.val)
	case itemIdentifier:
		return t.newIdentifier(token.val, token.pos, t.lex.lineNumber())
	case itemUnderscore:
		return t.newUnderscore(token.pos, t.lex.lineNumber())
	case itemNil:
		return t.newNil(token.pos)
	case itemField:
		return t.newField(token.pos, token.val)
	case itemBool:
		return t.newBool(token.pos, token.val == "true")
	case itemCharConstant, itemComplex, itemNumber:
		number, err := t.newNumber(token.pos, token.val, token.typ)
		if err != nil {
			t.error(err)
		}
		return number
	case itemLeftParen:
		pipe := t.expression("parenthesized expression", "expression")
		if token := t.next(); token.typ != itemRightParen {
			t.unexpected(token, "parenthesized expression", "closing parenthesis")
		}
		return pipe
	case itemString, itemRawString:
		s, err := unquote(token.val)
		if err != nil {
			t.error(err)
		}
		return t.newString(token.pos, token.val, s)
	}
	t.backup()
	return nil
}
