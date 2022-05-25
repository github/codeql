package main

//go:generate depstubber -vendor github.com/sacOO7/gowebsocket "" New,BuildProxy

import (
	"context"

	gobwas "github.com/gobwas/ws"
	gorilla "github.com/gorilla/websocket"
	sac "github.com/sacOO7/gowebsocket"
	"golang.org/x/net/websocket"
	nhooyr "nhooyr.io/websocket"
)

func main() {
	untrustedInput := "referrer"

	origin := "http://localhost/"

	// bad as input is directly passed to dial function
	websocket.Dial(untrustedInput, "", origin)

	config, _ := websocket.NewConfig(untrustedInput, origin) // good
	websocket.DialConfig(config)

	nhooyr.Dial(context.TODO(), untrustedInput, nil)

	dialer := gorilla.Dialer{}
	dialer.Dial(untrustedInput, nil)

	dialer.DialContext(context.TODO(), untrustedInput, nil)

	gobwas.Dial(context.TODO(), untrustedInput)

	dialer2 := gobwas.Dialer{}
	dialer2.Dial(context.TODO(), untrustedInput)

	sac.BuildProxy(untrustedInput)
	sac.New(untrustedInput)
}
