package main

//go:generate depstubber -vendor gopkg.in/macaron.v1 Context,RequestBody

import (
	"gopkg.in/macaron.v1"
)

func sources(ctx *macaron.Context, body *macaron.RequestBody) {
	_ = ctx.AllParams()                     // $UntrustedFlowSource
	_ = ctx.GetCookie("")                   // $UntrustedFlowSource
	_, _ = ctx.GetSecureCookie("")          // $UntrustedFlowSource
	_, _ = ctx.GetSuperSecureCookie("", "") // $UntrustedFlowSource
	_, _, _ = ctx.GetFile("")               // $UntrustedFlowSource
	_ = ctx.Params("")                      // $UntrustedFlowSource
	_ = ctx.ParamsEscape("")                // $UntrustedFlowSource
	_ = ctx.Query("")                       // $UntrustedFlowSource
	_ = ctx.QueryEscape("")                 // $UntrustedFlowSource
	_ = ctx.QueryStrings("")                // $UntrustedFlowSource
	_, _ = body.Bytes()                     // $UntrustedFlowSource
	_, _ = body.String()                    // $UntrustedFlowSource
}
