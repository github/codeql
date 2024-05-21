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
string wrapRegexp(string regex) {
  result =
    [
      "\\b" + regex + "\\b", "fromJSON\\(\\s*" + regex + "\\s*\\)",
      "toJSON\\(\\s*" + regex + "\\s*\\)"
    ]
}

bindingset[str]
private string trimQuotes(string str) {
  result = str.trim().regexpReplaceAll("^(\"|')", "").regexpReplaceAll("(\"|')$", "")
}

bindingset[line, var]
predicate extractLineAssignment(string line, string var, string key, string value) {
  exists(string assignment |
    // single line assignment
    assignment =
      line.regexpCapture("(echo|Write-Output)\\s+(.*)>>\\s*(\"|')?\\$(\\{)?GITHUB_" +
          var.toUpperCase() + "(\\})?(\"|')?", 2) and
    count(assignment.splitAt("=")) = 2 and
    key = trimQuotes(assignment.splitAt("=", 0)) and
    value = trimQuotes(assignment.splitAt("=", 1))
    or
    // workflow command assignment
    assignment =
      line.regexpCapture("(echo|Write-Output)\\s+(\"|')?::set-" + var.toLowerCase() +
          "\\s+name=(.*)(\"|')?", 3).regexpReplaceAll("^\"", "").regexpReplaceAll("\"$", "") and
    key = trimQuotes(assignment.splitAt("::", 0)) and
    value = trimQuotes(assignment.splitAt("::", 1))
  )
}

bindingset[var]
private string multilineAssignmentRegex(string var) {
  // eg:
  // echo "PR_TITLE<<EOF" >> $GITHUB_ENV
  // echo "$TITLE" >> $GITHUB_ENV
  // echo "EOF" >> $GITHUB_ENV
  result =
    ".*(echo|Write-Output)\\s+(.*)<<[\\-]*\\s*([A-Z]*)EOF(.+)(echo|Write-Output)\\s+(\"|')?([A-Z]*)EOF(\"|')?\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_"
      + var.toUpperCase() + "(\\})?(\"|')?.*"
}

bindingset[var]
private string multilineBlockAssignmentRegex(string var) {
  // eg:
  // {
  //   echo 'JSON_RESPONSE<<EOF'
  //   echo "$TITLE" >> "$GITHUB_ENV"
  //   echo EOF
  // } >> "$GITHUB_ENV"
  result =
    ".*\\{(\\s|::NEW_LINE::)*(echo|Write-Output)\\s+(.*)<<[\\-]*\\s*([A-Z]*)EOF(.+)(echo|Write-Output)\\s+(\"|')?([A-Z]*)EOF(\"|')?(\\s|::NEW_LINE::)*\\}\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_"
      + var.toUpperCase() + "(\\})?(\"|')?.*"
}

bindingset[var]
private string multilineHereDocAssignmentRegex(string var) {
  // eg:
  // cat <<-EOF >> "$GITHUB_ENV"
  //   echo "FOO=$TITLE"
  // EOF
  result =
    ".*cat\\s*<<[\\-]*\\s*[A-Z]*EOF\\s*>>\\s*[\"']*\\$[\\{]*GITHUB_.*" + var.toUpperCase() +
      "[\\}]*[\"']*.*(echo|Write-Output)\\s+([^=]+)=(.*)::NEW_LINE::.*EOF.*"
}

bindingset[script, var]
predicate extractMultilineAssignment(string script, string var, string key, string value) {
  // multiline assignment
  exists(string flattenedScript |
    flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
    value =
      "$(" +
        trimQuotes(flattenedScript.regexpCapture(multilineAssignmentRegex(var), 4))
            .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
                "(\\})?(\"|')?", "")
            .replaceAll("::NEW_LINE::", "\n")
            .trim()
            .splitAt("\n") + ")" and
    key = trimQuotes(flattenedScript.regexpCapture(multilineAssignmentRegex(var), 2))
  )
  or
  // multiline block assignment
  exists(string flattenedScript |
    flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
    value =
      "$(" +
        trimQuotes(flattenedScript.regexpCapture(multilineBlockAssignmentRegex(var), 5))
            .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
                "(\\})?(\"|')?", "")
            .replaceAll("::NEW_LINE::", "\n")
            .trim()
            .splitAt("\n") + ")" and
    key = trimQuotes(flattenedScript.regexpCapture(multilineBlockAssignmentRegex(var), 3))
  )
  or
  // multiline heredoc assignment
  exists(string flattenedScript |
    flattenedScript = script.replaceAll("\n", "::NEW_LINE::") and
    value =
      trimQuotes(flattenedScript.regexpCapture(multilineHereDocAssignmentRegex(var), 3))
          .regexpReplaceAll("\\s*>>\\s*(\"|')?\\$(\\{)?GITHUB_" + var.toUpperCase() +
              "(\\})?(\"|')?", "")
          .replaceAll("::NEW_LINE::", "\n")
          .trim()
          .splitAt("\n") and
    key = trimQuotes(flattenedScript.regexpCapture(multilineHereDocAssignmentRegex(var), 2))
  )
}

bindingset[line]
predicate extractPathAssignment(string line, string value) {
  exists(string path |
    // single path assignment
    path =
      line.regexpCapture("(echo|Write-Output)\\s+(.*)>>\\s*(\"|')?\\$(\\{)?GITHUB_PATH(\\})?(\"|')?",
        2) and
    value = trimQuotes(path)
    or
    // workflow command assignment
    path =
      line.regexpCapture("(echo|Write-Output)\\s+(\"|')?::add-path::(.*)(\"|')?", 3)
          .regexpReplaceAll("^\"", "")
          .regexpReplaceAll("\"$", "") and
    value = trimQuotes(path)
  )
}

predicate writeToGitHubEnv(Run run, string key, string value) {
  extractLineAssignment(run.getScript().splitAt("\n"), "ENV", key, value) or
  extractMultilineAssignment(run.getScript(), "ENV", key, value)
}

predicate writeToGitHubOutput(Run run, string key, string value) {
  extractLineAssignment(run.getScript().splitAt("\n"), "OUTPUT", key, value) or
  extractMultilineAssignment(run.getScript(), "OUTPUT", key, value)
}

predicate writeToGitHubPath(Run run, string value) {
  extractPathAssignment(run.getScript().splitAt("\n"), value)
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
