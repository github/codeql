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
private import semmle.python.dataflow.new.internal.Attributes

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
   * Handle those three cases of Tarfile opens:
   *  - `tarfile.open()`
   *  - `tarfile.TarFile()`
   *  - `MKtarfile.Tarfile.open()`
   */
  API::Node tarfileOpen() {
      result in [
          API::moduleImport("tarfile").getMember(["open", "TarFile"]),
          API::moduleImport("tarfile").getMember("TarFile").getASubclass().getMember("open")
        ]
  }

  /**
   * Handle the previous three cases, plus the use of `closing` in the previous cases
   */
  class AllTarfileOpens extends API::CallNode {
    AllTarfileOpens() {
      exists(TarfileOpens tfo | this = tfo.getACall())
      or
      exists(API::Node closing, Node arg, TarfileOpens tfo |
        closing = API::moduleImport("contextlib").getMember("closing") and
        this = closing.getACall() and
        arg = this.getArg(0) and
        arg = tfo.getACall()
      )
    }
  }

  /**
   * A call to `tarfile.open`, considered as a flow source.
   */
  class TarfileOpen extends Source {
    TarfileOpen() {
      this = tarfileOpen().getACall()
      // If argument refers to a string object, then it's a hardcoded path and
      // this tarfile is safe.
      not this.(DataFlow::CallCfgNode).getArg(0).getALocalSource().asExpr() instanceof StrConst and
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
   * A sink capturing method calls to `extractall`.
   *
   * For a call to `file.extractall` without `members` argument, `file` is considered a sink.
   */
  class ExtractAllWithoutMembersSink extends Sink {
    ExtractAllWithoutMembersSink() {
      exists(AllTarfileOpens atfo, MethodCallNode call |
        call = atfo.getReturn().getMember("extractall").getACall() and
        not exists(Node arg | arg = call.getArgByName("members")) and
        this = call.getObject()
      )
    }
  }

    /**
   * A sink capturing method calls to `extractall` with `members` arguments.
   *
   * For a call to `file.extractall` with `members` argument, `file` is considered a sink if not
   * a the `members` argument contains a NameConstant as None, a List or call to the method `getmembers`.
   * Otherwise, the argument of `members` is considered a sink.  
   */
  class ExtractAllwithMembersSink extends Sink {
    ExtractAllwithMembersSink() {
      exists(AllTarfileOpens atfo, MethodCallNode call, Node arg |
        call = atfo.getReturn().getMember("extractall").getACall() and
        arg = call.getArgByName("members") and
        if
          arg.asCfgNode() instanceof NameConstantNode or
          arg.asCfgNode() instanceof ListNode
        then this = call.getObject()
        else
          if arg.(MethodCallNode).getMethodName() = "getmembers"
          then this = arg.(MethodCallNode).getObject()
          else this = call.getArgByName("members")
      )
    }
  }

  /**
   * An argument to `extract` is considered a sink.
   */
  class ExtractSink extends Sink {
    ExtractSink() {
      this = tarfileOpen().getReturn().getMember("extract").getACall().getArg(0)
    }
  }

  /**
   * An argument to `_extract_member` is considered a sink.
   */
  class ExtractMemberSink extends Sink {
    ExtractMemberSink() {
      exists(MethodCallNode call, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("_extract_member").getACall() and
        call.getArg(1).(AttrRead).accesses(this, "name")
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
