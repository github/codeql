// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	/* #nosec */
	"crypto/sha1"
	"crypto/sha256"
	"errors"
)

// Define common errors used by SASL mechanisms and negotiators.
var (
	ErrInvalidState     = errors.New("invalid state")
	ErrInvalidChallenge = errors.New("invalid or missing challenge")
	ErrAuthn            = errors.New("authentication error")
	ErrTooManySteps     = errors.New("step called too many times")
)

var (
	// Plain is a Mechanism that implements the PLAIN authentication mechanism
	// as defined by RFC 4616.
	Plain Mechanism = plain

	// ScramSha256Plus is a Mechanism that implements the SCRAM-SHA-256-PLUS
	// authentication mechanism defined in RFC 7677.
	// The only supported channel binding types are tls-unique as defined in RFC
	// 5929 and tls-exporter defined in RFC 9266.
	ScramSha256Plus Mechanism = scram("SCRAM-SHA-256-PLUS", sha256.New)

	// ScramSha256 is a Mechanism that implements the SCRAM-SHA-256
	// authentication mechanism defined in RFC 7677.
	ScramSha256 Mechanism = scram("SCRAM-SHA-256", sha256.New)

	// ScramSha1Plus is a Mechanism that implements the SCRAM-SHA-1-PLUS
	// authentication mechanism defined in RFC 5802.
	// The only supported channel binding types are tls-unique as defined in RFC
	// 5929 and tls-exporter defined in RFC 9266.
	ScramSha1Plus Mechanism = scram("SCRAM-SHA-1-PLUS", sha1.New)

	// ScramSha1 is a Mechanism that implements the SCRAM-SHA-1 authentication
	// mechanism defined in RFC 5802.
	ScramSha1 Mechanism = scram("SCRAM-SHA-1", sha1.New)
)

// Mechanism represents a SASL mechanism that can be used by a Client or Server
// to perform the actual negotiation. Base64 encoding the final challenges and
// responses should not be performed by the mechanism.
//
// Mechanisms must be stateless and may be shared between goroutines. When a
// mechanism needs to store state between the different steps it can return
// anything that it needs to store and the value will be cached by the
// negotiator and passed in as the data parameter when the next challenge is
// received.
type Mechanism struct {
	Name  string
	Start func(n *Negotiator) (more bool, resp []byte, cache interface{}, err error)
	Next  func(n *Negotiator, challenge []byte, data interface{}) (more bool, resp []byte, cache interface{}, err error)
}
