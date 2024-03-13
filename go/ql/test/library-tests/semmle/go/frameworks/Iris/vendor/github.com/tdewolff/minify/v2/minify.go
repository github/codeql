// Package minify relates MIME type to minifiers. Several minifiers are provided in the subpackages.
package minify

import (
	"bytes"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"mime"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"path"
	"regexp"
	"strings"
	"sync"

	"github.com/tdewolff/parse/v2"
	"github.com/tdewolff/parse/v2/buffer"
)

// Warning is used to report usage warnings such as using a deprecated feature
var Warning = log.New(os.Stderr, "WARNING: ", 0)

// ErrNotExist is returned when no minifier exists for a given mimetype.
var ErrNotExist = errors.New("minifier does not exist for mimetype")

// ErrClosedWriter is returned when writing to a closed writer.
var ErrClosedWriter = errors.New("write on closed writer")

////////////////////////////////////////////////////////////////

// MinifierFunc is a function that implements Minifer.
type MinifierFunc func(*M, io.Writer, io.Reader, map[string]string) error

// Minify calls f(m, w, r, params)
func (f MinifierFunc) Minify(m *M, w io.Writer, r io.Reader, params map[string]string) error {
	return f(m, w, r, params)
}

// Minifier is the interface for minifiers.
// The *M parameter is used for minifying embedded resources, such as JS within HTML.
type Minifier interface {
	Minify(*M, io.Writer, io.Reader, map[string]string) error
}

////////////////////////////////////////////////////////////////

type patternMinifier struct {
	pattern *regexp.Regexp
	Minifier
}

type cmdMinifier struct {
	cmd *exec.Cmd
}

var cmdArgExtension = regexp.MustCompile(`^\.[0-9a-zA-Z]+`)

func (c *cmdMinifier) Minify(_ *M, w io.Writer, r io.Reader, _ map[string]string) error {
	cmd := &exec.Cmd{}
	*cmd = *c.cmd // concurrency safety

	var in, out *os.File
	for i, arg := range cmd.Args {
		if j := strings.Index(arg, "$in"); j != -1 {
			var err error
			ext := cmdArgExtension.FindString(arg[j+3:])
			if in, err = ioutil.TempFile("", "minify-in-*"+ext); err != nil {
				return err
			}
			cmd.Args[i] = arg[:j] + in.Name() + arg[j+3+len(ext):]
		} else if j := strings.Index(arg, "$out"); j != -1 {
			var err error
			ext := cmdArgExtension.FindString(arg[j+4:])
			if out, err = ioutil.TempFile("", "minify-out-*"+ext); err != nil {
				return err
			}
			cmd.Args[i] = arg[:j] + out.Name() + arg[j+4+len(ext):]
		}
	}

	if in == nil {
		cmd.Stdin = r
	} else if _, err := io.Copy(in, r); err != nil {
		return err
	}
	if out == nil {
		cmd.Stdout = w
	} else {
		defer io.Copy(w, out)
	}
	stderr := &bytes.Buffer{}
	cmd.Stderr = stderr

	err := cmd.Run()
	if _, ok := err.(*exec.ExitError); ok {
		if stderr.Len() != 0 {
			err = fmt.Errorf("%s", stderr.String())
		}
		err = fmt.Errorf("command %s failed: %w", cmd.Path, err)
	}
	return err
}

////////////////////////////////////////////////////////////////

// M holds a map of mimetype => function to allow recursive minifier calls of the minifier functions.
type M struct {
	mutex   sync.RWMutex
	literal map[string]Minifier
	pattern []patternMinifier

	URL *url.URL
}

// New returns a new M.
func New() *M {
	return &M{
		sync.RWMutex{},
		map[string]Minifier{},
		[]patternMinifier{},
		nil,
	}
}

// Add adds a minifier to the mimetype => function map (unsafe for concurrent use).
func (m *M) Add(mimetype string, minifier Minifier) {
	m.mutex.Lock()
	m.literal[mimetype] = minifier
	m.mutex.Unlock()
}

// AddFunc adds a minify function to the mimetype => function map (unsafe for concurrent use).
func (m *M) AddFunc(mimetype string, minifier MinifierFunc) {
	m.mutex.Lock()
	m.literal[mimetype] = minifier
	m.mutex.Unlock()
}

// AddRegexp adds a minifier to the mimetype => function map (unsafe for concurrent use).
func (m *M) AddRegexp(pattern *regexp.Regexp, minifier Minifier) {
	m.mutex.Lock()
	m.pattern = append(m.pattern, patternMinifier{pattern, minifier})
	m.mutex.Unlock()
}

// AddFuncRegexp adds a minify function to the mimetype => function map (unsafe for concurrent use).
func (m *M) AddFuncRegexp(pattern *regexp.Regexp, minifier MinifierFunc) {
	m.mutex.Lock()
	m.pattern = append(m.pattern, patternMinifier{pattern, minifier})
	m.mutex.Unlock()
}

// AddCmd adds a minify function to the mimetype => function map (unsafe for concurrent use) that executes a command to process the minification.
// It allows the use of external tools like ClosureCompiler, UglifyCSS, etc. for a specific mimetype.
func (m *M) AddCmd(mimetype string, cmd *exec.Cmd) {
	m.mutex.Lock()
	m.literal[mimetype] = &cmdMinifier{cmd}
	m.mutex.Unlock()
}

// AddCmdRegexp adds a minify function to the mimetype => function map (unsafe for concurrent use) that executes a command to process the minification.
// It allows the use of external tools like ClosureCompiler, UglifyCSS, etc. for a specific mimetype regular expression.
func (m *M) AddCmdRegexp(pattern *regexp.Regexp, cmd *exec.Cmd) {
	m.mutex.Lock()
	m.pattern = append(m.pattern, patternMinifier{pattern, &cmdMinifier{cmd}})
	m.mutex.Unlock()
}

// Match returns the pattern and minifier that gets matched with the mediatype.
// It returns nil when no matching minifier exists.
// It has the same matching algorithm as Minify.
func (m *M) Match(mediatype string) (string, map[string]string, MinifierFunc) {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	mimetype, params := parse.Mediatype([]byte(mediatype))
	if minifier, ok := m.literal[string(mimetype)]; ok { // string conversion is optimized away
		return string(mimetype), params, minifier.Minify
	}

	for _, minifier := range m.pattern {
		if minifier.pattern.Match(mimetype) {
			return minifier.pattern.String(), params, minifier.Minify
		}
	}
	return string(mimetype), params, nil
}

// Minify minifies the content of a Reader and writes it to a Writer (safe for concurrent use).
// An error is returned when no such mimetype exists (ErrNotExist) or when an error occurred in the minifier function.
// Mediatype may take the form of 'text/plain', 'text/*', '*/*' or 'text/plain; charset=UTF-8; version=2.0'.
func (m *M) Minify(mediatype string, w io.Writer, r io.Reader) error {
	mimetype, params := parse.Mediatype([]byte(mediatype))
	return m.MinifyMimetype(mimetype, w, r, params)
}

// MinifyMimetype minifies the content of a Reader and writes it to a Writer (safe for concurrent use).
// It is a lower level version of Minify and requires the mediatype to be split up into mimetype and parameters.
// It is mostly used internally by minifiers because it is faster (no need to convert a byte-slice to string and vice versa).
func (m *M) MinifyMimetype(mimetype []byte, w io.Writer, r io.Reader, params map[string]string) error {
	m.mutex.RLock()
	defer m.mutex.RUnlock()

	if minifier, ok := m.literal[string(mimetype)]; ok { // string conversion is optimized away
		return minifier.Minify(m, w, r, params)
	}
	for _, minifier := range m.pattern {
		if minifier.pattern.Match(mimetype) {
			return minifier.Minify(m, w, r, params)
		}
	}
	return ErrNotExist
}

// Bytes minifies an array of bytes (safe for concurrent use). When an error occurs it return the original array and the error.
// It returns an error when no such mimetype exists (ErrNotExist) or any error occurred in the minifier function.
func (m *M) Bytes(mediatype string, v []byte) ([]byte, error) {
	out := buffer.NewWriter(make([]byte, 0, len(v)))
	if err := m.Minify(mediatype, out, buffer.NewReader(v)); err != nil {
		return v, err
	}
	return out.Bytes(), nil
}

// String minifies a string (safe for concurrent use). When an error occurs it return the original string and the error.
// It returns an error when no such mimetype exists (ErrNotExist) or any error occurred in the minifier function.
func (m *M) String(mediatype string, v string) (string, error) {
	out := buffer.NewWriter(make([]byte, 0, len(v)))
	if err := m.Minify(mediatype, out, buffer.NewReader([]byte(v))); err != nil {
		return v, err
	}
	return string(out.Bytes()), nil
}

// Reader wraps a Reader interface and minifies the stream.
// Errors from the minifier are returned by the reader.
func (m *M) Reader(mediatype string, r io.Reader) io.Reader {
	pr, pw := io.Pipe()
	go func() {
		if err := m.Minify(mediatype, pw, r); err != nil {
			pw.CloseWithError(err)
		} else {
			pw.Close()
		}
	}()
	return pr
}

// writer makes sure that errors from the minifier are passed down through Close (can be blocking).
type writer struct {
	pw     *io.PipeWriter
	wg     sync.WaitGroup
	err    error
	closed bool
}

// Write intercepts any writes to the writer.
func (w *writer) Write(b []byte) (int, error) {
	if w.closed {
		return 0, ErrClosedWriter
	}
	n, err := w.pw.Write(b)
	if w.err != nil {
		err = w.err
	}
	return n, err
}

// Close must be called when writing has finished. It returns the error from the minifier.
func (w *writer) Close() error {
	if !w.closed {
		w.pw.Close()
		w.wg.Wait()
		w.closed = true
	}
	return w.err
}

// Writer wraps a Writer interface and minifies the stream.
// Errors from the minifier are returned by Close on the writer.
// The writer must be closed explicitly.
func (m *M) Writer(mediatype string, w io.Writer) io.WriteCloser {
	pr, pw := io.Pipe()
	mw := &writer{pw, sync.WaitGroup{}, nil, false}
	mw.wg.Add(1)
	go func() {
		defer mw.wg.Done()

		if err := m.Minify(mediatype, w, pr); err != nil {
			mw.err = err
		}
		pr.Close()
	}()
	return mw
}

// responseWriter wraps an http.ResponseWriter and makes sure that errors from the minifier are passed down through Close (can be blocking).
// All writes to the response writer are intercepted and minified on the fly.
// http.ResponseWriter loses all functionality such as Pusher, Hijacker, Flusher, ...
type responseWriter struct {
	http.ResponseWriter

	writer    *writer
	m         *M
	mediatype string
}

// WriteHeader intercepts any header writes and removes the Content-Length header.
func (w *responseWriter) WriteHeader(status int) {
	w.ResponseWriter.Header().Del("Content-Length")
	w.ResponseWriter.WriteHeader(status)
}

// Write intercepts any writes to the response writer.
// The first write will extract the Content-Type as the mediatype. Otherwise it falls back to the RequestURI extension.
func (w *responseWriter) Write(b []byte) (int, error) {
	if w.writer == nil {
		// first write
		if mediatype := w.ResponseWriter.Header().Get("Content-Type"); mediatype != "" {
			w.mediatype = mediatype
		}
		w.writer = w.m.Writer(w.mediatype, w.ResponseWriter).(*writer)
	}
	return w.writer.Write(b)
}

// Close must be called when writing has finished. It returns the error from the minifier.
func (w *responseWriter) Close() error {
	if w.writer != nil {
		return w.writer.Close()
	}
	return nil
}

// ResponseWriter minifies any writes to the http.ResponseWriter.
// http.ResponseWriter loses all functionality such as Pusher, Hijacker, Flusher, ...
// Minification might be slower than just sending the original file! Caching is advised.
func (m *M) ResponseWriter(w http.ResponseWriter, r *http.Request) *responseWriter {
	mediatype := mime.TypeByExtension(path.Ext(r.RequestURI))
	return &responseWriter{w, nil, m, mediatype}
}

// Middleware provides a middleware function that minifies content on the fly by intercepting writes to http.ResponseWriter.
// http.ResponseWriter loses all functionality such as Pusher, Hijacker, Flusher, ...
// Minification might be slower than just sending the original file! Caching is advised.
func (m *M) Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		mw := m.ResponseWriter(w, r)
		next.ServeHTTP(mw, r)
		mw.Close()
	})
}

// MiddlewareWithError provides a middleware function that minifies content on the fly by intercepting writes to http.ResponseWriter. The error function allows handling minification errors.
// http.ResponseWriter loses all functionality such as Pusher, Hijacker, Flusher, ...
// Minification might be slower than just sending the original file! Caching is advised.
func (m *M) MiddlewareWithError(next http.Handler, errorFunc func(w http.ResponseWriter, r *http.Request, err error)) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		mw := m.ResponseWriter(w, r)
		next.ServeHTTP(mw, r)
		if err := mw.Close(); err != nil {
			errorFunc(w, r, err)
			return
		}
	})
}
