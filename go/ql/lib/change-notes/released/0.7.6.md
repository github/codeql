## 0.7.6

### Minor Analysis Improvements

* The diagnostic query `go/diagnostics/successfully-extracted-files`, and therefore the Code Scanning UI measure of scanned Go files, now considers any Go file seen during extraction, even one with some errors, to be extracted / scanned.
* The XPath library, which is used for the XPath injection query (`go/xml/xpath-injection`), now includes support for `Parser` sinks from the [libxml2](https://github.com/lestrrat-go/libxml2) package.
* `CallNode::getACallee` and related predicates now recognise more callees accessed via a function variable, in particular when the callee is stored into a global variable or is captured by an anonymous function. This may lead to new alerts where data-flow into such a callee is relevant.
