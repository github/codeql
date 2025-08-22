/**
 * Provides classes and predicates for Gemfiles, including version constraint logic.
 */

private import codeql.ruby.AST

/**
 * Provides classes and predicates for Gemfiles, including version constraint logic.
 */
module Gemfile {
  private File getGemfile() { result.getBaseName() = "Gemfile" }

  /**
   * A call to `gem` inside a gemfile. This defines a dependency. For example:
   *
   * ```rb
   * gem "actionpack", "~> 7.0.0"
   * ```
   *
   * This call defines a dependency on the `actionpack` gem, with version constraint `~> 7.0.0`.
   * For detail on version constraints, see the `VersionConstraint` class.
   */
  class Gem extends MethodCall {
    Gem() { this.getMethodName() = "gem" and this.getFile() = getGemfile() }

    /**
     * Gets the name of the gem in this version constraint.
     */
    string getName() { result = this.getArgument(0).getConstantValue().getStringlikeValue() }

    /**
     * Gets the `i`th version string for this gem. A single `gem` call may have multiple version constraints, for example:
     *
     * ```rb
     * gem "json", "3.4.0", ">= 3.0"
     * ```
     */
    string getVersionString(int i) {
      result = this.getArgument(i + 1).getConstantValue().getStringlikeValue()
    }

    /**
     * Gets a version constraint defined by this call.
     */
    VersionConstraint getAVersionConstraint() { result = this.getVersionString(_) }
  }

  private newtype TComparator =
    TEq() or
    TNeq() or
    TGt() or
    TLt() or
    TGeq() or
    TLeq() or
    TPGeq()

  /**
   * A comparison operator in a version constraint.
   */
  private class Comparator extends TComparator {
    string toString() { result = this.toSourceString() }

    /**
     * Gets the representation of the comparator in source code.
     * This is defined separately so that we can change the `toString` implementation without breaking `parseConstraint`.
     */
    string toSourceString() {
      this = TEq() and result = "="
      or
      this = TNeq() and result = "!="
      or
      this = TGt() and result = ">"
      or
      this = TLt() and result = "<"
      or
      this = TGeq() and result = ">="
      or
      this = TLeq() and result = "<="
      or
      this = TPGeq() and result = "~>"
    }
  }

  bindingset[s]
  private predicate parseExactVersion(string s, string version) {
    version = s.regexpCapture("\\s*(\\d+\\.\\d+\\.\\d+)\\s*", 1)
  }

  bindingset[s]
  private predicate parseConstraint(string s, Comparator c, string version) {
    exists(string pattern | pattern = "(=|!=|>=?|<=?|~>)\\s+(.+)" |
      c.toSourceString() = s.regexpCapture(pattern, 1) and version = s.regexpCapture(pattern, 2)
    )
  }

  /**
   * A version constraint in a `gem` call. This consists of a version number and an optional comparator, for example
   * `>= 1.2.3`.
   */
  class VersionConstraint extends string {
    Comparator comp;
    string versionString;

    VersionConstraint() {
      this = any(Gem g).getVersionString(_) and
      (
        parseConstraint(this, comp, versionString)
        or
        parseExactVersion(this, versionString) and comp = TEq()
      )
    }

    /**
     * Gets the string defining the version number used in this constraint.
     */
    string getVersionString() { result = versionString }

    /**
     * Gets the `Version` used in this constraint.
     */
    Version getVersion() { result = this.getVersionString() }

    /**
     * Holds if `other` is a version which is strictly greater than the range described by this version constraint.
     */
    bindingset[other]
    predicate before(string other) {
      comp = TEq() and this.getVersion().before(other)
      or
      comp = TLt() and
      (this.getVersion().before(other) or this.getVersion().equal(other))
      or
      comp = TLeq() and this.getVersion().before(other)
      or
      // ~> x.y.z <=> >= x.y.z && < x.(y+1).0
      // ~> x.y <=> >= x.y && < (x+1).0
      comp = TPGeq() and
      exists(int thisMajor, int thisMinor, int otherMajor, int otherMinor |
        thisMajor = this.getVersion().getMajor() and
        thisMinor = this.getVersion().getMinor() and
        exists(string maj, string mi | normalizeSemver(other, _, maj, mi, _) |
          otherMajor = maj.toInt() and otherMinor = mi.toInt()
        )
      |
        exists(this.getVersion().getPatch()) and
        (
          thisMajor < otherMajor
          or
          thisMajor = otherMajor and
          thisMinor < otherMinor
        )
        or
        not exists(this.getVersion().getPatch()) and
        thisMajor < otherMajor
      )
      // if the comparator is > or >=, it has no upper bound and therefore isn't guaranteed to be before any other version.
    }
  }

  /**
   * A version number in a version constraint. For example, in the following code
   *
   * ```rb
   * gem "json", ">= 3.4.5"
   * ```
   *
   * The version is `3.4.5`.
   */
  private class Version extends string {
    string normalized;

    Version() {
      this = any(Gem c).getAVersionConstraint().getVersionString() and
      normalized = normalizeSemver(this)
    }

    /**
     * Holds if this version is strictly before the version defined by `other`.
     */
    bindingset[other]
    predicate before(string other) { normalized < normalizeSemver(other) }

    /**
     * Holds if this versino is equal to the version defined by `other`.
     */
    bindingset[other]
    predicate equal(string other) { normalized = normalizeSemver(other) }

    /**
     * Holds if this version is strictly after the version defined by `other`.
     */
    bindingset[other]
    predicate after(string other) { normalized > normalizeSemver(other) }

    /**
     * Holds if this version defines a patch number.
     */
    predicate hasPatch() { exists(getPatch(this)) }

    /**
     * Gets the major number of this version.
     */
    int getMajor() { result = getMajor(normalized).toInt() }

    /**
     * Gets the minor number of this version, if it exists.
     */
    int getMinor() { result = getMinor(normalized).toInt() }

    /**
     * Gets the patch number of this version, if it exists.
     */
    int getPatch() { result = getPatch(normalized).toInt() }
  }

  /**
   * Normalizes a SemVer string such that the lexicographical ordering
   * of two normalized strings is consistent with the SemVer ordering.
   *
   * Pre-release information and build metadata is not supported.
   */
  bindingset[orig]
  private predicate normalizeSemver(
    string orig, string normalized, string major, string minor, string patch
  ) {
    major = getMajor(orig) and
    (
      minor = getMinor(orig)
      or
      not exists(getMinor(orig)) and minor = "0"
    ) and
    (
      patch = getPatch(orig)
      or
      not exists(getPatch(orig)) and patch = "0"
    ) and
    normalized = leftPad(major) + "." + leftPad(minor) + "." + leftPad(patch)
  }

  bindingset[orig]
  private string normalizeSemver(string orig) { normalizeSemver(orig, result, _, _, _) }

  bindingset[s]
  private string getMajor(string s) { result = s.regexpCapture("(\\d+).*", 1) }

  bindingset[s]
  private string getMinor(string s) { result = s.regexpCapture("(\\d+)\\.(\\d+).*", 2) }

  bindingset[s]
  private string getPatch(string s) { result = s.regexpCapture("(\\d+)\\.(\\d+)\\.(\\d+).*", 3) }

  bindingset[str]
  private string leftPad(string str) { result = ("000" + str).suffix(str.length()) }
}
