import java
import TestUtilities.InlineExpectationsTest

class SameVarAccessTest extends InlineExpectationsTest {
  SameVarAccessTest() { this = "SameVarAccessTest" }

  override string getARelevantTag() { result = "sameVarAccess" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sameVarAccess" and
    exists(MethodAccess call |
      call.getMethod().hasStringSignature("checkSameVarAccess(Object, Object)") and
      (
        // Verify that predicate is symmetric
        call.getArgument(0).(VarAccess).accessSameVarOfSameOwner(call.getArgument(1)) and
        call.getArgument(1).(VarAccess).accessSameVarOfSameOwner(call.getArgument(0))
      ) and
      // No value because only have to verify whether arguments are the same (InlineExpectationsTest comment
      // is present) or not (no comment is present)
      value = "" and
      location = call.getLocation() and
      element = call.toString()
    )
  }
}
