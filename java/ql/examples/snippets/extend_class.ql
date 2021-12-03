/**
 * @id java/examples/extend-class
 * @name Class extends/implements
 * @description Finds classes/interfaces that extend/implement com.example.Class
 * @tags class
 *       extends
 *       implements
 *       overrides
 *       subtype
 *       supertype
 */

import java

from RefType type
where type.getASupertype+().hasQualifiedName("com.example", "Class")
select type
