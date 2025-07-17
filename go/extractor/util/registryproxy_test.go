package util

import (
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
