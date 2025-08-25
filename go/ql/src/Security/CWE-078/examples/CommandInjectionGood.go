package main

import (
	"log"
	"net/http"
	"os"
	"os/exec"
)

func handler(req *http.Request) {
	imageName := req.URL.Query()["imageName"][0]
	outputPath := "/tmp/output.svg"

	// Create the output file
	outfile, err := os.Create(outputPath)
	if err != nil {
		log.Fatal(err)
	}
	defer outfile.Close()

	// Prepare the command
	cmd := exec.Command("imagetool", imageName)

	// Set the output to our file
	cmd.Stdout = outfile

	cmd.Run()
}
