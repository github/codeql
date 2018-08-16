/** Definitions related to the namespace `System.Web.WebPages`, ASP.NET */
import csharp

private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.WebPages` namespace. */
class SystemWebWebPagesNamespace extends Namespace {
  SystemWebWebPagesNamespace() {
    getParentNamespace() instanceof SystemWebNamespace and
    hasName("WebPages")
  }
}

/** The `System.Web.WebPages.WebPageExecutingBase` class. */
class SystemWebWebPagesWebPageExecutingBaseClass extends Class {
  SystemWebWebPagesWebPageExecutingBaseClass() {
    getNamespace() instanceof SystemWebWebPagesNamespace and
    hasName("WebPageExecutingBase")
  }
}

/**
 * This class describes any class that derives from System.Web.WebPages.WebPageExecutingBase
 */
class WebPageClass extends Class {
	WebPageClass () {
		this.getBaseClass*() instanceof SystemWebWebPagesWebPageExecutingBaseClass
	}
	
	Method getWriteLiteralMethod() {
    result = getAMethod("WriteLiteral")
	}
	
	Method getWriteLiteralToMethod() {
    result = getAMethod("WriteLiteralTo")
	}
}