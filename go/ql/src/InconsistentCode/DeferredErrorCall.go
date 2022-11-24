package main

import (
	"io"
	"log"
	"os"
)

func example() {
	defer io.WriteString(os.Stdout, "All done!")

	if _, err := io.WriteString(os.Stdout, "Hello"); err != nil {
		log.Fatal(err)
	}
}
