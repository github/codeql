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

func myHandler3(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.ParseInt(param1, 10, 64)
	out := 1337 / value
	fmt.Println(out)
}

func myHandler4(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.ParseFloat(param1, 32)
	out := 1337 / value
	fmt.Println(out)
}

func myHandler5(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.ParseUint(param1, 10, 64)
	out := 1337 / value
	fmt.Println(out)
}

func myHandler6(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value := int(param1[0])
	if value != 0 {
		out := 1337 / value
		fmt.Println(out)
	}
}

func myHandler7(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value := int(param1[0])
	if value >= 0 {
		out := 1337 / value
		fmt.Println(out)
	}
}

func myHandler8(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.ParseInt(param1, 10, 64)
	if value > 0 {
		out := 1337 / value
		fmt.Println(out)
	}
}

func myHandler9(w http.ResponseWriter, r *http.Request) {
	param1 := r.URL.Query()["param1"][0]
	value, _ := strconv.ParseInt(param1, 10, 64)
	if value == 0 {
		fmt.Println(param1)
		return
	}
	out := 1337 / value
	fmt.Println(out)
}
