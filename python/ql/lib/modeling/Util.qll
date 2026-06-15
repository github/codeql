/**
 * Contains utility methods and classes to assist with generating data extensions models.
 */

private import python
private import semmle.python.ApiGraphs
private import semmle.python.filters.Tests

/**
 * A file that probably contains tests.
 */
class TestFile extends File {
  TestFile() {
    this.getRelativePath().regexpMatch(".*(test|spec|examples).+") and
    not this.getAbsolutePath().matches("%/ql/test/%") // allows our test cases to work
  }
}

/** A class to represent scopes that the user might want to model. */
class RelevantScope extends Scope {
  RelevantScope() {
    this.isPublic() and
    not this instanceof TestScope and
    not this.getLocation().getFile() instanceof TestFile and
    exists(this.getLocation().getFile().getRelativePath())
  }
}

/**
 * Gets the dotted path of a scope.
 */
string computeScopePath(RelevantScope scope) {
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
    if scope instanceof Class or scope instanceof Function
    then result = computeScopePath(scope.getEnclosingScope()) + "." + scope.getName()
    else result = "unknown: " + scope.toString()
}

signature predicate modelSig(string type, string path);

/**
 * A utility module for finding models of endpoints.
 *
 * Chiefly the `hasModel` predicate is used to determine if a scope has a model.
 */
module FindModel<modelSig/2 model> {
  /**
   * Holds if the given scope has a model as identified by the provided predicate `model`.
   */
  predicate hasModel(RelevantScope scope) {
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
    exists(int index | index = path.indexOf(["Member", "Method"] + "[" + member + "]") |
      result = path.prefix(index)
    )
  }

  /**
   * Holds if `(type,path)` identifies `scope`.
   */
  bindingset[type, path]
  predicate pathToScope(RelevantScope scope, string type, string path) {
    computeScopePath(scope) =
      type.replaceAll("!", "") + "." +
        path.replaceAll("Member[", "").replaceAll("]", "").replaceAll("Instance.", "") +
        scope.getName()
  }
}
