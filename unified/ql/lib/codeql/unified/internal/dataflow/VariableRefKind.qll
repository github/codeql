private import unified

newtype TVariableRefKind =
  TRead() or
  TWrite() or
  TPostUpdate()

class VariableRefKind extends TVariableRefKind {
  predicate isRead() { this = TRead() }

  predicate isWrite() { this = TWrite() }

  predicate isPostUpdate() { this = TPostUpdate() }

  string toString() {
    this.isRead() and result = "read"
    or
    this.isWrite() and result = "write"
    or
    this.isPostUpdate() and result = "post-update"
  }
}
