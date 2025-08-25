// Package jwt is a stub of github.com/iris-contrib/middleware/jwt, manually generated.
package jwt

import (
	gj "github.com/golang-jwt/jwt/v4"
)

type (
	// Token for JWT. Different fields will be used depending on whether you're
	// creating or parsing/verifying a token.
	//
	// A type alias for jwt.Token.
	Token = gj.Token
	// MapClaims type that uses the map[string]interface{} for JSON decoding
	// This is the default claims type if you don't supply one
	//
	// A type alias for jwt.MapClaims.
	MapClaims = gj.MapClaims
	// Claims must just have a Valid method that determines
	// if the token is invalid for any supported reason.
	//
	// A type alias for jwt.Claims.
	Claims = gj.Claims
)

var (
	NewToken           = gj.New
	NewTokenWithClaims = gj.NewWithClaims
)
