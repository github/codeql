/**
 * Provides classes for modeling CodeIgniter framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A CodeIgniter input method call.
 */
class CodeIgniterInputMethod extends MethodCall {
  CodeIgniterInputMethod() {
    this.getMethodName() in [
      "get", "post", "get_post", "cookie", "server", "request",
      "input_stream", "set_cookie"
    ]
  }
}

/**
 * A CodeIgniter database method call.
 */
class CodeIgniterDbCall extends MethodCall {
  CodeIgniterDbCall() {
    this.getMethodName() in [
      "query", "where", "or_where", "where_in", "or_where_in",
      "like", "or_like", "not_like",
      "select", "from", "join", "order_by", "group_by", "having",
      "limit", "offset", "get", "get_where",
      "insert", "update", "delete", "truncate"
    ]
  }
}

/**
 * A CodeIgniter unsafe query.
 */
class CodeIgniterUnsafeQuery extends MethodCall {
  CodeIgniterUnsafeQuery() {
    this.getMethodName() = "query"
  }
}

/**
 * A CodeIgniter view loading call.
 */
class CodeIgniterOutput extends MethodCall {
  CodeIgniterOutput() {
    this.getMethodName() in ["view", "set_output", "append_output"]
  }
}

/**
 * A CodeIgniter escape function.
 */
class CodeIgniterEscape extends MethodCall {
  CodeIgniterEscape() {
    this.getMethodName() in ["escape", "escape_str", "escape_like_str"]
  }
}
