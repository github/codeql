package server

import (
	"net/http"
	"strconv"
)

func serve_good() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {

		c, _ := strconv.Atoi(r.Form.Get("count"))
		if c > 200 {
			c = 200
		}
		_ = make([]int, c)

	})
	http.ListenAndServe(":80", nil)
}
