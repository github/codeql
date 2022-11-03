import java
import DataFlow
import semmle.code.java.Reflection
import semmle.code.java.dataflow.FlowSources

/**
 * A call to `java.lang.reflect.Method.invoke`.
 */
class MethodInvokeCall extends MethodAccess {
  MethodInvokeCall() { this.getMethod().hasQualifiedName("java.lang.reflect", "Method", "invoke") }
}

/**
 * Unsafe reflection sink (the qualifier or method arguments to `Constructor.newInstance(...)` or `Method.invoke(...)`)
 */
class UnsafeReflectionSink extends DataFlow::ExprNode {
  UnsafeReflectionSink() {
    exists(MethodAccess ma |
      (
        ma.getMethod().hasQualifiedName("java.lang.reflect", "Constructor<>", "newInstance") or
        ma instanceof MethodInvokeCall
      ) and
      this.asExpr() = [ma.getQualifier(), ma.getAnArgument()]
    )
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that looks like resolving a class.
 * A method probably resolves a class if it takes a string, returns a Class
 * and its name contains "resolve", "load", etc.
 */
predicate looksLikeResolveClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m, int i, Expr arg |
    m = ma.getMethod() and arg = ma.getArgument(i)
  |
    m.getReturnType() instanceof TypeClass and
    m.getName().toLowerCase().regexpMatch("resolve|load|class|type") and
    arg.getType() instanceof TypeString and
    arg = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that looks like instantiating a class.
 * A method probably instantiates a class if it is external, takes a Class, returns an Object
 * and its name contains "instantiate" or similar terms.
 */
predicate looksLikeInstantiateClassStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m, int i, Expr arg |
    m = ma.getMethod() and arg = ma.getArgument(i)
  |
    m.getReturnType() instanceof TypeObject and
    m.getName().toLowerCase().regexpMatch("instantiate|instance|create|make|getbean") and
    arg.getType() instanceof TypeClass and
    arg = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}
