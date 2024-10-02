import actions
import codeql.actions.config.Config

abstract class PoisonableStep extends Step { }

private string dangerousActions() {
  exists(string action |
    poisonableActionsDataModel(action) and
    result = action
  )
}

class DangerousActionUsesStep extends PoisonableStep, UsesStep {
  DangerousActionUsesStep() { this.getCallee() = dangerousActions() }
}

class PoisonableCommandStep extends PoisonableStep, Run {
  PoisonableCommandStep() {
    exists(string regexp |
      poisonableCommandsDataModel(regexp) and
      exists(this.getACommand().regexpFind(regexp, _, _))
    )
  }
}

class JavascriptImportnUsesStep extends PoisonableStep, UsesStep {
  JavascriptImportnUsesStep() {
    exists(string script, string line, string import_stmt |
      this.getCallee() = "actions/github-script" and
      script = this.getArgument("script") and
      line = script.splitAt("\n").trim() and
      import_stmt = line.regexpCapture(".*await\\s+import\\((.*)\\).*", 1) and
      import_stmt.regexpMatch(".*\\bgithub.workspace\\b.*")
    )
  }
}

class LocalScriptExecutionRunStep extends PoisonableStep, Run {
  string path;

  LocalScriptExecutionRunStep() {
    exists(string cmd, string regexp, int path_group | cmd = this.getACommand() |
      poisonableLocalScriptsDataModel(regexp, path_group) and
      path = cmd.regexpCapture(regexp, path_group)
    )
  }

  string getPath() { result = normalizePath(path.splitAt(" ")) }
}

class LocalActionUsesStep extends PoisonableStep, UsesStep {
  LocalActionUsesStep() { this.getCallee().matches("./%") }
}

class EnvVarInjectionFromFileReadRunStep extends PoisonableStep, Run {
  EnvVarInjectionFromFileReadRunStep() {
    exists(string content, string value |
      writeToGitHubEnv(this, content) and
      extractVariableAndValue(content, _, value) and
      outputsPartialFileContent(value)
    )
  }
}
