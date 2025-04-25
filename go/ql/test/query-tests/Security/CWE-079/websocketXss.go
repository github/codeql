package main

//go:generate depstubber -vendor github.com/gobwas/ws "" ReadFrame,WriteFrame,NewTextFrame,Dial
//go:generate depstubber -vendor github.com/gorilla/websocket Dialer ReadJSON,WriteJSON,NewPreparedMessage
//go:generate depstubber -vendor golang.org/x/net/websocket Codec Dial
//go:generate depstubber -vendor nhooyr.io/websocket "" Dial

import (
	"context"
	"fmt"
	"net/http"

	gorilla "github.com/gorilla/websocket"
	websocket "golang.org/x/net/websocket"
	nhooyr "nhooyr.io/websocket"
)

func marshal(v any) (data []byte, payloadType byte, err error) {
	return nil, 0, nil
}
func unmarshal(data []byte, payloadType byte, v any) (err error) {
	return nil
}

func xss(w http.ResponseWriter, r *http.Request) {
	uri := r.Header.Get("X-Header")
	origin := "test"
	{
		ws, _ := websocket.Dial(uri, "", origin)
		var xnet = make([]byte, 512) // $ Source[go/reflected-xss]
		ws.Read(xnet)
		fmt.Fprintf(w, "%v", xnet) // $ Alert[go/reflected-xss]
		codec := &websocket.Codec{Marshal: marshal, Unmarshal: unmarshal}
		xnet2 := make([]byte, 512) // $ Source[go/reflected-xss]
		codec.Receive(ws, xnet2)
		fmt.Fprintf(w, "%v", xnet2) // $ Alert[go/reflected-xss]
	}
	{
		n, _, _ := nhooyr.Dial(context.TODO(), uri, nil)
		_, nhooyr, _ := n.Read(context.TODO()) // $ Source[go/reflected-xss]
		fmt.Fprintf(w, "%v", nhooyr)           // $ Alert[go/reflected-xss]
	}
	{
		dialer := gorilla.Dialer{}
		conn, _, _ := dialer.Dial(uri, nil)
		var gorillaMsg = make([]byte, 512) // $ Source[go/reflected-xss]
		gorilla.ReadJSON(conn, gorillaMsg)
		fmt.Fprintf(w, "%v", gorillaMsg) // $ Alert[go/reflected-xss]

		gorilla2 := make([]byte, 512) // $ Source[go/reflected-xss]
		conn.ReadJSON(gorilla2)
		fmt.Fprintf(w, "%v", gorilla2) // $ Alert[go/reflected-xss]

		_, gorilla3, _ := conn.ReadMessage() // $ Source[go/reflected-xss]
		fmt.Fprintf(w, "%v", gorilla3)       // $ Alert[go/reflected-xss]

	}
}
