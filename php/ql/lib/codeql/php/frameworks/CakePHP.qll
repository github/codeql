/**
 * Provides classes for modeling CakePHP framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A CakePHP request input method call.
 */
class CakePHPRequestInput extends MethodCall {
  CakePHPRequestInput() {
    this.getMethodName() in [
      "getQuery", "getData", "getParam", "getCookie", "getSession",
      "query", "data", "params"
    ]
  }
}

/**
 * A CakePHP query builder method call.
 */
class CakePHPQueryCall extends MethodCall {
  CakePHPQueryCall() {
    this.getMethodName() in [
      "find", "where", "andWhere", "orWhere", "contain",
      "select", "order", "group", "having", "limit", "offset",
      "first", "all", "toArray", "count"
    ]
  }
}

/**
 * A CakePHP unsafe query (raw SQL).
 */
class CakePHPUnsafeQuery extends MethodCall {
  CakePHPUnsafeQuery() {
    this.getMethodName() in ["query", "execute"]
  }
}

/**
 * A CakePHP view rendering call.
 */
class CakePHPViewRender extends MethodCall {
  CakePHPViewRender() {
    this.getMethodName() in ["render", "set", "viewBuilder"]
  }
}

/**
 * A CakePHP sanitization function.
 */
class CakePHPSanitize extends FunctionCall {
  CakePHPSanitize() {
    this.getFunctionName() in ["h", "htmlspecialchars", "htmlentities"]
  }
}

/**
 * A CakePHP CSRF token check.
 */
class CakePHPCsrfCheck extends MethodCall {
  CakePHPCsrfCheck() {
    this.getMethodName() in ["validateCsrfToken", "csrfCheck", "getParam"] and
    // getParam with "_Token" or "_csrfToken" is often used for CSRF
    exists(string m | m = this.getMethodName() | m != "getParam" or m = "getParam")
  }
}
