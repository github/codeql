package project

import (
	"path/filepath"
	"testing"

	"golang.org/x/mod/modfile"
)

func testStartsWithAnyOf(t *testing.T, path string, prefix string, expectation bool) {
	result := startsWithAnyOf(path, []string{prefix})
	if result != expectation {
		t.Errorf("Expected startsWithAnyOf(%s, %s) to be %t, but it is %t.", path, prefix, expectation, result)
	}
}

func TestStartsWithAnyOf(t *testing.T) {
	testStartsWithAnyOf(t, ".", ".", true)
	testStartsWithAnyOf(t, ".", "dir", true)
	testStartsWithAnyOf(t, ".", filepath.Join("foo", "bar"), true)
	testStartsWithAnyOf(t, "dir", "dir", true)
	testStartsWithAnyOf(t, "foo", filepath.Join("foo", "bar"), true)
	testStartsWithAnyOf(t, filepath.Join("foo", "bar"), filepath.Join("foo", "bar"), true)
	testStartsWithAnyOf(t, filepath.Join("foo", "bar"), filepath.Join("foo", "bar", "baz"), true)

	testStartsWithAnyOf(t, filepath.Join("foo", "bar"), "foo", false)
	testStartsWithAnyOf(t, filepath.Join("foo", "bar"), "bar", false)
	testStartsWithAnyOf(t, filepath.Join("foo", "bar"), filepath.Join("foo", "baz"), false)
}

func testHasInvalidToolchainVersion(t *testing.T, contents string) bool {
	modFile, err := modfile.Parse("test.go", []byte(contents), nil)

	if err != nil {
		t.Errorf("Unable to parse %s: %s.\n", contents, err.Error())
	}

	return hasInvalidToolchainVersion(modFile)
}

func TestHasInvalidToolchainVersion(t *testing.T) {
	invalid := []string{
		"go 1.21\n",
		"go 1.22\n",
	}

	for _, v := range invalid {
		if !testHasInvalidToolchainVersion(t, v) {
			t.Errorf("Expected testHasInvalidToolchainVersion(\"%s\") to be true, but got false", v)
		}
	}

	valid := []string{
		"go 1.20\n",
		"go 1.21.1\n",
		"go 1.22\n\ntoolchain go1.22.0\n",
	}

	for _, v := range valid {
		if testHasInvalidToolchainVersion(t, v) {
			t.Errorf("Expected testHasInvalidToolchainVersion(\"%s\") to be false, but got true", v)
		}
	}
}
