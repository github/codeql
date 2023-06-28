package types

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"io"

	"github.com/go-pg/pg/v10/internal/parser"
)

var errEndOfArray = errors.New("pg: end of array")

type arrayParser struct {
	p parser.StreamingParser

	stickyErr error
	buf       []byte
}

func newArrayParserErr(err error) *arrayParser {
	return &arrayParser{
		stickyErr: err,
		buf:       make([]byte, 32),
	}
}

func newArrayParser(rd Reader) *arrayParser {
	p := parser.NewStreamingParser(rd)
	err := p.SkipByte('{')
	if err != nil {
		return newArrayParserErr(err)
	}
	return &arrayParser{
		p: p,
	}
}

func (p *arrayParser) NextElem() ([]byte, error) {
	if p.stickyErr != nil {
		return nil, p.stickyErr
	}

	c, err := p.p.ReadByte()
	if err != nil {
		if err == io.EOF {
			return nil, errEndOfArray
		}
		return nil, err
	}

	switch c {
	case '"':
		b, err := p.p.ReadSubstring(p.buf[:0])
		if err != nil {
			return nil, err
		}
		p.buf = b

		err = p.readCommaBrace()
		if err != nil {
			return nil, err
		}

		return b, nil
	case '{':
		b, err := p.readSubArray(p.buf[:0])
		if err != nil {
			return nil, err
		}
		p.buf = b

		err = p.readCommaBrace()
		if err != nil {
			return nil, err
		}

		return b, nil
	case '}':
		return nil, errEndOfArray
	default:
		err = p.p.UnreadByte()
		if err != nil {
			return nil, err
		}

		b, err := p.readSimple(p.buf[:0])
		if err != nil {
			return nil, err
		}
		p.buf = b

		if bytes.Equal(b, []byte("NULL")) {
			return nil, nil
		}
		return b, nil
	}
}

func (p *arrayParser) readSimple(b []byte) ([]byte, error) {
	for {
		tmp, err := p.p.ReadSlice(',')
		if err == nil {
			b = append(b, tmp...)
			b = b[:len(b)-1]
			break
		}
		b = append(b, tmp...)
		if err == bufio.ErrBufferFull {
			continue
		}
		if err == io.EOF {
			if b[len(b)-1] == '}' {
				b = b[:len(b)-1]
				break
			}
		}
		return nil, err
	}
	return b, nil
}

func (p *arrayParser) readSubArray(b []byte) ([]byte, error) {
	b = append(b, '{')
	for {
		c, err := p.p.ReadByte()
		if err != nil {
			return nil, err
		}

		if c == '}' {
			b = append(b, '}')
			return b, nil
		}

		if c == '"' {
			b = append(b, '"')
			for {
				tmp, err := p.p.ReadSlice('"')
				b = append(b, tmp...)
				if err != nil {
					if err == bufio.ErrBufferFull {
						continue
					}
					return nil, err
				}
				if len(b) > 1 && b[len(b)-2] != '\\' {
					break
				}
			}
			continue
		}

		b = append(b, c)
	}
}

func (p *arrayParser) readCommaBrace() error {
	c, err := p.p.ReadByte()
	if err != nil {
		return err
	}
	switch c {
	case ',', '}':
		return nil
	default:
		return fmt.Errorf("pg: got %q, wanted ',' or '}'", c)
	}
}
