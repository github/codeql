package bytes

import (
	"go-micro.dev/v4/codec"
)

type Marshaler struct{}

type Message struct {
	Header map[string]string
	Body   []byte
}

func (n Marshaler) Marshal(v interface{}) ([]byte, error) {
	switch ve := v.(type) {
	case *[]byte:
		return *ve, nil
	case []byte:
		return ve, nil
	case *Message:
		return ve.Body, nil
	}
	return nil, codec.ErrInvalidMessage
}

func (n Marshaler) Unmarshal(d []byte, v interface{}) error {
	switch ve := v.(type) {
	case *[]byte:
		*ve = d
		return nil
	case *Message:
		ve.Body = d
		return nil
	}
	return codec.ErrInvalidMessage
}

func (n Marshaler) String() string {
	return "bytes"
}
