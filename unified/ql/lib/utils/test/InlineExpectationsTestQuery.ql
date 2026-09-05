/**
 * @kind test-postprocess
 */

private import unified
private import codeql.util.test.InlineExpectationsTest as T
private import internal.InlineExpectationsTestImpl
import T::TestPostProcessing
import T::TestPostProcessing::Make<Impl, Input>

private module Input implements T::TestPostProcessing::InputSig<Impl> {
  string getRelativeUrl(Location location) {
    exists(File f, int startline, int startcolumn, int endline, int endcolumn |
      location.hasLocationInfo(_, startline, startcolumn, endline, endcolumn) and
      f = location.getFile()
    |
      result =
        f.getRelativePath() + ":" + startline + ":" + startcolumn + ":" + endline + ":" + endcolumn
    )
  }

  bindingset[relativePath]
  string getStartCommentMarker(string relativePath) {
    // The unified extractor is a new tree-sitter-based extractor that currently ingests only
    // Swift sources (see `file_types` in its `codeql-extractor.yml`), which use `//`. Gating on
    // the extension keeps this correct if it later gains a language with a different comment
    // syntax.
    relativePath.regexpMatch(".*\\.(swift|swiftinterface)") and
    result = "//"
  }
}
