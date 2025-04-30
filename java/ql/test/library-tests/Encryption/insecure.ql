import default
import semmle.code.java.security.Encryption

from StringLiteral s, string reason
where
  s.getValue().regexpMatch(getInsecureAlgorithmRegex()) and
  if exists(getInsecureAlgorithmReason(s.getValue()))
  then reason = getInsecureAlgorithmReason(s.getValue())
  else reason = "<no reason>"
select s, reason
