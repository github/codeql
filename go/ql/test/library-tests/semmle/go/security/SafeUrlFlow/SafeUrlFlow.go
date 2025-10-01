package main

import (
	"context"
	"net/http"
	"net/url"
)

func testStdlibSources(w http.ResponseWriter, req *http.Request) {
	host := req.Host                                                 // $ Source
	http.Redirect(w, req, "https://"+host+"/path", http.StatusFound) // $ Alert

	baseURL := req.URL                           // $ Source
	w.Header().Set("Location", baseURL.String()) // $ Alert

	targetURL := url.URL{}
	targetURL.Host = host        // additional flow step from Host field to URL struct
	http.Get(targetURL.String()) // $ Alert
}

func testBarrierEdge1(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	query := baseURL.Query()                                       // barrier edge blocks flow here
	http.Redirect(w, req, query.Get("redirect"), http.StatusFound) // no flow expected
}

func testBarrierEdge2(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	urlString := baseURL.String()
	sliced := urlString[0:10]          // barrier edge (string slicing) blocks flow here
	w.Header().Set("Location", sliced) // no flow expected
}

func testFieldReads(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL // $ Source

	// Test that other URL methods preserve flow
	scheme := baseURL.Scheme     // should preserve flow
	host := baseURL.Host         // should preserve flow
	path := baseURL.Path         // should preserve flow
	fragment := baseURL.Fragment // should not preserve flow
	user := baseURL.User         // should not preserve flow

	// These should still have flow (not sanitized)
	http.Redirect(w, req, "https://"+scheme+"://example.com", http.StatusFound) // $ Alert
	w.Header().Set("Location", "https://"+host+"/path")                         // $ Alert
	http.Get("https://example.com" + path)                                      // $ Alert
	http.Get(fragment)
	http.Get(user.String())
}

func testRequestForgerySinks(req *http.Request) {
	baseURL := req.URL // $ Source

	// Standard library HTTP functions (request-forgery sinks)
	http.Get(baseURL.String())                           // $ Alert
	http.Post(baseURL.String(), "application/json", nil) // $ Alert
	http.PostForm(baseURL.String(), nil)                 // $ Alert
	http.Head(baseURL.String())                          // $ Alert

	// HTTP Client methods (request-forgery sinks)
	client := &http.Client{}
	client.Get(baseURL.String())                           // $ Alert
	client.Post(baseURL.String(), "application/json", nil) // $ Alert
	client.PostForm(baseURL.String(), nil)                 // $ Alert
	client.Head(baseURL.String())                          // $ Alert

	// NewRequest + Client.Do (request-forgery sinks)
	request, _ := http.NewRequest("GET", baseURL.String(), nil) // $ Alert
	client.Do(request)

	// NewRequestWithContext + Client.Do (request-forgery sinks)
	reqWithCtx, _ := http.NewRequestWithContext(context.TODO(), "POST", baseURL.String(), nil) // $ Alert
	client.Do(reqWithCtx)

	// RoundTrip method (request-forgery sink)
	request2, _ := http.NewRequest("GET", baseURL.String(), nil) // $ Alert
	transport := &http.Transport{}
	transport.RoundTrip(request2)
}

func testHostFieldAssignmentFlow(w http.ResponseWriter, req *http.Request) {
	host := req.Host // $ Source

	targetURL, _ := url.Parse("http://example.com/data")
	targetURL.Host = host // additional flow step from Host field to URL struct

	http.Redirect(w, req, targetURL.String(), http.StatusFound) // $ Alert
}

func testHostFieldOverwritten(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	baseURL.Host = "something.else.com" // barrier edge (Host field overwritten) blocks flow here
	http.Get(baseURL.String())
}

func testFieldAccess(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL // $ Source

	// These field accesses should preserve flow
	host := baseURL.Host
	path := baseURL.Path
	scheme := baseURL.Scheme
	opaquePart := baseURL.Opaque

	// Reconstruct URL - flow should be preserved through field access
	reconstructed := scheme + "://" + host + path
	http.Get(reconstructed) // $ Alert

	// Test individual fields
	http.Redirect(w, req, "https://"+host+"/path", http.StatusFound) // $ Alert
	w.Header().Set("Location", "https://example.com"+path)           // $ Alert
	http.Post(scheme+"://example.com/api", "application/json", nil)  // $ Alert
	http.Post(opaquePart, "application/json", nil)                   // $ Alert

	// These field accesses should block flow
	user := baseURL.User         // barrier edge (User field)
	query := baseURL.RawQuery    // barrier edge (RawQuery field)
	fragment := baseURL.Fragment // barrier edge (Fragment field)

	if user != nil {
		http.Redirect(w, req, user.String(), http.StatusFound) // no flow expected
	}
	w.Header().Set("Location", "https://example.com/?"+query) // no flow expected
	http.Get("https://example.com/#" + fragment)              // no flow expected
}

// Helper function to avoid unused variable warnings
func use(vars ...interface{}) {}
