/**
 * @name Comprehensive PHP library test
 * @description Tests all major abstractions in the PHP library
 * @kind problem
 * @problem.severity recommendation
 * @id php/comprehensive-test
 */

import php

// Test 1: Count different node types
from int funcCount, int classCount, int methodCount, int callCount, int varCount
where
  funcCount = count(FunctionDefinition f | any()) and
  classCount = count(ClassDeclaration c | any()) and
  methodCount = count(MethodDeclaration m | any()) and
  callCount = count(FunctionCallExpression c | any()) and
  varCount = count(VariableName v | any())
select "Statistics: " + funcCount + " functions, " + classCount + " classes, " +
       methodCount + " methods, " + callCount + " function calls, " + varCount + " variables"
