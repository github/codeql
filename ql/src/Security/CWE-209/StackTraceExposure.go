package example

import (
	"log"
	"net/http"
	"runtime"
)

func handlePanic(w http.ResponseWriter, r *http.Request) {
	buf := make([]byte, 2<<16)
	buf = buf[:runtime.Stack(buf, true)]
	// BAD: printing a stack trace back to the response
	w.Write(buf)
	// GOOD: logging the response to the server and sending
	// a more generic message.
	log.Printf("Panic: %s", buf)
	w.Write([]byte("An unexpected runtime error occurred"))
}
