/**
 * Provides default sources, sinks and sanitizers for reasoning about zip-slip
 * vulnerabilities, as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * zip-slip vulnerabilities.
 */
module ZipSlip {
  private import TaintedPathCustomizations

  /**
   * A data flow source for zip-slip vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for zip-slip vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for zip-slip vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for zip-slip vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A tar file header, as a source for zip slip.
   */
  class TarHeaderSource extends Source, DataFlow::Node {
    TarHeaderSource() {
      this =
        any(DataFlow::MethodCallNode mcn |
          mcn.getTarget().hasQualifiedName("archive/tar", "Reader", "Next")
        ).getResult(0)
    }
  }

  /**
   * A zip file header, as a source for zip slip.
   */
  class ZipHeaderSource extends Source {
    ZipHeaderSource() {
      exists(DataFlow::FieldReadNode frn, DataFlow::Node elbase |
        frn.getField().hasQualifiedName("archive/zip", "Reader", "File") and
        DataFlow::localFlow(frn, elbase)
      |
        DataFlow::readsAnElement(this, elbase)
      )
    }
  }

  /**
   * Excludes zipped file data from consideration for zip slip.
   */
  class ZipFileOpen extends Sanitizer {
    ZipFileOpen() {
      this =
        any(DataFlow::MethodCallNode mcn |
          mcn.getTarget().hasQualifiedName("archive/zip", "File", "Open")
        ).getResult(0)
    }
  }

  /** A path-traversal sink, considered as a taint sink for zip slip. */
  class TaintedPathSinkAsSink extends Sink {
    TaintedPathSinkAsSink() {
      this instanceof TaintedPath::Sink and
      // Exclude `os.Symlink`, which is treated specifically in query `go/unsafe-unzip-symlink`.
      not exists(DataFlow::CallNode c | c.getTarget().hasQualifiedName("os", "Symlink") |
        this = c.getAnArgument()
      )
    }
  }

  /** A path-traversal sanitizer, considered as a sanitizer for zip slip. */
  class TaintedPathSanitizerAsSanitizer extends Sanitizer {
    TaintedPathSanitizerAsSanitizer() { this instanceof TaintedPath::Sanitizer }
  }

  pragma[noinline]
  private predicate taintedPathGuardChecks(
    TaintedPath::SanitizerGuard guard, DataFlow::Node checked, boolean branch
  ) {
    guard.checks(checked.asExpr(), branch)
  }

  pragma[noinline]
  private predicate taintFlowsToCheckedNode(DataFlow::Node source, DataFlow::Node checked) {
    taintedPathGuardChecks(_, checked, _) and
    (
      // Manual magic that is equivalent to `localTaint(source, checked)`
      source = checked
      or
      exists(DataFlow::Node succ |
        taintFlowsToCheckedNode(succ, checked) and
        TaintTracking::localTaintStep(source, succ)
      )
    )
  }

  /**
   * A sanitizer guard for zip-slip vulnerabilities which backtracks to sanitize expressions
   * that locally flow into a guarded expression. For example, an ordinary sanitizer guard
   * might say that in `if x { z := y }` the reference to `y` is sanitized because of the guard
   * `x`; these guards say that if the function begins
   * `f(p string) { w := filepath.Join(p); y := filepath.Dir(w) }` then both `p` and `w` are also
   * sanitized as expressions that contributed taint to `y`.
   *
   * This is useful because many sanitizers don't directly check the filename included in an archive
   * header, but some derived expression. It also propagates back from a field reference to its parent
   * (e.g. `hdr.Filename` to `hdr`), increasing the chances that a future reference to `hdr.Filename`
   * will also be regarded as clean (though SSA catches some cases of this).
   */
  class TaintedPathSanitizerGuardAsBacktrackingSanitizerGuard extends SanitizerGuard {
    TaintedPath::SanitizerGuard taintedPathGuard;

    TaintedPathSanitizerGuardAsBacktrackingSanitizerGuard() { this = taintedPathGuard }

    override predicate checks(Expr e, boolean branch) {
      exists(DataFlow::Node source, DataFlow::Node checked |
        taintedPathGuardChecks(taintedPathGuard, checked, branch) and
        taintFlowsToCheckedNode(source, checked)
      |
        e = source.asExpr()
      )
    }
  }
}
