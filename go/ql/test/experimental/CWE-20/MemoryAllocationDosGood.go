package server

import (
	"net/http"
	"strconv"
)

type testStruct struct {
	PageSize int
}


func getInt(r *http.Request) int {
	ret, _ := strconv.Atoi(r.Form.Get("count3"))
	return ret
}

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
