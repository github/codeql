import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking

/** The class `java.io.FileInputStream`. */
class TypeFileInputStream extends Class {
  TypeFileInputStream() { this.hasQualifiedName("java.io", "FileInputStream") }
}

/** Models additional taint steps like `file.toPath()`, `path.toFile()`, `new FileInputStream(..)`, `Files.readAll{Bytes|Lines}(...)`, and `new File(...)`. */
class PathAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    inputStreamReadsFromFile(node1, node2)
    or
    isFileToPath(node1, node2)
    or
    isPathToFile(node1, node2)
    or
    readsAllFromPath(node1, node2)
    or
    taintedNewFile(node1, node2)
  }
}

/** Holds if `node1` is converted to `node2` via a call to `node1.toPath()`. */
private predicate isFileToPath(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFile and
    call.getMethod().hasName("toPath") and
    call = node2.asExpr() and
    call.getQualifier() = node1.asExpr()
  )
}

/** Holds if `node1` is converted to `node2` via a call to `node1.toFile()`. */
private predicate isPathToFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypePath and
    call.getMethod().hasName("toFile") and
    call = node2.asExpr() and
    call.getQualifier() = node1.asExpr()
  )
}

/** Holds if `node1` is read by `node2` via a call to `Files.readAllBytes(node1)` or `Files.readAllLines(node1)`. */
private predicate readsAllFromPath(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess call |
    call.getReceiverType() instanceof TypeFiles and
    call.getMethod().hasName(["readAllBytes", "readAllLines"]) and
    call = node2.asExpr() and
    call.getArgument(0) = node1.asExpr()
  )
}

/** Holds if `node1` is passed to `node2` via a call to `new FileInputStream(node1)`. */
private predicate inputStreamReadsFromFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall call |
    call.getConstructedType() instanceof TypeFileInputStream and
    call = node2.asExpr() and
    call.getAnArgument() = node1.asExpr()
  )
}

/** Holds if `node1` is passed to `node2` via a call to `new File(node1)`. */
private predicate taintedNewFile(DataFlow::Node node1, DataFlow::Node node2) {
  exists(ConstructorCall call |
    call.getConstructedType() instanceof TypeFile and
    call = node2.asExpr() and
    call.getAnArgument() = node1.asExpr()
  )
}
