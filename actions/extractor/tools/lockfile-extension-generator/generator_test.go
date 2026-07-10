package main

import (
	"os"
	"testing"
)

func TestRowsFromLockfile(t *testing.T) {
	contents, err := os.ReadFile("testdata/actions.lock")
	if err != nil {
		t.Fatalf("reading fixture: %v", err)
	}

	rows, err := rowsFromLockfile(contents)
	if err != nil {
		t.Fatalf("rowsFromLockfile: %v", err)
	}

	// Every full-semver resolved ref expands to {raw, minor, major} so a
	// workflow that writes a shorter tag in `uses:` still matches. Rows are
	// sorted by (workflowPath, nwo, ref).
	want := []row{
		{".github/workflows/ci.yml", "actions/checkout", "v4"},
		{".github/workflows/ci.yml", "actions/checkout", "v4.3"},
		{".github/workflows/ci.yml", "actions/checkout", "v4.3.1"},
		{".github/workflows/ci.yml", "some-owner/pinned-action", "v1"},
		{".github/workflows/ci.yml", "some-owner/pinned-action", "v1.2"},
		{".github/workflows/ci.yml", "some-owner/pinned-action", "v1.2.0"},
		{".github/workflows/release.yml", "actions/checkout", "v4"},
		{".github/workflows/release.yml", "actions/checkout", "v4.3"},
		{".github/workflows/release.yml", "actions/checkout", "v4.3.1"},
	}

	if len(rows) != len(want) {
		t.Fatalf("got %d rows, want %d:\n%#v", len(rows), len(want), rows)
	}
	for i := range want {
		if rows[i] != want[i] {
			t.Errorf("row %d: got %+v, want %+v", i, rows[i], want[i])
		}
	}
}

func TestRefVariants(t *testing.T) {
	cases := []struct {
		ref  string
		want []string
	}{
		{"v4.3.1", []string{"v4.3.1", "v4.3", "v4"}},
		{"v1.0.0", []string{"v1.0.0", "v1.0", "v1"}},
		// Partial tags are already their own broadest form.
		{"v4", []string{"v4"}},
		{"v4.3", []string{"v4.3"}},
		// Pre-release and non-semver refs pass through untouched.
		{"v2.0.0-beta.1", []string{"v2.0.0-beta.1"}},
		{"main", []string{"main"}},
	}
	for _, c := range cases {
		got := refVariants(c.ref)
		if len(got) != len(c.want) {
			t.Errorf("refVariants(%q) = %v, want %v", c.ref, got, c.want)
			continue
		}
		for i := range c.want {
			if got[i] != c.want[i] {
				t.Errorf("refVariants(%q) = %v, want %v", c.ref, got, c.want)
				break
			}
		}
	}
}

func TestRenderExtensionMatchesGolden(t *testing.T) {
	contents, err := os.ReadFile("testdata/actions.lock")
	if err != nil {
		t.Fatalf("reading fixture: %v", err)
	}
	rows, err := rowsFromLockfile(contents)
	if err != nil {
		t.Fatalf("rowsFromLockfile: %v", err)
	}
	got := renderExtension(rows)

	want, err := os.ReadFile("testdata/expected.yml")
	if err != nil {
		t.Fatalf("reading golden: %v", err)
	}
	if got != string(want) {
		t.Errorf("rendered extension does not match testdata/expected.yml:\n--- got ---\n%s", got)
	}
}
