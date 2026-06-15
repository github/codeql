package main

import (
	"context"
	"fmt"
	"net/http"
	"net/url"
)

func handler2(w http.ResponseWriter, req *http.Request) {
	tainted := req.FormValue("target") // $ Source
	// Gratuitous copy due to use-use flow propagating sanitization when
	// used as a suffix in the last two OK cases forwards onto the final
	// Not OK case.
	tainted2 := tainted

	http.Get("example.com") // OK

	http.Get(tainted) // $ Alert

	http.Head(tainted) // $ Alert

	http.Post(tainted, "text/basic", nil) // $ Alert

	http.PostForm(tainted, nil) // $ Alert

	client := &http.Client{}
	rq1, _ := http.NewRequest("GET", tainted, nil) // $ Sink
	client.Do(rq1)                                 // $ Alert

	rq2, _ := http.NewRequestWithContext(context.Background(), "GET", tainted, nil) // $ Sink
	client.Do(rq2)                                                                  // $ Alert

	client.Get(tainted)                     // $ Alert
	client.Head(tainted)                    // $ Alert
	client.Post(tainted, "text/basic", nil) // $ Alert
	client.PostForm(tainted, nil)           // $ Alert

	http.Get("http://" + tainted) // $ Alert

	http.Get("http://example.com" + tainted) // $ Alert

	http.Get("http://example.com/" + tainted) // OK

	http.Get("http://example.com/?" + tainted) // OK

	u, _ := url.Parse("http://example.com/relative-path")
	u.Host = tainted2
	http.Get(u.String()) // $ Alert

	// Simple types are considered sanitized.
	url := fmt.Sprintf("%s/%d", "some-url", intSource())
	http.Get("http://" + url)
}

func main() {

}

func intSource() int64 {
	return 0
}
