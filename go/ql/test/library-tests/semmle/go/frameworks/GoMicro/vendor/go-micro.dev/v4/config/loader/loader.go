// Package loader manages loading from multiple sources
package loader

import (
	"context"

	"go-micro.dev/v4/config/reader"
	"go-micro.dev/v4/config/source"
)

// Loader manages loading sources.
type Loader interface {
	// Stop the loader
	Close() error
	// Load the sources
	Load(...source.Source) error
	// A Snapshot of loaded config
	Snapshot() (*Snapshot, error)
	// Force sync of sources
	Sync() error
	// Watch for changes
	Watch(...string) (Watcher, error)
	// Name of loader
	String() string
}

// Watcher lets you watch sources and returns a merged ChangeSet.
type Watcher interface {
	// First call to next may return the current Snapshot
	// If you are watching a path then only the data from
	// that path is returned.
	Next() (*Snapshot, error)
	// Stop watching for changes
	Stop() error
}

// Snapshot is a merged ChangeSet.
type Snapshot struct {
	// The merged ChangeSet
	ChangeSet *source.ChangeSet
	// Deterministic and comparable version of the snapshot
	Version string
}

// Options contains all options for a config loader.
type Options struct {
	Reader reader.Reader

	// for alternative data
	Context context.Context

	Source []source.Source

	WithWatcherDisabled bool
}

// Option is a helper for a single option.
type Option func(o *Options)

// Copy snapshot.
func Copy(s *Snapshot) *Snapshot {
	cs := *(s.ChangeSet)

	return &Snapshot{
		ChangeSet: &cs,
		Version:   s.Version,
	}
}
