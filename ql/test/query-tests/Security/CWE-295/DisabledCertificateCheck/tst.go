package main

import "testing"

func TestSomethingExciting(t *testing.T) {
	transport := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // OK
	}
	doStuffTo(transport)
}

func doStuffTo(t *http.Transport) {}
