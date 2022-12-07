package main

//go:generate depstubber -vendor github.com/gogf/gf/frame/g "" DB
//go:generate depstubber -vendor github.com/gogf/gf/database/gdb DB,Core,TX ""

import (
	"github.com/gogf/gf/database/gdb"
	"github.com/gogf/gf/frame/g"
)

func gogfCoreTest(sql string, c *gdb.Core) {
	c.Exec(sql, nil)               // $ querystring=sql
	c.GetAll(sql, nil)             // $ querystring=sql
	c.GetArray(sql, nil)           // $ querystring=sql
	c.GetCount(sql, nil)           // $ querystring=sql
	c.GetOne(sql, nil)             // $ querystring=sql
	c.GetValue(sql, nil)           // $ querystring=sql
	c.Prepare(sql, true)           // $ querystring=sql
	c.Query(sql, nil)              // $ querystring=sql
	c.Raw(sql, nil)                // $ querystring=sql
	c.GetScan(nil, sql, nil)       // $ querystring=sql
	c.GetStruct(nil, sql, nil)     // $ querystring=sql
	c.GetStructs(nil, sql, nil)    // $ querystring=sql
	c.DoCommit(nil, nil, sql, nil) // $ querystring=sql
	c.DoExec(nil, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(nil, nil, sql, nil) // $ querystring=sql
	c.DoQuery(nil, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(nil, nil, sql)     // $ querystring=sql
}

func gogfDbtest(sql string, c gdb.DB) {
	c.Exec(sql, nil)               // $ querystring=sql
	c.GetAll(sql, nil)             // $ querystring=sql
	c.GetArray(sql, nil)           // $ querystring=sql
	c.GetCount(sql, nil)           // $ querystring=sql
	c.GetOne(sql, nil)             // $ querystring=sql
	c.GetValue(sql, nil)           // $ querystring=sql
	c.Prepare(sql, true)           // $ querystring=sql
	c.Query(sql, nil)              // $ querystring=sql
	c.Raw(sql, nil)                // $ querystring=sql
	c.GetScan(nil, sql, nil)       // $ querystring=sql
	c.DoCommit(nil, nil, sql, nil) // $ querystring=sql
	c.DoExec(nil, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(nil, nil, sql, nil) // $ querystring=sql
	c.DoQuery(nil, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(nil, nil, sql)     // $ querystring=sql
}

func gogfGTest(sql string) {
	c := g.DB("ad")
	c.Exec(sql, nil)               // $ querystring=sql
	c.GetAll(sql, nil)             // $ querystring=sql
	c.GetArray(sql, nil)           // $ querystring=sql
	c.GetCount(sql, nil)           // $ querystring=sql
	c.GetOne(sql, nil)             // $ querystring=sql
	c.GetValue(sql, nil)           // $ querystring=sql
	c.Prepare(sql, true)           // $ querystring=sql
	c.Query(sql, nil)              // $ querystring=sql
	c.Raw(sql, nil)                // $ querystring=sql
	c.GetScan(nil, sql, nil)       // $ querystring=sql
	c.DoCommit(nil, nil, sql, nil) // $ querystring=sql
	c.DoExec(nil, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(nil, nil, sql, nil) // $ querystring=sql
	c.DoQuery(nil, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(nil, nil, sql)     // $ querystring=sql
}

func main() {
	return
}
