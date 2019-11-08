package main

import "testing"

func TestGetImportPathFromRepoURL(t *testing.T) {
	tests := map[string]string{
		"git@github.com:Semmle/go.git":       "github.com/Semmle/go",
		"git@github.com:Semmle/go":           "github.com/Semmle/go",
		"https://github.com/Semmle/go.git":   "github.com/Semmle/go",
		"https://github.com:12345/Semmle/go": "github.com/Semmle/go",
		"gitolite@some.url:some/repo":        "some.url/some/repo",
	}
	for input, expected := range tests {
		actual := getImportPathFromRepoURL(input)
		if actual != expected {
			t.Errorf("Expected getImportPathFromRepoURL(\"%s\") to be \"%s\", but got \"%s\".", input, expected, actual)
		}
	}
}
