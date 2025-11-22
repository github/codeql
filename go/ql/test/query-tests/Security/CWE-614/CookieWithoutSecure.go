package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func handler1(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session", // $ Source
		Value: "secret",
	}
	http.SetCookie(w, &c) // $ Alert // BAD: Secure set to false by default
}

func handler2(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:   "session", // $ Source
		Value:  "secret",
		Secure: false,
	}
	http.SetCookie(w, &c) // $ Alert // BAD: Secure explicitly set to false
}

func handler3(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:   "session",
		Value:  "secret",
		Secure: true,
	}
	http.SetCookie(w, &c) // GOOD: Secure explicitly set to true
}

func handler4(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	c.Secure = true
	http.SetCookie(w, &c) // GOOD: Secure explicitly set to true
}

func handler5(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session", // $ Source
		Value: "secret",
	}
	c.Secure = false
	http.SetCookie(w, &c) // $ Alert // BAD: Secure explicitly set to false
}

func handler6(w http.ResponseWriter, r *http.Request) {
	val := false
	c := http.Cookie{
		Name:   "session", // $ Source
		Value:  "secret",
		Secure: val,
	}
	http.SetCookie(w, &c) // $ Alert // BAD: Secure explicitly set to false
}

func handler7(w http.ResponseWriter, r *http.Request) {
	val := true
	c := http.Cookie{
		Name:   "session",
		Value:  "secret",
		Secure: val,
	}
	http.SetCookie(w, &c) // GOOD: Secure explicitly set to true
}

func handler8(w http.ResponseWriter, r *http.Request) {
	val := true
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	c.Secure = val
	http.SetCookie(w, &c) // GOOD: Secure explicitly set to true
}

func handler9(w http.ResponseWriter, r *http.Request) {
	val := false
	c := http.Cookie{
		Name:  "session", // $ Source
		Value: "secret",
	}
	c.Secure = val
	http.SetCookie(w, &c) // $ Alert //BAD: Secure explicitly set to false
}

func main() {

	router := gin.Default()

	router.GET("/cookie", func(c *gin.Context) {

		_, err := c.Cookie("session")

		if err != nil {
			c.SetCookie("session", "test", 3600, "/", "localhost", false, false) // $ Alert // BAD: Secure set to false
		}
	})

	router.Run()
}
