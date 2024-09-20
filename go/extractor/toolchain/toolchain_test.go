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
	if HasGoVersion(util.NewSemVer("1.21")) {
		t.Error("Expected HasGoVersion(\"1.21\") to be false, but got true")
	}
}
