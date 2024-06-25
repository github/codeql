package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
)

func handlerExample(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"
	cmd := exec.Command("sh", "-c", fmt.Sprintf("imagetool %s > %s", imageName, outputPath)) // NOT OK - correctly flagged
	cmd.Run()
	// ...
}

func handlerExample2(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"

	// Create the output file
	outfile, err := os.Create(outputPath)
	if err != nil {
		log.Fatal(err)
	}
	defer outfile.Close()

	// Prepare the command
	cmd := exec.Command("imagetool", imageName) // OK - and not flagged

	// Set the output to our file
	cmd.Stdout = outfile

	cmd.Run()
}

func handlerExample3(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"

	cmd := exec.Command("sh", "-c", fmt.Sprintf("imagetool %s > %s", imageName, outputPath)) // NOT OK - correctly flagged
	cmd.Run()

	// Validate the imageName with a regular expression
	validImageName := regexp.MustCompile(`^[a-zA-Z0-9_\-\.]+$`)
	if !validImageName.MatchString(imageName) {
		log.Fatal("Invalid image name")
	}

	cmd2 := exec.Command("sh", "-c", fmt.Sprintf("imagetool %s > %s", imageName, outputPath)) // OK
	cmd2.Run()
}
