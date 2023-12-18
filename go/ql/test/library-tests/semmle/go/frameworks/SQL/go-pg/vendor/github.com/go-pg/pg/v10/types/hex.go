package types

import (
	"bytes"
	"encoding/hex"
	"fmt"
	"io"

	fasthex "github.com/tmthrgd/go-hex"
)

type HexEncoder struct {
	b       []byte
	flags   int
	written bool
}

func NewHexEncoder(b []byte, flags int) *HexEncoder {
	return &HexEncoder{
		b:     b,
		flags: flags,
	}
}

func (enc *HexEncoder) Bytes() []byte {
	return enc.b
}

func (enc *HexEncoder) Write(b []byte) (int, error) {
	if !enc.written {
		if hasFlag(enc.flags, arrayFlag) {
			enc.b = append(enc.b, `"\`...)
		} else if hasFlag(enc.flags, quoteFlag) {
			enc.b = append(enc.b, '\'')
		}
		enc.b = append(enc.b, `\x`...)
		enc.written = true
	}

	i := len(enc.b)
	enc.b = append(enc.b, make([]byte, fasthex.EncodedLen(len(b)))...)
	fasthex.Encode(enc.b[i:], b)

	return len(b), nil
}

func (enc *HexEncoder) Close() error {
	if enc.written {
		if hasFlag(enc.flags, arrayFlag) {
			enc.b = append(enc.b, '"')
		} else if hasFlag(enc.flags, quoteFlag) {
			enc.b = append(enc.b, '\'')
		}
	} else {
		enc.b = AppendNull(enc.b, enc.flags)
	}
	return nil
}

//------------------------------------------------------------------------------

func NewHexDecoder(rd Reader, n int) (io.Reader, error) {
	if n <= 0 {
		var rd bytes.Reader
		return &rd, nil
	}

	if c, err := rd.ReadByte(); err != nil {
		return nil, err
	} else if c != '\\' {
		return nil, fmt.Errorf("got %q, wanted %q", c, '\\')
	}

	if c, err := rd.ReadByte(); err != nil {
		return nil, err
	} else if c != 'x' {
		return nil, fmt.Errorf("got %q, wanted %q", c, 'x')
	}

	return hex.NewDecoder(rd), nil
}
