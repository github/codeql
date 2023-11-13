## Sat 29 October 2022 | v0.1.8

Add `golog.Now` variable so 3rd-parties can customize the time.Now functionality used in golog.Log.Time and Timestamp.

## Wed 09 Decemember | v0.1.6

Fix `Clone` not inherite the parent's formatters field (fixes `SetLevelFormat` on childs).

## Mo 07 September | v0.1.5

Introduce the [Formatter](https://github.com/kataras/golog/blob/master/formatter.go) interface. [Example](https://github.com/kataras/golog/tree/master/_examples/customize-output).

- Add `Logger.RegisterFormatter(Formatter)` to register a custom `Formatter`.
- Add `Logger.SetFormat(formatter string, opts ...interface{})` to set the default formatter for all log levels.
- Add `Logger.SetLevelFormat(levelName string, formatter string, opts ...interface{})` to change the output format for the given "levelName".

## Su 06 September | v0.1.3 and v0.1.4

- Add `Logger.SetLevelOutput(levelName string, w io.Writer)` to customize the writer per level.
- Add `Logger.GetLevelOutput(levelName string) io.Writer` to get the leveled output or the default one.

## Sa 15 August | v0.1.2

- `Logger.Child` accepts an `interface{}` instead of `string`. This way you can register children for pointers without forcing to naming them. If the key is string or completes the `fmt.Stringer` interface, then it's used as prefix (like always did).

## Fr 14 August 2020 | v0.0.19

- Use locks on hijacker.

## Tu 09 June 2020 | v0.0.18

- New `SetStacktraceLimit` method. If 0 (default) all debug stacktrace will be logged, if negative the field is disabled.
- If `TimeFormat` field is empty then `timestamp` field is disabled. 

## Sa 06 June 2020 | v0.0.16

- New `Fields` type that can be passed to `Logf/Debugf/Infof/Warnf/Errorf/Fatalf` functions and set the `Log.Fields` data field (which can be retrieved through a custom `LogHandler`).
- Add `Log.Stacktrace` of new `Frame` type which holds the callers stack trace when `Debug/Debugf`.
- Add `json` struct fields to the `Log` structure.
- Update the [customize-output](_examples/customize-output) example.

## Su 17 May 2020 | v0.0.14

Add a `Warningf` method to complete the [dgraph-io/badger.Logger](https://github.com/dgraph-io/badger/blob/ef28ef36b5923f12ffe3a1702bdfa6b479db6637/logger.go#L27) interface **and set the `Prefix` text right before the log's actual message instead of the beginning of the log line.**

## Tu 28 April 2020 | v0.0.12

This release provides support for colorized log level per registered output. Log's level will be colorful for registered `io.Writer`(via `AddOutput`) that supports colors, even when the rest of the writers (e.g. files) don't.

**Breaking changes on the `Levels` map**. See the corresponding updated example for migration.

## Th 12 December 2019 | v0.0.10

- Update [pio dependency](https://github.com/kataras/pio) to version 0.0.2 as it contains a small but important bugfix for GUI apps.

## We 16 October 2019 | v0.0.9

- Set the Logger's `NewLine` on `Clone` method which `golog` makes use inside its `Child("...")` method.
- Go module (v0.0.9). 

## We 02 August 2017 | v0.0.8

Add `fatal` level and `Fatal/Fatalf` funcs.

### v0.0.6 

## Su 30 July 2017 | v0.0.6 && v0.0.7

### v0.0.6 

Add a `SetPrefix(string)` and `Child(string) *Logger`.

Default package-level logger
```go
// automatically prefixed as "Router: "
golog.Child("Router").Errorf("Route %s already exists", "/mypath")
// able to prefix the main logger or child 
golog.Child("Server").SetPrefix("HTTP Server: ").Infof("Server is running at %s", ":8080")
// Child does return a new *Logger based on its parent
srvLogger := golog.Child("Server")
```

Same for independent instances
```go
log := golog.New()
log.SetPrefix("App#1: ")

routerLogger := log.Child("Router")
routerLogger.Errorf("Route %s already exists", "/mypath")
```

Example can be found [here](_examples/child/main.go).

### v0.0.7

Users are now able to add custom or modify existing levels with an easy to remember API.

```go
package main

import (
	"github.com/kataras/golog"
)

func main() {
	// Let's add a custom level,
	//
	// It should be starting from level index 6,
	// because we have 6 built'n levels  (0 is the start index):
	// disable,
	// fatal,
	// error,
	// warn,
	// info
	// debug

	// First we create our level to a golog.Level
	// in order to be used in the Log functions.
	var SuccessLevel golog.Level = 6
	// Register our level, just three fields.
	golog.Levels[SuccessLevel] = &golog.LevelMetadata{
		Name:    "success",
		RawText: "[SUCC]",
		// ColorfulText (Green Color[SUCC])
		ColorfulText: "\x1b[32m[SUCC]\x1b[0m",
	}

	// create a new golog logger
	myLogger := golog.New()

	// set its level to the higher in order to see it
	// ("success" is the name we gave to our level)
	myLogger.SetLevel("success")

	// and finally print a log message with our custom level
	myLogger.Logf(SuccessLevel, "This is a success log message with green color")
}
```

Example can be found [here](_examples/customize-levels/new-level/main.go).

## Sa 29 July 2017 | v0.0.4 & v0.0.5

### v0.0.4
- Fix an issue occurred by previous chnages, which [pio](https://github.com/kataras/pio) appends a trailing new line.

- Add a new method `golog#NewLine` which can override the default line breaker chars "\n".

### v0.0.5

Default output is `os.Stdout` instead of `os.Stderr` now, you can change it by `golog#SetOutput`.

Users are now able to customize both raw and colorful leveled log messages' prefix, example below.

Example Code:

```go
package main

import (
    "github.com/kataras/golog"
)

func main() {

    // First argument is the raw text for outputs
    // that are not support colors,
    // second argument is the full colorful text (yes it can be different if you wish to).
    //
    // If the second argument is empty then golog will update the colorful text to the
    // default color (i.e red on ErrorText) based on the first argument.

    // Default is "[ERRO]"
    golog.ErrorText("|ERROR|", "")
    // Default is "[WARN]"
    golog.WarnText("|WARN|", "")
    // Default is "[INFO]"
    golog.InfoText("|INFO|", "")
    // Default is "[DBUG]"
    golog.DebugText("|DEBUG|", "")

    // Business as usual...
    golog.SetLevel("debug")

    golog.Println("This is a raw message, no levels, no colors.")
    golog.Info("This is an info message, with colors (if the output is terminal)")
    golog.Warn("This is a warning message")
    golog.Error("This is an error message")
    golog.Debug("This is a debug message")
}
```

> This feature has been implemented after @carlca 's suggestion, [here](https://github.com/kataras/golog/issues/2).


## Th 27 July 2017 | v0.0.3

Increase the logger's performance by reducing the use of buffers on the [pio library](https://github.com/kataras/pio)