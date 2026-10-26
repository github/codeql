package test

import (
	"net/http"

	"github.com/astaxie/beego/orm"
)

// BAD: using untrusted data in SQL queries
func testDbMethods(bdb *orm.DB, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent() // $ Source[go/sql-injection]

	bdb.Exec(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	bdb.ExecContext(nil, untrusted)     // $ querystring=untrusted Alert[go/sql-injection]
	bdb.Prepare(untrusted)              // $ querystring=untrusted Alert[go/sql-injection]
	bdb.PrepareContext(nil, untrusted)  // $ querystring=untrusted Alert[go/sql-injection]
	bdb.Query(untrusted)                // $ querystring=untrusted Alert[go/sql-injection]
	bdb.QueryContext(nil, untrusted)    // $ querystring=untrusted Alert[go/sql-injection]
	bdb.QueryRow(untrusted)             // $ querystring=untrusted Alert[go/sql-injection]
	bdb.QueryRowContext(nil, untrusted) // $ querystring=untrusted Alert[go/sql-injection]
}

// BAD: using untrusted data to build SQL queries (QueryBuilder does not sanitize its arguments)
func testQueryBuilderMethods(qb orm.QueryBuilder, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()  // $ Source[go/sql-injection]
	untrusted2 := untrustedSource.UserAgent() // $ Source[go/sql-injection]

	qb.Select(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	qb.From(untrusted)                   // $ querystring=untrusted Alert[go/sql-injection]
	qb.InnerJoin(untrusted)              // $ querystring=untrusted Alert[go/sql-injection]
	qb.LeftJoin(untrusted)               // $ querystring=untrusted Alert[go/sql-injection]
	qb.RightJoin(untrusted)              // $ querystring=untrusted Alert[go/sql-injection]
	qb.On(untrusted)                     // $ querystring=untrusted Alert[go/sql-injection]
	qb.Where(untrusted)                  // $ querystring=untrusted Alert[go/sql-injection]
	qb.And(untrusted)                    // $ querystring=untrusted Alert[go/sql-injection]
	qb.Or(untrusted)                     // $ querystring=untrusted Alert[go/sql-injection]
	qb.In(untrusted)                     // $ querystring=untrusted Alert[go/sql-injection]
	qb.OrderBy(untrusted)                // $ querystring=untrusted Alert[go/sql-injection]
	qb.GroupBy(untrusted)                // $ querystring=untrusted Alert[go/sql-injection]
	qb.Having(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	qb.Update(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	qb.Set(untrusted)                    // $ querystring=untrusted Alert[go/sql-injection]
	qb.Delete(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	qb.InsertInto(untrusted, untrusted2) // $ querystring=untrusted querystring=untrusted2 Alert[go/sql-injection]
	qb.Values(untrusted)                 // $ querystring=untrusted Alert[go/sql-injection]
	qb.Subquery(untrusted, untrusted2)   // $ querystring=untrusted querystring=untrusted2 Alert[go/sql-injection]
}

func testOrmerRaw(ormer orm.Ormer, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent() // $ Source[go/sql-injection]
	untrusted2 := untrustedSource.UserAgent()
	ormer.Raw(untrusted, untrusted2)                    // $ querystring=untrusted Alert[go/sql-injection] // BAD: using an untrusted string as a query
	ormer.Raw("FROM ? SELECT ?", untrusted, untrusted2) // $ querystring="FROM ? SELECT ?" // GOOD: untrusted string used in argument context
}

func testFilterRaw(querySeter orm.QuerySeter, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent() // $ Source[go/sql-injection]
	querySeter.FilterRaw(untrusted, "safe")  // $ querystring="safe"    // GOOD: untrusted used as a column name
	querySeter.FilterRaw("safe", untrusted)  // $ querystring=untrusted Alert[go/sql-injection] // BAD: untrusted used as a SQL fragment
}

func testConditionRaw(cond orm.Condition, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent() // $ Source[go/sql-injection]
	cond.Raw(untrusted, "safe")              // $ querystring="safe"    // GOOD: untrusted used as a column name
	cond.Raw("safe", untrusted)              // $ querystring=untrusted Alert[go/sql-injection] // BAD: untrusted used as a SQL fragment
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
	ormer.Read(&obj)                            // $ Source[go/stored-xss]
	sink.Write([]byte(obj.field))               // $ Alert[go/stored-xss]
	sink.Write([]byte(obj.substructs[0].field)) // $ Alert[go/stored-xss]

	obj2 := MyStruct{}
	ormer.ReadForUpdate(&obj2)     // $ Source[go/stored-xss]
	sink.Write([]byte(obj2.field)) // $ Alert[go/stored-xss]

	obj3 := MyStruct{}
	ormer.ReadOrCreate(&obj3, "arg") // $ Source[go/stored-xss]
	sink.Write([]byte(obj3.field))   // $ Alert[go/stored-xss]
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testFieldReads(textField *orm.TextField, jsonField *orm.JSONField, jsonbField *orm.JsonbField, sink http.ResponseWriter) {
	sink.Write([]byte(textField.Value()))              // $ Alert[go/stored-xss]
	sink.Write([]byte(textField.RawValue().(string)))  // $ Alert[go/stored-xss]
	sink.Write([]byte(textField.String()))             // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonField.Value()))              // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonField.RawValue().(string)))  // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonField.String()))             // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonbField.Value()))             // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonbField.RawValue().(string))) // $ Alert[go/stored-xss]
	sink.Write([]byte(jsonbField.String()))            // $ Alert[go/stored-xss]
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testQuerySeterReads(qs orm.QuerySeter, sink http.ResponseWriter) {
	var objs []*MyStruct
	qs.All(&objs)                     // $ Source[go/stored-xss]
	sink.Write([]byte(objs[0].field)) // $ Alert[go/stored-xss]

	var obj MyStruct
	qs.One(&obj)                  // $ Source[go/stored-xss]
	sink.Write([]byte(obj.field)) // $ Alert[go/stored-xss]

	var allMaps []orm.Params
	qs.Values(&allMaps)                              // $ Source[go/stored-xss]
	sink.Write([]byte(allMaps[0]["field"].(string))) // $ Alert[go/stored-xss]

	var allLists []orm.ParamsList
	qs.ValuesList(&allLists)                    // $ Source[go/stored-xss]
	sink.Write([]byte(allLists[0][0].(string))) // $ Alert[go/stored-xss]

	var oneList orm.ParamsList
	qs.ValuesFlat(&oneList, "colname")      // $ Source[go/stored-xss]
	sink.Write([]byte(oneList[0].(string))) // $ Alert[go/stored-xss]

	var oneRowMap orm.Params
	qs.RowsToMap(&oneRowMap, "key", "value")        // $ Source[go/stored-xss]
	sink.Write([]byte(oneRowMap["field"].(string))) // $ Alert[go/stored-xss]

	var oneRowStruct MyStruct
	qs.RowsToStruct(&oneRowStruct, "key", "value") // $ Source[go/stored-xss]
	sink.Write([]byte(oneRowStruct.field))         // $ Alert[go/stored-xss]
}

// BAD: (possible stored XSS) retrieving data from a database then writing to an HTTP response
func testRawSeterReads(rs orm.RawSeter, sink http.ResponseWriter) {
	var allMaps []orm.Params
	rs.Values(&allMaps)                              // $ Source[go/stored-xss]
	sink.Write([]byte(allMaps[0]["field"].(string))) // $ Alert[go/stored-xss]

	var allLists []orm.ParamsList
	rs.ValuesList(&allLists)                    // $ Source[go/stored-xss]
	sink.Write([]byte(allLists[0][0].(string))) // $ Alert[go/stored-xss]

	var oneList orm.ParamsList
	rs.ValuesFlat(&oneList, "colname")      // $ Source[go/stored-xss]
	sink.Write([]byte(oneList[0].(string))) // $ Alert[go/stored-xss]

	var oneRowMap orm.Params
	rs.RowsToMap(&oneRowMap, "key", "value")        // $ Source[go/stored-xss]
	sink.Write([]byte(oneRowMap["field"].(string))) // $ Alert[go/stored-xss]

	var oneRowStruct MyStruct
	rs.RowsToStruct(&oneRowStruct, "key", "value") // $ Source[go/stored-xss]
	sink.Write([]byte(oneRowStruct.field))         // $ Alert[go/stored-xss]

	var strField string
	rs.QueryRow(&strField)       // $ Source[go/stored-xss]
	sink.Write([]byte(strField)) // $ Alert[go/stored-xss]

	var strFields []string
	rs.QueryRows(&strFields)         // $ Source[go/stored-xss]
	sink.Write([]byte(strFields[0])) // $ Alert[go/stored-xss]
}
