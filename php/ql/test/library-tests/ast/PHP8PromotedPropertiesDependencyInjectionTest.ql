/**
 * @name PHP 8.0+ Promoted Properties Dependency Injection Test
 * @description Test queries for detecting promoted properties used in dependency injection
 * @kind table
 * @problem.severity recommendation
 */

import php
import codeql.php.ast.PHP8ConstructorPromotion

// Test: Find promoted properties with repository/service-like type names
from PromotedProperty prop
where prop.getType().matches(["%Repository%", "%Service%", "%Factory%", "%Handler%", "%Manager%"])
select prop.getLocation().getStartLine() as line,
       prop.getClass().getName() as className,
       prop.getName() as propertyName,
       prop.getType() as propertyType,
       prop.getVisibility() as visibility,
       "promoted_dependency" as testType
