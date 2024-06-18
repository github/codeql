package project

import (
	"path/filepath"
	"testing"

	"github.com/github/codeql-go/extractor/util"
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

func parseModFile(t *testing.T, contents string) *modfile.File {
	modFile, err := modfile.Parse("go.mod", []byte(contents), nil)

	if err != nil {
		t.Errorf("Unable to parse %s: %s.\n", contents, err.Error())
	}

	return modFile
}

func testHasInvalidToolchainVersion(t *testing.T, contents string) bool {
	return hasInvalidToolchainVersion(parseModFile(t, contents))
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

func parseWorkFile(t *testing.T, contents string) *modfile.WorkFile {
	workFile, err := modfile.ParseWork("go.work", []byte(contents), nil)

	if err != nil {
		t.Errorf("Unable to parse %s: %s.\n", contents, err.Error())
	}

	return workFile
}

func TestRequiredGoVersion(t *testing.T) {
	type ModVersionPair struct {
		FileContents    string
		ExpectedVersion string
	}

	modules := []ModVersionPair{
		{"go 1.20", "v1.20"},
		{"go 1.21.2", "v1.21.2"},
		{"go 1.21rc1", "v1.21.0-rc1"},
		{"go 1.21rc1\ntoolchain go1.22.0", "v1.22.0"},
		{"go 1.21rc1\ntoolchain go1.22rc1", "v1.22.0-rc1"},
	}

	for _, testData := range modules {
		// `go.mod` and `go.work` files have mostly the same format
		modFile := parseModFile(t, testData.FileContents)
		workFile := parseWorkFile(t, testData.FileContents)
		mod := GoModule{
			Path:   "test", // irrelevant
			Module: modFile,
		}
		work := GoWorkspace{
			WorkspaceFile: workFile,
		}

		result := mod.RequiredGoVersion()
		if result == nil {
			t.Errorf(
				"Expected mod.RequiredGoVersion() to return %s for the below `go.mod` file, but got nothing:\n%s",
				testData.ExpectedVersion,
				testData.FileContents,
			)
		} else if result != util.NewSemVer(testData.ExpectedVersion) {
			t.Errorf(
				"Expected mod.RequiredGoVersion() to return %s for the below `go.mod` file, but got %s:\n%s",
				testData.ExpectedVersion,
				result,
				testData.FileContents,
			)
		}

		result = work.RequiredGoVersion()
		if result == nil {
			t.Errorf(
				"Expected mod.RequiredGoVersion() to return %s for the below `go.work` file, but got nothing:\n%s",
				testData.ExpectedVersion,
				testData.FileContents,
			)
		} else if result != util.NewSemVer(testData.ExpectedVersion) {
			t.Errorf(
				"Expected mod.RequiredGoVersion() to return %s for the below `go.work` file, but got %s:\n%s",
				testData.ExpectedVersion,
				result,
				testData.FileContents,
			)
		}
	}

}
