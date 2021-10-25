import cpp

class MutexTypeForTest extends MutexType {
  MutexTypeForTest() { this.(Class).getName() = "Mutex7" }

  override predicate mustlockAccess(FunctionCall fc, Expr arg) {
    exists(Function f |
      f = fc.getTarget() and
      f.getName() = "custom_l" and
      f.getDeclaringType() = this and
      arg = fc.getQualifier()
    )
  }

  override predicate trylockAccess(FunctionCall fc, Expr arg) { none() }

  override predicate unlockAccess(FunctionCall fc, Expr arg) {
    exists(Function f |
      f = fc.getTarget() and
      f.getName() = "custom_ul" and
      f.getDeclaringType() = this and
      arg = fc.getQualifier()
    )
  }
}
