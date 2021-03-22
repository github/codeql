import default
import TestUtilities.InlineExpectationsTest

private string getValue(WildcardTypeAccess wta) {
  if wta.hasNoBound() // also makes sure that hasNoBound() is working correctly
  then result = ""
  else
    // Also makes sure that getBound() is working correctly (and has at most
    // one result)
    exists(Expr bound | bound = wta.getBound() and not wta.getBound() != bound |
      bound = wta.getUpperBound() and result = "u:" + bound
      or
      bound = wta.getLowerBound() and result = "l:" + bound
    )
}

class WildcardTypeAccessTest extends InlineExpectationsTest {
  WildcardTypeAccessTest() { this = "WildcardTypeAccessTest" }

  override string getARelevantTag() { result = "wildcardTypeAccess" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(WildcardTypeAccess wta |
      location = wta.getLocation() and
      element = wta.toString() and
      tag = "wildcardTypeAccess" and
      value = getValue(wta)
    )
  }
}
