# xpathparser

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GoDoc](https://godoc.org/github.com/santhosh-tekuri/xpathparser?status.svg)](https://godoc.org/github.com/santhosh-tekuri/xpathparser)
[![Go Report Card](https://goreportcard.com/badge/github.com/santhosh-tekuri/xpathparser)](https://goreportcard.com/report/github.com/santhosh-tekuri/xpathparser)
[![Build Status](https://travis-ci.org/santhosh-tekuri/xpathparser.svg?branch=master)](https://travis-ci.org/santhosh-tekuri/xpathparser)
[![codecov.io](https://codecov.io/github/santhosh-tekuri/xpathparser/coverage.svg?branch=master)](https://codecov.io/github/santhosh-tekuri/xpathparser?branch=master)

Package xpathparser provides lexer and parser for XPath 1.0.

This Package parses given XPath expression to expression model. 

## Example

An example of using this package:

```go
expr := xpathparser.MustParse("(/a/b)[5]")
fmt.Println(expr)
```

This package does not evaluate xpath. For evaluating xpaths use https://github.com/santhosh-tekuri/xpath
