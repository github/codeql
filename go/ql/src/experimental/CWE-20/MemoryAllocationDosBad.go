package server

import (
	"net/http"
	"strconv"
)

func serve_bad() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {

		c, _ := strconv.Atoi(r.Form.Get("count"))
		_ = make([]int, c)

	})
	http.ListenAndServe(":80", nil)
}
