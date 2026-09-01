/**
 * @kind test-postprocess
 * @tags inline-expectation-test
 */

private import csharp
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
    // C# databases can also contain XML (e.g. `.csproj`, `.config`) and Razor markup, whose
    // comment syntaxes are not yet supported, so we only render for C# sources.
    relativePath.regexpMatch(".*\\.(cs|csx)") and
    result = "//"
  }
}
