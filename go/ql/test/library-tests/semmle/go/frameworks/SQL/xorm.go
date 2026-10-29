package main

//go:generate depstubber -vendor xorm.io/xorm Engine,Session
//go:generate depstubber -vendor github.com/go-xorm/xorm Engine,Session

import (
	xorm1 "github.com/go-xorm/xorm"
	xorm2 "xorm.io/xorm"
)

func xormtest() {
	query := "UntrustedString"
	arg := "arg"

	engine1 := xorm1.Engine{}
	engine1.Query(query, arg)          // $ querystring=query
	engine1.Exec(query, arg)           // $ querystring=query
	engine1.QueryString(query, arg)    // $ querystring=query
	engine1.QueryInterface(query, arg) // $ querystring=query
	engine1.SQL(query)                 // $ querystring=query
	engine1.Where(query)               // $ querystring=query
	engine1.Alias(query)               // $ querystring=query
	engine1.NotIn(query)               // $ querystring=query
	engine1.In(query)                  // $ querystring=query
	engine1.Select(query)              // $ querystring=query
	engine1.SetExpr(query, nil)        // $ querystring=query
	engine1.OrderBy(query)             // $ querystring=query
	engine1.Having(query)              // $ querystring=query
	engine1.GroupBy(query)             // $ querystring=query

	engine2 := xorm2.Engine{}
	engine2.Query(query, arg)          // $ querystring=query
	engine2.Exec(query, arg)           // $ querystring=query
	engine2.QueryString(query, arg)    // $ querystring=query
	engine2.QueryInterface(query, arg) // $ querystring=query
	engine2.SQL(query)                 // $ querystring=query
	engine2.Where(query)               // $ querystring=query
	engine2.Alias(query)               // $ querystring=query
	engine2.NotIn(query)               // $ querystring=query
	engine2.In(query)                  // $ querystring=query
	engine2.Select(query)              // $ querystring=query
	engine2.SetExpr(query, nil)        // $ querystring=query
	engine2.OrderBy(query)             // $ querystring=query
	engine2.Having(query)              // $ querystring=query
	engine2.GroupBy(query)             // $ querystring=query

	session1 := xorm1.Session{}
	session1.Query(query, arg)          // $ querystring=query
	session1.Exec(query, arg)           // $ querystring=query
	session1.QueryString(query, arg)    // $ querystring=query
	session1.QueryInterface(query, arg) // $ querystring=query
	session1.SQL(query)                 // $ querystring=query
	session1.Where(query)               // $ querystring=query
	session1.Alias(query)               // $ querystring=query
	session1.NotIn(query)               // $ querystring=query
	session1.In(query)                  // $ querystring=query
	session1.Select(query)              // $ querystring=query
	session1.SetExpr(query, nil)        // $ querystring=query
	session1.OrderBy(query)             // $ querystring=query
	session1.Having(query)              // $ querystring=query
	session1.GroupBy(query)             // $ querystring=query
	session1.And(query)                 // $ querystring=query
	session1.Or(query)                  // $ querystring=query

	session2 := xorm2.Session{}
	session2.Query(query, arg)          // $ querystring=query
	session2.Exec(query, arg)           // $ querystring=query
	session2.QueryString(query, arg)    // $ querystring=query
	session2.QueryInterface(query, arg) // $ querystring=query
	session2.SQL(query)                 // $ querystring=query
	session2.Where(query)               // $ querystring=query
	session2.Alias(query)               // $ querystring=query
	session2.NotIn(query)               // $ querystring=query
	session2.In(query)                  // $ querystring=query
	session2.Select(query)              // $ querystring=query
	session2.SetExpr(query, nil)        // $ querystring=query
	session2.OrderBy(query)             // $ querystring=query
	session2.Having(query)              // $ querystring=query
	session2.GroupBy(query)             // $ querystring=query
	session2.And(query)                 // $ querystring=query
	session2.Or(query)                  // $ querystring=query
}
