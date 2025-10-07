/** Provides definitions for working with uses of Android external storage */
overlay[local?]
module;

import java
private import semmle.code.java.security.FileReadWrite
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

private predicate externalStorageFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlowStep(node1, node2)
  or
  exists(ConstructorCall c | c.getConstructedType() instanceof TypeFile |
    node1.asExpr() = c.getArgument(0) and
    node2.asExpr() = c
  )
  or
  node2.asExpr().(ArrayAccess).getArray() = node1.asExpr()
  or
  node2.asExpr().(FieldRead).getField().getInitializer() = node1.asExpr()
}

private predicate externalStorageDirFlowsTo(DataFlow::Node n) {
  sourceNode(n, "android-external-storage-dir")
  or
  exists(DataFlow::Node mid | externalStorageDirFlowsTo(mid) and externalStorageFlowStep(mid, n))
}

/**
 * Holds if `n` is a node that reads the contents of an external file in Android.
 * This is controllable by third-party applications, so is treated as a remote flow source.
 */
predicate androidExternalStorageSource(DataFlow::Node n) {
  exists(DirectFileReadExpr read |
    n.asExpr() = read and
    externalStorageDirFlowsTo(DataFlow::exprNode(read.getFileExpr()))
  )
}
