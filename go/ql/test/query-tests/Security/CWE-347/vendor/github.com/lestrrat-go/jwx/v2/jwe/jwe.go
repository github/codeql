//go:generate ../tools/cmd/genjwe.sh

// Package jwe implements JWE as described in https://tools.ietf.org/html/rfc7516
package jwe

import (
	"bytes"
	"context"
	"crypto/ecdsa"
	"crypto/rsa"
	"fmt"
	"io"

	"github.com/lestrrat-go/blackmagic"
	"github.com/lestrrat-go/jwx/v2/internal/base64"
	"github.com/lestrrat-go/jwx/v2/internal/json"
	"github.com/lestrrat-go/jwx/v2/internal/keyconv"
	"github.com/lestrrat-go/jwx/v2/jwk"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/content_crypt"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/keyenc"
	"github.com/lestrrat-go/jwx/v2/jwe/internal/keygen"
	"github.com/lestrrat-go/jwx/v2/x25519"
)

const (
	fmtInvalid = iota
	fmtCompact
	fmtJSON
	fmtJSONPretty
	fmtMax
)

var _ = fmtInvalid
var _ = fmtMax

var registry = json.NewRegistry()

type keyEncrypterWrapper struct {
	encrypter KeyEncrypter
}

func (w *keyEncrypterWrapper) Algorithm() jwa.KeyEncryptionAlgorithm {
	return w.encrypter.Algorithm()
}

func (w *keyEncrypterWrapper) EncryptKey(cek []byte) (keygen.ByteSource, error) {
	encrypted, err := w.encrypter.EncryptKey(cek)
	if err != nil {
		return nil, err
	}
	return keygen.ByteKey(encrypted), nil
}

type recipientBuilder struct {
	alg     jwa.KeyEncryptionAlgorithm
	key     interface{}
	headers Headers
}

func (b *recipientBuilder) Build(cek []byte, calg jwa.ContentEncryptionAlgorithm, cc *content_crypt.Generic) (Recipient, []byte, error) {
	var enc keyenc.Encrypter

	// we need the raw key for later use
	rawKey := b.key

	var keyID string
	if ke, ok := b.key.(KeyEncrypter); ok {
		enc = &keyEncrypterWrapper{encrypter: ke}
		if kider, ok := enc.(KeyIDer); ok {
			keyID = kider.KeyID()
		}
	} else if jwkKey, ok := b.key.(jwk.Key); ok {
		// Meanwhile, grab the kid as well
		keyID = jwkKey.KeyID()

		var raw interface{}
		if err := jwkKey.Raw(&raw); err != nil {
			return nil, nil, fmt.Errorf(`failed to retrieve raw key out of %T: %w`, b.key, err)
		}

		rawKey = raw
	}

	if enc == nil {
		switch b.alg {
		case jwa.RSA1_5:
			var pubkey rsa.PublicKey
			if err := keyconv.RSAPublicKey(&pubkey, rawKey); err != nil {
				return nil, nil, fmt.Errorf(`failed to generate public key from key (%T): %w`, rawKey, err)
			}

			v, err := keyenc.NewRSAPKCSEncrypt(b.alg, &pubkey)
			if err != nil {
				return nil, nil, fmt.Errorf(`failed to create RSA PKCS encrypter: %w`, err)
			}
			enc = v
		case jwa.RSA_OAEP, jwa.RSA_OAEP_256:
			var pubkey rsa.PublicKey
			if err := keyconv.RSAPublicKey(&pubkey, rawKey); err != nil {
				return nil, nil, fmt.Errorf(`failed to generate public key from key (%T): %w`, rawKey, err)
			}

			v, err := keyenc.NewRSAOAEPEncrypt(b.alg, &pubkey)
			if err != nil {
				return nil, nil, fmt.Errorf(`failed to create RSA OAEP encrypter: %w`, err)
			}
			enc = v
		case jwa.A128KW, jwa.A192KW, jwa.A256KW,
			jwa.A128GCMKW, jwa.A192GCMKW, jwa.A256GCMKW,
			jwa.PBES2_HS256_A128KW, jwa.PBES2_HS384_A192KW, jwa.PBES2_HS512_A256KW:
			sharedkey, ok := rawKey.([]byte)
			if !ok {
				return nil, nil, fmt.Errorf(`invalid key: []byte required (%T)`, rawKey)
			}

			var err error
			switch b.alg {
			case jwa.A128KW, jwa.A192KW, jwa.A256KW:
				enc, err = keyenc.NewAES(b.alg, sharedkey)
			case jwa.PBES2_HS256_A128KW, jwa.PBES2_HS384_A192KW, jwa.PBES2_HS512_A256KW:
				enc, err = keyenc.NewPBES2Encrypt(b.alg, sharedkey)
			default:
				enc, err = keyenc.NewAESGCMEncrypt(b.alg, sharedkey)
			}
			if err != nil {
				return nil, nil, fmt.Errorf(`failed to create key wrap encrypter: %w`, err)
			}
			// NOTE: there was formerly a restriction, introduced
			// in PR #26, which disallowed certain key/content
			// algorithm combinations. This seemed bogus, and
			// interop with the jose tool demonstrates it.
		case jwa.ECDH_ES, jwa.ECDH_ES_A128KW, jwa.ECDH_ES_A192KW, jwa.ECDH_ES_A256KW:
			var keysize int
			switch b.alg {
			case jwa.ECDH_ES:
				// https://tools.ietf.org/html/rfc7518#page-15
				// In Direct Key Agreement mode, the output of the Concat KDF MUST be a
				// key of the same length as that used by the "enc" algorithm.
				keysize = cc.KeySize()
			case jwa.ECDH_ES_A128KW:
				keysize = 16
			case jwa.ECDH_ES_A192KW:
				keysize = 24
			case jwa.ECDH_ES_A256KW:
				keysize = 32
			}

			switch key := rawKey.(type) {
			case x25519.PublicKey:
				var apu, apv []byte
				if hdrs := b.headers; hdrs != nil {
					apu = hdrs.AgreementPartyUInfo()
					apv = hdrs.AgreementPartyVInfo()
				}

				v, err := keyenc.NewECDHESEncrypt(b.alg, calg, keysize, rawKey, apu, apv)
				if err != nil {
					return nil, nil, fmt.Errorf(`failed to create ECDHS key wrap encrypter: %w`, err)
				}
				enc = v
			default:
				var pubkey ecdsa.PublicKey
				if err := keyconv.ECDSAPublicKey(&pubkey, rawKey); err != nil {
					return nil, nil, fmt.Errorf(`failed to generate public key from key (%T): %w`, key, err)
				}

				var apu, apv []byte
				if hdrs := b.headers; hdrs != nil {
					apu = hdrs.AgreementPartyUInfo()
					apv = hdrs.AgreementPartyVInfo()
				}

				v, err := keyenc.NewECDHESEncrypt(b.alg, calg, keysize, &pubkey, apu, apv)
				if err != nil {
					return nil, nil, fmt.Errorf(`failed to create ECDHS key wrap encrypter: %w`, err)
				}
				enc = v
			}
		case jwa.DIRECT:
			sharedkey, ok := rawKey.([]byte)
			if !ok {
				return nil, nil, fmt.Errorf("invalid key: []byte required")
			}
			enc, _ = keyenc.NewNoop(b.alg, sharedkey)
		default:
			return nil, nil, fmt.Errorf(`invalid key encryption algorithm (%s)`, b.alg)
		}
	}

	r := NewRecipient()
	if hdrs := b.headers; hdrs != nil {
		_ = r.SetHeaders(hdrs)
	}

	if err := r.Headers().Set(AlgorithmKey, b.alg); err != nil {
		return nil, nil, fmt.Errorf(`failed to set header: %w`, err)
	}

	if keyID != "" {
		if err := r.Headers().Set(KeyIDKey, keyID); err != nil {
			return nil, nil, fmt.Errorf(`failed to set header: %w`, err)
		}
	}

	var rawCEK []byte
	enckey, err := enc.EncryptKey(cek)
	if err != nil {
		return nil, nil, fmt.Errorf(`failed to encrypt key: %w`, err)
	}
	if enc.Algorithm() == jwa.ECDH_ES || enc.Algorithm() == jwa.DIRECT {
		rawCEK = enckey.Bytes()
	} else {
		if err := r.SetEncryptedKey(enckey.Bytes()); err != nil {
			return nil, nil, fmt.Errorf(`failed to set encrypted key: %w`, err)
		}
	}

	if hp, ok := enckey.(populater); ok {
		if err := hp.Populate(r.Headers()); err != nil {
			return nil, nil, fmt.Errorf(`failed to populate: %w`, err)
		}
	}

	return r, rawCEK, nil
}

// Encrypt generates a JWE message for the given payload and returns
// it in serialized form, which can be in either compact or
// JSON format. Default is compact.
//
// You must pass at least one key to `jwe.Encrypt()` by using `jwe.WithKey()`
// option.
//
//	jwe.Encrypt(payload, jwe.WithKey(alg, key))
//	jwe.Encrypt(payload, jws.WithJSON(), jws.WithKey(alg1, key1), jws.WithKey(alg2, key2))
//
// Note that in the second example the `jws.WithJSON()` option is
// specified as well. This is because the compact serialization
// format does not support multiple recipients, and users must
// specifically ask for the JSON serialization format.
//
// Read the documentation for `jwe.WithKey()` to learn more about the
// possible values that can be used for `alg` and `key`.
//
// Look for options that return `jwe.EncryptOption` or `jws.EncryptDecryptOption`
// for a complete list of options that can be passed to this function.
func Encrypt(payload []byte, options ...EncryptOption) ([]byte, error) {
	// default content encryption algorithm
	calg := jwa.A256GCM

	// default compression is "none"
	compression := jwa.NoCompress

	// default format is compact serialization
	format := fmtCompact

	// builds each "recipient" with encrypted_key and headers
	var builders []*recipientBuilder

	var protected Headers
	var mergeProtected bool
	var useRawCEK bool
	for _, option := range options {
		//nolint:forcetypeassert
		switch option.Ident() {
		case identKey{}:
			data := option.Value().(*withKey)
			v, ok := data.alg.(jwa.KeyEncryptionAlgorithm)
			if !ok {
				return nil, fmt.Errorf(`jwe.Encrypt: expected alg to be jwa.KeyEncryptionAlgorithm, but got %T`, data.alg)
			}

			switch v {
			case jwa.DIRECT, jwa.ECDH_ES:
				useRawCEK = true
			}

			builders = append(builders, &recipientBuilder{
				alg:     v,
				key:     data.key,
				headers: data.headers,
			})
		case identContentEncryptionAlgorithm{}:
			calg = option.Value().(jwa.ContentEncryptionAlgorithm)
		case identCompress{}:
			compression = option.Value().(jwa.CompressionAlgorithm)
		case identMergeProtectedHeaders{}:
			mergeProtected = option.Value().(bool)
		case identProtectedHeaders{}:
			v := option.Value().(Headers)
			if !mergeProtected || protected == nil {
				protected = v
			} else {
				ctx := context.TODO()
				merged, err := protected.Merge(ctx, v)
				if err != nil {
					return nil, fmt.Errorf(`jwe.Encrypt: failed to merge headers: %w`, err)
				}
				protected = merged
			}
		case identSerialization{}:
			format = option.Value().(int)
		}
	}

	// We need to have at least one builder
	switch l := len(builders); {
	case l == 0:
		return nil, fmt.Errorf(`jwe.Encrypt: missing key encryption builders: use jwe.WithKey() to specify one`)
	case l > 1:
		if format == fmtCompact {
			return nil, fmt.Errorf(`jwe.Encrypt: cannot use compact serialization when multiple recipients exist (check the number of WithKey() argument, or use WithJSON())`)
		}
	}

	if useRawCEK {
		if len(builders) != 1 {
			return nil, fmt.Errorf(`jwe.Encrypt: multiple recipients for ECDH-ES/DIRECT mode supported`)
		}
	}

	// There is exactly one content encrypter.
	contentcrypt, err := content_crypt.NewGeneric(calg)
	if err != nil {
		return nil, fmt.Errorf(`jwe.Encrypt: failed to create AES encrypter: %w`, err)
	}

	generator := keygen.NewRandom(contentcrypt.KeySize())
	bk, err := generator.Generate()
	if err != nil {
		return nil, fmt.Errorf(`jwe.Encrypt: failed to generate key: %w`, err)
	}
	cek := bk.Bytes()

	recipients := make([]Recipient, len(builders))
	for i, builder := range builders {
		// some builders require hint from the contentcrypt object
		r, rawCEK, err := builder.Build(cek, calg, contentcrypt)
		if err != nil {
			return nil, fmt.Errorf(`jwe.Encrypt: failed to create recipient #%d: %w`, i, err)
		}
		recipients[i] = r

		// Kinda feels weird, but if useRawCEK == true, we asserted earlier
		// that len(builders) == 1, so this is OK
		if useRawCEK {
			cek = rawCEK
		}
	}

	if protected == nil {
		protected = NewHeaders()
	}

	if err := protected.Set(ContentEncryptionKey, calg); err != nil {
		return nil, fmt.Errorf(`jwe.Encrypt: failed to set "enc" in protected header: %w`, err)
	}

	if compression != jwa.NoCompress {
		payload, err = compress(payload)
		if err != nil {
			return nil, fmt.Errorf(`jwe.Encrypt: failed to compress payload before encryption: %w`, err)
		}
		if err := protected.Set(CompressionKey, compression); err != nil {
			return nil, fmt.Errorf(`jwe.Encrypt: failed to set "zip" in protected header: %w`, err)
		}
	}

	// If there's only one recipient, you want to include that in the
	// protected header
	if len(recipients) == 1 {
		h, err := protected.Merge(context.TODO(), recipients[0].Headers())
		if err != nil {
			return nil, fmt.Errorf(`jwe.Encrypt: failed to merge protected headers: %w`, err)
		}
		protected = h
	}

	aad, err := protected.Encode()
	if err != nil {
		return nil, fmt.Errorf(`failed to base64 encode protected headers: %w`, err)
	}

	iv, ciphertext, tag, err := contentcrypt.Encrypt(cek, payload, aad)
	if err != nil {
		return nil, fmt.Errorf(`failed to encrypt payload: %w`, err)
	}

	msg := NewMessage()

	if err := msg.Set(CipherTextKey, ciphertext); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, CipherTextKey, err)
	}
	if err := msg.Set(InitializationVectorKey, iv); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, InitializationVectorKey, err)
	}
	if err := msg.Set(ProtectedHeadersKey, protected); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, ProtectedHeadersKey, err)
	}
	if err := msg.Set(RecipientsKey, recipients); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, RecipientsKey, err)
	}
	if err := msg.Set(TagKey, tag); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, TagKey, err)
	}

	switch format {
	case fmtCompact:
		return Compact(msg)
	case fmtJSON:
		return json.Marshal(msg)
	case fmtJSONPretty:
		return json.MarshalIndent(msg, "", "  ")
	default:
		return nil, fmt.Errorf(`jwe.Encrypt: invalid serialization`)
	}
}

type decryptCtx struct {
	msg              *Message
	aad              []byte
	computedAad      []byte
	keyProviders     []KeyProvider
	protectedHeaders Headers
}

// Decrypt takes the key encryption algorithm and the corresponding
// key to decrypt the JWE message, and returns the decrypted payload.
// The JWE message can be either compact or full JSON format.
//
// `alg` accepts a `jwa.KeyAlgorithm` for convenience so you can directly pass
// the result of `(jwk.Key).Algorithm()`, but in practice it must be of type
// `jwa.KeyEncryptionAlgorithm` or otherwise it will cause an error.
//
// `key` must be a private key. It can be either in its raw format (e.g. *rsa.PrivateKey) or a jwk.Key
func Decrypt(buf []byte, options ...DecryptOption) ([]byte, error) {
	var keyProviders []KeyProvider
	var keyUsed interface{}

	var dst *Message
	//nolint:forcetypeassert
	for _, option := range options {
		switch option.Ident() {
		case identMessage{}:
			dst = option.Value().(*Message)
		case identKeyProvider{}:
			keyProviders = append(keyProviders, option.Value().(KeyProvider))
		case identKeyUsed{}:
			keyUsed = option.Value()
		case identKey{}:
			pair := option.Value().(*withKey)
			alg, ok := pair.alg.(jwa.KeyEncryptionAlgorithm)
			if !ok {
				return nil, fmt.Errorf(`WithKey() option must be specified using jwa.KeyEncryptionAlgorithm (got %T)`, pair.alg)
			}
			keyProviders = append(keyProviders, &staticKeyProvider{
				alg: alg,
				key: pair.key,
			})
		}
	}

	if len(keyProviders) < 1 {
		return nil, fmt.Errorf(`jwe.Decrypt: no key providers have been provided (see jwe.WithKey(), jwe.WithKeySet(), and jwe.WithKeyProvider()`)
	}

	msg, err := parseJSONOrCompact(buf, true)
	if err != nil {
		return nil, fmt.Errorf(`failed to parse buffer for Decrypt: %w`, err)
	}

	// Process things that are common to the message
	ctx := context.TODO()
	h, err := msg.protectedHeaders.Clone(ctx)
	if err != nil {
		return nil, fmt.Errorf(`failed to copy protected headers: %w`, err)
	}
	h, err = h.Merge(ctx, msg.unprotectedHeaders)
	if err != nil {
		return nil, fmt.Errorf(`failed to merge headers for message decryption: %w`, err)
	}

	var aad []byte
	if aadContainer := msg.authenticatedData; aadContainer != nil {
		aad = base64.Encode(aadContainer)
	}

	var computedAad []byte
	if len(msg.rawProtectedHeaders) > 0 {
		computedAad = msg.rawProtectedHeaders
	} else {
		// this is probably not required once msg.Decrypt is deprecated
		var err error
		computedAad, err = msg.protectedHeaders.Encode()
		if err != nil {
			return nil, fmt.Errorf(`failed to encode protected headers: %w`, err)
		}
	}

	// for each recipient, attempt to match the key providers
	// if we have no recipients, pretend like we only have one
	recipients := msg.recipients
	if len(recipients) == 0 {
		r := NewRecipient()
		if err := r.SetHeaders(msg.protectedHeaders); err != nil {
			return nil, fmt.Errorf(`failed to set headers to recipient: %w`, err)
		}
		recipients = append(recipients, r)
	}

	var dctx decryptCtx

	dctx.aad = aad
	dctx.computedAad = computedAad
	dctx.msg = msg
	dctx.keyProviders = keyProviders
	dctx.protectedHeaders = h

	var lastError error
	for _, recipient := range recipients {
		decrypted, err := dctx.try(ctx, recipient, keyUsed)
		if err != nil {
			lastError = err
			continue
		}
		if dst != nil {
			*dst = *msg
			dst.rawProtectedHeaders = nil
			dst.storeProtectedHeaders = false
		}
		return decrypted, nil
	}
	return nil, fmt.Errorf(`jwe.Decrypt: failed to decrypt any of the recipients (last error = %w)`, lastError)
}

func (dctx *decryptCtx) try(ctx context.Context, recipient Recipient, keyUsed interface{}) ([]byte, error) {
	var tried int
	var lastError error
	for i, kp := range dctx.keyProviders {
		var sink algKeySink
		if err := kp.FetchKeys(ctx, &sink, recipient, dctx.msg); err != nil {
			return nil, fmt.Errorf(`key provider %d failed: %w`, i, err)
		}

		for _, pair := range sink.list {
			tried++
			// alg is converted here because pair.alg is of type jwa.KeyAlgorithm.
			// this may seem ugly, but we're trying to avoid declaring separate
			// structs for `alg jwa.KeyAlgorithm` and `alg jwa.SignatureAlgorithm`
			//nolint:forcetypeassert
			alg := pair.alg.(jwa.KeyEncryptionAlgorithm)
			key := pair.key

			decrypted, err := dctx.decryptContent(ctx, alg, key, recipient)
			if err != nil {
				lastError = err
				continue
			}

			if keyUsed != nil {
				if err := blackmagic.AssignIfCompatible(keyUsed, key); err != nil {
					return nil, fmt.Errorf(`failed to assign used key (%T) to %T: %w`, key, keyUsed, err)
				}
			}
			return decrypted, nil
		}
	}
	return nil, fmt.Errorf(`jwe.Decrypt: tried %d keys, but failed to match any of the keys with recipient (last error = %s)`, tried, lastError)
}

func (dctx *decryptCtx) decryptContent(ctx context.Context, alg jwa.KeyEncryptionAlgorithm, key interface{}, recipient Recipient) ([]byte, error) {
	if jwkKey, ok := key.(jwk.Key); ok {
		var raw interface{}
		if err := jwkKey.Raw(&raw); err != nil {
			return nil, fmt.Errorf(`failed to retrieve raw key from %T: %w`, key, err)
		}
		key = raw
	}

	dec := newDecrypter(alg, dctx.msg.protectedHeaders.ContentEncryption(), key).
		AuthenticatedData(dctx.aad).
		ComputedAuthenticatedData(dctx.computedAad).
		InitializationVector(dctx.msg.initializationVector).
		Tag(dctx.msg.tag)

	if recipient.Headers().Algorithm() != alg {
		// algorithms don't match
		return nil, fmt.Errorf(`jwe.Decrypt: key and recipient algorithms do not match`)
	}

	h2, err := dctx.protectedHeaders.Clone(ctx)
	if err != nil {
		return nil, fmt.Errorf(`jwe.Decrypt: failed to copy headers (1): %w`, err)
	}

	h2, err = h2.Merge(ctx, recipient.Headers())
	if err != nil {
		return nil, fmt.Errorf(`failed to copy headers (2): %w`, err)
	}

	switch alg {
	case jwa.ECDH_ES, jwa.ECDH_ES_A128KW, jwa.ECDH_ES_A192KW, jwa.ECDH_ES_A256KW:
		epkif, ok := h2.Get(EphemeralPublicKeyKey)
		if !ok {
			return nil, fmt.Errorf(`failed to get 'epk' field`)
		}
		switch epk := epkif.(type) {
		case jwk.ECDSAPublicKey:
			var pubkey ecdsa.PublicKey
			if err := epk.Raw(&pubkey); err != nil {
				return nil, fmt.Errorf(`failed to get public key: %w`, err)
			}
			dec.PublicKey(&pubkey)
		case jwk.OKPPublicKey:
			var pubkey interface{}
			if err := epk.Raw(&pubkey); err != nil {
				return nil, fmt.Errorf(`failed to get public key: %w`, err)
			}
			dec.PublicKey(pubkey)
		default:
			return nil, fmt.Errorf("unexpected 'epk' type %T for alg %s", epkif, alg)
		}

		if apu := h2.AgreementPartyUInfo(); len(apu) > 0 {
			dec.AgreementPartyUInfo(apu)
		}
		if apv := h2.AgreementPartyVInfo(); len(apv) > 0 {
			dec.AgreementPartyVInfo(apv)
		}
	case jwa.A128GCMKW, jwa.A192GCMKW, jwa.A256GCMKW:
		ivB64, ok := h2.Get(InitializationVectorKey)
		if ok {
			ivB64Str, ok := ivB64.(string)
			if !ok {
				return nil, fmt.Errorf("unexpected type for 'iv': %T", ivB64)
			}
			iv, err := base64.DecodeString(ivB64Str)
			if err != nil {
				return nil, fmt.Errorf(`failed to b64-decode 'iv': %w`, err)
			}
			dec.KeyInitializationVector(iv)
		}
		tagB64, ok := h2.Get(TagKey)
		if ok {
			tagB64Str, ok := tagB64.(string)
			if !ok {
				return nil, fmt.Errorf("unexpected type for 'tag': %T", tagB64)
			}
			tag, err := base64.DecodeString(tagB64Str)
			if err != nil {
				return nil, fmt.Errorf(`failed to b64-decode 'tag': %w`, err)
			}
			dec.KeyTag(tag)
		}
	case jwa.PBES2_HS256_A128KW, jwa.PBES2_HS384_A192KW, jwa.PBES2_HS512_A256KW:
		saltB64, ok := h2.Get(SaltKey)
		if !ok {
			return nil, fmt.Errorf(`failed to get 'p2s' field`)
		}
		saltB64Str, ok := saltB64.(string)
		if !ok {
			return nil, fmt.Errorf("unexpected type for 'p2s': %T", saltB64)
		}

		count, ok := h2.Get(CountKey)
		if !ok {
			return nil, fmt.Errorf(`failed to get 'p2c' field`)
		}
		countFlt, ok := count.(float64)
		if !ok {
			return nil, fmt.Errorf("unexpected type for 'p2c': %T", count)
		}
		salt, err := base64.DecodeString(saltB64Str)
		if err != nil {
			return nil, fmt.Errorf(`failed to b64-decode 'salt': %w`, err)
		}
		dec.KeySalt(salt)
		dec.KeyCount(int(countFlt))
	}

	plaintext, err := dec.Decrypt(recipient, dctx.msg.cipherText, dctx.msg)
	if err != nil {
		return nil, fmt.Errorf(`jwe.Decrypt: decryption failed: %w`, err)
	}

	if h2.Compression() == jwa.Deflate {
		buf, err := uncompress(plaintext)
		if err != nil {
			return nil, fmt.Errorf(`jwe.Derypt: failed to uncompress payload: %w`, err)
		}
		plaintext = buf
	}

	if plaintext == nil {
		return nil, fmt.Errorf(`failed to find matching recipient`)
	}

	return plaintext, nil
}

// Parse parses the JWE message into a Message object. The JWE message
// can be either compact or full JSON format.
//
// Parse() currently does not take any options, but the API accepts it
// in anticipation of future addition.
func Parse(buf []byte, _ ...ParseOption) (*Message, error) {
	return parseJSONOrCompact(buf, false)
}

func parseJSONOrCompact(buf []byte, storeProtectedHeaders bool) (*Message, error) {
	buf = bytes.TrimSpace(buf)
	if len(buf) == 0 {
		return nil, fmt.Errorf(`empty buffer`)
	}

	if buf[0] == '{' {
		return parseJSON(buf, storeProtectedHeaders)
	}
	return parseCompact(buf, storeProtectedHeaders)
}

// ParseString is the same as Parse, but takes a string.
func ParseString(s string) (*Message, error) {
	return Parse([]byte(s))
}

// ParseReader is the same as Parse, but takes an io.Reader.
func ParseReader(src io.Reader) (*Message, error) {
	buf, err := io.ReadAll(src)
	if err != nil {
		return nil, fmt.Errorf(`failed to read from io.Reader: %w`, err)
	}
	return Parse(buf)
}

func parseJSON(buf []byte, storeProtectedHeaders bool) (*Message, error) {
	m := NewMessage()
	m.storeProtectedHeaders = storeProtectedHeaders
	if err := json.Unmarshal(buf, &m); err != nil {
		return nil, fmt.Errorf(`failed to parse JSON: %w`, err)
	}
	return m, nil
}

func parseCompact(buf []byte, storeProtectedHeaders bool) (*Message, error) {
	parts := bytes.Split(buf, []byte{'.'})
	if len(parts) != 5 {
		return nil, fmt.Errorf(`compact JWE format must have five parts (%d)`, len(parts))
	}

	hdrbuf, err := base64.Decode(parts[0])
	if err != nil {
		return nil, fmt.Errorf(`failed to parse first part of compact form: %w`, err)
	}

	protected := NewHeaders()
	if err := json.Unmarshal(hdrbuf, protected); err != nil {
		return nil, fmt.Errorf(`failed to parse header JSON: %w`, err)
	}

	ivbuf, err := base64.Decode(parts[2])
	if err != nil {
		return nil, fmt.Errorf(`failed to base64 decode iv: %w`, err)
	}

	ctbuf, err := base64.Decode(parts[3])
	if err != nil {
		return nil, fmt.Errorf(`failed to base64 decode content: %w`, err)
	}

	tagbuf, err := base64.Decode(parts[4])
	if err != nil {
		return nil, fmt.Errorf(`failed to base64 decode tag: %w`, err)
	}

	m := NewMessage()
	if err := m.Set(CipherTextKey, ctbuf); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, CipherTextKey, err)
	}
	if err := m.Set(InitializationVectorKey, ivbuf); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, InitializationVectorKey, err)
	}
	if err := m.Set(ProtectedHeadersKey, protected); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, ProtectedHeadersKey, err)
	}

	if err := m.makeDummyRecipient(string(parts[1]), protected); err != nil {
		return nil, fmt.Errorf(`failed to setup recipient: %w`, err)
	}

	if err := m.Set(TagKey, tagbuf); err != nil {
		return nil, fmt.Errorf(`failed to set %s: %w`, TagKey, err)
	}

	if storeProtectedHeaders {
		// This is later used for decryption.
		m.rawProtectedHeaders = parts[0]
	}

	return m, nil
}

// RegisterCustomField allows users to specify that a private field
// be decoded as an instance of the specified type. This option has
// a global effect.
//
// For example, suppose you have a custom field `x-birthday`, which
// you want to represent as a string formatted in RFC3339 in JSON,
// but want it back as `time.Time`.
//
// In that case you would register a custom field as follows
//
//	jwe.RegisterCustomField(`x-birthday`, timeT)
//
// Then `hdr.Get("x-birthday")` will still return an `interface{}`,
// but you can convert its type to `time.Time`
//
//	bdayif, _ := hdr.Get(`x-birthday`)
//	bday := bdayif.(time.Time)
func RegisterCustomField(name string, object interface{}) {
	registry.Register(name, object)
}
