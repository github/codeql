package main

import (
	"net/http"
	"os/exec"
)

func handler(req *http.Request) {
	cmdName := req.URL.Query()["cmd"][0]
	cmd := exec.Command(cmdName)
	cmd.Run()
}
