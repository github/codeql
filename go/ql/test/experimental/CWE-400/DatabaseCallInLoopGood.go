package main

import "gorm.io/gorm"

func getUsersGood(db *gorm.DB, names []string) []User {
	res := make([]User, 0, len(names))
	db.Where("name IN ?", names).Find(&res)
	return res
}
