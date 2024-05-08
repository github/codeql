package toolchain

import (
	"testing"

	"github.com/github/codeql-go/extractor/util"
)

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

func TestHasGoVersion(t *testing.T) {
	versions := []string{"1.21", "v1.22", "1.22.3", "v1.21rc4"}

	// All versions should be unknown.
	for _, version := range versions {
		if HasGoVersion(version) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be false, but got true", version)
		}

		if HasGoVersion(util.FormatSemVer(version)) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be false, but got true", util.FormatSemVer(version))
		}

		if HasGoVersion(util.UnformatSemVer(version)) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be false, but got true", util.UnformatSemVer(version))
		}

		// Add the version in preparation for the next part of the test.
		addGoVersion(version)
	}

	// Now we should have all of the versions.
	for _, version := range versions {
		if !HasGoVersion(version) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be true, but got false", version)
		}

		if !HasGoVersion(util.FormatSemVer(version)) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be true, but got false", util.FormatSemVer(version))
		}

		if !HasGoVersion(util.UnformatSemVer(version)) {
			t.Errorf("Expected HasGoVersion(\"%s\") to be true, but got false", util.UnformatSemVer(version))
		}
	}

}

func testGoVersionToSemVer(t *testing.T, goVersion string, expectedSemVer string) {
	result := GoVersionToSemVer(goVersion)
	if result != expectedSemVer {
		t.Errorf("Expected GoVersionToSemVer(\"%s\") to be %s, but got %s.", goVersion, expectedSemVer, result)
	}
}

func TestGoVersionToSemVer(t *testing.T) {
	testGoVersionToSemVer(t, "1.20", "v1.20.0")
	testGoVersionToSemVer(t, "1.20.1", "v1.20.1")
	testGoVersionToSemVer(t, "1.20rc1", "v1.20.0-rc1")
}

func testToolchainVersionToSemVer(t *testing.T, toolchainVersion string, expectedSemVer string) {
	result := ToolchainVersionToSemVer(toolchainVersion)
	if result != expectedSemVer {
		t.Errorf("Expected ToolchainVersionToSemVer(\"%s\") to be %s, but got %s.", toolchainVersion, expectedSemVer, result)
	}
}

func TestToolchainVersionToSemVer(t *testing.T) {
	testToolchainVersionToSemVer(t, "go1.20", "v1.20.0")
	testToolchainVersionToSemVer(t, "go1.20.1", "v1.20.1")
	testToolchainVersionToSemVer(t, "go1.20rc1", "v1.20.0-rc1")
}
