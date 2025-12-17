/**
 * @name PHP 8.0+ Public Mutable Promoted Properties Test
 * @description Test queries for detecting potentially problematic public mutable promoted properties
 * @kind table
 * @problem.severity warning
 */

import php
import codeql.php.ast.PHP8ConstructorPromotion

// Test: Find public promoted properties with mutable types (arrays, collections, objects)
from PromotedProperty prop
where prop.isPublic() and
      (
        prop.getType().matches("%array%") or
        prop.getType().matches("%Collection%") or
        prop.getType().matches("%stdClass%") or
        prop.getType().matches("%object%")
      )
select prop.getLocation().getStartLine() as line,
       prop.getClass().getName() as className,
       prop.getName() as propertyName,
       prop.getType() as propertyType,
       "public_mutable_promoted_property" as testType
