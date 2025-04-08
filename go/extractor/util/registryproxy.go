package util

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"os"
	"os/exec"
	"strings"
)

const PROXY_HOST = "CODEQL_PROXY_HOST"
const PROXY_PORT = "CODEQL_PROXY_PORT"
const PROXY_CA_CERTIFICATE = "CODEQL_PROXY_CA_CERTIFICATE"
const PROXY_URLS = "CODEQL_PROXY_URLS"
const GOPROXY_SERVER = "goproxy_server"

type RegistryConfig struct {
	Type string `json:"type"`
	URL  string `json:"url"`
}

var proxy_address string
var proxy_cert_file string
var proxy_configs []RegistryConfig

// Tries to parse the given string value into an array of RegistryConfig values.
func parseRegistryConfigs(str string) ([]RegistryConfig, error) {
	var configs []RegistryConfig
	if err := json.Unmarshal([]byte(str), &configs); err != nil {
		return nil, err
	}

	return configs, nil
}

func checkEnvVars() {
	if proxy_host, proxy_host_set := os.LookupEnv(PROXY_HOST); proxy_host_set {
		if proxy_port, proxy_port_set := os.LookupEnv(PROXY_PORT); proxy_port_set {
			proxy_address = fmt.Sprintf("http://%s:%s", proxy_host, proxy_port)
			slog.Info("Found private registry proxy", slog.String("proxy_address", proxy_address))
		}
	}

	if proxy_cert, proxy_cert_set := os.LookupEnv(PROXY_CA_CERTIFICATE); proxy_cert_set {
		// Write the certificate to a temporary file
		slog.Info("Found certificate")

		f, err := os.CreateTemp("", "codeql-proxy.crt")
		if err != nil {
			slog.Error("Unable to create temporary file for the proxy certificate", slog.String("error", err.Error()))
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
		}
	}

	if proxy_urls, proxy_urls_set := os.LookupEnv(PROXY_URLS); proxy_urls_set {
		val, err := parseRegistryConfigs(proxy_urls)
		if err != nil {
			slog.Error("Unable to parse proxy configurations", slog.String("error", err.Error()))
		} else {
			// We only care about private registry configurations that are relevant to Go and
			// filter others out at this point.
			proxy_configs = make([]RegistryConfig, 0)
			for _, cfg := range val {
				if cfg.Type == GOPROXY_SERVER {
					proxy_configs = append(proxy_configs, cfg)
					slog.Info("Found GOPROXY server", slog.String("url", cfg.URL))
				}
			}
		}
	}
}

// Applies private package proxy related environment variables to `cmd`.
func ApplyProxyEnvVars(cmd *exec.Cmd) {
	slog.Info(
		"Applying private registry proxy environment variables",
		slog.String("cmd_args", strings.Join(cmd.Args, " ")),
	)

	checkEnvVars()

	// Preserve environment variables
	cmd.Env = os.Environ()

	if proxy_address != "" {
		cmd.Env = append(cmd.Env, fmt.Sprintf("HTTP_PROXY=%s", proxy_address))
		cmd.Env = append(cmd.Env, fmt.Sprintf("HTTPS_PROXY=%s", proxy_address))
	}
	if proxy_cert_file != "" {
		slog.Info("Setting SSL_CERT_FILE", slog.String("proxy_cert_file", proxy_cert_file))
		cmd.Env = append(cmd.Env, fmt.Sprintf("SSL_CERT_FILE=%s", proxy_cert_file))
	}

	if len(proxy_configs) > 0 {
		goproxy_val := "https://proxy.golang.org,direct"

		for _, cfg := range proxy_configs {
			goproxy_val = cfg.URL + "," + goproxy_val
		}

		cmd.Env = append(cmd.Env, fmt.Sprintf("GOPROXY=%s", goproxy_val))
		cmd.Env = append(cmd.Env, "GOPRIVATE=")
		cmd.Env = append(cmd.Env, "GONOPROXY=")
	}
}
