/**
 * @id java/examples/unusedmethod
 * @name Unused private method
 * @description Finds private methods that are not accessed
 * @tags method
 *       access
 *       private
 */

import java

from Method m
where
  m.isPrivate() and
  not exists(m.getAReference()) and
  not m instanceof InitializerMethod
select m
