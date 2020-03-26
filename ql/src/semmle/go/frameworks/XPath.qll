/**
 * Provides classes for working with XPath-related concepts such as XPath expressions.
 */

import go

/** Provides classes for working with XPath-related APIs. */
module XPath {
  /** Provides classes for working with XPath expression strings. */
  module XPathExpressionString {
    /**
     * A data-flow node whose string value is interpreted as (part of) an XPath expression.
     *
     * Extend this class to model new APIs.
     */
    abstract class Range extends DataFlow::Node { }

    /** An XPath expression string used in an API function of the https://github.com/antchfx/xpath package. */
    private class AntchfxxpathXPathExpressionString extends Range {
      AntchfxxpathXPathExpressionString() {
        exists(Function f, string name | name.matches("Compile%") |
          f.hasQualifiedName("github.com/antchfx/xpath", name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("MustCompile%") |
          f.hasQualifiedName("github.com/antchfx/xpath", name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("Select%") |
          f.hasQualifiedName("github.com/antchfx/xpath", name) and
          this = f.getACall().getArgument(1)
        )
      }
    }

    /** An XPath expression string used in an API function of the https://github.com/antchfx/htmlquery package. */
    private class AntchfxhtmlqueryXPathExpressionString extends Range {
      AntchfxhtmlqueryXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/antchfx/xmlquery package. */
    private class AntchfxxmlqueryXPathExpressionString extends Range {
      AntchfxxmlqueryXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/antchfx/jsonquery package. */
    private class AntchfxjsonqueryXPathExpressionString extends Range {
      AntchfxjsonqueryXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/go-xmlpath/xmlpath package. */
    private class GoxmlpathxmlpathXPathExpressionString extends Range {
      GoxmlpathxmlpathXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/ChrisTrenkamp/goxpath package. */
    private class ChrisTrenkampgoxpathXPathExpressionString extends Range {
      ChrisTrenkampgoxpathXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/santhosh-tekuri/xpathparser package. */
    private class AnthoshtekurixpathparserXPathExpressionString extends Range {
      AnthoshtekurixpathparserXPathExpressionString() {
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

    /** An XPath expression string used in an API function of the https://github.com/moovweb/gokogiri package. */
    private class MoovwebgokogiriXPathExpressionString extends Range {
      MoovwebgokogiriXPathExpressionString() {
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
  }
}
