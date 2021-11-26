/** Definitions related to the namespace `System.Web.WebPages`, ASP.NET */

import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.WebPages` namespace. */
class SystemWebWebPagesNamespace extends Namespace {
  SystemWebWebPagesNamespace() {
    this.getParentNamespace() instanceof SystemWebNamespace and
    this.hasName("WebPages")
  }
}

/** The `System.Web.WebPages.WebPageExecutingBase` class. */
class SystemWebWebPagesWebPageExecutingBaseClass extends Class {
  SystemWebWebPagesWebPageExecutingBaseClass() {
    this.getNamespace() instanceof SystemWebWebPagesNamespace and
    this.hasName("WebPageExecutingBase")
  }
}

/** A class that derives from `System.Web.WebPages.WebPageExecutingBase`. */
class WebPageClass extends Class {
  WebPageClass() { this.getBaseClass*() instanceof SystemWebWebPagesWebPageExecutingBaseClass }

  /** Gets the `WriteLiteral` method. */
  Method getWriteLiteralMethod() { result = this.getAMethod("WriteLiteral") }

  /** Gets the `WriteLiteralTo` method. */
  Method getWriteLiteralToMethod() { result = this.getAMethod("WriteLiteralTo") }
}
