package main

import (
	"database/sql"
	"os/exec"
)

var db *sql.DB

func run(query string) {
	rows, _ := db.Query(query)
	var cmdName string
	rows.Scan(&cmdName)
	if cmdName == "mybinary1" || cmdName == "mybinary2" {
		cmd := exec.Command(cmdName)
	}
	cmd.Run()
}
