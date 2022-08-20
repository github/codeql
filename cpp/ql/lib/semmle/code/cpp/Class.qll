/**
 * Provides classes representing C++ classes, including structs, unions, and template classes.
 */

import semmle.code.cpp.Type
import semmle.code.cpp.UserType
import semmle.code.cpp.metrics.MetricClass
import semmle.code.cpp.Linkage
private import semmle.code.cpp.internal.ResolveClass

/**
 * A class type [N4140 9].
 *
 * While this does include types declared with the `class` keyword, it also
 * includes types declared with the `struct` and `union` keywords.  For example,
 * the types `MyClass`, `MyStruct` and `MyUnion` in:
 * ```
 * class MyClass {
 * public:
 *   MyClass();
 * };
 *
 * struct MyStruct {
 *   int x, y, z;
 * };
 *
 * union MyUnion {
 *   int i;
 *   float f;
 * };
 * ```
 */
class Class extends UserType {
  Class() { isClass(underlyingElement(this)) }

  override string getAPrimaryQlClass() { result = "Class" }

  /** Gets a child declaration of this class, struct or union. */
  override Declaration getADeclaration() { result = this.getAMember() }

  /** Gets a type declared in this class, struct or union. */
  UserType getANestedType() { result = this.getAMember() }

  /**
   * Gets a function declared in this class, struct or union.
   * For template member functions, results include both the template
   * and the instantiations of that template. If you only want the
   * template, then use `getACanonicalMemberFunction()` instead.
   */
  MemberFunction getAMemberFunction() { result = this.getAMember() }

  /**
   * Gets a function declared in this class, struct or union.
   * For template member functions, results include only the template.
   * If you also want instantiations of the template, then use
   * `getAMemberFunction()` instead.
   */
  MemberFunction getACanonicalMemberFunction() { result = this.getACanonicalMember() }

  /**
   * Gets a member variable declared in this class, struct or union.
   * For template member variables, results include both the template
   * and the instantiations of that template. If you only want the
   * template, then use `getACanonicalMemberVariable()` instead.
   */
  MemberVariable getAMemberVariable() { result = this.getAMember() }

  /**
   * Gets a member variable declared in this class, struct or union.
   * For template member variables, results include only the template.
   * If you also want instantiations of the template, then use
   * `getAMemberVariable()` instead.
   */
  MemberVariable getACanonicalMemberVariable() { result = this.getAMember() }

  /**
   * Gets a member declared in this class, struct or union.
   * For template members, this may be either the template or an instantiation
   * of that template. If you only want the template, see
   * `getACanonicalMember()`.
   */
  Declaration getAMember() { result = this.getAMember(_) }

  /**
   * Gets a member declared in this class, struct or union.
   * If you also want template instantiations of results, see
   * `getAMember()`.
   */
  Declaration getACanonicalMember() { result = this.getCanonicalMember(_) }

  /**
   * Gets the (zero-based) `index`th member declared in this class, struct
   * or union.
   * If you also want template instantiations of results, see
   * `getAMember(int)`.
   */
  Declaration getCanonicalMember(int index) {
    member(underlyingElement(this), index, unresolveElement(result))
  }

  /**
   * Gets the (zero-based) `index`th canonical member declared in this
   * class, struct or union. If that member is a template, all instantiations
   * of that template. If you only want the canonical member, see
   * `getCanonicalMember(int)`.
   */
  Declaration getAMember(int index) {
    result = this.getCanonicalMember(index) or
    result = this.getCanonicalMember(index).(TemplateClass).getAnInstantiation() or
    result = this.getCanonicalMember(index).(TemplateFunction).getAnInstantiation() or
    result = this.getCanonicalMember(index).(TemplateVariable).getAnInstantiation()
  }

  /**
   * Gets a private member declared in this class, struct or union.
   * For template members, this may be either the template or an
   * instantiation of that template. For just the template, use
   * `getAPrivateCanonicalMember()`.
   */
  Declaration getAPrivateMember() { result = this.getAMember() and result.hasSpecifier("private") }

  /**
   * Gets a private canonical member declared in this class, struct or union.
   * If you also want template instantiations of results, see
   * `getAPrivateMember()`.
   */
  Declaration getAPrivateCanonicalMember() {
    result = this.getACanonicalMember() and result.hasSpecifier("private")
  }

  /**
   * Gets a protected member declared in this class, struct or union.
   * For template members, this may be either the template or an
   * instantiation of that template. For just the template, use
   * `getAProtectedCanonicalMember()`.
   */
  Declaration getAProtectedMember() {
    result = this.getAMember() and result.hasSpecifier("protected")
  }

  /**
   * Gets a protected canonical member declared in this class, struct or union.
   * If you also want template instantiations of results, see
   * `getAProtectedMember()`.
   */
  Declaration getAProtectedCanonicalMember() {
    result = this.getACanonicalMember() and result.hasSpecifier("protected")
  }

  /**
   * Gets a public member declared in this class, struct or union.
   * For template members, this may be either the template or an
   * instantiation of that template. For just the template, use
   * `getAPublicCanonicalMember()`.
   */
  Declaration getAPublicMember() { result = this.getAMember() and result.hasSpecifier("public") }

  /**
   * Gets a public canonical member declared in this class, struct or union.
   * If you also want template instantiations of results, see
   * `getAPublicMember()`.
   */
  Declaration getAPublicCanonicalMember() {
    result = this.getACanonicalMember() and result.hasSpecifier("public")
  }

  /** Gets a static member declared in this class, struct or union. */
  Declaration getAStaticMember() { result = this.getAMember() and result.isStatic() }

  /** Gets a field of this class, struct or union. */
  Field getAField() { result = this.getAMemberVariable() }

  /** Gets a constructor of this class, struct or union. */
  Constructor getAConstructor() { result = this.getAMemberFunction() }

  /** Holds if this class, struct or union has a constructor. */
  predicate hasConstructor() { exists(this.getAConstructor()) }

  /**
   * Holds if this class has a copy constructor that is either explicitly
   * declared (though possibly `= delete`) or is auto-generated, non-trivial
   * and called from somewhere.
   *
   * DEPRECATED: There is more than one reasonable definition of what it means
   * to have a copy constructor, and we do not want to promote one particular
   * definition by naming it with this predicate. Having a copy constructor
   * could mean that such a member is declared or defined in the source or that
   * it is callable by a particular caller. For C++11, there's also a question
   * of whether to include members that are defaulted or deleted.
   */
  deprecated predicate hasCopyConstructor() { this.getAMemberFunction() instanceof CopyConstructor }

  /**
   * Like accessOfBaseMember but returns multiple results if there are multiple
   * paths to `base` through the inheritance graph.
   */
  private AccessSpecifier accessOfBaseMemberMulti(Class base, AccessSpecifier fieldInBase) {
    this = base and result = fieldInBase
    or
    exists(ClassDerivation cd | cd.getBaseClass() = base |
      result =
        this.accessOfBaseMemberMulti(cd.getDerivedClass(),
          fieldInBase.accessInDirectDerived(cd.getASpecifier()))
    )
  }

  /**
   * Gets the access specifier, if any, that a hypothetical member of `base`
   * would have when viewed as a member of `this`, given that this member had
   * access specifier `fieldInBase`. Encodes the rules of C++14 11.2/1 and
   * 11.6/1, except that this predicate includes the case of `base` = `this`.
   */
  AccessSpecifier accessOfBaseMember(Class base, AccessSpecifier fieldInBase) {
    // If there are multiple paths through the inheritance graph, we take the
    // most permissive one (C++14 11.6/1). This implementation relies on the
    // alphabetical order of "private", "protected", "public".
    result.hasName(max(this.accessOfBaseMemberMulti(base, fieldInBase).getName()))
  }

  /**
   * Gets the access specifier, if any, that `member` has when viewed as a
   * member of `this`, where `member` may come from a base class of `this`.
   * Encodes the rules of C++14 11.2/1 and 11.6/1, except that this predicate
   * includes the case of `base` = `this`.
   */
  AccessSpecifier accessOfBaseMember(Declaration member) {
    result = this.accessOfBaseMember(member.getDeclaringType(), member.getASpecifier())
  }

  /**
   * DEPRECATED: name changed to `hasImplicitCopyConstructor` to reflect that
   * `= default` members are no longer included.
   */
  deprecated predicate hasGeneratedCopyConstructor() { this.hasImplicitCopyConstructor() }

  /**
   * DEPRECATED: name changed to `hasImplicitCopyAssignmentOperator` to
   * reflect that `= default` members are no longer included.
   */
  deprecated predicate hasGeneratedCopyAssignmentOperator() { this.hasImplicitCopyConstructor() }

  /**
   * Holds if this class, struct or union has an implicitly-declared copy
   * constructor that is not _deleted_. This predicate is more accurate than
   * checking if this class, struct or union has a `CopyConstructor cc` where
   * `cc.isCompilerGenerated()` since such a `CopyConstructor` may not exist
   * in the database if (1) it is never called or (2) it is _trivial_, meaning
   * that it is equivalent to `memcpy`.
   */
  predicate hasImplicitCopyConstructor() {
    not this.implicitCopyConstructorDeleted() and
    forall(CopyConstructor cc | cc = this.getAMemberFunction() |
      cc.isCompilerGenerated() and not cc.isDeleted()
    ) and
    (
      not this instanceof ClassTemplateInstantiation
      or
      this.(ClassTemplateInstantiation).getTemplate().hasImplicitCopyConstructor()
    ) and
    (
      not this instanceof PartialClassTemplateSpecialization
      or
      this.(PartialClassTemplateSpecialization).getPrimaryTemplate().hasImplicitCopyConstructor()
    )
  }

  /**
   * Holds if this class, struct or union has an implicitly-declared copy
   * assignment operator that is not _deleted_. This predicate is more
   * accurate than checking if this class, struct or union has a
   * `CopyAssignmentOperator ca` where `ca.isCompilerGenerated()` since such a
   * `CopyAssignmentOperator` may not exist in the database if (1) it is never
   * called or (2) it is _trivial_, meaning that it is equivalent to `memcpy`.
   */
  predicate hasImplicitCopyAssignmentOperator() {
    not this.implicitCopyAssignmentOperatorDeleted() and
    forall(CopyAssignmentOperator ca | ca = this.getAMemberFunction() |
      ca.isCompilerGenerated() and not ca.isDeleted()
    ) and
    (
      not this instanceof ClassTemplateInstantiation
      or
      this.(ClassTemplateInstantiation).getTemplate().hasImplicitCopyAssignmentOperator()
    ) and
    (
      not this instanceof PartialClassTemplateSpecialization
      or
      this.(PartialClassTemplateSpecialization)
          .getPrimaryTemplate()
          .hasImplicitCopyAssignmentOperator()
    )
  }

  /**
   * Holds if the compiler would be unable to generate a copy constructor for
   * this class, struct or union. This predicate implements the rules listed
   * here:
   * http://en.cppreference.com/w/cpp/language/copy_constructor#Deleted_implicitly-declared_copy_constructor
   */
  predicate implicitCopyConstructorDeleted() {
    // - T has non-static data members that cannot be copied (have deleted,
    //   inaccessible, or ambiguous copy constructors);
    exists(Type t | t = this.getAFieldSubobjectType().getUnspecifiedType() |
      // Note: Overload resolution is not implemented -- all copy
      // constructors are considered equal.
      this.cannotAccessCopyConstructorOnAny(t)
    )
    or
    // - T has direct or virtual base class that cannot be copied (has deleted,
    //   inaccessible, or ambiguous copy constructors);
    exists(Class c | c = this.getADirectOrVirtualBase() |
      // Note: Overload resolution is not implemented -- all copy
      // constructors are considered equal.
      this.cannotAccessCopyConstructorOnThis(c)
    )
    or
    // - T has direct or virtual base class with a deleted or inaccessible
    //   destructor;
    exists(Class base | base = this.getADirectOrVirtualBase() |
      this.cannotAccessDestructor(base, this)
    )
    or
    // - T has a user-defined move constructor or move assignment operator;
    exists(MoveConstructor mc | mc = this.getAMemberFunction() | not mc.isCompilerGenerated())
    or
    exists(MoveAssignmentOperator ma | ma = this.getAMemberFunction() |
      not ma.isCompilerGenerated()
    )
    or
    // - T is a union and has a variant member with non-trivial copy
    //   constructor (since C++11)
    none() // Not implemented
    or
    // - T has a data member of rvalue reference type.
    exists(Type t | t = this.getAFieldSubobjectType() | t instanceof RValueReferenceType)
  }

  /**
   * Holds if the compiler would be unable to generate a copy assignment
   * operator for this class, struct or union. This predicate implements the
   * rules listed here:
   * http://en.cppreference.com/w/cpp/language/copy_assignment#Deleted_implicitly-declared_copy_assignment_operator
   */
  predicate implicitCopyAssignmentOperatorDeleted() {
    // - T has a user-declared move constructor;
    exists(MoveConstructor mc | mc = this.getAMemberFunction() | not mc.isCompilerGenerated())
    or
    // - T has a user-declared move assignment operator.
    exists(MoveAssignmentOperator ma | ma = this.getAMemberFunction() |
      not ma.isCompilerGenerated()
    )
    or
    // - T has a non-static data member of non-class type (or array thereof)
    //   that is const;
    exists(Type t | t = this.getAFieldSubobjectType() |
      // The rule for this case refers only to non-class types only, but our
      // implementation extends it to cover class types too. Class types are
      // supposed to be covered by the rule below on data members that
      // cannot be copy-assigned. Copy-assigning a const class-typed member
      // would call an overload of type
      // `const C& operator=(const C&) const;`. Such an overload is unlikely
      // to exist because it contradicts the intention of "const": it allows
      // assigning to a const object. But since we have not implemented the
      // ability to distinguish between overloads, we cannot distinguish that
      // overload from the ordinary `C& operator=(const C&);`. Instead, we
      // require class types to be non-const in this clause.
      /* not t instanceof Class and */ t.isConst()
    )
    or
    // - T has a non-static data member of a reference type;
    exists(Type t | t = this.getAFieldSubobjectType() | t instanceof ReferenceType)
    or
    // - T has a non-static data member or a direct or virtual base class that
    //   cannot be copy-assigned (overload resolution for the copy assignment
    //   fails, or selects a deleted or inaccessible function);
    exists(Type t | t = this.getAFieldSubobjectType().getUnspecifiedType() |
      // Note: Overload resolution is not implemented -- all copy assignment
      // operators are considered equal.
      this.cannotAccessCopyAssignmentOperatorOnAny(t)
    )
    or
    exists(Class c | c = this.getADirectOrVirtualBase() |
      // Note: Overload resolution is not implemented -- all copy assignment
      // operators are considered equal.
      this.cannotAccessCopyAssignmentOperatorOnThis(c)
    )
    // - T is a union-like class, and has a variant member whose corresponding
    //   assignment operator is non-trivial.
    // Not implemented
  }

  /** Gets the destructor of this class, struct or union, if any. */
  Destructor getDestructor() { result = this.getAMemberFunction() }

  /** Holds if this class, struct or union has a destructor. */
  predicate hasDestructor() { exists(this.getDestructor()) }

  /**
   * Holds if this class, struct or union is a POD (Plain Old Data) class
   * [N4140 9(10)].
   *
   * The definition of POD changed between C++03 and C++11, so whether
   * a class is POD can depend on which version of the language it was
   * compiled for. For this reason, the `is_pod_class` predicate is
   * generated by the extractor.
   */
  predicate isPOD() { is_pod_class(underlyingElement(this)) }

  /**
   * Holds if this class, struct or union is a standard-layout class
   * [N4140 9(7)]. Also holds for structs in C programs.
   */
  predicate isStandardLayout() { is_standard_layout_class(underlyingElement(this)) }

  /**
   * Holds if this class/struct is abstract, in other words whether
   * it declares one or more pure virtual member functions.
   */
  predicate isAbstract() { this.getAMemberFunction() instanceof PureVirtualFunction }

  /** Gets a direct base class/struct of this class/struct [N4140 10]. */
  Class getABaseClass() { this.getADerivation().getBaseClass() = result }

  /** Gets a class/struct that is directly derived from this class/struct [N4140 10]. */
  Class getADerivedClass() { result.getABaseClass() = this }

  /** Holds if this class/struct derives directly from that. */
  predicate derivesFrom(Class that) { this.getABaseClass() = that }

  override predicate refersToDirectly(Type t) {
    t = this.getATemplateArgument() or
    this.isConstructedFrom(t)
  }

  /**
   * Gets a class derivation of this class/struct, for example the
   * `public B` in the following code:
   * ```
   * class D : public B {
   *   ...
   * };
   * ```
   */
  ClassDerivation getADerivation() {
    exists(ClassDerivation d | d.getDerivedClass() = this and d = result)
  }

  /**
   * Gets class derivation number `index` of this class/struct, for example the
   * `public B` is derivation 1 in the following code:
   * ```
   * class D : public A, public B, public C {
   *   ...
   * };
   * ```
   */
  ClassDerivation getDerivation(int index) {
    exists(ClassDerivation d | d.getDerivedClass() = this and d.getIndex() = index and d = result)
  }

  /**
   * Gets the byte offset within `this` of each base class subobject of type
   * `baseClass`, or zero if `baseClass` and `this` are the same type. Both
   * direct and indirect base classes are included.
   * Does not hold for base class subobjects for virtual base classes, nor does
   * it hold for further base class subobjects of virtual base classes.
   */
  private int getANonVirtualBaseClassByteOffset(Class baseClass) {
    baseClass = this and result = 0 // `baseClass` is the most-derived type
    or
    exists(ClassDerivation cd |
      // Add the offset of the direct base class and the offset of `baseClass`
      // within that direct base class.
      cd = this.getADerivation() and
      result = cd.getBaseClass().getANonVirtualBaseClassByteOffset(baseClass) + cd.getByteOffset()
    )
  }

  /**
   * Gets the byte offset within `this` of each base class subobject of type
   * `baseClass`, or zero if `baseClass` and `this` are the same type. Both
   * direct and indirect base classes are included.
   * Note that for virtual base classes, and non-virtual base classes thereof,
   * this predicate assumes that `this` is the type of the complete most-derived
   * object.
   */
  int getABaseClassByteOffset(Class baseClass) {
    // Handle the non-virtual case.
    result = this.getANonVirtualBaseClassByteOffset(baseClass)
    or
    exists(Class virtualBaseClass, int virtualBaseOffset, int offsetFromVirtualBase |
      // Look for the base class as a non-virtual base of a direct or indirect
      // virtual base, adding the two offsets.
      this.getVirtualBaseClassByteOffset(virtualBaseClass) = virtualBaseOffset and
      offsetFromVirtualBase = virtualBaseClass.getANonVirtualBaseClassByteOffset(baseClass) and
      result = virtualBaseOffset + offsetFromVirtualBase
    )
  }

  /**
   * Holds if this class/struct has a virtual class derivation, for
   * example the `virtual public B` in the following code:
   * ```
   * class D : virtual public B {
   *   ...
   * };
   * ```
   */
  predicate hasVirtualBaseClass(Class base) {
    exists(ClassDerivation cd |
      this.getADerivation() = cd and
      cd.getBaseClass() = base and
      cd.hasSpecifier("virtual")
    )
  }

  /**
   * Gets the byte offset of virtual base class subobject `base` within a
   * most-derived object of class `this`. The virtual base can be a direct or
   * indirect virtual base of `this`. Does not hold if `this` is an
   * uninstantiated template.
   * See `ClassDerivation.getByteOffset` for offsets of non-virtual base
   * classes.
   */
  int getVirtualBaseClassByteOffset(Class base) {
    virtual_base_offsets(underlyingElement(this), unresolveElement(base), result)
  }

  /**
   * Holds if this class/struct has a private class derivation, for
   * example the `private B` in the following code:
   * ```
   * class D : private B {
   *   ...
   * };
   * ```
   */
  predicate hasPrivateBaseClass(Class base) {
    exists(ClassDerivation cd |
      this.getADerivation() = cd and
      cd.getBaseClass() = base and
      cd.hasSpecifier("private")
    )
  }

  /**
   * Holds if this class/struct has a public class derivation, for
   * example the `public B` in the following code:
   * ```
   * class D : public B {
   *   ...
   * };
   * ```
   */
  predicate hasPublicBaseClass(Class base) {
    exists(ClassDerivation cd |
      this.getADerivation() = cd and
      cd.getBaseClass() = base and
      cd.hasSpecifier("public")
    )
  }

  /**
   * Holds if this class/struct has a protected class derivation, for
   * example the `protected B` in the following code:
   * ```
   * class D : protected B {
   *   ...
   * };
   * ```
   */
  predicate hasProtectedBaseClass(Class base) {
    exists(ClassDerivation cd |
      this.getADerivation() = cd and
      cd.getBaseClass() = base and
      cd.hasSpecifier("protected")
    )
  }

  /** Gets the metric class associated with this class, struct or union. */
  MetricClass getMetrics() { result = this }

  /** Gets a friend declaration in this class, struct or union. */
  FriendDecl getAFriendDecl() { result.getDeclaringClass() = this }

  override string explain() { result = "class " + this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts

  /**
   * Gets the alignment of this type in bytes (on the machine where facts were
   * extracted).
   */
  override int getAlignment() { usertypesize(underlyingElement(this), _, result) }

  /**
   * Holds if this class, struct or union is constructed from another class as
   * a result of template instantiation. It originates either from a class
   * template or from a class nested in a class template.
   */
  predicate isConstructedFrom(Class c) {
    class_instantiation(underlyingElement(this), unresolveElement(c))
  }

  /**
   * Holds if this class/struct is polymorphic (has a virtual function, or
   * inherits one).
   */
  predicate isPolymorphic() {
    exists(MemberFunction f | f.getDeclaringType() = this.getABaseClass*() and f.isVirtual())
  }

  override predicate involvesTemplateParameter() {
    this.getATemplateArgument().(Type).involvesTemplateParameter()
  }

  /** Holds if this class, struct or union was declared 'final'. */
  predicate isFinal() { usertype_final(underlyingElement(this)) }

  /** Gets a link target which references this class, struct or union. */
  LinkTarget getALinkTarget() { this = result.getAClass() }

  /**
   * Gets the UUID that associated with this class, struct or union via the
   * `__declspec(uuid)` attribute.
   *
   * Regardless of the format of the UUID string in source code, the returned
   * value is normalized to the standard "registry format", without braces, and
   * using lowercase letters (e.g. "01234567-89ab-cdef-0123-456789abcdef").
   */
  string getUuid() { usertype_uuid(underlyingElement(this), result) }

  private Type getAFieldSubobjectType() {
    result = stripArrayTypes(this.getAField().getUnderlyingType())
  }

  private Class getADirectOrVirtualBase() {
    // `result` is a direct base of `this`
    result.getADerivedClass() = this
    or
    // `result` is an indirect virtual base of `this`. The case where `result`
    // is a direct virtual base of `this` is included in the above clause, and
    // therefore we can use "+"-closure instead of "*"-closure here.
    result.(VirtualBaseClass).getAVirtuallyDerivedClass().getADerivedClass+() = this
  }

  /**
   * Holds if `this` can NOT access the destructor of class `c` on an object of
   * type `objectClass`. Note: this implementation is incomplete but will be
   * correct in most cases; it errs on the side of claiming that the destructor
   * is accessible.
   */
  pragma[inline]
  private predicate cannotAccessDestructor(Class c, Class objectClass) {
    // The destructor in our db, if any, is accessible. If there is no
    // destructor in our db, it usually means that there is a default
    // public one.
    exists(Destructor d | d = c.getAMemberFunction() | not this.canAccessMember(d, objectClass))
    // The extractor doesn't seem to support the case of a deleted destructor,
    // so we ignore that. It is very much a corner case.
    // To implement this properly, there should be a predicate about whether
    // the implicit destructor is deleted, similar to
    // `implicitCopyConstructorDeleted`. See
    // http://en.cppreference.com/w/cpp/language/destructor#Deleted_implicitly-declared_destructor
  }

  private predicate cannotAccessCopyConstructorOnThis(Class c) {
    this.cannotAccessCopyConstructor(c, this)
  }

  private predicate cannotAccessCopyConstructorOnAny(Class c) {
    this.cannotAccessCopyConstructor(c, c)
  }

  /**
   * Holds if `this` can NOT access the copy constructor of class `c` in order
   * to construct an object of class `objectClass`. In practice, set
   * `objectClass` to `this` when access-checking a base subobject
   * initialization (like `class D : C { D(D& that) : C(that) { ... } }`). Set
   * `objectClass` to `c` for any other purpose (like `C y = x;`).
   */
  pragma[inline]
  private predicate cannotAccessCopyConstructor(Class c, Class objectClass) {
    // Pseudocode:
    //   if c has CopyConstructor cc
    //   then this.cannotAccess(cc)
    //   else this.implicitCopyConstructorDeleted()
    exists(CopyConstructor cc | cc = c.getAMemberFunction() |
      not this.canAccessMember(cc, objectClass)
    )
    or
    not exists(CopyConstructor cc | cc = c.getAMemberFunction() and not cc.isDeleted()) and
    c.implicitCopyConstructorDeleted() // mutual recursion here
    // no access check in this case since the implicit member is always
    // public.
  }

  private predicate cannotAccessCopyAssignmentOperatorOnThis(Class c) {
    this.cannotAccessCopyAssignmentOperator(c, this)
  }

  private predicate cannotAccessCopyAssignmentOperatorOnAny(Class c) {
    this.cannotAccessCopyAssignmentOperator(c, c)
  }

  /**
   * Holds if `this` can NOT access the copy assignment operator of class `c` on
   * an object of type `objectClass`, where `objectClass` is derived from or
   * equal to `c`. That is, whether the call `x.C::operator=(...)` is forbidden
   * when the type of `x` is `objectClass`, and `c` has the name `C`.
   */
  pragma[inline]
  private predicate cannotAccessCopyAssignmentOperator(Class c, Class objectClass) {
    // Pseudocode:
    //   if c has CopyAssignmentOperator ca
    //   then this.cannotAccess(ca)
    //   else this.implicitCopyAssignmentOperatorDeleted()
    exists(CopyAssignmentOperator ca | ca = c.getAMemberFunction() |
      not this.canAccessMember(ca, objectClass)
    )
    or
    not exists(CopyAssignmentOperator ca | ca = c.getAMemberFunction() and not ca.isDeleted()) and
    c.implicitCopyAssignmentOperatorDeleted() // mutual recursion here
    // no access check in this case since the implicit member is always
    // public.
  }
}

/**
 * A class derivation, for example the `public B` in the following code:
 * ```
 * class D : public B {
 *   ...
 * };
 * ```
 */
class ClassDerivation extends Locatable, @derivation {
  /**
   * Gets the class/struct from which we are actually deriving, resolving a
   * typedef if necessary.  For example, the base class in the following code
   * would be `B`:
   * ```
   * struct B {
   * };
   *
   * typedef B T;
   *
   * struct D : T {
   * };
   * ```
   */
  Class getBaseClass() { result = this.getBaseType().getUnderlyingType() }

  override string getAPrimaryQlClass() { result = "ClassDerivation" }

  /**
   * Gets the type from which we are deriving, without resolving any
   * typedef. For example, the base type in the following code would be `T`:
   * ```
   * struct B {
   * };
   *
   * typedef B T;
   *
   * struct D : T {
   * };
   * ```
   */
  Type getBaseType() { derivations(underlyingElement(this), _, _, unresolveElement(result), _) }

  /**
   * Gets the class/struct that is doing the deriving. For example, the derived
   * class in the following code would be `D`:
   * ```
   * struct B {
   * };
   *
   * struct D : B {
   * };
   * ```
   */
  Class getDerivedClass() {
    derivations(underlyingElement(this), unresolveElement(result), _, _, _)
  }

  /**
   * Gets the index of the derivation in the derivation list for the
   * derived class/struct (indexed from 0).  For example, the index of the
   * derivation of `B2` in the following code would be `1`:
   * ```
   * struct D : B1, B2 {
   *   ...
   * };
   * ```
   */
  int getIndex() { derivations(underlyingElement(this), _, result, _, _) }

  /** Gets a specifier (for example `public`) applied to the derivation. */
  Specifier getASpecifier() { derspecifiers(underlyingElement(this), unresolveElement(result)) }

  /** Holds if the derivation has specifier `s`. */
  predicate hasSpecifier(string s) { this.getASpecifier().hasName(s) }

  /** Holds if the derivation is for a virtual base class. */
  predicate isVirtual() { this.hasSpecifier("virtual") }

  /** Gets the location of the derivation. */
  override Location getLocation() { derivations(underlyingElement(this), _, _, _, result) }

  /**
   * Gets the byte offset of the base class subobject relative to the start of
   * the derived class object. Only holds for non-virtual bases, since the
   * offset of a virtual base class is not a constant. Does not hold if the
   * derived class is an uninstantiated template.
   * See `Class.getVirtualBaseClassByteOffset` for offsets of virtual base
   * classes.
   */
  int getByteOffset() { direct_base_offsets(underlyingElement(this), result) }

  override string toString() { result = "derivation" }
}

/**
 * A class, struct or union that is directly enclosed by a function.  For example
 * the `struct` in the following code is a `LocalClass`:
 * ```
 * void myFunction() {
 *   struct { int x; int y; } vec = { 1, 2 };
 * };
 * ```
 */
class LocalClass extends Class {
  LocalClass() { this.isLocal() }

  override string getAPrimaryQlClass() { not this instanceof LocalStruct and result = "LocalClass" }

  override Function getEnclosingAccessHolder() { result = this.getEnclosingFunction() }
}

/**
 * A class, struct or union that is declared within another class.  For example
 * the struct `PairT` in the following code is a nested class:
 * ```
 * template<class T>
 * class MyTemplateClass {
 * public:
 *   struct PairT {
 *     T first, second;
 *   };
 * };
 * ```
 */
class NestedClass extends Class {
  NestedClass() { this.isMember() }

  override string getAPrimaryQlClass() {
    not this instanceof NestedStruct and result = "NestedClass"
  }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is public. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }
}

/**
 * An "abstract class", in other words a class/struct that contains at least one
 * pure virtual function.
 */
class AbstractClass extends Class {
  AbstractClass() { this.getAMemberFunction() instanceof PureVirtualFunction }

  override string getAPrimaryQlClass() { result = "AbstractClass" }
}

/**
 * A class template (this class also finds partial specializations
 * of class templates).  For example in the following code there is a
 * `MyTemplateClass<T>` template:
 * ```
 * template<class T>
 * class MyTemplateClass {
 *   ...
 * };
 * ```
 * Note that this does not include template instantiations, and full
 * specializations.  See `ClassTemplateInstantiation` and
 * `FullClassTemplateSpecialization`.
 */
class TemplateClass extends Class {
  TemplateClass() { usertypes(underlyingElement(this), _, 6) }

  /**
   * Gets a class instantiated from this template.
   *
   * For example for `MyTemplateClass<T>` in the following code, the results are
   * `MyTemplateClass<int>` and `MyTemplateClass<long>`:
   * ```
   * template<class T>
   * class MyTemplateClass {
   *   ...
   * };
   *
   * MyTemplateClass<int> instance;
   *
   * MyTemplateClass<long> instance;
   * ```
   */
  Class getAnInstantiation() {
    result.isConstructedFrom(this) and
    exists(result.getATemplateArgument())
  }

  override string getAPrimaryQlClass() { result = "TemplateClass" }
}

/**
 * A class that is an instantiation of a template.  For example in the following
 * code there is a `MyTemplateClass<int>` instantiation:
 * ```
 * template<class T>
 * class MyTemplateClass {
 *   ...
 * };
 *
 * MyTemplateClass<int> instance;
 * ```
 * For the `MyTemplateClass` template itself, see `TemplateClass`.
 */
class ClassTemplateInstantiation extends Class {
  TemplateClass tc;

  ClassTemplateInstantiation() { tc.getAnInstantiation() = this }

  override string getAPrimaryQlClass() { result = "ClassTemplateInstantiation" }

  /**
   * Gets the class template from which this instantiation was instantiated.
   *
   * For example for `MyTemplateClass<int>` in the following code, the result is
   * `MyTemplateClass<T>`:
   * ```
   * template<class T>
   * class MyTemplateClass {
   *   ...
   * };
   *
   * MyTemplateClass<int> instance;
   * ```
   */
  TemplateClass getTemplate() { result = tc }
}

/**
 * A specialization of a class template (this may be a full or partial template
 * specialization - see `FullClassTemplateSpecialization` and
 * `PartialClassTemplateSpecialization`).
 */
class ClassTemplateSpecialization extends Class {
  ClassTemplateSpecialization() {
    isFullClassTemplateSpecialization(this) or
    isPartialClassTemplateSpecialization(this)
  }

  /**
   * Gets the primary template for the specialization, for example on
   * `S<T,int>`, the result is `S<T,U>`.
   */
  TemplateClass getPrimaryTemplate() {
    // Ignoring template arguments, the primary template has the same name
    // as each of its specializations.
    result.getSimpleName() = this.getSimpleName() and
    // It is in the same namespace as its specializations.
    result.getNamespace() = this.getNamespace() and
    // It is distinguished by the fact that each of its template arguments
    // is a distinct template parameter.
    count(TemplateParameter tp | tp = result.getATemplateArgument()) =
      count(int i | exists(result.getTemplateArgument(i)))
  }

  override string getAPrimaryQlClass() { result = "ClassTemplateSpecialization" }
}

private predicate isFullClassTemplateSpecialization(Class c) {
  // This class has template arguments, but none of them involves a template parameter.
  exists(c.getATemplateArgument()) and
  not exists(Type ta | ta = c.getATemplateArgument() and ta.involvesTemplateParameter()) and
  // This class does not have any instantiations.
  not exists(c.(TemplateClass).getAnInstantiation()) and
  // This class is not an instantiation of a class template.
  not c instanceof ClassTemplateInstantiation
}

/**
 * A full specialization of a class template.  For example `MyTemplateClass<int>`
 * in the following code is a `FullClassTemplateSpecialization`:
 * ```
 * template<class T>
 * class MyTemplateClass {
 *   ...
 * };
 *
 * template<>
 * class MyTemplateClass<int> {
 *   ...
 * };
 * ```
 */
class FullClassTemplateSpecialization extends ClassTemplateSpecialization {
  FullClassTemplateSpecialization() { isFullClassTemplateSpecialization(this) }

  override string getAPrimaryQlClass() { result = "FullClassTemplateSpecialization" }
}

private predicate isPartialClassTemplateSpecialization(Class c) {
  /*
   * (a) At least one of this class's template arguments involves a
   *     template parameter in some respect, for example T, T*, etc.
   *
   * (b) It is not the case that the n template arguments of this class
   *     are a set of n distinct template parameters.
   *
   * template <typename T,U> class X {};      // class template
   * template <typename T> class X<T,T> {};   // partial class template specialization
   * template <typename T> class X<T,int> {}; // partial class template specialization
   * template <typename T> class Y {};        // class template
   * template <typename T> class Y<T*> {};    // partial class template specialization
   */

  exists(Type ta | ta = c.getATemplateArgument() and ta.involvesTemplateParameter()) and
  count(TemplateParameter tp | tp = c.getATemplateArgument()) !=
    count(int i | exists(c.getTemplateArgument(i)))
}

/**
 * A partial specialization of a class template.  For example `MyTemplateClass<int, T>`
 * in the following code is a `PartialClassTemplateSpecialization`:
 * ```
 * template<class S, class T>
 * class MyTemplateClass {
 *   ...
 * };
 *
 * template<class T>
 * class MyTemplateClass<int, T> {
 *   ...
 * };
 * ```
 */
class PartialClassTemplateSpecialization extends ClassTemplateSpecialization {
  PartialClassTemplateSpecialization() { isPartialClassTemplateSpecialization(this) }

  override string getAPrimaryQlClass() { result = "PartialClassTemplateSpecialization" }
}

/**
 * A class/struct derivation that is virtual.  For example the derivation in
 * the following code is a `VirtualClassDerivation`:
 * ```
 * class MyClass : public virtual MyBaseClass {
 *   ...
 * };
 * ```
 */
class VirtualClassDerivation extends ClassDerivation {
  VirtualClassDerivation() { this.hasSpecifier("virtual") }

  override string getAPrimaryQlClass() { result = "VirtualClassDerivation" }
}

/**
 * A class/struct that is the base of some virtual class derivation.  For
 * example `MyBaseClass` in the following code is a `VirtualBaseClass` of
 * `MyClass`:
 * ```
 * class MyBaseClass {
 *  ...
 * };
 *
 * class MyClass : public virtual MyBaseClass {
 *   ...
 * };
 * ```
 */
class VirtualBaseClass extends Class {
  VirtualBaseClass() { exists(VirtualClassDerivation cd | cd.getBaseClass() = this) }

  override string getAPrimaryQlClass() { result = "VirtualBaseClass" }

  /** A virtual class derivation of which this class/struct is the base. */
  VirtualClassDerivation getAVirtualDerivation() { result.getBaseClass() = this }

  /** A class/struct that is derived from this one using virtual inheritance. */
  Class getAVirtuallyDerivedClass() { result = this.getAVirtualDerivation().getDerivedClass() }
}

/**
 * The proxy class (where needed) associated with a template parameter, as
 * in the following code:
 * ```
 * template <typename T>
 * struct S : T { // the type of this T is a proxy class
 *   ...
 * };
 * ```
 */
class ProxyClass extends UserType {
  ProxyClass() { usertypes(underlyingElement(this), _, 9) }

  override string getAPrimaryQlClass() { result = "ProxyClass" }

  /** Gets the location of the proxy class. */
  override Location getLocation() { result = this.getTemplateParameter().getDefinitionLocation() }

  /** Gets the template parameter for which this is the proxy class. */
  TemplateParameter getTemplateParameter() {
    is_proxy_class_for(underlyingElement(this), unresolveElement(result))
  }
}

// Unpacks "array of ... of array of t" into t.
private Type stripArrayTypes(Type t) {
  not t instanceof ArrayType and result = t
  or
  result = stripArrayTypes(t.(ArrayType).getBaseType())
}
