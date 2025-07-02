/**
 * Support for ExternalDependencies.ql query.
 *
 * This performs a "technology inventory" by associating each source file
 * with the libraries it uses.
 */

import cpp
import semmle.code.cpp.commons.Dependency

/**
 * An `Element` that is to be considered a Library.
 */
abstract class LibraryElement extends Element {
  abstract string getName();

  abstract string getVersion();

  abstract File getAFile();
}

/**
 * Anything that is to be considered a library.
 */
private newtype LibraryT =
  LibraryTElement(LibraryElement lib, string name, string version) {
    lib.getName() = name and
    lib.getVersion() = version
  }

/**
 * A library that can have dependencies on it.
 */
class Library extends LibraryT {
  string name;
  string version;

  Library() { this = LibraryTElement(_, name, version) }

  string getName() { result = name }

  string getVersion() {
    // The versions reported for C/C++ dependencies are just the versions that
    // happen to be installed on the system where the build takes place.
    // Reporting those versions is likely to cause misunderstandings, both for
    // people reading them and for vulnerability checkers.
    result = "unknown"
  }

  string toString() { result = this.getName() + "-" + this.getVersion() }

  File getAFile() {
    exists(LibraryElement lib |
      this = LibraryTElement(lib, _, _) and
      result = lib.getAFile()
    )
  }
}

/**
 * Holds if there are `num` dependencies from `sourceFile` on `destLib` (and
 * `sourceFile` is not in `destLib`).
 */
predicate libDependencies(File sourceFile, Library destLib, int num) {
  num =
    strictcount(Element source, Element dest, File destFile |
      // dependency from source -> dest.
      dependsOnSimple(source, dest) and
      sourceFile = source.getFile() and
      destFile = dest.getFile() and
      // destFile is inside destLib, sourceFile is outside.
      destFile = destLib.getAFile() and
      not sourceFile = destLib.getAFile() and
      // don't include dependencies from template instantiations that
      // may depend back on types in the using code.
      not source.isFromTemplateInstantiation(_) and
      // exclude very common dependencies
      not destLib.getName() = "linux" and
      not destLib.getName().regexpMatch("gcc-[0-9]+") and
      not destLib.getName() = "glibc"
    )
}

/**
 * Generate the table of dependencies for the query (with some
 * packages that basically all projects depend on excluded).
 */
predicate encodedDependencies(File source, string encodedDependency, int num) {
  exists(Library destLib |
    libDependencies(source, destLib, num) and
    encodedDependency =
      "/" + source.getRelativePath() + "<|>" + destLib.getName() + "<|>" + destLib.getVersion()
  )
}
