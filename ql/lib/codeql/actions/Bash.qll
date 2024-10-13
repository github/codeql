private import codeql.actions.Ast
private import codeql.Locations
import codeql.actions.config.Config
private import codeql.actions.security.ControlChecks

module Bash {
  string stmtSeparator() { result = ";" }

  string commandSeparator() { result = ["&&", "||"] }

  string splitSeparator() {
    result = stmtSeparator() or
    result = commandSeparator()
  }

  string redirectionSeparator() { result = [">", ">>", "2>", "2>>", ">&", "2>&", "<", "<<<"] }

  string pipeSeparator() { result = "|" }

  string separator() {
    result = stmtSeparator() or
    result = commandSeparator() or
    result = pipeSeparator()
  }

  string partialFileContentCommand() { result = ["cat", "jq", "yq", "tail", "head"] }

  /** Checks if expr is a bash command substitution */
  bindingset[expr]
  predicate isCmdSubstitution(string expr, string cmd) {
    exists(string regexp |
      // $(cmd)
      regexp = "\\$\\(([^)]+)\\)" and
      cmd = expr.regexpCapture(regexp, 1)
      or
      // `cmd`
      regexp = "`([^`]+)`" and
      cmd = expr.regexpCapture(regexp, 1)
    )
  }

  /** Checks if expr is a bash command substitution */
  bindingset[expr]
  predicate containsCmdSubstitution(string expr, string cmd) {
    exists(string regexp |
      // $(cmd)
      regexp = ".*\\$\\(([^)]+)\\).*" and
      cmd = expr.regexpCapture(regexp, 1)
      or
      // `cmd`
      regexp = ".*`([^`]+)`.*" and
      cmd = expr.regexpCapture(regexp, 1)
    )
  }

  /** Checks if expr is a bash parameter expansion */
  bindingset[expr]
  predicate isParameterExpansion(string expr, string parameter, string operator, string params) {
    exists(string regexp |
      // $VAR
      regexp = "\\$([a-zA-Z_][a-zA-Z0-9_]+)\\b" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = "" and
      params = ""
      or
      // ${VAR}
      regexp = "\\$\\{([a-zA-Z_][a-zA-Z0-9_]*)\\}" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = "" and
      params = ""
      or
      // ${!VAR}
      regexp = "\\$\\{([!#])([a-zA-Z_][a-zA-Z0-9_]*)\\}" and
      parameter = expr.regexpCapture(regexp, 2) and
      operator = expr.regexpCapture(regexp, 1) and
      params = ""
      or
      // ${VAR<OP><PARAMS>}, ...
      regexp = "\\$\\{([a-zA-Z_][a-zA-Z0-9_]*)([#%/:^,\\-+]{1,2})?(.*?)\\}" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = expr.regexpCapture(regexp, 2) and
      params = expr.regexpCapture(regexp, 3)
    )
  }

  bindingset[expr]
  predicate containsParameterExpansion(string expr, string parameter, string operator, string params) {
    exists(string regexp |
      // $VAR
      regexp = ".*\\$([a-zA-Z_][a-zA-Z0-9_]+)\\b.*" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = "" and
      params = ""
      or
      // ${VAR}
      regexp = ".*\\$\\{([a-zA-Z_][a-zA-Z0-9_]*)\\}.*" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = "" and
      params = ""
      or
      // ${!VAR}
      regexp = ".*\\$\\{([!#])([a-zA-Z_][a-zA-Z0-9_]*)\\}.*" and
      parameter = expr.regexpCapture(regexp, 2) and
      operator = expr.regexpCapture(regexp, 1) and
      params = ""
      or
      // ${VAR<OP><PARAMS>}, ...
      regexp = ".*\\$\\{([a-zA-Z_][a-zA-Z0-9_]*)([#%/:^,\\-+]{1,2})?(.*?)\\}.*" and
      parameter = expr.regexpCapture(regexp, 1) and
      operator = expr.regexpCapture(regexp, 2) and
      params = expr.regexpCapture(regexp, 3)
    )
  }

  bindingset[raw_content]
  predicate extractVariableAndValue(string raw_content, string key, string value) {
    exists(string regexp, string content | content = trimQuotes(raw_content) |
      regexp = "(?msi).*^([a-zA-Z_][a-zA-Z0-9_]*)\\s*<<\\s*['\"]?(\\S+)['\"]?\\s*\n(.*?)\n\\2\\s*$" and
      key = trimQuotes(content.regexpCapture(regexp, 1)) and
      value = trimQuotes(content.regexpCapture(regexp, 3))
      or
      exists(string line |
        line = content.splitAt("\n") and
        regexp = "(?i)^([a-zA-Z_][a-zA-Z0-9_\\-]*)\\s*=\\s*(.*)$" and
        key = trimQuotes(line.regexpCapture(regexp, 1)) and
        value = trimQuotes(line.regexpCapture(regexp, 2))
      )
    )
  }

  bindingset[script]
  predicate singleLineFileWrite(
    string script, string cmd, string file, string content, string filters
  ) {
    exists(string regexp |
      regexp =
        "(?i)(echo|printf|write-output)\\s*(.*?)\\s*(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+)" and
      cmd = script.regexpCapture(regexp, 1) and
      file = trimQuotes(script.regexpCapture(regexp, 5)) and
      filters = "" and
      content = script.regexpCapture(regexp, 2)
    )
  }

  bindingset[script]
  predicate singleLineWorkflowCmd(string script, string cmd, string key, string value) {
    exists(string regexp |
      regexp =
        "(?i)(echo|printf|write-output)\\s*(['|\"])?::(set-[a-z]+)\\s*name\\s*=\\s*(.*?)::(.*)" and
      cmd = script.regexpCapture(regexp, 3) and
      key = script.regexpCapture(regexp, 4) and
      value = trimQuotes(script.regexpCapture(regexp, 5))
      or
      regexp = "(?i)(echo|printf|write-output)\\s*(['|\"])?::(add-[a-z]+)\\s*::(.*)" and
      cmd = script.regexpCapture(regexp, 3) and
      key = "" and
      value = trimQuotes(script.regexpCapture(regexp, 4))
    )
  }

  bindingset[script]
  predicate heredocFileWrite(string script, string cmd, string file, string content, string filters) {
    exists(string regexp |
      regexp =
        "(?msi).*^(cat)\\s*(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+)\\s*<<\\s*['\"]?(\\S+)['\"]?\\s*\n(.*?)\n\\4\\s*$.*" and
      cmd = script.regexpCapture(regexp, 1) and
      file = trimQuotes(script.regexpCapture(regexp, 4)) and
      content = script.regexpCapture(regexp, 6) and
      filters = ""
      or
      regexp =
        "(?msi).*^(cat)\\s*(<<|<)\\s*[-]?['\"]?(\\S+)['\"]?\\s*([^>]*)(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+)\\s*\n(.*?)\n\\3\\s*$.*" and
      cmd = script.regexpCapture(regexp, 1) and
      file = trimQuotes(script.regexpCapture(regexp, 7)) and
      filters = script.regexpCapture(regexp, 4) and
      content = script.regexpCapture(regexp, 8)
    )
  }

  bindingset[script]
  predicate linesFileWrite(string script, string cmd, string file, string content, string filters) {
    exists(string regexp, string var_name |
      regexp =
        "(?msi).*((echo|printf)\\s+['|\"]?(.*?<<(\\S+))['|\"]?\\s*>>\\s*(\\S+)\\s*[\r\n]+)" +
          "(((.*?)\\s*>>\\s*\\S+\\s*[\r\n]+)+)" +
          "((echo|printf)\\s+['|\"]?(EOF)['|\"]?\\s*>>\\s*\\S+\\s*[\r\n]*).*" and
      var_name = trimQuotes(script.regexpCapture(regexp, 3)).regexpReplaceAll("<<\\s*(\\S+)", "") and
      content =
        var_name + "=$(" +
          trimQuotes(script.regexpCapture(regexp, 6))
              .regexpReplaceAll(">>.*GITHUB_(ENV|OUTPUT)(})?", "")
              .trim() + ")" and
      cmd = "echo" and
      file = trimQuotes(script.regexpCapture(regexp, 5)) and
      filters = ""
    )
  }

  bindingset[script]
  predicate blockFileWrite(string script, string cmd, string file, string content, string filters) {
    exists(string regexp, string first_line, string var_name |
      regexp =
        "(?msi).*^\\s*\\{\\s*[\r\n]" +
          //
          "(.*?)" +
          //
          "(\\s*\\}\\s*(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+))\\s*$.*" and
      first_line = script.regexpCapture(regexp, 1).splitAt("\n", 0).trim() and
      var_name = first_line.regexpCapture("echo\\s+('|\\\")?(.*)<<.*", 2) and
      content = var_name + "=$(" + script.regexpCapture(regexp, 1).splitAt("\n").trim() + ")" and
      not content.indexOf("EOF") > 0 and
      file = trimQuotes(script.regexpCapture(regexp, 5)) and
      cmd = "echo" and
      filters = ""
    )
  }

  bindingset[script]
  predicate multiLineFileWrite(
    string script, string cmd, string file, string content, string filters
  ) {
    heredocFileWrite(script, cmd, file, content, filters)
    or
    linesFileWrite(script, cmd, file, content, filters)
    or
    blockFileWrite(script, cmd, file, content, filters)
  }

  bindingset[script, file_var]
  predicate extractFileWrite(string script, string file_var, string content) {
    // single line assignment
    exists(string file_expr, string raw_content |
      isParameterExpansion(file_expr, file_var, _, _) and
      singleLineFileWrite(script.splitAt("\n"), _, file_expr, raw_content, _) and
      content = trimQuotes(raw_content)
    )
    or
    // workflow command assignment
    exists(string key, string value, string cmd |
      (
        file_var = "GITHUB_ENV" and
        cmd = "set-env" and
        content = key + "=" + value
        or
        file_var = "GITHUB_OUTPUT" and
        cmd = "set-output" and
        content = key + "=" + value
        or
        file_var = "GITHUB_PATH" and
        cmd = "add-path" and
        content = value
      ) and
      singleLineWorkflowCmd(script.splitAt("\n"), cmd, key, value)
    )
    or
    // multiline assignment
    exists(string file_expr, string raw_content |
      multiLineFileWrite(script, _, file_expr, raw_content, _) and
      isParameterExpansion(file_expr, file_var, _, _) and
      content = trimQuotes(raw_content)
    )
  }

  /** Writes the content of the file specified by `path` into a file pointed to by `file_var` */
  predicate fileToFileWrite(Run run, string file_var, string path) {
    exists(string regexp, string stmt, string file_expr |
      regexp =
        "(?i)(cat)\\s*" + "((?:(?!<<|<<-)[^>\n])+)\\s*" +
          "(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*" + "(\\S+)" and
      stmt = run.getAStmt() and
      file_expr = trimQuotes(stmt.regexpCapture(regexp, 5)) and
      path = stmt.regexpCapture(regexp, 2) and
      containsParameterExpansion(file_expr, file_var, _, _)
    )
  }

  predicate fileToGitHubEnv(Run run, string path) { fileToFileWrite(run, "GITHUB_ENV", path) }

  predicate fileToGitHubOutput(Run run, string path) { fileToFileWrite(run, "GITHUB_OUTPUT", path) }

  predicate fileToGitHubPath(Run run, string path) { fileToFileWrite(run, "GITHUB_PATH", path) }

  bindingset[snippet]
  predicate outputsPartialFileContent(Run run, string snippet) {
    // e.g.
    // echo FOO=`yq '.foo' foo.yml` >> $GITHUB_ENV
    // echo "FOO=$(<foo.txt)" >> $GITHUB_ENV
    // yq '.foo' foo.yml >> $GITHUB_PATH
    // cat foo.txt >> $GITHUB_PATH
    exists(int i, string line, string cmd |
      run.getStmt(i) = line and
      line.indexOf(snippet.regexpReplaceAll("^\\$\\(", "").regexpReplaceAll("\\)$", "")) > -1 and
      run.getCommand(i) = cmd and
      cmd.indexOf(["<", Bash::partialFileContentCommand() + " "]) = 0
    )
  }

  /**
   * Holds if the Run scripts contains an access to an environment variable called `var`
   * which value may get appended to the GITHUB_XXX special file
   */
  predicate envReachingGitHubFileWrite(Run run, string var, string file_var, string field) {
    exists(string file_write_value |
      (
        file_var = "GITHUB_ENV" and
        run.getAWriteToGitHubEnv(field, file_write_value)
        or
        file_var = "GITHUB_OUTPUT" and
        run.getAWriteToGitHubOutput(field, file_write_value)
        or
        file_var = "GITHUB_PATH" and
        field = "PATH" and
        run.getAWriteToGitHubPath(file_write_value)
      ) and
      envReachingRunExpr(run, var, file_write_value)
    )
  }

  /**
   * Holds if and environment variable is used, directly or indirectly, in a Run's step expression.
   * Where the expression is a string captured from the Run's script.
   */
  bindingset[expr]
  predicate envReachingRunExpr(Run run, string var, string expr) {
    exists(string var2, string value2 |
      // VAR2=${VAR:-default} (var2=value2)
      // echo "FIELD=${VAR2:-default}" >> $GITHUB_ENV (field, file_write_value)
      run.getAnAssignment(var2, value2) and
      containsParameterExpansion(value2, var, _, _) and
      containsParameterExpansion(expr, var2, _, _)
    )
    or
    // var reaches the file write directly
    // echo "FIELD=${VAR:-default}" >> $GITHUB_ENV (field, file_write_value)
    containsParameterExpansion(expr, var, _, _)
  }

  /**
   * Holds if the Run scripts contains a command substitution (`cmd`)
   * which output may get appended to the GITHUB_XXX special file
   */
  predicate cmdReachingGitHubFileWrite(Run run, string cmd, string file_var, string field) {
    exists(string file_write_value |
      (
        file_var = "GITHUB_ENV" and
        run.getAWriteToGitHubEnv(field, file_write_value)
        or
        file_var = "GITHUB_OUTPUT" and
        run.getAWriteToGitHubOutput(field, file_write_value)
        or
        file_var = "GITHUB_PATH" and
        field = "PATH" and
        run.getAWriteToGitHubPath(file_write_value)
      ) and
      (
        // cmd output is assigned to a second variable (var2) and var2 reaches the file write
        exists(string var2, string value2 |
          // VAR2=$(cmd)
          // echo "FIELD=${VAR2:-default}" >> $GITHUB_ENV (field, file_write_value)
          run.getAnAssignment(var2, value2) and
          containsCmdSubstitution(value2, cmd) and
          containsParameterExpansion(file_write_value, var2, _, _)
        )
        or
        // var reaches the file write directly
        // echo "FIELD=$(cmd)" >> $GITHUB_ENV (field, file_write_value)
        containsCmdSubstitution(file_write_value, cmd)
      )
    )
  }
}
