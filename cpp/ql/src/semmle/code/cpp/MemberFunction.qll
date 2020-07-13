/**
 * Provides classes for working with C++ member functions, constructors, destructors,
 * and user-defined operators.
 */

import cpp

/**
 * A C++ function declared as a member of a class [N4140 9.3]. This includes
 * static member functions. For example the functions `MyStaticMemberFunction`
 * and `MyMemberFunction` in:
 * ```
 * class MyClass {
 * public:
 *   void MyMemberFunction() {
 *     DoSomething();
 *   }
 *
 *   static void MyStaticMemberFunction() {
 *     DoSomething();
 *   }
 * };
 * ```
 */
class MemberFunction extends Function {
  MemberFunction() { this.isMember() }

  override string getAPrimaryQlClass() {
    not this instanceof CopyAssignmentOperator and
    not this instanceof MoveAssignmentOperator and
    result = "MemberFunction"
  }

  /**
   * Gets the number of parameters of this function, including any implicit
   * `this` parameter.
   */
  override int getEffectiveNumberOfParameters() {
    if isStatic() then result = getNumberOfParameters() else result = getNumberOfParameters() + 1
  }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

  /** Holds if this function overrides that function. */
  predicate overrides(MemberFunction that) {
    overrides(underlyingElement(this), unresolveElement(that))
  }

  /** Gets a directly overridden function. */
  MemberFunction getAnOverriddenFunction() { this.overrides(result) }

  /** Gets a directly overriding function. */
  MemberFunction getAnOverridingFunction() { result.overrides(this) }

  /**
   * Gets the declaration entry for this member function that is within the
   * class body.
   */
  FunctionDeclarationEntry getClassBodyDeclarationEntry() {
    if strictcount(getADeclarationEntry()) = 1
    then result = getDefinition()
    else (
      result = getADeclarationEntry() and result != getDefinition()
    )
  }

  /**
   * Gets the type of the `this` parameter associated with this member function, if any. The type
   * may have `const` and/or `volatile` qualifiers, matching the function declaration.
   */
  PointerType getTypeOfThis() {
    member_function_this_type(underlyingElement(this), unresolveElement(result))
  }
}

/**
 * A C++ virtual function. For example the two functions called
 * `myVirtualFunction` in the following code are each a
 * `VirtualFunction`:
 * ```
 * class A {
 * public:
 *   virtual void myVirtualFunction() = 0;
 * };
 *
 * class B: public A {
 * public:
 *   virtual void myVirtualFunction() {
 *     doSomething();
 *   }
 * };
 * ```
 */
class VirtualFunction extends MemberFunction {
  VirtualFunction() { this.hasSpecifier("virtual") or purefunctions(underlyingElement(this)) }

  override string getAPrimaryQlClass() { result = "VirtualFunction" }

  /** Holds if this virtual function is pure. */
  predicate isPure() { this instanceof PureVirtualFunction }

  /**
   * Holds if this function was declared with the `override` specifier
   * [N4140 10.3].
   */
  predicate isOverrideExplicit() { this.hasSpecifier("override") }
}

/**
 * A C++ pure virtual function [N4140 10.4]. For example the first function
 * called `myVirtualFunction` in the following code:
 * ```
 * class A {
 * public:
 *   virtual void myVirtualFunction() = 0;
 * };
 *
 * class B: public A {
 * public:
 *   virtual void myVirtualFunction() {
 *     doSomething();
 *   }
 * };
 * ```
 */
class PureVirtualFunction extends VirtualFunction {
  PureVirtualFunction() { purefunctions(underlyingElement(this)) }

  override string getAPrimaryQlClass() { result = "PureVirtualFunction" }
}

/**
 * A const C++ member function [N4140 9.3.1/4]. A const function has the
 * `const` specifier and does not modify the state of its class. For example
 * the member function `day` in the following code:
 * ```
 * class MyClass {
 *   ...
 *
 *   int day() const {
 *     return d;
 *   }
 *
 *   ...
 * };
 * ```
 */
class ConstMemberFunction extends MemberFunction {
  ConstMemberFunction() { this.hasSpecifier("const") }

  override string getAPrimaryQlClass() { result = "ConstMemberFunction" }
}

/**
 * A C++ constructor [N4140 12.1]. For example the function `MyClass` in the
 * following code is a constructor:
 * ```
 * class MyClass {
 * public:
 *   MyClass() {
 *     ...
 *   }
 * };
 * ```
 */
class Constructor extends MemberFunction {
  Constructor() { functions(underlyingElement(this), _, 2) }

  override string getAPrimaryQlClass() { result = "Constructor" }

  /**
   * Holds if this constructor serves as a default constructor.
   *
   * This holds for constructors with zero formal parameters. It also holds
   * for constructors which have a non-zero number of formal parameters,
   * provided that every parameter has a default value.
   */
  predicate isDefault() { forall(Parameter p | p = this.getAParameter() | p.hasInitializer()) }

  /**
   * Gets an entry in the constructor's initializer list, or a
   * compiler-generated action which initializes a base class or member
   * variable.
   */
  ConstructorInit getAnInitializer() { result = getInitializer(_) }

  /**
   * Gets an entry in the constructor's initializer list, or a
   * compiler-generated action which initializes a base class or member
   * variable. The index specifies the order in which the initializer is
   * to be evaluated.
   */
  ConstructorInit getInitializer(int i) {
    exprparents(unresolveElement(result), i, underlyingElement(this))
  }
}

/**
 * A function that defines an implicit conversion.
 */
abstract class ImplicitConversionFunction extends MemberFunction {
  /** Gets the type this `ImplicitConversionFunction` takes as input. */
  abstract Type getSourceType();

  /** Gets the type this `ImplicitConversionFunction` converts to. */
  abstract Type getDestType();
}

/**
 * DEPRECATED: as of C++11 this class does not correspond perfectly with the
 * language definition of a converting constructor.
 *
 * A C++ constructor that also defines an implicit conversion. For example the
 * function `MyClass` in the following code is a `ConversionConstructor`:
 * ```
 * class MyClass {
 * public:
 *   MyClass(const MyOtherClass &from) {
 *     ...
 *   }
 * };
 * ```
 */
deprecated class ConversionConstructor extends Constructor, ImplicitConversionFunction {
  ConversionConstructor() {
    strictcount(Parameter p | p = getAParameter() and not p.hasInitializer()) = 1 and
    not hasSpecifier("explicit")
  }

  override string getAPrimaryQlClass() {
    not this instanceof CopyConstructor and
    not this instanceof MoveConstructor and
    result = "ConversionConstructor"
  }

  /** Gets the type this `ConversionConstructor` takes as input. */
  override Type getSourceType() { result = this.getParameter(0).getType() }

  /** Gets the type this `ConversionConstructor` is a constructor of. */
  override Type getDestType() { result = this.getDeclaringType() }
}

private predicate hasCopySignature(MemberFunction f) {
  f.getParameter(0).getUnspecifiedType().(LValueReferenceType).getBaseType() = f.getDeclaringType()
}

private predicate hasMoveSignature(MemberFunction f) {
  f.getParameter(0).getUnspecifiedType().(RValueReferenceType).getBaseType() = f.getDeclaringType()
}

/**
 * A C++ copy constructor [N4140 12.8]. For example the function `MyClass` in
 * the following code is a `CopyConstructor`:
 * ```
 * class MyClass {
 * public:
 *   MyClass(const MyClass &from) {
 *     ...
 *   }
 * };
 * ```
 *
 * As per the standard, a copy constructor of class `T` is a non-template
 * constructor whose first parameter has type `T&`, `const T&`, `volatile
 * T&`, or `const volatile T&`, and either there are no other parameters,
 * or the rest of the parameters all have default values.
 *
 * For template classes, it can generally not be determined until instantiation
 * whether a constructor is a copy constructor. For such classes, `CopyConstructor`
 * over-approximates the set of copy constructors; if an under-approximation is
 * desired instead, see the member predicate
 * `mayNotBeCopyConstructorInInstantiation`.
 */
class CopyConstructor extends Constructor {
  CopyConstructor() {
    hasCopySignature(this) and
    (
      // The rest of the parameters all have default values
      forall(int i | i > 0 and exists(getParameter(i)) | getParameter(i).hasInitializer())
      or
      // or this is a template class, in which case the default values have
      // not been extracted even if they exist. In that case, we assume that
      // there are default values present since that is the most common case
      // in real-world code.
      getDeclaringType() instanceof TemplateClass
    ) and
    not exists(getATemplateArgument())
  }

  override string getAPrimaryQlClass() { result = "CopyConstructor" }

  /**
   * Holds if we cannot determine that this constructor will become a copy
   * constructor in all instantiations. Depending on template parameters of the
   * enclosing class, this may become an ordinary constructor or a copy
   * constructor.
   */
  predicate mayNotBeCopyConstructorInInstantiation() {
    // In general, default arguments of template classes can only be
    // type-checked for each template instantiation; if an argument in an
    // instantiation fails to type-check then the corresponding parameter has
    // no default argument in the instantiation.
    getDeclaringType() instanceof TemplateClass and
    getNumberOfParameters() > 1
  }
}

/**
 * A C++ move constructor [N4140 12.8]. For example the function `MyClass` in
 * the following code is a `MoveConstructor`:
 * ```
 * class MyClass {
 * public:
 *   MyClass(MyClass &&from) {
 *     ...
 *   }
 * };
 * ```
 *
 * As per the standard, a move constructor of class `T` is a non-template
 * constructor whose first parameter is `T&&`, `const T&&`, `volatile T&&`,
 * or `const volatile T&&`, and either there are no other parameters, or
 * the rest of the parameters all have default values.
 *
 * For template classes, it can generally not be determined until instantiation
 * whether a constructor is a move constructor. For such classes, `MoveConstructor`
 * over-approximates the set of move constructors; if an under-approximation is
 * desired instead, see the member predicate
 * `mayNotBeMoveConstructorInInstantiation`.
 */
class MoveConstructor extends Constructor {
  MoveConstructor() {
    hasMoveSignature(this) and
    (
      // The rest of the parameters all have default values
      forall(int i | i > 0 and exists(getParameter(i)) | getParameter(i).hasInitializer())
      or
      // or this is a template class, in which case the default values have
      // not been extracted even if they exist. In that case, we assume that
      // there are default values present since that is the most common case
      // in real-world code.
      getDeclaringType() instanceof TemplateClass
    ) and
    not exists(getATemplateArgument())
  }

  override string getAPrimaryQlClass() { result = "MoveConstructor" }

  /**
   * Holds if we cannot determine that this constructor will become a move
   * constructor in all instantiations. Depending on template parameters of the
   * enclosing class, this may become an ordinary constructor or a move
   * constructor.
   */
  predicate mayNotBeMoveConstructorInInstantiation() {
    // In general, default arguments of template classes can only be
    // type-checked for each template instantiation; if an argument in an
    // instantiation fails to type-check then the corresponding parameter has
    // no default argument in the instantiation.
    getDeclaringType() instanceof TemplateClass and
    getNumberOfParameters() > 1
  }
}

/**
 * A C++ constructor that takes no arguments ('default' constructor). This
 * is the constructor that is invoked when no initializer is given. For
 * example the function `MyClass` in the following code is a
 * `NoArgConstructor`:
 * ```
 * class MyClass {
 * public:
 *   MyClass() {
 *     ...
 *   }
 * };
 * ```
 */
class NoArgConstructor extends Constructor {
  NoArgConstructor() { this.getNumberOfParameters() = 0 }
}

/**
 * A C++ destructor [N4140 12.4]. For example the function `~MyClass` in the
 * following code is a destructor:
 * ```
 * class MyClass {
 * public:
 *   ~MyClass() {
 *     ...
 *   }
 * };
 * ```
 */
class Destructor extends MemberFunction {
  Destructor() { functions(underlyingElement(this), _, 3) }

  override string getAPrimaryQlClass() { result = "Destructor" }

  /**
   * Gets a compiler-generated action which destructs a base class or member
   * variable.
   */
  DestructorDestruction getADestruction() { result = getDestruction(_) }

  /**
   * Gets a compiler-generated action which destructs a base class or member
   * variable. The index specifies the order in which the destruction should
   * be evaluated.
   */
  DestructorDestruction getDestruction(int i) {
    exprparents(unresolveElement(result), i, underlyingElement(this))
  }
}

/**
 * A C++ conversion operator [N4140 12.3.2]. For example the function
 * `operator int` in the following code is a `ConversionOperator`:
 * ```
 * class MyClass {
 * public:
 *   operator int();
 * };
 * ```
 */
class ConversionOperator extends MemberFunction, ImplicitConversionFunction {
  ConversionOperator() { functions(underlyingElement(this), _, 4) }

  override string getAPrimaryQlClass() { result = "ConversionOperator" }

  override Type getSourceType() { result = this.getDeclaringType() }

  override Type getDestType() { result = this.getType() }
}

/**
 * A C++ copy assignment operator [N4140 12.8]. For example the function
 * `operator=` in the following code is a `CopyAssignmentOperator`:
 * ```
 * class MyClass {
 * public:
 *   MyClass &operator=(const MyClass &other);
 * };
 * ```
 *
 * As per the standard, a copy assignment operator of class `T` is a
 * non-template non-static member function with the name `operator=` that
 * takes exactly one parameter of type `T`, `T&`, `const T&`, `volatile
 * T&`, or `const volatile T&`.
 */
class CopyAssignmentOperator extends Operator {
  CopyAssignmentOperator() {
    hasName("operator=") and
    (
      hasCopySignature(this)
      or
      // Unlike CopyConstructor, this member allows a non-reference
      // parameter.
      getParameter(0).getUnspecifiedType() = getDeclaringType()
    ) and
    not exists(this.getParameter(1)) and
    not exists(getATemplateArgument())
  }

  override string getAPrimaryQlClass() { result = "CopyAssignmentOperator" }
}

/**
 * A C++ move assignment operator [N4140 12.8]. For example the function
 * `operator=` in the following code is a `MoveAssignmentOperator`:
 * ```
 * class MyClass {
 * public:
 *   MyClass &operator=(MyClass &&other);
 * };
 * ```
 *
 * As per the standard, a move assignment operator of class `T` is a
 * non-template non-static member function with the name `operator=` that
 * takes exactly one parameter of type `T&&`, `const T&&`, `volatile T&&`,
 * or `const volatile T&&`.
 */
class MoveAssignmentOperator extends Operator {
  MoveAssignmentOperator() {
    hasName("operator=") and
    hasMoveSignature(this) and
    not exists(this.getParameter(1)) and
    not exists(getATemplateArgument())
  }

  override string getAPrimaryQlClass() { result = "MoveAssignmentOperator" }
}
