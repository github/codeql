package main

import (
	"net/http"
	"os/exec"
)

func handler(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"
	cmd := exec.Command("sh", "-c", fmt.Sprintf("imagetool %s > %s", imageName, outputPath))
	cmd.Run()
	// ...
}
