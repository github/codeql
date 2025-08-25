package main

import "net/http"

func clearTestBad(sourceReq *http.Request) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	return string(b)
}

func clearTestBad2(sourceReq *http.Request, x bool) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	if x {
		clear(b)
	}
	return string(b)
}

func clearTestBad3(sourceReq *http.Request, x bool) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	if x {
		return string(b)
	}
	clear(b)
	return string(b)
}

func clearTestGood(sourceReq *http.Request) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	clear(b) // should prevent taint flow
	return string(b)
}

func clearTestGood2(sourceReq *http.Request, x bool) string {
	b := make([]byte, 8)
	sourceReq.Body.Read(b)
	clear(b) // should prevent taint flow
	if x {
		return string(b)
	}
	return ""
}
