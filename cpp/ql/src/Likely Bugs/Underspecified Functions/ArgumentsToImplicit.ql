/**
 * @name Call with arguments to an implicitly declared function
 * @description A function call passed arguments even though the
 *              function in question is only implicitly declared (and
 *              hence accepting no arguments).  This may indicate
 *              that the code does not follow the author's intent.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cpp/arguments-to-implicit
 * @tags correctness
 *       maintainability
 */

import cpp

// True if there is no explicit definition of the function
predicate hasNoExplicitDecl(Function f) {
  not exists(FunctionDeclarationEntry fde | fde = f.getADeclarationEntry() | not fde.isImplicit())
}

// True if this file (or header) was compiled as a C file
predicate isCompiledAsC(Function f) {
  exists(File file | file.compiledAsC() |
    file = f.getFile() or file.getAnIncludedFile+() = f.getFile()
  )
}

predicate isWhitelisted(Function f) {
  f instanceof BuiltInFunction
  or
  // The following list can be expanded as the need arises
  exists(string name | name = f.getName() |
    name = "static_assert" or
    name = "_Static_assert" or
    name = "strptime"
  )
}

from FunctionCall fc, Function f
where
  f = fc.getTarget() and
  hasNoExplicitDecl(f) and
  isCompiledAsC(f) and
  not isWhitelisted(f) and
  fc.getNumberOfArguments() > 0
select fc, "This call to an implicitly declared function $@ has arguments.", f, f.toString()
