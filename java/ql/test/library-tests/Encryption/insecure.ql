import default
import semmle.code.java.security.Encryption

from StringLiteral s
where s.getRepresentedString().regexpMatch(getInsecureAlgorithmRegex())
select s
