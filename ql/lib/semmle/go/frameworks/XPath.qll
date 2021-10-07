/**
 * Provides classes for working with XPath-related concepts such as XPath expressions.
 */

import go

/** Provides classes for working with XPath-related APIs. */
module XPath {
  /**
   * A data-flow node whose string value is interpreted as (part of) an XPath expression.
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `XPath::XPathExpressionString::Range` instead.
   */
  class XPathExpressionString extends DataFlow::Node {
    XPathExpressionString::Range self;

    XPathExpressionString() { this = self }
  }

  /** Provides classes for working with XPath expression strings. */
  module XPathExpressionString {
    /**
     * A data-flow node whose string value is interpreted as (part of) an XPath expression.
     *
     * Extend this class to model new APIs. If you want to refine existing API models,
     * extend `XPath::XPathExpressionString` instead.
     */
    abstract class Range extends DataFlow::Node { }

    /**
     * An XPath expression string used in an API function of the
     * [XPath](https://github.com/antchfx/xpath) package.
     */
    private class AntchfxXpathXPathExpressionString extends Range {
      AntchfxXpathXPathExpressionString() {
        exists(Function f, string name | name.matches("Compile%") |
          f.hasQualifiedName(package("github.com/antchfx/xpath", ""), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("MustCompile%") |
          f.hasQualifiedName(package("github.com/antchfx/xpath", ""), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("Select%") |
          f.hasQualifiedName(package("github.com/antchfx/xpath", ""), name) and
          this = f.getACall().getArgument(1)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [htmlquery](https://github.com/antchfx/htmlquery) package.
     */
    private class AntchfxHtmlqueryXPathExpressionString extends Range {
      AntchfxHtmlqueryXPathExpressionString() {
        exists(Function f, string name | name.matches("Find%") |
          f.hasQualifiedName(package("github.com/antchfx/htmlquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
        or
        exists(Function f, string name | name.matches("Query%") |
          f.hasQualifiedName(package("github.com/antchfx/htmlquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [xmlquery](https://github.com/antchfx/xmlquery) package.
     */
    private class AntchfxXmlqueryXPathExpressionString extends Range {
      AntchfxXmlqueryXPathExpressionString() {
        exists(Function f, string name | name.matches("Find%") |
          f.hasQualifiedName(package("github.com/antchfx/xmlquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
        or
        exists(Function f, string name | name.matches("Query%") |
          f.hasQualifiedName(package("github.com/antchfx/xmlquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
        or
        exists(Method m, string name | name.matches("Select%") |
          m.hasQualifiedName(package("github.com/antchfx/xmlquery", ""), "Node", name) and
          this = m.getACall().getArgument(0)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [jsonquery](https://github.com/antchfx/jsonquery) package.
     */
    private class AntchfxJsonqueryXPathExpressionString extends Range {
      AntchfxJsonqueryXPathExpressionString() {
        exists(Function f, string name | name.matches("Find%") |
          f.hasQualifiedName(package("github.com/antchfx/jsonquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
        or
        exists(Function f, string name | name.matches("Query%") |
          f.hasQualifiedName(package("github.com/antchfx/jsonquery", ""), name) and
          this = f.getACall().getArgument(1)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [xmlpath](https://github.com/go-xmlpath/xmlpath) package.
     */
    private class GoXmlpathXmlpathXPathExpressionString extends Range {
      GoXmlpathXmlpathXPathExpressionString() {
        exists(Function f, string name | name.matches("Compile%") |
          f.hasQualifiedName(XmlPath::packagePath(), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("MustCompile%") |
          f.hasQualifiedName(XmlPath::packagePath(), name) and
          this = f.getACall().getArgument(0)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [goxpath](https://github.com/ChrisTrenkamp/goxpath) package.
     */
    private class ChrisTrenkampGoxpathXPathExpressionString extends Range {
      ChrisTrenkampGoxpathXPathExpressionString() {
        exists(Function f, string name | name.matches("Parse%") |
          f.hasQualifiedName(package("github.com/ChrisTrenkamp/goxpath", ""), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("MustParse%") |
          f.hasQualifiedName(package("github.com/ChrisTrenkamp/goxpath", ""), name) and
          this = f.getACall().getArgument(0)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [xpathparser](https://github.com/santhosh-tekuri/xpathparser) package.
     */
    private class SanthoshTekuriXpathparserXPathExpressionString extends Range {
      SanthoshTekuriXpathparserXPathExpressionString() {
        exists(Function f, string name | name.matches("Parse%") |
          f.hasQualifiedName(package("github.com/santhosh-tekuri/xpathparser", ""), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Function f, string name | name.matches("MustParse%") |
          f.hasQualifiedName(package("github.com/santhosh-tekuri/xpathparser", ""), name) and
          this = f.getACall().getArgument(0)
        )
      }
    }

    /**
     * An XPath expression string used in an API function of the
     * [gokogiri]https://github.com/jbowtie/gokogiri) package.
     */
    private class JbowtieGokogiriXPathExpressionString extends Range {
      JbowtieGokogiriXPathExpressionString() {
        exists(Function f, string name | name.matches("Compile%") |
          f.hasQualifiedName(package("github.com/jbowtie/gokogiri", "xpath"), name) and
          this = f.getACall().getArgument(0)
        )
        or
        exists(Method m, string name | name.matches("Search%") |
          m.hasQualifiedName(package("github.com/jbowtie/gokogiri", "xml"), "Node", name) and
          this = m.getACall().getArgument(0)
        )
        or
        exists(Method m, string name | name.matches("EvalXPath%") |
          m.hasQualifiedName(package("github.com/jbowtie/gokogiri", "xml"), "Node", name) and
          this = m.getACall().getArgument(0)
        )
      }
    }
  }
}

/**
 * Provides classes for working with the [xmlpath](https://gopkg.in/xmlpath.v2) package.
 */
module XmlPath {
  /** Gets the package name `github.com/go-xmlpath/xmlpath` or `gopkg.in/xmlpath`. */
  string packagePath() {
    result = package(["github.com/go-xmlpath/xmlpath", "gopkg.in/xmlpath"], "")
  }
}
