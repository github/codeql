/**
 * @name PHP 8.0+ Promoted Property Query Test
 * @description Test queries for promoted property visibility and types
 * @kind table
 * @problem.severity recommendation
 */

import php
import codeql.php.ast.PHP8ConstructorPromotion

// Test: Find all promoted properties and their visibility levels
from PromotedProperty prop
select prop.getLocation().getStartLine() as line,
       prop.getClass().getName() as className,
       prop.getName() as propertyName,
       prop.getVisibility() as visibility,
       prop.getType() as propertyType,
       "promoted_property" as testType
