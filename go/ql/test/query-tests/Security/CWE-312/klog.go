package main

//go:generate depstubber -vendor k8s.io/klog "" Info

import (
	"net/http"
	"strings"

	"k8s.io/klog"
)

func mask(key, value string) string {
	if strings.EqualFold(key, "Authorization") {
		return "<masked>"
	}
	return value
}

func klogTest() {
	http.HandleFunc("/klog", func(w http.ResponseWriter, r *http.Request) {
		for name, headers := range r.Header { // $ Source
			for _, header := range headers {
				klog.Info(header)             // $ Alert
				klog.Info(mask(name, header)) // OK
			}
		}
		klog.Info(r.Header.Get("Accept"))        // OK
		klog.Info(r.Header["Content-Type"])      // OK
		klog.Info(r.Header.Get("Authorization")) // $ Alert
	})
	http.ListenAndServe(":80", nil)
}
