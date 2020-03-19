/**
 * @name XPath injection
 * @description Building an XPath expression from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id go/xml/xpath-injection
 * @tags security
 *       external/cwe/cwe-643
 */

import go
import semmle.go.dataflow.TaintTracking
import DataFlow::PathGraph

class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { 
    source instanceof UntrustedFlowSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }
}

abstract class XPathInjectionSink extends DataFlow::Node { }

Function getAMatchingFunction(string package, int argumentNumber, CallExpr call, Expr argument) {
  result.getPackage().getName() = package and
  call.getTarget() = result and
  call.getArgument(argumentNumber) = argument
}

// https://github.com/antchfx/xpath
class XPathSink extends XPathInjectionSink {
  XPathSink() {
    exists(CallExpr call |
      getAMatchingFunction("xpath", 0, call, this.asExpr()).getName().matches("Compile")
      or 
      getAMatchingFunction("xpath", 0, call, this.asExpr()).getName().matches("MustCompile")
      or 
      getAMatchingFunction("xpath", 1, call, this.asExpr()).getName().matches("Select")
    )
  }
}

// https://github.com/antchfx/htmlquery
class HtmlQuerySink extends XPathInjectionSink {
  HtmlQuerySink() {
    exists(CallExpr call |
      getAMatchingFunction("htmlquery", 1, call, this.asExpr()).getName().matches("Find%")
      or 
      getAMatchingFunction("htmlquery", 1, call, this.asExpr()).getName().matches("Query%")
      or 
      getAMatchingFunction("htmlquery", 0, call, this.asExpr()).getName().matches("getQuery")
    )
  }
}

// https://github.com/antchfx/xmlquery
class XmlQuerySink extends XPathInjectionSink {
  XmlQuerySink() {
    exists(CallExpr call |
      getAMatchingFunction("xmlquery", 1, call, this.asExpr()).getName().matches("Find%")
      or 
      getAMatchingFunction("xmlquery", 1, call, this.asExpr()).getName().matches("Query%")
      or 
      getAMatchingFunction("xmlquery", 0, call, this.asExpr()).getName().matches("getQuery")
      or 
      getAMatchingFunction("xmlquery", 0, call, this.asExpr()).getName().matches("Select%")
    )
  }
}

// https://github.com/antchfx/jsonquery
class JsonQuerySink extends XPathInjectionSink {
  JsonQuerySink() {
    exists(CallExpr call |
      getAMatchingFunction("jsonquery", 1, call, this.asExpr()).getName().matches("Find%")
      or 
      getAMatchingFunction("jsonquery", 1, call, this.asExpr()).getName().matches("Query%")
      or 
      getAMatchingFunction("jsonquery", 0, call, this.asExpr()).getName().matches("getQuery")
    )
  }
}

// https://github.com/go-xmlpath/xmlpath
class XmlPathSink extends XPathInjectionSink {
  XmlPathSink() {
    exists(CallExpr call |
      getAMatchingFunction("xmlpath", 0, call, this.asExpr()).getName().matches("Compile%")
      or 
      getAMatchingFunction("xmlpath", 0, call, this.asExpr()).getName().matches("MustCompile")
    )
  }
}

// https://github.com/ChrisTrenkamp/goxpath
class GoXPathSink extends XPathInjectionSink {
  GoXPathSink() {
    exists(CallExpr call |
      getAMatchingFunction("goxpath", 0, call, this.asExpr()).getName().matches("Parse")
      or 
      getAMatchingFunction("goxpath", 0, call, this.asExpr()).getName().matches("MustParse")
      or 
      getAMatchingFunction("goxpath", 0, call, this.asExpr()).getName().matches("ParseExec")
    )
  }
}

// https://github.com/santhosh-tekuri/xpathparser
class XPathParserSink extends XPathInjectionSink {
  XPathParserSink() {
    exists(CallExpr call |
      getAMatchingFunction("xpathparser", 0, call, this.asExpr()).getName().matches("Parse")
      or 
      getAMatchingFunction("xpathparser", 0, call, this.asExpr()).getName().matches("MustParse")
    )
  }
}

// https://github.com/moovweb/gokogiri
class GokogiriSink extends XPathInjectionSink {
  GokogiriSink() {
    exists(CallExpr call |
      getAMatchingFunction("xpath", 0, call, this.asExpr()).getName().matches("Compile")
      or 
      // TODO: The following cases will have false positives in case a *xpath.Expression is supplied
      // I don't know how to fix this, since I'm new to the Go QL flavour.
      // https://github.com/moovweb/gokogiri/blob/a1a828153468a7518b184e698f6265904108d957/xml/node.go#L613
      getAMatchingFunction("xml", 0, call, this.asExpr()).getName().matches("Search%")
      or
      getAMatchingFunction("xml", 0, call, this.asExpr()).getName().matches("EvalXPath%")    
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XPathInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used in an XPath expression.",
  source.getNode(), "User-provided value"
