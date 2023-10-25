package jwt

import (
	"crypto"
	"crypto/rsa"
	_ "crypto/sha256" // ignore:lint
	_ "crypto/sha512"
	"errors"
)

var (
	// ErrTokenSignature indicates that the verification failed.
	ErrTokenSignature = errors.New("jwt: invalid token signature")
	// ErrInvalidKey indicates that an algorithm required secret key is not a valid type.
	ErrInvalidKey = errors.New("jwt: invalid key")
)

// Alg represents a signing and verifying algorithm.
type Alg interface {
	// Name should return the "alg" JWT field.
	Name() string
	// Sign should accept the private key given on jwt.Sign and
	// the base64-encoded header and payload data.
	// Should return the signature.
	Sign(key PrivateKey, headerAndPayload []byte) ([]byte, error)
	// Verify should verify the JWT "signature" (base64-decoded) against
	// the header and payload (base64-encoded).
	Verify(key PublicKey, headerAndPayload []byte, signature []byte) error
	// Note:
	// some signing algorithms may be asymmetric,
	// so we accept the headerAndPayload as it's, instead of a Sign's result.
}

// AlgParser is an optional interface that an "Alg" can complete
// so parsing keys can be easier to be found based on the algorithm used.
//
// See kid_keys.go.
type AlgParser interface {
	Parse(private, public []byte) (PrivateKey, PublicKey, error)
}

// The builtin signing available algorithms.
// Author's recommendation of choosing the best algorithm for your application:
// Already work with RSA public and private keys?
// Choose RSA(RS256/RS384/RS512/PS256/PS384/PS512) (length of produced token characters is bigger).
// If you need the separation between public and private key, choose ECDSA(ES256/ES384/ES512) or EdDSA.
// ECDSA and EdDSA produce smaller tokens than RSA.
// If you need performance and well-tested algorithm, choose HMAC(HS256/HS384/HS512).
// The basic difference between symmetric and an asymmetric algorithm
// is that symmetric uses one shared key for both signing and verifying,
// and the asymmetric uses private key for signing and a public key for verifying.
// In general, asymmetric data is more secure because it uses different keys
// for the signing and verifying process but it's slower than symmetric ones.
var (
	// None for unsecured JWTs.
	// An unsecured JWT may be fit for client-side use.
	// For instance, if the session ID is a hard-to-guess number, and
	// the rest of the data is only used by the client for constructing a
	// view, the use of a signature is superfluous.
	// This data can be used by a single-page web application
	// to construct a view with the "pretty" name for the user
	// without hitting the backend while he gets
	// redirected to his last visited page. Even if a malicious user
	// were to modify this data he or she would gain nothing.
	// Example payload:
	//  {
	//    "sub": "user123",
	//    "session": "ch72gsb320000udocl363eofy",
	//    "name": "Pretty Name",
	//    "lastpage": "/views/settings"
	//  }
	NONE Alg = &algNONE{}
	// HMAC-SHA signing algorithms.
	// Keys should be type of []byte.
	//
	// HMAC shared secrets, as used by JWTs, are optimized for speed.
	// This allows many sign/verify operations to be performed efficiently
	// but make brute force attacks easier. So, the length of the shared secret
	// for HS256/384/512 is of the utmost importance. In fact, JSON Web
	// Algorithms9 defines the minimum key length to be equal to the size in bits of the hash function
	// used along with the HMAC algorithm:
	// > A key of the same size as the hash output (for instance, 256 bits for "HS256") or larger
	// MUST be used with this algorithm.” - JSON Web Algorithms (RFC 7518), 3.2 HMAC with SHA-2 Functions.
	//
	// In other words, many passwords that could be used in other contexts are simply not good enough for
	// use with HMAC-signed JWTs. 256-bits equals 32 ASCII characters, so if you are using something
	// human readable, CONSIDER that number to be the MINIMUM number of characters to include in the
	// secret. Another good option is to switch to RS256 or other public-key algorithms, which are much
	// more robust and flexible. This is NOT SIMPLY A HYPOTHETICAL ATTACK, it has been shown that brute
	// force attacks for HS256 are simple enough to perform11 if the shared secret is too short.
	HS256 Alg = &algHMAC{"HS256", crypto.SHA256}
	HS384 Alg = &algHMAC{"HS384", crypto.SHA384}
	HS512 Alg = &algHMAC{"HS512", crypto.SHA512}
	// RSA signing algorithms.
	// Sign   key: *rsa.PrivateKey
	// Verify key: *rsa.PublicKey (or *rsa.PrivateKey with its PublicKey filled)
	//
	// Signing and verifying RS256 signed tokens is just as easy.
	// The only difference lies in the use of a private/public key pair rather than a shared secret.
	// There are many ways to create RSA keys.
	// OpenSSL is one of the most popular libraries for key creation and management.
	// Generate a private key:
	// $ openssl genpkey -algorithm rsa -out private_key.pem -pkeyopt rsa_keygen_bits:2048
	// Derive the public key from the private key:
	// $ openssl rsa -pubout -in private_key.pem -out public_key.pem
	RS256 Alg = &algRSA{"RS256", crypto.SHA256}
	RS384 Alg = &algRSA{"RS384", crypto.SHA384}
	RS512 Alg = &algRSA{"RS512", crypto.SHA512}
	// RSASSA-PSS signing algorithms.
	// Sign   key: *rsa.PrivateKey
	// Verify key: *rsa.PublicKey (or *rsa.PrivateKey with its PublicKey filled)
	//
	// RSASSA-PSS is another signature scheme with appendix based on RSA.
	// PSS stands for Probabilistic Signature Scheme, in contrast with the usual deterministic approach.
	// This scheme makes use of a cryptographically secure random number generator.
	// If a secure RNG is not available, the resulting signature and verification operations
	// provide a level of security comparable to deterministic approaches.
	// This way RSASSA-PSS results in a net improvement over PKCS v1.5 signatures
	//
	// Note that the OpenSSL generates different OIDs to protect
	// reusing the same key material for different cryptosystems.
	PS256 Alg = &algRSAPSS{"PS256", &rsa.PSSOptions{SaltLength: rsa.PSSSaltLengthAuto, Hash: crypto.SHA256}}
	PS384 Alg = &algRSAPSS{"PS384", &rsa.PSSOptions{SaltLength: rsa.PSSSaltLengthAuto, Hash: crypto.SHA384}}
	PS512 Alg = &algRSAPSS{"PS512", &rsa.PSSOptions{SaltLength: rsa.PSSSaltLengthAuto, Hash: crypto.SHA512}}
	// ECDSA signing algorithms.
	// Sign   key: *ecdsa.PrivateKey
	// Verify key: *ecdsa.PublicKey (or *ecdsa.PrivateKey with its PublicKey filled)
	//
	// 4.2.3 ES256: ECDSA using P-256/xxx and SHA-256/xxx
	// ECDSA algorithms also make use of public keys. The math behind the algorithm is different,
	// though, so the steps to generate the keys are different as well. The "P-256" in the name of this
	// algorithm tells us exactly which version of the algorithm to use.
	//
	// Generate a private key:
	// $ openssl ecparam -name prime256v1 -genkey -noout -out ecdsa_private_key.pem
	// Derive the public key from the private key:
	// $ openssl ec -in ecdsa_private_key.pem -pubout -out ecdsa_public_key.pem
	//
	// If you open these files you will note that there is much less data in them.
	// This is one of the benefits of ECDSA over RSA.
	// The generated files are in PEM format as well,
	// so simply pasting them in your source will suffice.
	// It generates a smaller token (almost 3 times less).
	ES256 Alg = &algECDSA{"ES256", crypto.SHA256, 32, 256}
	ES384 Alg = &algECDSA{"ES384", crypto.SHA384, 48, 384}
	ES512 Alg = &algECDSA{"ES512", crypto.SHA512, 66, 521}
	// Ed25519 Edwards-curve Digital Signature Algorithm.
	// The algorithm's name is: "EdDSA".
	// Sign   key: ed25519.PrivateKey
	// Verify key: ed25519.PublicKey
	// EdDSA uses small public keys (32 or 57 bytes)
	// and signatures (64 or 114 bytes) for Ed25519 and Ed448, respectively.
	// EdDSA provides similar performance with ECDSA, HMAC is still the fastest one.
	// It is fairly new algorithm, this has its benefits and its downsides.
	// Its standard library, which this jwt package use, added on go1.13.
	EdDSA Alg = &algEdDSA{"EdDSA"}

	allAlgs = []Alg{
		NONE,
		RS256,
		RS384,
		RS512,
		PS256,
		PS384,
		PS512,
		ES256,
		ES384,
		ES512,
		EdDSA,
	}
)
