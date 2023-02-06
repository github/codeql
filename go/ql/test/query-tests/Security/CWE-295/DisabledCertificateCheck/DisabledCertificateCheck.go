package main

import (
	"crypto/tls"
	"net/http"
)

func doAuthReq(authReq *http.Request) *http.Response {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, // NOT OK
	}
	client := &http.Client{Transport: tr}
	res, _ := client.Do(authReq)
	return res
}
