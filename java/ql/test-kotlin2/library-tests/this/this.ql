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

MaybeElement qualifier(ThisAccess t) {
  if exists(t.getQualifier()) then result = TElement(t.getQualifier()) else result = TNoElement()
}

from ThisAccess t
select t, qualifier(t)

query predicate extensionReceiverAcc(ExtensionReceiverAccess va) { any() }
