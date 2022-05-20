/** Provides classes for identifying expressions that might be sanitized. */

import csharp
private import semmle.code.csharp.frameworks.system.Net
private import semmle.code.csharp.frameworks.system.Web
private import semmle.code.csharp.frameworks.System

/**
 * An expression that should be treated as Html encoded.
 */
class HtmlSanitizedExpr extends Expr {
  HtmlSanitizedExpr() {
    exists(Method m |
      m = any(SystemWebHttpUtility h).getAnHtmlEncodeMethod() or
      m = any(SystemWebHttpServerUtility h).getAnHtmlEncodeMethod() or
      m = any(SystemWebHttpUtility c).getAnHtmlAttributeEncodeMethod() or
      m = any(SystemNetWebUtility h).getAnHtmlEncodeMethod()
    |
      // All four utility classes provide the same pair of Html[Attribute]Encode methods:
      //
      //  - `string Html[Attribute]Encode(string value)`
      //  - `void Html[Attribute]Encode(string value, TextWriter output)`
      //
      // In the first form, we treat the call as sanitized, and in the second form
      // we treat any subsequent uses of the `output` argument as sanitized.
      m.getNumberOfParameters() = 1 and
      this = m.getACall()
      or
      exists(AssignableRead arg, MethodCall mc |
        m = mc.getTarget() and
        arg = mc.getArgumentForParameter(m.getParameter(1)) and
        this = arg.getANextRead()
      )
    )
  }
}

/**
 * An expression that should be treated as URL encoded.
 */
class UrlSanitizedExpr extends Expr {
  UrlSanitizedExpr() {
    exists(Method m |
      m = any(SystemWebHttpUtility c).getAnUrlEncodeMethod() or
      m = any(SystemWebHttpServerUtility c).getAnUrlEncodeMethod() or
      m = any(SystemNetWebUtility c).getAnUrlEncodeMethod()
    |
      this = m.getACall()
    )
  }
}

/**
 * An expression node with a simple type.
 */
class SimpleTypeSanitizedExpr extends DataFlow::ExprNode {
  SimpleTypeSanitizedExpr() { this.getType() instanceof SimpleType }
}

/**
 * An expression node with type `System.Guid`.
 */
class GuidSanitizedExpr extends DataFlow::ExprNode {
  GuidSanitizedExpr() { this.getType() instanceof SystemGuid }
}
