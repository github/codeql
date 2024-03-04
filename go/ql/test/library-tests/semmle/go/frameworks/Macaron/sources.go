package main

//go:generate depstubber -vendor gopkg.in/macaron.v1 Context,RequestBody

import (
	"gopkg.in/macaron.v1"
)

func sources(ctx *macaron.Context, body *macaron.RequestBody) {
	_ = ctx.AllParams()
	_ = ctx.GetCookie("")
	_, _ = ctx.GetSecureCookie("")
	_, _ = ctx.GetSuperSecureCookie("", "")
	_, _, _ = ctx.GetFile("")
	_ = ctx.Params("")
	_ = ctx.ParamsEscape("")
	_ = ctx.Query("")
	_ = ctx.QueryEscape("")
	_ = ctx.QueryStrings("")
	_, _ = body.Bytes()
	_, _ = body.String()
}
