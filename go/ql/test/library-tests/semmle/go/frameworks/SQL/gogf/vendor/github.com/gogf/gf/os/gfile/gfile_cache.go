// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gfile

import (
	"github.com/gogf/gf/os/gcache"
	"github.com/gogf/gf/os/gcmd"
	"github.com/gogf/gf/os/gfsnotify"
	"time"
)

const (
	defaultCacheExpire    = time.Minute      // defaultCacheExpire is the expire time for file content caching in seconds.
	commandEnvKeyForCache = "gf.gfile.cache" // commandEnvKeyForCache is the configuration key for command argument or environment configuring cache expire duration.
)

var (
	// Default expire time for file content caching.
	cacheExpire = gcmd.GetOptWithEnv(commandEnvKeyForCache, defaultCacheExpire).Duration()

	// internalCache is the memory cache for internal usage.
	internalCache = gcache.New()
)

// GetContentsWithCache returns string content of given file by <path> from cache.
// If there's no content in the cache, it will read it from disk file specified by <path>.
// The parameter <expire> specifies the caching time for this file content in seconds.
func GetContentsWithCache(path string, duration ...time.Duration) string {
	return string(GetBytesWithCache(path, duration...))
}

// GetBytesWithCache returns []byte content of given file by <path> from cache.
// If there's no content in the cache, it will read it from disk file specified by <path>.
// The parameter <expire> specifies the caching time for this file content in seconds.
func GetBytesWithCache(path string, duration ...time.Duration) []byte {
	key := cacheKey(path)
	expire := cacheExpire
	if len(duration) > 0 {
		expire = duration[0]
	}
	r, _ := internalCache.GetOrSetFuncLock(key, func() (interface{}, error) {
		b := GetBytes(path)
		if b != nil {
			// Adding this <path> to gfsnotify,
			// it will clear its cache if there's any changes of the file.
			_, _ = gfsnotify.Add(path, func(event *gfsnotify.Event) {
				internalCache.Remove(key)
				gfsnotify.Exit()
			})
		}
		return b, nil
	}, expire)
	if r != nil {
		return r.([]byte)
	}
	return nil
}

// cacheKey produces the cache key for gcache.
func cacheKey(path string) string {
	return commandEnvKeyForCache + path
}
