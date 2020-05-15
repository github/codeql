package main

//go:generate depstubber -vendor github.com/gobwas/ws Dialer Dial
//go:generate depstubber -vendor github.com/gorilla/websocket Dialer
//go:generate depstubber -vendor github.com/sacOO7/gowebsocket "" New,BuildProxy
//go:generate depstubber -vendor golang.org/x/net/websocket "" Dial,NewConfig,DialConfig
//go:generate depstubber -vendor nhooyr.io/websocket "" Dial

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"regexp"
	"strings"

	gobwas "github.com/gobwas/ws"
	gorilla "github.com/gorilla/websocket"
	sac "github.com/sacOO7/gowebsocket"
	"golang.org/x/net/websocket"
	nhooyr "nhooyr.io/websocket"
)

func test() {
	// x net websocket Dial good
	http.HandleFunc("/ex0", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		origin := "http://localhost/"

		untrustedInputTrimmed := strings.TrimRight(untrustedInput, "\n\r")
		if untrustedInputTrimmed == "ws://localhost:12345/ws" {
			// good as input is checked against fixed set of urls.
			ws, _ := websocket.Dial(untrustedInputTrimmed, "", origin)
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
			config, _ := websocket.NewConfig(untrustedInput, origin) // good
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
		ws, _ := websocket.Dial(untrustedInput, "", origin)
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
		config, _ := websocket.NewConfig(untrustedInput, origin) // good
		ws2, _ := websocket.DialConfig(config)
		var msg = make([]byte, 512)
		var n int
		n, _ = ws2.Read(msg)
		fmt.Printf("Received: %s.\n", msg[:n])
	})

	// nhooyr websocket dial bad
	http.HandleFunc("/ex4", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		// bad as input is used directly
		nhooyr.Dial(context.TODO(), untrustedInput, nil)
		w.WriteHeader(500)
	})

	// nhooyr websocket dial good
	http.HandleFunc("/ex5", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		// good as input is tested againt regex
		if m, _ := regexp.MatchString("ws://localhost:12345/*", untrustedInput); m {
			nhooyr.Dial(context.TODO(), untrustedInput, nil)
		}
	})

	// gorilla websocket Dialer.Dial bad
	http.HandleFunc("/ex6", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		dialer := gorilla.Dialer{}
		dialer.Dial(untrustedInput, r.Header)
	})

	// gorilla websocket Dialer.Dial good
	http.HandleFunc("/ex7", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if untrustedInput == "localhost" {

			dialer := gorilla.Dialer{}
			dialer.Dial(untrustedInput, r.Header)
		}
	})

	// gorilla websocket Dialer.DialContext bad
	http.HandleFunc("/ex8", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		dialer := gorilla.Dialer{}
		dialer.DialContext(context.TODO(), untrustedInput, r.Header)
	})

	// gorilla websocket Dialer.DialContext good
	http.HandleFunc("/ex9", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if untrustedInput == "localhost" {

			dialer := gorilla.Dialer{}
			dialer.DialContext(context.TODO(), untrustedInput, r.Header)
		}
	})

	// gobwas websocket Dial good
	http.HandleFunc("/ex10", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if untrustedInput == "localhost" {
			gobwas.Dial(context.TODO(), untrustedInput)
		}
	})

	// gobwas websocket Dial bad
	http.HandleFunc("/ex11", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()
		gobwas.Dial(context.TODO(), untrustedInput)
	})

	// gobwas websocket Dialer.Dial bad
	http.HandleFunc("/ex12", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()
		dialer := gobwas.Dialer{}
		dialer.Dial(context.TODO(), untrustedInput)
	})

	// gobwas websocket Dialer.Dial good
	http.HandleFunc("/ex12", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if "localhost" == untrustedInput {
			dialer := gobwas.Dialer{}
			dialer.Dial(context.TODO(), untrustedInput)
		}
	})

	// sac007 websocket New good
	http.HandleFunc("/ex13", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if "localhost" == untrustedInput {
			sac.New(untrustedInput)
		}
	})

	// sac007 websocket BuildProxy good
	http.HandleFunc("/ex14", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		if "localhost" == untrustedInput {
			sac.BuildProxy(untrustedInput)
		}
	})

	// sac007 websocket BuildProxy bad
	http.HandleFunc("/ex15", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		sac.BuildProxy(untrustedInput)
	})

	// sac007 websocket New bad
	http.HandleFunc("/ex16", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		sac.New(untrustedInput)
	})

	log.Println(http.ListenAndServe(":80", nil))

}
