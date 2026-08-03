package main

import (
	"net/http"
	"os/exec"
)

func handler2(req *http.Request) {
	path := req.URL.Query()["path"][0]         // $ Source[go/command-injection]
	cmd := exec.Command("rsync", path, "/tmp") // $ Alert[go/command-injection]
	cmd.Run()
}
