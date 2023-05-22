package main

//go:generate depstubber -vendor github.com/go-pg/pg Conn,DB,Tx Q
//go:generate depstubber -vendor github.com/go-pg/pg/orm Query Q
//go:generate depstubber -vendor github.com/go-pg/pg/v9 Conn,DB,Tx Q

import (
	"github.com/go-pg/pg"
	"github.com/go-pg/pg/orm"
	newpg "github.com/go-pg/pg/v9"
)

func pgtest(query string, conn pg.Conn, db pg.DB, tx pg.Tx) {
	pg.Q(query) // $ querystring=query
	var dst []byte
	conn.FormatQuery(dst, query) // $ querystring=query
	conn.Prepare(query)          // $ querystring=query
	db.FormatQuery(dst, query)   // $ querystring=query
	db.Prepare(query)            // $ querystring=query
	tx.FormatQuery(dst, query)   // $ querystring=query
	tx.Prepare(query)            // $ querystring=query
}

// go-pg v9 dropped support for `FormatQuery`
func newpgtest(query string, conn newpg.Conn, db newpg.DB, tx newpg.Tx) {
	newpg.Q(query)      // $ querystring=query
	conn.Prepare(query) // $ querystring=query
	db.Prepare(query)   // $ querystring=query
	tx.Prepare(query)   // $ querystring=query
}

func sink(x interface{}) {}

func pgormtest(query string, q orm.Query) {
	orm.Q(query)        // $ querystring=query
	q.ColumnExpr(query) // $ querystring=query
	q.For(query)        // $ querystring=query
	var b []byte
	q.FormatQuery(b, query) // $ querystring=query
	q.Having(query)         // $ querystring=query
	q.Where(query)          // $ querystring=query
	q.WhereInMulti(query)   // $ querystring=query
	q.WhereOr(query)        // $ querystring=query

	var formatter orm.Formatter
	var sink1 []byte

	sink2 := formatter.Append(sink1, "Appended1")
	sink3 := formatter.AppendBytes(sink1, []byte("Appended2"))
	sink4 := formatter.FormatQuery(sink1, "Query")

	sink(sink1) // $ flowfrom=Appended1 $ flowfrom=Appended2 $ flowfrom=Query
	sink(sink2) // $ flowfrom=Appended1
	sink(sink3) // $ flowfrom=Appended2
	sink(sink4) // $ flowfrom=Query
}
