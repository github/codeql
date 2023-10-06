/**
 * Models the `execa` library in terms of `FileSystemAccess` and `SystemCommandExecution`.
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgeryCustomizations

/**
 * Provide model for [Execa](https://github.com/sindresorhus/execa) package
 */
module Execa {
  /**
   * The Execa input file read and output file write
   */
  class ExecaFileSystemAccess extends FileSystemReadAccess, DataFlow::Node {
    API::Node execaArg;
    boolean isPipedToFile;

    ExecaFileSystemAccess() {
      (
        execaArg = API::moduleImport("execa").getMember("$").getParameter(0) and
        isPipedToFile = false
        or
        execaArg =
          API::moduleImport("execa")
              .getMember(["execa", "execaCommand", "execaCommandSync", "execaSync"])
              .getParameter([0, 1, 2]) and
        isPipedToFile = false
        or
        execaArg =
          API::moduleImport("execa")
              .getMember(["execa", "execaCommand", "execaCommandSync", "execaSync"])
              .getReturn()
              .getMember(["pipeStdout", "pipeAll", "pipeStderr"])
              .getParameter(0) and
        isPipedToFile = true
      ) and
      this = execaArg.asSink()
    }

    override DataFlow::Node getADataNode() { none() }

    override DataFlow::Node getAPathArgument() {
      result = execaArg.getMember("inputFile").asSink() and isPipedToFile = false
      or
      result = execaArg.asSink() and isPipedToFile = true
    }
  }

  /**
   * A call to `execa.execa` or `execa.execaSync`
   */
  class ExecaCall extends API::CallNode {
    boolean isSync;

    ExecaCall() {
      this = API::moduleImport("execa").getMember("execa").getACall() and
      isSync = false
      or
      this = API::moduleImport("execa").getMember("execaSync").getACall() and
      isSync = true
    }
  }

  /**
   * The system command execution nodes for `execa.execa` or `execa.execaSync` functions
   */
  class ExecaExec extends SystemCommandExecution, ExecaCall {
    ExecaExec() { isSync = [false, true] }

    override DataFlow::Node getACommandArgument() { result = this.getArgument(0) }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // if shell: true then first and second args are sinks
      // options can be third argument
      arg = [this.getArgument(0), this.getParameter(1).getUnknownMember().asSink()] and
      isExecaShellEnable(this.getParameter(2))
      or
      // options can be second argument
      arg = this.getArgument(0) and
      isExecaShellEnable(this.getParameter(1))
    }

    override DataFlow::Node getArgumentList() {
      // execa(cmd, [arg]);
      exists(DataFlow::Node arg | arg = this.getArgument(1) |
        // if it is a object then it is a option argument not command argument
        result = arg and not arg.asExpr() instanceof ObjectExpr
      )
    }

    override predicate isSync() { isSync = true }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  /**
   * A call to `execa.$` or `execa.$.sync` tag functions
   */
  private class ExecaScriptExpr extends DataFlow::ExprNode {
    boolean isSync;

    ExecaScriptExpr() {
      this.asExpr() =
        [
          API::moduleImport("execa").getMember("$"),
          API::moduleImport("execa").getMember("$").getReturn()
        ].getAValueReachableFromSource().asExpr() and
      isSync = false
      or
      this.asExpr() =
        [
          API::moduleImport("execa").getMember("$").getMember("sync"),
          API::moduleImport("execa").getMember("$").getMember("sync").getReturn()
        ].getAValueReachableFromSource().asExpr() and
      isSync = true
    }
  }

  /**
   * The system command execution nodes for `execa.$` or `execa.$.sync` tag functions
   */
  class ExecaScriptEec extends SystemCommandExecution, ExecaScriptExpr {
    ExecaScriptEec() { isSync = [false, true] }

    override DataFlow::Node getACommandArgument() {
      exists(TemplateLiteral tl | isFirstTaggedTemplateParameter(this.asExpr(), tl) |
        result.asExpr() = tl.getChildExpr(0) and
        not result.asExpr().mayHaveStringValue(" ") // exclude whitespace
      )
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // $({shell: true})`${cmd} ${arg0} ... ${arg1}`
      // ISSUE: $`cmd args` I can't reach the tag function argument easily
      exists(TemplateLiteral tmpL | isFirstTaggedTemplateParameter(this.asExpr(), tmpL) |
        arg.asExpr() = tmpL.getAChildExpr() and
        isExecaShellEnableWithExpr(this.asExpr().(CallExpr).getArgument(0)) and
        not arg.asExpr().mayHaveStringValue(" ") // exclude whitespace
      )
    }

    override DataFlow::Node getArgumentList() {
      // $`${cmd} ${arg0} ... ${argn}`
      exists(TemplateLiteral tmpL | isFirstTaggedTemplateParameter(this.asExpr(), tmpL) |
        result.asExpr() = tmpL.getAChildExpr() and
        not result.asExpr() = tmpL.getChildExpr(0) and
        not result.asExpr().mayHaveStringValue(" ") // exclude whitespace
      )
    }

    override predicate isSync() { isSync = true }

    override DataFlow::Node getOptionsArg() {
      result = this.asExpr().getAChildExpr().flow() and result.asExpr() instanceof ObjectExpr
    }
  }

  /**
   * A call to `execa.execaCommandSync` or `execa.execaCommand`
   */
  private class ExecaCommandCall extends API::CallNode {
    boolean isSync;

    ExecaCommandCall() {
      this = API::moduleImport("execa").getMember("execaCommandSync").getACall() and
      isSync = true
      or
      this = API::moduleImport("execa").getMember("execaCommand").getACall() and
      isSync = false
    }
  }

  /**
   * The system command execution nodes for `execa.execaCommand` or `execa.execaCommandSync` functions
   */
  class ExecaCommandExec extends SystemCommandExecution, ExecaCommandCall {
    ExecaCommandExec() { isSync = [false, true] }

    override DataFlow::Node getACommandArgument() {
      result = this.(DataFlow::CallNode).getArgument(0)
    }

    override DataFlow::Node getArgumentList() {
      // execaCommand(`${cmd} ${arg}`);
      result.asExpr() = this.getParameter(0).asSink().asExpr().getAChildExpr() and
      not result.asExpr() = this.getArgument(0).asExpr().getChildExpr(0)
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // execaCommandSync(`${cmd} ${arg}`, {shell: true})
      arg.asExpr() = this.getArgument(0).asExpr().getAChildExpr+() and
      isExecaShellEnable(this.getParameter(1))
      or
      // there is only one argument that is constructed in previous nodes,
      // it makes sanitizing really hard to select whether it is vulnerable to argument injection or not
      arg = this.getParameter(0).asSink() and
      not exists(this.getArgument(0).asExpr().getChildExpr(1))
    }

    override predicate isSync() { isSync = true }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  // Holds if left parameter is the left child of a template literal and returns the template literal
  private predicate isFirstTaggedTemplateParameter(Expr left, TemplateLiteral templateLiteral) {
    exists(TaggedTemplateExpr parent |
      templateLiteral = parent.getTemplate() and
      left = parent.getChildExpr(0)
    )
  }

  /**
   * Holds whether Execa has shell enabled options or not, get Parameter responsible for options
   */
  pragma[inline]
  private predicate isExecaShellEnable(API::Node n) {
    n.getMember("shell").asSink().asExpr().(BooleanLiteral).getValue() = "true"
  }

  // Holds whether Execa has shell enabled options or not, get Parameter responsible for options
  private predicate isExecaShellEnableWithExpr(Expr n) {
    exists(ObjectExpr o, Property p | o = n.getAChildExpr*() |
      o.getAChild() = p and
      p.getAChild().(Label).getName() = "shell" and
      p.getAChild().(Literal).getValue() = "true"
    )
  }
}
