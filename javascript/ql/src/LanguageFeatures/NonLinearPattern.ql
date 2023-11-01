/**
 * @name Non-linear pattern
 * @description If the same pattern variable appears twice in an array or object pattern,
 *              the second binding will silently overwrite the first binding, which is probably
 *              unintentional.
 * @kind problem
 * @problem.severity error
 * @id js/non-linear-pattern
 * @tags reliability
 *       correctness
 *       language-features
 * @precision very-high
 */

import javascript

class RootDestructuringPattern extends DestructuringPattern {
  RootDestructuringPattern() {
    not this = any(PropertyPattern p).getValuePattern() and
    not this = any(ArrayPattern p).getAnElement()
  }

  /** Holds if this pattern has multiple bindings for `name`. */
  predicate hasConflictingBindings(string name) {
    exists(VarRef v, VarRef w |
      v = this.getABindingVarRef() and
      w = this.getABindingVarRef() and
      name = v.getName() and
      name = w.getName() and
      v != w
    )
  }

  /** Gets the first occurrence of the conflicting binding `name`. */
  VarDecl getFirstClobberedVarDecl(string name) {
    this.hasConflictingBindings(name) and
    result =
      min(VarDecl decl |
        decl = this.getABindingVarRef() and decl.getName() = name
      |
        decl order by decl.getLocation().getStartLine(), decl.getLocation().getStartColumn()
      )
  }

  /** Holds if variables in this pattern may resemble type annotations. */
  predicate resemblesTypeAnnotation() {
    this.hasConflictingBindings(_) and // Restrict size of predicate.
    this instanceof Parameter and
    this instanceof ObjectPattern and
    not exists(this.getTypeAnnotation()) and
    this.getFile().getFileType().isTypeScript()
  }
}

from RootDestructuringPattern p, string n, VarDecl v, VarDecl w, string message
where
  v = p.getFirstClobberedVarDecl(n) and
  w = p.getABindingVarRef() and
  w.getName() = n and
  v != w and
  if p.resemblesTypeAnnotation()
  then message = "The pattern variable '" + n + "' appears to be a type, but is a variable $@."
  else message = "Repeated binding of pattern variable '" + n + "' $@."
select w, message, v, "previously bound"
