import cpp

newtype TMaybeStmtParent =
  TStmtParent(StmtParent p) or
  TNoStmtParent()

class MaybeStmtParent extends TMaybeStmtParent {
  abstract string toString();

  abstract Location getLocation();
}

class YesMaybeStmtParent extends MaybeStmtParent {
  StmtParent p;

  YesMaybeStmtParent() { this = TStmtParent(p) }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }

  StmtParent getStmtParent() { result = p }
}

class NoMaybeStmtParent extends MaybeStmtParent {
  NoMaybeStmtParent() { this = TNoStmtParent() }

  override string toString() { result = "<none>" }

  override Location getLocation() { result instanceof UnknownLocation }
}

MaybeStmtParent parent(Stmt s) {
  if exists(s.getParent())
  then result.(YesMaybeStmtParent).getStmtParent() = s.getParent()
  else result instanceof NoMaybeStmtParent
}

from Stmt s
select s, parent(s)
