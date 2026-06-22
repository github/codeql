package main

const fmt = "formatted %s string"
const text = "test"
const key = "key"

var v []byte

func main() {
	glogTest(len(v))
	stdlib(len(v))
	slogTest()
}
