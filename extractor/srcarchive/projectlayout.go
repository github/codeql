package srcarchive

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strings"
)

// ProjectLayout describes a very simple project layout rewriting paths starting
// with `from` to start with `to` instead.
//
// We currently only support project layouts of the form
//
// # to
// from//
type ProjectLayout struct {
	from, to string
}

// normaliseSlashes adds an initial slash to `path` if there isn't one, and trims
// a final slash if there is one
func normaliseSlashes(path string) string {
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return strings.TrimSuffix(path, "/")
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
	res.to = normaliseSlashes(strings.TrimSpace(strings.TrimPrefix(line, "#")))

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
	res.from = normaliseSlashes(line)

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
	if str == p.from {
		return p.to
	}
	if strings.HasPrefix(str, p.from+"/") {
		return p.to + "/" + str[len(p.from)+1:]
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
