package registries

import (
	"os/exec"
	"strings"
	"testing"
)

func parseRegistryConfigsFail(t *testing.T, str string) {
	_, err := parseRegistryConfigs(str)

	if err == nil {
		t.Fatal("Expected `parseRegistryConfigs` to fail, but it succeeded.")
	}
}

func parseRegistryConfigsSuccess(t *testing.T, str string) []RegistryConfig {
	val, err := parseRegistryConfigs(str)

	if err != nil {
		t.Fatalf("Expected `parseRegistryConfigs` to succeed, but it failed: %s", err.Error())
	}

	return val
}

func TestParseRegistryConfigs(t *testing.T) {
	parseRegistryConfigsFail(t, "")

	empty := parseRegistryConfigsSuccess(t, "[]")

	if len(empty) != 0 {
		t.Fatal("Expected `parseRegistryConfigs(\"[]\")` to return no configurations, but got some.")
	}

	single := parseRegistryConfigsSuccess(t, "[{ \"type\": \"goproxy_server\", \"url\": \"https://proxy.example.com/mod\" }]")

	if len(single) != 1 {
		t.Fatalf("Expected `parseRegistryConfigs` to return one configuration, but got %d.", len(single))
	}

	first := single[0]

	if first.Type != "goproxy_server" {
		t.Fatalf("Expected `Type` to be `goproxy_server`, but got `%s`", first.Type)
	}

	if first.URL != "https://proxy.example.com/mod" {
		t.Fatalf("Expected `URL` to be `https://proxy.example.com/mod`, but got `%s`", first.URL)
	}
}

func TestParseRegistryConfigsMultiple(t *testing.T) {
	multiple := parseRegistryConfigsSuccess(t, "[{ \"type\": \"git_source\", \"url\": \"https://github.com/github\" }, { \"type\": \"goproxy_server\", \"url\": \"https://proxy.example.com/mod\" }]")

	if len(multiple) != 2 {
		t.Fatalf("Expected `parseRegistryConfigs` to return two configurations, but got %d.", len(multiple))
	}

	first := multiple[0]

	if first.Type != "git_source" {
		t.Fatalf("Expected `Type` to be `git_source`, but got `%s`", first.Type)
	}

	if first.URL != "https://github.com/github" {
		t.Fatalf("Expected `URL` to be `https://github.com/github`, but got `%s`", first.URL)
	}

	second := multiple[1]

	if second.Type != "goproxy_server" {
		t.Fatalf("Expected `Type` to be `goproxy_server`, but got `%s`", second.Type)
	}

	if second.URL != "https://proxy.example.com/mod" {
		t.Fatalf("Expected `URL` to be `https://proxy.example.com/mod`, but got `%s`", second.URL)
	}
}

func TestParseRegistryConfigsMultipleGitSources(t *testing.T) {
	multiple := parseRegistryConfigsSuccess(t, "[{ \"type\": \"git_source\", \"url\": \"https://github.com/github\" }, { \"type\": \"git_source\", \"url\": \"https://go.googlesource.com/go\" }]")

	if len(multiple) != 2 {
		t.Fatalf("Expected `parseRegistryConfigs` to return two configurations, but got %d.", len(multiple))
	}

	first := multiple[0]

	if first.Type != "git_source" {
		t.Fatalf("Expected `Type` to be `git_source`, but got `%s`", first.Type)
	}

	if first.URL != "https://github.com/github" {
		t.Fatalf("Expected `URL` to be `https://github.com/github`, but got `%s`", first.URL)
	}

	second := multiple[1]

	if second.Type != "git_source" {
		t.Fatalf("Expected `Type` to be `git_source`, but got `%s`", second.Type)
	}

	if second.URL != "https://go.googlesource.com/go" {
		t.Fatalf("Expected `URL` to be `https://go.googlesource.com/go`, but got `%s`", second.URL)
	}
}

func TestParseRegistryConfigsMultipleGoProxyServers(t *testing.T) {
	multiple := parseRegistryConfigsSuccess(t, "[{ \"type\": \"goproxy_server\", \"url\": \"https://proxy.example.com/mod\" }, { \"type\": \"goproxy_server\", \"url\": \"https://goproxy.io\" }]")

	if len(multiple) != 2 {
		t.Fatalf("Expected `parseRegistryConfigs` to return two configurations, but got %d.", len(multiple))
	}

	first := multiple[0]

	if first.Type != "goproxy_server" {
		t.Fatalf("Expected `Type` to be `goproxy_server`, but got `%s`", first.Type)
	}

	if first.URL != "https://proxy.example.com/mod" {
		t.Fatalf("Expected `URL` to be `https://proxy.example.com/mod`, but got `%s`", first.URL)
	}

	second := multiple[1]

	if second.Type != "goproxy_server" {
		t.Fatalf("Expected `Type` to be `goproxy_server`, but got `%s`", second.Type)
	}

	if second.URL != "https://goproxy.io" {
		t.Fatalf("Expected `URL` to be `https://goproxy.io`, but got `%s`", second.URL)
	}
}

func TestApplyProxyEnvVarsPreservesCommandEnvironment(t *testing.T) {
	originalProxyVars := proxy_vars
	originalProxyVarsChecked := proxy_vars_checked
	defer func() {
		proxy_vars = originalProxyVars
		proxy_vars_checked = originalProxyVarsChecked
	}()

	t.Setenv("CODEQL_REGISTRIES_TEST_INHERITED", "inherited")
	proxy_vars = []string{"GOPROXY=https://proxy.example.com"}
	proxy_vars_checked = true

	cmd := Command("go", "version")
	cmd.AppendEnv("GOTOOLCHAIN=local")
	applyProxyEnvVars(cmd.cmd)

	env := make(map[string]string)
	for _, entry := range cmd.cmd.Env {
		key, value, found := strings.Cut(entry, "=")
		if found {
			env[key] = value
		}
	}

	expected := map[string]string{
		"CODEQL_REGISTRIES_TEST_INHERITED": "inherited",
		"GOTOOLCHAIN":                      "local",
		"GOPROXY":                          "https://proxy.example.com",
	}
	for key, value := range expected {
		if env[key] != value {
			t.Errorf("Expected %s=%s, got %q", key, value, env[key])
		}
	}
}

func TestApplyProxyEnvVarsPreservesInheritedEnvironmentWithoutOverrides(t *testing.T) {
	originalProxyVars := proxy_vars
	originalProxyVarsChecked := proxy_vars_checked
	defer func() {
		proxy_vars = originalProxyVars
		proxy_vars_checked = originalProxyVarsChecked
	}()

	t.Setenv("CODEQL_REGISTRIES_TEST_INHERITED", "inherited")
	proxy_vars = []string{"GOPROXY=https://proxy.example.com"}
	proxy_vars_checked = true

	cmd := exec.Command("go", "version")
	applyProxyEnvVars(cmd)

	env := make(map[string]string)
	for _, entry := range cmd.Env {
		key, value, found := strings.Cut(entry, "=")
		if found {
			env[key] = value
		}
	}

	if env["CODEQL_REGISTRIES_TEST_INHERITED"] != "inherited" {
		t.Errorf("Expected inherited environment variable to be preserved, got %q", env["CODEQL_REGISTRIES_TEST_INHERITED"])
	}
}
