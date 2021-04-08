/** Provides classes related to the namespace `System.Xml.XPath`. */

import csharp as csharp
private import semmle.code.csharp.frameworks.system.Xml as xml

/** Definitions relating to the `System.Xml.XPath` namespace. */
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

  /** The `System.Xml.XPath.XPathNavigator` class. */
  class XPathNavigator extends Class {
    XPathNavigator() { this.hasName("XPathNavigator") }

    /** Gets a method that selects nodes. */
    csharp::Method getASelectMethod() {
      result = this.getAMethod() and result.getName().matches("Select%")
    }

    /** Gets the `Compile` method. */
    csharp::Method getCompileMethod() { result = this.getAMethod("Compile") }

    /** Gets an `Evaluate` method. */
    csharp::Method getAnEvaluateMethod() { result = this.getAMethod("Evaluate") }

    /** Gets a `Matches` method. */
    csharp::Method getAMatchesMethod() { result = this.getAMethod("Matches") }
  }
}
