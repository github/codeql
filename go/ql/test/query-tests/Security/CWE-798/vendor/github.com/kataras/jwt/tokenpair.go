package jwt

import "encoding/json"

// TokenPair holds the access token and refresh token response.
type TokenPair struct {
	AccessToken  json.RawMessage `json:"access_token,omitempty"`
	RefreshToken json.RawMessage `json:"refresh_token,omitempty"`
}

// NewTokenPair accepts raw access and refresh token
// and returns a structure which holds both of them,
// ready to be sent to the client as JSON.
func NewTokenPair(accessToken, refreshToken []byte) TokenPair {
	return TokenPair{
		AccessToken:  BytesQuote(accessToken),
		RefreshToken: BytesQuote(refreshToken),
	}
}

// BytesQuote returns a double-quoted []byte slice representing "b".
func BytesQuote(b []byte) []byte {
	dst := make([]byte, len(b)+2)
	dst[0] = '"'
	copy(dst[1:], b)
	dst[len(dst)-1] = '"'
	return dst
}
