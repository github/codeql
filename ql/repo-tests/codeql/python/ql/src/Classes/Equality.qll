import python

private Attribute dictAccess(LocalVariable var) {
  result.getName() = "__dict__" and
  result.getObject() = var.getAnAccess()
}

private Call getattr(LocalVariable obj, LocalVariable attr) {
  result.getFunc().(Name).getId() = "getattr" and
  result.getArg(0) = obj.getAnAccess() and
  result.getArg(1) = attr.getAnAccess()
}

/**
 * A generic equality method that compares all attributes in its dict,
 * or compares attributes using `getattr`.
 */
class GenericEqMethod extends Function {
  GenericEqMethod() {
    this.getName() = "__eq__" and
    exists(LocalVariable self, LocalVariable other |
      self.getAnAccess() = this.getArg(0) and
      self.getId() = "self" and
      other.getAnAccess() = this.getArg(1) and
      exists(Compare eq |
        eq.getOp(0) instanceof Eq or
        eq.getOp(0) instanceof NotEq
      |
        // `self.__dict__ == other.__dict__`
        eq.getAChildNode() = dictAccess(self) and
        eq.getAChildNode() = dictAccess(other)
        or
        // `getattr(self, var) == getattr(other, var)`
        exists(Variable var |
          eq.getAChildNode() = getattr(self, var) and
          eq.getAChildNode() = getattr(other, var)
        )
      )
    )
  }
}

/** An `__eq__` method that just does `self is other` */
class IdentityEqMethod extends Function {
  IdentityEqMethod() {
    this.getName() = "__eq__" and
    exists(LocalVariable self, LocalVariable other |
      self.getAnAccess() = this.getArg(0) and
      self.getId() = "self" and
      other.getAnAccess() = this.getArg(1) and
      exists(Compare eq | eq.getOp(0) instanceof Is |
        eq.getAChildNode() = self.getAnAccess() and
        eq.getAChildNode() = other.getAnAccess()
      )
    )
  }
}

/** An (in)equality method that delegates to its complement */
class DelegatingEqualityMethod extends Function {
  DelegatingEqualityMethod() {
    exists(Return ret, UnaryExpr not_, Compare comp, Cmpop op, Parameter p0, Parameter p1 |
      ret.getScope() = this and
      ret.getValue() = not_ and
      not_.getOp() instanceof Not and
      not_.getOperand() = comp and
      comp.compares(p0.getVariable().getAnAccess(), op, p1.getVariable().getAnAccess())
    |
      this.getName() = "__eq__" and op instanceof NotEq
      or
      this.getName() = "__ne__" and op instanceof Eq
    )
  }
}
