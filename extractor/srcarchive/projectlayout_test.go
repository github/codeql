package srcarchive

import (
	"io/ioutil"
	"os"
	"testing"
)

func mkProjectLayout(projectLayoutSource string, t *testing.T) (*ProjectLayout, error) {
	pt, err := ioutil.TempFile("", "path-transformer")
	if err != nil {
		t.Fatalf("Unable to create temporary file for project layout: %s", err.Error())
	}
	defer os.Remove(pt.Name())
	_, err = pt.WriteString(projectLayoutSource)
	if err != nil {
		t.Fatalf("Unable to write to temporary file for project layout: %s", err.Error())
	}
	err = pt.Close()
	if err != nil {
		t.Fatalf("Unable to close path transformer file: %s.", err.Error())
	}

	pt, err = os.Open(pt.Name())
	if err != nil {
		t.Fatalf("Unable to open path transformer file: %s.", err.Error())
	}

	return LoadProjectLayout(pt)
}

func testTransformation(projectLayout *ProjectLayout, t *testing.T, path string, expected string) {
	actual := projectLayout.Transform(path)
	if actual != expected {
		t.Errorf("Expected %s to be transformed to %s, but got %s", path, expected, actual)
	}
}

func TestValidProjectLayout(t *testing.T) {
	p, err := mkProjectLayout(`
# /opt/src
/opt/src/root/src/org/repo//
`, t)

	if err != nil {
		t.Fatalf("Error loading project layout: %s", err.Error())
	}

	testTransformation(p, t, "/opt/src/root/src/org/repo", "/opt/src")
	testTransformation(p, t, "/opt/src/root/src/org/repo/", "/opt/src/")
	testTransformation(p, t, "/opt/src/root/src/org/repo/main.go", "/opt/src/main.go")
	testTransformation(p, t, "/opt/not/in/src", "/opt/not/in/src")
	testTransformation(p, t, "/opt/src/root/srcorg/repo", "/opt/src/root/srcorg/repo")
	testTransformation(p, t, "opt/src/root/src/org/repo", "opt/src/root/src/org/repo")
}

func TestWindowsPaths(t *testing.T) {
	p, err := mkProjectLayout(`
# /c:/virtual
/d://
`, t)

	if err != nil {
		t.Fatalf("Error loading project layout: %s", err.Error())
	}

	testTransformation(p, t, "d:/foo", "c:/virtual/foo")
}

func TestWindowsToUnixPaths(t *testing.T) {
	p, err := mkProjectLayout(`
# /opt/src
/d://
`, t)

	if err != nil {
		t.Fatalf("Error loading project layout: %s", err.Error())
	}

	testTransformation(p, t, "d:/foo", "/opt/src/foo")
}

func TestEmptyProjectLayout(t *testing.T) {
	_, err := mkProjectLayout("", t)
	if err == nil {
		t.Error("Expected error on empty project layout")
	}
}

func TestEmptyProjectLayout2(t *testing.T) {
	_, err := mkProjectLayout(`
	`, t)
	if err == nil {
		t.Error("Expected error on empty project layout")
	}
}

func TestExclusion(t *testing.T) {
	_, err := mkProjectLayout(`
# /opt/src
-/foo//
`, t)
	if err == nil {
		t.Error("Expected error on exclusion")
	}
}

func TestStar(t *testing.T) {
	_, err := mkProjectLayout(`
# /opt/src
/foo/**/bar//
`, t)
	if err == nil {
		t.Error("Expected error on star")
	}
}

func TestDoubleSlash(t *testing.T) {
	_, err := mkProjectLayout(`
# /opt/src
/foo//bar//
`, t)
	if err == nil {
		t.Error("Expected error on multiple double slashes")
	}
}

func TestInternalDoubleSlash(t *testing.T) {
	_, err := mkProjectLayout(`
# /opt/src
/foo//bar
`, t)
	if err == nil {
		t.Error("Expected error on internal double slash")
	}
}
