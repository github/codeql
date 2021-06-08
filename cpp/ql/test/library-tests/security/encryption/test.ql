import default
import semmle.code.cpp.security.Encryption

string describe(Function f) {
  f.getName().regexpMatch(getSecureAlgorithmRegex()) and
  result = "getSecureAlgorithmRegex"
  or
  f.getName().regexpMatch(getInsecureAlgorithmRegex()) and
  result = "getInsecureAlgorithmRegex"
}

from Function f
where exists(f.getLocation().getFile())
select f, concat(describe(f), ", ")
