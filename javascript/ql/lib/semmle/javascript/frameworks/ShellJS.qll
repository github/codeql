/**
 * Models the `shelljs` library in terms of `FileSystemAccess` and `SystemCommandExecution`.
 *
 * https://www.npmjs.com/package/shelljs
 */

import javascript

module ShellJS {
  private API::Node shellJSMember() {
    result = API::moduleImport("shelljs")
    or
    result =
      shellJSMember()
          .getMember([
              "exec", "cd", "cp", "touch", "chmod", "pushd", "find", "ls", "ln", "mkdir", "mv",
              "rm", "cat", "head", "sort", "tail", "uniq", "grep", "sed", "to", "toEnd", "echo"
            ])
          .getReturn()
  }

  /**
   * Gets a function that can execute a shell command using the `shelljs` or `async-shelljs` modules.
   */
  DataFlow::SourceNode shelljs() {
    result = shellJSMember().asSource() or
    result = DataFlow::moduleImport("async-shelljs")
  }

  /** A member of the `shelljs` library. */
  class Member extends DataFlow::SourceNode instanceof Member::Range {
    /** Gets the name of `shelljs` member being referenced, such as `cat` in `shelljs.cat`. */
    string getName() { result = super.getName() }
  }

  module Member {
    /**
     * A member of the `shelljs` library.
     *
     * Can be subclassed to recognize additional values as `shelljs` member functions.
     */
    abstract class Range extends DataFlow::SourceNode {
      abstract string getName();
    }

    private class DefaultRange extends Range {
      string name;

      DefaultRange() { this = shelljs().getAPropertyRead(name) }

      override string getName() { result = name }
    }

    /** The `shelljs.exec` library modeled as a `shelljs` member. */
    private class ShellJsExec extends Range {
      ShellJsExec() {
        this = DataFlow::moduleImport("shelljs.exec") or
        this = shellJSMember().getMember("exec").asSource()
      }

      override string getName() { result = "exec" }
    }
  }

  /**
   * A call to one of the functions exported from the `shelljs` library.
   */
  class ShellJSCall extends DataFlow::CallNode {
    string name;

    ShellJSCall() {
      exists(Member member |
        this = member.getACall() and
        name = member.getName()
      )
    }

    /** Gets the name of the exported function, such as `rm` in `shelljs.rm()`. */
    string getName() { result = name }

    /** Holds if the first argument starts with a `-`, indicating it is an option. */
    predicate hasOptionsArg() {
      exists(string val |
        this.getArgument(0).mayHaveStringValue(val) and
        val.matches("-%")
      )
    }

    /** Gets the `n`th argument after the initial options argument, if any. */
    DataFlow::Node getTranslatedArgument(int n) {
      if this.hasOptionsArg()
      then result = this.getArgument(n + 1)
      else result = this.getArgument(n)
    }
  }

  /**
   * A file system access that can't be modeled as a read or a write.
   */
  private class ShellJSGenericFileAccess extends FileSystemAccess, ShellJSCall {
    ShellJSGenericFileAccess() {
      name = ["cd", "cp", "touch", "chmod", "pushd", "find", "ls", "ln", "mkdir", "mv", "rm"]
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnArgument() }
  }

  /**
   * A `shelljs` call that returns names of existing files.
   */
  private class ShellJSFilenameSource extends FileNameSource, ShellJSCall {
    ShellJSFilenameSource() {
      name = "find" or
      name = "ls"
    }
  }

  /**
   * A file system access that returns the contents of a file.
   */
  private class ShellJSRead extends FileSystemReadAccess, ShellJSCall {
    ShellJSRead() { name = ["cat", "head", "sort", "tail", "uniq"] }

    override DataFlow::Node getAPathArgument() { result = this.getAnArgument() }

    override DataFlow::Node getADataNode() { result = this }
  }

  /**
   * A file system access that returns the contents of a file, but where certain arguemnts
   * should be treated as patterns, not filenames.
   */
  private class ShellJSPatternRead extends FileSystemReadAccess, ShellJSCall {
    int offset;

    ShellJSPatternRead() {
      name = "grep" and offset = 1
      or
      name = "sed" and offset = 2
    }

    override DataFlow::Node getAPathArgument() {
      // Do not treat regex patterns as filenames.
      exists(int arg |
        arg >= offset and
        result = this.getTranslatedArgument(arg)
      )
    }

    override DataFlow::Node getADataNode() { result = this }
  }

  /**
   * A call to `shelljs.exec()` modeled as command execution.
   */
  private class ShellJSExec extends SystemCommandExecution, ShellJSCall {
    ShellJSExec() { name = "exec" }

    override DataFlow::Node getACommandArgument() { result = this.getArgument(0) }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getACommandArgument() }

    override predicate isSync() { none() }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and
      not result = this.getArgument(0) and
      not result.getALocalSource() instanceof DataFlow::FunctionNode and // looks like callback
      not result.getALocalSource() instanceof DataFlow::ArrayCreationNode // looks like argumentlist
    }
  }

  /**
   * A call to `to()` or `toEnd()` on the `ShellString` object returned from another `shelljs` call,
   * such as `shelljs.cat(file1).to(file2)`.
   */
  private class ShellJSPipe extends FileSystemWriteAccess, DataFlow::CallNode {
    ShellJSPipe() {
      exists(string name | this = any(ShellJSCall inner).getAMethodCall(name) |
        name = "to" or
        name = "toEnd"
      )
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }

    override DataFlow::Node getADataNode() { result = this.getReceiver() }
  }
}
