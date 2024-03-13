package jwt

import (
	"errors"
	"fmt"
)

// Expected is a TokenValidator which performs simple checks
// between standard claims values.
//
// Usage:
//  expected := Expected{
//	  Issuer: "my-app",
//  }
//  verifiedToken, err := Verify(..., expected)
type Expected Claims // We could use the same Claims structure but for concept separation we use a different one.

var _ TokenValidator = Expected{}

// ErrExpected indicates a standard claims post-validation error.
// Usage:
//  verifiedToken, err := Verify(...)
//    if errors.Is(ErrExpected, err) {
//
//  }
var ErrExpected = errors.New("jwt: field not match")

// ValidateToken completes the TokenValidator interface.
// It performs simple checks against the expected "e" and the verified "c" claims.
// Can be passed at the Verify's last input argument.
//
// It returns a type of ErrExpected on validation failures.
func (e Expected) ValidateToken(token []byte, c Claims, err error) error {
	if err != nil {
		return err
	}

	if v := e.NotBefore; v > 0 {
		if v != c.NotBefore {
			return fmt.Errorf("%w: nbf", ErrExpected)
		}
	}

	if v := e.IssuedAt; v > 0 {
		if v != c.IssuedAt {
			return fmt.Errorf("%w: iat", ErrExpected)
		}
	}

	if v := e.Expiry; v > 0 {
		if v != c.Expiry {
			return fmt.Errorf("%w: exp", ErrExpected)
		}
	}

	if v := e.ID; v != "" {
		if v != c.ID {
			return fmt.Errorf("%w: jti", ErrExpected)
		}
	}

	if v := e.Issuer; v != "" {
		if v != c.Issuer {
			return fmt.Errorf("%w: iss", ErrExpected)
		}
	}

	if v := e.Subject; v != "" {
		if v != c.Subject {
			return fmt.Errorf("%w: sub", ErrExpected)
		}
	}

	if n := len(e.Audience); n > 0 {
		if n != len(c.Audience) {
			return fmt.Errorf("%w: aud (length)", ErrExpected)
		}

		for i := range c.Audience {
			if v := e.Audience[i]; v != c.Audience[i] {
				return fmt.Errorf("%w: aud (%q)", ErrExpected, v)
			}
		}
	}

	return nil
}
