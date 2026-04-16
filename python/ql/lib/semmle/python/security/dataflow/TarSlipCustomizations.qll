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
   * A call to `shutil.unpack_archive`, considered as a flow source.
   *
   * The archive filename is not hardcoded, so it may come from user input.
   */
  class ShutilUnpackArchiveSource extends Source {
    ShutilUnpackArchiveSource() {
      this = API::moduleImport("shutil").getMember("unpack_archive").getACall() and
      not this.(DataFlow::CallCfgNode).getArg(0).getALocalSource().asExpr() instanceof StringLiteral
    }
  }

  /**
   * A call to `shutil.unpack_archive`, considered as a flow sink.
   *
   * The archive filename is not hardcoded, so it may come from user input.
   */
  class ShutilUnpackArchiveSink extends Sink {
    ShutilUnpackArchiveSink() {
      this = API::moduleImport("shutil").getMember("unpack_archive").getACall() and
      not this.(DataFlow::CallCfgNode).getArg(0).getALocalSource().asExpr() instanceof StringLiteral
    }
  }

  /**
   * Holds if `call` is a subprocess call that invokes `tar` for archive extraction
   * with at least one non-literal argument (the archive filename).
   *
   * Detects patterns like `subprocess.run(["tar", "-xf", untrusted_filename])`.
   */
  private predicate isSubprocessTarExtraction(DataFlow::CallCfgNode call) {
    exists(SequenceNode cmdList |
      call =
        API::moduleImport("subprocess")
            .getMember(["run", "call", "check_call", "check_output", "Popen"])
            .getACall() and
      cmdList = call.getArg(0).asCfgNode() and
      // Command must be "tar" or a full path ending in "/tar" (e.g. "/usr/bin/tar")
      cmdList.getElement(0).getNode().(StringLiteral).getText().regexpMatch("(.*/)?tar") and
      // At least one extraction-related flag must be present:
      // single-dash flags containing 'x' (like -x, -xf, -xvf) or the long option --extract
      exists(string flag |
        flag = cmdList.getElement(_).getNode().(StringLiteral).getText() and
        (flag.regexpMatch("-[a-zA-Z]*x[a-zA-Z]*") or flag = "--extract")
      ) and
      // At least one non-literal argument (the archive filename)
      exists(int i |
        i > 0 and
        exists(cmdList.getElement(i)) and
        not cmdList.getElement(i).getNode() instanceof StringLiteral
      )
    )
  }

  /**
   * A call to `subprocess` functions that invokes `tar` for archive extraction,
   * considered as a flow source.
   */
  class SubprocessTarExtractionSource extends Source {
    SubprocessTarExtractionSource() { isSubprocessTarExtraction(this) }
  }

  /**
   * A call to `subprocess` functions that invokes `tar` for archive extraction,
   * considered as a flow sink.
   */
  class SubprocessTarExtractionSink extends Sink {
    SubprocessTarExtractionSink() { isSubprocessTarExtraction(this) }
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
