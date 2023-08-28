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
		signedToken := c.Param("signedToken")
		VerifyJWT(signedToken)

		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	_ = router.Run()
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

