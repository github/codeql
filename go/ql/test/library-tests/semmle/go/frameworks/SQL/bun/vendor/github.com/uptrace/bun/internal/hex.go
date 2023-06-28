package internal

import (
	fasthex "github.com/tmthrgd/go-hex"
)

type HexEncoder struct {
	b       []byte
	written bool
}

func NewHexEncoder(b []byte) *HexEncoder {
	return &HexEncoder{
		b: b,
	}
}

func (enc *HexEncoder) Bytes() []byte {
	return enc.b
}

func (enc *HexEncoder) Write(b []byte) (int, error) {
	if !enc.written {
		enc.b = append(enc.b, '\'')
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
		enc.b = append(enc.b, '\'')
	} else {
		enc.b = append(enc.b, "NULL"...)
	}
	return nil
}
