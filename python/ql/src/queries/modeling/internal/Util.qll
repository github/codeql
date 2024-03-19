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

string computeScopePath(Scope scope) {
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
      result = computeScopePath(scope.(Class).getEnclosingScope()) + "." + scope.(Class).getName()
    else
      if scope instanceof Function
      then
        result =
          computeScopePath(scope.(Function).getEnclosingScope()) + "." + scope.(Function).getName()
      else result = "unknown: " + scope.toString()
}

string computeFunctionName(Function function) { result = computeScopePath(function) }

bindingset[fullyQualified]
predicate fullyQualifiedToYamlFormat(string fullyQualified, string type2, string path) {
  exists(int firstDot | firstDot = fullyQualified.indexOf(".", 0, 0) |
    type2 = fullyQualified.prefix(firstDot) and
    path =
      ("Member[" + fullyQualified.suffix(firstDot + 1).replaceAll(".", "].Member[") + "]")
          .replaceAll(".Member[__init__].", "")
          .replaceAll("Member[__init__].", "")
  )
}

/**
 * Holds if `(type,path)` evaluates to the given function or method, when evalauted from a client of the current library.
 */
predicate pathToFunction(Function function, string type, string path) {
  function.getLocation().getFile() instanceof RelevantFile and
  function.isPublic() and // only public methods are modeled
  fullyQualifiedToYamlFormat(computeFunctionName(function), type, path)
}
