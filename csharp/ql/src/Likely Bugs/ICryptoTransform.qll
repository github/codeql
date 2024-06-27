import csharp

class ImplementsICryptoTransform extends Class {
  ImplementsICryptoTransform() {
    this.getABaseType*().hasFullyQualifiedName("System.Security.Cryptography", "ICryptoTransform")
  }
}

predicate usesICryptoTransformType(ValueOrRefType t) {
  exists(ImplementsICryptoTransform ict |
    ict = t or
    usesICryptoTransformType(t.getAChild())
  )
}

predicate hasICryptoTransformMember(Class c) {
  c.getAField().getType() instanceof UsesICryptoTransform
}

class UsesICryptoTransform extends Class {
  UsesICryptoTransform() { usesICryptoTransformType(this) or hasICryptoTransformMember(this) }
}

class LambdaCapturingICryptoTransformSource extends DataFlow::Node {
  LambdaCapturingICryptoTransformSource() {
    exists(LambdaExpr l, LocalScopeVariable lsvar, UsesICryptoTransform ict | l = this.asExpr() |
      ict = lsvar.getType() and
      lsvar.getACapturingCallable() = l
    )
  }
}
