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
      exists(this.getScript().splitAt("\n").trim().regexpFind("([^a-z]|^)" + regexp, _, _))
    )
  }
}

class LocalScriptExecutionRunStep extends PoisonableStep, Run {
  string cmd;

  LocalScriptExecutionRunStep() {
    exists(string line, string regexp, int group | line = this.getScript().splitAt("\n").trim() |
      poisonableLocalScriptsDataModel(regexp, group) and
      cmd = line.regexpCapture(regexp, group)
    )
  }

  string getCommand() { result = cmd }
}

class LocalActionUsesStep extends PoisonableStep, UsesStep {
  LocalActionUsesStep() { this.getCallee().matches("./%") }
}

class EnvVarInjectionRunStep extends PoisonableStep, Run {
  EnvVarInjectionRunStep() {
    exists(string content, string value |
      // Heuristic:
      // Run step with env var definition based on file content.
      // eg: `echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV`
      // eg: `echo "sha=$(<test-results/sha-number)" >> $GITHUB_ENV`
      writeToGitHubEnv(this, content) and
      extractVariableAndValue(content, _, value) and
      value.matches("%" + ["ls ", "cat ", "jq ", "$(<"] + "%")
    )
  }
}
