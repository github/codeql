import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps

/**
 * An Additional taint step that connect a map like object to its key and values
 */
private class KtorStringValuesStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(MethodCall mc |
      mc.getMethod().hasQualifiedName("io.ktor.util", "StringValues", "forEach")
    |
      pred.asExpr() = mc.getQualifier() and
      succ.asExpr() = mc.getArgument(0).(LambdaExpr).asMethod().getAParameter().getAnAccess()
    )
  }
}
