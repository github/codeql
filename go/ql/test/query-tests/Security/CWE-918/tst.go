package main

import (
	"context"
	"net/http"
	"net/url"
)

func handler2(w http.ResponseWriter, req *http.Request) {
	tainted := req.FormValue("target")

	http.Get("example.com") // OK

	http.Get(tainted) // Not OK

	http.Head(tainted) // OK

	http.Post(tainted, "text/basic", nil) // Not OK

	client := &http.Client{}
	rq, _ := http.NewRequest("GET", tainted, nil)
	client.Do(rq) // Not OK

	rq, _ = http.NewRequestWithContext(context.Background(), "GET", tainted, nil)
	client.Do(rq) // Not OK

	http.Get("http://" + tainted) // Not OK

	http.Get("http://example.com" + tainted) // Not OK

	http.Get("http://example.com/" + tainted) // OK

	http.Get("http://example.com/?" + tainted) // OK

	u, _ := url.Parse("http://example.com/relative-path")
	u.Host = tainted
	http.Get(u.String()) // Not OK
}

func main() {

}
