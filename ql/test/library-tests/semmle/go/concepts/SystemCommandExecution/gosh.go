package main

import "github.com/codeskyblue/go-sh"

func test() {
	sh.Command("echo", "hello\tworld").Run()
}
