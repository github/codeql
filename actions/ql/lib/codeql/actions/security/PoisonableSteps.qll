import actions

abstract class PoisonableStep extends Step { }

class DangerousActionUsesStep extends PoisonableStep, UsesStep {
  DangerousActionUsesStep() { poisonableActionsDataModel(this.getCallee()) }
}

class PoisonableCommandStep extends PoisonableStep, Run {
  PoisonableCommandStep() {
    exists(string regexp |
      poisonableCommandsDataModel(regexp) and
      this.getScript().getACommand().regexpMatch(regexp)
    )
  }
}

class JavascriptImportUsesStep extends PoisonableStep, UsesStep {
  JavascriptImportUsesStep() {
    exists(string script, string line |
      this.getCallee() = "actions/github-script" and
      script = this.getArgument("script") and
      line = script.splitAt("\n").trim() and
      // const { default: foo } = await import('${{ github.workspace }}/scripts/foo.mjs')
      // const script = require('${{ github.workspace }}/scripts/test.js');
      // const script = require('./scripts');
      line.regexpMatch(".*(import|require)\\(('|\")(\\./|.*github.workspace).*")
    )
  }
}

class SetupNodeUsesStep extends PoisonableStep, UsesStep {
  SetupNodeUsesStep() {
    this.getCallee() = "actions/setup-node" and
    this.getArgument("cache") = "yarn"
  }
}

class LocalScriptExecutionRunStep extends PoisonableStep, Run {
  string path;

  LocalScriptExecutionRunStep() {
    exists(string cmd, string regexp, int path_group | cmd = this.getScript().getACommand() |
      poisonableLocalScriptsDataModel(regexp, path_group) and
      path = cmd.regexpCapture(regexp, path_group)
    )
  }

  string getPath() { result = normalizePath(path.splitAt(" ")) }
}

class LocalActionUsesStep extends PoisonableStep, UsesStep {
  LocalActionUsesStep() { this.getCallee().matches("./%") }

  string getPath() { result = normalizePath(this.getCallee()) }
}
