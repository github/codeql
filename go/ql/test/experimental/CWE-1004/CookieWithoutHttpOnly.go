package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/sessions"
)

func handler1(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:  "session",
		Value: "secret",
	}
	http.SetCookie(w, &c) // BAD: HttpOnly set to false by default
}

func handler2(w http.ResponseWriter, r *http.Request) {
	c := http.Cookie{
		Name:     "session",
		Value:    "secret",
		HttpOnly: false,
	}
	http.SetCookie(w, &c) // BAD: HttpOnly explicitly set to false
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
		Name:  "session",
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // BAD: HttpOnly explicitly set to false
}

func handler6(w http.ResponseWriter, r *http.Request) {
	val := false
	c := http.Cookie{
		Name:     "session",
		Value:    "secret",
		HttpOnly: val,
	}
	http.SetCookie(w, &c) // BAD: HttpOnly explicitly set to false
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
		Name:  "session",
		Value: "secret",
	}
	c.HttpOnly = val
	http.SetCookie(w, &c) // BAD: HttpOnly explicitly set to false
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
	name := "session"
	c := http.Cookie{
		Name:  name,
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // BAD: auth related name
}

func handler12(w http.ResponseWriter, r *http.Request) {
	session := "login_name"
	c := http.Cookie{
		Name:  session,
		Value: "secret",
	}
	c.HttpOnly = false
	http.SetCookie(w, &c) // BAD: auth related name
}

var store = sessions.NewCookieStore([]byte("aa"))

func handler13(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Save(r, w) // BAD: Default options are set (false)
}

func handler14(w http.ResponseWriter, r *http.Request) {
	httpOnly := false
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge:   -1,
		HttpOnly: httpOnly,
	}

	session.Save(r, w) // BAD: Explicitly set to false
}

func handler15(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge: -1,
	}

	session.Save(r, w) // BAD: default (false) is used
}

func handler16(w http.ResponseWriter, r *http.Request) {
	httpOnly := true
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge:   -1,
		HttpOnly: httpOnly,
	}

	session.Save(r, w) // GOOD: value is true
}

func handler17(w http.ResponseWriter, r *http.Request, httpOnly bool) {
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge:   -1,
		HttpOnly: httpOnly,
	}

	session.Save(r, w) // GOOD: value is unknown
}

func handler18(w http.ResponseWriter, r *http.Request) {
	httpOnly := false
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge:   -1,
		HttpOnly: httpOnly,
	}

	store.Save(r, w, session) // BAD: Explicitly set to false
}

func handler19(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, "session-name")
	session.Values["foo"] = "secret"

	session.Options = &sessions.Options{
		MaxAge: -1,
	}

	store.Save(r, w, session) // BAD: default (false) is used
}

func main() {

	router := gin.Default()

	router.GET("/cookie", func(c *gin.Context) {

		_, err := c.Cookie("session")

		if err != nil {
			c.SetCookie("session", "test", 3600, "/", "localhost", false, false) // BAD: httpOnly set to false
		}
	})

	router.Run()
}
