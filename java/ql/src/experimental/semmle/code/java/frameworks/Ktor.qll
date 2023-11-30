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

predicate findACall(DataFlow::Node pred, string s) {
  exists(Call c |
    c.getCallee().getDeclaringType().hasQualifiedName("io.ktor.server.auth.ldap", "LdapKt")
  |
    pred.asExpr() = c.getArgument(0) and s = c.getCallee().getStringSignature()
  )
}

predicate findAMethod(DataFlow::Node pred, string s) {
  exists(MethodCall mc |
    mc.getMethod().hasQualifiedName("io.ktor.network.sockets", "SocketsKt", "openReadChannel")
  |
    pred.asExpr() = mc.getArgument(0) and
    s = mc.getMethod().getStringSignature()
  )
}

predicate addSteps(DataFlow::Node pred, DataFlow::Node succ) {
  exists(MethodCall m |
    m.getMethod().hasQualifiedName("io.ktor.utils.io.core", "StringsKt", ["readBytes"])
  |
    pred.asExpr() = m.getArgument(0) and
    succ.asExpr() = m
  )
}
