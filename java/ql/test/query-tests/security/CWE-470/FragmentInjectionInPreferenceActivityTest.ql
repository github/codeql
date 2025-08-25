import java
import semmle.code.java.security.FragmentInjection
import utils.test.InlineExpectationsTest

module FragmentInjectionInPreferenceActivityTest implements TestSig {
  string getARelevantTag() { result = "hasPreferenceFragmentInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPreferenceFragmentInjection" and
    exists(IsValidFragmentMethod isValidFragment | isValidFragment.isUnsafe() |
      isValidFragment.getLocation() = location and
      element = isValidFragment.toString() and
      value = ""
    )
  }
}

import MakeTest<FragmentInjectionInPreferenceActivityTest>
