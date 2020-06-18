/**
 * AWS Access key ID and Secret access key in Expression
 * AccesskeyID = "AKIA2TOTLLINHPIDIH5M"
 * Secretaccesskey = "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"
 */

import python
from Expr t
where t.(StrConst).getText().regexpMatch("(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}") or t.(StrConst).getText().regexpMatch("[a-zA-Z0-9\\/+]{40}")
select t,"AWS SecretId or SecretKey Exposured"
