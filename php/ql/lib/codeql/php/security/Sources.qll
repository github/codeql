import codeql.php.ast.internal.TreeSitter

/**
 * Very small, syntax-based model of untrusted input sources.
 *
 * MVP: only recognizes direct reads from PHP superglobals (for example `$_GET["x"]`).
 */
module PhpSecuritySources {
  /** Holds if `name` is the name of a PHP superglobal variable (without the leading `$`). */
  predicate isSuperglobalName(string name) {
    name in [
      "_GET",
      "_POST",
      "_COOKIE",
      "_REQUEST",
      "_SERVER",
      "_FILES",
      "_ENV"
    ]
  }

  /** Holds if `v` is a superglobal variable name. */
  predicate isSuperglobalVar(Php::VariableName v) {
    isSuperglobalName(v.getChild().getValue())
  }

  /** Holds if `node` has (transitively) a superglobal variable-name descendant. */
  predicate hasSuperglobalDescendant(Php::AstNode node) {
    exists(Php::VariableName v | v = node and isSuperglobalVar(v)) or
    exists(Php::AstNode child | child = node.getAFieldOrChild() and hasSuperglobalDescendant(child))
  }

  /** Holds if `e` is an expression that directly uses a superglobal. */
  predicate isUntrustedSourceExpr(Php::Expression e) { hasSuperglobalDescendant(e) }
}
