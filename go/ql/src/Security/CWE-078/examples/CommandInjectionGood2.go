package main

import (
	"log"
	"net/http"
	"os/exec"
	"regexp"
)

func handler(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"

	// Validate the imageName with a regular expression
	validImageName := regexp.MustCompile(`^[a-zA-Z0-9_\-\.]+$`)
	if !validImageName.MatchString(imageName) {
		log.Fatal("Invalid image name")
		return
	}

	cmd := exec.Command("sh", "-c", fmt.Sprintf("imagetool %s > %s", imageName, outputPath))
	cmd.Run()
}
