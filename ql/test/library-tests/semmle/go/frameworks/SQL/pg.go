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
	pg.Q(query)
	var dst []byte
	conn.FormatQuery(dst, query)
	conn.Prepare(query)
	db.FormatQuery(dst, query)
	db.Prepare(query)
	tx.FormatQuery(dst, query)
	tx.Prepare(query)
}

// go-pg v9 dropped support for `FormatQuery`
func newpgtest(query string, conn newpg.Conn, db newpg.DB, tx newpg.Tx) {
	newpg.Q(query)
	conn.Prepare(query)
	db.Prepare(query)
	tx.Prepare(query)
}
func pgormtest(query string, q orm.Query) {
	orm.Q(query)
	q.ColumnExpr(query)
	q.For(query)
	var b []byte
	q.FormatQuery(b, query)
	q.Having(query)
	q.Where(query)
	q.WhereInMulti(query)
	q.WhereOr(query)
}
