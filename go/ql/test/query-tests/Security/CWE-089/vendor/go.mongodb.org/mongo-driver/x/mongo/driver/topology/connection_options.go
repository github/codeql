package topology

import (
	"context"
	"crypto/tls"
	"net"
	"time"

	"go.mongodb.org/mongo-driver/event"
	"go.mongodb.org/mongo-driver/x/mongo/driver"
	"go.mongodb.org/mongo-driver/x/mongo/driver/ocsp"
)

// Dialer is used to make network connections.
type Dialer interface {
	DialContext(ctx context.Context, network, address string) (net.Conn, error)
}

// DialerFunc is a type implemented by functions that can be used as a Dialer.
type DialerFunc func(ctx context.Context, network, address string) (net.Conn, error)

// DialContext implements the Dialer interface.
func (df DialerFunc) DialContext(ctx context.Context, network, address string) (net.Conn, error) {
	return df(ctx, network, address)
}

// DefaultDialer is the Dialer implementation that is used by this package. Changing this
// will also change the Dialer used for this package. This should only be changed why all
// of the connections being made need to use a different Dialer. Most of the time, using a
// WithDialer option is more appropriate than changing this variable.
var DefaultDialer Dialer = &net.Dialer{}

// Handshaker is the interface implemented by types that can perform a MongoDB
// handshake over a provided driver.Connection. This is used during connection
// initialization. Implementations must be goroutine safe.
type Handshaker = driver.Handshaker

type connectionConfig struct {
	appName                  string
	connectTimeout           time.Duration
	dialer                   Dialer
	handshaker               Handshaker
	idleTimeout              time.Duration
	cmdMonitor               *event.CommandMonitor
	poolMonitor              *event.PoolMonitor
	readTimeout              time.Duration
	writeTimeout             time.Duration
	tlsConfig                *tls.Config
	compressors              []string
	zlibLevel                *int
	zstdLevel                *int
	ocspCache                ocsp.Cache
	disableOCSPEndpointCheck bool
	errorHandlingCallback    func(error, uint64)
	tlsConnectionSource      tlsConnectionSource
}

func newConnectionConfig(opts ...ConnectionOption) (*connectionConfig, error) {
	cfg := &connectionConfig{
		connectTimeout:      30 * time.Second,
		dialer:              nil,
		tlsConnectionSource: defaultTLSConnectionSource,
	}

	for _, opt := range opts {
		err := opt(cfg)
		if err != nil {
			return nil, err
		}
	}

	if cfg.dialer == nil {
		cfg.dialer = &net.Dialer{}
	}

	return cfg, nil
}

// ConnectionOption is used to configure a connection.
type ConnectionOption func(*connectionConfig) error

func withTLSConnectionSource(fn func(tlsConnectionSource) tlsConnectionSource) ConnectionOption {
	return func(c *connectionConfig) error {
		c.tlsConnectionSource = fn(c.tlsConnectionSource)
		return nil
	}
}

func withErrorHandlingCallback(fn func(error, uint64)) ConnectionOption {
	return func(c *connectionConfig) error {
		c.errorHandlingCallback = fn
		return nil
	}
}

// WithCompressors sets the compressors that can be used for communication.
func WithCompressors(fn func([]string) []string) ConnectionOption {
	return func(c *connectionConfig) error {
		c.compressors = fn(c.compressors)
		return nil
	}
}

// WithConnectTimeout configures the maximum amount of time a dial will wait for a
// Connect to complete. The default is 30 seconds.
func WithConnectTimeout(fn func(time.Duration) time.Duration) ConnectionOption {
	return func(c *connectionConfig) error {
		c.connectTimeout = fn(c.connectTimeout)
		return nil
	}
}

// WithDialer configures the Dialer to use when making a new connection to MongoDB.
func WithDialer(fn func(Dialer) Dialer) ConnectionOption {
	return func(c *connectionConfig) error {
		c.dialer = fn(c.dialer)
		return nil
	}
}

// WithHandshaker configures the Handshaker that wll be used to initialize newly
// dialed connections.
func WithHandshaker(fn func(Handshaker) Handshaker) ConnectionOption {
	return func(c *connectionConfig) error {
		c.handshaker = fn(c.handshaker)
		return nil
	}
}

// WithIdleTimeout configures the maximum idle time to allow for a connection.
func WithIdleTimeout(fn func(time.Duration) time.Duration) ConnectionOption {
	return func(c *connectionConfig) error {
		c.idleTimeout = fn(c.idleTimeout)
		return nil
	}
}

// WithReadTimeout configures the maximum read time for a connection.
func WithReadTimeout(fn func(time.Duration) time.Duration) ConnectionOption {
	return func(c *connectionConfig) error {
		c.readTimeout = fn(c.readTimeout)
		return nil
	}
}

// WithWriteTimeout configures the maximum write time for a connection.
func WithWriteTimeout(fn func(time.Duration) time.Duration) ConnectionOption {
	return func(c *connectionConfig) error {
		c.writeTimeout = fn(c.writeTimeout)
		return nil
	}
}

// WithTLSConfig configures the TLS options for a connection.
func WithTLSConfig(fn func(*tls.Config) *tls.Config) ConnectionOption {
	return func(c *connectionConfig) error {
		c.tlsConfig = fn(c.tlsConfig)
		return nil
	}
}

// WithMonitor configures a event for command monitoring.
func WithMonitor(fn func(*event.CommandMonitor) *event.CommandMonitor) ConnectionOption {
	return func(c *connectionConfig) error {
		c.cmdMonitor = fn(c.cmdMonitor)
		return nil
	}
}

// withPoolMonitor configures a event for connection monitoring.
func withPoolMonitor(fn func(*event.PoolMonitor) *event.PoolMonitor) ConnectionOption {
	return func(c *connectionConfig) error {
		c.poolMonitor = fn(c.poolMonitor)
		return nil
	}
}

// WithZlibLevel sets the zLib compression level.
func WithZlibLevel(fn func(*int) *int) ConnectionOption {
	return func(c *connectionConfig) error {
		c.zlibLevel = fn(c.zlibLevel)
		return nil
	}
}

// WithZstdLevel sets the zstd compression level.
func WithZstdLevel(fn func(*int) *int) ConnectionOption {
	return func(c *connectionConfig) error {
		c.zstdLevel = fn(c.zstdLevel)
		return nil
	}
}

// WithOCSPCache specifies a cache to use for OCSP verification.
func WithOCSPCache(fn func(ocsp.Cache) ocsp.Cache) ConnectionOption {
	return func(c *connectionConfig) error {
		c.ocspCache = fn(c.ocspCache)
		return nil
	}
}

// WithDisableOCSPEndpointCheck specifies whether or the driver should perform non-stapled OCSP verification. If set
// to true, the driver will only check stapled responses and will continue the connection without reaching out to
// OCSP responders.
func WithDisableOCSPEndpointCheck(fn func(bool) bool) ConnectionOption {
	return func(c *connectionConfig) error {
		c.disableOCSPEndpointCheck = fn(c.disableOCSPEndpointCheck)
		return nil
	}
}
