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

MaybeElement getter(Property p) {
  if exists(p.getGetter()) then result = TElement(p.getGetter()) else result = TNoElement()
}

MaybeElement setter(Property p) {
  if exists(p.getSetter()) then result = TElement(p.getSetter()) else result = TNoElement()
}

MaybeElement backingField(Property p) {
  if exists(p.getBackingField())
  then result = TElement(p.getBackingField())
  else result = TNoElement()
}

from Property p
where p.fromSource()
select p, getter(p), setter(p), backingField(p), concat(string s | p.hasModifier(s) | s, ", ")

query predicate fieldDeclarations(FieldDeclaration fd, Field f, int i) { fd.getField(i) = f }
