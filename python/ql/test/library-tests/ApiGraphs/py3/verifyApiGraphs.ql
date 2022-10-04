// Note: This is not using standard inline-expectation tests, so will not alert if you
// have not manually added an annotation to a line!
import TestUtilities.VerifyApiGraphs

class CustomEntryPoint extends API::EntryPoint {
  CustomEntryPoint() { this = "CustomEntryPoint" }

  override DataFlow::LocalSourceNode getASource() {
    result.asExpr().(StrConst).getText() = "magic_string"
  }
}
