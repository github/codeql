deprecated module;

import java
import semmle.code.java.dataflow.FlowSources

/** A sink for JShell expression injection vulnerabilities. */
class JShellInjectionSink extends DataFlow::Node {
  JShellInjectionSink() {
    this.asExpr() = any(JShellEvalCall jsec).getArgument(0)
    or
    this.asExpr() = any(SourceCodeAnalysisWrappersCall scawc).getArgument(0)
  }
}

/** A call to `JShell.eval`. */
private class JShellEvalCall extends MethodCall {
  JShellEvalCall() {
    this.getMethod().hasName("eval") and
    this.getMethod().getDeclaringType().hasQualifiedName("jdk.jshell", "JShell") and
    this.getMethod().getNumberOfParameters() = 1
  }
}

/** A call to `SourceCodeAnalysis.wrappers`. */
private class SourceCodeAnalysisWrappersCall extends MethodCall {
  SourceCodeAnalysisWrappersCall() {
    this.getMethod().hasName("wrappers") and
    this.getMethod().getDeclaringType().hasQualifiedName("jdk.jshell", "SourceCodeAnalysis") and
    this.getMethod().getNumberOfParameters() = 1
  }
}

/** A call to `SourceCodeAnalysis.analyzeCompletion`. */
class SourceCodeAnalysisAnalyzeCompletionCall extends MethodCall {
  SourceCodeAnalysisAnalyzeCompletionCall() {
    this.getMethod().hasName("analyzeCompletion") and
    this.getMethod()
        .getDeclaringType()
        .getAnAncestor()
        .hasQualifiedName("jdk.jshell", "SourceCodeAnalysis") and
    this.getMethod().getNumberOfParameters() = 1
  }
}

/** A call to `CompletionInfo.source` or `CompletionInfo.remaining`. */
class CompletionInfoSourceOrRemainingCall extends MethodCall {
  CompletionInfoSourceOrRemainingCall() {
    this.getMethod().getName() in ["source", "remaining"] and
    this.getMethod()
        .getDeclaringType()
        .getAnAncestor()
        .hasQualifiedName("jdk.jshell", "SourceCodeAnalysis$CompletionInfo") and
    this.getMethod().getNumberOfParameters() = 0
  }
}
