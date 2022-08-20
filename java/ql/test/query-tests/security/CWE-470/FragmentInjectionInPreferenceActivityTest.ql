import java
import semmle.code.java.security.FragmentInjection
import TestUtilities.InlineExpectationsTest

class FragmentInjectionInPreferenceActivityTest extends InlineExpectationsTest {
  FragmentInjectionInPreferenceActivityTest() { this = "FragmentInjectionInPreferenceActivityTest" }

  override string getARelevantTag() { result = "hasPreferenceFragmentInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPreferenceFragmentInjection" and
    exists(IsValidFragmentMethod isValidFragment | isValidFragment.isUnsafe() |
      isValidFragment.getLocation() = location and
      element = isValidFragment.toString() and
      value = ""
    )
  }
}
