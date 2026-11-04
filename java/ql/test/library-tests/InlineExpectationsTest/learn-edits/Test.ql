import java
import utils.test.InlineExpectationsTest

module DirectTest implements TestSig {
  string getARelevantTag() { result = "java-direct" }

  predicate tagIsIgnored(string expectedTag) { expectedTag = "foreign" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Method method |
      method.getName() =
        ["target", "safeAppend", "safeReplace", "unsafeHash", "unsafeSpace", "unsafeNewline"] and
      method.fromSource() and
      location = method.getLocation() and
      element = method.toString() and
      tag = "java-direct" and
      if method.getName() = "unsafeHash"
      then value = "a#b"
      else
        if method.getName() = "unsafeSpace"
        then value = "hello world"
        else
          if method.getName() = "unsafeNewline"
          then value = "hello\nworld"
          else
            if method.getName() = ["safeAppend", "safeReplace"]
            then value = "safe"
            else value = ""
    )
  }
}

private module Test = MakeTest<DirectTest>;

from string file, int line, string operation, int startColumn, int endColumn, string text
where Test::learnEdits(file, line, operation, startColumn, endColumn, text)
select file, line, operation, startColumn, endColumn, text
