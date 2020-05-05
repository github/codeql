import default
import semmle.code.java.security.Encryption

from CryptoAlgoSpec s
select s, s.getAlgoSpec()
