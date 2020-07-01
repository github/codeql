/**
 * @name Mismatching new/free or malloc/delete
 * @description An object that was allocated with 'malloc' or 'new' is being freed using a mismatching 'free' or 'delete'.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/new-free-mismatch
 * @tags reliability
 *       security
 *       external/cwe/cwe-401
 */

import NewDelete

/**
 * Holds if `allocKind` and `freeKind` indicate corresponding
 * types of allocation and free.
 */
predicate correspondingKinds(string allocKind, string freeKind) {
  allocKind = "malloc" and
  freeKind = "free"
  or
  allocKind = "new" and
  freeKind = "delete"
}

from
  Expr alloc, string allocKind, string allocKindSimple, Expr free, Expr freed, string freeKind,
  string freeKindSimple
where
  allocReaches(freed, alloc, allocKind) and
  freeExprOrIndirect(free, freed, freeKind) and
  allocKindSimple = allocKind.replaceAll("[]", "") and
  freeKindSimple = freeKind.replaceAll("[]", "") and
  not correspondingKinds(allocKindSimple, freeKindSimple)
select free,
  "There is a " + allocKindSimple + "/" + freeKindSimple + " mismatch between this " + freeKind +
    " and the corresponding $@.", alloc, allocKind
