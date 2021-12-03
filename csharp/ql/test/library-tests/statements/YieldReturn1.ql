/**
 * @name Test for yield returns
 */

import csharp

where forex(YieldReturnStmt yr | exists(yr.getExpr()))
select 1
