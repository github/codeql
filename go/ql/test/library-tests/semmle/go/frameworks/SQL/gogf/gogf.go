package main

//go:generate depstubber -vendor github.com/gogf/gf/frame/g "" DB
//go:generate depstubber -vendor github.com/gogf/gf/database/gdb DB,Core,TX ""

import (
	"context"

	"github.com/gogf/gf/database/gdb"
	"github.com/gogf/gf/frame/g"
)

func gogfCoreTest(sql string, c *gdb.Core, ctx context.Context) {
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
	c.DoCommit(ctx, nil, sql, nil) // $ querystring=sql
	c.DoExec(ctx, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(ctx, nil, sql, nil) // $ querystring=sql
	c.DoQuery(ctx, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(ctx, nil, sql)     // $ querystring=sql
}

func gogfDbtest(sql string, c gdb.DB, ctx context.Context) {
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
	c.DoCommit(ctx, nil, sql, nil) // $ querystring=sql
	c.DoExec(ctx, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(ctx, nil, sql, nil) // $ querystring=sql
	c.DoQuery(ctx, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(ctx, nil, sql)     // $ querystring=sql
}

func gogfGTest(sql string, ctx context.Context) {
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
	c.DoCommit(ctx, nil, sql, nil) // $ querystring=sql
	c.DoExec(ctx, nil, sql, nil)   // $ querystring=sql
	c.DoGetAll(ctx, nil, sql, nil) // $ querystring=sql
	c.DoQuery(ctx, nil, sql, nil)  // $ querystring=sql
	c.DoPrepare(ctx, nil, sql)     // $ querystring=sql
}

func main() {
	return
}
