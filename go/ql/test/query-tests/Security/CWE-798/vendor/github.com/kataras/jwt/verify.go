package jwt

import (
	"encoding/json"
	"errors"
)

// Verify decodes, verifies and validates the standard JWT claims
// of the given "token" using the algorithm and
// the secret key that this token was generated with.
//
// It returns a VerifiedToken which can be used to
// read the standard claims and some read-only information about the token.
// That VerifiedToken contains a `Claims` method, useful
// to bind the token's payload(claims) to a custom Go struct or a map when necessary.
//
// The last variadic input argument is optional, can be used
// for further claims validations before exit.
// Returns the verified token information.
//
// Example Code:
//
//  verifiedToken, err := jwt.Verify(jwt.HS256, []byte("secret"), token)
//  [handle error...]
//  var claims map[string]interface{}
//  verifiedToken.Claims(&claims)
func Verify(alg Alg, key PublicKey, token []byte, validators ...TokenValidator) (*VerifiedToken, error) {
	return verifyToken(alg, key, nil, token, nil, validators...)
}

// VerifyEncrypted same as `Verify` but it decrypts the payload part with the given "decrypt" function.
// The "decrypt" function is called AFTER base64-decode and BEFORE Unmarshal.
// Look the `GCM` function for details.
func VerifyEncrypted(alg Alg, key PublicKey, decrypt InjectFunc, token []byte, validators ...TokenValidator) (*VerifiedToken, error) {
	return verifyToken(alg, key, decrypt, token, nil, validators...)
}

// VerifyWithHeaderValidator same as `Verify` but it accepts a custom header validator too.
func VerifyWithHeaderValidator(alg Alg, key PublicKey, token []byte, headerValidator HeaderValidator, validators ...TokenValidator) (*VerifiedToken, error) {
	return verifyToken(alg, key, nil, token, headerValidator, validators...)
}

// VerifyEncryptedWithHeaderValidator same as `VerifyEncrypted` but it accepts a custom header validator too.
func VerifyEncryptedWithHeaderValidator(alg Alg, key PublicKey, decrypt InjectFunc, token []byte, headerValidator HeaderValidator, validators ...TokenValidator) (*VerifiedToken, error) {
	return verifyToken(alg, key, decrypt, token, headerValidator, validators...)
}

func verifyToken(alg Alg, key PublicKey, decrypt InjectFunc, token []byte, headerValidator HeaderValidator, validators ...TokenValidator) (*VerifiedToken, error) {
	if len(token) == 0 {
		return nil, ErrMissing
	}

	header, payload, signature, err := decodeToken(alg, key, token, headerValidator)
	if err != nil {
		return nil, err
	}

	if decrypt != nil {
		payload, err = decrypt(payload)
		if err != nil {
			return nil, err
		}
	}

	var standardClaims Claims
	standardClaimsErr := json.Unmarshal(payload, &standardClaims) // Use the standard one instead of the custom, no need to support "required" feature here.
	// Do not exist on this error now, the payload may not be a JSON one.
	if standardClaimsErr != nil {
		var secondChange claimsSecondChance // try again with a different structure, which always converted to the standard jwt claims.
		if err = json.Unmarshal(payload, &secondChange); err != nil {
			err = errPayloadNotJSON // allow validators to catch this error.
		}

		standardClaims = secondChange.toClaims()
	} else {
		err = validateClaims(Clock(), standardClaims)
	}

	for _, validator := range validators {
		// A token validator can skip the builtin validation and return a nil error,
		// in that case the previous error is skipped.
		if err = validator.ValidateToken(token, standardClaims, err); err != nil {
			break
		}
	}

	if err != nil {
		// Exit on parsing standard claims error(when Plain is missing) or standard claims validation error or custom validators.
		return nil, err
	}

	verifiedTok := &VerifiedToken{
		Token:          token,
		Header:         header,
		Payload:        payload,
		Signature:      signature,
		StandardClaims: standardClaims,
		// We could store the standard claims error when Plain token validator is applied
		// but there is no a single case of its usability, so we don't, unless is requested.
	}
	return verifiedTok, nil
}

// VerifiedToken holds the information about a verified token.
// Look `Verify` for more.
type VerifiedToken struct {
	Token          []byte // The original token.
	Header         []byte // The header (decoded) part.
	Payload        []byte // The payload (decoded) part.
	Signature      []byte // The signature (decoded) part.
	StandardClaims Claims // Any standard claims extracted from the payload.
}

// Claims decodes the token's payload to the "dest".
// If the application requires custom claims, this is the method to Go.
//
// It calls the `Unmarshal(t.Payload, dest)` package-level function .
// When called, it decodes the token's payload (aka claims)
// to the "dest" pointer of a struct or map value.
// Note that the `StandardClaims` field is always set,
// as it contains the standard JWT claims,
// and validated at the `Verify` function itself,
// therefore NO FURTHER STEP is required
// to validate the "exp", "iat" and "nbf" claims.
func (t *VerifiedToken) Claims(dest interface{}) error {
	return Unmarshal(t.Payload, dest)
}

var errPayloadNotJSON = errors.New("jwt: payload is not a type of JSON") // malformed JSON or it's not a JSON at all.

// Plain can be provided as a Token Validator at `Verify` and `VerifyEncrypted` functions
// to allow tokens with plain payload (no JSON or malformed JSON) to be successfully validated.
//
// Usage:
//  verifiedToken, err := jwt.Verify(jwt.HS256, []byte("secret"), token, jwt.Plain)
//  [handle error...]
//  [verifiedToken.Payload...]
var Plain = TokenValidatorFunc(func(token []byte, standardClaims Claims, err error) error {
	if err == errPayloadNotJSON {
		return nil // skip this error entirely.
	}

	return err
})

type (
	// TokenValidator provides further token and claims validation.
	TokenValidator interface {
		// ValidateToken accepts the token, the claims extracted from that
		// and any error that may caused by claims validation (e.g. ErrExpired)
		// or the previous validator.
		// A token validator can skip the builtin validation and return a nil error.
		// Usage:
		//  func(v *myValidator) ValidateToken(token []byte, standardClaims Claims, err error) error {
		//    if err!=nil { return err } <- to respect the previous error
		//    // otherwise return nil or any custom error.
		//  }
		//
		// Look `Blocklist`, `Expected` and `Leeway` for builtin implementations.
		ValidateToken(token []byte, standardClaims Claims, err error) error
	}

	// TokenValidatorFunc is the interface-as-function shortcut for a TokenValidator.
	TokenValidatorFunc func(token []byte, standardClaims Claims, err error) error
)

// ValidateToken completes the ValidateToken interface.
// It calls itself.
func (fn TokenValidatorFunc) ValidateToken(token []byte, standardClaims Claims, err error) error {
	return fn(token, standardClaims, err)
}
