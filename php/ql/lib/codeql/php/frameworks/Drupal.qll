/**
 * Provides classes for modeling Drupal framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Drupal user input method call.
 */
class DrupalUserInput extends MethodCall {
  DrupalUserInput() {
    this.getMethodName() in ["get", "getQuery", "getQueryString", "all", "keys"]
  }
}

/**
 * A Drupal database query call.
 */
class DrupalDbQuery extends MethodCall {
  DrupalDbQuery() {
    this.getMethodName() in [
      "query", "select", "insert", "update", "delete", "merge", "truncate",
      "condition", "fields", "values", "execute", "fetchField", "fetchAll",
      "fetchAssoc", "fetchObject", "fetchCol"
    ]
  }
}

/**
 * A Drupal unsafe raw query.
 */
class DrupalUnsafeQuery extends MethodCall {
  DrupalUnsafeQuery() {
    this.getMethodName() = "query"
  }
}

/**
 * A Drupal render call.
 */
class DrupalRender extends MethodCall {
  DrupalRender() {
    this.getMethodName() in ["render", "renderPlain", "renderRoot"]
  }
}

/**
 * A Drupal render function.
 */
class DrupalRenderFunction extends FunctionCall {
  DrupalRenderFunction() {
    this.getFunctionName() in ["render", "drupal_render"]
  }
}

/**
 * A Drupal XSS sanitization.
 */
class DrupalXssSanitizer extends MethodCall {
  DrupalXssSanitizer() {
    this.getMethodName() in ["filter", "filterAdmin", "escape"]
  }
}

/**
 * A Drupal check plain function.
 */
class DrupalCheckPlain extends FunctionCall {
  DrupalCheckPlain() {
    this.getFunctionName() in ["check_plain", "filter_xss", "check_markup"]
  }
}

/**
 * A Drupal CSRF token check.
 */
class DrupalTokenCheck extends MethodCall {
  DrupalTokenCheck() {
    this.getMethodName() in ["validate", "get"]
  }
}
