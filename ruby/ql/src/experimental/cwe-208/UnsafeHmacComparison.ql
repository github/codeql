/**
 * @name Unsafe HMAC Comparison
 * @description An HMAC is being compared using the equality operator.  This may be vulnerable to a cryptographic timing attack
 *              because the equality operation does not occur in constant time."
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.0
 * @precision high
 * @id rb/unsafe-hmac-comparison
 * @tags security
 *       external/cwe/cwe-208
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

private class OpenSslHmacSource extends DataFlow::Node {
  OpenSslHmacSource() {
    exists(API::Node hmacNode | hmacNode = API::getTopLevelMember("OpenSSL").getMember("HMAC") |
      this = hmacNode.getAMethodCall(["hexdigest", "to_s", "digest", "base64digest"])
      or
      this = hmacNode.getAnInstantiation()
    )
  }
}

private module UnsafeHmacComparison {
  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof OpenSslHmacSource }

    // Holds if a given sink is an Equality Operation (== or !=)
    predicate isSink(DataFlow::Node sink) {
      any(EqualityOperation eqOp).getAnOperand() = sink.asExpr().getExpr()
    }
  }

  import DataFlow::Global<Config>
}

private import UnsafeHmacComparison::PathGraph

from UnsafeHmacComparison::PathNode source, UnsafeHmacComparison::PathNode sink
where UnsafeHmacComparison::flowPath(source, sink)
select sink.getNode(), source, sink, "This comparison is potentially vulnerable to a timing attack."
