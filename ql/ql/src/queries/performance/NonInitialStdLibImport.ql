/**
 * @name Standard library is not the first import
 * @description Importing other libraries before the standard library can cause a change in
 *              evaluation order and may lead to performance errors.
 * @kind problem
 * @problem.severity error
 * @id ql/noninitial-stdlib-import
 * @tags performance
 * @precision high
 */

import ql

predicate isStdLibImport(Import i, string name) {
  name = i.getQualifiedName(0) and
  i.getLocation().getFile().getRelativePath().matches(name + "%") and
  not exists(i.getQualifiedName(1))
}

Import importBefore(Import i) {
  exists(Module m, int bi, int ii |
    result = m.getMember(bi) and
    i = m.getMember(ii) and
    bi < ii
  )
}

from Import i
where isStdLibImport(i, _) and exists(importBefore(i))
select i, "This import may cause reevaluation to occur, as there are other imports preceding it"
