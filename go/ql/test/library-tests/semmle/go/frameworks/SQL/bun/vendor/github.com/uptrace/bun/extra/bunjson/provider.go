package bunjson

import (
	"io"
)

var provider Provider = StdProvider{}

func SetProvider(p Provider) {
	provider = p
}

type Provider interface {
	Marshal(v interface{}) ([]byte, error)
	Unmarshal(data []byte, v interface{}) error
	NewEncoder(w io.Writer) Encoder
	NewDecoder(r io.Reader) Decoder
}

type Decoder interface {
	Decode(v interface{}) error
	UseNumber()
}

type Encoder interface {
	Encode(v interface{}) error
}

func Marshal(v interface{}) ([]byte, error) {
	return provider.Marshal(v)
}

func Unmarshal(data []byte, v interface{}) error {
	return provider.Unmarshal(data, v)
}

func NewEncoder(w io.Writer) Encoder {
	return provider.NewEncoder(w)
}

func NewDecoder(r io.Reader) Decoder {
	return provider.NewDecoder(r)
}
