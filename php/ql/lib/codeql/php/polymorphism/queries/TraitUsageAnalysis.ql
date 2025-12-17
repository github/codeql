/**
 * @name Trait Usage Analysis
 * @description Analyzes trait composition patterns in the codebase
 * @kind table
 * @tags polymorphism
 *       traits
 *       analysis
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.TraitUsage

/**
 * Show trait usage statistics
 */
from Trait trait, int usageCount
where
  usageCount = count(Class c | classUsesTrait(c, trait))
select trait.getName() as trait_name,
  usageCount as class_count,
  count(Method m | trait.hasMethod(m.getName())) as method_count
order by usageCount desc
