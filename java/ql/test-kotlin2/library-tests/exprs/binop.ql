import java

newtype TMaybeElement =
  TElement(Element e) or
  TNoElement()

class MaybeElement extends TMaybeElement {
  abstract string toString();

  abstract Location getLocation();
}

class YesMaybeElement extends MaybeElement {
  Element e;

  YesMaybeElement() { this = TElement(e) }

  override string toString() { result = e.toString() }

  override Location getLocation() { result = e.getLocation() }
}

class NoMaybeElement extends MaybeElement {
  NoMaybeElement() { this = TNoElement() }

  override string toString() { result = "<none>" }

  override Location getLocation() { none() }
}

MaybeElement lhs(BinaryExpr e) {
  if exists(e.getLeftOperand())
  then result = TElement(e.getLeftOperand())
  else result = TNoElement()
}

MaybeElement rhs(BinaryExpr e) {
  if exists(e.getRightOperand())
  then result = TElement(e.getRightOperand())
  else result = TNoElement()
}

from Expr e
select e, lhs(e), rhs(e)
