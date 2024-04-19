package jwt

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
)

type algRSAPSS struct {
	name string
	opts *rsa.PSSOptions
}

func (a *algRSAPSS) Parse(private, public []byte) (privateKey PrivateKey, publicKey PublicKey, err error) {
	if len(private) > 0 {
		privateKey, err = ParsePrivateKeyRSA(private)
		if err != nil {
			return nil, nil, fmt.Errorf("RSA-PSS: private key: %v", err)
		}
	}

	if len(public) > 0 {
		publicKey, err = ParsePublicKeyRSA(public)
		if err != nil {
			return nil, nil, fmt.Errorf("RSA-PSS: public key: %v", err)
		}
	}

	return
}

func (a *algRSAPSS) Name() string {
	return a.name
}

func (a *algRSAPSS) Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error) {
	privateKey, ok := key.(*rsa.PrivateKey)
	if !ok {
		return nil, ErrInvalidKey
	}

	h := a.opts.Hash.New()
	// header.payload
	_, err := h.Write(headerAndPayload)
	if err != nil {
		return nil, err
	}

	hashed := h.Sum(nil)
	return rsa.SignPSS(rand.Reader, privateKey, a.opts.Hash, hashed, a.opts)
}

func (a *algRSAPSS) Verify(key PublicKey, headerAndPayload []byte, signature []byte) error {
	publicKey, ok := key.(*rsa.PublicKey)
	if !ok {
		if privateKey, ok := key.(*rsa.PrivateKey); ok {
			publicKey = &privateKey.PublicKey
		} else {
			return ErrInvalidKey
		}
	}

	h := a.opts.Hash.New()
	// header.payload
	_, err := h.Write(headerAndPayload)
	if err != nil {
		return err
	}

	hashed := h.Sum(nil)

	if err = rsa.VerifyPSS(publicKey, a.opts.Hash, hashed, signature, a.opts); err != nil {
		return fmt.Errorf("%w: %v", ErrTokenSignature, err)
	}

	return nil
}
