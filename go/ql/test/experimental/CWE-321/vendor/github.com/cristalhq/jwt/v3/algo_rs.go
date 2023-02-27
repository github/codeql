package jwt

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
)

// NewSignerRS returns a new RSA-based signer.
func NewSignerRS(alg Algorithm, key *rsa.PrivateKey) (Signer, error) {
	if key == nil {
		return nil, ErrNilKey
	}
	hash, err := getHashRS(alg, key.Size())
	if err != nil {
		return nil, err
	}
	return &rsAlg{
		alg:        alg,
		hash:       hash,
		privateKey: key,
	}, nil
}

// NewVerifierRS returns a new RSA-based verifier.
func NewVerifierRS(alg Algorithm, key *rsa.PublicKey) (Verifier, error) {
	if key == nil {
		return nil, ErrNilKey
	}
	hash, err := getHashRS(alg, key.Size())
	if err != nil {
		return nil, err
	}
	return &rsAlg{
		alg:       alg,
		hash:      hash,
		publicKey: key,
	}, nil
}

func getHashRS(alg Algorithm, size int) (crypto.Hash, error) {
	var hash crypto.Hash
	switch alg {
	case RS256:
		hash = crypto.SHA256
	case RS384:
		hash = crypto.SHA384
	case RS512:
		hash = crypto.SHA512
	default:
		return 0, ErrUnsupportedAlg
	}
	return hash, nil
}

type rsAlg struct {
	alg        Algorithm
	hash       crypto.Hash
	publicKey  *rsa.PublicKey
	privateKey *rsa.PrivateKey
}

func (rs *rsAlg) Algorithm() Algorithm {
	return rs.alg
}

func (rs *rsAlg) SignSize() int {
	return rs.privateKey.Size()
}

func (rs *rsAlg) Sign(payload []byte) ([]byte, error) {
	digest, err := hashPayload(rs.hash, payload)
	if err != nil {
		return nil, err
	}

	signature, errSign := rsa.SignPKCS1v15(rand.Reader, rs.privateKey, rs.hash, digest)
	if errSign != nil {
		return nil, errSign
	}
	return signature, nil
}

func (rs *rsAlg) VerifyToken(token *Token) error {
	if constTimeAlgEqual(token.Header().Algorithm, rs.alg) {
		return rs.Verify(token.Payload(), token.Signature())
	}
	return ErrAlgorithmMismatch
}

func (rs *rsAlg) Verify(payload, signature []byte) error {
	digest, err := hashPayload(rs.hash, payload)
	if err != nil {
		return err
	}

	errVerify := rsa.VerifyPKCS1v15(rs.publicKey, rs.hash, digest, signature)
	if errVerify != nil {
		return ErrInvalidSignature
	}
	return nil
}
