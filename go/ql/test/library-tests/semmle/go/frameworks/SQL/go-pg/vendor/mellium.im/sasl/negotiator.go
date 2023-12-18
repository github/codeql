// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	"crypto/rand"
	"crypto/tls"
	"strings"
)

// State represents the current state of a Negotiator.
// The first two bits represent the actual state of the state machine and the
// last 3 bits are a bitmask that define the machines behavior.
// The remaining bits should not be used.
type State uint8

// The current step of the Server or Client (represented by the first two bits
// of the state byte).
const (
	Initial State = iota
	AuthTextSent
	ResponseSent
	ValidServerResponse

	// Bitmask used for extracting the step from the state byte.
	StepMask = 0x3
)

const (
	// RemoteCB bit is on if the remote client or server supports channel binding.
	RemoteCB State = 1 << (iota + 3)

	// Errored bit is on if the machine has errored.
	Errored

	// Receiving bit is on if the machine is a server.
	Receiving
)

// NewClient creates a new SASL Negotiator that supports creating authentication
// requests using the given mechanism.
func NewClient(m Mechanism, opts ...Option) *Negotiator {
	machine := &Negotiator{
		mechanism: m,
	}
	getOpts(machine, opts...)
	for _, rname := range machine.remoteMechanisms {
		lname := m.Name
		if lname == rname && strings.HasSuffix(lname, "-PLUS") {
			machine.state |= RemoteCB
			break
		}
	}
	if len(machine.nonce) == 0 {
		machine.nonce = nonce(noncerandlen, rand.Reader)
	}
	return machine
}

// NewServer creates a new SASL Negotiator that supports receiving
// authentication requests using the given mechanism.
// A nil permissions function is the same as a function that always returns
// false.
func NewServer(m Mechanism, permissions func(*Negotiator) bool, opts ...Option) *Negotiator {
	machine := &Negotiator{
		mechanism: m,
		state:     AuthTextSent | Receiving,
	}
	getOpts(machine, opts...)
	if permissions != nil {
		machine.permissions = permissions
	}
	for _, rname := range machine.remoteMechanisms {
		lname := m.Name
		if lname == rname && strings.HasSuffix(lname, "-PLUS") {
			machine.state |= RemoteCB
			break
		}
	}
	if len(machine.nonce) == 0 {
		machine.nonce = nonce(noncerandlen, rand.Reader)
	}
	return machine
}

// A Negotiator represents a SASL client or server state machine that can
// attempt to negotiate auth. Negotiators should not be used from multiple
// goroutines, and must be reset between negotiation attempts.
type Negotiator struct {
	tlsState         *tls.ConnectionState
	remoteMechanisms []string
	credentials      func() (Username, Password, Identity []byte)
	permissions      func(*Negotiator) bool
	mechanism        Mechanism
	state            State
	nonce            []byte
	cache            interface{}
}

// Nonce returns a unique nonce that is reset for each negotiation attempt. It
// is used by SASL Mechanisms and should generally not be called directly.
func (c *Negotiator) Nonce() []byte {
	return c.nonce
}

// Step attempts to transition the state machine to its next state. If Step is
// called after a previous invocation generates an error (and the state machine
// has not been reset to its initial state), Step panics.
func (c *Negotiator) Step(challenge []byte) (more bool, resp []byte, err error) {
	if c.state&Errored == Errored {
		panic("sasl: Step called on a SASL state machine that has errored")
	}
	defer func() {
		if err != nil {
			c.state |= Errored
		}
	}()

	switch c.state & StepMask {
	case Initial:
		more, resp, c.cache, err = c.mechanism.Start(c)
		c.state = c.state&^StepMask | AuthTextSent
	case AuthTextSent:
		more, resp, c.cache, err = c.mechanism.Next(c, challenge, c.cache)
		c.state = c.state&^StepMask | ResponseSent
	case ResponseSent:
		more, resp, c.cache, err = c.mechanism.Next(c, challenge, c.cache)
		c.state = c.state&^StepMask | ValidServerResponse
	case ValidServerResponse:
		more, resp, c.cache, err = c.mechanism.Next(c, challenge, c.cache)
	}

	if err != nil {
		return false, nil, err
	}

	return more, resp, err
}

// State returns the internal state of the SASL state machine.
func (c *Negotiator) State() State {
	return c.state
}

// Reset resets the state machine to its initial state so that it can be reused
// in another SASL exchange.
func (c *Negotiator) Reset() {
	c.state = c.state & (Receiving | RemoteCB)

	// Skip the start step for servers
	if c.state&Receiving == Receiving {
		c.state = c.state&^StepMask | AuthTextSent
	}

	c.nonce = nonce(noncerandlen, rand.Reader)
	c.cache = nil
}

// Credentials returns a username, and password for authentication and optional
// identity for authorization.
func (c *Negotiator) Credentials() (username, password, identity []byte) {
	if c.credentials != nil {
		return c.credentials()
	}
	return
}

// Permissions is the callback used by the server to authenticate the user.
func (c *Negotiator) Permissions(opts ...Option) bool {
	if c.permissions != nil {
		nn := *c
		getOpts(&nn, opts...)
		return c.permissions(&nn)
	}
	return false
}

// TLSState is the state of any TLS connections being used to negotiate SASL
// (it can be used for channel binding).
func (c *Negotiator) TLSState() *tls.ConnectionState {
	if c.tlsState != nil {
		return c.tlsState
	}
	return nil
}

// RemoteMechanisms is a list of mechanisms as advertised by the other side of a
// SASL negotiation.
func (c *Negotiator) RemoteMechanisms() []string {
	if c.remoteMechanisms != nil {
		return c.remoteMechanisms
	}
	return nil
}
