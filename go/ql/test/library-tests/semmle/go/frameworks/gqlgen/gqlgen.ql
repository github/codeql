import go
import TestUtilities.InlineExpectationsTest

module UntrustedFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "resolverParameter" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "resolverParameter" and
    exists(Gqlgen::ResolverParameter p |
      element = p.toString() and
      value = "\"" + p.toString() + "\"" and
      p.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<UntrustedFlowSourceTest>
