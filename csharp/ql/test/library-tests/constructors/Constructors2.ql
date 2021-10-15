/**
 * @name Test for static constructors
 */

import csharp

where count(StaticConstructor c | c.getName() = "Class") = 1
select 1
