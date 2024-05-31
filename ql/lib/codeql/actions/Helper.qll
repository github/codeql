private import codeql.actions.Ast
private import codeql.Locations

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
private string trimQuotes(string str) {
  result = str.trim().regexpReplaceAll("^(\"|')", "").regexpReplaceAll("(\"|')$", "")
}

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

// TODO, the followinr test fails
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
predicate singleLineFileWrite(string script, string cmd, string file, string content, string filters) {
  exists(string regexp |
    regexp = "(?i)(echo|write-output)\\s*(.*?)\\s*(>>|>)\\s*(\\S+)" and
    cmd = script.regexpCapture(regexp, 1) and
    file = trimQuotes(script.regexpCapture(regexp, 4)) and
    filters = "" and
    content = script.regexpCapture(regexp, 2)
  )
}

bindingset[script]
predicate singleLineWorkflowCmd(string script, string cmd, string key, string value) {
  exists(string regexp |
    regexp = "(?i)(echo|write-output)\\s*(['|\"])?::(set-[a-z]+)\\s*name\\s*=\\s*(.*?)::(.*)" and
    cmd = script.regexpCapture(regexp, 3) and
    key = script.regexpCapture(regexp, 4) and
    value = trimQuotes(script.regexpCapture(regexp, 5))
    or
    regexp = "(?i)(echo|write-output)\\s*(['|\"])?::(add-[a-z]+)\\s*::(.*)" and
    cmd = script.regexpCapture(regexp, 3) and
    key = "" and
    value = trimQuotes(script.regexpCapture(regexp, 4))
  )
}

bindingset[script]
predicate heredocFileWrite(string script, string cmd, string file, string content, string filters) {
  exists(string regexp |
    regexp = "(?msi).*^(cat)\\s*(>>|>)\\s*(\\S+)\\s*<<\\s*['\"]?(\\S+)['\"]?\\s*\n(.*?)\n\\4\\s*$.*" and
    cmd = script.regexpCapture(regexp, 1) and
    file = trimQuotes(script.regexpCapture(regexp, 3)) and
    content = script.regexpCapture(regexp, 5) and
    filters = ""
    or
    regexp =
      "(?msi).*^(cat)\\s*(<<|<)\\s*[-]?['\"]?(\\S+)['\"]?\\s*([^>]*)(>>|>)\\s*(\\S+)\\s*\n(.*?)\n\\3\\s*$.*" and
    cmd = script.regexpCapture(regexp, 1) and
    file = trimQuotes(script.regexpCapture(regexp, 6)) and
    filters = script.regexpCapture(regexp, 4) and
    content = script.regexpCapture(regexp, 7)
  )
}

bindingset[script]
predicate linesFileWrite(string script, string cmd, string file, string content, string filters) {
  exists(string regexp |
    regexp =
      "(?msi).*(echo\\s+['|\"]?(.*?<<(\\S+))['|\"]?\\s*>>\\s*(\\S+)\\s*[\r\n]+)" +
        "(((.*?)\\s*>>\\s*\\S+\\s*[\r\n]+)+)" +
        "(echo\\s+['|\"]?(EOF)['|\"]?\\s*>>\\s*\\S+\\s*[\r\n]*).*" and
    content =
      trimQuotes(script.regexpCapture(regexp, 2)) + "\n" + "$(" +
        trimQuotes(script.regexpCapture(regexp, 5)) +
        // TODO: there are some >> $GITHUB_ENV, >> $GITHUB_OUTPUT, >> "$GITHUB_ENV" lefotvers in content
        //.regexpReplaceAll("\\s*(>|>>)\\s*\\$[{]*" + file + "(.*?)[}]*", "")
        ")\n" + trimQuotes(script.regexpCapture(regexp, 3)) and
    cmd = "echo" and
    file = trimQuotes(script.regexpCapture(regexp, 4)) and
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
        "(\\s*\\}\\s*(>>|>)\\s*(\\S+))\\s*$.*" and
    content =
      script
          .regexpCapture(regexp, 1)
          .regexpReplaceAll("(?m)^[ ]*echo\\s*['\"](.*?)['\"]", "$1")
          .regexpReplaceAll("(?m)^[ ]*echo\\s*", "") and
    file = trimQuotes(script.regexpCapture(regexp, 4)) and
    cmd = "echo" and
    filters = ""
  )
}

bindingset[script]
predicate multiLineFileWrite(string script, string cmd, string file, string content, string filters) {
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

predicate writeToGitHubEnv(Run run, string content) {
  extractFileWrite(run.getScript(), "GITHUB_ENV", content)
}

predicate writeToGitHubOutput(Run run, string content) {
  extractFileWrite(run.getScript(), "GITHUB_OUTPUT", content)
}

predicate writeToGitHubPath(Run run, string content) {
  extractFileWrite(run.getScript(), "GITHUB_PATH", content)
}

predicate inPrivilegedCompositeAction(AstNode node) {
  exists(CompositeAction a |
    // node is in a privileged composite action
    a = node.getEnclosingCompositeAction() and
    (
      a.isPrivileged()
      or
      exists(Job caller |
        caller = a.getACaller() and
        caller.isPrivileged() and
        caller.isExternallyTriggerable()
      )
    )
  )
}

predicate inPrivilegedExternallyTriggerableJob(AstNode node) {
  exists(Job j |
    // node is in a privileged and externally triggereable job
    j = node.getEnclosingJob() and
    // job is privileged (write access or access to secrets)
    j.isPrivileged() and
    // job is triggereable by an external user
    j.isExternallyTriggerable()
  )
}

predicate inNonPrivilegedCompositeAction(AstNode node) {
  exists(CompositeAction a |
    // node is in a non-privileged composite action
    a = node.getEnclosingCompositeAction() and
    not a.isPrivileged() and
    not exists(LocalJob caller |
      caller = a.getACaller() and
      caller.isPrivileged() and
      caller.isExternallyTriggerable()
    )
  )
}

predicate inNonPrivilegedJob(AstNode node) {
  exists(Job j |
    // node is in a non-privileged or not externally triggereable job
    j = node.getEnclosingJob() and
    (
      // job is non-privileged (no write access and no access to secrets)
      not j.isPrivileged()
      or
      // job is triggereable by an external user
      not j.isExternallyTriggerable()
    )
  )
}
