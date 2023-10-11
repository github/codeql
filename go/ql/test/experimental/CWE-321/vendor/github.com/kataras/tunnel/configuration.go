package tunnel

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

// Configurator is an interface with a single `Apply` method.
// Available Configurators:
// - Configuration{}
// - WithServers
//
// See `Start` package-level function.
type Configurator interface {
	Apply(*Configuration)
}

// ConfiguratorFunc a function signature that completes the `Configurator` interface.
type ConfiguratorFunc func(*Configuration)

// Apply should set the Configuration "tc".
func (opt ConfiguratorFunc) Apply(tc *Configuration) {
	opt(tc)
}

// WithServers its a helper which returns a new Configuration
// added one or more Tunnels based on `http.Server` instances.
func WithServers(servers ...*http.Server) ConfiguratorFunc {
	return func(tc *Configuration) {
		for _, srv := range servers {
			tunnel := Tunnel{
				Addr: srv.Addr,
			}
			tc.Tunnels = append(tc.Tunnels, tunnel)

			srv.RegisterOnShutdown(func() {
				tc.StopTunnel(tunnel)
			})
		}
	}
}

type (
	// Configuration contains configuration
	// for the optional tunneling through ngrok feature.
	// Note that the ngrok should be already installed at the host machine.
	Configuration struct {
		// Client defaults to the http.DefaultClient,
		// callers can use this field to change it.
		Client *http.Client
		// AuthToken field is optionally and can be used
		// to authenticate the ngrok access.
		// ngrok authtoken <YOUR_AUTHTOKEN>
		AuthToken string `ini:"auth_token" json:"authToken,omitempty" yaml:"AuthToken" toml:"AuthToken"`

		// No:
		// Config is optionally and can be used
		// to load ngrok configuration from file system path.
		//
		// If you don't specify a location for a configuration file,
		// ngrok tries to read one from the default location $HOME/.ngrok2/ngrok.yml.
		// The configuration file is optional; no error is emitted if that path does not exist.
		// Config string `json:"config,omitempty" yaml:"Config" toml:"Config"`

		// Bin is the system binary path of the ngrok executable file.
		// If it's empty then it will try to find it through system env variables.
		Bin string `ini:"bin" json:"bin,omitempty" yaml:"Bin" toml:"Bin"`

		// WebUIAddr is the web interface address of an already-running ngrok instance.
		// The package will try to fetch the default web interface address(http://127.0.0.1:4040)
		// to determinate if a ngrok instance is running before try to start it manually.
		// However if a custom web interface address is used,
		// this field must be set e.g. http://127.0.0.1:5050.
		WebInterface string `ini:"web_interface" json:"webInterface,omitempty" yaml:"WebInterface" toml:"WebInterface"`

		// Region is optionally, can be used to set the region which defaults to "us".
		// Available values are:
		// "us" for United States
		// "eu" for Europe
		// "ap" for Asia/Pacific
		// "au" for Australia
		// "sa" for South America
		// "jp" forJapan
		// "in" for India
		Region string `ini:"region" json:"region,omitempty" yaml:"Region" toml:"Region"`
		// Tunnels the collection of the tunnels.
		// Most of the times you only need one.
		Tunnels []Tunnel `ini:"tunnels" json:"tunnels" yaml:"Tunnels" toml:"Tunnels"`
	}

	// Tunnel is the Tunnels field of the Configuration structure.
	Tunnel struct {
		// Name is the only one required field,
		// it is used to create and close tunnels, e.g. "MyApp".
		// If this field is not empty then ngrok tunnels will be created
		// when the app is up and running.
		Name string `ini:"name" json:"name" yaml:"Name" toml:"Name"`
		// Addr should be set of form 'hostname:port'.
		Addr string `ini:"addr" json:"addr,omitempty" yaml:"Addr" toml:"Addr"`

		// Hostname is a static subdomain that can be used instead of random URLs
		// when paid account.
		Hostname string `ini:"hostname" json:"hostname,omitempty" yaml:"Hostname" toml:"Hostname"`
	}
)

var _ Configurator = Configuration{}

func getConfiguration(c Configurator) Configuration {
	cfg := Configuration{}
	c.Apply(&cfg)

	if cfg.Client == nil {
		cfg.Client = http.DefaultClient
	}

	if cfg.WebInterface == "" {
		cfg.WebInterface = DefaultWebInterface
	}

	return cfg
}

// Apply implements the Option on the Configuration structure.
func (tc Configuration) Apply(c *Configuration) {
	*c = tc
}

func (tc Configuration) isEnabled() bool {
	return len(tc.Tunnels) > 0
}

func (tc Configuration) isNgrokRunning() bool {
	resp, err := tc.Client.Get(tc.WebInterface)
	if err != nil {
		return false
	}

	resp.Body.Close()
	return true
}

// https://ngrok.com/docs/ngrok-agent/api
type ngrokTunnel struct {
	Name  string `json:"name"`
	Addr  string `json:"addr"`
	Proto string `json:"proto"`
	Auth  string `json:"basic_auth,omitempty"`
	//	BindTLS  bool   `json:"bind_tls"`
	Schemes  []string `json:"schemes"`
	Hostname string   `json:"hostname"`
}

// ErrExec returns when ngrok executable was not found in the PATH or NGROK environment variable.
var ErrExec = errors.New(`"ngrok" executable not found, please install it from: https://ngrok.com/download`)

// StartTunnel starts the ngrok, if not already running,
// creates and starts a localhost tunnel. It binds the "publicAddr" pointer
// to the value of the ngrok's output public address.
func (tc Configuration) StartTunnel(t Tunnel, publicAddr *string) error {
	tunnelAPIRequest := ngrokTunnel{
		Name:     t.Name,
		Addr:     t.Addr,
		Hostname: t.Hostname,
		Proto:    "http",
		Schemes:  []string{"https"},
		// BindTLS:  true,
	}

	if !tc.isNgrokRunning() {
		ngrokBin := "ngrok" // environment binary.

		if tc.Bin == "" {
			_, err := exec.LookPath(ngrokBin)
			if err != nil {
				ngrokEnvVar, found := os.LookupEnv("NGROK")
				if !found {
					return ErrExec
				}

				ngrokBin = ngrokEnvVar
			}
		} else {
			ngrokBin = tc.Bin
		}

		// if tc.AuthToken != "" {
		// 	cmd := exec.Command(ngrokBin, "config", "add-authtoken", tc.AuthToken)
		// 	err := cmd.Run()
		// 	if err != nil {
		// 		return err
		// 	}
		// }

		// start -none, start without tunnels.
		//  and finally the -log stdout logs to the stdout otherwise the pipe will never be able to read from, spent a lot of time on this lol.
		cmd := exec.Command(ngrokBin, "start", "--none", "--log", "stdout")

		// if tc.Config != "" {
		// 	cmd.Args = append(cmd.Args, []string{"--config", tc.Config}...)
		// }
		if tc.AuthToken != "" {
			cmd.Args = append(cmd.Args, []string{"--authtoken", tc.AuthToken}...)
		}

		if tc.Region != "" {
			cmd.Args = append(cmd.Args, []string{"--region", tc.Region}...)
		}

		// cmd.Stdout = os.Stdout
		// cmd.Stderr = os.Stderr

		stdout, err := cmd.StdoutPipe()
		if err != nil {
			return err
		}

		// stderr, err := cmd.StderrPipe()
		// if err != nil {
		// 	return err
		// }

		if err := cmd.Start(); err != nil {
			return err
		}

		p := make([]byte, 256)
		okText := []byte("client session established")
		for {
			n, err := stdout.Read(p)
			if err != nil {
				// if errors.Is(err, io.EOF) {
				// 	return nil
				// }
				return err
			}

			// we need this one:
			// msg="client session established"
			// note that this will block if something terrible happens
			// but ngrok's errors are strong so the error is easy to be resolved without any logs.
			if bytes.Contains(p[:n], okText) {
				break
			}
		}
	}

	return tc.createTunnel(tunnelAPIRequest, publicAddr)
}

func (tc Configuration) createTunnel(tunnelAPIRequest ngrokTunnel, publicAddr *string) error {
	url := fmt.Sprintf("%s/api/tunnels", tc.WebInterface)
	requestData, err := json.Marshal(tunnelAPIRequest)
	if err != nil {
		return err
	}

	resp, err := tc.Client.Post(url, "application/json", bytes.NewBuffer(requestData))
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	type publicAddrOrErrResp struct {
		PublicAddr string `json:"public_url"`
		Details    struct {
			ErrorText string `json:"err"` // when can't bind more addresses, status code was successful.
		} `json:"details"`
		ErrMsg string `json:"msg"` // when ngrok is not yet ready, status code was unsuccessful.
	}

	var apiResponse publicAddrOrErrResp

	err = json.NewDecoder(resp.Body).Decode(&apiResponse)
	if err != nil {
		return err
	}

	if errText := strings.Join([]string{apiResponse.ErrMsg, apiResponse.Details.ErrorText}, ": "); len(errText) > 2 {
		return errors.New(errText)
	}

	*publicAddr = apiResponse.PublicAddr
	return nil
}

// StopTunnel removes and stops a tunnel from a running ngrok instance.
func (tc Configuration) StopTunnel(t Tunnel) error {
	url := fmt.Sprintf("%s/api/tunnels/%s", tc.WebInterface, t.Name)
	req, err := http.NewRequest(http.MethodDelete, url, nil)
	if err != nil {
		return err
	}

	resp, err := tc.Client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusNoContent {
		return fmt.Errorf("stopTunnel: unexpected status code: %d", resp.StatusCode)
	}

	return nil
}
