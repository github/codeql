package main

import (
	"io"
	"log"
	"os"
)

func example() {
	if _, err := io.WriteString(os.Stdout, "Hello"); err != nil {
		log.Fatal(err)
	}

	if _, err := io.WriteString(os.Stdout, "All done!"); err != nil {
		log.Fatal(err)
	}
}
