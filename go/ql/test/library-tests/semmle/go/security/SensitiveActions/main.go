package main

import (
	"os"
)

func use(_ string) {}

type passStruct struct {
	password string
}

func (p passStruct) getPassword() string {
	return p.password
}

func (p passStruct) get(key string) string {
	return ""
}

func get(key string) string {
	return ""
}

var (
	password, PassWord, myPasswordInCleartext                                      string
	hashed_password, password_hashed, password_hash, hash_password, hashedPassword string
	secret                                                                         string
)

func main() {
	use(password)
	use(PassWord)
	use(myPasswordInCleartext)

	var p passStruct
	use(p.password)
	p.getPassword()
	p.get("password")
	get("password")

	use(hashed_password)
	use(password_hashed)
	use(password_hash)
	use(hash_password)
	use(hashedPassword)

	os.Exit(0)

	use(secret)
}
