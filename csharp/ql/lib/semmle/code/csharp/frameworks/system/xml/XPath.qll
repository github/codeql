/** Provides classes related to the namespace `System.Xml.XPath`. */

private import csharp as CSharp
private import semmle.code.csharp.frameworks.system.Xml as Xml

/** Definitions relating to the `System.Xml.XPath` namespace. */
module SystemXmlXPath {
  /** The `System.Xml.XPath` namespace. */
  class Namespace extends CSharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof Xml::SystemXmlNamespace and
      this.hasName("XPath")
    }
  }

  /** A class in the `System.Xml.XPath` namespace. */
  class Class extends CSharp::Class {
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
    CSharp::Method getASelectMethod() {
      result = this.getAMethod() and result.getName().matches("Select%")
    }

    /** Gets the `Compile` method. */
    CSharp::Method getCompileMethod() { result = this.getAMethod("Compile") }

    /** Gets an `Evaluate` method. */
    CSharp::Method getAnEvaluateMethod() { result = this.getAMethod("Evaluate") }

    /** Gets a `Matches` method. */
    CSharp::Method getAMatchesMethod() { result = this.getAMethod("Matches") }
  }
}
