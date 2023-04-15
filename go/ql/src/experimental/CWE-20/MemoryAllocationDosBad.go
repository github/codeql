package server

import (
	"net/http"
	"strconv"
)

type testStruct struct {
	PageSize int
}


func serve_bad() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {

		c, _ := strconv.Atoi(r.Form.Get("count"))
		_ = make([]int, c)

		d, _ := strconv.Atoi(r.Form.Get("count2"))
		if(d <= 0){
			d = 20
		}
		_ = make([]int, d)

		e, _ := strconv.Atoi(r.Form.Get("count3"))
		if(e > 0){
			// some extra operation
		}
		_ = make([]int, e)

	})
	http.ListenAndServe(":80", nil)
}
