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

func marshal(v interface{}) (data []byte, payloadType byte, err error) {
	return nil, 0, nil
}
func unmarshal(data []byte, payloadType byte, v interface{}) (err error) {
	return nil
}

func xss(w http.ResponseWriter, r *http.Request) {
	uri := r.Header.Get("X-Header")
	origin := "test"
	{
		ws, _ := websocket.Dial(uri, "", origin)
		var xnet = make([]byte, 512)
		ws.Read(xnet)
		fmt.Fprintf(w, "%v", xnet)
		codec := &websocket.Codec{marshal, unmarshal}
		xnet2 := make([]byte, 512)
		codec.Receive(ws, xnet2)
		fmt.Fprintf(w, "%v", xnet2)
	}
	{
		n, _, _ := nhooyr.Dial(context.TODO(), uri, nil)
		_, nhooyr, _ := n.Read(context.TODO())
		fmt.Fprintf(w, "%v", nhooyr)
	}
	{
		dialer := gorilla.Dialer{}
		conn, _, _ := dialer.Dial(uri, nil)
		var gorillaMsg = make([]byte, 512)
		gorilla.ReadJSON(conn, gorillaMsg)
		fmt.Fprintf(w, "%v", gorillaMsg)

		gorilla2 := make([]byte, 512)
		conn.ReadJSON(gorilla2)
		fmt.Fprintf(w, "%v", gorilla2)

		_, gorilla3, _ := conn.ReadMessage()
		fmt.Fprintf(w, "%v", gorilla3)

	}
}
