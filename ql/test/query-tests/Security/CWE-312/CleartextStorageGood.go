// +build ignore

package main

import (
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"log"
	"net/http"

	"golang.org/x/crypto/scrypt"
)

var tokens = make(map[string]string)

func saltAndHash(pw string) ([]byte, []byte) {
	salt := make([]byte, 64)
	_, err := io.ReadFull(rand.Reader, salt)
	if err != nil {
		log.Fatal(err)
	}

	hash, err := scrypt.Key([]byte(password), salt, 32768, 8, 1, 64)

	return hash, salt
}

func genToken(user string) {
	res := make([]byte, 32)
	_, err := io.ReadFull(rand.Reader, salt)
	if err != nil {
		log.Fatal(err)
	}

	base64, err := base64.EncodeToString(res)
	if err != nil {
		log.Fatal(err)
	}

	return base64
}

func serve1() {
	http.HandleFunc("/register", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		user := r.Form.Get("user")
		pw := r.Form.Get("password")

		log.Printf("Registering new user %s.\n", user)

		hash, salt = saltAndHash(pw)

		userdb.Store(user, hash, salt)

		var tokenCookie Cookie
		tokenCookie.Name = "auth"
		tokenCookie.Value = genToken(user)
		http.SetCookie(w, encrypt(pwCookie))
	})
	http.ListenAndServe(":80", nil)
}
