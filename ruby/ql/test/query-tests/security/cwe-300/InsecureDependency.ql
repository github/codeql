import codeql.ruby.AST
import utils.test.InlineExpectationsTest
import codeql.ruby.security.InsecureDependencyQuery

module InsecureDependencyTest implements TestSig {
  string getARelevantTag() { result = "result" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "result" and
    value = "BAD" and
    exists(Expr e |
      insecureDependencyUrl(e, _) and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}

import MakeTest<InsecureDependencyTest>

from Expr url, string msg
where insecureDependencyUrl(url, msg)
select url, msg
