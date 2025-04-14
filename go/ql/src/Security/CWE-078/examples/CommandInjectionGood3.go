package main

import (
	"log"
	"net/http"
	"os/exec"
	"strings"
)

func handler(req *http.Request) {
	repoURL := req.URL.Query()["repoURL"][0]
	outputPath := "/tmp/repo"

	// Sanitize the repoURL to ensure it does not start with "--"
	if strings.HasPrefix(repoURL, "--") {
		log.Fatal("Invalid repository URL")
	} else {
		cmd := exec.Command("git", "clone", repoURL, outputPath)
		err := cmd.Run()
		if err != nil {
			log.Fatal(err)
		}
	}

	// Or: add "--" to ensure that the repoURL is not interpreted as a flag
	cmd := exec.Command("git", "clone", "--", repoURL, outputPath)
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}
