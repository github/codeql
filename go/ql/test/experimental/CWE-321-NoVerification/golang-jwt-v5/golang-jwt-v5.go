package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"log"
	"net/http"
	"os"
)

type CustomerInfo struct {
	Name string
	ID   int
	jwt.RegisteredClaims
}

// BAD constant key
var JwtKey = []byte("AllYourBase")

func main() {
	router := gin.Default()
	router.GET("/ping", func(c *gin.Context) {
		// https://pkg.go.dev/github.com/go-jose/go-jose/v3/jwt
		var unsignedToken = c.Param("customerName")
		signedToken := newToken(unsignedToken)
		signedToken = c.Param("signedToken")
		// GOOD
		verifyJWT(signedToken)
		notVerifyJWT(signedToken)

		// BAD only unverified parse
		signedToken = c.Param("signedToken")
		notVerifyJWT(signedToken)

		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	_ = router.Run()
}

func newToken(unsignedToken string) string {
	fmt.Println("Signing JWT")
	signer := jwt.GetSigningMethod(jwt.SigningMethodHS256.Alg())
	claims := CustomerInfo{ID: 1, Name: unsignedToken}
	signedToken, err := jwt.NewWithClaims(signer, claims).SignedString(JwtKey)
	signedToken2, err := jwt.New(signer).SignedString(JwtKey)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println(signedToken)
	fmt.Println(signedToken2)
	return signedToken
}
func notVerifyJWT(signedToken string) {
	fmt.Println("only decoding JWT")
	DecodedToken, _, err := jwt.NewParser().ParseUnverified(signedToken, &CustomerInfo{})
	if claims, ok := DecodedToken.Claims.(*CustomerInfo); ok {
		fmt.Printf("DecodedToken:%v\n", claims)
	} else {
		log.Fatal("error", err)
	}
}
func LoadJwtKey(token *jwt.Token) (interface{}, error) {
	return JwtKey, nil
}
func verifyJWT(signedToken string) {
	fmt.Println("verifying JWT")
	DecodedToken, err := jwt.ParseWithClaims(signedToken, &CustomerInfo{}, LoadJwtKey)
	if claims, ok := DecodedToken.Claims.(*CustomerInfo); ok && DecodedToken.Valid {
		fmt.Printf("NAME:%v ,ID:%v\n", claims.Name, claims.ID)
	} else {
		log.Fatal(err)
	}
}

