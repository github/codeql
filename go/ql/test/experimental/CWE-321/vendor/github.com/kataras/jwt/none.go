package jwt

import "bytes"

type algNONE struct{}

func (a *algNONE) Name() string {
	return "NONE"
}

func (a *algNONE) Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error) {
	return nil, nil
}

func (a *algNONE) Verify(key PublicKey, headerAndPayload []byte, signature []byte) error {
	if !bytes.Equal(signature, []byte{}) {
		return ErrTokenSignature
	}

	return nil
}
