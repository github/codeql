package main

//go:generate depstubber -vendor github.com/rqlite/gorqlite Connection,ParameterizedStatement Open

import (
	"context"

	"github.com/rqlite/gorqlite"
)

func gorqlitetest(sql string, sqls []string, param_sql gorqlite.ParameterizedStatement, param_sqls []gorqlite.ParameterizedStatement, ctx context.Context) {
	conn, _ := gorqlite.Open("dbUrl")

	conn.Query(sqls) // $ querystring=sqls
	conn.Queue(sqls) // $ querystring=sqls
	conn.Write(sqls) // $ querystring=sqls

	conn.QueryOne(sql) // $ querystring=sql
	conn.QueueOne(sql) // $ querystring=sql
	conn.WriteOne(sql) // $ querystring=sql

	conn.QueryParameterized(param_sqls) // $ querystring=param_sqls
	conn.QueueParameterized(param_sqls) // $ querystring=param_sqls
	conn.WriteParameterized(param_sqls) // $ querystring=param_sqls

	conn.QueryOneParameterized(param_sql) // $ querystring=param_sql
	conn.QueueOneParameterized(param_sql) // $ querystring=param_sql
	conn.WriteOneParameterized(param_sql) // $ querystring=param_sql

	conn.QueryContext(ctx, sqls) // $ querystring=sqls
	conn.QueueContext(ctx, sqls) // $ querystring=sqls
	conn.WriteContext(ctx, sqls) // $ querystring=sqls

	conn.QueryOneContext(ctx, sql) // $ querystring=sql
	conn.QueueOneContext(ctx, sql) // $ querystring=sql
	conn.WriteOneContext(ctx, sql) // $ querystring=sql

	conn.QueryParameterizedContext(ctx, param_sqls) // $ querystring=param_sqls
	conn.QueueParameterizedContext(ctx, param_sqls) // $ querystring=param_sqls
	conn.WriteParameterizedContext(ctx, param_sqls) // $ querystring=param_sqls

	conn.QueryOneParameterizedContext(ctx, param_sql) // $ querystring=param_sql
	conn.QueueOneParameterizedContext(ctx, param_sql) // $ querystring=param_sql
	conn.WriteOneParameterizedContext(ctx, param_sql) // $ querystring=param_sql
}

func main() {
	return
}
