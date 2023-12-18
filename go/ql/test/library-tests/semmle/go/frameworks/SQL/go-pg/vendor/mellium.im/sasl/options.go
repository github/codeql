// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	"crypto/tls"
)

// An Option represents an input to a SASL state machine.
type Option func(*Negotiator)

func getOpts(n *Negotiator, o ...Option) {
	n.credentials = func() (username, password, identity []byte) {
		return
	}
	n.permissions = func(_ *Negotiator) bool {
		return false
	}
	for _, f := range o {
		f(n)
	}
}

// TLSState lets the state machine negotiate channel binding with a TLS session
// if supported by the underlying mechanism.
func TLSState(cs tls.ConnectionState) Option {
	return func(n *Negotiator) {
		n.tlsState = &cs
	}
}

// nonce overrides the nonce used for authentication attempts.
// This defaults to a random value and should not be changed.
func setNonce(v []byte) Option {
	return func(n *Negotiator) {
		n.nonce = v
	}
}

// RemoteMechanisms sets a list of mechanisms supported by the remote client or
// server with which the state machine will be negotiating.
// It is used to determine if the server supports channel binding.
func RemoteMechanisms(m ...string) Option {
	return func(n *Negotiator) {
		n.remoteMechanisms = m
	}
}

// Credentials provides the negotiator with a username and password to
// authenticate with and (optionally) an authorization identity.
// Identity will normally be left empty to act as the username.
// The Credentials function is called lazily and may be called multiple times by
// the mechanism.
// It is not memoized by the negotiator.
func Credentials(f func() (Username, Password, Identity []byte)) Option {
	return func(n *Negotiator) {
		n.credentials = f
	}
}
