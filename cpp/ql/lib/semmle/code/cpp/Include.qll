/**
 * Provides classes representing C/C++ `#include`, `#include_next`, and `#import` preprocessor
 * directives.
 */

import semmle.code.cpp.Preprocessor

/**
 * A C/C++ `#include`, `#include_next`, or `#import` preprocessor
 * directive. The following example contains four different `Include`
 * directives:
 * ```
 * #include "header.h"
 * #include <string>
 * #include_next <header2.h>
 * #import <header3.h>
 * ```
 */
class Include extends PreprocessorDirective, @ppd_include {
  override string toString() { result = "#include " + this.getIncludeText() }

  /**
   * Gets the token which occurs after `#include`, for example `"filename"`
   * or `<filename>`.
   */
  string getIncludeText() { result = this.getHead() }

  /** Gets the file directly included by this `#include`. */
  File getIncludedFile() { includes(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets a file which might be transitively included by this `#include`.
   *
   * Note that as this isn't computed within the context of a particular
   * translation unit, it is often a slight over-approximation.
   */
  predicate provides(File l) {
    exists(Include i | this.getAnInclude*() = i and i.getIncludedFile() = l)
  }

  /**
   * A `#include` which appears in the file directly included by this
   * `#include`.
   */
  Include getAnInclude() { this.getIncludedFile() = result.getFile() }
}

/**
 * A `#include_next` preprocessor directive (a non-standard extension to
 * C/C++). For example the following code contains one `IncludeNext` directive:
 * ```
 * #include_next <header2.h>
 * ```
 */
class IncludeNext extends Include, @ppd_include_next {
  override string toString() { result = "#include_next " + this.getIncludeText() }
}

/**
 * A `#import` preprocessor directive (used heavily in Objective C, and
 * supported by GCC as an extension in C). For example the following code
 * contains one `Import` directive:
 * ```
 * #import <header3.h>
 * ```
 */
class Import extends Include, @ppd_objc_import {
  override string toString() { result = "#import " + this.getIncludeText() }
}
