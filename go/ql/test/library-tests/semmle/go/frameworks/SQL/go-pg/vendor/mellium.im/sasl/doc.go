// Copyright 2016 The Mellium Contributors.
// Use of this source code is governed by the BSD 2-clause
// license that can be found in the LICENSE file.

// Package sasl implements the Simple Authentication and Security Layer (SASL)
// as defined by RFC 4422.
//
// Most users of this package will only need to create a Negotiator using
// NewClient or NewServer and call its Step method repeatedly.
// Authors implementing SASL mechanisms other than the builtin ones will want to
// create a Mechanism struct which will likely use the other methods on the
// Negotiator.
//
// Be advised: This API is still unstable and is subject to change.
package sasl // import "mellium.im/sasl"
