/**
 * @name Test for constructors
 */

import csharp

where forall(StaticConstructor c | c.hasNoParameters())
select 1
