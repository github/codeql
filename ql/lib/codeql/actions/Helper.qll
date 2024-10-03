private import codeql.actions.Ast
private import codeql.Locations
import codeql.actions.config.Config
private import codeql.actions.security.ControlChecks

bindingset[expr]
string normalizeExpr(string expr) {
  result =
    expr.regexpReplaceAll("\\['([a-zA-Z0-9_\\*\\-]+)'\\]", ".$1")
        .regexpReplaceAll("\\[\"([a-zA-Z0-9_\\*\\-]+)\"\\]", ".$1")
        .regexpReplaceAll("\\s*\\.\\s*", ".")
}

bindingset[regex]
string wrapRegexp(string regex) { result = "\\b" + regex + "\\b" }

bindingset[regex]
string wrapJsonRegexp(string regex) {
  result = ["fromJSON\\(\\s*" + regex + "\\s*\\)", "toJSON\\(\\s*" + regex + "\\s*\\)"]
}

bindingset[str]
string trimQuotes(string str) {
  result = str.trim().regexpReplaceAll("^(\"|')", "").regexpReplaceAll("(\"|')$", "")
}

predicate inPrivilegedContext(AstNode node, Event event) {
  node.getEnclosingJob().isPrivilegedExternallyTriggerable(event)
}

predicate inNonPrivilegedContext(AstNode node) {
  not node.getEnclosingJob().isPrivilegedExternallyTriggerable(_)
}

string defaultBranchNames() {
  repositoryDataModel(_, result)
  or
  not exists(string default_branch_name | repositoryDataModel(_, default_branch_name)) and
  result = ["main", "master"]
}

string getRepoRoot() {
  exists(Workflow w |
    w.getLocation().getFile().getRelativePath().indexOf("/.github/workflows") > 0 and
    result =
      w.getLocation()
          .getFile()
          .getRelativePath()
          .prefix(w.getLocation().getFile().getRelativePath().indexOf("/.github/workflows") + 1) and
    // exclude workflow_enum reusable workflows directory root
    not result.indexOf(".github/reusable_workflows/") > -1
    or
    not w.getLocation().getFile().getRelativePath().indexOf("/.github/workflows") > 0 and
    not w.getLocation().getFile().getRelativePath().indexOf(".github/reusable_workflows") > -1 and
    result = ""
  )
}

bindingset[path]
string normalizePath(string path) {
  exists(string trimmed_path | trimmed_path = trimQuotes(path) |
    // ./foo -> GITHUB_WORKSPACE/foo
    if path.indexOf("./") = 0
    then result = path.replaceAll("./", "GITHUB_WORKSPACE/")
    else
      // GITHUB_WORKSPACE/foo -> GITHUB_WORKSPACE/foo
      if path.indexOf("GITHUB_WORKSPACE/") = 0
      then result = path
      else
        // foo -> GITHUB_WORKSPACE/foo
        if path.regexpMatch("^[^/~].*")
        then result = "GITHUB_WORKSPACE/" + path.regexpReplaceAll("/$", "")
        else
          // ~/foo -> ~/foo
          // /foo -> /foo
          result = path
  )
}

/**
 * Holds if the path cache_path is a subpath of the path untrusted_path.
 */
bindingset[subpath, path]
predicate isSubpath(string subpath, string path) { subpath.substring(0, path.length()) = path }

module Bash {
  string stmtSeparator() { result = ";" }

  string commandSeparator() { result = ["&&", "||"] }

  string pipeSeparator() { result = "|" }

  string splitSeparators() {
    result = stmtSeparator() or result = commandSeparator() or result = pipeSeparator()
  }

  string redirectionSeparator() { result = [">", ">>", "2>", "2>>", ">&", "2>&", "<", "<<<"] }

  string partialFileContentCommand() { result = ["cat", "jq", "yq", "tail", "head"] }

  /** Checks if expr is a bash parameter expansion */
  bindingset[expr]
  predicate isBashParameterExpansion(string expr, string parameter, string operator, string params) {
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
    exists(string regexp |
      regexp =
        "(?msi).*((echo|printf)\\s+['|\"]?(.*?<<(\\S+))['|\"]?\\s*>>\\s*(\\S+)\\s*[\r\n]+)" +
          "(((.*?)\\s*>>\\s*\\S+\\s*[\r\n]+)+)" +
          "((echo|printf)\\s+['|\"]?(EOF)['|\"]?\\s*>>\\s*\\S+\\s*[\r\n]*).*" and
      content =
        trimQuotes(script.regexpCapture(regexp, 3)) + "\n" +
          // "$(" +
          trimQuotes(script.regexpCapture(regexp, 6)) +
          // ")\n" +
          "\n" + trimQuotes(script.regexpCapture(regexp, 4)) and
      cmd = "echo" and
      file = trimQuotes(script.regexpCapture(regexp, 5)) and
      filters = ""
    )
  }

  bindingset[script]
  predicate blockFileWrite(string script, string cmd, string file, string content, string filters) {
    exists(string regexp |
      regexp =
        "(?msi).*^\\s*\\{\\s*[\r\n]" +
          //
          "(.*?)" +
          //
          "(\\s*\\}\\s*(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*(\\S+))\\s*$.*" and
      content =
        script
            .regexpCapture(regexp, 1)
            .regexpReplaceAll("(?m)^\\s*(echo|printf|write-output)\\s*['\"](.*?)['\"]", "$2")
            .regexpReplaceAll("(?m)^\\s*(echo|printf|write-output)\\s*", "") and
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
      isBashParameterExpansion(file_expr, file_var, _, _) and
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
      isBashParameterExpansion(file_expr, file_var, _, _) and
      content = trimQuotes(raw_content)
    )
  }

  /** Writes the content of the file specified by `path` into a file pointed to by `file_var` */
  bindingset[script, file_var]
  predicate fileToFileWrite(string script, string file_var, string path) {
    exists(string regexp, string line, string file_expr |
      isBashParameterExpansion(file_expr, file_var, _, _) and
      regexp =
        "(?i)(cat)\\s*" + "((?:(?!<<|<<-)[^>\n])+)\\s*" +
          "(>>|>|\\s*\\|\\s*tee\\s*(-a|--append)?)\\s*" + "(\\S+)" and
      line = script.splitAt("\n") and
      path = line.regexpCapture(regexp, 2) and
      file_expr = trimQuotes(line.regexpCapture(regexp, 5))
    )
  }

  predicate fileToGitHubEnv(Run run, string path) {
    fileToFileWrite(run.getScript(), "GITHUB_ENV", path)
  }

  predicate fileToGitHubOutput(Run run, string path) {
    fileToFileWrite(run.getScript(), "GITHUB_OUTPUT", path)
  }

  predicate fileToGitHubPath(Run run, string path) {
    fileToFileWrite(run.getScript(), "GITHUB_PATH", path)
  }

  bindingset[snippet]
  predicate outputsPartialFileContent(Run run, string snippet) {
    // e.g.
    // echo FOO=`yq '.foo' foo.yml` >> $GITHUB_ENV
    // echo "FOO=$(<foo.txt)" >> $GITHUB_ENV
    // yq '.foo' foo.yml >> $GITHUB_PATH
    // cat foo.txt >> $GITHUB_PATH
    // Bash::getACommand(snippet).indexOf(["<", Bash::partialFileContentCommand() + " "]) = 0
    exists(int i, string line, string cmd |
      run.getStmt(i) = line and
      line.matches("%" + snippet + "%") and
      run.getCommand(i) = cmd and
      cmd.indexOf(["<", Bash::partialFileContentCommand() + " "]) = 0
    )
  }
}
