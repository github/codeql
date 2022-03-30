package main

import "fmt"

func niceFetchGood(url string) {
	s, e := fetch(url)
	if e != nil {
		fmt.Printf("Unable to fetch URL: %v\n", e)
	} else {
		fmt.Printf("URL contents: %s\n", s)
	}
}
