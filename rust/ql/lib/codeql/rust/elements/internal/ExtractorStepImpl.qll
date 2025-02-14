/**
 * This module provides a hand-modifiable wrapper around the generated class `ExtractorStep`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ExtractorStep

/**
 * INTERNAL: This module contains the customizable definition of `ExtractorStep` and should not
 * be referenced directly.
 */
module Impl {
  class ExtractorStep extends Generated::ExtractorStep {
    override string toString() {
      result = this.getAction() + "(" + this.getFile().getAbsolutePath() + ")"
      or
      not this.hasFile() and result = this.getAction()
    }

    /**
     * Provides location information for this step.
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getFile().getAbsolutePath() = filepath and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }
  }
}
