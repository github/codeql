package main

//go:generate depstubber -vendor github.com/gorilla/websocket Dialer
//go:generate depstubber -vendor golang.org/x/net/websocket "" Dial,NewConfig,DialConfig

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strings"

	gorilla "github.com/gorilla/websocket"
	"golang.org/x/net/websocket"
)

func handler(w http.ResponseWriter, req *http.Request) {
	target := req.FormValue("target")

	// BAD: `target` is controlled by the attacker
	_, err := http.Get("https://" + target + ".example.com/data/")
	if err != nil {
		// error handling
	}
	// process request response
}

func handler1(w http.ResponseWriter, req *http.Request) {
	target := req.FormValue("target")

	var subdomain string
	if target == "EU" {
		subdomain = "europe"
	} else {
		subdomain = "world"
	}

	// GOOD: `subdomain` is controlled by the server
	_, err := http.Get("https://" + subdomain + ".example.com/data/")
	if err != nil {
		// error handling
	}
	// process request response
}

func test() {

	http.HandleFunc("/ex0", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		origin := "http://localhost/"

		untrustedInputTrimmed := strings.TrimRight(untrustedInput, "\n\r")
		if untrustedInputTrimmed == "ws://localhost:12345/ws" {
			// good as input is checked against fixed set of urls.
			ws, _ := websocket.Dial(untrustedInputTrimmed, "", origin) // OK
			var msg = make([]byte, 512)
			var n int
			n, _ = ws.Read(msg)
			fmt.Printf("Received: %s.\n", msg[:n])
		}
	})

	// x net websocket DialConfig good
	http.HandleFunc("/ex1", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		origin := "http://localhost/"
		// good as input is tested against a regex
		if m, _ := regexp.MatchString("ws://localhost:12345/*", untrustedInput); m {
			config, _ := websocket.NewConfig(untrustedInput, origin) // OK? Regex
			ws2, _ := websocket.DialConfig(config)
			var msg = make([]byte, 512)
			var n int
			n, _ = ws2.Read(msg)
			fmt.Printf("Received: %s.\n", msg[:n])
		}
	})

	// x net websocket dial bad
	http.HandleFunc("/ex2", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		origin := "http://localhost/"

		// bad as input is directly passed to dial function
		ws, _ := websocket.Dial(untrustedInput, "", origin) // SSRF
		var msg = make([]byte, 512)
		var n int
		n, _ = ws.Read(msg)
		fmt.Printf("Received: %s.\n", msg[:n])
	})

	// x net websocket dialConfig bad
	http.HandleFunc("/ex3", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		origin := "http://localhost/"
		// bad as input is directly used
		config, _ := websocket.NewConfig(untrustedInput, origin) // SSRF
		ws2, _ := websocket.DialConfig(config)
		var msg = make([]byte, 512)
		var n int
		n, _ = ws2.Read(msg)
		fmt.Printf("Received: %s.\n", msg[:n])
	})

	// gorilla websocket Dialer.Dial bad
	http.HandleFunc("/ex6", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		dialer := gorilla.Dialer{}
		dialer.Dial(untrustedInput, r.Header) //SSRF
	})

	// gorilla websocket Dialer.Dial good
	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if untrustedInput == "localhost" {
			dialer := gorilla.Dialer{}
			dialer.Dial(untrustedInput, r.Header) //OK
		}
	})

	// gorilla websocket Dialer.DialContext bad
	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		dialer := gorilla.Dialer{}
		dialer.DialContext(context.TODO(), untrustedInput, r.Header) //SSRF
	})

	// gorilla websocket Dialer.DialContext good
	http.HandleFunc("/ex9", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if untrustedInput == "localhost" {
			dialer := gorilla.Dialer{}
			dialer.DialContext(context.TODO(), untrustedInput, r.Header) //OK
		}
	})

	log.Println(http.ListenAndServe(":80", nil))

}
