package main

import (
	"net/http"
	"strconv"
)

func serve1() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {

		c, _ := strconv.Atoi(r.Form.Get("count"))
		_ = make([]int, c)

	})
	http.ListenAndServe(":80", nil)
}
