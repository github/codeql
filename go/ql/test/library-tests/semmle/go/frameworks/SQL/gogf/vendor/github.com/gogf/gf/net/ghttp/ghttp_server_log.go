// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package ghttp

import (
	"fmt"
	"github.com/gogf/gf/errors/gerror"
)

// handleAccessLog handles the access logging for server.
func (s *Server) handleAccessLog(r *Request) {
	if !s.IsAccessLogEnabled() {
		return
	}
	scheme := "http"
	if r.TLS != nil {
		scheme = "https"
	}
	s.Logger().Ctx(r.Context()).File(s.config.AccessLogPattern).
		Stdout(s.config.LogStdout).
		Printf(
			`%d "%s %s %s %s %s" %.3f, %s, "%s", "%s"`,
			r.Response.Status,
			r.Method, scheme, r.Host, r.URL.String(), r.Proto,
			float64(r.LeaveTime-r.EnterTime)/1000,
			r.GetClientIp(), r.Referer(), r.UserAgent(),
		)
}

// handleErrorLog handles the error logging for server.
func (s *Server) handleErrorLog(err error, r *Request) {
	// It does nothing if error logging is custom disabled.
	if !s.IsErrorLogEnabled() {
		return
	}

	scheme := "http"
	if r.TLS != nil {
		scheme = "https"
	}
	content := fmt.Sprintf(
		`%d "%s %s %s %s %s" %.3f, %s, "%s", "%s"`,
		r.Response.Status, r.Method, scheme, r.Host, r.URL.String(), r.Proto,
		float64(r.LeaveTime-r.EnterTime)/1000,
		r.GetClientIp(), r.Referer(), r.UserAgent(),
	)
	if s.config.ErrorStack {
		if stack := gerror.Stack(err); stack != "" {
			content += "\nStack:\n" + stack
		} else {
			content += ", " + err.Error()
		}
	} else {
		content += ", " + err.Error()
	}
	s.Logger().Ctx(r.Context()).
		File(s.config.ErrorLogPattern).
		Stdout(s.config.LogStdout).
		Print(content)
}
