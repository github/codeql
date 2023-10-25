package tunnel

import (
	"fmt"
	"net/http"
	"time"
)

const (
	// DefaultWebInterface is the default web interface for ngrok.
	DefaultWebInterface = "http://127.0.0.1:4040"
	// DefaultAddr is the default local web server address will be set
	// if tunnel's Addr field is missing.
	DefaultAddr = "localhost:8080"
)

// DefaultNameGenerator is a function which should set
// the application's name if Tunnel's Name field is missing.
//
// This name can be used to stop a tunnel as well.
var DefaultNameGenerator = func(tunnelIndex int) string {
	return fmt.Sprintf("app-%d-%s", tunnelIndex+1, time.Now().Format(http.TimeFormat))
}

// StartError is a custom error type which provides
// details about the started and failed to start tunnels
// so the caller can decide to retry the failed once or
// to stop the succeed ones.
//
// Usage:
// publicAddr, err := tunnel.Start(Configuration{...})
// if err != nil {
//	  if startErr, ok := err.(tunnel.Error);ok {
//      startErr.Failed tunnels...
//      startErr.Succeed tunnels...
//      startErr.Err error...
//	  }
// }
//
// See `Start` package-level function.
type StartError struct {
	Succeed []Tunnel
	Failed  []Tunnel
	Err     error
}

// Error returns the underline error's message.
func (e StartError) Error() string {
	if e.Err == nil {
		return ""
	}

	return e.Err.Error()
}

// Start creates a localhost ngrok tunnel based on the given Configuration.
// that's why it may return a non empty list among with a non-nil error.
//
// The ngrok instance may be running or not. Meaning that
// if the ngrok binary instance is not already running then
// this function will try to start it first.
func Start(c Configurator) (publicAddrs []string, err error) {
	cfg := getConfiguration(c)

	for tunnIdx, t := range cfg.Tunnels {
		if t.Name == "" {
			if DefaultNameGenerator != nil {
				t.Name = DefaultNameGenerator(tunnIdx)
			}
		}

		if t.Addr == "" {
			t.Addr = DefaultAddr
		}

		var publicAddr string
		err = cfg.StartTunnel(t, &publicAddr)
		if err != nil {
			err = StartError{
				Succeed: cfg.Tunnels[:tunnIdx],
				Failed:  cfg.Tunnels[tunnIdx:],
				Err:     err,
			}
			break
		}

		publicAddrs = append(publicAddrs, publicAddr)
	}

	// strings.Join(publicAddrs, ", ")
	return publicAddrs, err
}

// MustStart same as Start package-level function but it panics on error.
func MustStart(c Configurator) []string {
	publicAddrs, err := Start(c)
	if err != nil {
		panic(err)
	}

	return publicAddrs
}

// StopTunnel deletes a tunnel from a running ngrok instance.
// If the tunnelName is "*" then it stops all registered tunnels.
// The tunnelName can be also the server's original addr.
// Exits on first error.
func StopTunnel(c Configurator, tunnelName string) error {
	cfg := getConfiguration(c)

	for _, tunnel := range cfg.Tunnels {
		if tunnelName == "*" {
			if err := cfg.StopTunnel(tunnel); err != nil {
				return err
			}
		} else if tunnel.Name == tunnelName || tunnel.Addr == tunnelName {
			return cfg.StopTunnel(tunnel)
		}
	}

	return nil
}
