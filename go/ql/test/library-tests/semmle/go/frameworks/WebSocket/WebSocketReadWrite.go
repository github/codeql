package main

//go:generate depstubber -vendor github.com/gobwas/ws Dialer ReadFrame,WriteFrame,NewTextFrame,Dial
//go:generate depstubber -vendor github.com/gorilla/websocket Dialer ReadJSON,WriteJSON,NewPreparedMessage
//go:generate depstubber -vendor golang.org/x/net/websocket Codec Dial,NewConfig,DialConfig
//go:generate depstubber -vendor nhooyr.io/websocket "" Dial

import (
	"context"
	"io"
	"net/http"

	gobwas "github.com/gobwas/ws"
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
		ws.Write([]byte(xnet))
		codec := &websocket.Codec{marshal, unmarshal}
		xnet2 := make([]byte, 512)
		codec.Receive(ws, xnet2)
		codec.Send(ws, []byte(xnet2))
	}
	{
		n, _, _ := nhooyr.Dial(context.TODO(), uri, nil)
		_, nhooyr, _ := n.Read(context.TODO())
		n.Write(context.TODO(), 0, nhooyr)

		_, nhooyrReader, _ := n.Reader(context.TODO())
		writer, _ := n.Writer(context.TODO(), 0)
		io.Copy(writer, nhooyrReader)
	}
	{
		dialer := gorilla.Dialer{}
		conn, _, _ := dialer.Dial(uri, nil)
		var gorillaMsg = make([]byte, 512)
		gorilla.ReadJSON(conn, gorillaMsg)
		gorilla.WriteJSON(conn, gorillaMsg)

		gorilla2 := make([]byte, 512)
		conn.ReadJSON(gorilla2)
		pm, _ := gorilla.NewPreparedMessage(0, gorilla2)
		conn.WritePreparedMessage(pm)
		conn.WriteJSON(gorilla2)

		_, gorilla3, _ := conn.ReadMessage()
		conn.WriteMessage(0, gorilla3)

	}
	{
		conn, _, _, _ := gobwas.Dial(context.TODO(), uri)
		frame, _ := gobwas.ReadFrame(conn)

		gobwas.WriteFrame(conn, frame)

		resp := gobwas.NewTextFrame([]byte(uri))
		gobwas.WriteFrame(conn, resp)
	}
}
