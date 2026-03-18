package jwt

import (
	"crypto"
	"crypto/ecdsa"
	"crypto/rand"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"math/big"
)

type algECDSA struct {
	name      string
	hasher    crypto.Hash
	keySize   int
	curveBits int
}

func (a *algECDSA) Parse(private, public []byte) (privateKey PrivateKey, publicKey PublicKey, err error) {
	if len(private) > 0 {
		privateKey, err = ParsePrivateKeyECDSA(private)
		if err != nil {
			return nil, nil, fmt.Errorf("ECDSA: private key: %v", err)
		}
	}

	if len(public) > 0 {
		publicKey, err = ParsePublicKeyECDSA(public)
		if err != nil {
			return nil, nil, fmt.Errorf("ECDSA: public key: %v", err)
		}
	}

	return
}

func (a *algECDSA) Name() string {
	return a.name
}

// JWT handbook chapter 7.2.2.3.1 Algorithm
// The following code is a clone of the js code described in the book.
func (a *algECDSA) Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error) {
	privateKey, ok := key.(*ecdsa.PrivateKey)
	if !ok {
		return nil, ErrInvalidKey
	}

	h := a.hasher.New()
	// header.payload
	_, err := h.Write(headerAndPayload)
	if err != nil {
		return nil, err
	}

	hashed := h.Sum(nil)
	r, s, err := ecdsa.Sign(rand.Reader, privateKey, hashed)
	if err != nil {
		return nil, err
	}

	curveBits := privateKey.Curve.Params().BitSize
	if a.curveBits != curveBits {
		return nil, ErrInvalidKey
	}

	keyBytes := curveBits / 8
	if curveBits%8 > 0 {
		keyBytes++
	}

	rBytes := r.Bytes()
	rBytesPadded := make([]byte, keyBytes)
	copy(rBytesPadded[keyBytes-len(rBytes):], rBytes)

	sBytes := s.Bytes()
	sBytesPadded := make([]byte, keyBytes)
	copy(sBytesPadded[keyBytes-len(sBytes):], sBytes)

	signature := append(rBytesPadded, sBytesPadded...)
	return signature, nil
}

func (a *algECDSA) Verify(key PublicKey, headerAndPayload []byte, signature []byte) error {
	publicKey, ok := key.(*ecdsa.PublicKey)
	if !ok {
		if privateKey, ok := key.(*ecdsa.PrivateKey); ok {
			publicKey = &privateKey.PublicKey
		} else {
			return ErrInvalidKey
		}
	}

	if len(signature) != 2*a.keySize {
		return ErrTokenSignature
	}

	r := big.NewInt(0).SetBytes(signature[:a.keySize])
	s := big.NewInt(0).SetBytes(signature[a.keySize:])

	h := a.hasher.New()
	// header.payload
	_, err := h.Write(headerAndPayload)
	if err != nil {
		return err
	}

	hashed := h.Sum(nil)
	if !ecdsa.Verify(publicKey, hashed, r, s) {
		return ErrTokenSignature
	}

	return nil
}

// Key Helpers.

// MustLoadECDSA accepts private and public PEM filenames
// and returns a pair of private and public ECDSA keys.
// Pass the returned private key to the `Token` (signing) function
// and the public key to the `Verify` function.
//
// It panics on errors.
func MustLoadECDSA(privateKeyFilename, publicKeyFilename string) (*ecdsa.PrivateKey, *ecdsa.PublicKey) {
	privateKey, err := LoadPrivateKeyECDSA(privateKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	publicKey, err := LoadPublicKeyECDSA(publicKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	return privateKey, publicKey
}

// LoadPrivateKeyECDSA accepts a file path of a PEM-encoded ECDSA private key
// and returns the ECDSA private key Go value.
// Pass the returned value to the `Token` (signing) function.
func LoadPrivateKeyECDSA(filename string) (*ecdsa.PrivateKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePrivateKeyECDSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// LoadPublicKeyECDSA accepts a file path of a PEM-encoded ECDSA public key
// and returns the ECDSA public key Go value.
// Pass the returned value to the `Verify` function.
func LoadPublicKeyECDSA(filename string) (*ecdsa.PublicKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePublicKeyECDSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// ParsePrivateKeyECDSA decodes and parses the
// PEM-encoded ECDSA private key's raw contents.
// Pass the result to the `Token` (signing) function.
func ParsePrivateKeyECDSA(key []byte) (*ecdsa.PrivateKey, error) {
	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("private key: malformed or missing PEM format (ECDSA)")
	}

	return x509.ParseECPrivateKey(block.Bytes)
}

// ParsePublicKeyECDSA decodes and parses the
// PEM-encoded ECDSA public key's raw contents.
// Pass the result to the `Verify` function.
func ParsePublicKeyECDSA(key []byte) (*ecdsa.PublicKey, error) {
	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("public key: malformed or missing PEM format (ECDSA)")
	}

	parsedKey, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		if cert, err := x509.ParseCertificate(block.Bytes); err == nil {
			parsedKey = cert.PublicKey
		} else {
			return nil, err
		}
	}

	publicKey, ok := parsedKey.(*ecdsa.PublicKey)
	if !ok {
		return nil, fmt.Errorf("public key: malformed or missing PEM format (ECDSA)")
	}

	return publicKey, nil
}
