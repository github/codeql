package tree_sitter_tsg_python_test

import (
	"testing"

	tree_sitter "github.com/smacker/go-tree-sitter"
	"github.com/tree-sitter/tree-sitter-tsg_python"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_tsg_python.Language())
	if language == nil {
		t.Errorf("Error loading TsgPython grammar")
	}
}
