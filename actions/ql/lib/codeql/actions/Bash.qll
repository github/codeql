private import codeql.actions.Ast

class BashShellScript extends ShellScript {
  BashShellScript() {
    exists(Run run |
      this = run.getScript() and
      run.getShell().matches(["bash%", "sh"])
    )
  }

  private string lineProducer(int i) {
    result = this.getRawScript().regexpReplaceAll("\\\\\\s*\n", "").splitAt("\n", i)
  }

  private predicate cmdSubstitutionReplacement(string cmdSubs, string id, int k) {
    exists(string line | line = this.lineProducer(k) |
      exists(int i, int j |
        cmdSubs =
          // $() cmd substitution
          line.regexpFind("\\$\\((?:[^()]+|\\((?:[^()]+|\\([^()]*\\))*\\))*\\)", i, j)
              .regexpReplaceAll("^\\$\\(", "")
              .regexpReplaceAll("\\)$", "") and
        id = "cmdsubs:" + k + ":" + i + ":" + j
      )
      or
      exists(int i, int j |
        // `...` cmd substitution
        cmdSubs =
          line.regexpFind("\\`[^\\`]+\\`", i, j)
              .regexpReplaceAll("^\\`", "")
              .regexpReplaceAll("\\`$", "") and
        id = "cmd:" + k + ":" + i + ":" + j
      )
    )
  }

  private predicate rankedCmdSubstitutionReplacements(int i, string old, string new) {
    old = rank[i](string old2 | this.cmdSubstitutionReplacement(old2, _, _) | old2) and
    this.cmdSubstitutionReplacement(old, new, _)
  }

  private predicate doReplaceCmdSubstitutions(int line, int round, string old, string new) {
    round = 0 and
    old = this.lineProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doReplaceCmdSubstitutions(line, round - 1, old, middle) and
      this.rankedCmdSubstitutionReplacements(round, target, replacement) and
      new = middle.replaceAll(target, replacement)
    )
  }

  private string cmdSubstitutedLineProducer(int i) {
    // script lines where any command substitution has been replaced with a unique placeholder
    result =
      max(int round, string new |
        this.doReplaceCmdSubstitutions(i, round, _, new)
      |
        new order by round
      )
    or
    this.cmdSubstitutionReplacement(result, _, i)
  }

  private predicate quotedStringReplacement(string quotedStr, string id) {
    exists(string line, int k | line = this.cmdSubstitutedLineProducer(k) |
      exists(int i, int j |
        // double quoted string
        quotedStr = line.regexpFind("\"((?:[^\"\\\\]|\\\\.)*)\"", i, j) and
        id =
          "qstr:" + k + ":" + i + ":" + j + ":" + quotedStr.length() + ":" +
            quotedStr.regexpReplaceAll("[^a-zA-Z0-9]", "")
      )
      or
      exists(int i, int j |
        // single quoted string
        quotedStr = line.regexpFind("'((?:\\\\.|[^'\\\\])*)'", i, j) and
        id =
          "qstr:" + k + ":" + i + ":" + j + ":" + quotedStr.length() + ":" +
            quotedStr.regexpReplaceAll("[^a-zA-Z0-9]", "")
      )
    )
  }

  private predicate rankedQuotedStringReplacements(int i, string old, string new) {
    old = rank[i](string old2 | this.quotedStringReplacement(old2, _) | old2) and
    this.quotedStringReplacement(old, new)
  }

  private predicate doReplaceQuotedStrings(int line, int round, string old, string new) {
    round = 0 and
    old = this.cmdSubstitutedLineProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doReplaceQuotedStrings(line, round - 1, old, middle) and
      this.rankedQuotedStringReplacements(round, target, replacement) and
      new = middle.replaceAll(target, replacement)
    )
  }

  private string quotedStringLineProducer(int i) {
    result =
      max(int round, string new | this.doReplaceQuotedStrings(i, round, _, new) | new order by round)
  }

  private string stmtProducer(int i) {
    result = this.quotedStringLineProducer(i).splitAt(Bash::splitSeparator()).trim() and
    // when splitting the line with a separator that is not present, the result is the original line which may contain other separators
    // we only one the split parts that do not contain any of the separators
    not result.indexOf(Bash::splitSeparator()) > -1
  }

  private predicate doStmtRestoreQuotedStrings(int line, int round, string old, string new) {
    round = 0 and
    old = this.stmtProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doStmtRestoreQuotedStrings(line, round - 1, old, middle) and
      this.rankedQuotedStringReplacements(round, target, replacement) and
      new = middle.replaceAll(replacement, target)
    )
  }

  private string restoredStmtQuotedStringLineProducer(int i) {
    result =
      max(int round, string new |
        this.doStmtRestoreQuotedStrings(i, round, _, new)
      |
        new order by round
      ) and
    not result.indexOf("qstr:") > -1
  }

  private predicate doStmtRestoreCmdSubstitutions(int line, int round, string old, string new) {
    round = 0 and
    old = this.restoredStmtQuotedStringLineProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doStmtRestoreCmdSubstitutions(line, round - 1, old, middle) and
      this.rankedCmdSubstitutionReplacements(round, target, replacement) and
      new = middle.replaceAll(replacement, target)
    )
  }

  override string getStmt(int i) {
    result =
      max(int round, string new |
        this.doStmtRestoreCmdSubstitutions(i, round, _, new)
      |
        new order by round
      ) and
    not result.indexOf("cmdsubs:") > -1
  }

  override string getAStmt() { result = this.getStmt(_) }

  private string cmdProducer(int i) {
    result = this.quotedStringLineProducer(i).splitAt(Bash::separator()).trim() and
    // when splitting the line with a separator that is not present, the result is the original line which may contain other separators
    // we only one the split parts that do not contain any of the separators
    not result.indexOf(Bash::separator()) > -1
  }

  private predicate doCmdRestoreQuotedStrings(int line, int round, string old, string new) {
    round = 0 and
    old = this.cmdProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doCmdRestoreQuotedStrings(line, round - 1, old, middle) and
      this.rankedQuotedStringReplacements(round, target, replacement) and
      new = middle.replaceAll(replacement, target)
    )
  }

  private string restoredCmdQuotedStringLineProducer(int i) {
    result =
      max(int round, string new |
        this.doCmdRestoreQuotedStrings(i, round, _, new)
      |
        new order by round
      ) and
    not result.indexOf("qstr:") > -1
  }

  private predicate doCmdRestoreCmdSubstitutions(int line, int round, string old, string new) {
    round = 0 and
    old = this.restoredCmdQuotedStringLineProducer(line) and
    new = old
    or
    round > 0 and
    exists(string middle, string target, string replacement |
      this.doCmdRestoreCmdSubstitutions(line, round - 1, old, middle) and
      this.rankedCmdSubstitutionReplacements(round, target, replacement) and
      new = middle.replaceAll(replacement, target)
    )
  }

  string getCmd(int i) {
    result =
      max(int round, string new |
        this.doCmdRestoreCmdSubstitutions(i, round, _, new)
      |
        new order by round
      ) and
    not result.indexOf("cmdsubs:") > -1
  }

  string getACmd() { result = this.getCmd(_) }

  override string getCommand(int i) {
    // remove redirection
    result =
      this.getCmd(i)
          .regexpReplaceAll("(>|>>|2>|2>>|<|<<<)\\s*[\\{\\}\\$\"'_\\-0-9a-zA-Z]+$", "")
          .trim() and
    // exclude variable declarations
    not result.regexpMatch("^[a-zA-Z0-9\\-_]+=") and
    // exclude comments
    not result.trim().indexOf("#") = 0 and
    // exclude the following keywords
    not result =
      [
        "", "for", "in", "do", "done", "if", "then", "else", "elif", "fi", "while", "until", "case",
        "esac", "{", "}"
      ]
  }

  override string getACommand() { result = this.getCommand(_) }

  override string getFileReadCommand(int i) {
    result = this.getStmt(i) and
    result.matches(Bash::fileReadCommand() + "%")
  }

  override string getAFileReadCommand() { result = this.getFileReadCommand(_) }

  override predicate getAssignment(int i, string name, string data) {
    exists(string stmt |
      stmt = this.getStmt(i) and
      name = stmt.regexpCapture("^([a-zA-Z0-9\\-_]+)=.*", 1) and
      data = stmt.regexpCapture("^[a-zA-Z0-9\\-_]+=(.*)", 1)
    )
  }

  override predicate getAnAssignment(string name, string data) { this.getAssignment(_, name, data) }

  override predicate getAWriteToGitHubEnv(string name, string data) {
    exists(string raw |
      Bash::extractFileWrite(this, "GITHUB_ENV", raw) and
      Bash::extractVariableAndValue(raw, name, data)
    )
  }

  override predicate getAWriteToGitHubOutput(string name, string data) {
    exists(string raw |
      Bash::extractFileWrite(this, "GITHUB_OUTPUT", raw) and
      Bash::extractVariableAndValue(raw, name, data)
    )
  }

  override predicate getAWriteToGitHubPath(string data) {
    Bash::extractFileWrite(this, "GITHUB_PATH", data)
  }

  override predicate getAnEnvReachingGitHubOutputWrite(string var, string output_field) {
    Bash::envReachingGitHubFileWrite(this, var, "GITHUB_OUTPUT", output_field)
  }

  override predicate getACmdReachingGitHubOutputWrite(string cmd, string output_field) {
    Bash::cmdReachingGitHubFileWrite(this, cmd, "GITHUB_OUTPUT", output_field)
  }

  override predicate getAnEnvReachingGitHubEnvWrite(string var, string output_field) {
    Bash::envReachingGitHubFileWrite(this, var, "GITHUB_ENV", output_field)
  }

  override predicate getACmdReachingGitHubEnvWrite(string cmd, string output_field) {
    Bash::cmdReachingGitHubFileWrite(this, cmd, "GITHUB_ENV", output_field)
  }

  override predicate getAnEnvReachingGitHubPathWrite(string var) {
    Bash::envReachingGitHubFileWrite(this, var, "GITHUB_PATH", _)
  }

  override predicate getACmdReachingGitHubPathWrite(string cmd) {
    Bash::cmdReachingGitHubFileWrite(this, cmd, "GITHUB_PATH", _)
  }

  override predicate getAnEnvReachingArgumentInjectionSink(
    string var, string command, string argument
  ) {
    Bash::envReachingArgumentInjectionSink(this, var, command, argument)
  }

  override predicate getACmdReachingArgumentInjectionSink(
    string cmd, string command, string argument
  ) {
    Bash::cmdReachingArgumentInjectionSink(this, cmd, command, argument)
  }

  override predicate fileToGitHubEnv(string path) {
    Bash::fileToFileWrite(this, "GITHUB_ENV", path)
  }

  override predicate fileToGitHubOutput(string path) {
    Bash::fileToFileWrite(this, "GITHUB_OUTPUT", path)
  }

  override predicate fileToGitHubPath(string path) {
    Bash::fileToFileWrite(this, "GITHUB_PATH", path)
  }
}

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

  string fileReadCommand() { result = ["<", "cat", "jq", "yq", "tail", "head"] }

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
      cmd = expr.regexpCapture(regexp, 1).trim()
      or
      // `cmd`
      regexp = ".*`([^`]+)`.*" and
      cmd = expr.regexpCapture(regexp, 1).trim()
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
      regexp = "(?i)(echo|printf)\\s*(.*?)\\s*(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+)" and
      cmd = script.regexpCapture(regexp, 1) and
      file = trimQuotes(script.regexpCapture(regexp, 5)) and
      filters = "" and
      content = script.regexpCapture(regexp, 2)
    )
  }

  bindingset[script]
  predicate singleLineWorkflowCmd(string script, string cmd, string key, string value) {
    exists(string regexp |
      regexp = "(?i)(echo|printf)\\s*(['|\"])?::(set-[a-z]+)\\s*name\\s*=\\s*(.*?)::(.*)" and
      cmd = script.regexpCapture(regexp, 3) and
      key = script.regexpCapture(regexp, 4) and
      value = trimQuotes(script.regexpCapture(regexp, 5))
      or
      regexp = "(?i)(echo|printf)\\s*(['|\"])?::(add-[a-z]+)\\s*::(.*)" and
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

  bindingset[file_var]
  predicate extractFileWrite(BashShellScript script, string file_var, string content) {
    // single line assignment
    exists(string file_expr, string raw_content |
      isParameterExpansion(file_expr, file_var, _, _) and
      singleLineFileWrite(script.getAStmt(), _, file_expr, raw_content, _) and
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
      singleLineWorkflowCmd(script.getAStmt(), cmd, key, value)
    )
    or
    // multiline assignment
    exists(string file_expr, string raw_content |
      multiLineFileWrite(script.getRawScript(), _, file_expr, raw_content, _) and
      isParameterExpansion(file_expr, file_var, _, _) and
      content = trimQuotes(raw_content)
    )
  }

  /** Writes the content of the file specified by `path` into a file pointed to by `file_var` */
  predicate fileToFileWrite(BashShellScript script, string file_var, string path) {
    exists(string regexp, string stmt, string file_expr |
      regexp =
        "(?i)(cat)\\s*" + "((?:(?!<<|<<-)[^>\n])+)\\s*" +
          "(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*" + "(\\S+)" and
      stmt = script.getAStmt() and
      file_expr = trimQuotes(stmt.regexpCapture(regexp, 5)) and
      path = stmt.regexpCapture(regexp, 2) and
      containsParameterExpansion(file_expr, file_var, _, _)
    )
  }

  /**
   * Holds if the Run scripts contains an access to an environment variable called `var`
   * which value may get appended to the GITHUB_XXX special file
   */
  predicate envReachingGitHubFileWrite(
    BashShellScript script, string var, string file_var, string field
  ) {
    exists(string file_write_value |
      (
        file_var = "GITHUB_ENV" and
        script.getAWriteToGitHubEnv(field, file_write_value)
        or
        file_var = "GITHUB_OUTPUT" and
        script.getAWriteToGitHubOutput(field, file_write_value)
        or
        file_var = "GITHUB_PATH" and
        field = "PATH" and
        script.getAWriteToGitHubPath(file_write_value)
      ) and
      envReachingRunExpr(script, var, file_write_value)
    )
  }

  /**
   * Holds if and environment variable is used, directly or indirectly, in a Run's step expression.
   * Where the expression is a string captured from the Run's script.
   */
  bindingset[expr]
  predicate envReachingRunExpr(BashShellScript script, string var, string expr) {
    exists(string var2, string value2 |
      // VAR2=${VAR:-default} (var2=value2)
      // echo "FIELD=${VAR2:-default}" >> $GITHUB_ENV (field, file_write_value)
      script.getAnAssignment(var2, value2) and
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
  predicate cmdReachingGitHubFileWrite(
    BashShellScript script, string cmd, string file_var, string field
  ) {
    exists(string file_write_value |
      (
        file_var = "GITHUB_ENV" and
        script.getAWriteToGitHubEnv(field, file_write_value)
        or
        file_var = "GITHUB_OUTPUT" and
        script.getAWriteToGitHubOutput(field, file_write_value)
        or
        file_var = "GITHUB_PATH" and
        field = "PATH" and
        script.getAWriteToGitHubPath(file_write_value)
      ) and
      cmdReachingRunExpr(script, cmd, file_write_value)
    )
  }

  predicate envReachingArgumentInjectionSink(
    BashShellScript script, string source, string command, string argument
  ) {
    exists(string cmd, string regex, int command_group, int argument_group |
      cmd = script.getACommand() and
      argumentInjectionSinksDataModel(regex, command_group, argument_group) and
      argument = cmd.regexpCapture(regex, argument_group).trim() and
      command = cmd.regexpCapture(regex, command_group).trim() and
      envReachingRunExpr(script, source, argument)
    )
  }

  predicate cmdReachingArgumentInjectionSink(
    BashShellScript script, string source, string command, string argument
  ) {
    exists(string cmd, string regex, int command_group, int argument_group |
      cmd = script.getACommand() and
      argumentInjectionSinksDataModel(regex, command_group, argument_group) and
      argument = cmd.regexpCapture(regex, argument_group).trim() and
      command = cmd.regexpCapture(regex, command_group).trim() and
      cmdReachingRunExpr(script, source, argument)
    )
  }

  /**
   * Holds if a command output is used, directly or indirectly, in a Run's step expression.
   * Where the expression is a string captured from the Run's script.
   */
  bindingset[expr]
  predicate cmdReachingRunExpr(BashShellScript script, string cmd, string expr) {
    // cmd output is assigned to a second variable (var2) and var2 reaches the file write
    exists(string var2, string value2 |
      // VAR2=$(cmd)
      // echo "FIELD=${VAR2:-default}" >> $GITHUB_ENV (field, file_write_value)
      script.getAnAssignment(var2, value2) and
      containsCmdSubstitution(value2, cmd) and
      containsParameterExpansion(expr, var2, _, _) and
      not varMatchesRegexTest(script, var2, alphaNumericRegex())
    )
    or
    exists(string var2, string value2, string var3, string value3 |
      // VAR2=$(cmd)
      // VAR3=$VAR2
      // echo "FIELD=${VAR3:-default}" >> $GITHUB_ENV (field, file_write_value)
      containsCmdSubstitution(value2, cmd) and
      script.getAnAssignment(var2, value2) and
      containsParameterExpansion(value3, var2, _, _) and
      script.getAnAssignment(var3, value3) and
      containsParameterExpansion(expr, var3, _, _) and
      not varMatchesRegexTest(script, var2, alphaNumericRegex()) and
      not varMatchesRegexTest(script, var3, alphaNumericRegex())
    )
    or
    // var reaches the file write directly
    // echo "FIELD=$(cmd)" >> $GITHUB_ENV (field, file_write_value)
    containsCmdSubstitution(expr, cmd)
  }

  /**
   * Holds if there test command that checks a variable against a regex
   * eg: `[[ $VAR =~ ^[a-zA-Z0-9_]+$ ]]`
   */
  bindingset[var, regex]
  predicate varMatchesRegexTest(BashShellScript script, string var, string regex) {
    exists(string lhs, string rhs |
      lhs = script.getACommand().regexpCapture(".*\\[\\[\\s*(.*?)\\s*=~\\s*(.*?)\\s*\\]\\].*", 1) and
      containsParameterExpansion(lhs, var, _, _) and
      rhs = script.getACommand().regexpCapture(".*\\[\\[\\s*(.*?)\\s*=~\\s*(.*?)\\s*\\]\\].*", 2) and
      trimQuotes(rhs).regexpMatch(regex)
    )
  }

  /**
   * Holds if the given regex is used to match an alphanumeric string
   * eg: `^[0-9a-zA-Z]{40}$`, `^[0-9]+$` or `^[a-zA-Z0-9_]+$`
   */
  string alphaNumericRegex() { result = "^\\^\\[([09azAZ_-]+)\\](\\+|\\{\\d+\\})\\$$" }
}
