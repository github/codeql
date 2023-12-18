package parser

import (
	"bytes"
	"strconv"

	"github.com/go-pg/pg/v10/internal"
)

type Parser struct {
	b []byte
	i int
}

func New(b []byte) *Parser {
	return &Parser{
		b: b,
	}
}

func NewString(s string) *Parser {
	return New(internal.StringToBytes(s))
}

func (p *Parser) Valid() bool {
	return p.i < len(p.b)
}

func (p *Parser) Bytes() []byte {
	return p.b[p.i:]
}

func (p *Parser) Read() byte {
	if p.Valid() {
		c := p.b[p.i]
		p.Advance()
		return c
	}
	return 0
}

func (p *Parser) Peek() byte {
	if p.Valid() {
		return p.b[p.i]
	}
	return 0
}

func (p *Parser) Advance() {
	p.i++
}

func (p *Parser) Skip(skip byte) bool {
	if p.Peek() == skip {
		p.Advance()
		return true
	}
	return false
}

func (p *Parser) SkipBytes(skip []byte) bool {
	if len(skip) > len(p.b[p.i:]) {
		return false
	}
	if !bytes.Equal(p.b[p.i:p.i+len(skip)], skip) {
		return false
	}
	p.i += len(skip)
	return true
}

func (p *Parser) ReadSep(sep byte) ([]byte, bool) {
	ind := bytes.IndexByte(p.b[p.i:], sep)
	if ind == -1 {
		b := p.b[p.i:]
		p.i = len(p.b)
		return b, false
	}

	b := p.b[p.i : p.i+ind]
	p.i += ind + 1
	return b, true
}

func (p *Parser) ReadIdentifier() (string, bool) {
	if p.i < len(p.b) && p.b[p.i] == '(' {
		s := p.i + 1
		if ind := bytes.IndexByte(p.b[s:], ')'); ind != -1 {
			b := p.b[s : s+ind]
			p.i = s + ind + 1
			return internal.BytesToString(b), false
		}
	}

	ind := len(p.b) - p.i
	var alpha bool
	for i, c := range p.b[p.i:] {
		if isNum(c) {
			continue
		}
		if isAlpha(c) || (i > 0 && alpha && c == '_') {
			alpha = true
			continue
		}
		ind = i
		break
	}
	if ind == 0 {
		return "", false
	}
	b := p.b[p.i : p.i+ind]
	p.i += ind
	return internal.BytesToString(b), !alpha
}

func (p *Parser) ReadNumber() int {
	ind := len(p.b) - p.i
	for i, c := range p.b[p.i:] {
		if !isNum(c) {
			ind = i
			break
		}
	}
	if ind == 0 {
		return 0
	}
	n, err := strconv.Atoi(string(p.b[p.i : p.i+ind]))
	if err != nil {
		panic(err)
	}
	p.i += ind
	return n
}

func isNum(c byte) bool {
	return c >= '0' && c <= '9'
}

func isAlpha(c byte) bool {
	return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')
}
