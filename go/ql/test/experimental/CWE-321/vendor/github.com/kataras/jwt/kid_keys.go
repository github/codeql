package jwt

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"time"
)

var (
	// ErrEmptyKid fires when the header is missing a "kid" field.
	ErrEmptyKid = errors.New("jwt: kid is empty")
	// ErrUnknownKid fires when the header has a "kid" field
	// but does not match with any of the registered ones.
	ErrUnknownKid = errors.New("jwt: unknown kid")
)

type (
	// HeaderWithKid represents a simple header part which
	// holds the "kid" and "alg" fields.
	HeaderWithKid struct {
		Kid string `json:"kid"`
		Alg string `json:"alg"`
	}

	// Key holds the Go parsed key pairs.
	// This package has all the helpers you need to parse
	// a file or a string to go crypto keys,
	// e.g. `ParsePublicKeyRSA` and `ParsePrivateKeyRSA` package-level functions.
	Key struct {
		ID      string
		Alg     Alg
		Public  PublicKey
		Private PrivateKey
		MaxAge  time.Duration // optional.
		Encrypt InjectFunc    // optional.
		Decrypt InjectFunc    // optional.
	}

	// Keys is a map which holds the key id and a key pair.
	// User should initialize the keys once, not safe for concurrent writes.
	// See its `SignToken`, `VerifyToken` and `ValidateHeader` methods.
	// Usage:
	//  var keys jwt.Keys
	//  keys.Register("api", jwt.RS256, apiPubKey, apiPrivKey)
	//  keys.Register("cognito", jwt.RS256, cognitoPubKey, nil)
	//  ...
	//  token, err := keys.SignToken("api", myClaims{...}, jwt.MaxAge(15*time.Minute))
	//  ...
	//  var c myClaims
	//  err := keys.VerifyToken("api", token, &myClaims)
	//  }
	Keys map[string]*Key

	// KeysConfiguration for multiple keys sign and validate.
	// Look the MustLoad/Load method.
	//
	// Example at: _examples/multiple-kids.
	KeysConfiguration []struct {
		ID string `json:"id" yaml:"ID" toml:"ID" ini:"id"`
		// Alg declares the algorithm name.
		// Available values:
		//  * HS256
		//  * HS384
		//  * HS512
		//  * RS256
		//  * RS384
		//  * RS512
		//  * PS256
		//  * PS384
		//  * PS512
		//  * ES256
		//  * ES384
		//  * ES512
		//  * EdDSA
		Alg     string `json:"alg" yaml:"Alg" toml:"Alg" ini:"alg"`
		Private string `json:"private" yaml:"Private" toml:"Private" ini:"private"`
		Public  string `json:"public" yaml:"Public" toml:"Public" ini:"public"`
		// MaxAge sets the token expiration. It is optional.
		// If greater than zero then the MaxAge token validation
		// will be appended to the "VerifyToken" and the token is invalid
		// after expiration of its sign time.
		MaxAge time.Duration `json:"max_age" yaml:"MaxAge" toml:"MaxAge" ini:"max_age"`

		// EncryptionKey enables encryption on the generated token. It is optional.
		// Encryption using the Galois Counter mode of operation with
		// AES cipher symmetric-key cryptographic.
		//
		// The value should be the AES key,
		// either 16, 24, or 32 bytes to select
		// AES-128, AES-192, or AES-256.
		EncryptionKey string `json:"encryption_key" yaml:"EncryptionKey" toml:"EncryptionKey" ini:"encryption_key"`
	}
)

// MustLoad same as Load but it panics if errored.
func (c KeysConfiguration) MustLoad() Keys {
	keys, err := c.Load()
	if err != nil {
		panic(err)
	}

	return keys
}

// Load returns the keys parsed through the json, yaml, toml or ini configuration.
func (c KeysConfiguration) Load() (Keys, error) {
	parsedKeys := make(Keys, len(c))

	for _, entry := range c {
		alg := RS256

		for _, algo := range allAlgs {
			if strings.ToLower(algo.Name()) == strings.ToLower(entry.Alg) {
				alg = algo
				break
			}
		}

		p := &Key{
			ID:     entry.ID,
			Alg:    alg,
			MaxAge: entry.MaxAge,
		}

		if public, err := strconv.Unquote(entry.Public); err == nil {
			entry.Public = public
		}
		if private, err := strconv.Unquote(entry.Private); err == nil {
			entry.Private = private
		}

		if parser, ok := alg.(AlgParser); ok {
			var err error
			p.Private, p.Public, err = parser.Parse([]byte(entry.Private), []byte(entry.Public))
			if err != nil {
				return nil, fmt.Errorf("jwt: load keys: parse: %w", err)
			}
		} else {
			p.Private = entry.Private
			p.Public = entry.Public
		}

		if entry.EncryptionKey != "" {
			encrypt, decrypt, err := GCM([]byte(entry.EncryptionKey), nil)
			if err != nil {
				return nil, fmt.Errorf("jwt: load keys: build encryption: %w", err)
			}

			p.Encrypt = encrypt
			p.Decrypt = decrypt
		}

		parsedKeys[entry.ID] = p
	}

	return parsedKeys, nil
}

// Get returns the key based on its id.
func (keys Keys) Get(kid string) (*Key, bool) {
	k, ok := keys[kid]
	return k, ok
}

// Register registers a keypair to a unique identifier per key.
func (keys Keys) Register(alg Alg, kid string, pubKey PublicKey, privKey PrivateKey) {
	keys[kid] = &Key{
		ID:      kid,
		Alg:     alg,
		Public:  pubKey,
		Private: privKey,
	}
}

// ValidateHeader validates the given json header value (base64 decoded) based on the "keys".
// Keys structure completes the `HeaderValidator` interface.
func (keys Keys) ValidateHeader(alg string, headerDecoded []byte) (Alg, PublicKey, InjectFunc, error) {
	var h HeaderWithKid

	err := Unmarshal(headerDecoded, &h)
	if err != nil {
		return nil, nil, nil, err
	}

	if h.Kid == "" {
		return nil, nil, nil, ErrEmptyKid
	}

	key, ok := keys.Get(h.Kid)
	if !ok {
		return nil, nil, nil, ErrUnknownKid
	}

	if h.Alg != key.Alg.Name() {
		return nil, nil, nil, ErrTokenAlg
	}

	// If for some reason a specific alg was given by the caller then check that as well.
	if alg != "" && alg != h.Alg {
		return nil, nil, nil, ErrTokenAlg
	}

	return key.Alg, key.Public, key.Decrypt, nil
}

// SignToken signs the "claims" using the given "alg" based a specific key.
func (keys Keys) SignToken(kid string, claims interface{}, opts ...SignOption) ([]byte, error) {
	k, ok := keys.Get(kid)
	if !ok {
		return nil, ErrUnknownKid
	}

	if k.MaxAge > 0 {
		opts = append([]SignOption{MaxAge(k.MaxAge)}, opts...)
	}

	return SignEncryptedWithHeader(k.Alg, k.Private, k.Encrypt, claims, HeaderWithKid{
		Kid: kid,
		Alg: k.Alg.Name(),
	}, opts...)
}

// VerifyToken verifies the "token" using the given "alg" based on the registered public key(s)
// and sets the custom claims to the destination "claimsPtr".
func (keys Keys) VerifyToken(token []byte, claimsPtr interface{}, validators ...TokenValidator) error {
	verifiedToken, err := VerifyWithHeaderValidator(nil, nil, token, keys.ValidateHeader, validators...)
	if err != nil {
		return err
	}

	return verifiedToken.Claims(&claimsPtr)
}
