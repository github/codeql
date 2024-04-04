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

bindingset[fullyQualified]
predicate fullyQualifiedToYamlFormat(string fullyQualified, string type2, string path) {
  exists(int firstDot | firstDot = fullyQualified.indexOf(".", 0, 0) |
    type2 = fullyQualified.prefix(firstDot) and
    path =
      (
        "Member[" +
          fullyQualified
              .suffix(firstDot + 1)
              .replaceAll("!.", "]InstanceMember[")
              .replaceAll(".", "].Member[")
              .replaceAll("]InstanceMember[", "].Instance.Member[") + "]"
      ).replaceAll(".Member[__init__].", "").replaceAll("Member[__init__].", "").replaceAll("!", "")
  )
}

/**
 * Holds if `(type,path)` evaluates to the given function or method, when evalauted from a client of the current library.
 */
predicate pathToFunction(Function function, string type, string path) {
  function.getLocation().getFile() instanceof RelevantFile and
  function.isPublic() and // only public methods are modeled
  fullyQualifiedToYamlFormat(computeAnnotatedScopePath(function), type, path)
}

bindingset[result]
string extendFunctionPath(string path) {
  // already ends with `Member` or `Method`
  exists(int index, string functionName |
    functionName = result.regexpFind("(Member|Method)\\[[^\\]]+\\]", index, _) and
    result.length() = index + functionName.length() and
    result = path
  )
  or
  // ends with `ReturnValue`
  result = path + ".ReturnValue"
  or
  // ends with `Argument`
  exists(string argument |
    argument = result.regexpFind("\\.Argument\\[[^\\]]+\\]", _, _) and
    result = path + argument
  )
}
