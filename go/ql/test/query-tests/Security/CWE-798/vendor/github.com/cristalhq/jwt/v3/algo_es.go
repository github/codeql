package jwt

import (
	"crypto"
	"crypto/ecdsa"
	"crypto/rand"
	"math/big"
)

// NewSignerES returns a new ECDSA-based signer.
func NewSignerES(alg Algorithm, key *ecdsa.PrivateKey) (Signer, error) {
	if key == nil {
		return nil, ErrNilKey
	}
	hash, err := getParamsES(alg, roundBytes(key.PublicKey.Params().BitSize)*2)
	if err != nil {
		return nil, err
	}
	return &esAlg{
		alg:        alg,
		hash:       hash,
		privateKey: key,
		signSize:   roundBytes(key.PublicKey.Params().BitSize) * 2,
	}, nil
}

// NewVerifierES returns a new ECDSA-based verifier.
func NewVerifierES(alg Algorithm, key *ecdsa.PublicKey) (Verifier, error) {
	if key == nil {
		return nil, ErrNilKey
	}
	hash, err := getParamsES(alg, roundBytes(key.Params().BitSize)*2)
	if err != nil {
		return nil, err
	}
	return &esAlg{
		alg:       alg,
		hash:      hash,
		publicKey: key,
		signSize:  roundBytes(key.Params().BitSize) * 2,
	}, nil
}

func getParamsES(alg Algorithm, size int) (crypto.Hash, error) {
	var hash crypto.Hash
	switch alg {
	case ES256:
		hash = crypto.SHA256
	case ES384:
		hash = crypto.SHA384
	case ES512:
		hash = crypto.SHA512
	default:
		return 0, ErrUnsupportedAlg
	}

	if alg.keySize() != size {
		return 0, ErrInvalidKey
	}
	return hash, nil
}

type esAlg struct {
	alg        Algorithm
	hash       crypto.Hash
	publicKey  *ecdsa.PublicKey
	privateKey *ecdsa.PrivateKey
	signSize   int
}

func (es *esAlg) Algorithm() Algorithm {
	return es.alg
}

func (es *esAlg) SignSize() int {
	return es.signSize
}

func (es *esAlg) Sign(payload []byte) ([]byte, error) {
	digest, err := hashPayload(es.hash, payload)
	if err != nil {
		return nil, err
	}

	r, s, errSign := ecdsa.Sign(rand.Reader, es.privateKey, digest)
	if err != nil {
		return nil, errSign
	}

	pivot := es.SignSize() / 2

	rBytes, sBytes := r.Bytes(), s.Bytes()
	signature := make([]byte, es.SignSize())
	copy(signature[pivot-len(rBytes):], rBytes)
	copy(signature[pivot*2-len(sBytes):], sBytes)
	return signature, nil
}

func (es *esAlg) VerifyToken(token *Token) error {
	if constTimeAlgEqual(token.Header().Algorithm, es.alg) {
		return es.Verify(token.Payload(), token.Signature())
	}
	return ErrAlgorithmMismatch
}

func (es *esAlg) Verify(payload, signature []byte) error {
	if len(signature) != es.SignSize() {
		return ErrInvalidSignature
	}

	digest, err := hashPayload(es.hash, payload)
	if err != nil {
		return err
	}

	pivot := es.SignSize() / 2
	r := big.NewInt(0).SetBytes(signature[:pivot])
	s := big.NewInt(0).SetBytes(signature[pivot:])

	if !ecdsa.Verify(es.publicKey, digest, r, s) {
		return ErrInvalidSignature
	}
	return nil
}

func roundBytes(n int) int {
	res := n / 8
	if n%8 > 0 {
		return res + 1
	}
	return res
}
