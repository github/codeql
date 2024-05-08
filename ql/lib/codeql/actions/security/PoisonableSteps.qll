import actions

abstract class PoisonableStep extends Step { }

// source: https://github.com/boostsecurityio/poutine/blob/main/opa/rego/rules/untrusted_checkout_exec.rego#L16
private string dangerousActions() {
  result =
    ["pre-commit/action", "oxsecurity/megalinter", "bridgecrewio/checkov-action", "ruby/setup-ruby"]
}

class DangerousActionUsesStep extends PoisonableStep, UsesStep {
  DangerousActionUsesStep() { this.getCallee() = dangerousActions() }
}

// source: https://github.com/boostsecurityio/poutine/blob/main/opa/rego/rules/untrusted_checkout_exec.rego#L23
private string dangerousCommands() {
  result =
    [
      "npm install", "npm run ", "yarn ", "npm ci(\\b|$)", "make ", "terraform plan",
      "terraform apply", "gomplate ", "pre-commit run", "pre-commit install", "go generate",
      "msbuild ", "mvn ", "./mvnw ", "gradle ", "./gradlew ", "bundle install", "bundle exec ",
      "^ant ", "mkdocs build", "pytest"
    ]
}

class BuildRunStep extends PoisonableStep, Run {
  BuildRunStep() {
    exists(
      this.getScript().splitAt("\n").trim().regexpFind("([^a-z]|^)" + dangerousCommands(), _, _)
    )
  }
}

class LocalCommandExecutionRunStep extends PoisonableStep, Run {
  string cmd;

  LocalCommandExecutionRunStep() {
    // Heuristic:
    // Run step with a command starting with `./xxxx`, `sh xxxx`, ...
    exists(string line | line = this.getScript().splitAt("\n").trim() |
      // ./xxxx
      cmd = line.regexpCapture("(^|\\s+)\\.\\/(.*)", 2)
      or
      // sh xxxx
      cmd = line.regexpCapture("(^|\\s+)(ba|z|fi)?sh\\s+(.*)", 3)
      or
      // node xxxx
      cmd = line.regexpCapture("(^|\\s+)(node|python|ruby|go)\\s+(.*)", 3)
    )
  }

  string getCommand() { result = cmd }
}

class LocalActionUsesStep extends PoisonableStep, UsesStep {
  LocalActionUsesStep() { this.getCallee().matches("./%") }
}

class EnvVarInjectionRunStep extends PoisonableStep, Run {
  EnvVarInjectionRunStep() {
    exists(string value |
      // Heuristic:
      // Run step with env var definition based on file content.
      // eg: `echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV`
      // eg: `echo "sha=$(<test-results/sha-number)" >> $GITHUB_ENV`
      Utils::writeToGitHubEnv(this, _, value) and
      // TODO: add support for other commands like `<`, `jq`, ...
      value.regexpMatch(["\\$\\(", "`"] + ["ls\\s+", "cat\\s+", "<"] + ".*" + ["`", "\\)"])
    )
  }
}
