package main

import "testing"

func TestGetImportPathFromRepoURL(t *testing.T) {
	tests := map[string]string{
		"git@github.com:github/codeql-go.git":       "github.com/github/codeql-go",
		"git@github.com:github/codeql-go":           "github.com/github/codeql-go",
		"https://github.com/github/codeql-go.git":   "github.com/github/codeql-go",
		"https://github.com:12345/github/codeql-go": "github.com/github/codeql-go",
		"gitolite@some.url:some/repo":               "some.url/some/repo",
		"file:///C:/some/path":                      "",
		"https:///no/hostname":                      "",
		"https://hostnameonly":                      "",
	}
	for input, expected := range tests {
		actual := getImportPathFromRepoURL(input)
		if actual != expected {
			t.Errorf("Expected getImportPathFromRepoURL(\"%s\") to be \"%s\", but got \"%s\".", input, expected, actual)
		}
	}
}

func TestParseGoVersion(t *testing.T) {
	tests := map[string]string{
		"go version go1.18.9 linux/amd64": "go1.18.9",
		"warning: GOPATH set to GOROOT (/usr/local/go) has no effect\ngo version go1.18.9 linux/amd64": "go1.18.9",
	}
	for input, expected := range tests {
		actual := parseGoVersion(input)
		if actual != expected {
			t.Errorf("Expected parseGoVersion(\"%s\") to be \"%s\", but got \"%s\".", input, expected, actual)
		}
	}
}

func TestGetVersionToInstall(t *testing.T) {
	tests := map[versionInfo]string{
		// getVersionWhenGoModVersionNotFound()
		{"", false, "", false}:        maxGoVersion,
		{"", false, "1.2.2", true}:    maxGoVersion,
		{"", false, "9999.0.1", true}: maxGoVersion,
		{"", false, "1.11.13", true}:  "",
		{"", false, "1.20.3", true}:   "",

		// getVersionWhenGoModVersionTooHigh()
		{"9999.0", true, "", false}:           maxGoVersion,
		{"9999.0", true, "9999.0.1", true}:    "",
		{"9999.0", true, "1.1", true}:         maxGoVersion,
		{"9999.0", true, minGoVersion, false}: maxGoVersion,
		{"9999.0", true, maxGoVersion, true}:  "",

		// getVersionWhenGoModVersionTooLow()
		{"0.0", true, "", false}:      minGoVersion,
		{"0.0", true, "9999.0", true}: minGoVersion,
		{"0.0", true, "1.2.2", true}:  minGoVersion,
		{"0.0", true, "1.20.3", true}: "",

		// getVersionWhenGoModVersionSupported()
		{"1.20", true, "", false}:        "1.20",
		{"1.11", true, "", false}:        "1.11",
		{"1.20", true, "1.2.2", true}:    "1.20",
		{"1.11", true, "1.2.2", true}:    "1.11",
		{"1.20", true, "9999.0.1", true}: "1.20",
		{"1.11", true, "9999.0.1", true}: "1.11",
		// go.mod version > go installation version
		{"1.20", true, "1.11.13", true}: "1.20",
		{"1.20", true, "1.12", true}:    "1.20",
		// go.mod version <= go installation version (Note comparisons ignore the patch version)
		{"1.11", true, "1.20", true}:   "",
		{"1.11", true, "1.20.3", true}: "",
		{"1.20", true, "1.20.3", true}: "",
	}
	for input, expected := range tests {
		_, actual := getVersionToInstall(input)
		if actual != expected {
			t.Errorf("Expected getVersionToInstall(\"%s\") to be \"%s\", but got \"%s\".", input, expected, actual)
		}
	}
}
