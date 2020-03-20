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
import DataFlow::PathGraph

class ByteSliceType extends SliceType {
  ByteSliceType() { this.getElementType() instanceof Uint8Type }
}

class XPathInjectionConfiguration extends TaintTracking::Configuration {
  XPathInjectionConfiguration() { this = "XPathInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof UntrustedFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XPathInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    not node.asExpr().getType() instanceof StringType or
    not node.asExpr().getType() instanceof ByteSliceType
  }
}

abstract class XPathInjectionSink extends DataFlow::Node { }

// https://github.com/antchfx/xpath
class XPathSink extends XPathInjectionSink {
  XPathSink() {
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/xpath", "Compile%") and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/xpath", "MustCompile%") and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/xpath", "Select%") and
      this = f.getACall().getArgument(1)
    )
  }
}

// https://github.com/antchfx/htmlquery
class HtmlQuerySink extends XPathInjectionSink {
  HtmlQuerySink() {
    exists(Function f, string name | name.matches("Find%") |
      f.hasQualifiedName("github.com/antchfx/htmlquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f, string name | name.matches("Query%") |
      f.hasQualifiedName("github.com/antchfx/htmlquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/htmlquery", "getQuery") and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/antchfx/xmlquery
class XmlQuerySink extends XPathInjectionSink {
  XmlQuerySink() {
    exists(Function f, string name | name.matches("Find%") |
      f.hasQualifiedName("github.com/antchfx/xmlquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f, string name | name.matches("Query%") |
      f.hasQualifiedName("github.com/antchfx/xmlquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f, string name | name.matches("Select%") |
      f.hasQualifiedName("github.com/antchfx/xmlquery", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/xmlquery", "getQuery") and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/antchfx/jsonquery
class JsonQuerySink extends XPathInjectionSink {
  JsonQuerySink() {
    exists(Function f, string name | name.matches("Find%") |
      f.hasQualifiedName("github.com/antchfx/jsonquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f, string name | name.matches("Query%") |
      f.hasQualifiedName("github.com/antchfx/jsonquery", name) and
      this = f.getACall().getArgument(1)
    )
    or
    exists(Function f |
      f.hasQualifiedName("github.com/antchfx/jsonquery", "getQuery") and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/go-xmlpath/xmlpath
class XmlPathSink extends XPathInjectionSink {
  XmlPathSink() {
    exists(Function f, string name | name.matches("Compile%") |
      f.hasQualifiedName("github.com/go-xmlpath/xmlpath", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f, string name | name.matches("MustCompile%") |
      f.hasQualifiedName("github.com/go-xmlpath/xmlpath", name) and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/ChrisTrenkamp/goxpath
class GoXPathSink extends XPathInjectionSink {
  GoXPathSink() {
    exists(Function f, string name | name.matches("Parse%") |
      f.hasQualifiedName("github.com/ChrisTrenkamp/goxpath", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f, string name | name.matches("MustParse%") |
      f.hasQualifiedName("github.com/ChrisTrenkamp/goxpath", name) and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/santhosh-tekuri/xpathparser
class XPathParserSink extends XPathInjectionSink {
  XPathParserSink() {
    exists(Function f, string name | name.matches("Parse%") |
      f.hasQualifiedName("github.com/santhosh-tekuri/xpathparser", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f, string name | name.matches("MustParse%") |
      f.hasQualifiedName("github.com/santhosh-tekuri/xpathparser", name) and
      this = f.getACall().getArgument(0)
    )
  }
}

// https://github.com/moovweb/gokogiri
class GokogiriSink extends XPathInjectionSink {
  GokogiriSink() {
    exists(Function f, string name | name.matches("Compile%") |
      f.hasQualifiedName("github.com/moovweb/gokogiri/xpath", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f, string name | name.matches("Search%") |
      f.hasQualifiedName("github.com/moovweb/gokogiri/xml", name) and
      this = f.getACall().getArgument(0)
    )
    or
    exists(Function f, string name | name.matches("EvalXPath%") |
      f.hasQualifiedName("github.com/moovweb/gokogiri/xml", name) and
      this = f.getACall().getArgument(0)
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XPathInjectionConfiguration c, Function f
where c.hasFlowPath(source, sink) and f.getName().matches("Compile%")
select sink.getNode(), source, sink, "$@ flows here and is used in an XPath expression.",
  source.getNode(), "A user-provided value"
