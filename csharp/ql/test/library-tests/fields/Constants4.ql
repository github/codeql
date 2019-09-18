/**
 * @name Test for constants
 */

import csharp

where forall(MemberConstant c | exists(c.getValue()))
select 1
