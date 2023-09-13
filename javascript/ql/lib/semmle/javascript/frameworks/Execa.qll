/**
 * Models the `execa` library in terms of `FileSystemAccess` and `SystemCommandExecution`.
 */

import javascript
import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.UrlConcatenation

// I don't know where should i put following class
private class DynamicImport extends SystemCommandExecution, DataFlow::ExprNode {
  DynamicImport() { this = any(DynamicImportExpr e).getAChildExpr().flow() }

  override DataFlow::Node getACommandArgument() { result = this }

  override predicate isShellInterpreted(DataFlow::Node arg) { none() }

  override predicate isSync() { none() }

  override DataFlow::Node getOptionsArg() { none() }
}

module Execa {
  // https://github.com/sindresorhus/execa
  private class ExecaRead extends FileSystemReadAccess, DataFlow::Node {
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

  private class ExecaExec extends SystemCommandExecution, ExecaCall {
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
      // arguments can be vulnerable if the arguemnts belongs to a command that is vulnerable to command execution through argument itself
      // like `-oProxyCommand=touch file` by ssh command
      // function execa(file: string,arguments?: readonly string[],options?: Options<BufferEncodingOption>): ExecaChildProcess<Buffer>;
      arg = this.getParameter(1).getUnknownMember().asSink() and
      argumentIsInjectable(this.getParameter(0).asSink().getStringValue())
    }

    override predicate isSync() { name = "execaSync" }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  class ExecaScriptExpr extends DataFlow::ExprNode {
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

  private class ExecaScriptEec extends SystemCommandExecution, ExecaScriptExpr {
    ExecaScriptEec() { name = ["Sync", "ASync"] }

    override DataFlow::Node getACommandArgument() {
      result.asExpr() = templateLiteralChildAsSink(this.asExpr()).getAChildExpr+()
    }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // $({shell: true})`${sink} ${sink} .. ${sink}`
      // ISSUE: $`cmd args` I can't reach the tag function argument easyily
      exists(TemplateLiteral tmpL | templateLiteralChildAsSink(this.asExpr()) = tmpL |
        arg.asExpr() = tmpL.getAChildExpr+() and
        isExecaShellEnableWithExpr(this.asExpr().(CallExpr).getArgument(0))
      )
    }

    predicate isArgumentInjectable(DataFlow::Node arg) {
      // first arg only can execute one command so it is not vulnerable when we can inject something into it
      // but if the commmand is an executable like ssh then their arguments can be injected
      // and execute a command (a payload like `-oProxyCommand=touch file`)
      // $({shell: true})`${Can Not Be sink} ${sink} .. ${sink}`
      exists(TemplateLiteral tmpL | templateLiteralChildAsSink(this.asExpr()) = tmpL |
        arg.asExpr() = tmpL.getAChildExpr+() and
        not arg.asExpr() = tmpL.getChildExpr(0) and
        argumentIsInjectable(tmpL.getChildExpr(0).getStringValue())
      )
    }

    override predicate isSync() { name = "Sync" }

    override DataFlow::Node getOptionsArg() {
      result = this.asExpr().getAChildExpr*().flow() and result.asExpr() instanceof ObjectExpr
    }
  }

  class ExecaCommandCall extends API::CallNode {
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

  private class ExecaCommandExec extends SystemCommandExecution, ExecaCommandCall {
    ExecaCommandExec() { name = ["execaCommand", "execaCommandSync"] }

    override DataFlow::Node getACommandArgument() { result = this.getArgument(0) }

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

    predicate isArgumentInjectable(DataFlow::Node arg) {
      // first arg is the command so we should check whether it is begening with a command that vulnerable to argument command injection or not
      // execaCommand("echo " + sink);
      // execaCommand(`echo ${sink}`);
      argumentIsInjectable(this.getParameter(0).asSink().asExpr().getChildExpr(0).getStringValue()) and
      arg.asExpr() = this.getParameter(0).asSink().asExpr().getAChildExpr+() and
      not arg.asExpr() = this.getArgument(0).asExpr().getChildExpr(0)
    }

    override predicate isSync() { name = "execaCommandSync" }

    override DataFlow::Node getOptionsArg() {
      result = this.getLastArgument() and result.asExpr() instanceof ObjectExpr
    }
  }

  // parent = left`result`
  TemplateLiteral templateLiteralChildAsSink(Expr left) {
    exists(TaggedTemplateExpr parent |
      parent.getTemplate() = result and
      left = parent.getChildExpr(0)
    )
  }

  class CommandsVulnerableToArgumentInjection extends string {
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
  predicate argumentIsInjectable(string cmd) {
    // "cmd args" or "cmd"
    exists(CommandsVulnerableToArgumentInjection c |
      // full/relative path to command like `/usr/bin/cmd` or `somedir/cmd`
      cmd.matches("%/" + c)
      or
      // command like `cmd args`
      cmd.matches(c + " %")
      or
      // only the command `cmd`
      cmd = c
    )
  }

  // Check whether Execa has shell enabled options or not, get Parameter responsible for opstions
  predicate isExecaShellEnable(API::Node n) {
    n.getMember("shell").asSink().asExpr().(BooleanLiteral).getValue() = "true" and
    exists(n.getMember("shell"))
  }

  // Check whether Execa has shell enabled options or not, get Parameter responsible for opstions
  predicate isExecaShellEnableWithExpr(Expr n) {
    exists(ObjectExpr o, Property p | o = n.getAChildExpr*() |
      o.getAChild() = p and
      p.getAChild().(Label).getName() = "shell" and
      p.getAChild().(Literal).getValue() = "true"
    )
  }
}
