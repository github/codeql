package jws

import (
	"context"
	"fmt"
	"net/url"
	"sync"

	"github.com/lestrrat-go/jwx/v2/jwa"
	"github.com/lestrrat-go/jwx/v2/jwk"
)

// KeyProvider is responsible for providing key(s) to sign or verify a payload.
// Multiple `jws.KeyProvider`s can be passed to `jws.Verify()` or `jws.Sign()`
//
// `jws.Sign()` can only accept static key providers via `jws.WithKey()`,
// while `jws.Verify()` can accept `jws.WithKey()`, `jws.WithKeySet()`,
// `jws.WithVerifyAuto()`, and `jws.WithKeyProvider()`.
//
// Understanding how this works is crucial to learn how this package works.
//
// `jws.Sign()` is straightforward: signatures are created for each
// provided key.
//
// `jws.Verify()` is a bit more involved, because there are cases you
// will want to compute/deduce/guess the keys that you would like to
// use for verification.
//
// The first thing that `jws.Verify()` does is to collect the
// KeyProviders from the option list that the user provided (presented in pseudocode):
//
//	keyProviders := filterKeyProviders(options)
//
// Then, remember that a JWS message may contain multiple signatures in the
// message. For each signature, we call on the KeyProviders to give us
// the key(s) to use on this signature:
//
//	for sig in msg.Signatures {
//	  for kp in keyProviders {
//	    kp.FetcKeys(ctx, sink, sig, msg)
//	    ...
//	  }
//	}
//
// The `sink` argument passed to the KeyProvider is a temporary storage
// for the keys (either a jwk.Key or a "raw" key). The `KeyProvider`
// is responsible for sending keys into the `sink`.
//
// When called, the `KeyProvider` created by `jws.WithKey()` sends the same key,
// `jws.WithKeySet()` sends keys that matches a particular `kid` and `alg`,
// `jws.WithVerifyAuto()` fetchs a JWK from the `jku` URL,
// and finally `jws.WithKeyProvider()` allows you to execute arbitrary
// logic to provide keys. If you are providing a custom `KeyProvider`,
// you should execute the necessary checks or retrieval of keys, and
// then send the key(s) to the sink:
//
//	sink.Key(alg, key)
//
// These keys are then retrieved and tried for each signature, until
// a match is found:
//
//	keys := sink.Keys()
//	for key in keys {
//	  if givenSignature == makeSignatre(key, payload, ...)) {
//	    return OK
//	  }
//	}
type KeyProvider interface {
	FetchKeys(context.Context, KeySink, *Signature, *Message) error
}

// KeySink is a data storage where `jws.KeyProvider` objects should
// send their keys to.
type KeySink interface {
	Key(jwa.SignatureAlgorithm, interface{})
}

type algKeyPair struct {
	alg jwa.KeyAlgorithm
	key interface{}
}

type algKeySink struct {
	mu   sync.Mutex
	list []algKeyPair
}

func (s *algKeySink) Key(alg jwa.SignatureAlgorithm, key interface{}) {
	s.mu.Lock()
	s.list = append(s.list, algKeyPair{alg, key})
	s.mu.Unlock()
}

type staticKeyProvider struct {
	alg jwa.SignatureAlgorithm
	key interface{}
}

func (kp *staticKeyProvider) FetchKeys(_ context.Context, sink KeySink, _ *Signature, _ *Message) error {
	sink.Key(kp.alg, kp.key)
	return nil
}

type keySetProvider struct {
	set                  jwk.Set
	requireKid           bool // true if `kid` must be specified
	useDefault           bool // true if the first key should be used iff there's exactly one key in set
	inferAlgorithm       bool // true if the algorithm should be inferred from key type
	multipleKeysPerKeyID bool // true if we should attempt to match multiple keys per key ID. if false we assume that only one key exists for a given key ID
}

func (kp *keySetProvider) selectKey(sink KeySink, key jwk.Key, sig *Signature, _ *Message) error {
	if usage := key.KeyUsage(); usage != "" && usage != jwk.ForSignature.String() {
		return nil
	}

	if v := key.Algorithm(); v.String() != "" {
		var alg jwa.SignatureAlgorithm
		if err := alg.Accept(v); err != nil {
			return fmt.Errorf(`invalid signature algorithm %s: %w`, key.Algorithm(), err)
		}

		sink.Key(alg, key)
		return nil
	}

	if kp.inferAlgorithm {
		algs, err := AlgorithmsForKey(key)
		if err != nil {
			return fmt.Errorf(`failed to get a list of signature methods for key type %s: %w`, key.KeyType(), err)
		}

		// bail out if the JWT has a `alg` field, and it doesn't match
		if tokAlg := sig.ProtectedHeaders().Algorithm(); tokAlg != "" {
			for _, alg := range algs {
				if tokAlg == alg {
					sink.Key(alg, key)
					return nil
				}
			}
			return fmt.Errorf(`algorithm in the message does not match any of the inferred algorithms`)
		}

		// Yes, you get to try them all!!!!!!!
		for _, alg := range algs {
			sink.Key(alg, key)
		}
		return nil
	}
	return nil
}

func (kp *keySetProvider) FetchKeys(_ context.Context, sink KeySink, sig *Signature, msg *Message) error {
	if kp.requireKid {
		wantedKid := sig.ProtectedHeaders().KeyID()
		if wantedKid == "" {
			// If the kid is NOT specified... kp.useDefault needs to be true, and the
			// JWKs must have exactly one key in it
			if !kp.useDefault {
				return fmt.Errorf(`failed to find matching key: no key ID ("kid") specified in token`)
			} else if kp.useDefault && kp.set.Len() > 1 {
				return fmt.Errorf(`failed to find matching key: no key ID ("kid") specified in token but multiple keys available in key set`)
			}

			// if we got here, then useDefault == true AND there is exactly
			// one key in the set.
			key, _ := kp.set.Key(0)
			return kp.selectKey(sink, key, sig, msg)
		}

		// Otherwise we better be able to look up the key.
		// <= v2.0.3 backwards compatible case: only match a single key
		// whose key ID matches `wantedKid`
		if !kp.multipleKeysPerKeyID {
			key, ok := kp.set.LookupKeyID(wantedKid)
			if !ok {
				return fmt.Errorf(`failed to find key with key ID %q in key set`, wantedKid)
			}
			return kp.selectKey(sink, key, sig, msg)
		}

		// if multipleKeysPerKeyID is true, we attempt all keys whose key ID matches
		// the wantedKey
		var ok bool
		for i := 0; i < kp.set.Len(); i++ {
			key, _ := kp.set.Key(i)
			if key.KeyID() != wantedKid {
				continue
			}

			if err := kp.selectKey(sink, key, sig, msg); err != nil {
				continue
			}
			ok = true
			// continue processing so that we try all keys with the same key ID
		}
		if !ok {
			return fmt.Errorf(`failed to find key with key ID %q in key set`, wantedKid)
		}
		return nil
	}

	// Otherwise just try all keys
	for i := 0; i < kp.set.Len(); i++ {
		key, _ := kp.set.Key(i)
		if err := kp.selectKey(sink, key, sig, msg); err != nil {
			continue
		}
	}
	return nil
}

type jkuProvider struct {
	fetcher jwk.Fetcher
	options []jwk.FetchOption
}

func (kp jkuProvider) FetchKeys(ctx context.Context, sink KeySink, sig *Signature, _ *Message) error {
	kid := sig.ProtectedHeaders().KeyID()
	if kid == "" {
		return fmt.Errorf(`use of "jku" requires that the payload contain a "kid" field in the protected header`)
	}

	// errors here can't be reliablly passed to the consumers.
	// it's unfortunate, but if you need this control, you are
	// going to have to write your own fetcher
	u := sig.ProtectedHeaders().JWKSetURL()
	if u == "" {
		return fmt.Errorf(`use of "jku" field specified, but the field is empty`)
	}
	uo, err := url.Parse(u)
	if err != nil {
		return fmt.Errorf(`failed to parse "jku": %w`, err)
	}
	if uo.Scheme != "https" {
		return fmt.Errorf(`url in "jku" must be HTTPS`)
	}

	set, err := kp.fetcher.Fetch(ctx, u, kp.options...)
	if err != nil {
		return fmt.Errorf(`failed to fetch %q: %w`, u, err)
	}

	key, ok := set.LookupKeyID(kid)
	if !ok {
		// It is not an error if the key with the kid doesn't exist
		return nil
	}

	algs, err := AlgorithmsForKey(key)
	if err != nil {
		return fmt.Errorf(`failed to get a list of signature methods for key type %s: %w`, key.KeyType(), err)
	}

	hdrAlg := sig.ProtectedHeaders().Algorithm()
	for _, alg := range algs {
		// if we have a "alg" field in the JWS, we can only proceed if
		// the inferred algorithm matches
		if hdrAlg != "" && hdrAlg != alg {
			continue
		}

		sink.Key(alg, key)
		break
	}
	return nil
}

// KeyProviderFunc is a type of KeyProvider that is implemented by
// a single function. You can use this to create ad-hoc `KeyProvider`
// instances.
type KeyProviderFunc func(context.Context, KeySink, *Signature, *Message) error

func (kp KeyProviderFunc) FetchKeys(ctx context.Context, sink KeySink, sig *Signature, msg *Message) error {
	return kp(ctx, sink, sig, msg)
}
