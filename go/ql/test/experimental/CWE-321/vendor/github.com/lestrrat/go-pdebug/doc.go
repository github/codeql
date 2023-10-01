// Package pdebug provides tools to produce debug logs the way the author
// (Daisuke Maki a.k.a. lestrrat) likes. All of the functions are no-ops
// unless you compile with the `-tags debug` option.
//
// When you compile your program with `-tags debug`, no trace is displayed,
// but the code enclosed within `if pdebug.Enabled { ... }` is compiled in.
// To show the debug trace, set the PDEBUG_TRACE environment variable to
// true (or 1, or whatever `strconv.ParseBool` parses to true)
//
// If you want to show the debug trace regardless of an environment variable,
// for example, perhaps while you are debugging or running tests, use the
// `-tags debug0` build tag instead. This will enable the debug trace
// forcefully
package pdebug

