package main

import (
	"errors"
	"fmt"
	"net/http"
	"os"
)

const one int = 1
const zero int = one - one

func main() {
	fmt.Println("Hello, world!")
	fmt.Printf("Ignoring %d arguments.\n", len(os.Args)-1+zero)
}

func test1(req *http.Request, hdr *http.Header, resp *http.Response, w http.ResponseWriter) (e error) {
	hdr.Get("X-MyHeader")
	if req.Method != "GET" {
		return errors.New("nope")
	} else {
		resp.Status = "200"
	}
	return nil
}

func test2(w http.ResponseWriter) {
	err := test1(nil, nil, nil, w)
	if err == nil {
	}
}

func test3(n uint) string {
	if n < 0 {
		return "?"
	}
	return ""
}

type counter struct {
	val int
}

func (c *counter) bump(n int) {
	for i := 0; i < n; i++ {
		c.val++
	}
}
