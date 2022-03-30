package main

import (
	"encoding/json"
	sq "github.com/Masterminds/squirrel"
	"strings"
)

// Bad because quote characters are removed before concatenation,
// but then enclosed in a different enclosing quote:
func mismatch1(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	escaped := strings.Replace(string(versionJSON), "\"", "", -1)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("'"+escaped+"'")).
		Exec()
}

// Bad because quote characters are removed before concatenation,
// but then enclosed in a different enclosing quote:
func mismatch2(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	escaped := strings.Replace(string(versionJSON), "'", "", -1)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("\""+escaped+"\"")).
		Exec()
}
