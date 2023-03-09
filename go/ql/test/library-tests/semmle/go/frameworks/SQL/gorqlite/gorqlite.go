package main

//go:generate depstubber -vendor github.com/rqlite/gorqlite Connection Open

import (
	"github.com/rqlite/gorqlite"
)

func gorqlitetest(sql string, sqls []string) {
	conn, _ := gorqlite.Open("dbUrl")
	conn.Query(sqls)   // $ querystring=sqls
	conn.Queue(sqls)   // $ querystring=sqls
	conn.Write(sqls)   // $ querystring=sqls
	conn.QueryOne(sql) // $ querystring=sql
	conn.QueueOne(sql) // $ querystring=sql
	conn.WriteOne(sql) // $ querystring=sql
}
func main() {
	return
}
