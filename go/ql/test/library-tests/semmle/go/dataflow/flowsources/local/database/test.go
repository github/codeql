package test

import (
	"context"
	"fmt"

	beegoOrm "github.com/beego/beego/orm"
	gocb "github.com/couchbase/gocb/v2"
	"github.com/gogf/gf/database/gdb"
	"github.com/rqlite/gorqlite"
	"go.mongodb.org/mongo-driver/mongo"
)

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
