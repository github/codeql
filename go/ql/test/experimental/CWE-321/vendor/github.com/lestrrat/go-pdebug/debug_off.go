//+build !debug,!debug0

package pdebug

// Enabled is true if `-tags debug` or `-tags debug0` is used
// during compilation. Use this to "ifdef-out" debug blocks.
const Enabled = false

// Trace is true if `-tags debug` is used AND the environment
// variable `PDEBUG_TRACE` is set to a `true` value (i.e.,
// 1, true, etc), or `-tags debug0` is used. This allows you to
// compile-in the trace logs, but only show them when you 
// set the environment variable
const Trace = false

// IRelease is deprecated. Use Marker()/End() instead
func (g guard) IRelease(f string, args ...interface{}) {}

// IPrintf is deprecated. Use Marker()/End() instead
func IPrintf(f string, args ...interface{}) guard { return guard{} }

// Printf prints to standard out, just like a normal fmt.Printf,
// but respects the indentation level set by IPrintf/IRelease.
// Printf is no op unless you compile with the `debug` tag.
func Printf(f string, args ...interface{}) {}

// Dump dumps the objects using go-spew.
// Dump is a no op unless you compile with the `debug` tag.
func Dump(v ...interface{}) {}

// Marker marks the beginning of an indented block. The message
// you specify in the arguments is prefixed witha "START", and
// subsequent calls to Printf will be indented one level more.
//
// To reset this, you must call End() on the guard object that
// gets returned by Marker().
func Marker(f string, args ...interface{}) *markerg { return emptyMarkerGuard }
func (g *markerg) BindError(_ *error) *markerg { return g }
func (g *markerg) End() {}
