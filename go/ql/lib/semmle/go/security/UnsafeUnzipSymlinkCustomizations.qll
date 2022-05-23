/**
 * Provides default sources, sinks and sanitizers for reasoning about zip-slip
 * vulnerabilities, as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * zip-slip vulnerabilities.
 */
module UnsafeUnzipSymlink {
  /**
   * A data-flow source of filenames that may contain unresolved symbolic links.
   */
  abstract class FilenameWithSymlinks extends DataFlow::Node { }

  /**
   * A data flow sink for an unsafe symbolic-link unzip vulnerability.
   */
  abstract class SymlinkSink extends DataFlow::Node { }

  /**
   * A data flow sink at which symbolic links are resolved.
   *
   * `FilenameWithSymlinks` sources that reach such a sink are excluded from the
   * `go/unsafe-unzip-symlink` query.
   */
  abstract class EvalSymlinksSink extends DataFlow::Node { }

  /**
   * A data-flow sanitizer that prevents reaching an `EvalSymlinksSink`.
   *
   * This is called an invalidator instead of a sanitizer because reaching a EvalSymlinksSink
   * is a good thing from a security perspective.
   */
  abstract class EvalSymlinksInvalidator extends DataFlow::Node { }

  /**
   * A sanitizer guard that prevents reaching an `EvalSymlinksSink`.
   *
   * This is called an invalidator instead of a sanitizer because reaching a EvalSymlinksSink
   * is a good thing from a security perspective.
   */
  abstract class EvalSymlinksInvalidatorGuard extends DataFlow::BarrierGuard { }

  /**
   * A sanitizer for an unsafe symbolic-link unzip vulnerability.
   *
   * Extend this to mark a particular path as safe for use in an `os.Symlink` or similar call.
   * To exclude a source from the query entirely if it reaches a particular node, extend
   * `EvalSymlinksSink` instead.
   */
  abstract class SymlinkSanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for an unsafe symbolic-link unzip vulnerability.
   *
   * Extend this to mark a particular path as safe for use in an `os.Symlink` or similar call.
   * To exclude a source from the query entirely if it reaches a particular node, extend
   * `EvalSymlinksSink` instead.
   */
  abstract class SymlinkSanitizerGuard extends DataFlow::BarrierGuard { }

  /** A file name from a zip or tar entry, as a source for unsafe unzipping of symlinks. */
  class FileNameSource extends FilenameWithSymlinks, DataFlow::FieldReadNode {
    FileNameSource() {
      getField().hasQualifiedName("archive/zip", "File", ["Name", "Data"]) or
      getField().hasQualifiedName("archive/tar", "Header", ["Name", "Linkname"])
    }
  }

  /**
   * Gets a read from `archive/zip.Reader.File` or a call to `archive/tar.Reader.Next()`.
   */
  private Expr getAnArchiveEntryAccess() {
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
    result.getACallee() = node.getRoot()
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
  private AstNode getNonLoopParent(AstNode e) {
    result = e.getParent() and not result instanceof LoopStmt
  }

  /**
   * Gets `e`'s closest enclosing function-local loop statement, if one exists.
   */
  private LoopStmt getLocalEnclosingLoop(Expr e) { result = getNonLoopParent*(e).getParent() }

  /**
   * Gets a call expression that may call `node`'s enclosing function if `node` has no local enclosing loop.
   */
  private Expr getAnExprCallerIfNotInLoop(Expr node) {
    not exists(getLocalEnclosingLoop(node)) and
    result = getAnExprCaller(node)
  }

  /**
   * Gets a call to `os.Symlink`.
   */
  private CallExpr getASymlinkCall() { result.getTarget().hasQualifiedName("os", "Symlink") }

  /**
   * Gets the closest enclosing loop to an `os.Symlink` call, `archive/tar.Reader.Next` call or
   * read from `archive/zip.Reader.File`.
   */
  private LoopStmt getAnExtractionOrSymlinkLoop(Expr e) {
    (e = getASymlinkCall() or e = getAnArchiveEntryAccess()) and
    result = getLocalEnclosingLoop(getAnExprCallerIfNotInLoop*(e))
  }

  /**
   * Gets a loop statement that contains either a read from `archive/zip.Reader.File` or a call to `archive/tar.Reader.Next()`.
   */
  private LoopStmt getAnExtractionLoop() {
    result = getAnExtractionOrSymlinkLoop(getAnArchiveEntryAccess())
  }

  /**
   * An argument to a call to `os.Symlink` within a loop that extracts a zip or tar archive,
   * taken as a sink for unsafe unzipping of symlinks.
   */
  class OsSymlink extends DataFlow::Node, SymlinkSink {
    OsSymlink() {
      exists(DataFlow::CallNode n | n.asExpr() = getASymlinkCall() |
        this = n.getArgument([0, 1]) and
        getAnExtractionOrSymlinkLoop(n.asExpr()) = getAnExtractionLoop()
      )
    }
  }

  /**
   * An argument to `path/filepath.EvalSymlinks` or `os.Readlink`, taken as a sink for detecting target
   * paths that are likely safe to extract to.
   */
  class StdlibSymlinkResolvers extends DataFlow::Node, EvalSymlinksSink {
    StdlibSymlinkResolvers() {
      exists(DataFlow::CallNode n |
        n.getTarget().hasQualifiedName("path/filepath", "EvalSymlinks")
        or
        n.getTarget().hasQualifiedName("os", "Readlink")
      |
        this = n.getArgument(0)
      )
    }
  }
}
