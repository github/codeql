/*

Package jwt aims to provide an implementation of the JSON Web Token standard.
The library supports the JSON Web Algorithm standard with HMAC, RSA, ECDSA and EdDSA.
The signing operation can accept multiple claims and merge as one,
not a single change to the existing structs is required.
The verification process performs all the standard validations out of the box.
The library supports only the compact serialization format.

Benchmarks are shown that this package is near ~3 times faster than existing packages for both Sign and Verify operations.

Project Home:

	https://github.com/kataras/jwt

Examples Directory:

	https://github.com/kataras/jwt/tree/main/_examples

Benchmarks:

	https://github.com/kataras/jwt/tree/main/_benchmarks

Getting Started:

	package main

	import "github.com/kataras/jwt"

	// Keep it secret.
	var sharedKey = []byte("sercrethatmaycontainch@r$32chars")

	func main() {
	// Generate a token:
	myClaims := map[string]interface{}{
		"foo": "bar",
	}
	token, err := jwt.Sign(jwt.HS256, sharedKey, myClaims, jwt.MaxAge(15 * time.Minute))

	// Verify and extract claims from a token:
	verifiedToken, err := jwt.Verify(jwt.HS256, sharedKey, token)

	var claims map[string]interface{}
	err = verifiedToken.Claims(&claims)
	}


*/
package jwt
