package main

import (
	"net/http"
	"os/exec"
)

func handler(req *http.Request) {
	path := req.URL.Query()["path"][0]
	cmd := exec.Command("rsync", path, "/tmp")
	cmd.Run()
}
