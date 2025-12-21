/**
 * Provides classes for modeling Zend/Laminas framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Laminas request input method call.
 */
class LaminasRequestInput extends MethodCall {
  LaminasRequestInput() {
    this.getMethodName() in [
      "getQuery", "getPost", "getParam", "getParams", "getServer", "getCookie",
      "fromQuery", "fromPost", "fromRoute", "fromFiles"
    ]
  }
}

/**
 * A Laminas database adapter call.
 */
class LaminasDbCall extends MethodCall {
  LaminasDbCall() {
    this.getMethodName() in [
      "query", "execute", "createStatement", "prepare",
      "select", "insert", "update", "delete",
      "where", "from", "join", "order", "group", "having", "limit"
    ]
  }
}

/**
 * A Laminas unsafe query.
 */
class LaminasUnsafeQuery extends MethodCall {
  LaminasUnsafeQuery() {
    this.getMethodName() in ["query", "execute"]
  }
}

/**
 * A Laminas view rendering call.
 */
class LaminasViewRender extends MethodCall {
  LaminasViewRender() {
    this.getMethodName() in ["render", "renderFile", "assign", "setVariable", "setVariables"]
  }
}

/**
 * A Laminas escaper call.
 */
class LaminasEscaper extends MethodCall {
  LaminasEscaper() {
    this.getMethodName() in [
      "escapeHtml", "escapeHtmlAttr", "escapeJs", "escapeCss", "escapeUrl"
    ]
  }
}

/**
 * A Laminas form validation.
 */
class LaminasValidation extends MethodCall {
  LaminasValidation() {
    this.getMethodName() in ["isValid", "validate", "setData", "getData"]
  }
}
