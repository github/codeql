// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	"bytes"
)

var plainSep = []byte{0}

var plain = Mechanism{
	Name: "PLAIN",
	Start: func(m *Negotiator) (more bool, resp []byte, _ interface{}, err error) {
		username, password, identity := m.credentials()
		payload := make([]byte, 0, len(identity)+len(username)+len(password)+2)
		payload = append(payload, identity...)
		payload = append(payload, '\x00')
		payload = append(payload, username...)
		payload = append(payload, '\x00')
		payload = append(payload, password...)
		return false, payload, nil, nil
	},
	Next: func(m *Negotiator, challenge []byte, _ interface{}) (more bool, resp []byte, _ interface{}, err error) {
		// If we're a client, or we're a server that's past the AuthTextSent step,
		// we should never actually hit this step.
		if m.State()&Receiving != Receiving || m.State()&StepMask != AuthTextSent {
			err = ErrTooManySteps
			return
		}

		// If we're a server, validate that the challenge looks like:
		// "Identity\x00Username\x00Password"
		parts := bytes.Split(challenge, plainSep)
		if len(parts) != 3 {
			err = ErrInvalidChallenge
			return
		}

		if m.Permissions(Credentials(func() (Username, Password, Identity []byte) {
			return parts[1], parts[2], parts[0]
		})) {
			// Everything checks out as far as we know and the server should continue
			// to authenticate the user.
			return
		}

		err = ErrAuthn
		return
	},
}
