package srcarchive

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strings"

	"github.com/github/codeql-go/extractor/util"
)

// ProjectLayout describes a very simple project layout rewriting paths starting
// with `from` to start with `to` instead.
//
// We currently only support project layouts of the form:
//
//	# to
//	from//
type ProjectLayout struct {
	From, To string
}

// normaliseSlashes adds an initial slash to `path` if there isn't one, and trims
// a final slash if there is one
func normaliseSlashes(path string) string {
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return strings.TrimSuffix(path, "/")
}

// LoadProjectLayoutFromEnv loads a project layout from the file referenced by the
// {CODEQL,SEMMLE}_PATH_TRANSFORMER environment variable. If neither env var is set, returns nil. If
// the file cannot be read or does not have the right format, it returns an error.
func LoadProjectLayoutFromEnv() (*ProjectLayout, error) {
	pt := util.Getenv("CODEQL_PATH_TRANSFORMER", "SEMMLE_PATH_TRANSFORMER")
	if pt == "" {
		return nil, nil
	}
	ptf, err := os.Open(pt)
	if err != nil {
		return nil, err
	}
	projLayout, err := LoadProjectLayout(ptf)
	if err != nil {
		return nil, err
	}
	return projLayout, nil
}

// LoadProjectLayout loads a project layout from the given file, returning an error
// if the file does not have the right format
func LoadProjectLayout(file *os.File) (*ProjectLayout, error) {
	res := ProjectLayout{}
	scanner := bufio.NewScanner(file)

	line := ""
	for ; line == "" && scanner.Scan(); line = strings.TrimSpace(scanner.Text()) {
	}

	if !strings.HasPrefix(line, "#") {
		return nil, fmt.Errorf("first line of project layout should start with #, but got %s", line)
	}
	res.To = normaliseSlashes(strings.TrimSpace(strings.TrimPrefix(line, "#")))

	if !scanner.Scan() {
		return nil, errors.New("empty section in project-layout file")
	}

	line = strings.TrimSpace(scanner.Text())

	if !strings.HasSuffix(line, "//") {
		return nil, errors.New("unsupported project-layout feature")
	}
	line = strings.TrimSuffix(line, "//")

	if strings.HasPrefix(line, "-") || strings.Contains(line, "*") || strings.Contains(line, "//") {
		return nil, errors.New("unsupported project-layout feature")
	}
	res.From = normaliseSlashes(line)

	for scanner.Scan() {
		if strings.TrimSpace(scanner.Text()) != "" {
			return nil, errors.New("only one section with one rewrite supported")
		}
	}

	return &res, nil
}

// transformString transforms `str` as specified by the project layout: if it starts with the `from`
// prefix, that prefix is relaced by `to`; otherwise the string is returned unchanged
func (p *ProjectLayout) transformString(str string) string {
	if str == p.From {
		return p.To
	}
	if strings.HasPrefix(str, p.From+"/") {
		return p.To + "/" + str[len(p.From)+1:]
	}
	return str
}

// isWindowsPath checks whether the substring of `path` starting at `idx` looks like a (slashified)
// Windows path, that is, starts with a drive letter followed by a colon and a slash
func isWindowsPath(path string, idx int) bool {
	return len(path) >= 3+idx &&
		path[idx] != '/' &&
		path[idx+1] == ':' && path[idx+2] == '/'
}

// Transform transforms the given path according to the project layout: if it starts with the `from`
// prefix, that prefix is relaced by `to`; otherwise the path is returned unchanged.
//
// Unlike the (internal) method `transformString`, this method handles Windows paths sensibly.
func (p *ProjectLayout) Transform(path string) string {
	if isWindowsPath(path, 0) {
		result := p.transformString("/" + path)
		if isWindowsPath(result, 1) && result[0] == '/' {
			return result[1:]
		}
		return result
	} else {
		return p.transformString(path)
	}
}
