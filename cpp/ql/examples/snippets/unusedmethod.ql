/**
 * @id cpp/examples/unusedmethod
 * @name Unused private method
 * @description Finds private non-virtual methods that are not accessed
 * @tags method
 *       access
 *       private
 *       virtual
 */

import cpp

from MemberFunction fcn
where
  fcn.isPrivate() and
  not fcn.isVirtual() and
  not exists(FunctionCall call | fcn = call.getTarget())
select fcn.getDefinition()
