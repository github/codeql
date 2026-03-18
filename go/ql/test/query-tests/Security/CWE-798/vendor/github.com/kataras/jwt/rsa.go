package jwt

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"fmt"
)

type algRSA struct {
	name   string
	hasher crypto.Hash
}

func (a *algRSA) Parse(private, public []byte) (privateKey PrivateKey, publicKey PublicKey, err error) {
	if len(private) > 0 {
		privateKey, err = ParsePrivateKeyRSA(private)
		if err != nil {
			return nil, nil, fmt.Errorf("RSA: private key: %v", err)
		}
	}

	if len(public) > 0 {
		publicKey, err = ParsePublicKeyRSA(public)
		if err != nil {
			return nil, nil, fmt.Errorf("RSA: public key: %v", err)
		}
	}

	return
}

func (a *algRSA) Name() string {
	return a.name
}

func (a *algRSA) Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error) {
	privateKey, ok := key.(*rsa.PrivateKey)
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
	return rsa.SignPKCS1v15(rand.Reader, privateKey, a.hasher, hashed)
}

func (a *algRSA) Verify(key PublicKey, headerAndPayload []byte, signature []byte) error {
	publicKey, ok := key.(*rsa.PublicKey)
	if !ok {
		if privateKey, ok := key.(*rsa.PrivateKey); ok {
			publicKey = &privateKey.PublicKey
		} else {
			return ErrInvalidKey
		}
	}

	h := a.hasher.New()
	// header.payload
	_, err := h.Write(headerAndPayload)
	if err != nil {
		return err
	}

	hashed := h.Sum(nil)
	if err = rsa.VerifyPKCS1v15(publicKey, a.hasher, hashed, signature); err != nil {
		return fmt.Errorf("%w: %v", ErrTokenSignature, err)
	}

	return nil
}

// Key Helpers.

// MustLoadRSA accepts private and public PEM file paths
// and returns a pair of private and public RSA keys.
// Pass the returned private key to the `Token` (signing) function
// and the public key to the `Verify` function.
//
// It panics on errors.
func MustLoadRSA(privateKeyFilename, publicKeyFilename string) (*rsa.PrivateKey, *rsa.PublicKey) {
	privateKey, err := LoadPrivateKeyRSA(privateKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	publicKey, err := LoadPublicKeyRSA(publicKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	return privateKey, publicKey
}

// LoadPrivateKeyRSA accepts a file path of a PEM-encoded RSA private key
// and returns the RSA private key Go value.
// Pass the returned value to the `Token` (signing) function.
func LoadPrivateKeyRSA(filename string) (*rsa.PrivateKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePrivateKeyRSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// LoadPublicKeyRSA accepts a file path of a PEM-encoded RSA public key
// and returns the RSA public key Go value.
// Pass the returned value to the `Verify` function.
func LoadPublicKeyRSA(filename string) (*rsa.PublicKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePublicKeyRSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// ParsePrivateKeyRSA decodes and parses the
// PEM-encoded RSA private key's raw contents.
// Pass the result to the `Token` (signing) function.
func ParsePrivateKeyRSA(key []byte) (*rsa.PrivateKey, error) {
	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("private key: malformed or missing PEM format (RSA)")
	}

	privateKey, err := x509.ParsePKCS1PrivateKey(block.Bytes)
	if err != nil {
		if key, err := x509.ParsePKCS8PrivateKey(block.Bytes); err == nil {
			pKey, ok := key.(*rsa.PrivateKey)
			if !ok {
				return nil, fmt.Errorf("private key: expected a type of *rsa.PrivateKey")
			}

			privateKey = pKey
		} else {
			return nil, err
		}
	}

	return privateKey, nil
}

// ParsePublicKeyRSA decodes and parses the
// PEM-encoded RSA public key's raw contents.
// Pass the result to the `Verify` function.
func ParsePublicKeyRSA(key []byte) (*rsa.PublicKey, error) {
	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("public key: malformed or missing PEM format (RSA)")
	}

	parsedKey, err := x509.ParsePKIXPublicKey(block.Bytes)
	if err != nil {
		if cert, err := x509.ParseCertificate(block.Bytes); err == nil {
			parsedKey = cert.PublicKey
		} else {
			return nil, err
		}
	}

	publicKey, ok := parsedKey.(*rsa.PublicKey)
	if !ok {
		return nil, fmt.Errorf("public key: expected a type of *rsa.PublicKey")
	}

	return publicKey, nil
}
