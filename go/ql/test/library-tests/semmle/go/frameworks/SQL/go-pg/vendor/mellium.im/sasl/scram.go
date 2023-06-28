// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

package sasl

import (
	"bytes"
	"crypto/hmac"
	"crypto/tls"
	"encoding/base64"
	"errors"
	"hash"
	"strconv"
	"strings"

	"golang.org/x/crypto/pbkdf2"
)

const (
	exporterLen                = 32
	exporterLabel              = "EXPORTER-Channel-Binding"
	gs2HeaderCBSupportUnique   = "p=tls-unique,"
	gs2HeaderCBSupportExporter = "p=tls-exporter,"
	gs2HeaderNoServerCBSupport = "y,"
	gs2HeaderNoCBSupport       = "n,"
)

var (
	clientKeyInput = []byte("Client Key")
	serverKeyInput = []byte("Server Key")
)

// The number of random bytes to generate for a nonce.
const noncerandlen = 16

func getGS2Header(name string, n *Negotiator) (gs2Header []byte) {
	_, _, identity := n.Credentials()
	tlsState := n.TLSState()
	switch {
	case tlsState == nil || !strings.HasSuffix(name, "-PLUS"):
		// We do not support channel binding
		gs2Header = []byte(gs2HeaderNoCBSupport)
	case n.State()&RemoteCB == RemoteCB:
		// We support channel binding and the server does too
		if tlsState.Version >= tls.VersionTLS13 {
			gs2Header = []byte(gs2HeaderCBSupportExporter)
		} else {
			gs2Header = []byte(gs2HeaderCBSupportUnique)
		}
	case n.State()&RemoteCB != RemoteCB:
		// We support channel binding but the server does not
		gs2Header = []byte(gs2HeaderNoServerCBSupport)
	}
	if len(identity) > 0 {
		gs2Header = append(gs2Header, []byte(`a=`)...)
		gs2Header = append(gs2Header, identity...)
	}
	gs2Header = append(gs2Header, ',')
	return
}

func scram(name string, fn func() hash.Hash) Mechanism {
	// BUG(ssw): We need a way to cache the SCRAM client and server key
	// calculations.
	return Mechanism{
		Name: name,
		Start: func(m *Negotiator) (bool, []byte, interface{}, error) {
			user, _, _ := m.Credentials()

			// Escape "=" and ",". This is mostly the same as bytes.Replace but
			// faster because we can do both replacements in a single pass.
			n := bytes.Count(user, []byte{'='}) + bytes.Count(user, []byte{','})
			username := make([]byte, len(user)+(n*2))
			w := 0
			start := 0
			for i := 0; i < n; i++ {
				j := start
				j += bytes.IndexAny(user[start:], "=,")
				w += copy(username[w:], user[start:j])
				switch user[j] {
				case '=':
					w += copy(username[w:], "=3D")
				case ',':
					w += copy(username[w:], "=2C")
				}
				start = j + 1
			}
			copy(username[w:], user[start:])

			clientFirstMessage := make([]byte, 5+len(m.Nonce())+len(username))
			copy(clientFirstMessage, "n=")
			copy(clientFirstMessage[2:], username)
			copy(clientFirstMessage[2+len(username):], ",r=")
			copy(clientFirstMessage[5+len(username):], m.Nonce())

			return true, append(getGS2Header(name, m), clientFirstMessage...), clientFirstMessage, nil
		},
		Next: func(m *Negotiator, challenge []byte, data interface{}) (more bool, resp []byte, cache interface{}, err error) {
			if len(challenge) == 0 {
				return more, resp, cache, ErrInvalidChallenge
			}

			if m.State()&Receiving == Receiving {
				panic("not yet implemented")
			}
			return scramClientNext(name, fn, m, challenge, data)
		},
	}
}

func scramClientNext(name string, fn func() hash.Hash, m *Negotiator, challenge []byte, data interface{}) (more bool, resp []byte, cache interface{}, err error) {
	_, password, _ := m.Credentials()
	state := m.State()

	switch state & StepMask {
	case AuthTextSent:
		iter := -1
		var salt, nonce []byte
		remain := challenge
		for {
			var field []byte
			field, remain = nextParam(remain)
			if len(field) < 3 || (len(field) >= 2 && field[1] != '=') {
				continue
			}
			switch field[0] {
			case 'i':
				ival := string(bytes.TrimRight(field[2:], "\x00"))

				if iter, err = strconv.Atoi(ival); err != nil {
					return
				}
			case 's':
				salt = make([]byte, base64.StdEncoding.DecodedLen(len(field)-2))
				var n int
				n, err = base64.StdEncoding.Decode(salt, field[2:])
				salt = salt[:n]
				if err != nil {
					return
				}
			case 'r':
				nonce = field[2:]
			case 'm':
				// RFC 5802:
				// m: This attribute is reserved for future extensibility.  In this
				// version of SCRAM, its presence in a client or a server message
				// MUST cause authentication failure when the attribute is parsed by
				// the other end.
				err = errors.New("server sent reserved attribute `m'")
				return
			}
			if remain == nil {
				break
			}
		}

		switch {
		case iter < 0:
			err = errors.New("iteration count is invalid")
			return
		case nonce == nil || !bytes.HasPrefix(nonce, m.Nonce()):
			err = errors.New("server nonce does not match client nonce")
			return
		case salt == nil:
			err = errors.New("server sent empty salt")
			return
		}

		gs2Header := getGS2Header(name, m)
		tlsState := m.TLSState()
		var channelBinding []byte
		switch plus := strings.HasSuffix(name, "-PLUS"); {
		case plus && tlsState == nil:
			err = errors.New("sasl: SCRAM with channel binding requires a TLS connection")
			return
		case bytes.Contains(gs2Header, []byte(gs2HeaderCBSupportExporter)):
			keying, err := tlsState.ExportKeyingMaterial(exporterLabel, nil, exporterLen)
			if err != nil {
				return false, nil, nil, err
			}
			if len(keying) == 0 {
				err = errors.New("sasl: SCRAM with channel binding requires valid TLS keying material")
				return false, nil, nil, err
			}
			channelBinding = make([]byte, 2+base64.StdEncoding.EncodedLen(len(gs2Header)+len(keying)))
			channelBinding[0] = 'c'
			channelBinding[1] = '='
			base64.StdEncoding.Encode(channelBinding[2:], append(gs2Header, keying...))
		case bytes.Contains(gs2Header, []byte(gs2HeaderCBSupportUnique)):
			//lint:ignore SA1019 TLS unique must be supported by SCRAM
			if len(tlsState.TLSUnique) == 0 {
				err = errors.New("sasl: SCRAM with channel binding requires valid tls-unique data")
				return false, nil, nil, err
			}
			channelBinding = make(
				[]byte,
				//lint:ignore SA1019 TLS unique must be supported by SCRAM
				2+base64.StdEncoding.EncodedLen(len(gs2Header)+len(tlsState.TLSUnique)),
			)
			channelBinding[0] = 'c'
			channelBinding[1] = '='
			//lint:ignore SA1019 TLS unique must be supported by SCRAM
			base64.StdEncoding.Encode(channelBinding[2:], append(gs2Header, tlsState.TLSUnique...))
		default:
			channelBinding = make(
				[]byte,
				2+base64.StdEncoding.EncodedLen(len(gs2Header)),
			)
			channelBinding[0] = 'c'
			channelBinding[1] = '='
			base64.StdEncoding.Encode(channelBinding[2:], gs2Header)
		}
		clientFinalMessageWithoutProof := append(channelBinding, []byte(",r=")...)
		clientFinalMessageWithoutProof = append(clientFinalMessageWithoutProof, nonce...)

		clientFirstMessage := data.([]byte)
		authMessage := append(clientFirstMessage, ',')
		authMessage = append(authMessage, challenge...)
		authMessage = append(authMessage, ',')
		authMessage = append(authMessage, clientFinalMessageWithoutProof...)

		saltedPassword := pbkdf2.Key(password, salt, iter, fn().Size(), fn)

		h := hmac.New(fn, saltedPassword)
		_, err = h.Write(serverKeyInput)
		if err != nil {
			return
		}
		serverKey := h.Sum(nil)
		h.Reset()

		_, err = h.Write(clientKeyInput)
		if err != nil {
			return
		}
		clientKey := h.Sum(nil)

		h = hmac.New(fn, serverKey)
		_, err = h.Write(authMessage)
		if err != nil {
			return
		}
		serverSignature := h.Sum(nil)

		h = fn()
		_, err = h.Write(clientKey)
		if err != nil {
			return
		}
		storedKey := h.Sum(nil)
		h = hmac.New(fn, storedKey)
		_, err = h.Write(authMessage)
		if err != nil {
			return
		}
		clientSignature := h.Sum(nil)
		clientProof := make([]byte, len(clientKey))
		goXORBytes(clientProof, clientKey, clientSignature)

		encodedClientProof := make([]byte, base64.StdEncoding.EncodedLen(len(clientProof)))
		base64.StdEncoding.Encode(encodedClientProof, clientProof)
		clientFinalMessage := append(clientFinalMessageWithoutProof, []byte(",p=")...)
		clientFinalMessage = append(clientFinalMessage, encodedClientProof...)

		return true, clientFinalMessage, serverSignature, nil
	case ResponseSent:
		clientCalculatedServerFinalMessage := "v=" + base64.StdEncoding.EncodeToString(data.([]byte))
		if clientCalculatedServerFinalMessage != string(challenge) {
			err = ErrAuthn
			return
		}
		// Success!
		return false, nil, nil, nil
	}
	err = ErrInvalidState
	return
}

func nextParam(params []byte) ([]byte, []byte) {
	idx := bytes.IndexByte(params, ',')
	if idx == -1 {
		return params, nil
	}
	return params[:idx], params[idx+1:]
}
