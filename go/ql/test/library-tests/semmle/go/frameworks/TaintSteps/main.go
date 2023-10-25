package main

import (
	"encoding/hex"
	"encoding/json"
	"net/http"
)

func jsonTest(v interface{}) []interface{} {
	// taint step from v to b
	b, err := json.Marshal(v)
	// taint step from v to b2
	b2, err2 := json.MarshalIndent(v, "/*JSON*/", "  ")
	return [](interface{}){b, err, b2, err2}
}

func hexTest(encoded string) []interface{} {
	// taint step from encoded to decoded
	decoded, err := hex.DecodeString(encoded)
	// no taint step from decoded to encoded: hex-encoded data is not dangerous for injection
	// attacks, so until we have support for flow labels we do not track taint through this
	reEncoded := hex.EncodeToString(decoded)
	return [](interface{}){decoded, err, reEncoded}
}

func readTest(req *http.Request) string {
	b := make([]byte, 8)
	req.Body.Read(b)
	return string(b)
}

func clearTest(req *http.Request) string {
	b := make([]byte, 8)
	req.Body.Read(b)
	clear(b) // should prevent taint flow
	return string(b)
}
