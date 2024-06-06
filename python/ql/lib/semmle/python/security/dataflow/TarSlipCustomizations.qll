/**
 * Provides default sources, sinks and sanitizers for detecting
 * "tar slip"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "tar slip"
 * vulnerabilities, as well as extension points for adding your own.
 */
module TarSlip {
  /**
   * A data flow source for "tar slip" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "tar slip" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "tar slip" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A call to `tarfile.open`, considered as a flow source.
   */
  class TarfileOpen extends Source {
    TarfileOpen() {
      this = API::moduleImport("tarfile").getMember("open").getACall() and
      // If argument refers to a string object, then it's a hardcoded path and
      // this tarfile is safe.
      not this.(DataFlow::CallCfgNode).getArg(0).getALocalSource().asExpr() instanceof StringLiteral and
      // Ignore opens within the tarfile module itself
      not this.getLocation().getFile().getBaseName() = "tarfile.py"
    }
  }

  /**
   * A sanitizer based on file name. This because we extract the standard library.
   *
   * For efficiency we don't want to track the flow of taint
   * around the tarfile module.
   */
  class ExcludeTarFilePy extends Sanitizer {
    ExcludeTarFilePy() { this.getLocation().getFile().getBaseName() = "tarfile.py" }
  }

  /**
   * Holds if `call` has an unsafe extraction filter, either by default (as the default is unsafe),
   * or by being set to an explicitly unsafe value, such as `"fully_trusted"`, or `None`.
   */
  private predicate hasUnsafeFilter(API::CallNode call) {
    call =
      API::moduleImport("tarfile")
          .getMember("open")
          .getReturn()
          .getMember(["extract", "extractall"])
          .getACall() and
    (
      exists(Expr filterValue |
        filterValue = call.getParameter(4, "filter").getAValueReachingSink().asExpr() and
        (
          filterValue.(StringLiteral).getText() = "fully_trusted"
          or
          filterValue instanceof None
        )
      )
      or
      not exists(call.getParameter(4, "filter"))
    )
  }

  /**
   * A sink capturing method calls to `extractall`.
   *
   * For a call to `file.extractall`, `file` is considered a sink if
   * there is no `members` argument and the extraction filter is unsafe.
   */
  class ExtractAllSink extends Sink {
    ExtractAllSink() {
      exists(API::CallNode call |
        call =
          API::moduleImport("tarfile")
              .getMember("open")
              .getReturn()
              .getMember("extractall")
              .getACall() and
        hasUnsafeFilter(call) and
        not exists(call.getParameter(2, "members")) and
        this = call.(DataFlow::MethodCallNode).getObject()
      )
    }
  }

  /**
   * An argument to `extract` is considered a sink.
   */
  class ExtractSink extends Sink {
    ExtractSink() {
      exists(DataFlow::CallCfgNode call |
        call =
          API::moduleImport("tarfile").getMember("open").getReturn().getMember("extract").getACall() and
        this = call.getArg(0) and
        hasUnsafeFilter(call)
      )
    }
  }

  /** The `members` argument `extractall` is considered a sink. */
  class ExtractMembersSink extends Sink {
    ExtractMembersSink() {
      exists(DataFlow::CallCfgNode call |
        call =
          API::moduleImport("tarfile")
              .getMember("open")
              .getReturn()
              .getMember("extractall")
              .getACall() and
        this in [call.getArg(0), call.getArgByName("members")] and
        hasUnsafeFilter(call)
      )
    }
  }

  /**
   * Holds if `g` clears taint for `tarInfo`.
   *
   * The test `if <check_path>(info.name)` should clear taint for `info`,
   * where `<check_path>` is any function matching `"%path"`.
   * `info` is assumed to be a `TarInfo` instance.
   */
  predicate tarFileInfoSanitizer(DataFlow::GuardNode g, ControlFlowNode tarInfo, boolean branch) {
    exists(CallNode call, AttrNode attr |
      g = call and
      // We must test the name of the tar info object.
      attr = call.getAnArg() and
      attr.getName() = "name" and
      attr.getObject() = tarInfo
    |
      // The assumption that any test that matches %path is a sanitizer might be too broad.
      call.getAChild*().(AttrNode).getName().matches("%path")
      or
      call.getAChild*().(NameNode).getId().matches("%path")
    ) and
    branch = false
  }

  /**
   * A sanitizer guard heuristic.
   *
   * The test `if <check_path>(info.name)` should clear taint for `info`,
   * where `<check_path>` is any function matching `"%path"`.
   * `info` is assumed to be a `TarInfo` instance.
   */
  class TarFileInfoSanitizer extends Sanitizer {
    TarFileInfoSanitizer() {
      this = DataFlow::BarrierGuard<tarFileInfoSanitizer/3>::getABarrierNode()
    }
  }
}
