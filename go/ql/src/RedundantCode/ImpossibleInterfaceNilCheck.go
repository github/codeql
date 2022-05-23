package main

import "fmt"

func fetch(url string) (string, *RequestError)

func niceFetch(url string) {
	var s string
	var e error
	s, e = fetch(url)
	if e != nil {
		fmt.Printf("Unable to fetch URL: %v\n", e)
	} else {
		fmt.Printf("URL contents: %s\n", s)
	}
}
