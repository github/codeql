/**
 * @name Annotation is extended or implemented
 * @description Extending or implementing an annotation is unlikely to be what the programmer intends.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/annotation-subtype
 * @tags maintainability
 *       correctness
 *       logic
 */

import java

from RefType type, AnnotationType annotation
where type.getASupertype() = annotation
select type,
  "Should this class be annotated by '" + annotation.getName() + "', not have it as a super-type?"
