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
      exists(this.getScript().splitAt("\n").trim().regexpFind("(^|\\b|\\s+)" + regexp, _, _))
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
  string cmd;

  LocalScriptExecutionRunStep() {
    exists(string line, string regexp, int group | line = this.getScript().splitAt("\n").trim() |
      poisonableLocalScriptsDataModel(regexp, group) and
      //cmd = line.regexpCapture(".*(^|\\b|\\s+|\\$\\(|`)" + regexp + "(\\b|\\s+|;|\\)|`|$).*", group)
      cmd =
        line.regexpCapture(".*(^|;|\\$\\(|`|\\||&&)\\s*" + regexp + "\\s*(;|\\||\\)|`|-|&&|$).*",
          group)
    )
  }

  string getCommand() { result = cmd }
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
