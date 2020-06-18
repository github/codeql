/**
 * Tencent Cloud SecretId and SecretKey Exposured Example :
 * SecretId="AKIDkFUHo5c7kssfDVOqtgIemmJiuqX1uFWM"
 * SecretKey="uUmA8rLceRzGG7fy5yby5wZw31mHUUMo"
 */

import python
from Expr t
where t.(StrConst).getText().regexpMatch("AKID[a-zA-Z0-9]{32}") or t.(StrConst).getText().regexpMatch("[a-zA-Z0-9]{32}")
select t,"Tencent Cloud SecretId or SecretKey Exposured"
