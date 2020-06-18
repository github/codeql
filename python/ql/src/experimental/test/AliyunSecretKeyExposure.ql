/**
 * Aliyun  AccessKey ID and SECRET Exposured Example:
 * AccessKeyID = "LTAI4GGqpLRDXhXwRXo8B1RM"
 * SECRET = "R6sBJQVZnsaCNy77IvdmmHk6QM438w"
 */

import python
from Expr t
where t.(StrConst).getText().regexpMatch("LTAI[a-zA-Z0-9]{20}") or t.(StrConst).getText().regexpMatch("[a-zA-Z0-9]{30}")
select t,"Aliyun SecretId or SecretKey Exposured"
