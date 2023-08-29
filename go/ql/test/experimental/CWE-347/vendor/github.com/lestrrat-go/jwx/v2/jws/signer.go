package jws

import (
	"fmt"
	"sync"

	"github.com/lestrrat-go/jwx/v2/jwa"
)

type SignerFactory interface {
	Create() (Signer, error)
}
type SignerFactoryFn func() (Signer, error)

func (fn SignerFactoryFn) Create() (Signer, error) {
	return fn()
}

var muSignerDB sync.RWMutex
var signerDB map[jwa.SignatureAlgorithm]SignerFactory

// RegisterSigner is used to register a factory object that creates
// Signer objects based on the given algorithm.
//
// For example, if you would like to provide a custom signer for
// jwa.EdDSA, use this function to register a `SignerFactory`
// (probably in your `init()`)
//
// Unlike the `UnregisterSigner` function, this function automatically
// calls `jwa.RegisterSignatureAlgorithm` to register the algorithm
// in the known algorithms database.
func RegisterSigner(alg jwa.SignatureAlgorithm, f SignerFactory) {
	jwa.RegisterSignatureAlgorithm(alg)
	muSignerDB.Lock()
	signerDB[alg] = f
	muSignerDB.Unlock()
}

// UnregisterSigner removes the signer factory associated with
// the given algorithm.
//
// Note that when you call this function, the algorithm itself is
// not automatically unregistered from the known algorithms database.
// This is because the algorithm may still be required for verification or
// some other operation (however unlikely, it is still possible).
// Therefore, in order to completely remove the algorithm, you must
// call `jwa.UnregisterSignatureAlgorithm` yourself.
func UnregisterSigner(alg jwa.SignatureAlgorithm) {
	muSignerDB.Lock()
	delete(signerDB, alg)
	muSignerDB.Unlock()
}

func init() {
	signerDB = make(map[jwa.SignatureAlgorithm]SignerFactory)

	for _, alg := range []jwa.SignatureAlgorithm{jwa.RS256, jwa.RS384, jwa.RS512, jwa.PS256, jwa.PS384, jwa.PS512} {
		RegisterSigner(alg, func(alg jwa.SignatureAlgorithm) SignerFactory {
			return SignerFactoryFn(func() (Signer, error) {
				return newRSASigner(alg), nil
			})
		}(alg))
	}

	for _, alg := range []jwa.SignatureAlgorithm{jwa.ES256, jwa.ES384, jwa.ES512, jwa.ES256K} {
		RegisterSigner(alg, func(alg jwa.SignatureAlgorithm) SignerFactory {
			return SignerFactoryFn(func() (Signer, error) {
				return newECDSASigner(alg), nil
			})
		}(alg))
	}

	for _, alg := range []jwa.SignatureAlgorithm{jwa.HS256, jwa.HS384, jwa.HS512} {
		RegisterSigner(alg, func(alg jwa.SignatureAlgorithm) SignerFactory {
			return SignerFactoryFn(func() (Signer, error) {
				return newHMACSigner(alg), nil
			})
		}(alg))
	}

	RegisterSigner(jwa.EdDSA, SignerFactoryFn(func() (Signer, error) {
		return newEdDSASigner(), nil
	}))
}

// NewSigner creates a signer that signs payloads using the given signature algorithm.
func NewSigner(alg jwa.SignatureAlgorithm) (Signer, error) {
	muSignerDB.RLock()
	f, ok := signerDB[alg]
	muSignerDB.RUnlock()

	if ok {
		return f.Create()
	}
	return nil, fmt.Errorf(`unsupported signature algorithm "%s"`, alg)
}

type noneSigner struct{}

func (noneSigner) Algorithm() jwa.SignatureAlgorithm {
	return jwa.NoSignature
}

func (noneSigner) Sign([]byte, interface{}) ([]byte, error) {
	return nil, nil
}
