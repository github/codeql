/**
 * Provides the `LinkTarget` class representing linker invocations during the build process.
 */

import semmle.code.cpp.Class
import semmle.code.cpp.File
import semmle.code.cpp.Function

/**
 * A linker call during the build process, typically resulting in an
 * executable or a shared library.
 *
 * Note that if linkage information isn't captured as part of the snapshot,
 * then everything is grouped together into a single dummy link target.
 */
class LinkTarget extends @link_target {
  /**
   * Gets the file which was built.
   */
  File getBinary() { link_targets(this, unresolveElement(result)) }

  /**
   * Holds if this is the dummy link target: if linkage information isn't
   * captured as part of the snapshot, then everything is grouped together
   * into a single dummy link target.
   */
  predicate isDummy() { this.getBinary().getAbsolutePath() = "" }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getBinary().getAbsolutePath() }

  /**
   * Gets a function which was compiled into this link target, or had its
   * declaration included by one of the translation units which contributed
   * to this link target.
   */
  Function getAFunction() { link_parent(unresolveElement(result), this) }

  /**
   * Gets a class which had its declaration included by one of the
   * translation units which contributed to this link target.
   */
  Class getAClass() { link_parent(unresolveElement(result), this) }

  /**
   * Gets a global or namespace variable which was compiled into this
   * link target, or had its declaration included by one of the translation
   * units which contributed to this link target.
   */
  GlobalOrNamespaceVariable getAGlobalOrNamespaceVariable() {
    link_parent(unresolveElement(result), this)
  }
}

/**
 * Holds if this database was created with the linker awareness feature
 * switched on.
 */
cached
predicate isLinkerAwareExtracted() { exists(LinkTarget lt | not lt.isDummy()) }
