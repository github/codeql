/**
 * Provides classes and predicates for working with targets in Apache Ant build files.
 */

import XML

/** An XML element that represents an Ant target. */
class AntTarget extends XMLElement {
  AntTarget() { super.getName() = "target" }

  /** Gets the name of this Ant target. */
  override string getName() { result = this.getAttributeValue("name") }

  /**
   * Gets a string containing the dependencies of this Ant target,
   * without whitespace and with a leading and trailing comma.
   *
   * This is a utility method used for extracting individual dependencies.
   */
  string getDependsString() {
    result =
      "," +
        this.getAttributeValue("depends")
            .replaceAll(" ", "")
            .replaceAll("\r", "")
            .replaceAll("\n", "")
            .replaceAll("\t", "") + ","
  }

  /** Holds if this Ant target depends on the specified target. */
  predicate dependsOn(AntTarget that) {
    this.getFile() = that.getFile() and
    this.getDependsString().matches("%," + that.getName() + ",%")
  }

  /** Gets an Ant target on which this Ant target depends. */
  AntTarget getADependency() { this.dependsOn(result) }
}

/** An Ant target that occurs in an Ant build file with the default name `build.xml`. */
class MainAntTarget extends AntTarget {
  MainAntTarget() { this.getFile().getBaseName() = "build.xml" }
}
