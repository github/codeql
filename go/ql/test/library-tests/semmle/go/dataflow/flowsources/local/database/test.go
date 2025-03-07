package test

import (
	"fmt"

	gocb "github.com/couchbase/gocb/v2"
	"github.com/gogf/gf/database/gdb"
)

func gogf(g gdb.DB) {
	u1, err := g.GetOne("SELECT user from users") // $source

	if err != nil {
		return
	}

	fmt.Println(u1)
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
