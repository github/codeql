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

MaybeElement enclosingCallable(Expr e) {
  if exists(e.getEnclosingCallable())
  then result = TElement(e.getEnclosingCallable())
  else result = TNoElement()
}

from Expr e
where e.getFile().isSourceFile()
select e, enclosingCallable(e), e.getPrimaryQlClasses()
