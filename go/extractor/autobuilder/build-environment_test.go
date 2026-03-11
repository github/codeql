package autobuilder

import (
	"testing"

	"github.com/github/codeql-go/extractor/util"
)

func TestGetVersionToInstall(t *testing.T) {
	type inputVersions struct {
		modVersion string
		envVersion string
	}
	tests := map[inputVersions]string{
		// getVersionWhenGoModVersionNotFound()
		{"", ""}:         goVersionToInstall.String(),
		{"", "1.2.2"}:    goVersionToInstall.String(),
		{"", "9999.0.1"}: goVersionToInstall.String(),
		{"", "1.11.13"}:  "",
		{"", "1.20.3"}:   "",

		// getVersionWhenGoModVersionTooHigh()
		{"9999.0", ""}:                          goVersionToInstall.String(),
		{"9999.0", "9999.0.1"}:                  "",
		{"9999.0", "1.1"}:                       goVersionToInstall.String(),
		{"9999.0", minGoVersion.String()}:       goVersionToInstall.String(),
		{"9999.0", goVersionToInstall.String()}: "",

		// getVersionWhenGoModVersionTooLow()
		{"0.0", ""}:       minGoVersion.String(),
		{"0.0", "9999.0"}: minGoVersion.String(),
		{"0.0", "1.2.2"}:  minGoVersion.String(),
		{"0.0", "1.20.3"}: "",

		// getVersionWhenGoModVersionSupported()
		{"1.20", ""}:         "1.20",
		{"1.11", ""}:         "1.11",
		{"1.20", "1.2.2"}:    "1.20",
		{"1.11", "1.2.2"}:    "1.11",
		{"1.20", "9999.0.1"}: "1.20",
		{"1.11", "9999.0.1"}: "1.11",
		// go.mod version > go installation version
		{"1.20", "1.11.13"}: "1.20",
		{"1.20", "1.12"}:    "1.20",
		// go.mod version <= go installation version (Note comparisons ignore the patch version)
		{"1.11", "1.20"}:   "",
		{"1.11", "1.20.3"}: "",
		{"1.20", "1.20.3"}: "",
	}
	for input, expected := range tests {
		_, actual := getVersionToInstall(versionInfo{util.NewSemVer(input.modVersion), util.NewSemVer(input.envVersion)})
		if actual != util.NewSemVer(expected) {
			t.Errorf("Expected getVersionToInstall(\"%s\") to be \"%s\", but got \"%s\".", input, expected, actual)
		}
	}
}

func TestMaxGoVersions(t *testing.T) {
	if goVersionToInstall.IsNewerThan(maxGoVersion) {
		t.Errorf("goVersionToInstall (%s) should not be newer than maxGoVersion (%s).", goVersionToInstall, maxGoVersion)
	}
}
