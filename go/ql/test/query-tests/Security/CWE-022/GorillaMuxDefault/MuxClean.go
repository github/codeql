package main

import (
	"io/ioutil"
	"net/http"
	"path/filepath"

	"github.com/gorilla/mux"
)

// GOOD: Sanitized by Gorilla's cleaner
func GorillaHandler(w http.ResponseWriter, r *http.Request) {
	not_tainted_path := mux.Vars(r)["id"]
	data, _ := ioutil.ReadFile(filepath.Join("/home/user/", not_tainted_path))
	w.Write(data)
}

func main() {
	var router = mux.NewRouter()
	router.SkipClean(false)
	router.HandleFunc("/{category}", GorillaHandler)
}
