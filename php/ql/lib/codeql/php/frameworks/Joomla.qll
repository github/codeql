/**
 * Provides classes for modeling Joomla framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Joomla user input method call.
 */
class JoomlaUserInput extends MethodCall {
  JoomlaUserInput() {
    this.getMethodName() in [
      "get", "getInt", "getUint", "getFloat", "getBool", "getWord", "getAlnum",
      "getCmd", "getString", "getHtml", "getPath", "getUsername", "getArray"
    ]
  }
}

/**
 * A Joomla database query call.
 */
class JoomlaDbQuery extends MethodCall {
  JoomlaDbQuery() {
    this.getMethodName() in [
      "query", "setQuery", "execute", "loadResult", "loadRow", "loadAssoc",
      "loadObject", "loadColumn", "loadAssocList", "loadObjectList",
      "select", "from", "where", "join", "order", "group", "having", "limit"
    ]
  }
}

/**
 * A Joomla unsafe query.
 */
class JoomlaUnsafeQuery extends MethodCall {
  JoomlaUnsafeQuery() {
    this.getMethodName() in ["setQuery", "query"]
  }
}

/**
 * A Joomla quote method (safe).
 */
class JoomlaSafeQuery extends MethodCall {
  JoomlaSafeQuery() {
    this.getMethodName() in ["quote", "quoteName", "escape"]
  }
}

/**
 * A Joomla output call.
 */
class JoomlaOutput extends MethodCall {
  JoomlaOutput() {
    this.getMethodName() in ["setBuffer", "getBuffer", "render", "display"]
  }
}

/**
 * A Joomla XSS sanitization.
 */
class JoomlaXssSanitizer extends MethodCall {
  JoomlaXssSanitizer() {
    this.getMethodName() in ["escape", "clean", "filter"]
  }
}

/**
 * A Joomla static sanitization call.
 */
class JoomlaStaticSanitizer extends StaticMethodCall {
  JoomlaStaticSanitizer() {
    this.getMethodName() in ["objectHTMLSafe", "escape", "clean"]
  }
}

/**
 * A Joomla token check.
 */
class JoomlaTokenCheck extends MethodCall {
  JoomlaTokenCheck() {
    this.getMethodName() in ["checkToken", "getToken", "getFormToken"]
  }
}
