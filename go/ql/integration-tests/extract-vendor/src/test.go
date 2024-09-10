package test

import (
	subdir "example.com/test"
)

func Test() {

	foo := subdir.Add(2, 2)
	println(foo)
}
