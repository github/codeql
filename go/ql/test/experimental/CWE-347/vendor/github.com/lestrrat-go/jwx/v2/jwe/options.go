package jwe

import (
	"context"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"
	"github.com/lestrrat-go/option"
)

// Specify contents of the protected header. Some fields such as
// "enc" and "zip" will be overwritten when encryption is performed.
//
// There is no equivalent for unprotected headers in this implementation
func WithProtectedHeaders(h Headers) EncryptOption {
	cloned, _ := h.Clone(context.Background())
	return &encryptOption{option.New(identProtectedHeaders{}, cloned)}
}

type withKey struct {
	alg     jwa.KeyAlgorithm
	key     interface{}
	headers Headers
}

type WithKeySuboption interface {
	Option
	withKeySuboption()
}

type withKeySuboption struct {
	Option
}

func (*withKeySuboption) withKeySuboption() {}

// WithPerRecipientHeaders is used to pass header values for each recipient.
// Note that these headers are by definition _unprotected_.
func WithPerRecipientHeaders(hdr Headers) WithKeySuboption {
	return &withKeySuboption{option.New(identPerRecipientHeaders{}, hdr)}
}

// WithKey is used to pass a static algorithm/key pair to either `jwe.Encrypt()` or `jwe.Decrypt()`.
// either a raw key or `jwk.Key` may be passed as `key`.
//
// The `alg` parameter is the identifier for the key encryption algorithm that should be used.
// It is of type `jwa.KeyAlgorithm` but in reality you can only pass `jwa.SignatureAlgorithm`
// types. It is this way so that the value in `(jwk.Key).Algorithm()` can be directly
// passed to the option. If you specify other algorithm types such as `jwa.ContentEncryptionAlgorithm`,
// then you will get an error when `jwe.Encrypt()` or `jwe.Decrypt()` is executed.
//
// Unlike `jwe.WithKeySet()`, the `kid` field does not need to match for the key
// to be tried.
func WithKey(alg jwa.KeyAlgorithm, key interface{}, options ...WithKeySuboption) EncryptDecryptOption {
	var hdr Headers
	for _, option := range options {
		//nolint:forcetypeassert
		switch option.Ident() {
		case identPerRecipientHeaders{}:
			hdr = option.Value().(Headers)
		}
	}

	return &encryptDecryptOption{option.New(identKey{}, &withKey{
		alg:     alg,
		key:     key,
		headers: hdr,
	})}
}

func WithKeySet(set jwk.Set, options ...WithKeySetSuboption) DecryptOption {
	requireKid := true
	for _, option := range options {
		//nolint:forcetypeassert
		switch option.Ident() {
		case identRequireKid{}:
			requireKid = option.Value().(bool)
		}
	}

	return WithKeyProvider(&keySetProvider{
		set:        set,
		requireKid: requireKid,
	})
}

// WithJSON specifies that the result of `jwe.Encrypt()` is serialized in
// JSON format.
//
// If you pass multiple keys to `jwe.Encrypt()`, it will fail unless
// you also pass this option.
func WithJSON(options ...WithJSONSuboption) EncryptOption {
	var pretty bool
	for _, option := range options {
		//nolint:forcetypeassert
		switch option.Ident() {
		case identPretty{}:
			pretty = option.Value().(bool)
		}
	}

	format := fmtJSON
	if pretty {
		format = fmtJSONPretty
	}
	return &encryptOption{option.New(identSerialization{}, format)}
}
