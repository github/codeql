/**
 * Provides default sources, sinks and sanitizers for reasoning about path-traversal
 * vulnerabilities, as well as extension points for adding your own.
 */

import go
import semmle.go.dataflow.barrierguardutil.RegexpCheck

/**
 * Provides extension points for customizing the taint tracking configuration for reasoning about
 * path-traversal vulnerabilities.
 */
module TaintedPath {
  /**
   * A data flow source for path-traversal vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for path-traversal vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for path-traversal vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for path-traversal vulnerabilities.
   *
   * Note this class should be extended to define more taint-path sanitizer guards, but isn't itself a
   * `DataFlow::BarrierGuard` so that other queries can use this to define `BarrierGuard`s without
   * introducing recursion. The class `SanitizerGuardAsBarrierGuard` plugs all instances of this class
   * into the `DataFlow::BarrierGuard` type hierarchy.
   */
  abstract class SanitizerGuard extends DataFlow::Node {
    abstract predicate checks(Expr e, boolean branch);
  }

  /**
   * A sanitizer guard for path-traversal vulnerabilities, as a `DataFlow::BarrierGuard`.
   *
   * Use this class if you want all `TaintedPath::SanitizerGuard`s as a `DataFlow::BarrierGuard`,
   * e.g. to use directly in a `DataFlow::Configuration::isSanitizerGuard` method. If you want to
   * provide a new instance of a tainted path sanitizer, extend `TaintedPath::SanitizerGuard` instead.
   */
  class SanitizerGuardAsBarrierGuard extends DataFlow::BarrierGuard {
    SanitizerGuard guardImpl;

    SanitizerGuardAsBarrierGuard() { this = guardImpl }

    override predicate checks(Expr e, boolean branch) { guardImpl.checks(e, branch) }
  }

  /** A source of untrusted data, considered as a taint source for path traversal. */
  class UntrustedFlowAsSource extends Source {
    UntrustedFlowAsSource() { this instanceof UntrustedFlowSource }
  }

  /** A path expression, considered as a taint sink for path traversal. */
  class PathAsSink extends Sink {
    PathAsSink() { this = any(FileSystemAccess fsa).getAPathArgument() }
  }

  /**
   * A call to `filepath.Rel`, considered as a sanitizer for path traversal.
   */
  class FilepathRelSanitizer extends Sanitizer {
    FilepathRelSanitizer() {
      exists(Function f, FunctionOutput outp |
        f.hasQualifiedName("path/filepath", "Rel") and
        outp.isResult(0) and
        this = outp.getNode(f.getACall())
      )
    }
  }

  /**
   * A call to `[file]path.Clean("/" + e)`, considered to sanitize `e` against path traversal.
   */
  class FilepathCleanSanitizer extends Sanitizer {
    FilepathCleanSanitizer() {
      exists(DataFlow::CallNode cleanCall, StringOps::Concatenation concatNode |
        cleanCall =
          any(Function f | f.hasQualifiedName(["path", "path/filepath"], "Clean")).getACall() and
        concatNode = cleanCall.getArgument(0) and
        concatNode.getOperand(0).asExpr().(StringLit).getValue() = "/" and
        this = cleanCall.getResult()
      )
    }
  }

  /**
   * A check of the form `!strings.Contains(nd, "..")`, considered as a sanitizer guard for
   * path traversal.
   */
  class DotDotCheck extends SanitizerGuard, DataFlow::CallNode {
    DotDotCheck() {
      exists(string dotdot | dotdot = ".." or dotdot = "../" or dotdot = "..\\" |
        this.getTarget().hasQualifiedName("strings", "Contains") and
        this.getArgument(1).getStringValue() = dotdot
      )
    }

    override predicate checks(Expr e, boolean branch) {
      e = this.getArgument(0).asExpr() and
      branch = false
    }
  }

  /**
   * A node `nd` guarded by a check that ensures it is contained within some root folder,
   * considered as a sanitizer for path traversal.
   *
   * We currently recognize checks of the following form:
   *
   * ```
   * ..., err := filepath.Rel(base, path)
   * if err == nil {
   *   // path is known to be contained in base
   * }
   * ```
   */
  class PathContainmentCheck extends SanitizerGuard, DataFlow::EqualityTestNode {
    DataFlow::Node path;
    boolean outcome;

    PathContainmentCheck() {
      exists(Function f, FunctionInput inp, FunctionOutput outp, DataFlow::Property p |
        f.hasQualifiedName("path/filepath", "Rel") and
        inp.isParameter(1) and
        outp.isResult(1) and
        p.isNil()
      |
        exists(DataFlow::Node call, DataFlow::Node res |
          call = f.getACall() and
          DataFlow::localFlow(outp.getNode(call), res)
        |
          p.checkOn(this, outcome, res) and
          path = inp.getNode(call)
        )
      )
    }

    override predicate checks(Expr e, boolean branch) { e = path.asExpr() and branch = outcome }
  }

  /**
   * A call of the form `strings.HasPrefix(path, ...)` considered as a sanitizer guard
   * for `path`.
   *
   * This is overapproximate: if `path` is not normalized, then checking whether it starts with
   * some prefix is not a sufficient sanitizer. We still treat it as one to avoid false positives.
   */
  class PrefixCheck extends SanitizerGuard, DataFlow::CallNode {
    PrefixCheck() {
      exists(Function f |
        f.hasQualifiedName("strings", "HasPrefix") and
        this = f.getACall()
      )
    }

    override predicate checks(Expr e, boolean branch) {
      e = this.getArgument(0).asExpr() and branch = true
    }
  }

  /**
   * A call to a regexp match function, considered as a sanitizer guard for paths.
   *
   * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
   */
  class RegexpCheckAsSanitizerGuard extends SanitizerGuard {
    RegexpCheckAsSanitizerGuard() { regexpFunctionChecksExpr(this, _, _) }

    override predicate checks(Expr e, boolean branch) { regexpFunctionChecksExpr(this, e, branch) }
  }
}
