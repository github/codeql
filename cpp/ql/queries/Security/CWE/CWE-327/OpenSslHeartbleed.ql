/**
 * @name Use of a version of OpenSSL with Heartbleed
 * @description Using an old version of OpenSSL can allow remote
 *              attackers to retrieve portions of memory.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id cpp/openssl-heartbleed
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-788
 */

import cpp

/**
 * Holds if `v` and `w` are ever compared to each other.
 */
predicate comparedTo(Variable v, Variable w) {
  v.getAnAssignedValue() = w.getAnAccess()
  or
  exists(ComparisonOperation comp |
    comp = v.getAnAccess().getParent+() and
    comp = w.getAnAccess().getParent+()
  )
}

class DataVariable extends Variable {
  DataVariable() {
    exists(Struct ssl3_record_st |
      ssl3_record_st.hasName("ssl3_record_st") and
      this = ssl3_record_st.getAField() and
      this.hasName("data")
    )
  }
}

/**
 * Holds if expression `e` might evaluate to a pointer
 * into the memory region pointed to by `v`.
 */
predicate pointsInto(Expr e, DataVariable v) {
  e = v.getAnAccess() or
  e.(AddressOfExpr).getOperand().(ArrayExpr).getArrayBase() = v.getAnAccess() or
  varPointsInto(e.(VariableAccess).getTarget(), v)
}

pragma[nomagic]
predicate varPointsInto(Variable tainted, DataVariable src) {
  pointsInto(tainted.getAnAssignedValue(), src)
}

from FunctionCall fc, Struct ssl3_record_st, Field data, Field length
where
  fc.getTarget().getName().matches("%memcpy%") and
  ssl3_record_st.hasName("ssl3_record_st") and
  data = ssl3_record_st.getAField() and
  data.hasName("data") and
  length = ssl3_record_st.getAField() and
  length.hasName("length") and
  pointsInto(fc.getArgument(1), data) and
  not comparedTo(fc.getArgument(2).(VariableAccess).getTarget(), length)
select fc, "This call to memcpy is insecure (Heartbleed vulnerability)."
