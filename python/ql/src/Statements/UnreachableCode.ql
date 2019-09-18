/**
 * @name Unreachable code
 * @description Code is unreachable
 * @kind problem
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 * @problem.severity warning
 * @sub-severity low
 * @precision very-high
 * @id py/unreachable-statement
 */

import python

predicate typing_import(ImportingStmt is) {
    exists(Module m |
        is.getScope() = m and
        exists(TypeHintComment tc |
            tc.getLocation().getFile() = m.getFile()
        )
    )
}

/** Holds if `s` contains the only `yield` in scope */
predicate unique_yield(Stmt s) {
    exists(Yield y | s.contains(y)) and
    exists(Function f |
        f = s.getScope() and
        strictcount(Yield y | f.containsInScope(y)) = 1
    )
}

predicate reportable_unreachable(Stmt s) {
    s.isUnreachable() and
    not typing_import(s) and
    not exists(Stmt other | other.isUnreachable() |
        other.contains(s)
        or
        exists(StmtList l, int i, int j | 
            l.getItem(i) = other and l.getItem(j) = s and i < j
        )
    ) and
    not unique_yield(s)
}

from Stmt s
where reportable_unreachable(s)
select s, "Unreachable statement."
