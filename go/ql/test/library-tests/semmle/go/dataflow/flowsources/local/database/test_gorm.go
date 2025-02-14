package test

import "gorm.io/gorm"

// test querying an Association
func test_gorm_AssociationQuery(association *gorm.Association) {
	association.Find(&User{}) // $ source
}

// test querying a ConnPool
func test_gorm_ConnPoolQuery(connPool gorm.ConnPool) {
	rows, err := connPool.QueryContext(nil, "SELECT * FROM users") // $ source

	if err != nil {
		return
	}

	defer rows.Close()

	userRow := connPool.QueryRowContext(nil, "SELECT * FROM users WHERE id = 1") // $ source

	ignore(userRow)
}

// test querying a DB
func test_gorm_db(db *gorm.DB) {
	db.Find(&User{}) // $ source

	db.FindInBatches(&User{}, 10, nil) // $ source

	db.FirstOrCreate(&User{}) // $ source

	db.FirstOrInit(&User{}) // $ source

	db.First(&User{}) // $ source

	db.Last(&User{}) // $ source

	db.Take(&User{}) // $ source

	db.Scan(&User{}) // $ source

	var user User
	db.Model(&user) // $ source

	row := db.Row() // $ source
	ignore(row)

	rows, err := db.Rows() // $ source
	ignore(err)

	var user2 User
	db.ScanRows(rows, &user2)

	sink(user2) // $ hasTaintFlow="user2"

	var names []string
	db.Pluck("name", &names) // $ source
}
