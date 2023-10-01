// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gredis

import (
	"context"

	"github.com/gogf/gf/v2/container/gvar"
	"github.com/gogf/gf/v2/errors/gcode"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/internal/intlog"
)

// Redis client.
type Redis struct {
	adapter Adapter
}

const (
	errorNilRedis = `the Redis object is nil`
)

// SetAdapter sets custom adapter for current redis client.
func (r *Redis) SetAdapter(adapter Adapter) {
	if r == nil {
		return
	}
	r.adapter = adapter
}

// GetAdapter returns the adapter that is set in current redis client.
func (r *Redis) GetAdapter() Adapter {
	if r == nil {
		return nil
	}
	return r.adapter
}

// Conn retrieves and returns a connection object for continuous operations.
// Note that you should call Close function manually if you do not use this connection any further.
func (r *Redis) Conn(ctx context.Context) (*RedisConn, error) {
	if r == nil {
		return nil, gerror.NewCode(gcode.CodeInvalidParameter, errorNilRedis)
	}
	if r.adapter == nil {
		return nil, gerror.NewCodef(
			gcode.CodeMissingConfiguration,
			`redis adapter not initialized, missing configuration or adapter register?`,
		)
	}
	conn, err := r.adapter.Conn(ctx)
	if err != nil {
		return nil, err
	}
	return &RedisConn{
		conn:  conn,
		redis: r,
	}, nil
}

// Do send a command to the server and returns the received reply.
// It uses json.Marshal for struct/slice/map type values before committing them to redis.
func (r *Redis) Do(ctx context.Context, command string, args ...interface{}) (*gvar.Var, error) {
	if r == nil {
		return nil, gerror.NewCode(gcode.CodeInvalidParameter, errorNilRedis)
	}
	conn, err := r.Conn(ctx)
	if err != nil {
		return nil, err
	}
	defer func() {
		if closeErr := conn.Close(ctx); closeErr != nil {
			intlog.Errorf(ctx, `%+v`, closeErr)
		}
	}()
	return conn.Do(ctx, command, args...)
}

// MustConn performs as function Conn, but it panics if any error occurs internally.
func (r *Redis) MustConn(ctx context.Context) *RedisConn {
	c, err := r.Conn(ctx)
	if err != nil {
		panic(err)
	}
	return c
}

// MustDo performs as function Do, but it panics if any error occurs internally.
func (r *Redis) MustDo(ctx context.Context, command string, args ...interface{}) *gvar.Var {
	v, err := r.Do(ctx, command, args...)
	if err != nil {
		panic(err)
	}
	return v
}

// Close closes current redis client, closes its connection pool and releases all its related resources.
func (r *Redis) Close(ctx context.Context) error {
	if r == nil {
		return gerror.NewCode(gcode.CodeInvalidParameter, errorNilRedis)
	}
	return r.adapter.Close(ctx)
}
