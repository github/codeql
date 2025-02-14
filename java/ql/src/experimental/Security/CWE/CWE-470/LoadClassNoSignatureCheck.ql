/**
 * @name Load 3rd party classes or code ('unsafe reflection') without signature check
 * @description Loading classes or code from third-party packages without checking the
 *              package signature could make the application
 *              susceptible to package namespace squatting attacks,
 *              potentially leading to arbitrary code execution.
 * @problem.severity error
 * @precision high
 * @kind path-problem
 * @id java/android/unsafe-reflection
 * @tags security
 *       experimental
 *       external/cwe/cwe-470
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.SSA
import semmle.code.java.frameworks.android.Intent

class CheckSignaturesGuard extends Guard instanceof EqualityTest {
  MethodCall checkSignatures;

  CheckSignaturesGuard() {
    this.getAnOperand() = checkSignatures and
    checkSignatures
        .getMethod()
        .hasQualifiedName("android.content.pm", "PackageManager", "checkSignatures") and
    exists(Expr signatureCheckResult |
      this.getAnOperand() = signatureCheckResult and signatureCheckResult != checkSignatures
    |
      signatureCheckResult.(CompileTimeConstantExpr).getIntValue() = 0 or
      signatureCheckResult
          .(FieldRead)
          .getField()
          .hasQualifiedName("android.content.pm", "PackageManager", "SIGNATURE_MATCH")
    )
  }

  Expr getCheckedExpr() { result = checkSignatures.getArgument(0) }
}

predicate signatureChecked(Expr safe) {
  exists(CheckSignaturesGuard g, SsaVariable v |
    v.getAUse() = g.getCheckedExpr() and
    safe = v.getAUse() and
    g.controls(safe.getBasicBlock(), g.(EqualityTest).polarity())
  )
}

module InsecureLoadingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    exists(Method m | m = src.asExpr().(MethodCall).getMethod() |
      m.getDeclaringType().getASourceSupertype*() instanceof TypeContext and
      m.hasName("createPackageContext") and
      not signatureChecked(src.asExpr().(MethodCall).getArgument(0))
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod().hasQualifiedName("java.lang", "ClassLoader", "loadClass")
    |
      sink.asExpr() = ma.getQualifier()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall ma, Method m |
      ma.getMethod() = m and
      m.getDeclaringType().getASourceSupertype*() instanceof TypeContext and
      m.hasName("getClassLoader")
    |
      node1.asExpr() = ma.getQualifier() and
      node2.asExpr() = ma
    )
  }
}

module InsecureLoadFlow = TaintTracking::Global<InsecureLoadingConfig>;

import InsecureLoadFlow::PathGraph

deprecated query predicate problems(
  DataFlow::Node sinkNode, InsecureLoadFlow::PathNode source, InsecureLoadFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  InsecureLoadFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Class loaded from a $@ without signature check" and
  sourceNode = source.getNode() and
  message2 = "third party library"
}
