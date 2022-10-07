// Copyright 2017 Santhosh Kumar Tekuri. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package xpathparser

import (
	"fmt"
	"strconv"
	"strings"
)

type parser struct {
	lexer  lexer
	tokens []token
}

func (p *parser) error(format string, args ...interface{}) error {
	return &Error{fmt.Sprintf(format, args...), p.lexer.xpath, p.token(0).begin}
}

func (p *parser) unexpectedToken() error {
	return p.error("unexpected token %s", p.token(0).kind)
}

func (p *parser) expectedTokens(expected ...kind) error {
	tokens := make([]string, len(expected))
	for i, k := range expected {
		tokens[i] = k.String()
	}
	return p.error("expected %s, but got %v", strings.Join(tokens, " or "), p.token(0).kind)
}

func (p *parser) token(i int) token {
	for i > len(p.tokens)-1 {
		t, err := p.lexer.next()
		if err != nil {
			panic(err)
		}
		p.tokens = append(p.tokens, t)
	}
	return p.tokens[i]
}

func (p *parser) match(k kind) token {
	t := p.token(0)
	if t.kind != k {
		panic(p.error("expected %v, but got %v", k, t.kind))
	}
	p.tokens = p.tokens[1:]
	return t
}

func (p *parser) parse() Expr {
	expr := p.orExpr()
	p.match(eof)
	return expr
}

func (p *parser) orExpr() Expr {
	expr := p.andExpr()
	if p.token(0).kind == or {
		p.match(or)
		return &BinaryExpr{expr, Or, p.orExpr()}
	}
	return expr
}

func (p *parser) andExpr() Expr {
	expr := p.equalityExpr()
	if p.token(0).kind == and {
		p.match(and)
		return &BinaryExpr{expr, And, p.andExpr()}
	}
	return expr
}

func (p *parser) equalityExpr() Expr {
	expr := p.relationalExpr()
	for {
		switch kind := p.token(0).kind; kind {
		case eq, neq:
			p.match(kind)
			expr = &BinaryExpr{expr, Op(kind), p.relationalExpr()}
		default:
			return expr
		}
	}
}

func (p *parser) relationalExpr() Expr {
	expr := p.additiveExpr()
	for {
		switch kind := p.token(0).kind; kind {
		case lt, lte, gt, gte:
			p.match(kind)
			expr = &BinaryExpr{expr, Op(kind), p.additiveExpr()}
		default:
			return expr
		}
	}
}

func (p *parser) additiveExpr() Expr {
	expr := p.multiplicativeExpr()
	for {
		switch kind := p.token(0).kind; kind {
		case plus, minus:
			p.match(kind)
			expr = &BinaryExpr{expr, Op(kind), p.multiplicativeExpr()}
		default:
			return expr
		}
	}
}

func (p *parser) multiplicativeExpr() Expr {
	expr := p.unaryExpr()
	for {
		switch kind := p.token(0).kind; kind {
		case multiply, div, mod:
			p.match(kind)
			expr = &BinaryExpr{expr, Op(kind), p.unaryExpr()}
		default:
			return expr
		}
	}
}

func (p *parser) unaryExpr() Expr {
	if p.token(0).kind == minus {
		p.match(minus)
		return &NegateExpr{p.unionExpr()}
	}
	return p.unionExpr()
}

func (p *parser) unionExpr() Expr {
	expr := p.pathExpr()
	if p.token(0).kind == pipe {
		p.match(pipe)
		return &BinaryExpr{expr, Union, p.orExpr()}
	}
	return expr
}

func (p *parser) pathExpr() Expr {
	switch p.token(0).kind {
	case number, literal:
		filter := p.filterExpr()
		switch p.token(0).kind {
		case slash, slashSlash:
			panic(p.error("nodeset expected"))
		}
		return filter
	case lparen, dollar:
		filter := p.filterExpr()
		switch p.token(0).kind {
		case slash, slashSlash:
			return &PathExpr{filter, p.locationPath(false)}
		}
		return filter
	case identifier:
		if (p.token(1).kind == lparen && !isNodeTypeName(p.token(0))) || (p.token(1).kind == colon && p.token(3).kind == lparen) {
			filter := p.filterExpr()
			switch p.token(0).kind {
			case slash, slashSlash:
				return &PathExpr{filter, p.locationPath(false)}
			}
			return filter
		}
		return p.locationPath(false)
	case dot, dotDot, star, at:
		return p.locationPath(false)
	case slash, slashSlash:
		return p.locationPath(true)
	default:
		panic(p.unexpectedToken())
	}
}

func (p *parser) filterExpr() Expr {
	var expr Expr
	switch p.token(0).kind {
	case number:
		f, err := strconv.ParseFloat(p.match(number).text(), 64)
		if err != nil {
			panic(err)
		}
		expr = Number(f)
	case literal:
		expr = String(p.match(literal).text())
	case lparen:
		p.match(lparen)
		expr = p.orExpr()
		p.match(rparen)
	case identifier:
		expr = p.functionCall()
	case dollar:
		expr = p.variableReference()
	}
	predicates := p.predicates()
	if len(predicates) == 0 {
		return expr
	}
	return &FilterExpr{expr, predicates}
}

func (p *parser) functionCall() *FuncCall {
	prefix := ""
	if p.token(1).kind == colon {
		prefix = p.match(identifier).text()
		p.match(colon)
	}
	local := p.match(identifier).text()
	p.match(lparen)
	args := p.arguments()
	p.match(rparen)
	return &FuncCall{prefix, local, args}
}

func (p *parser) arguments() []Expr {
	var args []Expr
	for p.token(0).kind != rparen {
		args = append(args, p.orExpr())
		if p.token(0).kind == comma {
			p.match(comma)
			continue
		}
		break
	}
	return args
}

func (p *parser) predicates() []Expr {
	var predicates []Expr
	for p.token(0).kind == lbracket {
		p.match(lbracket)
		predicates = append(predicates, p.orExpr())
		p.match(rbracket)
	}
	return predicates
}

func (p *parser) variableReference() *VarRef {
	p.match(dollar)
	prefix := ""
	if p.token(1).kind == colon {
		prefix = p.match(identifier).text()
		p.match(colon)
	}
	return &VarRef{prefix, p.match(identifier).text()}
}

func (p *parser) locationPath(abs bool) *LocationPath {
	switch p.token(0).kind {
	case slash, slashSlash:
		if abs {
			return p.absoluteLocationPath()
		}
		return p.relativeLocationPath()
	case at, identifier, dot, dotDot, star:
		return p.relativeLocationPath()
	}
	panic(p.unexpectedToken())
}

func (p *parser) absoluteLocationPath() *LocationPath {
	var steps []*Step
	switch p.token(0).kind {
	case slash:
		p.match(slash)
		switch p.token(0).kind {
		case dot, dotDot, at, identifier, star:
			steps = p.steps()
		}
	case slashSlash:
		p.match(slashSlash)
		steps = append(steps, &Step{DescendantOrSelf, Node, nil})
		switch p.token(0).kind {
		case dot, dotDot, at, identifier, star:
			steps = append(steps, p.steps()...)
		default:
			panic(p.error(`locationPath cannot end with "//"`))
		}
	}
	return &LocationPath{true, steps}
}

func (p *parser) relativeLocationPath() *LocationPath {
	var steps []*Step
	switch p.token(0).kind {
	case slash:
		p.match(slash)
	case slashSlash:
		p.match(slashSlash)
		steps = append(steps, &Step{DescendantOrSelf, Node, nil})
	}
	steps = append(steps, p.steps()...)
	return &LocationPath{false, steps}
}

func (p *parser) steps() []*Step {
	var steps []*Step
	switch p.token(0).kind {
	case dot, dotDot, at, identifier, star:
		steps = append(steps, p.step())
	case eof:
		return steps
	default:
		panic(p.expectedTokens(dot, dotDot, at, identifier, star))
	}
	for {
		switch p.token(0).kind {
		case slash:
			p.match(slash)
		case slashSlash:
			p.match(slashSlash)
			steps = append(steps, &Step{DescendantOrSelf, Node, nil})
		default:
			return steps
		}
		switch p.token(0).kind {
		case dot, dotDot, at, identifier, star:
			steps = append(steps, p.step())
		default:
			panic(p.expectedTokens(dot, dotDot, at, identifier, star))
		}
	}
}

func (p *parser) step() *Step {
	var axis Axis
	var nodeTest NodeTest
	switch p.token(0).kind {
	case dot:
		p.match(dot)
		axis, nodeTest = Self, Node
	case dotDot:
		p.match(dotDot)
		axis, nodeTest = Parent, Node
	default:
		switch p.token(0).kind {
		case at:
			p.match(at)
			axis = Attribute
		case identifier:
			if p.token(1).kind == colonColon {
				axis = p.axisSpecifier()
			} else {
				axis = Child
			}
		case star:
			axis = Child
		}
		nodeTest = p.nodeTest(axis)
	}
	return &Step{axis, nodeTest, p.predicates()}
}

func (p *parser) nodeTest(axis Axis) NodeTest {
	switch p.token(0).kind {
	case identifier:
		if p.token(1).kind == lparen {
			return p.nodeTypeTest(axis)
		}
		return p.nameTest(axis)
	case star:
		return p.nameTest(axis)
	}
	panic(p.expectedTokens(identifier, star))
}

func (p *parser) nodeTypeTest(axis Axis) NodeTest {
	ntype := p.match(identifier).text()
	p.match(lparen)
	var nodeTest NodeTest
	switch ntype {
	case "processing-instruction":
		piName := ""
		if p.token(0).kind == literal {
			piName = p.match(literal).text()
		}
		nodeTest = PITest(piName)
	case "node":
		nodeTest = Node
	case "text":
		nodeTest = Text
	case "comment":
		nodeTest = Comment
	default:
		panic(p.error("invalid nodeType %q", ntype))
	}
	p.match(rparen)
	return nodeTest
}

func (p *parser) nameTest(axis Axis) NodeTest {
	var prefix string
	if p.token(0).kind == identifier && p.token(1).kind == colon {
		prefix = p.match(identifier).text()
		p.match(colon)
	}
	var local string
	switch p.token(0).kind {
	case identifier:
		local = p.match(identifier).text()
	case star:
		p.match(star)
		local = "*"
	default:
		// let us assume localName as empty-string and continue
	}
	return &NameTest{prefix, local}
}

func (p *parser) axisSpecifier() Axis {
	name := p.token(0).text()
	axis, ok := name2Axis[name]
	if !ok {
		panic(p.error("invalid axis %s", name))
	}
	p.match(identifier)
	p.match(colonColon)
	return axis
}

func isNodeTypeName(t token) bool {
	switch t.text() {
	case "node", "comment", "text", "processing-instruction":
		return true
	default:
		return false
	}
}
