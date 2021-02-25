/**
 * @name XML alert suppression
 * @description Generates information about alert suppressions in XML files.
 * @kind alert-suppression
 * @id cs/xml-alert-suppression
 */

import semmle.code.csharp.XML

from XMLSuppressionComment c
select c, // suppression comment
  c.getText(), // text of suppression comment (excluding delimiters)
  c.getAnnotation(), // text of suppression annotation
  c.getScope() // scope of suppression
