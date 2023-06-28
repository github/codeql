package types

import (
	"errors"
	"io"

	"github.com/go-pg/pg/v10/internal/parser"
)

var errEndOfHstore = errors.New("pg: end of hstore")

type hstoreParser struct {
	p parser.StreamingParser
}

func newHstoreParser(rd Reader) *hstoreParser {
	return &hstoreParser{
		p: parser.NewStreamingParser(rd),
	}
}

func (p *hstoreParser) NextKey() ([]byte, error) {
	err := p.p.SkipByte('"')
	if err != nil {
		if err == io.EOF {
			return nil, errEndOfHstore
		}
		return nil, err
	}

	key, err := p.p.ReadSubstring(nil)
	if err != nil {
		return nil, err
	}

	err = p.p.SkipByte('=')
	if err != nil {
		return nil, err
	}
	err = p.p.SkipByte('>')
	if err != nil {
		return nil, err
	}

	return key, nil
}

func (p *hstoreParser) NextValue() ([]byte, error) {
	err := p.p.SkipByte('"')
	if err != nil {
		return nil, err
	}

	value, err := p.p.ReadSubstring(nil)
	if err != nil {
		return nil, err
	}

	err = p.p.SkipByte(',')
	if err == nil {
		_ = p.p.SkipByte(' ')
	}

	return value, nil
}
