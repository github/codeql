/**
 * @name AV Rule 139
 * @description External objects will not be declared in more than one file.
 * @kind problem
 * @id cpp/jsf/av-rule-139
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

predicate twoDeclarations(Declaration element, Location l1, Location l2) {
  l1 = element.getADeclarationLocation() and
  l2 = element.getADeclarationLocation() and
  l1.getFile() != l2.getFile() and
  l1 != element.getDefinitionLocation() and
  l2 != element.getDefinitionLocation()
}

predicate twoDeclarationFilesWithDifferentNames(Declaration d, string f1, string f2) {
  f1 =
    min(string s, File f, Location l |
      twoDeclarations(d, l, _) and l.getFile() = f and s = f.getBaseName()
    |
      s
    ) and
  f2 =
    min(string s, File f, Location l |
      twoDeclarations(d, l, _) and l.getFile() = f and s = f.getBaseName() and s != f1
    |
      s
    )
}

predicate twoDeclarationFilesWithSameNames(Declaration d, string f1, string f2) {
  f1 =
    min(string s, File f, Location l |
      twoDeclarations(d, l, _) and l.getFile() = f and s = f.toString()
    |
      s
    ) and
  f2 =
    min(string s, File f, Location l |
      twoDeclarations(d, l, _) and l.getFile() = f and s = f.toString() and s != f1
    |
      s
    )
}

predicate twoDeclarationFilesMessage(Declaration d, string msg) {
  // If we can get two files with different names, all the better for the error message
  if twoDeclarationFilesWithDifferentNames(d, _, _)
  then
    exists(string f1, string f2 |
      twoDeclarationFilesWithDifferentNames(d, f1, f2) and msg = "Declared in " + f1 + " and " + f2
    )
  else
    exists(string f1, string f2 |
      twoDeclarationFilesWithSameNames(d, f1, f2) and msg = "Declared in " + f1 + " and " + f2
    )
}

from Declaration d, string msg
where
  twoDeclarations(d, _, _) and
  twoDeclarationFilesMessage(d, msg)
select d, "AV Rule 139: external objects will not be declared in more than one file. " + msg
