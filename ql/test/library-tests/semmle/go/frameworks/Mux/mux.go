package main

//go:generate depstubber -vendor github.com/gorilla/mux "" Vars,NewRouter

import (
	"fmt"
	"log"
	"net/http"
	"os/exec"

	"github.com/gorilla/mux"
)

func ArticlesHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Category: %v\n", vars["category"])
}

func CmdHandler(w http.ResponseWriter, r *http.Request) {
	cmdName := mux.Vars(r)["cmd"]

	cmd := exec.Command(cmdName)
	stdoutStderr, err := cmd.CombinedOutput()
	if err != nil {
		log.Print(err)
	}
	fmt.Fprintf(w, "%s\n", stdoutStderr)
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/run/{cmd}", CmdHandler)
	r.HandleFunc("/articles/{category}", ArticlesHandler)
	http.Handle("/", r)
	log.Fatal(http.ListenAndServe(":8090", nil))
}
