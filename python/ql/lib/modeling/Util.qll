/**
 * Contains utility methods and classes to assist with generating data extensions models.
 */

private import python
private import semmle.python.ApiGraphs

/**
 * A file that probably contains tests.
 */
class TestFile extends File {
  TestFile() {
    this.getRelativePath().regexpMatch(".*(test|spec|examples).+") and
    not this.getAbsolutePath().matches("%/ql/test/%") // allows our test cases to work
  }
}

/**
 * A file that is relevant in the context of library modeling.
 *
 * In practice, this means a file that is not part of test code.
 */
class RelevantFile extends File {
  RelevantFile() { not this instanceof TestFile and not this.inStdlib() }
}

/**
 * Gets the dotted path of a scope.
 * Class scopes are have a "!" suffix.
 */
string computeAnnotatedScopePath(Scope scope) {
  // base case
  if scope instanceof Module
  then
    scope.(Module).isPackageInit() and
    result = scope.(Module).getPackageName()
    or
    not scope.(Module).isPackageInit() and
    result = scope.(Module).getName()
  else
    //recursive cases
    if scope instanceof Class
    then
      result =
        computeAnnotatedScopePath(scope.(Class).getEnclosingScope()) + "." + scope.(Class).getName()
          + "!"
    else
      if scope instanceof Function
      then
        result =
          computeAnnotatedScopePath(scope.(Function).getEnclosingScope()) + "." +
            scope.(Function).getName()
      else result = "unknown: " + scope.toString()
}

string computeScopePath(Scope scope) {
  result = computeAnnotatedScopePath(scope).replaceAll("!", "")
}

signature predicate modelSig(string type, string path);

module FindModel<modelSig/2 model> {
  predicate hasModel(Scope scope) {
    exists(string type, string path, string searchPath | model(type, path) |
      searchPath = possibleMemberPathPrefix(path, scope.getName()) and
      pathToScope(scope, type, searchPath)
    )
  }

  /**
   * returns the prefix of `path` that might be a path to `member`
   */
  bindingset[path, member]
  string possibleMemberPathPrefix(string path, string member) {
    // functionName must be a substring of path
    exists(int index | index = path.indexOf(["Member", "Method"] + "[" + member + "]") |
      result = path.prefix(index)
    )
  }

  /**
   * Holds if `(type,path)` evaluates to the given entity, when evalauted from a client of the current library.
   */
  bindingset[type, path]
  predicate pathToScope(Scope scope, string type, string path) {
    scope.getLocation().getFile() instanceof RelevantFile and
    scope.isPublic() and // only public methods are modeled
    computeScopePath(scope) =
      type.replaceAll("!", "") + "." +
        path.replaceAll("Member[", "").replaceAll("]", "").replaceAll("Instance.", "") +
        scope.getName()
  }
}
