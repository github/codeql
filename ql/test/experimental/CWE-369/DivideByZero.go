package main

import (
	"fmt"
	"net/http"
	"strconv"
)

func myHandler1(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.Atoi(param1)
	out := 1337 / value
	fmt.Println(out)
}

func myHandler2(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value := int(param1[0])
	out := 1337 / value
	fmt.Println(out)
}
