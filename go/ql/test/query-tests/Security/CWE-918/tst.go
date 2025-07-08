package main

import (
	"context"
	"net/http"
	"net/url"
)

func handler2(w http.ResponseWriter, req *http.Request) {
	tainted := req.FormValue("target") // $ Source

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
	u.Host = tainted
	http.Get(u.String()) // $ Alert
}

func main() {

}
