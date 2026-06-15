package main

import (
	"context"
	"database/sql/driver"
)

var (
	driver1 string
	driver2 string
	driver3 string
	driver4 string
	driver5 string
	driver6 string
)

func testDriver(ctx context.Context, execer driver.Execer,
	execerContext driver.ExecerContext,
	conn driver.Conn,
	connContext driver.ConnPrepareContext,
	queryer driver.Queryer,
	queryerContext driver.QueryerContext) {
	execer.Exec(driver1, nil)                      // $ query=driver1
	execerContext.ExecContext(ctx, driver2, nil)   // $ query=driver2
	conn.Prepare(driver3)                          // $ querystring=driver3
	connContext.PrepareContext(ctx, driver4)       // $ querystring=driver4
	queryer.Query(driver5, nil)                    // $ query=driver5
	queryerContext.QueryContext(ctx, driver6, nil) // $ query=driver6
}
