/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being sanitized,
 *              otherwise a malicious user may be able to provide a regex that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

class RegexSink extends DataFlow::ExprNode {
  RegexSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      (
        m.getDeclaringType().hasQualifiedName("java.lang", "String") and
        (
          ma.getArgument(0) = this.asExpr() and
          (
            m.hasName("matches") or
            m.hasName("split") or
            m.hasName("replaceFirst") or
            m.hasName("replaceAll")
          )
        )
        or
        m.getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
        (
          ma.getArgument(0) = this.asExpr() and
          (
            m.hasName("compile") or
            m.hasName("matches")
          )
        )
        or
        m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "RegExUtils") and
        (
          ma.getArgument(1) = this.asExpr() and
          m.getParameterType(1).(Class).hasQualifiedName("java.lang", "String") and
          (
            m.hasName("removeAll") or
            m.hasName("removeFirst") or
            m.hasName("removePattern") or
            m.hasName("replaceAll") or
            m.hasName("replaceFirst") or
            m.hasName("replacePattern")
          )
        )
      )
    )
  }
}

abstract class Sanitizer extends DataFlow::ExprNode { }

class RegExpSanitizationCall extends Sanitizer {
  RegExpSanitizationCall() {
    exists(string calleeName, string sanitize, string regexp |
      calleeName = this.asExpr().(Call).getCallee().getName() and
      sanitize = "(?:escape|saniti[sz]e)" and
      regexp = "regexp?"
    |
      calleeName
          .regexpMatch("(?i)(" + sanitize + ".*" + regexp + ".*)" + "|(" + regexp + ".*" + sanitize +
              ".*)")
    )
  }
}

class RegexInjectionConfiguration extends TaintTracking::Configuration {
  RegexInjectionConfiguration() { this = "RegexInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, RegexInjectionConfiguration c
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ is user controlled.", source.getNode(),
  "This regular expression pattern"
