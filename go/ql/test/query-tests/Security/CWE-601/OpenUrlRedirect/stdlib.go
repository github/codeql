package main

import (
	"net/http"
	"net/url"
	"regexp"
)

func serveStdlib() {
	http.HandleFunc("/ex", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// BAD: a request parameter is incorporated without validation into a URL redirect
		w.Header().Set("Location", target)
		w.WriteHeader(302)
	})

	http.HandleFunc("/ex1", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// Probably OK because the status is set to 500, but we catch it anyway
		w.Header().Set("Location", target)
		w.WriteHeader(500)
	})

	http.HandleFunc("/ex2", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: local redirects are unproblematic
		w.Header().Set("Location", "/local"+target)
		// BAD: this could be a non-local redirect
		w.Header().Set("Location", "/"+target)
		// GOOD: localhost redirects are unproblematic
		w.Header().Set("Location", "//localhost/"+target)
		w.WriteHeader(302)
	})

	http.HandleFunc("/ex3", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// BAD: using the utility function
		http.Redirect(w, r, target, 301)
	})

	http.HandleFunc("/ex4", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: comparison against known URLs
		if target == "semmle.com" {
			http.Redirect(w, r, target, 301)
		} else {
			w.WriteHeader(400)
		}
	})

	http.HandleFunc("/ex5", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		me := "me"
		// BAD: may be a global redirection
		http.Redirect(w, r, target+"?from="+me, 301)
	})

	http.HandleFunc("/ex6", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is embedded in query string
		http.Redirect(w, r, someUrl()+"?target="+target, 301)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is embedded in hash
		http.Redirect(w, r, someUrl()+(HASH+target), 302)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		target += "/index.html"
		// BAD
		http.Redirect(w, r, target, 302)
	})

	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: request parameter is checked against a regexp
		if ok, _ := regexp.MatchString("", target); ok {
			http.Redirect(w, r, target, 302)
		} else {
			w.WriteHeader(400)
		}
	})

	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		// GOOD: this only rewrites	the scheme, which is not dangerous as the host cannot change.
		if r.URL.Scheme == "http" {
			r.URL.Scheme = "https"
			http.Redirect(w, r, r.URL.String(), 302)
		} else {
			// ...
		}
	})

	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: a check is done on the URL
		if isValidRedirect(target) {
			http.Redirect(w, r, target, 302)
		} else {
			// ...
		}
	})

	http.HandleFunc("/ex", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD: a check is done on the URL
		if isValidRedirect(target) {
			http.Redirect(w, r, target, 302)
		} else {
			// ...
		}
	})

	http.HandleFunc("/ex9", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.Form.Get("target")
		// GOOD, but we catch this anyway: a check is done on the URL
		if !isValidRedirect(target) {
			target = "/"
		}

		http.Redirect(w, r, target, 302)
	})

	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		// GOOD: Only safe parts of the URL are used
		url := *r.URL
		if url.Scheme == "http" {
			url.Scheme = "https"
			http.Redirect(w, r, url.String(), 302)
		} else {
			// ...
		}
	})

	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		// GOOD: Only safe parts of the URL are used
		if r.URL.Scheme == "http" {
			http.Redirect(w, r, "https://"+r.URL.RequestURI(), 302)
		} else {
			// ...
		}
	})

	http.HandleFunc("/ex9", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target := r.FormValue("target")
		// BAD: a request parameter is incorporated without validation into a URL redirect
		http.Redirect(w, r, target, 301)
	})

	http.HandleFunc("/ex10", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		target, _ := url.ParseRequestURI(r.FormValue("target"))
		// BAD: Path could start with `//`
		http.Redirect(w, r, target.Path, 301)
		// BAD: EscapedPath() does not help with that
		http.Redirect(w, r, target.EscapedPath(), 301)
	})

	http.HandleFunc("/ex11", func(w http.ResponseWriter, r *http.Request) {
		// GOOD: all these fields and methods are disregarded for OpenRedirect attacks:
		buf := make([]byte, 100)
		r.Body.Read(buf)
		http.Redirect(w, r, string(buf), 301)
		bodyReader, _ := r.GetBody()
		bodyReader.Read(buf)
		http.Redirect(w, r, string(buf), 301)
		http.Redirect(w, r, r.PostForm["someField"][0], 301)
		http.Redirect(w, r, r.MultipartForm.Value["someField"][0], 301)
		http.Redirect(w, r, r.Header.Get("someField"), 301)
		http.Redirect(w, r, r.Trailer.Get("someField"), 301)
		http.Redirect(w, r, r.PostFormValue("someField"), 301)
		cookie, _ := r.Cookie("key")
		http.Redirect(w, r, cookie.Value, 301)
		http.Redirect(w, r, r.Cookies()[0].Value, 301)
		http.Redirect(w, r, r.Referer(), 301)
		http.Redirect(w, r, r.UserAgent(), 301)
		http.Redirect(w, r, r.PostFormValue("target"), 301)
		reader, _ := r.MultipartReader()
		part, _ := reader.NextPart()
		part.Read(buf)
		http.Redirect(w, r, string(buf), 301)
	})

	http.ListenAndServe(":80", nil)
}
