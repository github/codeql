# Jet Template Engine for Go

[![Build Status](https://travis-ci.org/CloudyKit/jet.svg?branch=master)](https://travis-ci.org/CloudyKit/jet) [![Build status](https://ci.appveyor.com/api/projects/status/5g4whw3c6518vvku?svg=true)](https://ci.appveyor.com/project/CloudyKit/jet) [![Join the chat at https://gitter.im/CloudyKit/jet](https://badges.gitter.im/CloudyKit/jet.svg)](https://gitter.im/CloudyKit/jet)

Jet is a template engine developed to be easy to use, powerful, dynamic, yet secure and very fast.

* simple and familiar syntax
* supports template inheritance (`extends`) and composition (`block`/`yield`, `import`, `include`)
* descriptive error messages with filename and line number
* auto-escaping
* simple C-like expressions
* very fast execution – Jet can execute templates faster than some pre-compiled template engines
* very light in terms of allocations and memory footprint

## v6

Version 6 brings major improvements to the Go API. Make sure to read through the [breaking changes](./docs/changes.md) before making the jump.

## Docs

- [Go API](https://beta.pkg.go.dev/github.com/CloudyKit/jet/v6#section-documentation)
- [Syntax Reference](./docs/syntax.md)
- [Built-ins](./docs/builtins.md)
- [Wiki](https://github.com/CloudyKit/jet/wiki) (some things are out of date)

## Example application

An example to-do application is available in [examples/todos](./examples/todos). Clone the repository, then (in the repository root) do:
```
  $ cd examples/todos; go run main.go
```

## IntelliJ Plugin

If you use IntelliJ there is a plugin available at https://github.com/jhsx/GoJetPlugin.
There is also a very good Go plugin for IntelliJ – see https://github.com/go-lang-plugin-org/go-lang-idea-plugin.
GoJetPlugin + Go-lang-idea-plugin = happiness!

## Contributing

All contributions are welcome – if you find a bug please report it.

## Contributors

- José Santos (@jhsx)
- Daniel Lohse (@annismckenzie)
- Alexander Willing (@sauerbraten)
