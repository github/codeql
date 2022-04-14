/**
 * Provides predicates for reasoning about insecure dependency configurations.
 */

private import ruby

/**
 * A method call in a Gemfile.
 */
private class GemfileMethodCall extends MethodCall {
  GemfileMethodCall() { this.getLocation().getFile().getBaseName() = "Gemfile" }
}

/**
 * Method calls that configure gem dependencies and can specify (possibly insecure) URLs.
 */
abstract private class RelevantGemCall extends GemfileMethodCall {
  abstract Expr getAUrlPart();
}

/**
 * A call to `source`.
 */
private class SourceCall extends RelevantGemCall {
  SourceCall() { this.getMethodName() = "source" }

  override Expr getAUrlPart() { result = this.getAnArgument() }
}

/**
 * A call to `git_source`.
 */
private class GitSourceCall extends RelevantGemCall {
  GitSourceCall() { this.getMethodName() = "git_source" }

  override Expr getAUrlPart() { result = this.getBlock().getLastStmt() }
}

/**
 * A call to `gem`.
 */
private class GemCall extends RelevantGemCall {
  GemCall() { this.getMethodName() = "gem" }

  override Expr getAUrlPart() { result = this.getKeywordArgument(["source", "git"]) }
}

/**
 * Holds if `s` is a URL with an insecure protocol. `proto` is the protocol.
 */
bindingset[s]
private predicate hasInsecureProtocol(string s, string proto) {
  proto = s.regexpCapture("^(http|ftp):.+", 1).toUpperCase()
}

/**
 * Holds if `e` is a string containing a URL that uses the insecure protocol `proto`.
 */
private predicate containsInsecureUrl(Expr e, string proto) {
  // Handle cases where the string as a whole has no constant value (due to interpolations)
  // but has a known prefix. E.g. "http://#{foo}"
  exists(StringComponent c | c = e.(StringlikeLiteral).getComponent(0) |
    hasInsecureProtocol(c.getConstantValue().getString(), proto)
  )
  or
  hasInsecureProtocol(e.getConstantValue().getString(), proto)
}

/**
 * Returns the suggested protocol to use in place of the insecure protocol `proto`.
 */
bindingset[proto]
private string suggestedProtocol(string proto) {
  proto = "HTTP" and result = "HTTPS"
  or
  proto = "FTP" and result = "FTPS or SFTP"
}

/**
 * Holds if `url` is a string containing a URL that uses an insecure protocol.
 * `msg` is the alert message that will be displayed to the user.
 */
predicate insecureDependencyUrl(Expr url, string msg) {
  exists(RelevantGemCall call, string proto |
    url = call.getAUrlPart() and
    containsInsecureUrl(url, proto) and
    msg =
      "Dependency source URL uses the unencrypted protocol " + proto + ". Use " +
        suggestedProtocol(proto) + " instead."
  )
}
