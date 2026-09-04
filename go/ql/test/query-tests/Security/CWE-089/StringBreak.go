package main

import (
	"encoding/json"
	"fmt"

	sq "github.com/Masterminds/squirrel"
)

func save(id string, version interface{}) {
	versionJSON, _ := json.Marshal(version) // $ Source[go/unsafe-quoting]
	sq.StatementBuilder.
		Insert("resources").
		Columns("resource_id", "version_md5").
		Values(id, sq.Expr(fmt.Sprintf("md5('%s')", versionJSON))). // $ Alert[go/unsafe-quoting]
		Exec()
}
