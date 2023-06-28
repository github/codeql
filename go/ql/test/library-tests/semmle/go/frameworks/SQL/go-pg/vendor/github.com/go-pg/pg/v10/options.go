package pg

import (
	"context"
	"crypto/tls"
	"errors"
	"fmt"
	"net"
	"net/url"
	"os"
	"runtime"
	"strconv"
	"strings"
	"time"

	"github.com/go-pg/pg/v10/internal/pool"
)

// Options contains database connection options.
type Options struct {
	// Network type, either tcp or unix.
	// Default is tcp.
	Network string
	// TCP host:port or Unix socket depending on Network.
	Addr string

	// Dialer creates new network connection and has priority over
	// Network and Addr options.
	Dialer func(ctx context.Context, network, addr string) (net.Conn, error)

	// Hook that is called after new connection is established
	// and user is authenticated.
	OnConnect func(ctx context.Context, cn *Conn) error

	User     string
	Password string
	Database string

	// ApplicationName is the application name. Used in logs on Pg side.
	// Only available from pg-9.0.
	ApplicationName string

	// TLS config for secure connections.
	TLSConfig *tls.Config

	// Dial timeout for establishing new connections.
	// Default is 5 seconds.
	DialTimeout time.Duration

	// Timeout for socket reads. If reached, commands will fail
	// with a timeout instead of blocking.
	ReadTimeout time.Duration
	// Timeout for socket writes. If reached, commands will fail
	// with a timeout instead of blocking.
	WriteTimeout time.Duration

	// Maximum number of retries before giving up.
	// Default is to not retry failed queries.
	MaxRetries int
	// Whether to retry queries cancelled because of statement_timeout.
	RetryStatementTimeout bool
	// Minimum backoff between each retry.
	// Default is 250 milliseconds; -1 disables backoff.
	MinRetryBackoff time.Duration
	// Maximum backoff between each retry.
	// Default is 4 seconds; -1 disables backoff.
	MaxRetryBackoff time.Duration

	// Maximum number of socket connections.
	// Default is 10 connections per every CPU as reported by runtime.NumCPU.
	PoolSize int
	// Minimum number of idle connections which is useful when establishing
	// new connection is slow.
	MinIdleConns int
	// Connection age at which client retires (closes) the connection.
	// It is useful with proxies like PgBouncer and HAProxy.
	// Default is to not close aged connections.
	MaxConnAge time.Duration
	// Time for which client waits for free connection if all
	// connections are busy before returning an error.
	// Default is 30 seconds if ReadTimeOut is not defined, otherwise,
	// ReadTimeout + 1 second.
	PoolTimeout time.Duration
	// Amount of time after which client closes idle connections.
	// Should be less than server's timeout.
	// Default is 5 minutes. -1 disables idle timeout check.
	IdleTimeout time.Duration
	// Frequency of idle checks made by idle connections reaper.
	// Default is 1 minute. -1 disables idle connections reaper,
	// but idle connections are still discarded by the client
	// if IdleTimeout is set.
	IdleCheckFrequency time.Duration
}

func (opt *Options) init() {
	if opt.Network == "" {
		opt.Network = "tcp"
	}

	if opt.Addr == "" {
		switch opt.Network {
		case "tcp":
			host := env("PGHOST", "localhost")
			port := env("PGPORT", "5432")
			opt.Addr = fmt.Sprintf("%s:%s", host, port)
		case "unix":
			opt.Addr = "/var/run/postgresql/.s.PGSQL.5432"
		}
	}

	if opt.DialTimeout == 0 {
		opt.DialTimeout = 5 * time.Second
	}
	if opt.Dialer == nil {
		opt.Dialer = func(ctx context.Context, network, addr string) (net.Conn, error) {
			netDialer := &net.Dialer{
				Timeout:   opt.DialTimeout,
				KeepAlive: 5 * time.Minute,
			}
			return netDialer.DialContext(ctx, network, addr)
		}
	}

	if opt.User == "" {
		opt.User = env("PGUSER", "postgres")
	}

	if opt.Database == "" {
		opt.Database = env("PGDATABASE", "postgres")
	}

	if opt.PoolSize == 0 {
		opt.PoolSize = 10 * runtime.NumCPU()
	}

	if opt.PoolTimeout == 0 {
		if opt.ReadTimeout != 0 {
			opt.PoolTimeout = opt.ReadTimeout + time.Second
		} else {
			opt.PoolTimeout = 30 * time.Second
		}
	}

	if opt.IdleTimeout == 0 {
		opt.IdleTimeout = 5 * time.Minute
	}
	if opt.IdleCheckFrequency == 0 {
		opt.IdleCheckFrequency = time.Minute
	}

	switch opt.MinRetryBackoff {
	case -1:
		opt.MinRetryBackoff = 0
	case 0:
		opt.MinRetryBackoff = 250 * time.Millisecond
	}
	switch opt.MaxRetryBackoff {
	case -1:
		opt.MaxRetryBackoff = 0
	case 0:
		opt.MaxRetryBackoff = 4 * time.Second
	}
}

func env(key, defValue string) string {
	envValue := os.Getenv(key)
	if envValue != "" {
		return envValue
	}
	return defValue
}

// ParseURL parses an URL into options that can be used to connect to PostgreSQL.
func ParseURL(sURL string) (*Options, error) {
	parsedURL, err := url.Parse(sURL)
	if err != nil {
		return nil, err
	}

	// scheme
	if parsedURL.Scheme != "postgres" && parsedURL.Scheme != "postgresql" {
		return nil, errors.New("pg: invalid scheme: " + parsedURL.Scheme)
	}

	// host and port
	options := &Options{
		Addr: parsedURL.Host,
	}
	if !strings.Contains(options.Addr, ":") {
		options.Addr += ":5432"
	}

	// username and password
	if parsedURL.User != nil {
		options.User = parsedURL.User.Username()

		if password, ok := parsedURL.User.Password(); ok {
			options.Password = password
		}
	}

	if options.User == "" {
		options.User = "postgres"
	}

	// database
	if len(strings.Trim(parsedURL.Path, "/")) > 0 {
		options.Database = parsedURL.Path[1:]
	} else {
		return nil, errors.New("pg: database name not provided")
	}

	// ssl mode
	query, err := url.ParseQuery(parsedURL.RawQuery)
	if err != nil {
		return nil, err
	}

	if sslMode, ok := query["sslmode"]; ok && len(sslMode) > 0 {
		switch sslMode[0] {
		case "verify-ca", "verify-full":
			options.TLSConfig = &tls.Config{}
		case "allow", "prefer", "require":
			options.TLSConfig = &tls.Config{InsecureSkipVerify: true} //nolint
		case "disable":
			options.TLSConfig = nil
		default:
			return nil, fmt.Errorf("pg: sslmode '%v' is not supported", sslMode[0])
		}
	} else {
		options.TLSConfig = &tls.Config{InsecureSkipVerify: true} //nolint
	}

	delete(query, "sslmode")

	if appName, ok := query["application_name"]; ok && len(appName) > 0 {
		options.ApplicationName = appName[0]
	}

	delete(query, "application_name")

	if connTimeout, ok := query["connect_timeout"]; ok && len(connTimeout) > 0 {
		ct, err := strconv.Atoi(connTimeout[0])
		if err != nil {
			return nil, fmt.Errorf("pg: cannot parse connect_timeout option as int")
		}
		options.DialTimeout = time.Second * time.Duration(ct)
	}

	delete(query, "connect_timeout")

	if len(query) > 0 {
		return nil, errors.New("pg: options other than 'sslmode', 'application_name' and 'connect_timeout' are not supported")
	}

	return options, nil
}

func (opt *Options) getDialer() func(context.Context) (net.Conn, error) {
	return func(ctx context.Context) (net.Conn, error) {
		return opt.Dialer(ctx, opt.Network, opt.Addr)
	}
}

func newConnPool(opt *Options) *pool.ConnPool {
	return pool.NewConnPool(&pool.Options{
		Dialer:  opt.getDialer(),
		OnClose: terminateConn,

		PoolSize:           opt.PoolSize,
		MinIdleConns:       opt.MinIdleConns,
		MaxConnAge:         opt.MaxConnAge,
		PoolTimeout:        opt.PoolTimeout,
		IdleTimeout:        opt.IdleTimeout,
		IdleCheckFrequency: opt.IdleCheckFrequency,
	})
}
