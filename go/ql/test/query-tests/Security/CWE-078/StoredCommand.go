package main

import (
	"database/sql"
	"os/exec"
)

var db *sql.DB

func run(query string) {
	rows, _ := db.Query(query) // $ Source[go/stored-command]
	var cmdName string
	rows.Scan(&cmdName)
	cmd := exec.Command(cmdName) // $ Alert[go/stored-command]
	cmd.Run()
}
