/** Provides the `Element` class, the base class of all CIL program elements. */

private import dotnet
import semmle.code.csharp.Location

/** An element. */
deprecated class Element extends DotNet::Element, @cil_element {
  override Location getLocation() { result = bestLocation(this) }
}

cached
deprecated private Location bestLocation(Element e) {
  result = e.getALocation() and
  (e.getALocation().getFile().isPdbSourceFile() implies result.getFile().isPdbSourceFile())
}
