package test

//go:generate depstubber -vendor github.com/rqlite/gorqlite Connection,QueryResult

import (
	"context"

	"github.com/rqlite/gorqlite"
)

func parameterize(query string) gorqlite.ParameterizedStatement {
	return gorqlite.ParameterizedStatement{
		Query:     query,
		Arguments: []interface{}{},
	}
}

func test_rqlite_gorqlite(conn *gorqlite.Connection, ctx context.Context, query []string) {
	v1, err := conn.Query(query) // $ source
	if err != nil {
		return
	}

	sink(v1) // $ hasTaintFlow="v1"

	v2, err := conn.QueryContext(ctx, query) // $ source
	if err != nil {
		return
	}

	sink(v2) // $ hasTaintFlow="v2"

	v3, err := conn.QueryOne(query[0]) // $ source
	if err != nil {
		return
	}

	r3, err := v3.Slice()
	if err != nil {
		return
	}

	sink(r3) // $ hasTaintFlow="r3"

	v4, err := conn.QueryOneContext(ctx, query[0]) // $ source
	if err != nil {
		return
	}

	var r41, r42, r43 string
	v4.Scan(&r41, &r42, &r43)

	v5, err := conn.QueryOneParameterized(parameterize(query[0])) // $ source
	if err != nil {
		return
	}

	r5, err := v5.Map()

	r5Name := r5["name"]

	sink(r5Name) // $ hasTaintFlow="r5Name"

	v6, err := conn.QueryOneParameterizedContext(ctx, parameterize(query[0])) // $ source
	if err != nil {
		return
	}

	sink(v6) // $ hasTaintFlow="v6"

	v7, err := conn.QueryParameterized([]gorqlite.ParameterizedStatement{parameterize(query[0])}) // $ source
	if err != nil {
		return
	}

	sink(v7) // $ hasTaintFlow="v7"

	v8, err := conn.QueryParameterizedContext(ctx, []gorqlite.ParameterizedStatement{parameterize(query[0])}) // $ source
	if err != nil {
		return
	}

	sink(v8) // $ hasTaintFlow="v8"
}
