package main

import (
	"context"
	"net/http"
	"net/url"
)

func testStdlibSources(w http.ResponseWriter, req *http.Request) {
	safeHost := req.Host                                                 // $ Source
	http.Redirect(w, req, "https://"+safeHost+"/path", http.StatusFound) // $ Alert

	safeURL := req.URL                           // $ Source
	w.Header().Set("Location", safeURL.String()) // $ Alert

	targetURL := url.URL{}
	targetURL.Host = safeHost    // URL is safe if Host is safe
	http.Get(targetURL.String()) // $ Alert
}

func testBarrierEdge1(w http.ResponseWriter, req *http.Request) {
	safeURL := req.URL

	query := safeURL.Query()                                       // query is not guaranteed to be safe
	http.Redirect(w, req, query.Get("redirect"), http.StatusFound) // not guaranteed to be safe
}

func testBarrierEdge2(w http.ResponseWriter, req *http.Request) {
	safeURL := req.URL

	urlString := safeURL.String()
	sliced := urlString[0:10]          // a substring of a safe URL is not guaranteed to be safe
	w.Header().Set("Location", sliced) // not guaranteed to be safe
}

func testFieldReads(w http.ResponseWriter, req *http.Request) {
	safeURL := req.URL // $ Source

	safeScheme := safeURL.Scheme // the scheme of a safe URL is safe
	safeHost := safeURL.Host     // the host of a safe URL is safe
	safePath := safeURL.Path     // the path of a safe URL is safe
	fragment := safeURL.Fragment // the fragment of a safe URL is not guaranteed to be safe
	user := safeURL.User         // the user of a safe URL is not guaranteed to be safe

	http.Redirect(w, req, "https://"+safeScheme+"://example.com", http.StatusFound) // $ Alert
	w.Header().Set("Location", "https://"+safeHost+"/path")                         // $ Alert
	http.Get("https://example.com" + safePath)                                      // $ Alert

	http.Get(fragment)      // not guaranteed to be safe
	http.Get(user.String()) // not guaranteed to be safe
}

func testRequestForgerySinks(req *http.Request) {
	safeURL := req.URL // $ Source

	// Standard library HTTP functions (request-forgery sinks)
	http.Get(safeURL.String())                           // $ Alert
	http.Post(safeURL.String(), "application/json", nil) // $ Alert
	http.PostForm(safeURL.String(), nil)                 // $ Alert
	http.Head(safeURL.String())                          // $ Alert

	// HTTP Client methods (request-forgery sinks)
	client := &http.Client{}
	client.Get(safeURL.String())                           // $ Alert
	client.Post(safeURL.String(), "application/json", nil) // $ Alert
	client.PostForm(safeURL.String(), nil)                 // $ Alert
	client.Head(safeURL.String())                          // $ Alert

	// NewRequest + Client.Do (request-forgery sinks)
	request, _ := http.NewRequest("GET", safeURL.String(), nil) // $ Alert
	client.Do(request)

	// NewRequestWithContext + Client.Do (request-forgery sinks)
	reqWithCtx, _ := http.NewRequestWithContext(context.TODO(), "POST", safeURL.String(), nil) // $ Alert
	client.Do(reqWithCtx)

	// RoundTrip method (request-forgery sink)
	request2, _ := http.NewRequest("GET", safeURL.String(), nil) // $ Alert
	transport := &http.Transport{}
	transport.RoundTrip(request2)
}

func testHostFieldAssignmentFlow(w http.ResponseWriter, req *http.Request) {
	safeHost := req.Host // $ Source

	targetURL, _ := url.Parse("http://example.com/data")
	targetURL.Host = safeHost // URL is safe if Host is safe

	http.Redirect(w, req, targetURL.String(), http.StatusFound) // $ Alert

	targetURL.Host = "something.else.com" // targetURL is not guaranteed to be safe now that Host is overwritten
	http.Get(targetURL.String())
}

func testFieldAccess(w http.ResponseWriter, req *http.Request) {
	safeURL := req.URL // $ Source

	safeHost := safeURL.Host         // the host of a safe URL is safe
	safePath := safeURL.Path         // the path of a safe URL is safe
	safeScheme := safeURL.Scheme     // the scheme of a safe URL is safe
	safeOpaquePart := safeURL.Opaque // the opaque part of a safe URL is safe

	// Reconstruct URL - still guaranteed to be safe
	reconstructed := safeScheme + "://" + safeHost + safePath
	http.Get(reconstructed) // $ Alert

	// Test individual fields
	http.Redirect(w, req, "https://"+safeHost+"/path", http.StatusFound) // $ Alert
	w.Header().Set("Location", "https://example.com"+safePath)           // $ Alert
	http.Post(safeScheme+"://example.com/api", "application/json", nil)  // $ Alert
	http.Post(safeOpaquePart, "application/json", nil)                   // $ Alert

	user := safeURL.User         // the user of a safe URL is not guaranteed to be safe
	query := safeURL.RawQuery    // the query of a safe URL is not guaranteed to be safe
	fragment := safeURL.Fragment // the fragment of a safe URL is not guaranteed to be safe

	if user != nil {
		http.Redirect(w, req, user.String(), http.StatusFound) // not guaranteed to be safe
	}
	w.Header().Set("Location", "https://example.com/?"+query) // not guaranteed to be safe
	http.Get("https://example.com/#" + fragment)              // not guaranteed to be safe
}
