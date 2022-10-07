// Copyright 2017 Santhosh Kumar Tekuri. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/*
Package xpathparser provides lexer and parser for XPath 1.0.

This Package parses given XPath expression to expression model.

An example of using this package:

	expr := xpathparser.MustParse("(/a/b)[5]")
	fmt.Println(expr)

*/
package xpathparser
