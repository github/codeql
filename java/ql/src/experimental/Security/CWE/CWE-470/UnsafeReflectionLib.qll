import java
import semmle.code.java.Reflection
import semmle.code.java.dataflow.DataFlow

/**
 * Unsafe reflection sink,
 * e.g `Class.forName(...)` or `ClassLoader.loadClass(...)`.
 */
class UnsafeReflectionSink extends DataFlow::ExprNode {
  UnsafeReflectionSink() {
    exists(ReflectiveClassIdentifierMethodAccess rcima | rcima.getArgument(0) = this.getExpr())
  }
}
