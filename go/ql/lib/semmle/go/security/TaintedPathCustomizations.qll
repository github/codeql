/**
 * Provides default sources, sinks and sanitizers for reasoning about path-traversal
 * vulnerabilities, as well as extension points for adding your own.
 */

import go
import semmle.go.dataflow.barrierguardutil.RegexpCheck
import DataFlow

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
   */
  abstract class SanitizerGuard extends DataFlow::Node {
    abstract predicate checks(Expr e, boolean branch);
  }

  private predicate sanitizerGuard(DataFlow::Node g, Expr e, boolean branch) {
    g.(SanitizerGuard).checks(e, branch)
  }

  private class SanitizerGuardAsSanitizer extends Sanitizer {
    SanitizerGuardAsSanitizer() {
      this = DataFlow::BarrierGuard<sanitizerGuard/3>::getABarrierNode()
    }
  }

  /**
   * DEPRECATED: Use `ThreatModelFlowSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /** A source of untrusted data, considered as a taint source for path traversal. */
  private class ThreatModelFlowAsSource extends Source instanceof ThreatModelFlowSource { }

  /** A path expression, considered as a taint sink for path traversal. */
  class PathAsSink extends Sink {
    PathAsSink() { this = any(FileSystemAccess fsa).getAPathArgument() }
  }

  /**
   * A numeric- or boolean-typed node, considered a sanitizer for path traversal.
   */
  class NumericOrBooleanSanitizer extends Sanitizer {
    NumericOrBooleanSanitizer() {
      this.getType() instanceof NumericType or this.getType() instanceof BoolType
    }
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
   * A call to `filepath.Clean("/" + e)`, considered to sanitize `e` against path traversal.
   */
  class FilepathCleanSanitizer extends Sanitizer {
    FilepathCleanSanitizer() {
      exists(DataFlow::CallNode cleanCall, StringOps::Concatenation concatNode |
        cleanCall = any(Function f | f.hasQualifiedName("path/filepath", "Clean")).getACall() and
        concatNode = cleanCall.getArgument(0) and
        concatNode.getOperand(0).asExpr().(StringLit).getValue() = "/" and
        this = cleanCall.getResult()
      )
    }
  }

  /**
   * A read from the field `Filename` of the type `mime/multipart.FileHeader`,
   * considered as a sanitizer for path traversal.
   *
   * The only way to create a `mime/multipart.FileHeader` is to create a
   * `mime/multipart.Form`, which creates the `Filename` field of each
   * `mime/multipart.FileHeader` by calling `Part.FileName`, which calls
   * `path/filepath.Base` on its return value. In general `path/filepath.Base`
   * is not a sanitizer for path traversal, but in this specific case where the
   * output is going to be used as a filename rather than a directory name, it
   * is adequate.
   */
  class MimeMultipartFileHeaderFilenameSanitizer extends Sanitizer {
    MimeMultipartFileHeaderFilenameSanitizer() {
      this.(DataFlow::FieldReadNode)
          .getField()
          .hasQualifiedName("mime/multipart", "FileHeader", "Filename")
    }
  }

  /**
   * A call to `mime/multipart.Part.FileName`, considered as a sanitizer
   * against path traversal.
   *
   * `Part.FileName` calls `path/filepath.Base` on its return value. In
   * general `path/filepath.Base` is not a sanitizer for path traversal, but in
   * this specific case where the output is going to be used as a filename
   * rather than a directory name, it is adequate.
   */
  class MimeMultipartPartFileNameSanitizer extends Sanitizer {
    MimeMultipartPartFileNameSanitizer() {
      this =
        any(Method m | m.hasQualifiedName("mime/multipart", "Part", "FileName"))
            .getACall()
            .getResult()
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
   * A replacement of the form `!strings.ReplaceAll(nd, "..")` or `!strings.ReplaceAll(nd, ".")`, considered as a sanitizer for
   * path traversal.
   */
  class DotDotReplaceAll extends StringOps::ReplaceAll, Sanitizer {
    DotDotReplaceAll() { this.getReplacedString() = ["..", "."] }
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
