/**
 * @name AV Rule 185
 * @description C++ style casts (const_cast, reinterpret_cast, and static_cast) shall be used
 *              instead of the traditional C-style cast.
 * @kind problem
 * @id cpp/jsf/av-rule-185
 * @problem.severity recommendation
 * @tags correctness
 *       external/jsf
 */

import cpp

from Cast c
where
  c.fromSource() and
  c.getFile() instanceof CppFile and // Ignore C-style casts in C files
  not c instanceof ConstCast and
  not c instanceof ReinterpretCast and
  not c instanceof StaticCast
select c.findRootCause(),
  "AV Rule 184: C++ style casts shall be used instead of the traditional C-style casts."
