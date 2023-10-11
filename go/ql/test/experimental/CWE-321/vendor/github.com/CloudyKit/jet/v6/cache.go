package jet

import "sync"

// Cache is the interface Jet uses to store and retrieve parsed templates.
type Cache interface {

	// Get fetches a template from the cache. If Get returns nil, the same path with a different extension will be tried.
	// If Get() returns nil for all configured extensions, the same path and extensions will be tried on the Set's Loader.
	Get(templatePath string) *Template

	// Put places the result of parsing a template "file"/string in the cache.
	Put(templatePath string, t *Template)
}

// cache is the cache used by default in a new Set.
type cache struct {
	m sync.Map
}

// compile-time check that cache implements Cache
var _ Cache = (*cache)(nil)

func (c *cache) Get(templatePath string) *Template {
	_t, ok := c.m.Load(templatePath)
	if !ok {
		return nil
	}
	return _t.(*Template)
}

func (c *cache) Put(templatePath string, t *Template) {
	c.m.Store(templatePath, t)
}
