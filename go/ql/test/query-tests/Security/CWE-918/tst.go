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

	http.Head(tainted) // OK

	http.Post(tainted, "text/basic", nil) // $ Alert

	client := &http.Client{}
	rq, _ := http.NewRequest("GET", tainted, nil) // $ Sink
	client.Do(rq)                                 // $ Alert

	rq, _ = http.NewRequestWithContext(context.Background(), "GET", tainted, nil) // $ Sink
	client.Do(rq)                                                                 // $ Alert

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
