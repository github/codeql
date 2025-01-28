package test

import (
	oldOrm "github.com/astaxie/beego/orm"
	"github.com/beego/beego/v2/client/orm"
)

func test_beego_DB(db orm.DB) {
	rows, err := db.Query("SELECT * FROM users") // $ source
	ignore(rows, err)

	rows, err = db.QueryContext(nil, "SELECT * FROM users") // $ source
	ignore(rows, err)

	row := db.QueryRow("SELECT * FROM users") // $ source
	ignore(row)

	row = db.QueryRowContext(nil, "SELECT * FROM users") // $ source
	ignore(row)
}

func test_beego_Ormer() {
	o := oldOrm.NewOrm()
	o.Read(&User{})                 // $ source
	o.ReadForUpdate(&User{})        // $ source
	o.ReadOrCreate(&User{}, "name") // $ source
}

func test_beego_DQL() {
	o := orm.NewOrm()
	o.Read(&User{})                             // $ source
	o.ReadWithCtx(nil, &User{})                 // $ source
	o.ReadForUpdate(&User{})                    // $ source
	o.ReadForUpdateWithCtx(nil, &User{})        // $ source
	o.ReadOrCreate(&User{}, "name")             // $ source
	o.ReadOrCreateWithCtx(nil, &User{}, "name") // $ source
}
