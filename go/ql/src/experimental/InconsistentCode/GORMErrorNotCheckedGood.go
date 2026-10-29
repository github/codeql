package main

import "gorm.io/gorm"

func getUserIdGood(db *gorm.DB, name string) int64 {
	var user User
	if err := db.Where("name = ?", name).First(&user).Error; err != nil {
		// handle errors
	}
	return user.Id
}
