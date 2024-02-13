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
