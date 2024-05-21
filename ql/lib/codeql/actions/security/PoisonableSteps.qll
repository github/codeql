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
      "msbuild ", "mvn ", "gradle ", "bundle install", "bundle exec ", "^ant ", "mkdocs build",
      "pytest", "pip install -r ", "pip install --requirement", "java -jar "
    ]
}

class BuildRunStep extends PoisonableStep, Run {
  BuildRunStep() {
    exists(
      this.getScript().splitAt("\n").trim().regexpFind("([^a-z]|^)" + dangerousCommands(), _, _)
    )
  }
}

bindingset[cmdRegexp]
string wrapLocalCmd(string cmdRegexp) { result = "(^|;\\s*|\\s+)" + cmdRegexp + "(\\s+|;|$)" }

class LocalCommandExecutionRunStep extends PoisonableStep, Run {
  string cmd;

  LocalCommandExecutionRunStep() {
    // Heuristic:
    exists(string line | line = this.getScript().splitAt("\n").trim() |
      // ./xxxx
      // TODO: It could also be in the form of `dir/cmd`
      cmd = line.regexpCapture(wrapLocalCmd("\\.\\/(.*)"), 2)
      or
      // sh xxxx
      cmd = line.regexpCapture(wrapLocalCmd("(ba|z|fi)?sh\\s+(.*)"), 3)
      or
      // node xxxx.js
      cmd = line.regexpCapture(wrapLocalCmd("node\\s+(.*)(\\.js|\\.ts)"), 2)
      or
      // python xxxx.py
      cmd = line.regexpCapture(wrapLocalCmd("python\\s+(.*)\\.py"), 2)
      or
      // ruby xxxx.rb
      cmd = line.regexpCapture(wrapLocalCmd("ruby\\s+(.*)\\.rb"), 2)
      or
      // go xxxx.go
      cmd = line.regexpCapture(wrapLocalCmd("go\\s+(.*)\\.go"), 2)
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
      writeToGitHubEnv(this, _, value) and
      // TODO: add support for other commands like `<`, `jq`, ...
      value.regexpMatch(["\\$\\(", "`"] + ["ls\\s+", "cat\\s+", "<"] + ".*" + ["`", "\\)"])
    )
  }
}
