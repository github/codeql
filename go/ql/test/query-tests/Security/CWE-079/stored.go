package main

import (
	"database/sql"
	"io"
	"io/fs"
	"log"
	"net/http"
	"path/filepath"
)

var db *sql.DB
var q string

func storedserve1() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		rows, _ := db.Query(q, 32)

		for rows.Next() {
			var (
				id   int64
				name string
			)
			if err := rows.Scan(&id, &name); err != nil {
				log.Fatal(err)
			}

			// BAD: the stored XSS query assumes all query results are untrusted
			io.WriteString(w, name)
		}
	})
}

func storedserve2() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()
		rows, _ := db.Query(q, 32)

		for rows.Next() {
			var (
				id   int64
				name string
			)
			if err := rows.Scan(&id, &name); err != nil {
				log.Fatal(err)
			}

			// GOOD: name is checked against a constant value
			if name == "Sam" {
				io.WriteString(w, name)
			}
		}
	})
}

func storedserve3() {
	http.HandleFunc("/user", func(w http.ResponseWriter, r *http.Request) {
		filepath.WalkDir(".", func(path string, _ fs.DirEntry, err error) error {
			// BAD: filenames are considered to be untrusted
			io.WriteString(w, path)
			return nil
		})
	})
}
