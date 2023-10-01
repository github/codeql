// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

// Package grpool implements a goroutine reusable pool.
package grpool

import (
	"context"

	"github.com/gogf/gf/v2/container/glist"
	"github.com/gogf/gf/v2/container/gtype"
	"github.com/gogf/gf/v2/errors/gcode"
	"github.com/gogf/gf/v2/errors/gerror"
)

// Func is the pool function which contains context parameter.
type Func func(ctx context.Context)

// Pool manages the goroutines using pool.
type Pool struct {
	limit  int         // Max goroutine count limit.
	count  *gtype.Int  // Current running goroutine count.
	list   *glist.List // Job list for asynchronous job adding purpose.
	closed *gtype.Bool // Is pool closed or not.
}

type internalPoolItem struct {
	Ctx  context.Context
	Func Func
}

// Default goroutine pool.
var (
	pool = New()
)

// New creates and returns a new goroutine pool object.
// The parameter `limit` is used to limit the max goroutine count,
// which is not limited in default.
func New(limit ...int) *Pool {
	p := &Pool{
		limit:  -1,
		count:  gtype.NewInt(),
		list:   glist.New(true),
		closed: gtype.NewBool(),
	}
	if len(limit) > 0 && limit[0] > 0 {
		p.limit = limit[0]
	}
	return p
}

// Add pushes a new job to the pool using default goroutine pool.
// The job will be executed asynchronously.
func Add(ctx context.Context, f Func) error {
	return pool.Add(ctx, f)
}

// AddWithRecover pushes a new job to the pool with specified recover function.
// The optional `recoverFunc` is called when any panic during executing of `userFunc`.
// If `recoverFunc` is not passed or given nil, it ignores the panic from `userFunc`.
// The job will be executed asynchronously.
func AddWithRecover(ctx context.Context, userFunc Func, recoverFunc ...func(err error)) error {
	return pool.AddWithRecover(ctx, userFunc, recoverFunc...)
}

// Size returns current goroutine count of default goroutine pool.
func Size() int {
	return pool.Size()
}

// Jobs returns current job count of default goroutine pool.
func Jobs() int {
	return pool.Jobs()
}

// Add pushes a new job to the pool.
// The job will be executed asynchronously.
func (p *Pool) Add(ctx context.Context, f Func) error {
	for p.closed.Val() {
		return gerror.NewCode(gcode.CodeInvalidOperation, "pool closed")
	}
	p.list.PushFront(&internalPoolItem{
		Ctx:  ctx,
		Func: f,
	})
	// Check whether fork new goroutine or not.
	var n int
	for {
		n = p.count.Val()
		if p.limit != -1 && n >= p.limit {
			// No need fork new goroutine.
			return nil
		}
		if p.count.Cas(n, n+1) {
			// Use CAS to guarantee atomicity.
			break
		}
	}
	p.fork()
	return nil
}

// AddWithRecover pushes a new job to the pool with specified recover function.
// The optional `recoverFunc` is called when any panic during executing of `userFunc`.
// If `recoverFunc` is not passed or given nil, it ignores the panic from `userFunc`.
// The job will be executed asynchronously.
func (p *Pool) AddWithRecover(ctx context.Context, userFunc Func, recoverFunc ...func(err error)) error {
	return p.Add(ctx, func(ctx context.Context) {
		defer func() {
			if exception := recover(); exception != nil {
				if len(recoverFunc) > 0 && recoverFunc[0] != nil {
					if v, ok := exception.(error); ok && gerror.HasStack(v) {
						recoverFunc[0](v)
					} else {
						recoverFunc[0](gerror.Newf(`%+v`, exception))
					}
				}
			}
		}()
		userFunc(ctx)
	})
}

// Cap returns the capacity of the pool.
// This capacity is defined when pool is created.
// It returns -1 if there's no limit.
func (p *Pool) Cap() int {
	return p.limit
}

// Size returns current goroutine count of the pool.
func (p *Pool) Size() int {
	return p.count.Val()
}

// Jobs returns current job count of the pool.
// Note that, it does not return worker/goroutine count but the job/task count.
func (p *Pool) Jobs() int {
	return p.list.Size()
}

// fork creates a new goroutine worker.
// Note that the worker dies if the job function panics.
func (p *Pool) fork() {
	go func() {
		defer p.count.Add(-1)

		var (
			listItem interface{}
			poolItem *internalPoolItem
		)
		for !p.closed.Val() {
			if listItem = p.list.PopBack(); listItem != nil {
				poolItem = listItem.(*internalPoolItem)
				poolItem.Func(poolItem.Ctx)
			} else {
				return
			}
		}
	}()
}

// IsClosed returns if pool is closed.
func (p *Pool) IsClosed() bool {
	return p.closed.Val()
}

// Close closes the goroutine pool, which makes all goroutines exit.
func (p *Pool) Close() {
	p.closed.Set(true)
}
