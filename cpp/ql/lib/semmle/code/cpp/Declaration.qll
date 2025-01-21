/**
 * Provides classes for working with C and C++ declarations.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.Specifier
import semmle.code.cpp.Namespace
private import semmle.code.cpp.internal.QualifiedName as Q

/**
 * A C/C++ declaration: for example, a variable declaration, a type
 * declaration, or a function declaration.
 *
 * This file defines two closely related classes: `Declaration` and
 * `DeclarationEntry`. Some declarations do not correspond to a unique
 * location in the source code. For example, a global variable might
 * be declared in multiple source files:
 * ```
 *   extern int myglobal;
 * ```
 * and defined in one:
 * ```
 *   int myglobal;
 * ```
 * Each of these declarations (including the definition) is given its own
 * distinct `DeclarationEntry`, but they all share the same `Declaration`.
 *
 * Some derived class of `Declaration` do not have a corresponding
 * `DeclarationEntry`, because they always have a unique source location.
 * `EnumConstant` and `FriendDecl` are both examples of this.
 */
class Declaration extends Locatable, @declaration {
  /**
   * Gets the innermost namespace which contains this declaration.
   *
   * The result will either be `GlobalNamespace`, or the tightest lexically
   * enclosing namespace block. In particular, note that for declarations
   * within structures, the namespace of the declaration is the same as the
   * namespace of the structure.
   */
  Namespace getNamespace() {
    result = underlyingElement(this).(Q::Declaration).getNamespace()
    or
    exists(Parameter p | p = this and result = p.getFunction().getNamespace())
    or
    exists(LocalVariable v | v = this and result = v.getFunction().getNamespace())
  }

  /**
   * Gets the name of the declaration, fully qualified with its
   * namespace and declaring type.
   *
   * For performance, prefer the multi-argument `hasQualifiedName` or
   * `hasGlobalName` predicates since they don't construct so many intermediate
   * strings. For debugging, the `semmle.code.cpp.Print` module produces more
   * detailed output but are also more expensive to compute.
   *
   * Example: `getQualifiedName() =
   * "namespace1::namespace2::TemplateClass1<int>::Class2::memberName"`.
   */
  string getQualifiedName() { result = underlyingElement(this).(Q::Declaration).getQualifiedName() }

  /**
   * Holds if this declaration has a fully-qualified name with a name-space
   * component of `namespaceQualifier`, a declaring type of `typeQualifier`,
   * and a base name of `baseName`. Template parameters and arguments are
   * stripped from all components. Missing components are `""`.
   *
   * Example: `hasQualifiedName("namespace1::namespace2",
   * "TemplateClass1::Class2", "memberName")`.
   *
   * Example (the class `std::vector`): `hasQualifiedName("std", "", "vector")`
   * or `hasQualifiedName("std", "vector")`.
   *
   * Example (the `size` member function of class `std::vector`):
   * `hasQualifiedName("std", "vector", "size")`.
   */
  predicate hasQualifiedName(string namespaceQualifier, string typeQualifier, string baseName) {
    underlyingElement(this)
        .(Q::Declaration)
        .hasQualifiedName(namespaceQualifier, typeQualifier, baseName)
  }

  /**
   * Holds if this declaration has a fully-qualified name with a name-space
   * component of `namespaceQualifier`, no declaring type, and a base name of
   * `baseName`.
   *
   * See the 3-argument `hasQualifiedName` for examples.
   */
  predicate hasQualifiedName(string namespaceQualifier, string baseName) {
    this.hasQualifiedName(namespaceQualifier, "", baseName)
  }

  /**
   * Gets a description of this `Declaration` for display purposes.
   */
  string getDescription() { result = this.getName() }

  final override string toString() { result = this.getDescription() }

  /**
   * Gets the name of this declaration.
   *
   * This name doesn't include a namespace or any argument types, so
   * for example both functions `::open()` and `::std::ifstream::open(...)`
   * have the same name. The name of a template _class_ includes a string
   * representation of its parameters, and the names of its instantiations
   * include string representations of their arguments. Template _functions_
   * and their instantiations do not include template parameters or arguments.
   *
   * To get the name including the namespace, use `hasQualifiedName`.
   *
   * To test whether this declaration has a particular name in the global
   * namespace, use `hasGlobalName`.
   */
  string getName() { none() } // overridden in subclasses

  /** Holds if this declaration has the given name. */
  predicate hasName(string name) { name = this.getName() }

  /** Holds if this declaration has the given name in the global namespace. */
  predicate hasGlobalName(string name) { this.hasQualifiedName("", "", name) }

  /** Holds if this declaration has the given name in the global namespace or the `std` namespace. */
  predicate hasGlobalOrStdName(string name) {
    this.hasGlobalName(name)
    or
    this.hasQualifiedName("std", "", name)
  }

  /**
   * Holds if this declaration has the given name in the global namespace,
   * the `std` namespace or the `bsl` namespace.
   * We treat `std` and `bsl` as the same in some of our models.
   */
  predicate hasGlobalOrStdOrBslName(string name) {
    this.hasGlobalName(name)
    or
    this.hasQualifiedName("std", "", name)
    or
    this.hasQualifiedName("bsl", "", name)
  }

  /** Gets a specifier of this declaration. */
  Specifier getASpecifier() { none() } // overridden in subclasses

  /** Holds if this declaration has a specifier with the given name. */
  predicate hasSpecifier(string name) { this.getASpecifier().hasName(name) }

  /**
   * Gets a declaration entry corresponding to this declaration. See the
   * comment above this class for an explanation of the relationship
   * between `Declaration` and `DeclarationEntry`.
   */
  DeclarationEntry getADeclarationEntry() { none() }

  /**
   * Gets the location of a declaration entry corresponding to this
   * declaration.
   */
  Location getADeclarationLocation() { none() } // overridden in subclasses

  /**
   * Gets the declaration entry corresponding to this declaration that is a
   * definition, if any.
   */
  DeclarationEntry getDefinition() { none() }

  /** Gets the location of the definition, if any. */
  Location getDefinitionLocation() { none() } // overridden in subclasses

  /** Holds if the declaration has a definition. */
  predicate hasDefinition() { exists(this.getDefinition()) }

  /** Gets the preferred location of this declaration, if any. */
  override Location getLocation() { none() }

  /** Gets a file where this element occurs. */
  File getAFile() { result = this.getADeclarationLocation().getFile() }

  /** Holds if this declaration is a top-level declaration. */
  predicate isTopLevel() {
    not (
      this.isMember() or
      this instanceof EnumConstant or
      this instanceof Parameter or
      this instanceof ProxyClass or
      this instanceof LocalVariable or
      this instanceof TypeTemplateParameter or
      this.(UserType).isLocal()
    )
  }

  /** Holds if this declaration is static. */
  predicate isStatic() { this.hasSpecifier("static") }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate isMember() { this.hasDeclaringType() }

  /** Holds if this declaration is a member of a class/struct/union. */
  predicate hasDeclaringType() { exists(this.getDeclaringType()) }

  /**
   * Gets the class where this member is declared, if it is a member.
   * For templates, both the template itself and all instantiations of
   * the template are considered to have the same declaring class.
   */
  Class getDeclaringType() { this = result.getAMember() }

  /**
   * Gets a template argument used to instantiate this declaration from a template.
   * When called on a template, this will return a template parameter type for
   * both typed and non-typed parameters.
   */
  final Locatable getATemplateArgument() { result = this.getTemplateArgument(_) }

  /**
   * Gets a template argument used to instantiate this declaration from a template.
   * When called on a template, this will return a non-typed template
   * parameter value.
   */
  final Locatable getATemplateArgumentKind() { result = this.getTemplateArgumentKind(_) }

  /**
   * Gets the `i`th template argument used to instantiate this declaration from a
   * template.
   *
   * For example:
   *
   * `template<typename T, T X> class Foo;`
   *
   * Will have `getTemplateArgument(0)` return `T`, and
   * `getTemplateArgument(1)` return `X`.
   *
   * `Foo<int, 1> bar;`
   *
   * Will have `getTemplateArgument(0)` return `int`, and
   * `getTemplateArgument(1)` return `1`.
   */
  final Locatable getTemplateArgument(int index) {
    if exists(this.getTemplateArgumentValue(index))
    then result = this.getTemplateArgumentValue(index)
    else result = this.getTemplateArgumentType(index)
  }

  /**
   * Gets the `i`th template argument value used to instantiate this declaration
   * from a template. When called on a template, this will return the `i`th template
   * parameter value if it exists.
   *
   * For example:
   *
   * `template<typename T, T X> class Foo;`
   *
   * Will have `getTemplateArgumentKind(1)` return `T`, and no result for
   * `getTemplateArgumentKind(0)`.
   *
   * `Foo<int, 10> bar;
   *
   * Will have `getTemplateArgumentKind(1)` return `int`, and no result for
   * `getTemplateArgumentKind(0)`.
   */
  final Locatable getTemplateArgumentKind(int index) {
    exists(this.getTemplateArgumentValue(index)) and
    result = this.getTemplateArgumentType(index)
  }

  /** Gets the number of template arguments for this declaration. */
  final int getNumberOfTemplateArguments() {
    result = count(int i | exists(this.getTemplateArgument(i)))
  }

  private Type getTemplateArgumentType(int index) {
    class_template_argument(underlyingElement(this), index, unresolveElement(result))
    or
    function_template_argument(underlyingElement(this), index, unresolveElement(result))
    or
    variable_template_argument(underlyingElement(this), index, unresolveElement(result))
    or
    template_template_argument(underlyingElement(this), index, unresolveElement(result))
    or
    concept_template_argument(underlyingElement(this), index, unresolveElement(result))
  }

  private Expr getTemplateArgumentValue(int index) {
    class_template_argument_value(underlyingElement(this), index, unresolveElement(result))
    or
    function_template_argument_value(underlyingElement(this), index, unresolveElement(result))
    or
    variable_template_argument_value(underlyingElement(this), index, unresolveElement(result))
    or
    template_template_argument_value(underlyingElement(this), index, unresolveElement(result))
    or
    concept_template_argument_value(underlyingElement(this), index, unresolveElement(result))
  }
}

private class TDeclarationEntry = @var_decl or @type_decl or @fun_decl;

/**
 * A C/C++ declaration entry. For example the following code contains five
 * declaration entries:
 * ```
 * extern int myGlobal;
 * int myVariable;
 * typedef char MyChar;
 * void myFunction();
 * void myFunction() {
 *   // ...
 * }
 * ```
 * See the comment above `Declaration` for an explanation of the relationship
 * between `Declaration` and `DeclarationEntry`.
 */
class DeclarationEntry extends Locatable, TDeclarationEntry {
  /** Gets a specifier associated with this declaration entry. */
  string getASpecifier() { none() } // overridden in subclasses

  /**
   * Gets the name associated with the corresponding definition (where
   * available), or the name declared by this entry otherwise.
   */
  string getCanonicalName() {
    if this.getDeclaration().hasDefinition()
    then result = this.getDeclaration().getDefinition().getName()
    else result = this.getName()
  }

  /**
   * Gets the declaration for which this is a declaration entry.
   *
   * Note that this is *not* always the inverse of
   * `Declaration.getADeclarationEntry()`, for example if `C` is a
   * `TemplateClass`, `I` is an instantiation of `C`, and `D` is a
   * `Declaration` of `C`, then:
   *  `C.getADeclarationEntry()` returns `D`
   *  `I.getADeclarationEntry()` returns `D`
   *  but `D.getDeclaration()` only returns `C`
   */
  Declaration getDeclaration() { none() } // overridden in subclasses

  /** Gets the name associated with this declaration entry, if any. */
  string getName() { none() } // overridden in subclasses

  /**
   * Gets the type associated with this declaration entry.
   *
   * For variable declarations, get the type of the variable.
   * For function declarations, get the return type of the function.
   * For type declarations, get the type being declared.
   */
  Type getType() { none() } // overridden in subclasses

  /**
   * Gets the type associated with this declaration entry after specifiers
   * have been deeply stripped and typedefs have been resolved.
   *
   * For variable declarations, get the type of the variable.
   * For function declarations, get the return type of the function.
   * For type declarations, get the type being declared.
   */
  Type getUnspecifiedType() { result = this.getType().getUnspecifiedType() }

  /**
   * Holds if this declaration entry has a specifier with the given name.
   */
  predicate hasSpecifier(string specifier) { this.getASpecifier() = specifier }

  /** Holds if this declaration entry is a definition. */
  predicate isDefinition() { none() } // overridden in subclasses

  override string toString() {
    if this.isDefinition()
    then result = "definition of " + this.getName()
    else
      if this.getName() = this.getCanonicalName()
      then result = "declaration of " + this.getName()
      else result = "declaration of " + this.getCanonicalName() + " as " + this.getName()
  }
}

private class TAccessHolder = @function or @usertype;

/**
 * A declaration that can potentially have more C++ access rights than its
 * enclosing element. This comprises `Class` (they have access to their own
 * private members) along with other `UserType`s and `Function` (they can be
 * the target of `friend` declarations).  For example `MyClass` and
 * `myFunction` in the following code:
 * ```
 * class MyClass
 * {
 * public:
 *   ...
 * };
 *
 * void myFunction() {
 *   // ...
 * }
 * ```
 * In the C++ standard (N4140 11.2), rules for access control revolve around
 * the informal phrase "_R_ occurs in a member or friend of class C", where
 * `AccessHolder` corresponds to this _R_.
 */
class AccessHolder extends Declaration, TAccessHolder {
  /**
   * Holds if `this` can access private members of class `c`.
   *
   * This predicate encodes the phrase "occurs in a member or friend" that is
   * repeated many times in the C++14 standard, section 11.2.
   */
  predicate inMemberOrFriendOf(Class c) {
    this.getEnclosingAccessHolder*() = c
    or
    exists(FriendDecl fd | fd.getDeclaringClass() = c |
      this.getEnclosingAccessHolder*() = fd.getFriend()
    )
  }

  /**
   * Gets the nearest enclosing `AccessHolder`.
   */
  AccessHolder getEnclosingAccessHolder() { none() } // overridden in subclasses

  /**
   * Holds if a base class `base` of `derived` _is accessible at_ `this` (N4140
   * 11.2/4). When this holds, and `derived` has only one base subobject of
   * type `base`, code in `this` can implicitly convert a pointer to `derived`
   * into a pointer to `base`. Conversely, if such a conversion is possible
   * then this predicate holds.
   *
   * For the sake of generality, this predicate also holds whenever `base` =
   * `derived`.
   *
   * This predicate is `pragma[inline]` because it is infeasible to fully
   * compute it on large code bases: all classes `derived` can be converted to
   * their public bases `base` from everywhere (`this`), so this predicate
   * could yield a number of tuples that is quadratic in the size of the
   * program. To avoid this combinatorial explosion, only use this predicate in
   * a context where `this` together with `base` or `derived` are sufficiently
   * restricted.
   */
  pragma[inline]
  predicate canAccessClass(Class base, Class derived) {
    // This predicate is marked `inline` and implemented in a very particular
    // way. If we allowed this predicate to be fully computed, it would relate
    // all `AccessHolder`s to all classes, which would be too much.
    // There are four rules in N4140 11.2/4. Only the one named (4.4) is
    // recursive, and it describes a transitive closure: intuitively, if A can
    // be converted to B, and B can be converted to C, then A can be converted
    // to C. To limit the number of tuples in the non-inline helper predicates,
    // we first separate the derivation of 11.2/4 into two cases:
    // Derivations using only (4.1) and (4.4). Note that these derivations are
    // independent of `this`, which is why users of this predicate must take
    // care to avoid a combinatorial explosion.
    isDirectPublicBaseOf*(base, derived)
    or
    exists(DirectAccessHolder n |
      this.getEnclosingAccessHolder*() = n and
      // Derivations using (4.2) or (4.3) at least once.
      n.thisCanAccessClassTrans(base, derived)
    )
  }

  /**
   * Holds if a non-static member `member` _is accessible at_ `this` when named
   * in a class `derived` that is derived from or equal to the declaring class
   * of `member` (N4140 11.2/5 and 11.4).
   *
   * This predicate determines whether an expression `x.member` would be
   * allowed in `this` when `x` has type `derived`. The more general syntax
   * `x.N::member`, where `N` may be a base class of `derived`, is not
   * supported. This should only affect very rare edge cases of 11.4. This
   * predicate concerns only _access_ and thus does not determine whether
   * `member` can be unambiguously named at `this`: multiple overloads may
   * apply, or `member` may be declared in an ambiguous base class.
   *
   * This predicate is `pragma[inline]` because it is infeasible to fully
   * compute it on large code bases: all public members `member` are accessible
   * from everywhere (`this`), so this predicate could yield a number of tuples
   * that is quadratic in the size of the program. To avoid this combinatorial
   * explosion, only use this predicate in a context where `this` and `member`
   * are sufficiently restricted when `member` is public.
   */
  pragma[inline]
  predicate canAccessMember(Declaration member, Class derived) {
    this.couldAccessMember(member.getDeclaringType(), member.getASpecifier(), derived)
  }

  /**
   * Holds if a hypothetical non-static member of `memberClass` with access
   * specifier `memberAccess` _is accessible at_ `this` when named in a class
   * `derived` that is derived from or equal to `memberClass` (N4140 11.2/5 and
   * 11.4).
   *
   * This predicate determines whether an expression `x.m` would be
   * allowed in `this` when `x` has type `derived` and `m` has `memberAccess`
   * in `memberClass`. The more general syntax `x.N::n`, where `N` may be a
   * base class of `derived`, is not supported. This should only affect very
   * rare edge cases of 11.4.
   *
   * This predicate is `pragma[inline]` because it is infeasible to fully
   * compute it on large code bases: all classes `memberClass` have their
   * public members accessible from everywhere (`this`), so this predicate
   * could yield a number of tuples that is quadratic in the size of the
   * program. To avoid this combinatorial explosion, only use this predicate in
   * a context where `this` and `memberClass` are sufficiently restricted when
   * `memberAccess` is public.
   */
  pragma[inline]
  predicate couldAccessMember(Class memberClass, AccessSpecifier memberAccess, Class derived) {
    // There are four rules in N4140 11.2/5. To limit the number of tuples in
    // the non-inline helper predicates, we first separate the derivation of
    // 11.2/5 into two cases:
    // Rule (5.1) directly: the member is public, and `derived` uses public
    // inheritance all the way up to `memberClass`. Note that these derivations
    // are independent of `this`, which is why users of this predicate must
    // take care to avoid a combinatorial explosion.
    everyoneCouldAccessMember(memberClass, memberAccess, derived)
    or
    exists(DirectAccessHolder n |
      this.getEnclosingAccessHolder*() = n and
      // Any other derivation.
      n.thisCouldAccessMember(memberClass, memberAccess, derived)
    )
  }
}

/**
 * A declaration that very likely has more C++ access rights than its
 * enclosing element. This comprises `Class` (they have access to their own
 * private members) along with any target of a `friend` declaration.  For
 * example `MyClass` and `friendFunction` in the following code:
 * ```
 * class MyClass
 * {
 * public:
 *   friend void friendFunction();
 * };
 *
 * void friendFunction() {
 *   // ...
 * }
 * ```
 * Most access rights are computed for `DirectAccessHolder` instead of
 * `AccessHolder` -- that's more efficient because there are fewer
 * `DirectAccessHolder`s. If a `DirectAccessHolder` contains an `AccessHolder`,
 * then the contained `AccessHolder` inherits its access rights.
 */
private class DirectAccessHolder extends Element {
  DirectAccessHolder() {
    this instanceof Class
    or
    exists(FriendDecl fd | fd.getFriend() = this)
  }

  /**
   * Holds if a base class `base` of `derived` _is accessible at_ `this` when
   * the derivation of that fact uses rule (4.2) and (4.3) of N4140 11.2/4 at
   * least once. In other words, the `this` parameter is not ignored. This
   * restriction makes it feasible to fully enumerate this predicate even on
   * large code bases.
   */
  predicate thisCanAccessClassTrans(Class base, Class derived) {
    // This implementation relies on the following property of our predicates:
    // if `this.thisCanAccessClassStep(b, d)` and
    // `isDirectPublicBaseOf(b2, b)`, then
    // `this.thisCanAccessClassStep(b2, d)`. In other words, if a derivation
    // uses (4.2) or (4.3) somewhere and uses (4.1) directly above that in the
    // transitive chain, then the use of (4.1) is redundant. This means we only
    // need to consider derivations that use (4.2) or (4.3) as the "first"
    // step, that is, towards `base`, so this implementation is essentially a
    // transitive closure with a restricted base case.
    this.thisCanAccessClassStep(base, derived)
    or
    exists(Class between | this.thisCanAccessClassTrans(base, between) |
      isDirectPublicBaseOf(between, derived) or
      this.thisCanAccessClassStep(between, derived)
    )
    // It is possible that this predicate could be computed faster for deep
    // hierarchies if we can prove and utilize that all derivations of 11.2/4
    // can be broken down into steps where `base` is a _direct_ base of
    // `derived` in each step.
  }

  /**
   * Holds if a base class `base` of `derived` _is accessible at_ `this` using
   * only a single application of rule (4.2) and (4.3) of N4140 11.2/4.
   */
  private predicate thisCanAccessClassStep(Class base, Class derived) {
    exists(AccessSpecifier public | public.hasName("public") |
      // Rules (4.2) and (4.3) are implemented together as one here with
      // reflexive-transitive inheritance, where (4.3) is the transitive case,
      // and (4.2) is the reflexive case.
      exists(Class p | p = derived.getADerivedClass*() |
        this.isFriendOfOrEqualTo(p) and
        // Note: it's crucial that this is `!=` rather than `not =` since
        // `accessOfBaseMember` does not have a result when the member would be
        // inaccessible.
        p.accessOfBaseMember(base, public) != public
      )
    ) and
    // This is the only case that doesn't in itself guarantee that
    // `derived` < `base`, so we add the check here. The standard suggests
    // computing `canAccessClass` only for derived classes, but that seems
    // incompatible with the execution model of QL, so we instead construct
    // every case to guarantee `derived` < `base`.
    derived = base.getADerivedClass+()
  }

  /**
   * Like `couldAccessMember` but only contains derivations in which either
   * (5.2), (5.3) or (5.4) must be invoked. In other words, the `this`
   * parameter is not ignored. We check for 11.4 as part of (5.3), since
   * this further limits the number of tuples produced by this predicate.
   */
  pragma[inline]
  predicate thisCouldAccessMember(Class memberClass, AccessSpecifier memberAccess, Class derived) {
    // Only (5.4) is recursive, and chains of invocations of (5.4) can always
    // be collapsed to one invocation by the transitivity of 11.2/4.
    // Derivations not using (5.4) can always be rewritten to have a (5.4) rule
    // in front because our encoding of 11.2/4 in `canAccessClass` is
    // reflexive. Thus, we only need to consider three cases: rule (5.4)
    // followed by either (5.1), (5.2) or (5.3).
    // Rule (5.4), using a non-trivial derivation of 11.2/4, followed by (5.1).
    // If the derivation of 11.2/4 is trivial (only uses (4.1) and (4.4)), this
    // case can be replaced with purely (5.1) and thus does not need to be in
    // this predicate.
    exists(Class between | this.thisCanAccessClassTrans(between, derived) |
      everyoneCouldAccessMember(memberClass, memberAccess, between)
    )
    or
    // Rule (5.4) followed by Rule (5.2)
    exists(Class between | this.(AccessHolder).canAccessClass(between, derived) |
      between.accessOfBaseMember(memberClass, memberAccess).hasName("private") and
      this.isFriendOfOrEqualTo(between)
    )
    or
    // Rule (5.4) followed by Rule (5.3), integrating 11.4. We integrate 11.4
    // here because we would otherwise generate too many tuples. This code is
    // very performance-sensitive, and any changes should be benchmarked on
    // LibreOffice.
    // Rule (5.4) requires that `this.canAccessClass(between, derived)`
    // (implying that `derived <= between` in the class hierarchy) and that
    // `p <= between`. Rule 11.4 additionally requires `derived <= p`, but
    // all these rules together result in too much freedom and overlap between
    // cases. Therefore, for performance, we split into three cases for how
    // `between` as a base of `derived` is accessible at `this`, where `this`
    // is the implementation of `p`:
    // 1. `between` is an accessible base of `derived` by going through `p` as
    //    an intermediate step.
    // 2. `this` is part of the implementation of `derived` because it's a
    //    member or a friend. In this case, we do not need `p` to perform this
    //    derivation, so we can set `p = derived` and proceed as in case 1.
    // 3. `derived` has an alternative inheritance path up to `between` that
    //    bypasses `p`. Then that path must be public, or we are in case 2.
    exists(AccessSpecifier public | public.hasName("public") |
      exists(Class between, Class p |
        between
            .accessOfBaseMember(pragma[only_bind_into](memberClass), memberAccess)
            .hasName("protected") and
        this.isFriendOfOrEqualTo(p) and
        (
          // This is case 1 from above. If `p` derives privately from `between`
          // then the member we're trying to access is private or inaccessible
          // in `derived`, so either rule (5.2) applies instead, or the member
          // is inaccessible. Therefore, in this case, `p` must derive at least
          // protected from `between`. Further, since the access of `derived`
          // to its base `between` must pass through `p` in this case, we know
          // that `derived` must derived publicly from `p` unless we are in
          // case 2; there are no other cases of 11.2/4 where the
          // implementation of a base class can access itself as a base.
          p.accessOfBaseMember(between, public).getName() >= "protected" and
          derived.accessOfBaseMember(p, public) = public
          or
          // This is case 3 above.
          derived.accessOfBaseMember(between, public) = public and
          derived = p.getADerivedClass*() and
          exists(p.accessOfBaseMember(between, memberAccess))
        )
      )
    )
  }

  private predicate isFriendOfOrEqualTo(Class c) {
    exists(FriendDecl fd | fd.getDeclaringClass() = c | this = fd.getFriend())
    or
    this = c
  }
}

/**
 * Holds if `base` is a direct public base of `derived`, possibly virtual and
 * possibly through typedefs. The transitive closure of this predicate encodes
 * derivations of N4140 11.2/4 that use only (4.1) and (4.4).
 */
private predicate isDirectPublicBaseOf(Class base, Class derived) {
  exists(ClassDerivation cd |
    cd.getBaseClass() = base and
    cd.getDerivedClass() = derived and
    cd.getASpecifier().hasName("public")
  )
}

/**
 * Holds if a hypothetical member of `memberClass` with access specifier
 * `memberAccess` would be public when named as a member of `derived`.
 * This encodes N4140 11.2/5 case (5.1).
 */
private predicate everyoneCouldAccessMember(
  Class memberClass, AccessSpecifier memberAccess, Class derived
) {
  derived.accessOfBaseMember(memberClass, memberAccess).hasName("public")
}
