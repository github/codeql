package main

//go:generate depstubber -vendor gopkg.in/macaron.v1 Context

import (
	"gopkg.in/macaron.v1"
)

type EmbeddedContext struct {
	*macaron.Context
	foo string
}

func redir(ctx *macaron.Context) {
	ctx.Redirect("/example")
}

func redir1(ctx *EmbeddedContext) {
	ctx.Redirect("/example")
}

func main() {
}
