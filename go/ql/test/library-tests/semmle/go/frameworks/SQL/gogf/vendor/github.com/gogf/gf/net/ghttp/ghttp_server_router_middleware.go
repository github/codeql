// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package ghttp

import (
	"github.com/gogf/gf/debug/gdebug"
	"reflect"
)

const (
	// The default route pattern for global middleware.
	defaultMiddlewarePattern = "/*"
)

// BindMiddleware registers one or more global middleware to the server.
// Global middleware can be used standalone without service handler, which intercepts all dynamic requests
// before or after service handler. The parameter <pattern> specifies what route pattern the middleware intercepts,
// which is usually a "fuzzy" pattern like "/:name", "/*any" or "/{field}".
func (s *Server) BindMiddleware(pattern string, handlers ...HandlerFunc) {
	for _, handler := range handlers {
		s.setHandler(pattern, &handlerItem{
			Type: handlerTypeMiddleware,
			Name: gdebug.FuncPath(handler),
			Info: handlerFuncInfo{
				Func: handler,
				Type: reflect.TypeOf(handler),
			},
		})
	}
}

// BindMiddlewareDefault registers one or more global middleware to the server using default pattern "/*".
// Global middleware can be used standalone without service handler, which intercepts all dynamic requests
// before or after service handler.
func (s *Server) BindMiddlewareDefault(handlers ...HandlerFunc) {
	for _, handler := range handlers {
		s.setHandler(defaultMiddlewarePattern, &handlerItem{
			Type: handlerTypeMiddleware,
			Name: gdebug.FuncPath(handler),
			Info: handlerFuncInfo{
				Func: handler,
				Type: reflect.TypeOf(handler),
			},
		})
	}
}

// Use is alias of BindMiddlewareDefault.
// See BindMiddlewareDefault.
func (s *Server) Use(handlers ...HandlerFunc) {
	s.BindMiddlewareDefault(handlers...)
}
