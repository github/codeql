/**
 * @name Arbitrary file write extracting an archive containing symbolic links
 * @description Extracting files from a malicious zip archive without validating that the
 *              destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten. Extracting symbolic links in particular
 *              requires resolving previously extracted links to ensure the destination directory
 *              is not escaped.
 * @kind path-problem
 * @id go/unsafe-unzip-symlink
 * @problem.severity error
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import go
import DataFlow::PathGraph

/** A file name from a zip or tar entry, as a source for unsafe unzipping of symlinks. */
class FileNameSource extends DataFlow::FieldReadNode {
  FileNameSource() {
    getField().hasQualifiedName("archive/zip", "File", ["Name", "Data"]) or
    getField().hasQualifiedName("archive/tar", "Header", ["Name", "Linkname"])
  }
}

/**
 * Gets a read from `archive/zip.Reader.File` or a call to `archive/tar.Reader.Next()`.
 */
Expr getAnArchiveEntryAccess() {
  result =
    any(DataFlow::FieldReadNode frn | frn.readsField(_, "archive/zip", "Reader", "File")).asExpr() or
  result =
    any(DataFlow::MethodCallNode mcn |
      mcn.getTarget().hasQualifiedName("archive/tar", "Reader", "Next")
    ).asExpr()
}

/**
 * Gets a `CallNode` that may call `node`'s enclosing function.
 */
private DataFlow::CallNode getACaller(DataFlow::CallNode node) {
  result.getACallee() = node.getEnclosingCallable()
}

/**
 * Gets a call expression that may call `node`'s enclosing function.
 */
private Expr getAnExprCaller(Expr node) {
  exists(DataFlow::CallNode exprNode | exprNode = DataFlow::exprNode(node) |
    result = getACaller(exprNode).asExpr()
  )
}

/**
 * Gets `e`'s parent, where that parent is not a `LoopStmt`.
 */
AstNode getNonLoopParent(AstNode e) { result = e.getParent() and not result instanceof LoopStmt }

/**
 * Gets `e`'s closest enclosing function-local loop statement, if one exists.
 */
LoopStmt getLocalEnclosingLoop(Expr e) { result = getNonLoopParent*(e).getParent() }

/**
 * Gets one of `e`'s enclosing loop statements, including looking across function calls.
 *
 * The returned loops are the closest loop on their particular path (i.e., this might return
 * multiple results, but no result encloses any other).
 */
LoopStmt getAnEnclosingLoop(Expr e) {
  result = getLocalEnclosingLoop(e)
  or
  not exists(getLocalEnclosingLoop(e)) and result = getAnEnclosingLoop(getAnExprCaller(e))
}

/**
 * Gets a loop statement that contains either a read from `archive/zip.Reader.File` or a call to `archive/tar.Reader.Next()`.
 */
LoopStmt getAnExtractionLoop() { result = getAnEnclosingLoop(getAnArchiveEntryAccess()) }

/**
 * An argument to a call to `os.Symlink` within a loop that extracts a zip or tar archive,
 * taken as a sink for unsafe unzipping of symlinks.
 */
class SymlinkSink extends DataFlow::Node {
  SymlinkSink() {
    exists(DataFlow::CallNode n | n.getTarget().hasQualifiedName("os", "Symlink") |
      this = n.getArgument([0, 1]) and
      getAnEnclosingLoop(n.asExpr()) = getAnExtractionLoop()
    )
  }
}

/**
 * An argument to `path/filepath.EvalSymlinks`, taken as a sink for detecting target paths
 * that are likely safe to extract to.
 */
class EvalSymlinksSink extends DataFlow::Node {
  EvalSymlinksSink() {
    this =
      any(DataFlow::CallNode n | n.getTarget().hasQualifiedName("path/filepath", "EvalSymlinks"))
          .getArgument(0)
  }
}

/**
 * Taint-flow configuration tracking archive header fields flowing to a `path/filepath.EvalSymlinks` call.
 */
class EvalSymlinksConfiguration extends TaintTracking2::Configuration {
  EvalSymlinksConfiguration() { this = "Archive header field flow to `path/filepath.EvalSymlinks`" }

  override predicate isSource(DataFlow::Node source) { source instanceof FileNameSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof EvalSymlinksSink }
}

/**
 * Holds if `node` is an archive header field read that flows to a `path/filepath.EvalSymlinks` call.
 */
predicate symlinksEvald(DataFlow::Node node) {
  exists(EvalSymlinksConfiguration c | c.hasFlow(getASimilarReadNode(node), _))
}

/**
 * Taint-flow configuration tracking archive header fields flowing to an `os.Symlink` call,
 * which never flow to a `path/filepath.EvalSymlinks` call.
 */
class SymlinkConfiguration extends TaintTracking::Configuration {
  SymlinkConfiguration() { this = "Unsafe unzipping of symlinks" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof FileNameSource and
    not symlinksEvald(source)
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SymlinkSink }
}

from SymlinkConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select source.getNode(), source, sink,
  "Unresolved path from an archive header, which may point outside the archive root, is used in $@.",
  sink.getNode(), "symlink creation"
