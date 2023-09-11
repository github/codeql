package main

import "net/http"

func clearTestBad(sourceReq *http.Request) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	return string(b)
}

func clearTestGood(sourceReq *http.Request) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	clear(b) // should prevent taint flow
	return string(b)
}
