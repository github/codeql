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
	db1.Where(untrusted)
	db1.Raw(untrusted)
	db1.Not(untrusted)
	db1.Order(untrusted)
	db1.Or(untrusted)
	db1.Select(untrusted)
	db1.Table(untrusted)
	db1.Group(untrusted)
	db1.Having(untrusted)
	db1.Joins(untrusted)
	db1.Exec(untrusted)
	db1.Pluck(untrusted, nil)

	db2 := gorm2.DB{}
	db2.Where(untrusted)
	db2.Raw(untrusted)
	db2.Not(untrusted)
	db2.Order(untrusted)
	db2.Or(untrusted)
	db2.Select(untrusted)
	db2.Table(untrusted)
	db2.Group(untrusted)
	db2.Having(untrusted)
	db2.Joins(untrusted)
	db2.Exec(untrusted)
	db2.Distinct(untrusted)
	db2.Pluck(untrusted, nil)

}
