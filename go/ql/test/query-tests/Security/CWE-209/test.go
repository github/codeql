package test

import (
	"log"
	"net/http"
	"runtime"
)

var debug, development, trace, enableStackTrace, disableStackTrace, printStackTrace bool

var logger log.Logger

func handlePanic(w http.ResponseWriter, r *http.Request) {
	buf := make([]byte, 2<<16)
	buf = buf[:runtime.Stack(buf, true)]
	// BAD: printing a stack trace back to the response
	w.Write(buf)
	// GOOD: logging the response to the server and sending
	// a more generic message.
	logger.Printf("Panic: %s", buf)
	w.Write([]byte("An unexpected runtime error occurred"))
	// GOOD: guarding remote stack dumps with tests that suggest an opt-in debug mode:
	if debug {
		w.Write(buf)
	}
	if development {
		w.Write(buf)
	}
	if trace {
		w.Write(buf)
	}
	if enableStackTrace {
		w.Write(buf)
	}
	if !disableStackTrace {
		w.Write(buf) // Note our analysis doesn't actually check this branch goes the right way
	}
	if printStackTrace {
		w.Write(buf)
	}
}
