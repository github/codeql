/**
 * @name Test convenience abstractions
 * @description Tests the custom abstractions in AST.qll
 * @kind problem
 * @problem.severity recommendation
 * @id php/test-abstractions
 */

import php

from int callCount, int varCount, int funcCount, int classLikeCount, int loopCount, int stringCount
where
  callCount = count(Call c | any()) and
  varCount = count(Variable v | any()) and
  funcCount = count(Function f | any()) and
  classLikeCount = count(ClassLike c | any()) and
  loopCount = count(Loop l | any()) and
  stringCount = count(StringLiteral s | any())
select "Abstraction test: " + callCount + " calls, " + varCount + " variables, " +
       funcCount + " functions, " + classLikeCount + " class-likes, " +
       loopCount + " loops, " + stringCount + " strings"
