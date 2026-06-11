package main

import (
	"encoding/json"
	"strings"

	sq "github.com/Masterminds/squirrel"
)

// Bad because quote characters are removed before concatenation,
// but then enclosed in a different enclosing quote:
func mismatch1(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version) // $ Source[go/unsafe-quoting]
	escaped := strings.Replace(string(versionJSON), "\"", "", -1)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("'"+escaped+"'")). // $ Alert[go/unsafe-quoting]
		Exec()
}

// Bad because quote characters are removed before concatenation,
// but then enclosed in a different enclosing quote:
func mismatch2(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version) // $ Source[go/unsafe-quoting]
	escaped := strings.Replace(string(versionJSON), "'", "", -1)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("\""+escaped+"\"")). // $ Alert[go/unsafe-quoting]
		Exec()
}
