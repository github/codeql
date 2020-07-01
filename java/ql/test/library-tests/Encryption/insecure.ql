import default
import semmle.code.java.security.Encryption

from StringLiteral s
where s.getLiteral().regexpMatch(getInsecureAlgorithmRegex())
select s
