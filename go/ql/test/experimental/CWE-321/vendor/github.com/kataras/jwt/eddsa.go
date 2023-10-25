package jwt

import (
	"crypto/ed25519"
	"crypto/rand"
	"crypto/x509"
	"encoding/asn1"
	"encoding/pem"
	"errors"
	"fmt"
)

type algEdDSA struct {
	name string
}

func (a *algEdDSA) Parse(private, public []byte) (privateKey PrivateKey, publicKey PublicKey, err error) {
	if len(public) > 0 {
		publicKey, err = ParsePublicKeyEdDSA(public)
		if err != nil {
			if errors.Is(err, errPEMMalformed) {
				err = nil
				publicKey = ed25519.PublicKey(public)
			} else {
				return nil, nil, fmt.Errorf("EdDSA: public key: %v", err)
			}
		}
	}

	if len(private) > 0 {
		privateKey, err = ParsePrivateKeyEdDSA(private)
		if err != nil {
			if errors.Is(err, errPEMMalformed) {
				err = nil
				privateKey = ed25519.PrivateKey(private)
			} else {
				return nil, nil, fmt.Errorf("EdDSA: private key: %v", err)
			}
		}
	}

	return
}

func (a *algEdDSA) Name() string {
	return a.name
}

func (a *algEdDSA) Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error) {
	privateKey, ok := key.(ed25519.PrivateKey)
	if !ok {
		return nil, ErrInvalidKey
	}

	if len(privateKey) != ed25519.PrivateKeySize {
		return nil, ErrInvalidKey
	}

	return ed25519.Sign(privateKey, []byte(headerAndPayload)), nil
}

func (a *algEdDSA) Verify(key PublicKey, headerAndPayload []byte, signature []byte) error {
	publicKey, ok := key.(ed25519.PublicKey)
	if !ok {
		if privateKey, ok := key.(ed25519.PrivateKey); ok {
			publicKey = privateKey.Public().(ed25519.PublicKey)
		} else {
			return ErrInvalidKey
		}
	}

	if len(publicKey) != ed25519.PublicKeySize {
		return ErrInvalidKey
	}

	if !ed25519.Verify(publicKey, headerAndPayload, signature) {
		return ErrTokenSignature
	}

	return nil
}

// Key Helpers.

// MustLoadEdDSA accepts private and public PEM filenames
// and returns a pair of private and public ed25519 keys.
// Pass the returned private key to `Token` (signing) function
// and the public key to the `Verify` function.
//
// It panics on errors.
func MustLoadEdDSA(privateKeyFilename, publicKeyFilename string) (ed25519.PrivateKey, ed25519.PublicKey) {
	privateKey, err := LoadPrivateKeyEdDSA(privateKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	publicKey, err := LoadPublicKeyEdDSA(publicKeyFilename)
	if err != nil {
		panicHandler(err)
	}

	return privateKey, publicKey
}

// LoadPrivateKeyEdDSA accepts a file path of a PEM-encoded ed25519 private key
// and returns the ed25519 private key Go value.
// Pass the returned value to the `Token` (signing) function.
func LoadPrivateKeyEdDSA(filename string) (ed25519.PrivateKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePrivateKeyEdDSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// LoadPublicKeyEdDSA accepts a file path of a PEM-encoded ed25519 public key
// and returns the ed25519 public key Go value.
// Pass the returned value to the `Verify` function.
func LoadPublicKeyEdDSA(filename string) (ed25519.PublicKey, error) {
	b, err := ReadFile(filename)
	if err != nil {
		return nil, err
	}

	key, err := ParsePublicKeyEdDSA(b)
	if err != nil {
		return nil, err
	}

	return key, nil
}

// ParsePrivateKeyEdDSA decodes and parses the
// PEM-encoded ed25519 private key's raw contents.
// Pass the result to the `Token` (signing) function.
func ParsePrivateKeyEdDSA(key []byte) (ed25519.PrivateKey, error) {
	asn1PrivKey := struct {
		Version          int
		ObjectIdentifier struct {
			ObjectIdentifier asn1.ObjectIdentifier
		}
		PrivateKey []byte
	}{}

	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("private key: %w (EdDSA)", errPEMMalformed)
	}

	if _, err := asn1.Unmarshal(block.Bytes, &asn1PrivKey); err != nil {
		return nil, err
	}

	seed := asn1PrivKey.PrivateKey[2:]
	if l := len(seed); l != ed25519.SeedSize {
		return nil, fmt.Errorf("private key: bad seed length: %d", l)
	}

	privateKey := ed25519.NewKeyFromSeed(seed)
	return privateKey, nil
}

var errPEMMalformed = errors.New("pem malformed")

// ParsePublicKeyEdDSA decodes and parses the
// PEM-encoded ed25519 public key's raw contents.
// Pass the result to the `Verify` function.
func ParsePublicKeyEdDSA(key []byte) (ed25519.PublicKey, error) {
	asn1PubKey := struct {
		OBjectIdentifier struct {
			ObjectIdentifier asn1.ObjectIdentifier
		}
		PublicKey asn1.BitString
	}{}

	block, _ := pem.Decode(key)
	if block == nil {
		return nil, fmt.Errorf("public key: %w (EdDSA)", errPEMMalformed)
	}

	if _, err := asn1.Unmarshal(block.Bytes, &asn1PubKey); err != nil {
		return nil, err
	}

	publicKey := ed25519.PublicKey(asn1PubKey.PublicKey.Bytes)
	return publicKey, nil
}

// GenerateEdDSA generates random public and private keys for ed25519.
func GenerateEdDSA() (ed25519.PublicKey, ed25519.PrivateKey, error) {
	pub, priv, _ := ed25519.GenerateKey(rand.Reader)

	privBytes, err := x509.MarshalPKCS8PrivateKey(priv) // Convert a generated ed25519 key into a PEM block so that the ssh library can ingest it, bit round about tbh
	if err != nil {
		return nil, nil, err
	}
	privatePEM := pem.EncodeToMemory(
		&pem.Block{
			Type:  "PRIVATE KEY",
			Bytes: privBytes,
		},
	)

	pubBytes, err := x509.MarshalPKIXPublicKey(pub)
	if err != nil {
		return nil, nil, err
	}

	publicPEM := pem.EncodeToMemory(
		&pem.Block{
			Type:  "PUBLIC KEY",
			Bytes: pubBytes,
		})

	return publicPEM, privatePEM, nil
}
