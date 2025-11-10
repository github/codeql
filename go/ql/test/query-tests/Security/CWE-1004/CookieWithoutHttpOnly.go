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
	http.SetCookie(w, &c) // $ Alert // BAD: HttpOnly set to false by default
}

func handler2(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:     "session", // $ Source
		Value:    "secret",
		HttpOnly: false,
	}
	http.SetCookie(w, &c) // $ Alert // BAD: HttpOnly explicitly set to false
}

func handler3(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:     "session",
		Value:    "secret",
		HttpOnly: true,
	}
	http.SetCookie(w, &c) // GOOD: HttpOnly explicitly set to true
}

func handler4(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	c.HttpOnly = true
	http.SetCookie(w, &c) // GOOD: HttpOnly explicitly set to true
}

func handler5(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session", // $ Source
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // $ Alert // BAD: HttpOnly explicitly set to false
}

func handler6(w http.ResponseWriter, r *http.Request) {
	val := false
	c := http.Cookie{
		Name:     "session", // $ Source
		Value:    "secret",
		HttpOnly: val,
	}
	http.SetCookie(w, &c) // $ Alert // BAD: HttpOnly explicitly set to false
}

func handler7(w http.ResponseWriter, r *http.Request) {
	val := true
	c := http.Cookie{
		Name:     "session",
		Value:    "secret",
		HttpOnly: val,
	}
	http.SetCookie(w, &c) // GOOD: HttpOnly explicitly set to true
}

func handler8(w http.ResponseWriter, r *http.Request) {
	val := true
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	c.HttpOnly = val
	http.SetCookie(w, &c) // GOOD: HttpOnly explicitly set to true
}

func handler9(w http.ResponseWriter, r *http.Request) {
	val := false
	c := http.Cookie{
		Name:  "session", // $ Source
		Value: "secret",
	}
	c.HttpOnly = val
	http.SetCookie(w, &c) // $ Alert //BAD: HttpOnly explicitly set to false
}

func handler10(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "consent",
		Value: "1",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // GOOD: Name is not auth related
}

func handler11(w http.ResponseWriter, r *http.Request) {
	name := "session" // $ Source
	c := http.Cookie{
		Name:  name,
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // $ Alert // BAD: auth related name
}

func handler12(w http.ResponseWriter, r *http.Request) {
	session := "login_name" // $ Source
	c := http.Cookie{
		Name:  session, // $ Source
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // $ Alert // BAD: auth related name
}

func main() {

	router := gin.Default()

	router.GET("/cookie", func(c *gin.Context) {

		_, err := c.Cookie("session")

		if err != nil {
			c.SetCookie("session", "test", 3600, "/", "localhost", false, false) // $ Alert // BAD: httpOnly set to false
		}
	})

	router.Run()
}
