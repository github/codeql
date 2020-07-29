package gormtest

import (
	"github.com/jinzhu/gorm"
)

func getUntrustedString() string {
	return "trouble"
}

func main() {

	db := gorm.DB{}
	untrusted := getUntrustedString()
	db.Where(untrusted)
	db.Not(untrusted)
	db.Order(untrusted)
	db.Or(untrusted)
	db.Select(untrusted)
	db.Table(untrusted)
	db.Group(untrusted)
	db.Having(untrusted)
	db.Joins(untrusted)

}
