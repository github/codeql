/** Provides classes related to the namespace `System.Xml.XPath`. */

import csharp as csharp
private import semmle.code.csharp.frameworks.system.Xml as xml

module SystemXmlXPath {
  /** The `System.Xml.XPath` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof xml::SystemXmlNamespace and
      this.hasName("XPath")
    }
  }

  /** A class in the `System.Xml.XPath` namespace. */
  class Class extends csharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `System.Xml.XPath.XPathExpression` class. */
  class XPathExpression extends Class {
    XPathExpression() { this.hasName("XPathExpression") }
  }
}
