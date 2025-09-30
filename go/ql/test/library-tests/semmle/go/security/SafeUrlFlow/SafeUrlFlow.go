package main

import (
	"context"
	"net/http"
	"net/url"
)

func testStdlibSources(w http.ResponseWriter, req *http.Request) {
	host := req.Host                                                 // $ Source
	http.Redirect(w, req, "https://"+host+"/safe", http.StatusFound) // $ Alert

	baseURL := req.URL                           // $ Source
	w.Header().Set("Location", baseURL.String()) // $ Alert

	targetURL := url.URL{}
	targetURL.Host = host        // propagation to URL when Host is assigned
	http.Get(targetURL.String()) // $ Alert
}

func testSanitizerEdge1(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	// SanitizerEdge: Query method call (unsafe URL method - breaks flow)
	query := baseURL.Query()                                       // sanitizer edge blocks flow here
	http.Redirect(w, req, query.Get("redirect"), http.StatusFound) // no flow expected
}

func testSanitizerEdge2(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	// SanitizerEdge: String slicing (breaks flow)
	urlString := baseURL.String()
	sliced := urlString[0:10]          // sanitizer edge blocks flow here
	w.Header().Set("Location", sliced) // no flow expected
}

func testFieldReads(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL // $ Source

	// Test that other URL methods preserve flow
	scheme := baseURL.Scheme     // should preserve flow
	host := baseURL.Host         // should preserve flow
	path := baseURL.Path         // should preserve flow
	fragment := baseURL.Fragment // should preserve flow
	user := baseURL.User         // should preserve flow (but unsafe field)

	// These should still have flow (not sanitized)
	http.Redirect(w, req, "https://"+scheme+"://example.com", http.StatusFound) // $ Alert
	w.Header().Set("Location", "https://"+host+"/safe")                         // $ Alert
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
	safeHost := req.Host // $ Source

	// Test additional flow step: propagation when Host field is assigned
	targetURL, _ := url.Parse("http://example.com/data")
	targetURL.Host = safeHost // additional flow step from SafeUrlFlow config

	// Flow should propagate to the whole URL after Host assignment
	http.Redirect(w, req, targetURL.String(), http.StatusFound) // $ Alert
}

func testHostFieldOverwritten(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL

	// Flow should be blocked when Host is overwritten
	baseURL.Host = "something.else.com"
	http.Get(baseURL.String())
}

func testFieldAccess(w http.ResponseWriter, req *http.Request) {
	baseURL := req.URL // $ Source

	// Safe field accesses that should preserve flow
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
	use(opaquePart)                                                  // avoid unused variable warning

	// Unsafe field accesses that should be sanitized by UnsafeFieldReadSanitizer
	// These read unsafe URL fields and should NOT have flow
	unsafeUser := baseURL.User         // sanitizer edge (User field)
	unsafeQuery := baseURL.RawQuery    // sanitizer edge (RawQuery field)
	unsafeFragment := baseURL.Fragment // sanitizer edge (Fragment field)

	// These should NOT have flow due to sanitizer edges
	if unsafeUser != nil {
		http.Redirect(w, req, unsafeUser.String(), http.StatusFound) // no flow expected
	}
	w.Header().Set("Location", "https://example.com/?"+unsafeQuery) // no flow expected
	http.Get("https://example.com/#" + unsafeFragment)              // no flow expected
}

// Helper function to avoid unused variable warnings
func use(vars ...interface{}) {}
