package extractor

import (
	"go/ast"
	"testing"

	"golang.org/x/tools/go/packages"
)

func TestIsExactTestPackage(t *testing.T) {
	tests := []struct {
		name     string
		pkgID    string
		pkgPath  string
		expected bool
	}{
		{
			name:     "exact test package",
			pkgID:    "github.com/foo/bar [github.com/foo/bar.test]",
			pkgPath:  "github.com/foo/bar",
			expected: true,
		},
		{
			name:     "nested test package",
			pkgID:    "github.com/foo/bar [github.com/foo/bar/nested.test]",
			pkgPath:  "github.com/foo/bar",
			expected: false,
		},
		{
			name:     "deeply nested test package",
			pkgID:    "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6/plumbing/format/packfile.test]",
			pkgPath:  "github.com/go-git/go-git/v6",
			expected: false,
		},
		{
			name:     "exact test package with version",
			pkgID:    "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6.test]",
			pkgPath:  "github.com/go-git/go-git/v6",
			expected: true,
		},
		{
			name:     "non-test package",
			pkgID:    "github.com/foo/bar",
			pkgPath:  "github.com/foo/bar",
			expected: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			pkg := &packages.Package{
				ID:      tt.pkgID,
				PkgPath: tt.pkgPath,
			}
			result := isExactTestPackage(pkg)
			if result != tt.expected {
				t.Errorf("isExactTestPackage(%q) = %v, want %v", tt.pkgID, result, tt.expected)
			}
		})
	}
}

func TestIsBetterPackage(t *testing.T) {
	// Helper to create a package with specified properties
	makePkg := func(id, path string, syntaxCount int) *packages.Package {
		syntax := make([]*ast.File, syntaxCount)
		return &packages.Package{
			ID:      id,
			PkgPath: path,
			Syntax:  syntax,
		}
	}

	tests := []struct {
		name     string
		pkg      *packages.Package
		current  *packages.Package
		expected bool // true if pkg is better than current
	}{
		{
			name: "exact test package beats nested test package",
			pkg: makePkg(
				"github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6.test]",
				"github.com/go-git/go-git/v6",
				39, // 19 production + 20 test files
			),
			current: makePkg(
				"github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6/plumbing/format/packfile.test]",
				"github.com/go-git/go-git/v6",
				19, // production files only
			),
			expected: true,
		},
		{
			name: "nested test package loses to exact test package",
			pkg: makePkg(
				"github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6/plumbing/format/packfile.test]",
				"github.com/go-git/go-git/v6",
				19,
			),
			current: makePkg(
				"github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6.test]",
				"github.com/go-git/go-git/v6",
				39,
			),
			expected: false,
		},
		{
			name: "more syntax nodes wins when both are exact tests",
			pkg: makePkg(
				"github.com/foo/bar [github.com/foo/bar.test]",
				"github.com/foo/bar",
				50,
			),
			current: makePkg(
				"github.com/foo/bar [github.com/foo/bar.test]",
				"github.com/foo/bar",
				30,
			),
			expected: true,
		},
		{
			name: "fewer syntax nodes loses when both are exact tests",
			pkg: makePkg(
				"github.com/foo/bar [github.com/foo/bar.test]",
				"github.com/foo/bar",
				30,
			),
			current: makePkg(
				"github.com/foo/bar [github.com/foo/bar.test]",
				"github.com/foo/bar",
				50,
			),
			expected: false,
		},
		{
			name: "more syntax nodes wins when both are nested tests",
			pkg: makePkg(
				"github.com/foo/bar [github.com/foo/bar/pkg1.test]",
				"github.com/foo/bar",
				25,
			),
			current: makePkg(
				"github.com/foo/bar [github.com/foo/bar/pkg2.test]",
				"github.com/foo/bar",
				20,
			),
			expected: true,
		},
		{
			name: "longer ID wins when same syntax count",
			pkg: makePkg(
				"github.com/foo/bar [github.com/foo/bar/verylongpackagename.test]",
				"github.com/foo/bar",
				20,
			),
			current: makePkg(
				"github.com/foo/bar [github.com/foo/bar/short.test]",
				"github.com/foo/bar",
				20,
			),
			expected: true,
		},
		{
			name: "test package beats non-test with same syntax count",
			pkg: makePkg(
				"github.com/foo/bar [github.com/foo/bar.test]",
				"github.com/foo/bar",
				20,
			),
			current: makePkg(
				"github.com/foo/bar",
				"github.com/foo/bar",
				20,
			),
			expected: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := isBetterPackage(tt.pkg, tt.current)
			if result != tt.expected {
				t.Errorf("isBetterPackage() = %v, want %v\n  pkg:     %q (%d syntax nodes)\n  current: %q (%d syntax nodes)",
					result, tt.expected,
					tt.pkg.ID, len(tt.pkg.Syntax),
					tt.current.ID, len(tt.current.Syntax))
			}
		})
	}
}

// TestPackageSelectionRealWorld simulates the real-world go-git scenario
func TestPackageSelectionRealWorld(t *testing.T) {
	// Simulate the actual packages.Load result for go-git repository
	// when EXTRACT_TESTS=true
	pkgs := []*packages.Package{
		// Production package only
		{
			ID:      "github.com/go-git/go-git/v6",
			PkgPath: "github.com/go-git/go-git/v6",
			Syntax:  make([]*ast.File, 19), // 19 production files
		},
		// Root test package - this is what we want!
		{
			ID:      "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6.test]",
			PkgPath: "github.com/go-git/go-git/v6",
			Syntax:  make([]*ast.File, 39), // 19 production + 20 test files
		},
		// Nested test dependency 1
		{
			ID:      "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6/plumbing/format/packfile.test]",
			PkgPath: "github.com/go-git/go-git/v6",
			Syntax:  make([]*ast.File, 19), // production files only (dependency)
		},
		// Nested test dependency 2
		{
			ID:      "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6/plumbing/object.test]",
			PkgPath: "github.com/go-git/go-git/v6",
			Syntax:  make([]*ast.File, 19), // production files only (dependency)
		},
	}

	// Simulate the bestPackageIds selection logic
	bestPackageIds := make(map[string]*packages.Package)
	for _, pkg := range pkgs {
		if bestSoFar, present := bestPackageIds[pkg.PkgPath]; present {
			if isBetterPackage(pkg, bestSoFar) {
				bestPackageIds[pkg.PkgPath] = pkg
			}
		} else {
			bestPackageIds[pkg.PkgPath] = pkg
		}
	}

	// Verify the correct package was selected
	selected := bestPackageIds["github.com/go-git/go-git/v6"]
	expectedID := "github.com/go-git/go-git/v6 [github.com/go-git/go-git/v6.test]"
	expectedSyntaxCount := 39

	if selected.ID != expectedID {
		t.Errorf("Wrong package selected!\n  got:  %q (%d syntax nodes)\n  want: %q (%d syntax nodes)",
			selected.ID, len(selected.Syntax),
			expectedID, expectedSyntaxCount)
	}

	if len(selected.Syntax) != expectedSyntaxCount {
		t.Errorf("Wrong syntax count: got %d, want %d", len(selected.Syntax), expectedSyntaxCount)
	}

	// Verify it's recognized as an exact test package
	if !isExactTestPackage(selected) {
		t.Errorf("Selected package %q should be recognized as exact test package", selected.ID)
	}
}
