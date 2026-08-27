package autobuilder

import (
	"fmt"
	"testing"

	"github.com/github/codeql-go/extractor/util"
)

func addMinorVersions(t *testing.T, version util.SemVer, count int) string {
	t.Helper()

	var major, minor int
	if _, err := fmt.Sscanf(version.StandardSemVer(), "%d.%d", &major, &minor); err != nil {
		t.Fatalf("Unable to parse Go version %q: %s", version, err)
	}
	return fmt.Sprintf("%d.%d", major, minor+count)
}

func TestGetVersionToInstall(t *testing.T) {
	type inputVersions struct {
		modVersion string
		envVersion string
	}
	versionAboveMax := addMinorVersions(t, maxGoVersion, 1)
	versionTwoAboveMax := addMinorVersions(t, maxGoVersion, 2)
	tests := map[inputVersions]string{
		// getVersionWhenGoModVersionNotFound()
		{"", ""}:         maxGoVersion.String(),
		{"", "1.2.2"}:    maxGoVersion.String(),
		{"", "9999.0.1"}: maxGoVersion.String(),
		{"", "1.11.13"}:  "",
		{"", "1.20.3"}:   "",

		// getVersionWhenGoModVersionTooHigh()
		{versionAboveMax, ""}:                    versionAboveMax,
		{versionAboveMax, "1.1"}:                 versionAboveMax,
		{versionAboveMax, minGoVersion.String()}: versionAboveMax,
		{versionAboveMax, maxGoVersion.String()}: versionAboveMax,
		{versionTwoAboveMax, versionAboveMax}:    versionTwoAboveMax,
		{versionAboveMax, versionAboveMax}:       "",
		{versionAboveMax, versionTwoAboveMax}:    "",

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
