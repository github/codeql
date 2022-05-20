package main

import (
	"encoding/json"
	sq "github.com/Masterminds/squirrel"
	"strings"
)

// Good because there is no concatenation with quotes:
func saveGood(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("md5(?)", versionJSON)).
		Exec()
}

// Good because quote characters are removed before concatenation:
func saveGood2(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	escaped := strings.Replace(string(versionJSON), "\"", "", -1)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("\""+escaped+"\"")).
		Exec()
}

// Good because quote characters are removed before concatenation:
func saveGood3(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	escaped := strings.ReplaceAll(string(versionJSON), "'", "")
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("'"+escaped+"'")).
		Exec()
}
