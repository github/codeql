package pio

import (
	"encoding/json"
	"encoding/xml"
	"errors"
)

// Marshaler is the interface implemented by types that
// can marshal themselves into valid output.
type Marshaler interface {
	Marshal(v interface{}) ([]byte, error)
}

// Marshaled or (especially British, marshalled) is an interface which
// is implemented by values that can marshal theirselves.
//
// It's like Marshaler but it doesn't takes an argument.
type Marshaled interface {
	Marshal() ([]byte, error)
}

func fromMarshaled(self Marshaled) Marshaler {
	return MarshalerFunc(func(v interface{}) ([]byte, error) {
		return self.Marshal()
	})
}

// MarshalerFunc is the signature implemented by callers that
// are responsible to marshal "v" into valid printable result.
//
// Look `Printer#Marshal` for more.
type MarshalerFunc func(v interface{}) ([]byte, error)

// Marshal makes the Marshaler compatible with the
// standard golang's marshalers, so a marshaler
// created for a Printer, can be used on std packages as well.
func (m MarshalerFunc) Marshal(v interface{}) ([]byte, error) {
	return m(v)
}

// ErrMarshalNotResponsible retruns from a marshaler
// when it's not responsible and should continue to the next marshaler.
var ErrMarshalNotResponsible = errors.New("this marshaler is not responsible for this type of data")

// ErrMarshalNotFound or ErrSkipped can be used to skip a specific
// printer's output operation.
var ErrMarshalNotFound = errors.New("no marshaler found for this type of dat")

// Text is a Text marshaler, it converts
// string to a compatible form of []byte.
var Text = MarshalerFunc(func(v interface{}) ([]byte, error) {
	if b, ok := v.([]byte); ok {
		return b, nil
	}
	if s, ok := v.(string); ok {
		return []byte(s), nil // maybe 0101010 010110 here, but can be overridden by fmt.Sprintf("%s", v)
	}

	return nil, ErrMarshalNotResponsible
})

var (
	// JSON returns the JSON encoding of Printer#Print%v.
	// A shortcut for `encoding/json#Marshal`
	JSON = MarshalerFunc(json.Marshal)
	// JSONIndent returns the JSON encoding of Printer#Print%v.
	// A shortcut for `encoding/json#MarshalIndent(v, ""," ")`
	JSONIndent = MarshalerFunc(func(v interface{}) ([]byte, error) {
		return json.MarshalIndent(v, "", " ")
	})

	// XML returns the XML encoding of Printer#Print%v.
	// A shortcut for `encoding/xml#Marshal`
	XML = MarshalerFunc(xml.Marshal)
	// XMLIndent returns the XML encoding of Printer#Print%v.
	// A shortcut for `encoding/xml#MarshalIndent(v, ""," ")`
	XMLIndent = MarshalerFunc(func(v interface{}) ([]byte, error) {
		return xml.MarshalIndent(v, "", " ")
	})
)
