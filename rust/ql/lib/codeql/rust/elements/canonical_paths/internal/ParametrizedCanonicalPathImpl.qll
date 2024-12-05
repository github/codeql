/**
 * This module provides a hand-modifiable wrapper around the generated class `ParametrizedCanonicalPath`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.canonical_paths.ParametrizedCanonicalPath

/**
 * INTERNAL: This module contains the customizable definition of `ParametrizedCanonicalPath` and should not
 * be referenced directly.
 */
module Impl {
  class ParametrizedCanonicalPath extends Generated::ParametrizedCanonicalPath {
    override string toString() {
      exists(string args |
        (
          if this.getNumberOfGenericArgs() > 0
          then
            args =
              "<" +
                strictconcat(int i | | this.getGenericArg(i).toAbbreviatedString(), ", " order by i)
                + ">"
          else args = ""
        ) and
        result = this.getBase().toAbbreviatedString() + args
      )
    }
  }
}
