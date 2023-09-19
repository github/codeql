package main2

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-jose/go-jose/v3"
	"github.com/go-jose/go-jose/v3/jwt"
	"net/http"
)

type CustomerInfo struct {
	Name string
	ID   int
}

var JwtKey = []byte("AllYourBase")

func main() {
	router := gin.Default()
	router.GET("/ping", func(c *gin.Context) {
		// https://pkg.go.dev/github.com/go-jose/go-jose/v3/jwt
		signedToken := c.Param("signedToken")
		// GOOD: decode first and then verify
		notVerifyJWT(signedToken)
		verifyJWT(signedToken)
		// Bad: no verification
		signedToken = c.Param("signedToken")
		notVerifyJWT(signedToken)

		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	_ = router.Run()

}

func newToken(unsignedToken string) string {
	fmt.Println("Creating new JWT")
	signer, _ := jose.NewSigner(jose.SigningKey{Algorithm: jose.HS256, Key: JwtKey}, nil)
	raw, err := jwt.Signed(signer).Claims(CustomerInfo{ID: 1, Name: unsignedToken}).CompactSerialize()
	if err != nil {
		panic(err)
	}
	fmt.Println(raw)
	return raw
}

func notVerifyJWT(signedToken string) {
	fmt.Println("only decoding JWT")
	DecodedToken, _ := jwt.ParseSigned(signedToken)
	out := CustomerInfo{}
	if err := DecodedToken.UnsafeClaimsWithoutVerification(&out); err != nil {
		panic(err)
	}
	fmt.Printf("%v\n", out)
}
func verifyJWT(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, _ := jwt.ParseSigned(signedToken)
	out := CustomerInfo{}
	if err := DecodedToken.Claims(JwtKey, &out); err != nil {
		panic(err)
	}
	fmt.Printf("%v\n", out)
}
