package jwt

//go:generate depstubber -vendor  github.com/golang-jwt/jwt/v5 RegisteredClaims,Parser,Token,SigningMethodHMAC Parse,ParseWithClaims,NewParser,WithValidMethods

import (
	"net/http"

	"github.com/golang-jwt/jwt/v5"
)

func verify(endpointHandler func(writer http.ResponseWriter, request *http.Request)) http.HandlerFunc {
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		if request.Header["Token"] != nil {
			//Good, this specifiies an algorithim in the parser, and therefore does not need to check the algorithim in the key function
			p := jwt.NewParser(jwt.WithValidMethods([]string{"RSA256"}))
			p.Parse("test", func(token *jwt.Token) (interface{}, error) {
				return "", nil

			})
			//Bad, this parses with a custom parser that does not specify the algorithim/method and does not check the token's algorithm
			p_bad := jwt.NewParser()
			p_bad.Parse("test", key)
			//Good, this checks the token Method
			token, err := jwt.Parse(request.Header["Token"][0], func(token *jwt.Token) (interface{}, error) {
				_, ok := token.Method.(*jwt.SigningMethodHMAC)
				if !ok {
					writer.WriteHeader(http.StatusUnauthorized)
					_, err := writer.Write([]byte("You're Unauthorized"))
					if err != nil {
						return nil, err
					}
				}
				return "", nil

			})
			//Bad, this parses using the default parser without checking the token Method
			token_bad, err := jwt.Parse(request.Header["Token"][0], func(token *jwt.Token) (interface{}, error) {
				return "", nil

			})
			// parsing errors result
			if err != nil {
				writer.WriteHeader(http.StatusUnauthorized)
				_, err2 := writer.Write([]byte("You're Unauthorized due to error parsing the JWT"))
				if err2 != nil {
					return
				}

			}
			// if there's a token
			if token.Valid || token_bad.Valid {
				endpointHandler(writer, request)
			} else {
				writer.WriteHeader(http.StatusUnauthorized)
				_, err := writer.Write([]byte("You're Unauthorized due to invalid token"))
				if err != nil {
					return
				}
			}
		} else {
			writer.WriteHeader(http.StatusUnauthorized)
			_, err := writer.Write([]byte("You're Unauthorized due to No token in the header"))
			if err != nil {
				return
			}
		}
	})
}

func key(token *jwt.Token) (interface{}, error) {
	return "", nil
}
