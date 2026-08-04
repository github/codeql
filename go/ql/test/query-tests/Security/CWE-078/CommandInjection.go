package main

import (
	"net/http"
	"os/exec"
)

func handler(req *http.Request) {
	cmdName := req.URL.Query()["cmd"][0] // $ Source[go/command-injection]
	cmd := exec.Command(cmdName)         // $ Alert[go/command-injection]
	cmd.Run()
}
