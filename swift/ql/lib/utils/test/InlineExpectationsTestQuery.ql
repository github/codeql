/**
 * @kind test-postprocess
 * @tags inline-expectation-test
 */

private import swift
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
    // The Swift extractor only ingests Swift sources (no XML/YAML/HTML in its dbscheme), so a
    // constant marker is safe; revisit if Swift ever gains extraction of another file type.
    exists(relativePath) and result = "//"
  }
}
