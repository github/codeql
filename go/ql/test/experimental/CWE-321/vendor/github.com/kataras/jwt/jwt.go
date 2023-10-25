package jwt

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"reflect"
	"time"
)

// Map is just a type alias, a shortcut of map[string]interface{}.
type Map = map[string]interface{}

// Clock is used to validate tokens expiration if the "exp" (expiration) exists in the payload.
// It can be overridden to use any other time value, useful for testing.
//
// Usage: now := Clock()
var Clock = time.Now

// CompareHeader is the function which compares and validates
// the decoded header against the defined signature algorithm.
// Defaults to a fast and simple implementation but it can be modified
// to support custom usage when third-party jwt signers signs the token
// (e.g. from a java spring application).
//
// This affects every token of the current program.
// Use the `VerifyWithHeaderValidator` function to implement per-token validation instead.
var CompareHeader HeaderValidator = compareHeader

// ReadFile can be used to customize the way the
// Must/Load Key function helpers are loading the filenames from.
// Example of usage: embedded key pairs.
// Defaults to the `ioutil.ReadFile` which reads the file from the physical disk.
var ReadFile = ioutil.ReadFile

// Marshal same as json.Marshal.
// This variable can be modified to enable custom encoder behavior
// for a signed payload.
var Marshal = func(v interface{}) ([]byte, error) {
	if b, ok := v.([]byte); ok {
		return b, nil
	}

	return json.Marshal(v)
}

// Unmarshal same as json.Unmarshal
// but with the Decoder unmarshals a number into an interface{} as a
// json.Number instead of as a float64.
// This is the function being called on `VerifiedToken.Claims` method.
// This variable can be modified to enable custom decoder behavior.
var Unmarshal = defaultUnmarshal

// UnmarshalWithRequired protects the custom fields of JWT claims
// based on the json:required tag e.g. `json:"name,required"`.
// It accepts a struct value to be validated later on.
// Returns ErrMissingKey if a required value is missing from the payload.
//
// Usage:
//  Unmarshal = UnmarshalWithRequired
//  [...]
//  A Go struct like: UserClaims { Username string `json:"username,required" `}
//  [...]
//  And `Verify` as usual.
func UnmarshalWithRequired(payload []byte, dest interface{}) error {
	if err := defaultUnmarshal(payload, dest); err != nil {
		return err
	}

	return meetRequirements(reflect.ValueOf(dest))
}

func defaultUnmarshal(payload []byte, dest interface{}) error {
	dec := json.NewDecoder(bytes.NewReader(payload))
	dec.UseNumber() // fixes the issue of setting float64 instead of int64 on maps.
	return dec.Decode(&dest)
}

// InjectFunc can be used to further modify the final token's body part.
// Look the `GCM` function for a real implementation of this type.
type InjectFunc func(plainPayload []byte) ([]byte, error)
