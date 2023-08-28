package main

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
		signedToken := c.Param("signedToken")
		verifyJWT(signedToken)

		c.JSON(http.StatusOK, gin.H{
			"message": "pong",
		})
	})
	_ = router.Run()

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
