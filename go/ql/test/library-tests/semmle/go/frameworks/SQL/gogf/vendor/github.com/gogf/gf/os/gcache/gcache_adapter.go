// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gcache

import (
	"context"
	"time"
)

// Adapter is the core adapter for cache features implements.
type Adapter interface {
	// Set sets cache with `key`-`value` pair, which is expired after `duration`.
	//
	// It does not expire if `duration` == 0.
	// It deletes the `key` if `duration` < 0.
	Set(ctx context.Context, key interface{}, value interface{}, duration time.Duration) error

	// Sets batch sets cache with key-value pairs by `data`, which is expired after `duration`.
	//
	// It does not expire if `duration` == 0.
	// It deletes the keys of `data` if `duration` < 0 or given `value` is nil.
	Sets(ctx context.Context, data map[interface{}]interface{}, duration time.Duration) error

	// SetIfNotExist sets cache with `key`-`value` pair which is expired after `duration`
	// if `key` does not exist in the cache. It returns true the `key` does not exist in the
	// cache, and it sets `value` successfully to the cache, or else it returns false.
	//
	// The parameter `value` can be type of `func() interface{}`, but it does nothing if its
	// result is nil.
	//
	// It does not expire if `duration` == 0.
	// It deletes the `key` if `duration` < 0 or given `value` is nil.
	SetIfNotExist(ctx context.Context, key interface{}, value interface{}, duration time.Duration) (bool, error)

	// Get retrieves and returns the associated value of given `key`.
	// It returns nil if it does not exist, its value is nil, or it's expired.
	Get(ctx context.Context, key interface{}) (interface{}, error)

	// GetOrSet retrieves and returns the value of `key`, or sets `key`-`value` pair and
	// returns `value` if `key` does not exist in the cache. The key-value pair expires
	// after `duration`.
	//
	// It does not expire if `duration` == 0.
	// It deletes the `key` if `duration` < 0 or given `value` is nil, but it does nothing
	// if `value` is a function and the function result is nil.
	GetOrSet(ctx context.Context, key interface{}, value interface{}, duration time.Duration) (interface{}, error)

	// GetOrSetFunc retrieves and returns the value of `key`, or sets `key` with result of
	// function `f` and returns its result if `key` does not exist in the cache. The key-value
	// pair expires after `duration`.
	//
	// It does not expire if `duration` == 0.
	// It deletes the `key` if `duration` < 0 or given `value` is nil, but it does nothing
	// if `value` is a function and the function result is nil.
	GetOrSetFunc(ctx context.Context, key interface{}, f func() (interface{}, error), duration time.Duration) (interface{}, error)

	// GetOrSetFuncLock retrieves and returns the value of `key`, or sets `key` with result of
	// function `f` and returns its result if `key` does not exist in the cache. The key-value
	// pair expires after `duration`.
	//
	// It does not expire if `duration` == 0.
	// It does nothing if function `f` returns nil.
	//
	// Note that the function `f` should be executed within writing mutex lock for concurrent
	// safety purpose.
	GetOrSetFuncLock(ctx context.Context, key interface{}, f func() (interface{}, error), duration time.Duration) (interface{}, error)

	// Contains returns true if `key` exists in the cache, or else returns false.
	Contains(ctx context.Context, key interface{}) (bool, error)

	// GetExpire retrieves and returns the expiration of `key` in the cache.
	//
	// It returns 0 if the `key` does not expire.
	// It returns -1 if the `key` does not exist in the cache.
	GetExpire(ctx context.Context, key interface{}) (time.Duration, error)

	// Remove deletes one or more keys from cache, and returns its value.
	// If multiple keys are given, it returns the value of the last deleted item.
	Remove(ctx context.Context, keys ...interface{}) (value interface{}, err error)

	// Update updates the value of `key` without changing its expiration and returns the old value.
	// The returned value `exist` is false if the `key` does not exist in the cache.
	//
	// It deletes the `key` if given `value` is nil.
	// It does nothing if `key` does not exist in the cache.
	Update(ctx context.Context, key interface{}, value interface{}) (oldValue interface{}, exist bool, err error)

	// UpdateExpire updates the expiration of `key` and returns the old expiration duration value.
	//
	// It returns -1 and does nothing if the `key` does not exist in the cache.
	// It deletes the `key` if `duration` < 0.
	UpdateExpire(ctx context.Context, key interface{}, duration time.Duration) (oldDuration time.Duration, err error)

	// Size returns the number of items in the cache.
	Size(ctx context.Context) (size int, err error)

	// Data returns a copy of all key-value pairs in the cache as map type.
	// Note that this function may lead lots of memory usage, you can implement this function
	// if necessary.
	Data(ctx context.Context) (map[interface{}]interface{}, error)

	// Keys returns all keys in the cache as slice.
	Keys(ctx context.Context) ([]interface{}, error)

	// Values returns all values in the cache as slice.
	Values(ctx context.Context) ([]interface{}, error)

	// Clear clears all data of the cache.
	// Note that this function is sensitive and should be carefully used.
	Clear(ctx context.Context) error

	// Close closes the cache if necessary.
	Close(ctx context.Context) error
}
