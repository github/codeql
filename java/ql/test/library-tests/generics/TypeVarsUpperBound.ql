import default
import TestUtilities.InlineExpectationsTest

private string getOrderedBounds(BoundedType bt) {
  result =
    concat(TypeBound bound, int position |
      bound = bt.getTypeBound(position)
    |
      bound.getType().toString(), "," order by position
    )
}

class TypeVariableBoundTest extends InlineExpectationsTest {
  TypeVariableBoundTest() { this = "TypeVariableBoundTest" }

  override string getARelevantTag() { result = ["bounded", "boundedAccess"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(BoundedType bt | value = getOrderedBounds(bt) |
      bt.fromSource() and
      location = bt.getLocation() and
      element = bt.toString() and
      tag = "bounded"
      or
      exists(TypeAccess ta |
        ta.getType().(ParameterizedType).getATypeArgument() = bt and
        location = ta.getLocation() and
        element = ta.toString() and
        tag = "boundedAccess"
      )
    )
  }
}
