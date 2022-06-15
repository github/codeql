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
   * A sanitizer guard for "tar slip" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of exception info, considered as a flow source.
   */
  class TarfileOpen extends Source {
    TarfileOpen() {
      this = API::moduleImport("tarfile").getMember("open").getACall() and
      // If argument refers to a string object, then it's a hardcoded path and
      // this tarfile is safe.
      not this.(DataFlow::CallCfgNode).getArg(0).getALocalSource().asExpr() instanceof StrConst and
      /* Ignore opens within the tarfile module itself */
      not this.getLocation().getFile().getBaseName() = "tarfile.py"
    }
  }

  /**
   * For efficiency we don't want to track the flow of taint
   * around the tarfile module.
   */
  class ExcludeTarFilePy extends Sanitizer {
    ExcludeTarFilePy() { this.getLocation().getFile().getBaseName() = "tarfile.py" }
  }

  /**
   * For a call to `file.extractall` without arguments, `file` is considered a sink.
   */
  class ExtractAllSink extends Sink {
    ExtractAllSink() {
      exists(DataFlow::CallCfgNode call |
        call =
          API::moduleImport("tarfile")
              .getMember("open")
              .getReturn()
              .getMember("extractall")
              .getACall() and
        not exists(call.getArg(_)) and
        not exists(call.getArgByName(_)) and
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
        this = call.getArg(0)
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
        this in [call.getArg(0), call.getArgByName("members")]
      )
    }
  }

  /**
   * For a "check-like function name" (matching `"%path"`), `checkPath`,
   * and a call `checkPath(info.name)`, the variable `info` is considered checked.
   */
  class TarFileInfoSanitizer extends SanitizerGuard {
    ControlFlowNode tarInfo;

    TarFileInfoSanitizer() {
      exists(CallNode call, AttrNode attr |
        this = call and
        // We must test the name of the tar info object.
        attr = call.getAnArg() and
        attr.getName() = "name" and
        attr.getObject() = tarInfo
      |
        // Assume that any test with "path" in it is a sanitizer
        call.getAChild*().(AttrNode).getName().toLowerCase().matches("%path")
        or
        call.getAChild*().(NameNode).getId().toLowerCase().matches("%path")
      )
    }

    override predicate checks(ControlFlowNode checked, boolean branch) {
      checked = tarInfo and
      branch in [true, false]
    }
  }
}
