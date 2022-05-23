package main

import "gorm.io/gorm"

func getUserId(db *gorm.DB, name string) int64 {
	var user User
	db.Where("name = ?", name).First(&user)
	return user.Id
}
