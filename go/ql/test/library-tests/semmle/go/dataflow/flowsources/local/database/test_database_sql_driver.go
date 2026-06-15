package test

import "database/sql/driver"

func testQueryer(q driver.Queryer) {
	rows, err := q.Query("SELECT * FROM users", make([]driver.Value, 0)) // $ source
	ignore(rows, err)
}

func testQueryerContext(q driver.QueryerContext) {
	rows, err := q.QueryContext(nil, "SELECT * FROM users", make([]driver.NamedValue, 0)) // $ source
	ignore(rows, err)
}

func testStmt(stmt driver.Stmt) {
	rows, err := stmt.Query(make([]driver.Value, 0)) // $ source
	ignore(rows, err)
}

func testStmtContext(stmt driver.StmtQueryContext) {
	rows, err := stmt.QueryContext(nil, make([]driver.NamedValue, 0)) // $ source
	ignore(rows, err)
}
