import java

newtype TMaybeExpr =
  TExpr(Expr c) or
  TNoExpr()

class MaybeExpr extends TMaybeExpr {
  abstract string toString();

  abstract Location getLocation();
}

class YesMaybeExpr extends MaybeExpr {
  Expr c;

  YesMaybeExpr() { this = TExpr(c) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

class NoMaybeExpr extends MaybeExpr {
  NoMaybeExpr() { this = TNoExpr() }

  override string toString() { result = "<none>" }

  override Location getLocation() { none() }
}

MaybeExpr initializer(Variable v) {
  if exists(v.getInitializer()) then result = TExpr(v.getInitializer()) else result = TNoExpr()
}

from Variable v
where v.fromSource()
select v, v.getType().toString(), initializer(v)

query predicate isFinal(LocalVariableDecl v, string isFinal) {
  if v.hasModifier("final") then isFinal = "final" else isFinal = "non-final"
}

query predicate compileTimeConstant(CompileTimeConstantExpr e) {
  exists(Variable v | v.getAnAccess() = e)
}
