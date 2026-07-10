package main

import "testing"

func TestParsePin(t *testing.T) {
	cases := []struct {
		in      string
		wantNWO string
		wantRef string
		wantOK  bool
	}{
		{"actions/checkout@v4.3.1", "actions/checkout", "v4.3.1", true},
		{"Some-Owner/Pinned-Action@v1.2.0", "some-owner/pinned-action", "v1.2.0", true}, // owner/repo lower-cased, ref preserved
		{"owner/repo@V1.2.0", "owner/repo", "V1.2.0", true},                             // ref casing preserved
		{"owner/repo@sha1-deadbeef", "owner/repo", "sha1-deadbeef", true},               // colon-free ref accepted
		{"owner/repo", "", "", false},                                                   // no @
		{"owner/repo@", "", "", false},                                                  // empty ref
		{"@v1", "", "", false},                                                          // no repo path
		{"owner/repo/sub@v1", "", "", false},                                            // sub-action path rejected
		{"owneronly@v1", "", "", false},                                                 // no slash
		{"owner/repo@ref:with:colon", "", "", false},                                    // colon rejected
	}
	for _, c := range cases {
		nwo, ref, ok := parsePin(c.in)
		if ok != c.wantOK || nwo != c.wantNWO || ref != c.wantRef {
			t.Errorf("parsePin(%q) = (%q, %q, %v), want (%q, %q, %v)",
				c.in, nwo, ref, ok, c.wantNWO, c.wantRef, c.wantOK)
		}
	}
}

func TestParseSemVerAndIsFull(t *testing.T) {
	cases := []struct {
		tag       string
		wantOK    bool
		wantFull  bool
		wantMajor string
		wantMinor string
	}{
		{"v4.3.1", true, true, "v4", "v4.3"},
		{"4.3.1", true, true, "4", "4.3"}, // bare, no "v" prefix
		{"v4", true, false, "v4", "v4.0"},
		{"v4.3", true, false, "v4", "v4.3"},
		{"v2.0.0-beta.1", true, false, "v2", "v2.0"}, // pre-release: not full
		{"main", false, false, "", ""},
		{"0123456789abcdef0123456789abcdef01234567", false, false, "", ""}, // 40-char SHA
	}
	for _, c := range cases {
		sv, ok := parseSemVer(c.tag)
		if ok != c.wantOK {
			t.Errorf("parseSemVer(%q) ok = %v, want %v", c.tag, ok, c.wantOK)
			continue
		}
		if !ok {
			continue
		}
		if got := sv.isFull(); got != c.wantFull {
			t.Errorf("parseSemVer(%q).isFull() = %v, want %v", c.tag, got, c.wantFull)
		}
		if got := sv.majorTag(); got != c.wantMajor {
			t.Errorf("parseSemVer(%q).majorTag() = %q, want %q", c.tag, got, c.wantMajor)
		}
		if got := sv.minorTag(); got != c.wantMinor {
			t.Errorf("parseSemVer(%q).minorTag() = %q, want %q", c.tag, got, c.wantMinor)
		}
	}
}

func TestParseLockfile(t *testing.T) {
	doc, err := parseLockfile([]byte(`version: 'v0.0.2'
workflows:
    '.github/workflows/ci.yml':
        - 'actions/checkout@v4.3.1'
dependencies:
    'actions/checkout@v4.3.1':
        ref: 'v4.3.1'
        commit: 'sha1-abc'
`))
	if err != nil {
		t.Fatalf("parseLockfile: %v", err)
	}
	if doc.Version != "v0.0.2" {
		t.Errorf("version = %q, want v0.0.2", doc.Version)
	}
	keys := doc.Workflows[".github/workflows/ci.yml"]
	if len(keys) != 1 || keys[0] != "actions/checkout@v4.3.1" {
		t.Errorf("workflows entry = %v", keys)
	}
	if dep := doc.Dependencies["actions/checkout@v4.3.1"]; dep.Ref != "v4.3.1" {
		t.Errorf("dependency ref = %q, want v4.3.1", dep.Ref)
	}
}
