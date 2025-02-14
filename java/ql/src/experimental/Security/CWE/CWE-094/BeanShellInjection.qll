deprecated module;

import java
import semmle.code.java.dataflow.FlowSources

/** A call to `Interpreter.eval`. */
class InterpreterEvalCall extends MethodCall {
  InterpreterEvalCall() {
    this.getMethod().hasName("eval") and
    this.getMethod().getDeclaringType().hasQualifiedName("bsh", "Interpreter")
  }
}

/** A call to `BshScriptEvaluator.evaluate`. */
class BshScriptEvaluatorEvaluateCall extends MethodCall {
  BshScriptEvaluatorEvaluateCall() {
    this.getMethod().hasName("evaluate") and
    this.getMethod()
        .getDeclaringType()
        .hasQualifiedName("org.springframework.scripting.bsh", "BshScriptEvaluator")
  }
}

/** A sink for BeanShell expression injection vulnerabilities. */
class BeanShellInjectionSink extends DataFlow::Node {
  BeanShellInjectionSink() {
    this.asExpr() = any(InterpreterEvalCall iec).getArgument(0) or
    this.asExpr() = any(BshScriptEvaluatorEvaluateCall bseec).getArgument(0)
  }
}
