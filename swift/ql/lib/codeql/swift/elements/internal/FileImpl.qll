private import codeql.swift.generated.File
private import codeql.swift.elements.Location
private import codeql.swift.elements.UnknownLocation

module Impl {
  class File extends Generated::File {
    /** toString */
    override string toString() { result = this.getAbsolutePath() }

    /** Gets the absolute path of this file. */
    string getAbsolutePath() { result = this.getName() }

    /** Gets the full name of this file. */
    string getFullName() { result = this.getAbsolutePath() }

    /** Gets the URL of this file. */
    string getURL() { result = "file://" + this.getAbsolutePath() + ":0:0:0:0" }

    /**
     * Holds if either,
     * - `part` is the base name of this container and `i = 1`, or
     * - `part` is the stem of this container and `i = 2`, or
     * - `part` is the extension of this container and `i = 3`.
     */
    cached
    private predicate splitAbsolutePath(string part, int i) {
      part = this.getAbsolutePath().regexpCapture(".*/(([^/]*?)(?:\\.([^.]*))?)", i)
    }

    /** Gets the base name of this file. */
    string getBaseName() { this.splitAbsolutePath(result, 1) }

    /**
     * Gets the extension of this container, that is, the suffix of its base name
     * after the last dot character, if any.
     *
     * In particular,
     *
     *  - if the name does not include a dot, there is no extension, so this
     *    predicate has no result;
     *  - if the name ends in a dot, the extension is the empty string;
     *  - if the name contains multiple dots, the extension follows the last dot.
     *
     * Here are some examples of absolute paths and the corresponding extensions
     * (surrounded with quotes to avoid ambiguity):
     *
     * <table border="1">
     * <tr><th>Absolute path</th><th>Extension</th></tr>
     * <tr><td>"/tmp/tst.txt"</td><td>"txt"</td></tr>
     * <tr><td>"/tmp/.classpath"</td><td>"classpath"</td></tr>
     * <tr><td>"/bin/bash"</td><td>not defined</td></tr>
     * <tr><td>"/tmp/tst2."</td><td>""</td></tr>
     * <tr><td>"/tmp/x.tar.gz"</td><td>"gz"</td></tr>
     * </table>
     */
    string getExtension() { this.splitAbsolutePath(result, 3) }

    /**
     * Gets the stem of this container, that is, the prefix of its base name up to
     * (but not including) the last dot character if there is one, or the entire
     * base name if there is not.
     *
     * Here are some examples of absolute paths and the corresponding stems
     * (surrounded with quotes to avoid ambiguity):
     *
     * <table border="1">
     * <tr><th>Absolute path</th><th>Stem</th></tr>
     * <tr><td>"/tmp/tst.txt"</td><td>"tst"</td></tr>
     * <tr><td>"/tmp/.classpath"</td><td>""</td></tr>
     * <tr><td>"/bin/bash"</td><td>"bash"</td></tr>
     * <tr><td>"/tmp/tst2."</td><td>"tst2"</td></tr>
     * <tr><td>"/tmp/x.tar.gz"</td><td>"x.tar"</td></tr>
     * </table>
     */
    string getStem() { this.splitAbsolutePath(result, 2) }

    /**
     * Gets the number of lines containing code in this file. This value
     * is approximate.
     */
    int getNumberOfLinesOfCode() {
      result =
        count(int line |
          exists(Location loc |
            not loc instanceof UnknownLocation and
            loc.getFile() = this and
            loc.getStartLine() = line
          )
        )
    }

    /**
     * Gets the relative path of this file from the root folder of the
     * analyzed source location. The relative path of the root folder itself
     * would be the empty string.
     *
     * This has no result if the file is outside the source root, that is,
     * if the root folder is not a reflexive, transitive parent of this file.
     */
    string getRelativePath() {
      exists(string absPath, string pref |
        absPath = this.getAbsolutePath() and sourceLocationPrefix(pref)
      |
        absPath = pref and result = ""
        or
        absPath = pref.regexpReplaceAll("/$", "") + "/" + result and
        not result.matches("/%")
      )
    }
  }
}
