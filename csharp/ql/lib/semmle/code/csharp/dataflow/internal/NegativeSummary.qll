/** Provides modules for importing negative summaries. */

/**
 * A module importing the frameworks that provide external flow data,
 * ensuring that they are visible to the taint tracking / data flow library.
 */
private module Frameworks {
  private import semmle.code.csharp.frameworks.GeneratedNegative
}
