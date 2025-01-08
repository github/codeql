private import codeql.actions.Ast
private import codeql.Locations
private import codeql.actions.security.ControlChecks
import codeql.actions.config.Config
import codeql.actions.Bash
import codeql.actions.PowerShell

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
    not result.indexOf(".github/workflows/external/") > -1 and
    not result.indexOf(".github/actions/external/") > -1
    or
    not w.getLocation().getFile().getRelativePath().indexOf("/.github/workflows") > 0 and
    not w.getLocation().getFile().getRelativePath().indexOf(".github/workflows/external/") > -1 and
    not w.getLocation().getFile().getRelativePath().indexOf(".github/actions/external/") > -1 and
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
