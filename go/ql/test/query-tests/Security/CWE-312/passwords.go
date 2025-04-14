package main

import (
	"log"
	"os"
)

func myLog(x string) {
	log.Println(x) // $ Alert
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

	log.Println(password)        // $ Alert
	log.Println(o.password)      // $ Alert
	log.Println(getPassword())   // $ Alert
	log.Println(o.getPassword()) // $ Alert

	myLog(password) // $ Source

	log.Panic(password) // $ Alert

	log.Println(name + ", " + password) // $ Alert

	obj1 := passStruct{
		password: x, // $ Source
	}
	log.Println(obj1) // $ Alert

	obj2 := xStruct{
		x: password, // $ Source
	}
	log.Println(obj2) // $ Alert

	var obj3 xStruct
	log.Println(obj3) // $ SPURIOUS: Alert // caught because of the below line and def-use flow
	obj3.x = password // $ Source

	fixed_password := "cowbatterystaplecorrect"
	log.Println(fixed_password) // $ Alert // Probably OK

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
		passwordSet: make(map[string]bool), // $ Source
	}
	log.Println(utilityObject) // $ Alert

	secret := password           // $ Source
	log.Printf("pw: %s", secret) // $ Alert

	log.Println("Password is: " + redact("password", password))

	var t testable
	var y int

	if t.test(y) {
		f()
		// ...
		log.Println("Password is: " + password) // $ Alert
		// ...
	}

	if t.test(y) {
		if f() {
			log.Println("Password is: " + password) // $ Alert
		}
	}

	if os.Getenv("APP_ENV") != "production" {
		log.Println("Password is: " + password) // $ SPURIOUS: Alert
	}

	var password1 stringable = stringable{"arstneio"}
	log.Println(name + ", " + password1.String()) // $ Alert

	config := Config{
		password: x, // $ Source
		hostname: "tarski",
		x:        password,      // $ Source
		y:        getPassword(), // $ Source
	}
	log.Println(config.hostname) // OK
	log.Println(config)          // $ Alert
	log.Println(config.x)        // $ Alert
	log.Println(config.y)        // $ Alert

	obj4 := xStruct{
		x: "aaaaa",
	}
	log.Println(obj4) // OK
}

const password = "horsebatterystaplecorrect"

func test2() {
	log.Println(password) // OK
}
