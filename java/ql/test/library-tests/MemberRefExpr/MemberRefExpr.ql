import java

query string getReferencedCallable(MemberRefExpr e) {
  // Use qualified name because some callables don't have a source location (e.g. `Object.toString`)
  result = e.getReferencedCallable().getQualifiedName()
}

query Expr getReceiverExpr(MemberRefExpr e) { result = e.getReceiverExpr() }

query RefType getReceiverType(MemberRefExpr e) { result = e.getReceiverType() }
