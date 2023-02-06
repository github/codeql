package main

import (
	"bytes"
	"encoding/json"
	"strings"

	sq "github.com/Masterminds/squirrel"
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

var globalReplacer = strings.NewReplacer("\"", "", "'", "")

// Good because quote characters are removed before concatenation:
func saveGood4(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	escaped := globalReplacer.Replace(string(versionJSON))
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("'"+escaped+"'")).
		Exec()
}

// Good because quote characters are removed before concatenation:
func saveGood5(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	buf := new(bytes.Buffer)
	globalReplacer.WriteString(buf, string(versionJSON))
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("'"+buf.String()+"'")).
		Exec()
}
