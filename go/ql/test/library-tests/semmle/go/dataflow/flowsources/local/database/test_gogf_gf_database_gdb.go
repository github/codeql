package test

//go:generate depstubber -vendor github.com/gogf/gf/database/gdb Core,DB,Model,TX,Record,Result

import (
	"github.com/gogf/gf/database/gdb"
)

func gogf_Core(g gdb.Core) {
	v1, _ := g.DoGetAll(nil, nil, "SELECT user from users") // $ source
	sink(v1)                                                // $ hasTaintFlow="v1"

	v2, _ := g.DoQuery(nil, nil, "SELECT user from users") // $ source
	sink(v2)                                               // $ hasTaintFlow="v2"

	v3, _ := g.GetAll("SELECT user from users") // $ source
	sink(v3)                                    // $ hasTaintFlow="v3"

	v4, _ := g.GetArray("SELECT user from users") // $ source
	sink(v4)                                      // $ hasTaintFlow="v4"

	v5, _ := g.GetOne("SELECT user from users") // $ source
	sink(v5)                                    // $ hasTaintFlow="v5"

	var v6 User
	g.GetScan(&v6, "SELECT user from users") // $ source
	sink(v6)                                 // $ hasTaintFlow="v6"

	var v7 User
	g.GetStruct(&v7, "SELECT user from users") // $ source
	sink(v7)                                   // $ hasTaintFlow="v7"

	var v8 []User // $ source
	g.GetStructs(v8, "SELECT user from users")
	sink(v8) // $ hasTaintFlow="v8"

	v9, _ := g.GetValue("SELECT user from users") // $ source
	sink(v9)                                      // $ hasTaintFlow="v9"

	v10, _ := g.Query("SELECT user from users") // $ source
	sink(v10)                                   // $ hasTaintFlow="v10"
}

func gogf_DB(g gdb.DB) {
	v1, _ := g.DoGetAll(nil, nil, "SELECT user from users") // $ source
	sink(v1)                                                // $ hasTaintFlow="v1"

	v2, _ := g.DoQuery(nil, nil, "SELECT user from users") // $ source
	sink(v2)                                               // $ hasTaintFlow="v2"

	v3, _ := g.GetAll("SELECT user from users") // $ source
	sink(v3)                                    // $ hasTaintFlow="v3"

	v4, _ := g.GetArray("SELECT user from users") // $ source
	sink(v4)                                      // $ hasTaintFlow="v4"

	v5, _ := g.GetOne("SELECT user from users") // $ source
	sink(v5)                                    // $ hasTaintFlow="v5"

	var v6 User
	g.GetScan(&v6, "SELECT user from users") // $ source
	sink(v6)                                 // $ hasTaintFlow="v6"

	v7, _ := g.GetValue("SELECT user from users") // $ source
	sink(v7)                                      // $ hasTaintFlow="v7"

	v8, _ := g.Query("SELECT user from users") // $ source
	sink(v8)                                   // $ hasTaintFlow="v8"
}

func gogf_Model(g gdb.Model) {
	v1, _ := g.All() // $ source
	sink(v1)         // $ hasTaintFlow="v1"

	v2, _ := g.Array() // $ source
	sink(v2)           // $ hasTaintFlow="v2"

	v3, _ := g.FindAll() // $ source
	sink(v3)             // $ hasTaintFlow="v3"

	v4, _ := g.FindArray() // $ source
	sink(v4)               // $ hasTaintFlow="v4"

	v5, _ := g.FindOne() // $ source
	sink(v5)             // $ hasTaintFlow="v5"

	var v6 User
	g.FindScan(&v6) // $ source
	sink(v6)        // $ hasTaintFlow="v6"

	v7, _ := g.FindValue() // $ source
	sink(v7)               // $ hasTaintFlow="v7"

	v8, _ := g.One() // $ source
	sink(v8)         // $ hasTaintFlow="v8"

	var v9 User
	g.Scan(&v9) // $ source
	sink(v9)    // $ hasTaintFlow="v9"

	var v10 []User
	g.ScanList(&v10, "") // $ source
	sink(v10)            // $ hasTaintFlow="v10"

	v11, _ := g.Select() // $ source
	sink(v11)            // $ hasTaintFlow="v11"

	var v12 User
	g.Struct(&v12) // $ source
	sink(v12)      // $ hasTaintFlow="v12"

	var v13 []User
	g.Structs(&v13, "") // $ source
	sink(v13)           // $ hasTaintFlow="v13"

	v14, _ := g.Value() // $ source
	sink(v14)           // $ hasTaintFlow="v14"
}

func gogf_TX(g gdb.TX) {
	v1, _ := g.GetAll("SELECT user from users") // $ source
	sink(v1)                                    // $ hasTaintFlow="v1"

	v2, _ := g.GetOne("SELECT user from users") // $ source
	sink(v2)                                    // $ hasTaintFlow="v2"

	var v3 User
	g.GetScan(&v3, "SELECT user from users") // $ source
	sink(v3)                                 // $ hasTaintFlow="v3"

	var v4 User
	g.GetStruct(&v4, "SELECT user from users") // $ source
	sink(v4)                                   // $ hasTaintFlow="v4"

	var v5 []User // $ source
	g.GetStructs(v5, "SELECT user from users")
	sink(v5) // $ hasTaintFlow="v5"

	v6, _ := g.GetValue("SELECT user from users") // $ source
	sink(v6)                                      // $ hasTaintFlow="v6"

	v7, _ := g.Query("SELECT user from users") // $ source
	sink(v7)                                   // $ hasTaintFlow="v7"
}

func gogf_Record_summary(g gdb.Core) {
	record1, _ := g.GetOne("SELECT summary from records") // $ source
	gmap := record1.GMap()
	sink(gmap) // $ hasTaintFlow="gmap"

	record2, _ := g.GetOne("SELECT summary from records") // $ source
	interface_ := record2.Interface()
	sink(interface_) // $ hasTaintFlow="interface_"

	record3, _ := g.GetOne("SELECT summary from records") // $ source
	json := record3.Json()
	sink(json) // $ hasTaintFlow="json"

	record4, _ := g.GetOne("SELECT summary from records") // $ source
	map_ := record4.Map()
	sink(map_) // $ hasTaintFlow="map_"

	record5, _ := g.GetOne("SELECT summary from records") // $ source
	var struct_ struct{}
	record5.Struct(&struct_)
	sink(struct_) // $ hasTaintFlow="struct_"

	record6, _ := g.GetOne("SELECT summary from records") // $ source
	xml := record6.Xml()
	sink(xml) // $ hasTaintFlow="xml"

	// Note: currently missing models for methods on return type of `GMap`,
	// which is `StrAnyMap` from package "github.com/gogf/gf/container/gmap".
}

func gogf_Result_summary(g gdb.Core) {
	result1, _ := g.GetAll("SELECT summary from records") // $ source
	array := result1.Array()
	sink(array) // $ hasTaintFlow="array"

	result2, _ := g.GetAll("SELECT summary from records") // $ source
	chunk := result2.Chunk(1)
	sink(chunk) // $ hasTaintFlow="chunk"

	result3, _ := g.GetAll("SELECT summary from records") // $ source
	interface_ := result3.Interface()
	sink(interface_) // $ hasTaintFlow="interface_"

	result4, _ := g.GetAll("SELECT summary from records") // $ source
	json := result4.Json()
	sink(json) // $ hasTaintFlow="json"

	result5, _ := g.GetAll("SELECT summary from records") // $ source
	list := result5.List()
	sink(list) // $ hasTaintFlow="list"

	result6, _ := g.GetAll("SELECT summary from records") // $ source
	mapkeyint := result6.MapKeyInt("")
	sink(mapkeyint) // $ hasTaintFlow="mapkeyint"

	result7, _ := g.GetAll("SELECT summary from records") // $ source
	mapkeystr := result7.MapKeyStr("")
	sink(mapkeystr) // $ hasTaintFlow="mapkeystr"

	result8, _ := g.GetAll("SELECT summary from records") // $ source
	mapkeyuint := result8.MapKeyUint("")
	sink(mapkeyuint) // $ hasTaintFlow="mapkeyuint"

	result9, _ := g.GetAll("SELECT summary from records") // $ source
	mapkeyvalue := result9.MapKeyValue("")
	sink(mapkeyvalue) // $ hasTaintFlow="mapkeyvalue"

	result10, _ := g.GetAll("SELECT summary from records") // $ source
	recordkeyint := result10.RecordKeyInt("")
	sink(recordkeyint) // $ hasTaintFlow="recordkeyint"

	result11, _ := g.GetAll("SELECT summary from records") // $ source
	recordkeystr := result11.RecordKeyStr("")
	sink(recordkeystr) // $ hasTaintFlow="recordkeystr"

	result12, _ := g.GetAll("SELECT summary from records") // $ source
	recordkeyuint := result12.RecordKeyUint("")
	sink(recordkeyuint) // $ hasTaintFlow="recordkeyuint"

	result13, _ := g.GetAll("SELECT summary from records") // $ source
	var structslice1 []struct{}
	result13.ScanList(&structslice1, "")
	sink(structslice1) // $ hasTaintFlow="structslice1"

	result14, _ := g.GetAll("SELECT summary from records") // $ source
	var structslice2 []struct{}
	result14.Structs(&structslice2)
	sink(structslice2) // $ hasTaintFlow="structslice2"

	result15, _ := g.GetAll("SELECT summary from records") // $ source
	xml := result15.Xml()
	sink(xml) // $ hasTaintFlow="xml"

	// Note: currently missing models for methods on the type `Var` from
	// package "github.com/gogf/gf/container/gvar", which is involved in the
	// return type of `Array` and `MapKeyValue`.
}
