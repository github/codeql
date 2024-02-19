private import python

/**
 * A file that probably contains tests.
 */
class TestFile extends File {
  TestFile() {
    // TODO: Revisit this regex
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
  RelevantFile() { not this instanceof TestFile }
}

/**
 * Holds if `(type,path)` evaluates to the given method, when evalauted from a client of the current library.
 */
predicate pathToMethod(Function function, string type, string path) {
  function.getLocation().getFile() instanceof RelevantFile and
  function.isPublic() and // only public methods are modeled
  exists(string moduleName |
    type = function.getScope().getName().splitAt(".", 0) and
    moduleName = function.getScope().getName().splitAt(".", 1) and
    if moduleName = "__init__"
    then path = "Member[" + function.getName() + "]"
    else path = "Member[" + moduleName + "].Member[" + function.getName() + "]"
  )
  or
  not exists(function.getScope().getName().splitAt(".", 1)) and
  type = function.getScope().getName() and
  path = "Member[" + function.getName() + "]"
}
