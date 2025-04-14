package gormtest

//go:generate depstubber -vendor github.com/jinzhu/gorm DB
//go:generate depstubber -vendor gorm.io/gorm DB

import (
	gorm1 "github.com/jinzhu/gorm"
	gorm2 "gorm.io/gorm"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {
	untrusted := getUntrustedString()

	db1 := gorm1.DB{}
	db1.Where(untrusted)      // $ querystring=untrusted
	db1.Raw(untrusted)        // $ querystring=untrusted
	db1.Not(untrusted)        // $ querystring=untrusted
	db1.Order(untrusted)      // $ querystring=untrusted
	db1.Or(untrusted)         // $ querystring=untrusted
	db1.Select(untrusted)     // $ querystring=untrusted
	db1.Table(untrusted)      // $ querystring=untrusted
	db1.Group(untrusted)      // $ querystring=untrusted
	db1.Having(untrusted)     // $ querystring=untrusted
	db1.Joins(untrusted)      // $ querystring=untrusted
	db1.Exec(untrusted)       // $ querystring=untrusted
	db1.Pluck(untrusted, nil) // $ querystring=untrusted

	db2 := gorm2.DB{}
	db2.Where(untrusted)      // $ querystring=untrusted
	db2.Raw(untrusted)        // $ querystring=untrusted
	db2.Not(untrusted)        // $ querystring=untrusted
	db2.Order(untrusted)      // $ querystring=untrusted
	db2.Or(untrusted)         // $ querystring=untrusted
	db2.Select(untrusted)     // $ querystring=untrusted
	db2.Table(untrusted)      // $ querystring=untrusted
	db2.Group(untrusted)      // $ querystring=untrusted
	db2.Having(untrusted)     // $ querystring=untrusted
	db2.Joins(untrusted)      // $ querystring=untrusted
	db2.Exec(untrusted)       // $ querystring=untrusted
	db2.Distinct(untrusted)   // $ querystring=untrusted
	db2.Pluck(untrusted, nil) // $ querystring=untrusted

}
