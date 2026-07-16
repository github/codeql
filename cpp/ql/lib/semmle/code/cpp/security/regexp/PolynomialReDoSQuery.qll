/**
 * Provides classes and predicates for reasoning about polynomial-time
 * regular-expression denial-of-service (ReDoS) vulnerabilities in C++.
 *
 * The library mirrors the Java `PolynomialReDoSQuery` library: it plugs the
 * C++ regex parse-tree view (`semmle.code.cpp.regex.RegexTreeView`) into the
 * shared `SuperlinearBackTracking` analysis, and defines a data-flow
 * configuration that tracks user-controlled data to a subject expression
 * that is matched against a `std::regex` whose parse tree contains a
 * polynomial-backtracking term.
 */

private import cpp
private import semmle.code.cpp.regex.RegexTreeView::RegexTreeView as TreeView
import codeql.regex.nfa.SuperlinearBackTracking::Make<TreeView> as SuperlinearBackTracking
private import semmle.code.cpp.ir.dataflow.DataFlow
private import semmle.code.cpp.ir.dataflow.TaintTracking
private import semmle.code.cpp.regex.RegexFlowConfigs
private import semmle.code.cpp.security.FlowSources

/**
 * A sink for the polynomial ReDoS query: a subject expression that is
 * matched against a `std::regex` whose pattern is a `TreeView::RegExpLiteral`.
 */
class PolynomialRedosSink extends DataFlow::Node {
  TreeView::RegExpLiteral reg;

  PolynomialRedosSink() {
    exists(Expr e |
      regexMatchedAgainst(reg.getRegex(), e) and
      (this.asExpr() = e or this.asIndirectExpr() = e)
    )
  }

  /** Gets a regex term (a child of the matched literal) associated with this sink. */
  TreeView::RegExpTerm getRegExp() { result.getParent() = reg }
}

/**
 * A function whose result typically has a limited length, such as HTTP
 * headers, cookies, request URIs, or their C++ analogues. Values derived
 * from calls to such functions are treated as length-restricted and act as
 * barriers for the polynomial ReDoS analysis.
 *
 * This is a conservative, name-based heuristic: it matches functions whose
 * unqualified name (or declaring class name for member functions) suggests
 * that the returned string is bounded in length in practice.
 */
private class LengthRestrictedFunction extends Function {
  LengthRestrictedFunction() {
    exists(string n | n = this.getName().toLowerCase() |
      n.matches(["%header%", "%cookie%", "%requesturi%", "%requesturl%", "%useragent%"])
    )
    or
    exists(MemberFunction mf, string cls, string n |
      mf = this and
      cls = mf.getDeclaringType().getName().toLowerCase() and
      n = mf.getName().toLowerCase()
    |
      cls.matches("%cookie%") and n.matches("get%")
      or
      cls.matches("%request%") and n.matches(["%get%path%", "get%user%", "%querystring%"])
    )
  }
}

/**
 * Holds if `node` is a value whose static type has a small, fixed size, so
 * that it is treated as length-restricted for the polynomial ReDoS
 * analysis. This includes integral and floating-point values, which cannot
 * usefully be matched against a regex.
 */
private predicate isSmallFixedSizeType(DataFlow::Node node) {
  node.asExpr().getUnspecifiedType() instanceof IntegralType
  or
  node.asExpr().getUnspecifiedType() instanceof FloatingPointType
}

/** A configuration for the polynomial ReDoS query. */
module PolynomialRedosConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(SuperlinearBackTracking::PolynomialBackTrackingTerm regexp |
      regexp.getRootTerm() = sink.(PolynomialRedosSink).getRegExp()
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    isSmallFixedSizeType(node)
    or
    node.asExpr().(Call).getTarget() instanceof LengthRestrictedFunction
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    exists(SuperlinearBackTracking::PolynomialBackTrackingTerm regexp |
      regexp.getRootTerm() = sink.(PolynomialRedosSink).getRegExp()
    |
      result = sink.getLocation()
      or
      result = regexp.getLocation()
    )
  }
}

/** Taint-tracking flow from user input to a polynomial-backtracking regex match. */
module PolynomialRedosFlow = TaintTracking::Global<PolynomialRedosConfig>;
