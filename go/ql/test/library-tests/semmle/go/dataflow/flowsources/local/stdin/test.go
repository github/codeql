package test

import (
	"bufio"
	"fmt"
	"os"
)

func sink(string) {

}

func readStdinBuffer() {
	buf := make([]byte, 1024)
	n, err := os.Stdin.Read(buf) // $source
	if err != nil {
		return
	}
	sink(string(buf[:n])) // $hasTaintFlow="type conversion"
}

func readStdinBuffReader() {
	buf := make([]byte, 1024)
	r := bufio.NewReader(os.Stdin) // $source
	n, err := r.Read(buf)
	if err != nil {
		return
	}
	sink(string(buf[:n])) // $hasTaintFlow="type conversion"
}

func scan() {
	var username, email string
	fmt.Scan(&username, &email) // $source
	sink(username)              // $hasTaintFlow="username"
}

func scanf() {
	var s string
	fmt.Scanf("%s", &s) // $source
	sink(s)             // $hasTaintFlow="s"
}

func scanl() {
	var s string
	fmt.Scanln(&s) // $source
	sink(s)        // $hasTaintFlow="s"
}
