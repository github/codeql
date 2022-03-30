package main

import (
	"log"
	"os"
)

func myLog(x string) {
	log.Println(x) // NOT OK
}

func redact(kind, value string) string {
	if value != "" && kind == "password" {
		return "********"
	}
	return value
}

func test() {
	name := "user"
	password := "P@ssw0rd"
	x := "horsebatterystapleincorrect"
	var o passStruct

	log.Println(password)        // NOT OK
	log.Println(o.password)      // NOT OK
	log.Println(getPassword())   // NOT OK
	log.Println(o.getPassword()) // NOT OK

	myLog(password)

	log.Panic(password) // NOT OK

	log.Println(name + ", " + password) // NOT OK

	obj1 := passStruct{
		password: x,
	}
	log.Println(obj1) // NOT OK

	obj2 := xStruct{
		x: password,
	}
	log.Println(obj2) // NOT OK

	var obj3 xStruct
	log.Println(obj3) // caught because of the below line
	obj3.x = password // NOT OK

	fixed_password := "cowbatterystaplecorrect"
	log.Println(fixed_password) // Probably OK, but caught

	log.Println(IncorrectPasswordError) // OK

	var obj hashedStruct
	log.Println(obj.hashed_password) // OK
	var login encryptedStruct
	log.Println(login.encryptedPassword) // OK
	var HTML5QQ encodedStruct
	log.Println(HTML5QQ.encodedPassword) // OK

	pw := "arstneioarstneio"
	log.Println(passStruct{password: crypt(pw)}) // OK
	actually_secure_password := crypt(password)  // OK
	log.Println(actually_secure_password)        // OK

	var user1 cryptedStruct
	user1.cryptedPassword = x
	log.Println(user1) // OK

	var user2 passStruct
	user2.password = hash()
	log.Println(user2) // OK

	actually_ok_password_1 := hash()
	log.Println(actually_ok_password_1) // OK
	hashed2 := actually_ok_password_2()
	log.Println(hashed2) // OK

	passwordMD5 := "0d599f0ec05c3bda8c3b8a68c32a1b47"
	log.Println(passwordMD5) // OK
	password_sha := "5e03aad954f62810c0fdf16cb0dfba86bda486a53912fb7c894f96eaf8008aee"
	log.Println(password_sha) // OK

	utilityObject := passSetStruct{
		passwordSet: make(map[string]bool),
	}
	log.Println(utilityObject) // NOT OK

	secret := password
	log.Printf("pw: %s", secret) // NOT OK

	log.Println("Password is: " + redact("password", password))

	var t testable
	var y int

	if t.test(y) {
		f()
		// ...
		log.Println("Password is: " + password) // NOT OK
		// ...
	}

	if t.test(y) {
		if f() {
			log.Println("Password is: " + password) // NOT OK
		}
	}

	if os.Getenv("APP_ENV") != "production" {
		log.Println("Password is: " + password) // OK, but still flagged
	}

	var password1 stringable = stringable{"arstneio"}
	log.Println(name + ", " + password1.String()) // NOT OK

	config := Config{
		password: x,
		hostname: "tarski",
		x:        password,
		y:        getPassword(),
	}
	log.Println(config.hostname) // OK
	log.Println(config)          // NOT OK
	log.Println(config.x)        // NOT OK
	log.Println(config.y)        // NOT OK

	obj4 := xStruct{
		x: "aaaaa",
	}
	log.Println(obj4) // OK
}

const password = "horsebatterystaplecorrect"

func test2() {
	log.Println(password) // OK
}
