# go-pdebug

[![Build Status](https://travis-ci.org/lestrrat/go-pdebug.svg?branch=master)](https://travis-ci.org/lestrrat/go-pdebug)

[![GoDoc](https://godoc.org/github.com/lestrrat/go-pdebug?status.svg)](https://godoc.org/github.com/lestrrat/go-pdebug)

Utilities for my print debugging fun. YMMV

# WARNING

This repository has been moved to [github.com/lestrrat-go/pdebug](https://github.com/lestrrat-go/pdebug). This repository exists so that libraries pointing to this URL will keep functioning, but this repository will NOT be updated in the future. Please use the new import path.

# Synopsis

![optimized](https://pbs.twimg.com/media/CbiqhzLUUAIN_7o.png)

# Description

Building with `pdebug` declares a constant, `pdebug.Enabled` which you
can use to easily compile in/out depending on the presence of a build tag.

```go
func Foo() {
  // will only be available if you compile with `-tags debug`
  if pdebug.Enabled {
    pdebug.Printf("Starting Foo()!
  }
}
```

Note that using `github.com/lestrrat/go-pdebug` and `-tags debug` only
compiles in the code. In order to actually show the debug trace, you need
to specify an environment variable:

```shell
# For example, to show debug code during testing:
PDEBUG_TRACE=1 go test -tags debug
```

If you want to forcefully show the trace (which is handy when you're
debugging/testing), you can use the `debug0` tag instead:

```shell
go test -tags debug0
```

# Markers

When you want to print debug a chain of function calls, you can use the
`Marker` functions:

```go
func Foo() {
  if pdebug.Enabled {
    g := pdebug.Marker("Foo")
    defer g.End()
  }

  pdebug.Printf("Inside Foo()!")
}
```

This will cause all of the `Printf` calls to automatically indent
the output so it's visually easier to see where a certain trace log
is being generated.

By default it will print something like:

```
|DEBUG| START Foo
|DEBUG|   Inside Foo()!
|DEBUG| END Foo (1.23μs)
```

If you want to automatically show the error value you are returning
(but only if there is an error), you can use the `BindError` method:

```go
func Foo() (err error) {
  if pdebug.Enabled {
    g := pdebug.Marker("Foo").BindError(&err)
    defer g.End()
  }

  pdebug.Printf("Inside Foo()!")

  return errors.New("boo")
}
```

This will print something like:


```
|DEBUG| START Foo
|DEBUG|   Inside Foo()!
|DEBUG| END Foo (1.23μs): ERROR boo
```

