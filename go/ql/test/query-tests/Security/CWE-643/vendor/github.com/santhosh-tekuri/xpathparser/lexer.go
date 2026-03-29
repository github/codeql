// Copyright 2017 Santhosh Kumar Tekuri. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package xpathparser

// see lexer specification at https://www.w3.org/TR/xpath/#exprlex

import (
	"bytes"
	"strings"
	"unicode/utf8"
)

type kind int

const (
	eof kind = iota - 1

	// operators, note the order must same as Op enum values
	eq
	neq
	lt
	lte
	gt
	gte
	plus
	minus
	multiply
	mod
	div
	and
	or
	pipe

	slash
	slashSlash
	dot
	dotDot
	colon
	colonColon

	at
	dollar
	comma
	star

	lbracket
	rbracket
	lparen
	rparen

	identifier
	literal
	number
)

var kindNames = []string{
	`<eof>`,
	`'='`, `"!="`, `'<'`, `"<="`, `'>'`, `">="`,
	`'+'`, `'-'`, `'*'`, `"mod"`, `"div"`,
	`"and"`, `"or"`, `'|'`,
	`'/'`, `"//"`, `'.'`, `".."`, `':'`, `"::"`,
	`'@'`, `'$'`, `','`, `'*'`,
	`'['`, `']'`, `'('`, `')'`,
	`<identifier>`, `<literal>`, `<number>`,
}

func (k kind) String() string {
	return kindNames[k+1]
}

type token struct {
	xpath string
	kind  kind
	begin int
	end   int
}

func (t token) text() string {
	return t.xpath[t.begin:t.end]
}

type lexer struct {
	xpath    string
	pos      int
	expectOp bool
}

func (l *lexer) err(msg string) (token, error) {
	return token{}, &Error{msg, l.xpath, l.pos}
}

func (l *lexer) char(i int) int {
	if l.pos+i < len(l.xpath) {
		return int(l.xpath[l.pos+i])
	}
	return -1
}

func (l *lexer) consume(n int) {
	l.pos += n
}

func (l *lexer) hasMore() bool {
	return l.pos < len(l.xpath)
}

func (l *lexer) token(kind kind, n int) (token, error) {
	var t token
	if n > 0 {
		t = token{l.xpath, kind, l.pos, l.pos + n}
		l.consume(n)
	} else {
		t = token{l.xpath, kind, l.pos + n, l.pos}
	}
	switch kind {
	case at, colonColon, lparen, lbracket, and, or, mod, div, colon, slash, slashSlash,
		pipe, dollar, plus, minus, multiply, comma, lt, gt, lte, gte, eq, neq:
		l.expectOp = false
	default:
		l.expectOp = true
	}
	return t, nil
}

func (l *lexer) next() (token, error) {
SkipWS:
	for l.hasMore() {
		switch l.char(0) {
		case ' ', '\t', '\n', '\r':
			l.consume(1)
		default:
			break SkipWS
		}
	}

	switch l.char(0) {
	case -1:
		return l.token(eof, 0)
	case '$':
		return l.token(dollar, 1)
	case '"', '\'':
		return l.literal()
	case '/':
		if l.char(1) == '/' {
			return l.token(slashSlash, 2)
		}
		return l.token(slash, 1)
	case ',':
		return l.token(comma, 1)
	case '(':
		return l.token(lparen, 1)
	case ')':
		return l.token(rparen, 1)
	case '[':
		return l.token(lbracket, 1)
	case ']':
		return l.token(rbracket, 1)
	case '+':
		return l.token(plus, 1)
	case '-':
		return l.token(minus, 1)
	case '<':
		if l.char(1) == '=' {
			return l.token(lte, 2)
		}
		return l.token(lt, 1)
	case '>':
		if l.char(1) == '=' {
			return l.token(gte, 2)
		}
		return l.token(gt, 1)
	case '=':
		return l.token(eq, 1)
	case '!':
		if l.char(1) == '=' {
			return l.token(neq, 2)
		}
		return l.err("expected '!='")
	case '|':
		return l.token(pipe, 1)
	case '@':
		return l.token(at, 1)
	case ':':
		if l.char(1) == ':' {
			return l.token(colonColon, 2)
		}
		return l.token(colon, 1)
	case '*':
		if l.expectOp {
			return l.token(multiply, 1)
		}
		return l.token(star, 1)
	case '.':
		switch l.char(1) {
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			return l.number()
		case '.':
			return l.token(dotDot, 2)
		default:
			return l.token(dot, 1)
		}
	case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
		return l.number()
	default:
		if l.expectOp {
			return l.operator()
		}
		return l.identifier()
	}
}

func (l *lexer) literal() (token, error) {
	quote := l.char(0)
	l.consume(1)
	begin := l.pos
	for {
		switch l.char(0) {
		case quote:
			t, _ := l.token(literal, begin-l.pos)
			l.consume(1)
			return t, nil
		case -1:
			return l.err("unclosed literal")
		}
		l.consume(1)
	}
}

func (l *lexer) number() (token, error) {
	begin := l.pos
	dotAllowed := true
Loop:
	for {
		switch l.char(0) {
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			l.consume(1)
		case '.':
			if dotAllowed {
				dotAllowed = false
				l.consume(1)
			} else {
				break Loop
			}
		default:
			break Loop
		}
	}
	return l.token(number, begin-l.pos)
}

func (l *lexer) operator() (token, error) {
	remaining := l.xpath[l.pos:]
	switch {
	case strings.HasPrefix(remaining, "and"):
		return l.token(and, 3)
	case strings.HasPrefix(remaining, "or"):
		return l.token(or, 2)
	case strings.HasPrefix(remaining, "mod"):
		return l.token(mod, 3)
	case strings.HasPrefix(remaining, "div"):
		return l.token(div, 3)
	}
	return l.err("operatorName expected")
}

func (l *lexer) identifier() (token, error) {
	begin := l.pos
	b, ok := l.readName()
	if !ok {
		return l.err("identifier expected")
	}
	if !isName(b) {
		l.pos = begin
		return l.err("invalid identifier")
	}
	return l.token(identifier, begin-l.pos)
}

func (l *lexer) readName() ([]byte, bool) {
	if !l.hasMore() {
		return nil, false
	}
	buf := new(bytes.Buffer)
	b := byte(l.char(0))
	if b < utf8.RuneSelf && !isNameByte(b) {
		return nil, false
	}
	buf.WriteByte(b)
	l.consume(1)
	for l.hasMore() {
		b = byte(l.char(0))
		if b < utf8.RuneSelf && !isNameByte(b) {
			break
		}
		buf.WriteByte(b)
		l.consume(1)
	}
	return buf.Bytes(), true
}
