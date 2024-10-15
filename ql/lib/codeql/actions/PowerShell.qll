private import codeql.actions.Ast

class PowerShellScript extends ShellScript {
  PowerShellScript() {
    exists(Run run |
      this = run.getScript() and
      run.getShell().matches("pwsh%")
    )
  }

  override string getStmt(int i) { none() }

  override string getAStmt() { none() }

  override string getCommand(int i) { none() }

  override string getACommand() { none() }

  override string getFileReadCommand(int i) { none() }

  override string getAFileReadCommand() { none() }

  override predicate getAssignment(int i, string name, string data) { none() }

  override predicate getAnAssignment(string name, string data) { none() }

  override predicate getAWriteToGitHubEnv(string name, string data) { none() }

  override predicate getAWriteToGitHubOutput(string name, string data) { none() }

  override predicate getAWriteToGitHubPath(string data) { none() }

  override predicate getAnEnvReachingGitHubOutputWrite(string var, string output_field) { none() }

  override predicate getACmdReachingGitHubOutputWrite(string cmd, string output_field) { none() }

  override predicate getAnEnvReachingGitHubEnvWrite(string var, string output_field) { none() }

  override predicate getACmdReachingGitHubEnvWrite(string cmd, string output_field) { none() }

  override predicate getAnEnvReachingGitHubPathWrite(string var) { none() }

  override predicate getACmdReachingGitHubPathWrite(string cmd) { none() }

  override predicate getAnEnvReachingArgumentInjectionSink(
    string var, string command, string argument
  ) {
    none()
  }

  override predicate getACmdReachingArgumentInjectionSink(
    string cmd, string command, string argument
  ) {
    none()
  }

  override predicate fileToGitHubEnv(string path) { none() }

  override predicate fileToGitHubOutput(string path) { none() }

  override predicate fileToGitHubPath(string path) { none() }
}
