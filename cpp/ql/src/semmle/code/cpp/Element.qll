/**
 * Provides the `Element` class, which is the base class for all classes representing C or C++
 * program elements.
 */

import semmle.code.cpp.Location
private import semmle.code.cpp.Enclosing
private import semmle.code.cpp.internal.ResolveClass

/**
 * Get the `Element` that represents this `@element`.
 * Normally this will simply be a cast of `e`, but sometimes it is not.
 * For example, for an incomplete struct `e` the result may be a
 * complete struct with the same name.
 */
pragma[inline]
Element mkElement(@element e) { unresolveElement(result) = e }

/**
 * INTERNAL: Do not use.
 *
 * Gets an `@element` that resolves to the `Element`. This should
 * normally only be called from member predicates, where `e` is not
 * `this` and you need the result for an argument to a database
 * extensional.
 * See `underlyingElement` for when `e` is `this`.
 */
pragma[inline]
@element unresolveElement(Element e) {
  not result instanceof @usertype and
  result = e
  or
  e = resolveClass(result)
}

/**
 * INTERNAL: Do not use.
 *
 * Gets the `@element` that this `Element` extends. This should normally
 * only be called from member predicates, where `e` is `this` and you
 * need the result for an argument to a database extensional.
 * See `unresolveElement` for when `e` is not `this`.
 */
@element underlyingElement(Element e) { result = e }

/**
 * A C/C++ element with no member predicates other than `toString`. Not for
 * general use. This class does not define a location, so classes wanting to
 * change their location without affecting other classes can extend
 * `ElementBase` instead of `Element` to create a new rootdef for `getURL`,
 * `getLocation`, or `hasLocationInfo`.
 */
class ElementBase extends @element {
  /** Gets a textual representation of this element. */
  cached
  string toString() { none() }

  /** DEPRECATED: use `getAPrimaryQlClass` instead. */
  deprecated string getCanonicalQLClass() { result = this.getAPrimaryQlClass() }

  /**
   * Gets the name of a primary CodeQL class to which this element belongs.
   *
   * For most elements, this is simply the most precise syntactic category to
   * which they belong; for example, `AddExpr` is a primary class, but
   * `BinaryOperation` is not.
   *
   * This predicate can have multiple results if multiple primary classes match.
   * For some elements, this predicate may not have a result.
   */
  string getAPrimaryQlClass() { none() }
}

/**
 * A C/C++ element. This class is the base class for all C/C++
 * elements, such as functions, classes, expressions, and so on.
 */
class Element extends ElementBase {
  /** Gets the primary file where this element occurs. */
  File getFile() { result = this.getLocation().getFile() }

  /**
   * Holds if this element may be from source.
   *
   * Note: this predicate is provided for consistency with the libraries
   * for other languages, such as Java and Python. In C++, all files are
   * classified as source files, so this predicate is always true.
   */
  predicate fromSource() { this.getFile().fromSource() }

  /**
   * Holds if this element may be from a library.
   *
   * DEPRECATED: always true.
   */
  deprecated predicate fromLibrary() { this.getFile().fromLibrary() }

  /** Gets the primary location of this element. */
  Location getLocation() { none() }

  /**
   * Gets the source of this element: either itself or a macro that expanded
   * to this element.
   *
   * If the element is not in a macro expansion, then the "root" is just
   * the element itself. Otherwise, it is the definition of the innermost
   * macro whose expansion the element is in.
   *
   * This method is useful for filtering macro results in checks: simply
   * blame `e.findRootCause` rather than `e`. This will report only bugs
   * that are not in macros, and in addition report macros that (somewhere)
   * expand to a bug.
   */
  Element findRootCause() {
    if exists(MacroInvocation mi | this = mi.getAGeneratedElement())
    then
      exists(MacroInvocation mi |
        this = mi.getAGeneratedElement() and
        not exists(MacroInvocation closer |
          this = closer.getAGeneratedElement() and
          mi = closer.getParentInvocation+()
        ) and
        result = mi.getMacro()
      )
    else result = this
  }

  /**
   * Gets the parent scope of this `Element`, if any.
   * A scope is a `Type` (`Class` / `Enum`), a `Namespace`, a `BlockStmt`, a `Function`,
   * or certain kinds of `Statement`.
   */
  Element getParentScope() {
    // result instanceof class
    exists(Declaration m |
      m = this and
      result = m.getDeclaringType() and
      not this instanceof EnumConstant
    )
    or
    exists(TemplateClass tc | this = tc.getATemplateArgument() and result = tc)
    or
    // result instanceof namespace
    exists(Namespace n | result = n and n.getADeclaration() = this)
    or
    exists(FriendDecl d, Namespace n | this = d and n.getADeclaration() = d and result = n)
    or
    exists(Namespace n | this = n and result = n.getParentNamespace())
    or
    // result instanceof stmt
    exists(LocalVariable v |
      this = v and
      exists(DeclStmt ds | ds.getADeclaration() = v and result = ds.getParent())
    )
    or
    exists(Parameter p | this = p and result = p.getFunction())
    or
    exists(GlobalVariable g, Namespace n | this = g and n.getADeclaration() = g and result = n)
    or
    exists(EnumConstant e | this = e and result = e.getDeclaringEnum())
    or
    // result instanceof block|function
    exists(BlockStmt b | this = b and blockscope(unresolveElement(b), unresolveElement(result)))
    or
    exists(TemplateFunction tf | this = tf.getATemplateArgument() and result = tf)
    or
    // result instanceof stmt
    exists(ControlStructure s | this = s and result = s.getParent())
    or
    using_container(unresolveElement(result), underlyingElement(this))
  }

  /**
   * Holds if this element comes from a macro expansion. Only elements that
   * are entirely generated by a macro are included - for elements that
   * partially come from a macro, see `isAffectedByMacro`.
   */
  predicate isInMacroExpansion() { inMacroExpansion(this) }

  /**
   * Holds if this element is affected in any way by a macro. All elements
   * that are totally or partially generated by a macro are included, so
   * this is a super-set of `isInMacroExpansion`.
   */
  predicate isAffectedByMacro() { affectedByMacro(this) }

  private Element getEnclosingElementPref() {
    enclosingfunction(underlyingElement(this), unresolveElement(result)) or
    result.(Function) = stmtEnclosingElement(this) or
    this.(LocalScopeVariable).getFunction() = result or
    enumconstants(underlyingElement(this), unresolveElement(result), _, _, _, _) or
    derivations(underlyingElement(this), unresolveElement(result), _, _, _) or
    stmtparents(underlyingElement(this), _, unresolveElement(result)) or
    exprparents(underlyingElement(this), _, unresolveElement(result)) or
    namequalifiers(underlyingElement(this), unresolveElement(result), _, _) or
    initialisers(underlyingElement(this), unresolveElement(result), _, _) or
    exprconv(unresolveElement(result), underlyingElement(this)) or
    param_decl_bind(underlyingElement(this), _, unresolveElement(result)) or
    using_container(unresolveElement(result), underlyingElement(this)) or
    static_asserts(unresolveElement(this), _, _, _, underlyingElement(result))
  }

  /** Gets the closest `Element` enclosing this one. */
  cached
  Element getEnclosingElement() {
    result = getEnclosingElementPref()
    or
    not exists(getEnclosingElementPref()) and
    (
      this = result.(Class).getAMember()
      or
      result = exprEnclosingElement(this)
      or
      var_decls(underlyingElement(this), unresolveElement(result), _, _, _)
    )
  }

  /**
   * Holds if this `Element` is a part of a template instantiation (but not
   * the template itself).
   */
  predicate isFromTemplateInstantiation(Element instantiation) {
    exists(Element e | isFromTemplateInstantiationRec(e, instantiation) |
      this = e or
      this.(DeclarationEntry).getDeclaration() = e
    )
  }

  /**
   * Holds if this `Element` is part of a template `template` (not if it is
   * part of an instantiation of `template`). This means it is represented in
   * the database purely as syntax and without guarantees on the presence or
   * correctness of type-based operations such as implicit conversions.
   *
   * If an element is nested within several templates, this predicate holds with
   * a value of `template` for each containing template.
   */
  predicate isFromUninstantiatedTemplate(Element template) {
    exists(Element e | isFromUninstantiatedTemplateRec(e, template) |
      this = e or
      this.(DeclarationEntry).getDeclaration() = e
    )
  }
}

private predicate isFromTemplateInstantiationRec(Element e, Element instantiation) {
  instantiation.(Function).isConstructedFrom(_) and
  e = instantiation
  or
  instantiation.(Class).isConstructedFrom(_) and
  e = instantiation
  or
  instantiation.(Variable).isConstructedFrom(_) and
  e = instantiation
  or
  isFromTemplateInstantiationRec(e.getEnclosingElement(), instantiation)
}

private predicate isFromUninstantiatedTemplateRec(Element e, Element template) {
  is_class_template(unresolveElement(template)) and
  e = template
  or
  is_function_template(unresolveElement(template)) and
  e = template
  or
  is_variable_template(unresolveElement(template)) and
  e = template
  or
  isFromUninstantiatedTemplateRec(e.getEnclosingElement(), template)
}

/**
 * A C++11 `static_assert` or C11 `_Static_assert` construct.
 */
class StaticAssert extends Locatable, @static_assert {
  override string toString() { result = "static_assert(..., \"" + getMessage() + "\")" }

  /**
   * Gets the expression which this static assertion ensures is true.
   */
  Expr getCondition() { static_asserts(underlyingElement(this), unresolveElement(result), _, _, _) }

  /**
   * Gets the message which will be reported by the compiler if this static assertion fails.
   */
  string getMessage() { static_asserts(underlyingElement(this), _, result, _, _) }

  override Location getLocation() { static_asserts(underlyingElement(this), _, _, result, _) }
}
