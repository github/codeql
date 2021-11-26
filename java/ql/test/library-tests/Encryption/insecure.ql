import default
import semmle.code.java.security.Encryption

from StringLiteral s
where s.getValue().regexpMatch(getInsecureAlgorithmRegex())
select s
