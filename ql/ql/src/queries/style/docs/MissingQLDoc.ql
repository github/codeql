/**
 * @name Missing QLDoc.
 * @description Library classes should have QLDoc.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/missing-qldoc
 * @tags maintainability
 * @precision high
 */

import ql

from File f, Class c
where
  f = c.getLocation().getFile() and
  not exists(c.getQLDoc()) and // no QLDoc
  f.getExtension() = "qll" and // in a library
  not c.isPrivate() and // class is public
  not exists(Module m |
    m.getAMember*() = c and
    m.isPrivate() // modules containing the class are public
  ) and
  not exists(c.getAliasType()) and // class is not just an alias
  not f.getParentContainer*().getBaseName().toLowerCase() = ["internal", "experimental", "test"] // exclusions
select c, "This library class should have QLDoc."
