package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

func get_user_info() (string, error) {
	fmt.Println("Hello, World!")
	fmt.Println("*** Welcome to sql injection ***")
	fmt.Print("Please enter name: ")
	buf := make([]byte, 1024)
	count, err := os.Stdin.Read(buf)
	if err != nil {
		return "", err
	}
	trimmed := strings.TrimSpace(string(buf[0 : count-1]))
	return trimmed, nil
}

func get_new_id() int {
	return os.Getpid()
}

func write_info(id int, info string) {
	db, err := sql.Open("sqlite3", "./users.sqlite")
	if err != nil {
		log.Fatal(err)
	}
	query := fmt.Sprintf("INSERT INTO users VALUES (%d, '%s')", id, info)
	log.Printf("Running query: %s", query)
	_, err = db.Exec(query)
	if err != nil {
		log.Fatal(err)
	}
	db.Close()
}

func main() {
	log.Printf("sqli started")
	info, err := get_user_info()
	if err != nil {
		log.Printf("get_user_info failed: %s", err)
		os.Exit(1)
	}
	id := get_new_id()
	write_info(id, info)
	log.Printf("sqli finished")
}
