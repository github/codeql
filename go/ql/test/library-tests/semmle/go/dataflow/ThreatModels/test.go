package main

import (
	"github.com/nonexistent/sources"
	"net/http"
)

func Environment() {
	home := sources.ReadEnvironment("HOME")

	sink("SELECT * FROM " + home)
}

func Cli() {
	arg := sources.GetCliArg("arg")

	sink("SELECT * FROM " + arg)
}

func Custom() {
	query := sources.GetCustom("query")

	sink("SELECT * FROM " + query)
}

func StoredSqlInjection() {
	query := sources.ExecuteQuery("SELECT * FROM queries LIMIT 1")
	sink(query)
}

func Handler(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query().Get("query")

	sink("SELECT * FROM " + query)
}

func sink(s string) {
}
