package main

import (
	"fmt"
	"regexp"
	"strconv"
	"strings"

	"gopkg.in/yaml.v3"
)

// lockfilePath is the repo-relative location of the GitHub Actions lockfile.
const lockfilePath = ".github/workflows/actions.lock"

// lockfileDoc is the subset of the Actions lockfile (schema v0.0.2) that the
// generator needs: the per-workflow flat list of canonical pin keys, and the
// resolved ref recorded for each dependency.
//
// The full format is owned by `github.com/github/actions-lockfile`. We parse it
// directly here rather than depending on that (currently private) module so the
// generator builds anywhere the Go toolchain is available, with no module-proxy
// access to a private repository. The fields we read are a stable, minimal core
// of the format; see the schema in that repository for the authoritative shape.
type lockfileDoc struct {
	Version      string                        `yaml:"version"`
	Workflows    map[string][]string           `yaml:"workflows"`
	Dependencies map[string]lockfileDependency `yaml:"dependencies"`
}

type lockfileDependency struct {
	Ref    string `yaml:"ref"`
	Commit string `yaml:"commit"`
}

func parseLockfile(contents []byte) (*lockfileDoc, error) {
	var doc lockfileDoc
	if err := yaml.Unmarshal(contents, &doc); err != nil {
		return nil, fmt.Errorf("parsing lockfile YAML: %w", err)
	}
	return &doc, nil
}

// parsePin parses a canonical lockfile pin key of the form "OWNER/REPO@REF".
//
// It mirrors `lockfile.ParsePin`: the "@" separates repo from ref, the repo
// portion must contain exactly one "/", owner and repo are lower-cased (git
// forges treat them case-insensitively) while the ref preserves its casing, and
// a ref may not be empty or contain a colon. Sub-action paths
// ("owner/repo/sub@ref") are rejected because the lockfile pins at repo+ref
// granularity. Returns ok=false for anything that does not match.
func parsePin(s string) (nwo, ref string, ok bool) {
	atIdx := strings.IndexByte(s, '@')
	if atIdx <= 0 || atIdx == len(s)-1 {
		return "", "", false
	}
	repoPath := s[:atIdx]
	ref = s[atIdx+1:]

	if strings.Count(repoPath, "/") != 1 {
		return "", "", false
	}
	slashIdx := strings.IndexByte(repoPath, '/')
	owner := repoPath[:slashIdx]
	repo := repoPath[slashIdx+1:]
	if owner == "" || repo == "" {
		return "", "", false
	}
	if ref == "" || strings.Contains(ref, ":") {
		return "", "", false
	}
	nwo = strings.ToLower(owner) + "/" + strings.ToLower(repo)
	return nwo, ref, true
}

// semVer holds the parsed components of a semver-ish Actions tag. The scheme is
// deliberately lax (bare "2.0.0", partial "v4"/"v4.2", arbitrary suffixes all
// appear in the wild), matching `lockfile.SemVer`.
type semVer struct {
	prefix string
	major  int
	minor  int
	patch  int
	rest   string
	raw    string
}

var versionRE = regexp.MustCompile(`^(v?)(\d+)(?:\.(\d+))?(?:\.(\d+))?(.*)$`)

func parseSemVer(tag string) (semVer, bool) {
	if isFullSha(tag) {
		return semVer{}, false
	}
	m := versionRE.FindStringSubmatch(tag)
	if m == nil {
		return semVer{}, false
	}
	major, err := strconv.Atoi(m[2])
	if err != nil {
		return semVer{}, false
	}
	minor := 0
	if m[3] != "" {
		if minor, err = strconv.Atoi(m[3]); err != nil {
			return semVer{}, false
		}
	}
	patch := 0
	if m[4] != "" {
		if patch, err = strconv.Atoi(m[4]); err != nil {
			return semVer{}, false
		}
	}
	return semVer{prefix: m[1], major: major, minor: minor, patch: patch, rest: m[5], raw: tag}, true
}

func (s semVer) majorTag() string { return fmt.Sprintf("%s%d", s.prefix, s.major) }

func (s semVer) minorTag() string { return fmt.Sprintf("%s%d.%d", s.prefix, s.major, s.minor) }

// isFull reports whether the tag has all three components (major.minor.patch)
// and no pre-release suffix. Tags like "v4" or "v4.2" return false. Only a full
// version uniquely identifies a release, so only full versions get expanded
// into their shorter mutable forms.
func (s semVer) isFull() bool {
	return s.rest == "" && s.raw != s.majorTag() && s.raw != s.minorTag()
}

// isFullSha reports whether s looks like a full commit hash (SHA-1 or SHA-256),
// which must not be treated as a version tag.
func isFullSha(s string) bool {
	if len(s) != 40 && len(s) != 64 {
		return false
	}
	for _, c := range s {
		if !((c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')) {
			return false
		}
	}
	return true
}
