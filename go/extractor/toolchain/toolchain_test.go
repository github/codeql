package toolchain

import "testing"

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
	if HasGoVersion("1.21") {
		t.Error("Expected HasGoVersion(\"1.21\") to be false, but got true")
	}
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
