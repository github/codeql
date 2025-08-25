package test

import (
	"net/http"

	"github.com/astaxie/beego/orm"
)

// BAD: using untrusted data in SQL queries
func testDbMethods(bdb *orm.DB, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()

	bdb.Exec(untrusted)                 // $ querystring=untrusted
	bdb.ExecContext(nil, untrusted)     // $ querystring=untrusted
	bdb.Prepare(untrusted)              // $ querystring=untrusted
	bdb.PrepareContext(nil, untrusted)  // $ querystring=untrusted
	bdb.Query(untrusted)                // $ querystring=untrusted
	bdb.QueryContext(nil, untrusted)    // $ querystring=untrusted
	bdb.QueryRow(untrusted)             // $ querystring=untrusted
	bdb.QueryRowContext(nil, untrusted) // $ querystring=untrusted
}

// BAD: using untrusted data to build SQL queries (QueryBuilder does not sanitize its arguments)
func testQueryBuilderMethods(qb orm.QueryBuilder, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	untrusted2 := untrustedSource.UserAgent()

	qb.Select(untrusted)                 // $ querystring=untrusted
	qb.From(untrusted)                   // $ querystring=untrusted
	qb.InnerJoin(untrusted)              // $ querystring=untrusted
	qb.LeftJoin(untrusted)               // $ querystring=untrusted
	qb.RightJoin(untrusted)              // $ querystring=untrusted
	qb.On(untrusted)                     // $ querystring=untrusted
	qb.Where(untrusted)                  // $ querystring=untrusted
	qb.And(untrusted)                    // $ querystring=untrusted
	qb.Or(untrusted)                     // $ querystring=untrusted
	qb.In(untrusted)                     // $ querystring=untrusted
	qb.OrderBy(untrusted)                // $ querystring=untrusted
	qb.GroupBy(untrusted)                // $ querystring=untrusted
	qb.Having(untrusted)                 // $ querystring=untrusted
	qb.Update(untrusted)                 // $ querystring=untrusted
	qb.Set(untrusted)                    // $ querystring=untrusted
	qb.Delete(untrusted)                 // $ querystring=untrusted
	qb.InsertInto(untrusted, untrusted2) // $ querystring=untrusted querystring=untrusted2
	qb.Values(untrusted)                 // $ querystring=untrusted
	qb.Subquery(untrusted, untrusted2)   // $ querystring=untrusted querystring=untrusted2
}

func testOrmerRaw(ormer orm.Ormer, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	untrusted2 := untrustedSource.UserAgent()
	ormer.Raw(untrusted, untrusted2)                    // $ querystring=untrusted         // BAD: using an untrusted string as a query
	ormer.Raw("FROM ? SELECT ?", untrusted, untrusted2) // $ querystring="FROM ? SELECT ?" // GOOD: untrusted string used in argument context
}

func testFilterRaw(querySeter orm.QuerySeter, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	querySeter.FilterRaw(untrusted, "safe") // $ querystring="safe"    // GOOD: untrusted used as a column name
	querySeter.FilterRaw("safe", untrusted) // $ querystring=untrusted // BAD: untrusted used as a SQL fragment
}

func testConditionRaw(cond orm.Condition, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	cond.Raw(untrusted, "safe") // $ querystring="safe"    // GOOD: untrusted used as a column name
	cond.Raw("safe", untrusted) // $ querystring=untrusted // BAD: untrusted used as a SQL fragment
}

type SubStruct struct {
	field string
}

type MyStruct struct {
	field      string
	substructs []SubStruct
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testOrmerReads(ormer orm.Ormer, sink http.ResponseWriter) {
	obj := MyStruct{}
	ormer.Read(&obj)
	sink.Write([]byte(obj.field))
	sink.Write([]byte(obj.substructs[0].field))

	obj2 := MyStruct{}
	ormer.ReadForUpdate(&obj2)
	sink.Write([]byte(obj2.field))

	obj3 := MyStruct{}
	ormer.ReadOrCreate(&obj3, "arg")
	sink.Write([]byte(obj3.field))
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testFieldReads(textField *orm.TextField, jsonField *orm.JSONField, jsonbField *orm.JsonbField, sink http.ResponseWriter) {
	sink.Write([]byte(textField.Value()))
	sink.Write([]byte(textField.RawValue().(string)))
	sink.Write([]byte(textField.String()))
	sink.Write([]byte(jsonField.Value()))
	sink.Write([]byte(jsonField.RawValue().(string)))
	sink.Write([]byte(jsonField.String()))
	sink.Write([]byte(jsonbField.Value()))
	sink.Write([]byte(jsonbField.RawValue().(string)))
	sink.Write([]byte(jsonbField.String()))
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testQuerySeterReads(qs orm.QuerySeter, sink http.ResponseWriter) {
	var objs []*MyStruct
	qs.All(&objs)
	sink.Write([]byte(objs[0].field))

	var obj MyStruct
	qs.One(&obj)
	sink.Write([]byte(obj.field))

	var allMaps []orm.Params
	qs.Values(&allMaps)
	sink.Write([]byte(allMaps[0]["field"].(string)))

	var allLists []orm.ParamsList
	qs.ValuesList(&allLists)
	sink.Write([]byte(allLists[0][0].(string)))

	var oneList orm.ParamsList
	qs.ValuesFlat(&oneList, "colname")
	sink.Write([]byte(oneList[0].(string)))

	var oneRowMap orm.Params
	qs.RowsToMap(&oneRowMap, "key", "value")
	sink.Write([]byte(oneRowMap["field"].(string)))

	var oneRowStruct MyStruct
	qs.RowsToStruct(&oneRowStruct, "key", "value")
	sink.Write([]byte(oneRowStruct.field))
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testRawSeterReads(rs orm.RawSeter, sink http.ResponseWriter) {
	var allMaps []orm.Params
	rs.Values(&allMaps)
	sink.Write([]byte(allMaps[0]["field"].(string)))

	var allLists []orm.ParamsList
	rs.ValuesList(&allLists)
	sink.Write([]byte(allLists[0][0].(string)))

	var oneList orm.ParamsList
	rs.ValuesFlat(&oneList, "colname")
	sink.Write([]byte(oneList[0].(string)))

	var oneRowMap orm.Params
	rs.RowsToMap(&oneRowMap, "key", "value")
	sink.Write([]byte(oneRowMap["field"].(string)))

	var oneRowStruct MyStruct
	rs.RowsToStruct(&oneRowStruct, "key", "value")
	sink.Write([]byte(oneRowStruct.field))

	var strField string
	rs.QueryRow(&strField)
	sink.Write([]byte(strField))

	var strFields []string
	rs.QueryRows(&strFields)
	sink.Write([]byte(strFields[0]))
}
