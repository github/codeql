/**
 * Provides the `Element` class, the base class of all C# program elements.
 */

import Location
import Member
private import semmle.code.csharp.ExprOrStmtParent
private import dotnet

/**
 * A program element. Either a control flow element (`ControlFlowElement`), an
 * attribute (`Attribute`), a declaration (`Declaration`), a modifier
 * (`Modifier`), a namespace (`Namespace`), a namespace declaration
 * (`NamespaceDeclaration`), a `using` directive (`UsingDirective`), or type
 * parameter constraints (`TypeParameterConstraints`).
 */
class Element extends DotNet::Element, @element {
  override string toStringWithTypes() { result = this.toString() }

  /**
   * Gets the location of this element. Where an element has locations in
   * source and assemblies, choose the source location. If there are multiple
   * assembly locations, choose only one.
   */
  final override Location getLocation() { result = bestLocation(this) }

  /** Gets a location of this element, including sources and assemblies. */
  override Location getALocation() { none() }

  /** Gets the parent of this element, if any. */
  Element getParent() { result.getAChild() = this }

  /** Gets a child of this element, if any. */
  Element getAChild() { result = this.getChild(_) }

  /** Gets the `i`th child of this element (zero-based). */
  Element getChild(int i) { none() }

  /** Gets the number of children of this element. */
  pragma[nomagic]
  int getNumberOfChildren() { result = count(int i | exists(this.getChild(i))) }

  /**
   * Gets the index of this element among its parent's
   * other children (zero-based).
   */
  int getIndex() { exists(Element parent | parent.getChild(result) = this) }
}
