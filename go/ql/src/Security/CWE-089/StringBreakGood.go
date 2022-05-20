package main

import (
	"encoding/json"
	sq "github.com/Masterminds/squirrel"
)

func saveGood(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version)
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr("md5(?)", versionJSON)).
		Exec()
}
