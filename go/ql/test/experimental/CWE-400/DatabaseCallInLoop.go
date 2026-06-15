package main

import "gorm.io/gorm"

func getUsers(db *gorm.DB, names []string) []User {
	res := make([]User, 0, len(names))
	for _, name := range names {
		var user User
		db.Where("name = ?", name).First(&user) // $ Alert
		res = append(res, user)
	} // $ Source
	return res
}
