/**
 * Provides classes for modeling WordPress framework patterns.
 *
 * This module covers WordPress-specific patterns:
 * - User input handling
 * - Database queries with $wpdb
 * - Output and escaping
 * - Nonce verification
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A WordPress user input function.
 */
class WordPressUserInputFunction extends FunctionCall {
  WordPressUserInputFunction() {
    this.getFunctionName() in [
      "get_option", "get_post_meta", "get_user_meta", "get_term_meta",
      "get_query_var", "get_permalink", "get_the_title", "get_the_content"
    ]
  }
}

/**
 * A WordPress database method call ($wpdb->method()).
 */
class WordPressDbMethodCall extends MethodCall {
  WordPressDbMethodCall() {
    // Check if the object is $wpdb variable
    exists(Variable v | v = this.getObject() | v.getName() = "wpdb")
  }

  /** Gets the method name. */
  string getDbMethodName() { result = this.getMethodName() }
}

/**
 * A WordPress database query method (potentially unsafe).
 */
class WordPressDbQuery extends WordPressDbMethodCall {
  WordPressDbQuery() {
    this.getMethodName() in ["query", "get_results", "get_row", "get_var", "get_col"]
  }

  /** Gets the query argument. */
  TS::PHP::AstNode getQueryArgument() { result = this.getArgument(0) }
}

/**
 * A WordPress prepared statement.
 */
class WordPressPrepare extends WordPressDbMethodCall {
  WordPressPrepare() { this.getMethodName() = "prepare" }

  /** Gets the query template argument. */
  TS::PHP::AstNode getQueryTemplate() { result = this.getArgument(0) }
}

/**
 * A WordPress safe insert/update method.
 */
class WordPressSafeDbMethod extends WordPressDbMethodCall {
  WordPressSafeDbMethod() {
    this.getMethodName() in ["insert", "update", "delete", "replace"]
  }

  /** Gets the table name argument. */
  TS::PHP::AstNode getTableArgument() { result = this.getArgument(0) }

  /** Gets the data argument. */
  TS::PHP::AstNode getDataArgument() { result = this.getArgument(1) }
}

/**
 * A WordPress escaping function (sanitizers).
 */
class WordPressEscapeFunction extends FunctionCall {
  string escapeType;

  WordPressEscapeFunction() {
    exists(string name | name = this.getFunctionName() |
      name = "esc_html" and escapeType = "HTML"
      or
      name = "esc_attr" and escapeType = "attribute"
      or
      name = "esc_textarea" and escapeType = "textarea"
      or
      name = "esc_url" and escapeType = "URL"
      or
      name = "esc_js" and escapeType = "JavaScript"
      or
      name = "esc_sql" and escapeType = "SQL"
      or
      name = "wp_kses" and escapeType = "KSES"
      or
      name = "wp_kses_post" and escapeType = "KSES_post"
    )
  }

  /** Gets the escape type. */
  string getEscapeType() { result = escapeType }
}

/**
 * A WordPress sanitization function.
 */
class WordPressSanitizeFunction extends FunctionCall {
  WordPressSanitizeFunction() {
    this.getFunctionName() in [
      "sanitize_text_field", "sanitize_email", "sanitize_url", "sanitize_file_name",
      "sanitize_title", "sanitize_user", "sanitize_key", "sanitize_meta",
      "wp_unslash", "absint", "intval"
    ]
  }
}

/**
 * A WordPress nonce function (CSRF protection).
 */
class WordPressNonceFunction extends FunctionCall {
  WordPressNonceFunction() {
    this.getFunctionName() in [
      "wp_verify_nonce", "wp_nonce_field", "wp_nonce_url", "wp_create_nonce",
      "check_admin_referer", "check_ajax_referer"
    ]
  }
}

/**
 * A WordPress capability check function (authorization).
 */
class WordPressCapabilityCheck extends FunctionCall {
  WordPressCapabilityCheck() {
    this.getFunctionName() in [
      "current_user_can", "user_can", "author_can", "has_cap"
    ]
  }

  /** Gets the capability being checked. */
  TS::PHP::AstNode getCapabilityArgument() { result = this.getArgument(0) }
}

/**
 * A WordPress hook registration function.
 */
class WordPressHookFunction extends FunctionCall {
  WordPressHookFunction() {
    this.getFunctionName() in [
      "add_action", "add_filter", "remove_action", "remove_filter",
      "do_action", "apply_filters", "has_action", "has_filter"
    ]
  }

  /** Gets the hook name argument. */
  TS::PHP::AstNode getHookNameArgument() { result = this.getArgument(0) }

  /** Gets the callback argument, if present. */
  TS::PHP::AstNode getCallbackArgument() { result = this.getArgument(1) }
}

/**
 * A WordPress AJAX handler registration.
 */
class WordPressAjaxHandler extends WordPressHookFunction {
  WordPressAjaxHandler() {
    this.getFunctionName() = "add_action" and
    exists(StringLiteral s | s = this.getArgument(0) |
      s.getValue().regexpMatch("wp_ajax(_nopriv)?_.*")
    )
  }
}

/**
 * A WordPress output function (echo with translation).
 */
class WordPressOutputFunction extends FunctionCall {
  WordPressOutputFunction() {
    this.getFunctionName() in [
      "_e", "esc_html_e", "esc_attr_e",
      "the_content", "the_excerpt", "the_title", "the_permalink"
    ]
  }
}

/**
 * A WordPress translation function.
 */
class WordPressTranslationFunction extends FunctionCall {
  WordPressTranslationFunction() {
    this.getFunctionName() in [
      "__", "_e", "_x", "_ex", "_n", "_nx", "_n_noop", "_nx_noop",
      "esc_html__", "esc_html_e", "esc_html_x",
      "esc_attr__", "esc_attr_e", "esc_attr_x"
    ]
  }
}

/**
 * A WordPress option function.
 */
class WordPressOptionFunction extends FunctionCall {
  WordPressOptionFunction() {
    this.getFunctionName() in [
      "get_option", "update_option", "add_option", "delete_option",
      "get_site_option", "update_site_option", "add_site_option", "delete_site_option"
    ]
  }

  /** Gets the option name argument. */
  TS::PHP::AstNode getOptionNameArgument() { result = this.getArgument(0) }
}

/**
 * A WordPress transient function.
 */
class WordPressTransientFunction extends FunctionCall {
  WordPressTransientFunction() {
    this.getFunctionName() in [
      "get_transient", "set_transient", "delete_transient",
      "get_site_transient", "set_site_transient", "delete_site_transient"
    ]
  }
}

/**
 * A WordPress REST API endpoint registration.
 */
class WordPressRestEndpoint extends FunctionCall {
  WordPressRestEndpoint() {
    this.getFunctionName() = "register_rest_route"
  }

  /** Gets the namespace argument. */
  TS::PHP::AstNode getNamespaceArgument() { result = this.getArgument(0) }

  /** Gets the route pattern argument. */
  TS::PHP::AstNode getRouteArgument() { result = this.getArgument(1) }
}

// ---- Additional aliases for AllFrameworks.qll compatibility ----

/**
 * WordPress user input method call (alias for AllFrameworks).
 */
class WordPressUserInput extends MethodCall {
  WordPressUserInput() {
    this.getMethodName() in ["get", "post", "request", "cookie", "server", "files"]
  }
}

/**
 * WordPress unsafe query (alias for AllFrameworks).
 */
class WordPressUnsafeQuery extends WordPressDbQuery {
  WordPressUnsafeQuery() {
    this.getMethodName() in ["query", "get_results", "get_row", "get_var"]
  }
}

/**
 * WordPress output method (alias for AllFrameworks).
 */
class WordPressOutput extends MethodCall {
  WordPressOutput() {
    this.getMethodName() in ["render", "display", "output", "send"]
  }
}

/**
 * WordPress escape method (alias for AllFrameworks).
 */
class WordPressEscape extends MethodCall {
  WordPressEscape() {
    this.getMethodName() in ["escape", "escapeHtml", "escapeAttr"]
  }
}

/**
 * WordPress nonce check method (alias for AllFrameworks).
 */
class WordPressNonceCheck extends MethodCall {
  WordPressNonceCheck() {
    this.getMethodName() in ["verify_nonce", "check_admin_referer"]
  }
}
