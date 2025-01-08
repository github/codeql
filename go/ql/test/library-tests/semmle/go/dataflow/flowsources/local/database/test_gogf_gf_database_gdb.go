package test

import (
	"fmt"

	"github.com/gogf/gf/database/gdb"
)

func gogf(g gdb.DB) {
	u1, err := g.GetOne("SELECT user from users") // $source

	if err != nil {
		return
	}

	fmt.Println(u1)
}
