package project

import (
	"path/filepath"
	"testing"
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
