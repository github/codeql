package jwt

import (
	"crypto"
	_ "crypto/sha256" // to register a hash
	_ "crypto/sha512" // to register a hash
)

// Signer is used to sign tokens.
type Signer interface {
	Algorithm() Algorithm
	SignSize() int
	Sign(payload []byte) ([]byte, error)
}

// Verifier is used to verify tokens.
type Verifier interface {
	Algorithm() Algorithm
	Verify(payload, signature []byte) error
}

// Algorithm for signing and verifying.
type Algorithm string

func (a Algorithm) String() string { return string(a) }

// keySize of the algorithm's key (if exist). Is similar to Signer.SignSize.
func (a Algorithm) keySize() int { return algsKeySize[a] }

var algsKeySize = map[Algorithm]int{
	// for EdDSA private and public key have different sizes, so 0
	// for HS there is no limits for key size, so 0

	RS256: 256,
	RS384: 384,
	RS512: 512,

	ES256: 64,
	ES384: 96,
	ES512: 132,

	PS256: 256,
	PS384: 384,
	PS512: 512,
}

// Algorithm names for signing and verifying.
const (
	EdDSA Algorithm = "EdDSA"

	HS256 Algorithm = "HS256"
	HS384 Algorithm = "HS384"
	HS512 Algorithm = "HS512"

	RS256 Algorithm = "RS256"
	RS384 Algorithm = "RS384"
	RS512 Algorithm = "RS512"

	ES256 Algorithm = "ES256"
	ES384 Algorithm = "ES384"
	ES512 Algorithm = "ES512"

	PS256 Algorithm = "PS256"
	PS384 Algorithm = "PS384"
	PS512 Algorithm = "PS512"
)

func hashPayload(hash crypto.Hash, payload []byte) ([]byte, error) {
	hasher := hash.New()

	_, err := hasher.Write(payload)
	if err != nil {
		return nil, err
	}
	signed := hasher.Sum(nil)
	return signed, nil
}

func constTimeAlgEqual(a, b Algorithm) bool {
	return constTimeEqual(a.String(), b.String())
}
