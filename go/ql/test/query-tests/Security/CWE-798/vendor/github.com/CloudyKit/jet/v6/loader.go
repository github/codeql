// Copyright 2016 José Santos <henrique_1609@me.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package jet

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"sync"
)

// Loader is a minimal interface required for loading templates.
//
// Jet will build an absolute path (with slash delimiters) before looking up templates by resolving paths in extends/import/include statements:
//
// - `{{ extends "/bar.jet" }}` will make Jet look up `/bar.jet` in the Loader unchanged, no matter where it occurs (since it's an absolute path)
// - `{{ include("\views\bar.jet") }}` will make Jet look up `/views/bar.jet` in the Loader, no matter where it occurs
// - `{{ import "bar.jet" }}` in `/views/foo.jet` will result in a lookup of `/views/bar.jet`
// - `{{ extends "./bar.jet" }}` in `/views/foo.jet` will result in a lookup of `/views/bar.jet`
// - `{{ import "../views\bar.jet" }}` in `/views/foo.jet` will result in a lookup of `/views/bar.jet`
// - `{{ include("../bar.jet") }}` in `/views/foo.jet` will result in a lookup of `/bar.jet`
// - `{{ import "../views/../bar.jet" }}` in `/views/foo.jet` will result in a lookup of `/bar.jet`
//
// This means that the same template will always be looked up using the same path.
//
// Jet will also try appending multiple file endings for convenience: `{{ extends "/bar" }}` will lookup `/bar`, `/bar.jet`,
// `/bar.html.jet` and `/bar.jet.html` (in that order). To avoid unneccessary lookups, use the full file name in your templates (so the first lookup
// is always a hit, or override this list of extensions using Set.SetExtensions().
type Loader interface {
	// Exists returns whether or not a template exists under the requested path.
	Exists(templatePath string) bool

	// Open returns the template's contents or an error if something went wrong.
	// Calls to Open() will always be preceded by a call to Exists() with the same `templatePath`.
	// It is the caller's duty to close the template.
	Open(templatePath string) (io.ReadCloser, error)
}

// OSFileSystemLoader implements Loader interface using OS file system (os.File).
type OSFileSystemLoader struct {
	dir string
}

// compile time check that we implement Loader
var _ Loader = (*OSFileSystemLoader)(nil)

// NewOSFileSystemLoader returns an initialized OSFileSystemLoader.
func NewOSFileSystemLoader(dirPath string) *OSFileSystemLoader {
	return &OSFileSystemLoader{
		dir: filepath.FromSlash(dirPath),
	}
}

// Exists returns true if a file is found under the template path after converting it to a file path
// using the OS's path seperator and joining it with the loader's directory path.
func (l *OSFileSystemLoader) Exists(templatePath string) bool {
	templatePath = filepath.Join(l.dir, filepath.FromSlash(templatePath))
	stat, err := os.Stat(templatePath)
	if err == nil && !stat.IsDir() {
		return true
	}
	return false
}

// Open returns the result of `os.Open()` on the file located using the same logic as Exists().
func (l *OSFileSystemLoader) Open(templatePath string) (io.ReadCloser, error) {
	return os.Open(filepath.Join(l.dir, filepath.FromSlash(templatePath)))
}

// InMemLoader is a simple in-memory loader storing template contents in a simple map.
// InMemLoader normalizes paths passed to its methods by converting any input path to a slash-delimited path,
// turning it into an absolute path by prepending a "/" if neccessary, and cleaning it (see path.Clean()).
// It is safe for concurrent use.
type InMemLoader struct {
	lock  sync.RWMutex
	files map[string][]byte
}

// compile time check that we implement Loader
var _ Loader = (*InMemLoader)(nil)

// NewInMemLoader return a new InMemLoader.
func NewInMemLoader() *InMemLoader {
	return &InMemLoader{
		files: map[string][]byte{},
	}
}

func (l *InMemLoader) normalize(templatePath string) string {
	templatePath = filepath.ToSlash(templatePath)
	return path.Join("/", templatePath)
}

// Open returns a template's contents, or an error if no template was added under this path using Set().
func (l *InMemLoader) Open(templatePath string) (io.ReadCloser, error) {
	templatePath = l.normalize(templatePath)
	l.lock.RLock()
	defer l.lock.RUnlock()
	f, ok := l.files[templatePath]
	if !ok {
		return nil, fmt.Errorf("%s does not exist", templatePath)
	}

	return ioutil.NopCloser(bytes.NewReader(f)), nil
}

// Exists returns whether or not a template is indexed under this path.
func (l *InMemLoader) Exists(templatePath string) bool {
	templatePath = l.normalize(templatePath)
	l.lock.RLock()
	defer l.lock.RUnlock()
	_, ok := l.files[templatePath]
	return ok
}

// Set adds a template to the loader.
func (l *InMemLoader) Set(templatePath, contents string) {
	templatePath = l.normalize(templatePath)
	l.lock.Lock()
	defer l.lock.Unlock()
	l.files[templatePath] = []byte(contents)
}

// Delete removes whatever contents are stored under the given path.
func (l *InMemLoader) Delete(templatePath string) {
	templatePath = l.normalize(templatePath)
	l.lock.Lock()
	defer l.lock.Unlock()
	delete(l.files, templatePath)
}
