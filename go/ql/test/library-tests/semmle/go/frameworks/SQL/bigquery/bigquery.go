package main

//go:generate depstubber -vendor cloud.google.com/go/bigquery Client

import (
	"cloud.google.com/go/bigquery"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {
	untrusted := getUntrustedString()
	var client *bigquery.Client

	client.Query(untrusted) // $ querystring=untrusted
}
