package main

//go:generate depstubber -vendor gopkg.in/macaron.v1 Context,RequestBody

import (
	"gopkg.in/macaron.v1"
)

func sources(ctx *macaron.Context, body *macaron.RequestBody) {
	_ = ctx.AllParams()                     // $RemoteFlowSource
	_ = ctx.GetCookie("")                   // $RemoteFlowSource
	_, _ = ctx.GetSecureCookie("")          // $RemoteFlowSource
	_, _ = ctx.GetSuperSecureCookie("", "") // $RemoteFlowSource
	_, _, _ = ctx.GetFile("")               // $RemoteFlowSource
	_ = ctx.Params("")                      // $RemoteFlowSource
	_ = ctx.ParamsEscape("")                // $RemoteFlowSource
	_ = ctx.Query("")                       // $RemoteFlowSource
	_ = ctx.QueryEscape("")                 // $RemoteFlowSource
	_ = ctx.QueryStrings("")                // $RemoteFlowSource
	_, _ = body.Bytes()                     // $RemoteFlowSource
	_, _ = body.String()                    // $RemoteFlowSource
}
