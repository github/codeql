package main

//go:generate depstubber -vendor github.com/gobwas/ws Dialer Dial
//go:generate depstubber -vendor github.com/gorilla/websocket Dialer
//go:generate depstubber -vendor github.com/sacOO7/gowebsocket "" New,BuildProxy
//go:generate depstubber -vendor golang.org/x/net/websocket "" Dial,NewConfig,DialConfig
//go:generate depstubber -vendor nhooyr.io/websocket "" Dial

import (
	"context"

	gobwas "github.com/gobwas/ws"
	gorilla "github.com/gorilla/websocket"
	sac "github.com/sacOO7/gowebsocket"
	"golang.org/x/net/websocket"
	nhooyr "nhooyr.io/websocket"
)

func main() {
	untrustedInput := r.Referer()

	origin := "http://localhost/"

	// bad as input is directly passed to dial function
	ws, _ := websocket.Dial(untrustedInput, "", origin)

	config, _ := websocket.NewConfig(untrustedInput, origin) // good
	ws2, _ := websocket.DialConfig(config)

	nhooyr.Dial(context.TODO(), untrustedInput, nil)

	dialer := gorilla.Dialer{}
	dialer.Dial(untrustedInput, r.Header)

	dialer.DialContext(context.TODO(), untrustedInput, r.Header)

	gobwas.Dial(context.TODO(), untrustedInput)

	dialer2 := gobwas.Dialer{}
	dialer2.Dial(context.TODO(), untrustedInput)

	sac.BuildProxy(untrustedInput)
	sac.New(untrustedInput)

}
