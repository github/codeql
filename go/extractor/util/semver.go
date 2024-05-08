package util

import (
	"log"
	"strings"

	"golang.org/x/mod/semver"
)

// A type used to represent values known to be valid semantic versions.
type SemVer interface {
	String() string
	// Compares this semantic version against the `other`. Returns the following values:
	//
	// 0 if both versions are equal.
	//
	// -1 if this version is older than the `other`.
	//
	// 1 if this version is newer than the `other`.
	Compare(other SemVer) int
	// Returns true if this version is newer than the `other`, or false otherwise.
	IsNewerThan(other SemVer) bool
	// Returns true if this version is equal to `other` or newer, or false otherwise.
	IsAtLeast(other SemVer) bool
	// Returns true if this version is older than the `other`, or false otherwise.
	IsOlderThan(other SemVer) bool
	// Returns true if this version is equal to `other` or older, or false otherwise.
	IsAtMost(other SemVer) bool
	// Returns the `major.minor` version prefix of the semantic version. For example, "v1.2.3" becomes "v1.2".
	MajorMinor() SemVer
}

// The internal representation used for values known to be valid semantic versions.
//
// NOTE: Not exported to prevent invalid values from being constructed.
type semVer string

// Converts the semantic version to a string representation.
func (ver semVer) String() string {
	return string(ver)
}

// Represents `v0.0.0`.
func Zero() SemVer {
	return semVer("v0.0.0")
}

// Constructs a [SemVer] from the given `version` string. The input can be any valid version string
// that we commonly deal with. This includes ordinary version strings such as "1.2.3", ones with
// the "go" prefix, and ones with the "v" prefix. Go's non-semver-compliant release candidate
// versions are also automatically corrected from e.g. "go1.20rc1" to "v1.20-rc1". If given
// the empty string, this function return `nil`. Otherwise, for invalid version strings, the function
// prints a message to the log and exits the process.
func NewSemVer(version string) SemVer {
	// If the input is the empty string, return nil f
	if version == "" {
		return nil
	}

	// Drop a "go" prefix, if there is one.
	version = strings.TrimPrefix(version, "go")

	// Go versions don't follow the SemVer format, but the only exception we normally care about
	// is release candidates; so this is a horrible hack to convert e.g. `1.22rc1` into `1.22-rc1`
	// which is compatible with the SemVer specification.
	rcIndex := strings.Index(version, "rc")
	if rcIndex != -1 {
		version = semver.Canonical("v"+version[:rcIndex]) + "-" + version[rcIndex:]
	}

	// Add the "v" prefix that is required by the `semver` package.
	if !strings.HasPrefix(version, "v") {
		version = "v" + version
	}

	// Convert the remaining version string to a canonical semantic version,
	// and check that this was successful.
	canonical := semver.Canonical(version)

	if canonical == "" {
		log.Fatalf("%s is not a valid version string\n", version)
	}

	return semVer(canonical)
}

func (ver semVer) Compare(other SemVer) int {
	return semver.Compare(string(ver), string(other.String()))
}

func (ver semVer) IsNewerThan(other SemVer) bool {
	return ver.Compare(other) > 0
}

func (ver semVer) IsAtLeast(other SemVer) bool {
	return ver.Compare(other) >= 0
}

func (ver semVer) IsOlderThan(other SemVer) bool {
	return ver.Compare(other) < 0
}

func (ver semVer) IsAtMost(other SemVer) bool {
	return ver.Compare(other) <= 0
}

func (ver semVer) MajorMinor() SemVer {
	return semVer(semver.MajorMinor(string(ver)))
}
