package xormtest

//go:generate depstubber -vendor xorm.io/xorm Engine,Session
//go:generate depstubber -vendor github.com/go-xorm/xorm Engine,Session

import (
	xorm1 "github.com/go-xorm/xorm"
	xorm2 "xorm.io/xorm"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {
	untrusted := getUntrustedString()

	engine1 := xorm1.Engine{}
	engine1.Query(untrusted)
	engine1.QueryString(untrusted)
	engine1.QueryInterface(untrusted)
	engine1.SQL(untrusted)
	engine1.Where(untrusted)
	engine1.Alias(untrusted)
	engine1.NotIn(untrusted)
	engine1.In(untrusted)
	engine1.Select(untrusted)
	engine1.SetExpr(untrusted, nil)
	engine1.OrderBy(untrusted)
	engine1.Having(untrusted)
	engine1.GroupBy(untrusted)

	engine2 := xorm2.Engine{}
	engine2.Query(untrusted)
	engine2.QueryString(untrusted)
	engine2.QueryInterface(untrusted)
	engine2.SQL(untrusted)
	engine2.Where(untrusted)
	engine2.Alias(untrusted)
	engine2.NotIn(untrusted)
	engine2.In(untrusted)
	engine2.Select(untrusted)
	engine2.SetExpr(untrusted, nil)
	engine2.OrderBy(untrusted)
	engine2.Having(untrusted)
	engine2.GroupBy(untrusted)

	session1 := xorm1.Session{}
	session1.Query(untrusted)
	session1.QueryString(untrusted)
	session1.QueryInterface(untrusted)
	session1.SQL(untrusted)
	session1.Where(untrusted)
	session1.Alias(untrusted)
	session1.NotIn(untrusted)
	session1.In(untrusted)
	session1.Select(untrusted)
	session1.SetExpr(untrusted, nil)
	session1.OrderBy(untrusted)
	session1.Having(untrusted)
	session1.GroupBy(untrusted)
	session1.And(untrusted)
	session1.Or(untrusted)

	session2 := xorm2.Session{}
	session2.Query(untrusted)
	session2.QueryString(untrusted)
	session2.QueryInterface(untrusted)
	session2.SQL(untrusted)
	session2.Where(untrusted)
	session2.Alias(untrusted)
	session2.NotIn(untrusted)
	session2.In(untrusted)
	session2.Select(untrusted)
	session2.SetExpr(untrusted, nil)
	session2.OrderBy(untrusted)
	session2.Having(untrusted)
	session2.GroupBy(untrusted)
	session2.And(untrusted)
	session2.Or(untrusted)
}
