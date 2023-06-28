package orm

import (
	"bufio"
	"errors"
	"fmt"
	"io"

	"github.com/go-pg/pg/v10/internal/parser"
	"github.com/go-pg/pg/v10/types"
)

var errEndOfComposite = errors.New("pg: end of composite")

type compositeParser struct {
	p parser.StreamingParser

	stickyErr error
}

func newCompositeParserErr(err error) *compositeParser {
	return &compositeParser{
		stickyErr: err,
	}
}

func newCompositeParser(rd types.Reader) *compositeParser {
	p := parser.NewStreamingParser(rd)
	err := p.SkipByte('(')
	if err != nil {
		return newCompositeParserErr(err)
	}
	return &compositeParser{
		p: p,
	}
}

func (p *compositeParser) NextElem() ([]byte, error) {
	if p.stickyErr != nil {
		return nil, p.stickyErr
	}

	c, err := p.p.ReadByte()
	if err != nil {
		if err == io.EOF {
			return nil, errEndOfComposite
		}
		return nil, err
	}

	switch c {
	case '"':
		return p.readQuoted()
	case ',':
		return nil, nil
	case ')':
		return nil, errEndOfComposite
	default:
		_ = p.p.UnreadByte()
	}

	var b []byte
	for {
		tmp, err := p.p.ReadSlice(',')
		if err == nil {
			if b == nil {
				b = tmp
			} else {
				b = append(b, tmp...)
			}
			b = b[:len(b)-1]
			break
		}
		b = append(b, tmp...)
		if err == bufio.ErrBufferFull {
			continue
		}
		if err == io.EOF {
			if b[len(b)-1] == ')' {
				b = b[:len(b)-1]
				break
			}
		}
		return nil, err
	}

	if len(b) == 0 { // NULL
		return nil, nil
	}
	return b, nil
}

func (p *compositeParser) readQuoted() ([]byte, error) {
	var b []byte

	c, err := p.p.ReadByte()
	if err != nil {
		return nil, err
	}

	for {
		next, err := p.p.ReadByte()
		if err != nil {
			return nil, err
		}

		if c == '\\' || c == '\'' {
			if next == c {
				b = append(b, c)
				c, err = p.p.ReadByte()
				if err != nil {
					return nil, err
				}
			} else {
				b = append(b, c)
				c = next
			}
			continue
		}

		if c == '"' {
			switch next {
			case '"':
				b = append(b, '"')
				c, err = p.p.ReadByte()
				if err != nil {
					return nil, err
				}
			case ',', ')':
				return b, nil
			default:
				return nil, fmt.Errorf("pg: got %q, wanted ',' or ')'", c)
			}
			continue
		}

		b = append(b, c)
		c = next
	}
}
