/**
 * Symbols for crosss-project jump-to-definition resolution.
 */

import python
import semmle.python.pointsto.PointsTo

private newtype TSymbol =
  TModule(Module m) or
  TMember(Symbol outer, string part) {
    exists(Object o | outer.resolvesTo() = o |
      o.(ModuleObject).hasAttribute(part)
      or
      o.(ClassObject).hasAttribute(part)
    )
  }

/**
 * A "symbol" referencing an object in another module
 * Symbols are represented by the module name and the dotted name by which the
 * object would be referred to in that module.
 * For example for the code:
 * ```
 * class C:
 *     def m(self): pass
 * ```
 * If the code were in a module `mod`,
 * then symbol for the method `m` would be "mod/C.m"
 */
class Symbol extends TSymbol {
  string toString() {
    exists(Module m | this = TModule(m) and result = m.getName())
    or
    exists(TModule outer, string part |
      this = TMember(outer, part) and
      outer = TModule(_) and
      result = outer.(Symbol).toString() + "/" + part
    )
    or
    exists(TMember outer, string part |
      this = TMember(outer, part) and
      outer = TMember(_, _) and
      result = outer.(Symbol).toString() + "." + part
    )
  }

  /** Finds the `AstNode` that this `Symbol` refers to. */
  AstNode find() {
    this = TModule(result)
    or
    exists(Symbol s, string name | this = TMember(s, name) |
      exists(ClassObject cls |
        s.resolvesTo() = cls and
        cls.attributeRefersTo(name, _, result.getAFlowNode())
      )
      or
      exists(ModuleObject m |
        s.resolvesTo() = m and
        m.attributeRefersTo(name, _, result.getAFlowNode())
      )
    )
  }

  /**
   * Find the class or module `Object` that this `Symbol` refers to, if
   * this `Symbol` refers to a class or module.
   */
  Object resolvesTo() {
    this = TModule(result.(ModuleObject).getModule())
    or
    exists(Symbol s, string name, Object o |
      this = TMember(s, name) and
      o = s.resolvesTo() and
      result = attribute_in_scope(o, name)
    )
  }

  /**
   * Gets the `Module` for the module part of this `Symbol`.
   * For example, this would return the `os` module for the `Symbol` "os/environ".
   */
  Module getModule() {
    this = TModule(result)
    or
    exists(Symbol outer | this = TMember(outer, _) and result = outer.getModule())
  }

  /** Gets the `Symbol` that is the named member of this `Symbol`. */
  Symbol getMember(string name) { result = TMember(this, name) }
}

/* Helper for `Symbol`.resolvesTo() */
private Object attribute_in_scope(Object obj, string name) {
  exists(ClassObject cls | cls = obj |
    cls.lookupAttribute(name) = result and result.(ControlFlowNode).getScope() = cls.getPyClass()
  )
  or
  exists(ModuleObject mod | mod = obj |
    mod.attr(name) = result and
    result.(ControlFlowNode).getScope() = mod.getModule() and
    not result.(ControlFlowNode).isEntryNode()
  )
}
