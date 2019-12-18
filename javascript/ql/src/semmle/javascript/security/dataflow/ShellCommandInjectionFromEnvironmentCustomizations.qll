/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * command-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.TaintedPathCustomizations

module ShellCommandInjectionFromEnvironment {
  /**
   * A data flow source for command-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for command-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for command-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** An file name from the local file system, considered as a flow source for command injection. */
  class FileNameSourceAsSource extends Source {
    FileNameSourceAsSource() { this instanceof FileNameSource }

    override string getSourceType() { result = "file name" }
  }

  /** An absolute path from the local file system, considered as a flow source for command injection. */
  class AbsolutePathSource extends Source {
    AbsolutePathSource() {
      exists(ModuleScope ms | this.asExpr() = ms.getVariable("__dirname").getAnAccess())
      or
      exists(DataFlow::SourceNode process | process = NodeJSLib::process() |
        this = process.getAPropertyRead("execPath") or
        this = process.getAMemberCall("cwd")
      )
      or
      this = any(TaintedPath::ResolvingPathCall c).getOutput()
    }

    override string getSourceType() { result = "absolute path" }
  }

  /**
   * A shell command argument.
   */
  class ShellCommandSink extends Sink, DataFlow::ValueNode {
    ShellCommandSink() { any(SystemCommandExecution sys).isShellInterpreted(this) }
  }
}
