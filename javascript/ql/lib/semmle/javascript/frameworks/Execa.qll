/**
 * Models the `execa` library in terms of `FileSystemAccess` and `SystemCommandExecution`.
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.UrlConcatenation

/**
 * The dynamic import expression input can be a `data:` URL which loads any module from that data
 */
class DynamicImport extends SystemCommandExecution, DataFlow::ExprNode {
  DynamicImport() { this = any(DynamicImportExpr e).getAChildExpr().flow() }

  override DataFlow::Node getACommandArgument() { result = this }

  override predicate isShellInterpreted(DataFlow::Node arg) { none() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}

/**
 * Provide model for [Execa](https://github.com/sindresorhus/execa) package
 */
module Execa {
  /**
   * The Execa input file option
   */
  class ExecaRead extends FileSystemReadAccess, DataFlow::Node {
    API::Node execaNode;

    ExecaRead() {
      (
        execaNode = API::moduleImport("execa").getMember("$").getParameter(0)
        or
        execaNode =
          API::moduleImport("execa")
              .getMember(["execa", "execaCommand", "execaCommandSync", "execaSync"])
              .getParameter([0, 1, 2])
      ) and
      this = execaNode.asSink()
    }

    // data is the output of a command so IDK how it can be implemented
    override DataFlow::Node getADataNode() { none() }

    override DataFlow::Node getAPathArgument() {
      result = execaNode.getMember("inputFile").asSink()
    }
  }

  /**
   * A call to `execa.execa` or `execa.execaSync`
   */
  class ExecaCall extends API::CallNode {
    string name;

    ExecaCall() {
      this = API::moduleImport("execa").getMember("execa").getACall() and
      name = "execa"
      or
      this = API::moduleImport("execa").getMember("execaSync").getACall() and
      name = "execaSync"
    }

    /** Gets the name of the exported function, such as `rm` in `shelljs.rm()`. */
    string getName() { result = name }
  }

  /**
   * The system command execution nodes for `execa.execa` or `execa.execaSync` functions
   */
  class ExecaExec extends SystemCommandExecution, ExecaCall {
    ExecaExec() { name = ["execa", "execaSync"] }

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

    predicate isArgumentInjectable(DataFlow::Node arg) {
      // execa(file: string,arguments?: readonly string[],options?: Options<BufferEncodingOption>)
      arg = this.getParameter(1).getUnknownMember().asSink() and
      argumentIsInjectable(this.getParameter(0).asSink().getStringValue())
    }

    override predicate isSync() { name = "execaSync" }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  /**
   * A call to `execa.$` or `execa.$.sync` tag functions
   */
  private class ExecaScriptExpr extends DataFlow::ExprNode {
    string name;

    ExecaScriptExpr() {
      this.asExpr() =
        [
          API::moduleImport("execa").getMember("$"),
          API::moduleImport("execa").getMember("$").getReturn()
        ].getAValueReachableFromSource().asExpr() and
      name = "ASync"
      or
      this.asExpr() =
        [
          API::moduleImport("execa").getMember("$").getMember("sync"),
          API::moduleImport("execa").getMember("$").getMember("sync").getReturn()
        ].getAValueReachableFromSource().asExpr() and
      name = "Sync"
    }

    /** Gets the name of the exported function, such as `rm` in `shelljs.rm()`. */
    string getName() { result = name }
  }

  /**
   * The system command execution nodes for `execa.$` or `execa.$.sync` tag functions
   */
  class ExecaScriptEec extends SystemCommandExecution, ExecaScriptExpr {
    ExecaScriptEec() { name = ["Sync", "ASync"] }

    override DataFlow::Node getACommandArgument() {
      result.asExpr() = templateLiteralChildAsSink(this.asExpr()).getAChildExpr+()
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // $({shell: true})`${sink} ${sink} .. ${sink}`
      // ISSUE: $`cmd args` I can't reach the tag function argument easily
      exists(TemplateLiteral tmpL | templateLiteralChildAsSink(this.asExpr()) = tmpL |
        arg.asExpr() = tmpL.getAChildExpr+() and
        isExecaShellEnableWithExpr(this.asExpr().(CallExpr).getArgument(0))
      )
    }

    override DataFlow::Node getArgumentList() {
      // $`${Can Not Be sink} ${sink} .. ${sink}`
      exists(TemplateLiteral tmpL | templateLiteralChildAsSink(this.asExpr()) = tmpL |
        result.asExpr() = tmpL.getAChildExpr+() and
        not result.asExpr() = tmpL.getChildExpr(0)
      )
    }

    override predicate isSync() { name = "Sync" }

    override DataFlow::Node getOptionsArg() {
      result = this.asExpr().getAChildExpr*().flow() and result.asExpr() instanceof ObjectExpr
    }
  }

  /**
   * A call to `execa.execaCommandSync` or `execa.execaCommand`
   */
  private class ExecaCommandCall extends API::CallNode {
    string name;

    ExecaCommandCall() {
      this = API::moduleImport("execa").getMember("execaCommandSync").getACall() and
      name = "execaCommandSync"
      or
      this = API::moduleImport("execa").getMember("execaCommand").getACall() and
      name = "execaCommand"
    }

    /** Gets the name of the exported function, such as `rm` in `shelljs.rm()`. */
    string getName() { result = name }
  }

  /**
   * The system command execution nodes for `execa.execaCommand` or `execa.execaCommandSync` functions
   */
  class ExecaCommandExec extends SystemCommandExecution, ExecaCommandCall {
    ExecaCommandExec() { name = ["execaCommand", "execaCommandSync"] }

    override DataFlow::Node getACommandArgument() { result = this.getArgument(0) }

    override DataFlow::Node getArgumentList() {
      // execaCommand("echo " + sink);
      // execaCommand(`echo ${sink}`);
      result.asExpr() = this.getParameter(0).asSink().asExpr().getAChildExpr+() and
      not result.asExpr() = this.getArgument(0).asExpr().getChildExpr(0)
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // execaCommandSync(sink1 + sink2, {shell: true})
      arg.asExpr() = this.getArgument(0).asExpr().getAChildExpr+() and
      isExecaShellEnable(this.getParameter(1))
      or
      // there is only one argument that is constructed in previous nodes,
      // it makes sanitizing really hard to select whether it is vulnerable to argument injection or not
      arg = this.getParameter(0).asSink() and
      not exists(this.getArgument(0).asExpr().getChildExpr(1))
    }

    override predicate isSync() { name = "execaCommandSync" }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  // parent = left`result`
  private TemplateLiteral templateLiteralChildAsSink(Expr left) {
    exists(TaggedTemplateExpr parent |
      parent.getTemplate() = result and
      left = parent.getChildExpr(0)
    )
  }

  private class CommandsVulnerableToArgumentInjection extends string {
    CommandsVulnerableToArgumentInjection() {
      // Thanks to https://sonarsource.github.io/argument-injection-vectors/#+command
      this =
        [
          "chrome", "git-blame", "git-clone", "git-fetch", "git-grep", "git-ls-remote", "hg",
          "psql", "qt5", "ssh", "tar", "zip", "aria2c", "tcpdump", "sysctl", "split", "sed",
          "pidstat", "php", "nohup", "crontab", "crontab", "crontab", "crontab", "sh", "zsh",
          "bash", "cmd.exe", "cmd"
        ]
    }
  }

  // Check whether a command is vulnerable to argument injection or not
  bindingset[cmd]
  private predicate argumentIsInjectable(string cmd) {
    // "cmd args" or "cmd"
    exists(CommandsVulnerableToArgumentInjection c |
      // full/relative path to command like `/usr/bin/cmd` or `someDir/cmd`
      cmd.matches("%/" + c)
      or
      // command like `cmd args`
      cmd.matches(c + " %")
      or
      // only the command `cmd`
      cmd = c
    )
  }

  // Check whether Execa has shell enabled options or not, get Parameter responsible for options
  private predicate isExecaShellEnable(API::Node n) {
    n.getMember("shell").asSink().asExpr().(BooleanLiteral).getValue() = "true" and
    exists(n.getMember("shell"))
  }

  // Check whether Execa has shell enabled options or not, get Parameter responsible for options
  private predicate isExecaShellEnableWithExpr(Expr n) {
    exists(ObjectExpr o, Property p | o = n.getAChildExpr*() |
      o.getAChild() = p and
      p.getAChild().(Label).getName() = "shell" and
      p.getAChild().(Literal).getValue() = "true"
    )
  }
}
