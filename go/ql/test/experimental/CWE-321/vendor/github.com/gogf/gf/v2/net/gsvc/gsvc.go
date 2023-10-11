// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

// Package gsvc provides service registry and discovery definition.
package gsvc

import (
	"context"
	"time"

	"github.com/gogf/gf/v2/errors/gerror"
)

// Registry interface for service.
type Registry interface {
	Registrar
	Discovery
}

// Registrar interface for service registrar.
type Registrar interface {
	// Register registers `service` to Registry.
	Register(ctx context.Context, service *Service) error

	// Deregister off-lines and removes `service` from Registry.
	Deregister(ctx context.Context, service *Service) error
}

// Discovery interface for service discovery.
type Discovery interface {
	// Search searches and returns services with specified condition.
	Search(ctx context.Context, in SearchInput) ([]*Service, error)

	// Watch watches specified condition changes.
	Watch(ctx context.Context, key string) (Watcher, error)
}

// Watcher interface for service.
type Watcher interface {
	// Proceed proceeds watch in blocking way.
	Proceed() ([]*Service, error)

	// Close closes the watcher.
	Close() error
}

// Service definition.
type Service struct {
	Prefix     string   // Service prefix.
	Deployment string   // Service deployment name, eg: dev, qa, staging, prod, etc.
	Namespace  string   // Service Namespace, to indicate different service in the same environment with the same Name.
	Name       string   // Name for the service.
	Version    string   // Service version, eg: v1.0.0, v2.1.1, etc.
	Endpoints  []string // Service Endpoints, pattern: IP:port, eg: 192.168.1.2:8000.
	Metadata   Metadata // Custom data for this service, which can be set using JSON by environment or command-line.
}

// Metadata stores custom key-value pairs.
type Metadata map[string]interface{}

// SearchInput is the input for service searching.
type SearchInput struct {
	Prefix     string // Service prefix.
	Deployment string // Service deployment name, eg: dev, qa, staging, prod, etc.
	Namespace  string // Service Namespace, to indicate different service in the same environment with the same Name.
	Name       string // Name for the service.
	Version    string // Service version, eg: v1.0.0, v2.1.1, etc.}
}

// WatchInput is the input for service watching.
type WatchInput struct {
	Prefix     string // Service prefix.
	Deployment string // Service deployment name, eg: dev, qa, staging, prod, etc.
	Namespace  string // Service Namespace, to indicate different service in the same environment with the same Name.
	Name       string // Name for the service.
	Version    string // Service version, eg: v1.0.0, v2.1.1, etc.}
}

const (
	Schema            = `services`
	DefaultPrefix     = `services`
	DefaultDeployment = `default`
	DefaultNamespace  = `default`
	DefaultVersion    = `latest`
	EnvPrefix         = `GF_GSVC_PREFIX`
	EnvDeployment     = `GF_GSVC_DEPLOYMENT`
	EnvNamespace      = `GF_GSVC_NAMESPACE`
	EnvName           = `GF_GSVC_Name`
	EnvVersion        = `GF_GSVC_VERSION`
	MDProtocol        = `protocol`
	MDInsecure        = `insecure`
	MDWeight          = `weight`
	defaultTimeout    = 5 * time.Second
)

var (
	defaultRegistry Registry
)

// SetRegistry sets the default Registry implements as your own implemented interface.
func SetRegistry(registry Registry) {
	if registry == nil {
		panic(gerror.New(`invalid Registry value "nil" given`))
	}
	defaultRegistry = registry
}

// GetRegistry returns the default Registry that is previously set.
// It returns nil if no Registry is set.
func GetRegistry() Registry {
	return defaultRegistry
}
