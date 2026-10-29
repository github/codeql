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
	// Renders the semantic version as a standard version string, i.e. without a leading "v".
	StandardSemVer() string
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
//
// Note that we deliberately do not format the resulting [SemVer] to be in a `Canonical` representation.
// This is because we want to maintain the input version specificity for as long as possible. This is useful
// for e.g. `IdentifyEnvironment` where we want to output "1.22" if the project specifies "1.22" as the
// required Go version, rather than outputting "1.22.0", which implies a specific patch-level version
// when the intention is that any patch-level version of "1.22" is acceptable.
func NewSemVer(version string) SemVer {
	// If the input is the empty string, return `nil` since we use `nil` to represent "no version".
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
		var numeric string
		prerelease := version[rcIndex:]

		// the version string may already contain a "-";
		// if it does, drop the "-" since we add it back later
		if version[rcIndex-1] != '-' {
			numeric = version[:rcIndex]
		} else {
			numeric = version[:rcIndex-1]
		}

		// add a "v" to the numeric part of the version, if it's not already there
		if !strings.HasPrefix(numeric, "v") {
			numeric = "v" + numeric
		}

		// for the semver library to accept a version containing a prerelease,
		// the numeric part must be canonical; e.g.. "v0-rc1" is not valid and
		// must be "v0.0.0-rc1" instead.
		version = semver.Canonical(numeric) + "-" + prerelease
	} else if !strings.HasPrefix(version, "v") {
		// Add the "v" prefix that is required by the `semver` package, if
		// it's not already there.
		version = "v" + version
	}

	// Check that the remaining version string is valid.
	if !semver.IsValid(version) {
		log.Fatalf("%s is not a valid version string\n", version)
	}

	return semVer(version)
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

func (ver semVer) StandardSemVer() string {
	// Drop the 'v' prefix from the version string.
	result := string(ver)[1:]

	// Correct the pre-release identifier for use with `setup-go`, if one is present.
	// This still remains a standard semantic version.
	return strings.Replace(result, "-rc", "-rc.", 1)
}
