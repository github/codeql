/**
 * @name Local Android DoS Caused By NumberFormatException
 * @id java/android/nfe-local-android-dos
 * @description NumberFormatException thrown but not caught by an Android application that allows external inputs can crash the application, which is a local Denial of Service (Dos) attack.
 * @kind path-problem
 * @tags security
 *       external/cwe/cwe-755
 */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.frameworks.android.WebView
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

/** Code from java/ql/src/Violations of Best Practice/Exception Handling/NumberFormatException.ql */
private class SpecialMethodAccess extends MethodAccess {
  predicate isValueOfMethod(string klass) {
    this.getMethod().getName() = "valueOf" and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String")
  }

  predicate isParseMethod(string klass, string name) {
    this.getMethod().getName() = name and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass)
  }

  predicate throwsNFE() {
    this.isParseMethod("Byte", "parseByte") or
    this.isParseMethod("Short", "parseShort") or
    this.isParseMethod("Integer", "parseInt") or
    this.isParseMethod("Long", "parseLong") or
    this.isParseMethod("Float", "parseFloat") or
    this.isParseMethod("Double", "parseDouble") or
    this.isParseMethod("Byte", "decode") or
    this.isParseMethod("Short", "decode") or
    this.isParseMethod("Integer", "decode") or
    this.isParseMethod("Long", "decode") or
    this.isValueOfMethod("Byte") or
    this.isValueOfMethod("Short") or
    this.isValueOfMethod("Integer") or
    this.isValueOfMethod("Long") or
    this.isValueOfMethod("Float") or
    this.isValueOfMethod("Double")
  }
}

private class SpecialClassInstanceExpr extends ClassInstanceExpr {
  predicate isStringConstructor(string klass) {
    this.getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String") and
    this.getNumArgument() = 1
  }

  predicate throwsNFE() {
    this.isStringConstructor("Byte") or
    this.isStringConstructor("Short") or
    this.isStringConstructor("Integer") or
    this.isStringConstructor("Long") or
    this.isStringConstructor("Float") or
    this.isStringConstructor("Double")
  }
}

class NumberFormatException extends RefType {
  NumberFormatException() { this.hasQualifiedName("java.lang", "NumberFormatException") }
}

private predicate catchesNFE(TryStmt t) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getASubtype*() instanceof NumberFormatException
  )
}

private predicate throwsNFE(Expr e) {
  e.(SpecialClassInstanceExpr).throwsNFE() or e.(SpecialMethodAccess).throwsNFE()
}

/**
 * Taint configuration tracking flow from untrusted inputs to number conversion calls.
 */
class NFELocalDoSConfiguration extends TaintTracking::Configuration {
  NFELocalDoSConfiguration() { this = "NFELocalDoSConfiguration" }

  /** Holds if source is a remote flow source */
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  /** Holds if NFE is thrown but not caught */
  override predicate isSink(DataFlow::Node sink) {
    exists(Expr e |
      throwsNFE(e) and
      not exists(TryStmt t |
        t.getBlock() = e.getEnclosingStmt().getEnclosingStmt*() and
        catchesNFE(t)
      ) and
      sink.asExpr() = e
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, NFELocalDoSConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Local Android Denial of Service due to $@.", source.getNode(),
  "user-provided value"
