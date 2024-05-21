package main

//go:generate depstubber -vendor github.com/appleboy/gin-jwt/v2 GinJWTMiddleware New
//go:generate depstubber -vendor github.com/golang-jwt/jwt/v4 MapClaims,RegisteredClaims,SigningMethodRSA,SigningMethodHMAC,Token NewNumericDate,NewWithClaims,New
//go:generate depstubber -vendor github.com/gin-gonic/gin Context New
//go:generate depstubber -vendor github.com/go-kit/kit/auth/jwt "" NewSigner
//go:generate depstubber -vendor github.com/lestrrat/go-jwx/jwk "" New
//go:generate depstubber -vendor github.com/square/go-jose/v3 Recipient NewEncrypter,NewSigner
//go:generate depstubber -vendor gopkg.in/square/go-jose.v2 Recipient NewEncrypter,NewSigner
//go:generate depstubber -vendor github.com/cristalhq/jwt/v3 Signer NewSignerHS,HS256
//go:generate depstubber -vendor github.com/iris-contrib/middleware/jwt "" NewToken,NewTokenWithClaims
//go:generate depstubber -vendor github.com/kataras/iris/v12/middleware/jwt Signer,Verifier NewSigner,NewVerifier
//go:generate depstubber -vendor github.com/kataras/jwt Keys,Alg Sign,SignEncrypted,SignEncryptedWithHeader,SignWithHeader
//go:generate depstubber -vendor github.com/gogf/gf-jwt/v2 GfJWTMiddleware

import (
	"time"

	jwt "github.com/appleboy/gin-jwt/v2"
	cristal "github.com/cristalhq/jwt/v3"
	gokit "github.com/go-kit/kit/auth/jwt"
	gogf "github.com/gogf/gf-jwt/v2"
	gjwt "github.com/golang-jwt/jwt/v4"
	iris "github.com/iris-contrib/middleware/jwt"
	iris12 "github.com/kataras/iris/v12/middleware/jwt"
	kataras "github.com/kataras/jwt"
	le "github.com/lestrrat/go-jwx/jwk"
	jose_v3 "github.com/square/go-jose/v3"
	jose_v2 "gopkg.in/square/go-jose.v2"
)

func gjwtt() (interface{}, error) {
	mySigningKey := []byte("key1")

	// Create the Claims
	claims := &gjwt.RegisteredClaims{
		ExpiresAt: gjwt.NewNumericDate(time.Unix(1516239022, 0)),
		Issuer:    "test",
	}

	token := gjwt.NewWithClaims(nil, claims)
	return token.SignedString(mySigningKey) // BAD
}

func gin_jwt() (interface{}, error) {
	var identityKey = "id"
	return jwt.New(&jwt.GinJWTMiddleware{
		Realm:       "test zone",
		Key:         []byte("key2"), // BAD
		Timeout:     time.Hour,
		MaxRefresh:  time.Hour,
		IdentityKey: identityKey,
		PayloadFunc: func(data interface{}) jwt.MapClaims {
			return nil
		},
		IdentityHandler: nil,
		Authenticator:   nil,
		Authorizator:    nil,
		Unauthorized:    nil,
		TokenLookup:     "header: Authorization, query: token, cookie: jwt",
		TokenHeadName:   "Bearer",
		TimeFunc:        time.Now,
	})
}

func cristalhq() (interface{}, error) {
	key := []byte(`key3`)
	return cristal.NewSignerHS(cristal.HS256, key) // BAD
}

func josev3() (interface{}, error) {
	key := []byte("key4")
	return jose_v3.NewSigner(jose_v3.SigningKey{Algorithm: "", Key: key}, nil) // BAD
}
func josev3_2() (interface{}, error) {
	key2 := []byte("key5")
	return jose_v3.NewEncrypter(
		"",
		jose_v3.Recipient{
			Algorithm: "",
			Key:       key2, // BAD
		},
		nil)
}

func josev2() (interface{}, error) {
	key := []byte("key6")

	return jose_v2.NewEncrypter(
		"",
		jose_v2.Recipient{Algorithm: "", Key: key}, // BAD
		nil,
	)
}
func jose_v2_2() (interface{}, error) {
	key2 := []byte("key7")

	return jose_v2.NewSigner(jose_v2.SigningKey{Algorithm: "", Key: key2}, nil) // BAD
}

func go_kit() interface{} {
	var (
		kid = "kid"
		key = []byte("key8")

		mapClaims = gjwt.MapClaims{"user": "go-kit"}
	)

	return gokit.NewSigner(kid, key, nil, mapClaims) // BAD
}

func lejwt() (interface{}, error) {
	sharedKey := []byte("key9")
	return le.New(sharedKey) // BAD
}

var sharedKeyglobal = []byte("key10")

func lejwt2() (interface{}, error) {
	return le.New(sharedKeyglobal) // BAD
}

func gogfjwt() interface{} {
	return &gogf.GfJWTMiddleware{
		Realm:           "test zone",
		Key:             []byte("key11"), // BAD
		Timeout:         time.Minute * 5,
		MaxRefresh:      time.Minute * 5,
		IdentityKey:     "id",
		TokenLookup:     "header: Authorization, query: token, cookie: jwt",
		TokenHeadName:   "Bearer",
		TimeFunc:        time.Now,
		Authenticator:   nil,
		Unauthorized:    nil,
		PayloadFunc:     nil,
		IdentityHandler: nil,
	}
}

func irisjwt() interface{} {
	key := []byte("key12")
	token := iris.NewTokenWithClaims(nil, nil)
	tokenString, _ := token.SignedString(key) // BAD
	return tokenString
}

func iris12jwt2() interface{} {
	key := []byte("key13")

	s := &iris12.Signer{
		Alg:    nil,
		Key:    key, // BAD
		MaxAge: 3 * time.Second,
	}
	return s
}

func irisjwt3() interface{} {
	key := []byte("key14")
	signer := iris12.NewSigner(nil, key, 3*time.Second) // BAD
	return signer
}

func katarasJwt() interface{} {
	key := []byte("key15")
	token, _ := kataras.Sign(nil, key, nil, nil) // BAD
	return token
}

func katarasJwt2() interface{} {
	key := []byte("key16")
	token, _ := kataras.SignEncrypted(nil, key, nil, nil) // BAD
	return token
}

func katarasJwt3() interface{} {
	key := []byte("key17")
	token, _ := kataras.SignEncryptedWithHeader(nil, key, nil, nil, nil) // BAD
	return token
}

func katarasJwt4() interface{} {
	key := []byte("key18")
	token, _ := kataras.SignWithHeader(nil, key, nil, nil) // BAD
	return token
}

func katarasJwt5() {
	key := []byte("key19")
	var keys kataras.Keys
	var alg kataras.Alg
	keys.Register(alg, "api", nil, key) // BAD
}
