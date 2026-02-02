package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/go-chi/chi"
	"github.com/go-playground/validator"
	"github.com/gorilla/mux"
)

func HandlerGin(c *gin.Context) {
	var body struct {
		integer int
		float   float32
		boolean bool
		word    string
		safe    string `binding:"alphanum"`
	}

	err := c.ShouldBindJSON(&body) // $ Source

	http.Get(fmt.Sprintf("http://example.com/%d", body.integer)) // OK
	http.Get(fmt.Sprintf("http://example.com/%v", body.float))   // OK
	http.Get(fmt.Sprintf("http://example.com/%v", body.boolean)) // OK
	http.Get(fmt.Sprintf("http://example.com/%s", body.word))    // $ Alert
	http.Get(fmt.Sprintf("http://example.com/%s", body.safe))    // $ Alert

	if err == nil {
		http.Get(fmt.Sprintf("http://example.com/%s", body.word)) // $ Alert
		http.Get(fmt.Sprintf("http://example.com/%s", body.safe)) // OK
	}

	taintedParam := c.Param("id") // $ Source

	validate := validator.New()
	err = validate.Var(taintedParam, "alpha")
	if err == nil {
		http.Get("http://example.com/" + taintedParam) // OK
	}

	http.Get("http://example.com/" + taintedParam) // $ Alert

	taintedQuery := c.Query("id")                  // $ Source
	http.Get("http://example.com/" + taintedQuery) // $ Alert
}

func HandlerHttp(req *http.Request) {
	//HTTP
	var body struct {
		integer int
		float   float32
		boolean bool
		word    string
		safe    string `validate:"alphanum"`
	}
	reqBody, _ := ioutil.ReadAll(req.Body) // $ Source
	json.Unmarshal(reqBody, &body)

	http.Get(fmt.Sprintf("http://example.com/%d", body.integer)) // OK
	http.Get(fmt.Sprintf("http://example.com/%v", body.float))   // OK
	http.Get(fmt.Sprintf("http://example.com/%v", body.boolean)) // OK
	http.Get(fmt.Sprintf("http://example.com/%s", body.word))    // $ Alert
	http.Get(fmt.Sprintf("http://example.com/%s", body.safe))    // $ Alert

	validate := validator.New()
	err := validate.Struct(body)
	if err == nil {
		http.Get(fmt.Sprintf("http://example.com/%s", body.word)) // $ Alert
		http.Get(fmt.Sprintf("http://example.com/%s", body.safe)) // OK
	}

	taintedQuery := req.URL.Query().Get("param1")  // $ Source
	http.Get("http://example.com/" + taintedQuery) // $ Alert

	taintedParam := strings.TrimPrefix(req.URL.Path, "/example-path/") // $ Source
	http.Get("http://example.com/" + taintedParam)                     // $ Alert
}

func HandlerMux(r *http.Request) {
	vars := mux.Vars(r) // $ Source
	taintedParam := vars["id"]
	http.Get("http://example.com/" + taintedParam) // $ Alert

	numericID, _ := strconv.Atoi(taintedParam)
	http.Get(fmt.Sprintf("http://example.com/%d", numericID)) // OK
}

func HandlerChi(r *http.Request) {
	taintedParam := chi.URLParam(r, "articleID")   // $ Source
	http.Get("http://example.com/" + taintedParam) // $ Alert

	b, _ := strconv.ParseBool(taintedParam)
	http.Get(fmt.Sprintf("http://example.com/%t", b)) // OK
}
