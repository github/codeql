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

class LocalScriptExecutionRunStep extends PoisonableStep, Run {
  string cmd;

  LocalScriptExecutionRunStep() {
    exists(string line, string regexp, int group | line = this.getScript().splitAt("\n").trim() |
      poisonableLocalScriptsDataModel(regexp, group) and
      //cmd = line.regexpCapture(".*(^|\\b|\\s+|\\$\\(|`)" + regexp + "(\\b|\\s+|;|\\)|`|$).*", group)
      cmd = line.regexpCapture(".*(^|;|\\$\\(|`|\\|)\\s*" + regexp + "\\s*(;|\\||\\)|`|$).*", group)
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
