package util

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"net/url"
	"os"
	"os/exec"
	"strings"
)

const PROXY_HOST = "CODEQL_PROXY_HOST"
const PROXY_PORT = "CODEQL_PROXY_PORT"
const PROXY_CA_CERTIFICATE = "CODEQL_PROXY_CA_CERTIFICATE"
const PROXY_URLS = "CODEQL_PROXY_URLS"
const GOPROXY_SERVER = "goproxy_server"
const GIT_SOURCE = "git_source"

type RegistryConfig struct {
	Type string `json:"type"`
	URL  string `json:"url"`
}

// The address of the proxy including protocol and port (e.g. http://localhost:1234)
var proxy_address string

// The path to the temporary file that stores the proxy certificate, if any.
var proxy_cert_file string

// An array of goproxy server URLs.
var goproxy_servers []string

// An array of Git URLs.
var git_sources []string

// Stores the environment variables that we wish to pass on to `go` commands.
var proxy_vars []string = nil

// Keeps track of whether we have inspected the proxy environment variables.
// Needed since `proxy_vars` may be nil either way.
var proxy_vars_checked bool = false

// Tries to parse the given string value into an array of RegistryConfig values.
func parseRegistryConfigs(str string) ([]RegistryConfig, error) {
	var configs []RegistryConfig
	if err := json.Unmarshal([]byte(str), &configs); err != nil {
		return nil, err
	}

	return configs, nil
}

func getEnvVars() []string {
	var result []string

	if proxy_host, proxy_host_set := os.LookupEnv(PROXY_HOST); proxy_host_set && proxy_host != "" {
		if proxy_port, proxy_port_set := os.LookupEnv(PROXY_PORT); proxy_port_set && proxy_port != "" {
			proxy_address = fmt.Sprintf("http://%s:%s", proxy_host, proxy_port)
			result = append(
				result,
				fmt.Sprintf("HTTP_PROXY=%s", proxy_address),
				fmt.Sprintf("HTTPS_PROXY=%s", proxy_address),
				fmt.Sprintf("http_proxy=%s", proxy_address),
				fmt.Sprintf("https_proxy=%s", proxy_address),
			)

			slog.Info("Found private registry proxy", slog.String("proxy_address", proxy_address))
		}
	}

	if proxy_cert, proxy_cert_set := os.LookupEnv(PROXY_CA_CERTIFICATE); proxy_cert_set && proxy_cert != "" {
		// Write the certificate to a temporary file
		slog.Info("Found certificate")

		f, err := os.CreateTemp("", "codeql-proxy.crt")
		if err != nil {
			slog.Error("Failed to create temporary file for the proxy certificate", slog.String("error", err.Error()))
		}

		_, err = f.WriteString(proxy_cert)
		if err != nil {
			slog.Error("Failed to write to the temporary certificate file", slog.String("error", err.Error()))
		}

		err = f.Close()
		if err != nil {
			slog.Error("Failed to close the temporary certificate file", slog.String("error", err.Error()))
		} else {
			proxy_cert_file = f.Name()
			result = append(result, fmt.Sprintf("SSL_CERT_FILE=%s", proxy_cert_file))
		}
	}

	if proxy_urls, proxy_urls_set := os.LookupEnv(PROXY_URLS); proxy_urls_set && proxy_urls != "" {
		val, err := parseRegistryConfigs(proxy_urls)
		if err != nil {
			slog.Error("Unable to parse proxy configurations", slog.String("error", err.Error()))
		} else {
			// We only care about private registry configurations that are relevant to Go and
			// filter others out at this point.
			for _, cfg := range val {
				if cfg.Type == GOPROXY_SERVER {
					goproxy_servers = append(goproxy_servers, cfg.URL)
					slog.Info("Found GOPROXY server", slog.String("url", cfg.URL))
				} else if cfg.Type == GIT_SOURCE {
					parsed, err := url.Parse(cfg.URL)
					if err == nil && parsed.Hostname() != "" {
						git_source := parsed.Hostname() + parsed.Path + "*"
						git_sources = append(git_sources, git_source)
						slog.Info("Found Git source", slog.String("source", git_source))
					} else {
						slog.Warn("Not a valid URL for Git source", slog.String("url", cfg.URL))
					}
				}
			}

			goprivate := []string{}

			if len(goproxy_servers) > 0 {
				goproxy_val := "https://proxy.golang.org,direct"

				for _, url := range goproxy_servers {
					goproxy_val = url + "," + goproxy_val
				}

				result = append(result, fmt.Sprintf("GOPROXY=%s", goproxy_val), "GONOPROXY=")
			}

			if len(git_sources) > 0 {
				goprivate = append(goprivate, git_sources...)

				if proxy_cert_file != "" {
					slog.Info("Configuring `git` to use proxy certificate", slog.String("path", proxy_cert_file))
					cmd := exec.Command("git", "config", "--global", "http.sslCAInfo", proxy_cert_file)

					out, cmdErr := cmd.CombinedOutput()
					slog.Info(string(out))

					if cmdErr != nil {
						slog.Error("Failed to configure `git` to accept the certificate file", slog.String("error", cmdErr.Error()))
					}
				}
			}

			result = append(result, fmt.Sprintf("GOPRIVATE=%s", strings.Join(goprivate, ",")))
		}
	}

	return result
}

// Applies private package proxy related environment variables to `cmd`.
func ApplyProxyEnvVars(cmd *exec.Cmd) {
	// If we haven't done so yet, check whether the proxy environment variables are set
	// and extract information from them.
	if !proxy_vars_checked {
		proxy_vars = getEnvVars()
		proxy_vars_checked = true
	}

	// If the proxy is configured, `proxy_vars` will be not `nil`. We append those
	// variables to the existing environment to preserve those environment variables.
	// If `cmd.Env` is not changed, then the existing environment is also preserved.
	if proxy_vars != nil {
		cmd.Env = append(os.Environ(), proxy_vars...)
	}

	slog.Debug(
		"Applying private registry proxy environment variables",
		slog.String("cmd_args", strings.Join(cmd.Args, " ")),
		slog.String("proxy_vars", strings.Join(proxy_vars, ",")),
	)
}
