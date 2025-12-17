/**
 * @name PHP 8.0+ Constructor Promotion Query Test
 * @description Test queries for constructor property promotion feature detection
 * @kind table
 * @problem.severity recommendation
 */

import php
import codeql.php.ast.PHP8ConstructorPromotion

// Test 1: Find all classes using constructor promotion
from Class c
where classUsesPromotion(c)
select c.getLocation().getStartLine() as line,
       c.getName() as className,
       countPromotedProperties(c) as promotedPropertyCount,
       "class_with_promotion" as testType
