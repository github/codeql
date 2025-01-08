package test

import (
	"context"
	"database/sql"
	"fmt"

	beegoOrm "github.com/beego/beego/orm"
	gocb "github.com/couchbase/gocb/v2"
	"github.com/gogf/gf/database/gdb"
	"github.com/jmoiron/sqlx"
	"github.com/rqlite/gorqlite"
	"go.mongodb.org/mongo-driver/mongo"
	"gorm.io/gorm"
)

func stdlib() {
	pool, err := sql.Open("mysql", "user:password@localhost:5555/dbname")
	if err != nil {
		return
	}

	row := pool.QueryRow("SELECT * FROM users WHERE id = ?", 1) // $source
	fmt.Println(row)
}

func gormDB(db *gorm.DB) {
	type User struct {
		gorm.Model
	}

	var u1 User
	var u2 User

	db.Find(&u1, 1)          // $source
	db.FirstOrCreate(&u2, 1) // $source
}

func mongoDB(ctx context.Context, userCollection mongo.Collection) {
	type User struct {
	}

	var u1 User

	result := userCollection.FindOne(ctx, nil) // $source
	result.Decode(&u1)

	fmt.Println(u1)
}

func gogf(g gdb.DB) {
	u1, err := g.GetOne("SELECT user from users") // $source

	if err != nil {
		return
	}

	fmt.Println(u1)
}

func Sqlx() {
	db, err := sqlx.Connect("mysql", "user:password@localhost:5555/dbname")

	if err != nil {
		return
	}

	u1 := db.QueryRow("SELECT * FROM users WHERE id = ?", 1) // $source

	fmt.Println(u1)

	type User struct{}

	rows, err := db.Queryx("SELECT * FROM users") // $source
	for rows.Next() {
		var user User
		rows.StructScan(&user)
	}
}

func beego() {
	orm := beegoOrm.NewOrm()

	type User struct {
		Id   int
		Name string
	}

	var user User
	orm.Read(&user) // $source
}

func couchbase(coll *gocb.Collection) {
	type User struct {
		Name string
	}

	var user User

	result, err := coll.Get("documentID", nil) // $source

	if err != nil {
		return
	}

	result.Content(&user)

	fmt.Println(user)
}

func GoRqlite(conn *gorqlite.Connection) {
	var id int64
	var name string

	rows, err := conn.QueryOne("select id, name from foo where id = 1") // $source
	if err != nil {
		return
	}
	rows.Scan(&id, &name)
}
