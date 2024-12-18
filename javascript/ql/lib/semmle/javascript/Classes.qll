/**
 * Provides classes for working with ECMAScript 2015 classes.
 *
 * Class declarations and class expressions are modeled by (QL) classes `ClassDeclaration`
 * and `ClassExpression`, respectively, which are both subclasses of `ClassDefinition`.
 */

import javascript

/**
 * An ECMAScript 2015/TypeScript class definition or a TypeScript interface definition,
 * including both declarations and expressions.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   Rectangle(width, height) {
 *     this.width = width;
 *     this.height = height;
 *   }
 *
 *   area() { return this.width * this.height; }
 * }
 *
 * interface EventEmitter<T> {
 *   addListener(listener: (x: T) => void): void;
 * }
 * ```
 */
class ClassOrInterface extends @class_or_interface, TypeParameterized {
  /** Gets the identifier naming the declared type, if any. */
  Identifier getIdentifier() { none() } // Overridden in subtypes.

  /**
   * Gets the name of the defined class or interface, possibly inferred
   * from the context if this is an anonymous class expression.
   *
   * Has no result if no name could be determined.
   */
  string getName() {
    result = this.getIdentifier().getName() // Overridden in ClassExpr
  }

  /** Gets a member declared in this class or interface. */
  MemberDeclaration getAMember() { result.getDeclaringType() = this }

  /** Gets the `i`th member declared in this class or interface. */
  MemberDeclaration getMemberByIndex(int i) { properties(result, this, i, _, _) }

  /** Gets the member with the given name declared in this class or interface. */
  MemberDeclaration getMember(string name) {
    result = this.getAMember() and
    result.getName() = name
  }

  /** Gets a method declared in this class or interface. */
  MethodDeclaration getAMethod() { result = this.getAMember() }

  /**
   * Gets the method with the given name declared in this class or interface.
   *
   * Note that for overloaded method signatures in TypeScript files, this returns every overload.
   */
  MethodDeclaration getMethod(string name) { result = this.getMember(name) }

  /** Gets an overloaded version of the method with the given name declared in this class or interface. */
  MethodDeclaration getMethodOverload(string name, int overloadIndex) {
    result = this.getMethod(name) and
    overloadIndex = result.getOverloadIndex()
  }

  /** Gets a field declared in this class or interface. */
  FieldDeclaration getAField() { result = this.getAMember() }

  /** Gets the field with the given name declared in this class or interface. */
  FieldDeclaration getField(string name) { result = this.getMember(name) }

  /** Gets a call signature declared in this interface. */
  CallSignature getACallSignature() { result = this.getAMember() }

  /** Gets an index signature declared in this interface. */
  IndexSignature getAnIndexSignature() { result = this.getAMember() }

  /**
   * Gets the expression denoting the super class of this class,
   * or nothing if this is an interface or a class without an `extends` clause.
   */
  Expr getSuperClass() { none() }

  /**
   * Gets the `n`th type from the `implements` clause of this class or `extends` clause of this interface,
   * starting at 0.
   */
  TypeExpr getSuperInterface(int n) { none() }

  /**
   * Gets any type from the `implements` clause of this class or `extends` clause of this interface.
   */
  TypeExpr getASuperInterface() { result = this.getSuperInterface(_) }

  /**
   * Holds if this is an interface or a class declared with the `abstract` modifier.
   */
  predicate isAbstract() { none() }

  /**
   * Gets a description of this class or interface.
   *
   * For named types such as `class C { ... }`, this is just the declared
   * name. For classes assigned to variables, this is the name of the variable.
   * If no meaningful name can be inferred, the result is "anonymous class" or
   * "anonymous interface".
   */
  override string describe() { none() } // Overridden in subtypes.

  /**
   * Gets the canonical name of this class or interface type.
   *
   * Anonymous classes and interfaces do not have a canonical name.
   */
  TypeName getTypeName() { result.getADefinition() = this }

  /**
   * Gets the ClassOrInterface corresponding to either a super type or an implemented interface.
   */
  ClassOrInterface getASuperTypeDeclaration() {
    this.getSuperClass().(VarAccess).getVariable().getADeclaration() = result.getIdentifier() or
    this.getASuperInterface().(LocalTypeAccess).getLocalTypeName().getADeclaration() =
      result.getIdentifier()
  }
}

/**
 * An ECMAScript 2015 or TypeScript class definition, that is, either a class declaration statement
 * or a class expression.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {   // class declaration statement
 *   constructor(width, height) {
 *     this.width = width;
 *     this.height = height;
 *   }
 *
 *   area() { return this.width * this.height; }
 * }
 *
 * let C =
 * class {                           // class expression
 *   constructor() { this.x = 0; }
 *
 *   bump() { return this.x++; }
 * };
 * ```
 */
class ClassDefinition extends @class_definition, ClassOrInterface, AST::ValueNode {
  /** Gets the variable holding this class. */
  Variable getVariable() { result = this.getIdentifier().getVariable() }

  /** Gets the identifier naming the defined class, if any. */
  override VarDecl getIdentifier() { result = this.getChildExpr(0) }

  override TypeParameter getTypeParameter(int i) {
    // AST indices for type parameters: -3, -6, -9, ...
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -3 and astIndex % 3 = 0 and i = -(astIndex + 3) / 3
    )
  }

  /** Gets the expression denoting the super class of the defined class, if any. */
  override Expr getSuperClass() { result = this.getChildExpr(1) }

  /** Gets the `i`th type from the `implements` clause of this class, starting at 0. */
  override TypeExpr getSuperInterface(int i) {
    // AST indices for super interfaces: -1, -4, -7, ...
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -1 and astIndex % 3 = -1 and i = -(astIndex + 1) / 3
    )
  }

  /** Gets any type from the `implements` clause of this class. */
  override TypeExpr getASuperInterface() { result = ClassOrInterface.super.getASuperInterface() }

  /**
   * Gets the constructor of this class.
   *
   * Note that every class has a constructor: if no explicit constructor
   * is declared, it has a synthetic default constructor.
   */
  ConstructorDeclaration getConstructor() { result = this.getAMethod() }

  /**
   * Gets the `i`th decorator applied to this class.
   *
   * For example, the class `@A @B class C {}` has
   * `@A` as its 0th decorator, and `@B` as its first decorator.
   */
  Decorator getDecorator(int i) {
    // AST indices for decorators: -2, -5, -8, ...
    exists(int astIndex | exprs(result, _, this, astIndex, _) |
      astIndex <= -2 and astIndex % 3 = -2 and i = -(astIndex + 2) / 3
    )
  }

  /**
   * Gets a decorator applied to this class, if any.
   *
   * For example, the class `@A @B class C {}` has
   * decorators `@A` and `@B`.
   */
  Decorator getADecorator() { result = this.getDecorator(_) }

  /**
   * Holds if this class has the `abstract` modifier.
   */
  override predicate isAbstract() { is_abstract_class(this) }

  override string describe() {
    if exists(this.inferNameFromVarDef())
    then result = this.inferNameFromVarDef()
    else result = "anonymous class"
  }

  /**
   * Gets a description of this class, based on its declared name or the name
   * of the variable it is assigned to, if any.
   */
  private string inferNameFromVarDef() {
    // in ambiguous cases like `let C = class D {}`, prefer `D` to `C`
    if exists(this.getIdentifier())
    then result = "class " + this.getIdentifier().getName()
    else
      exists(VarDef vd | this = vd.getSource() |
        result = "class " + vd.getTarget().(VarRef).getName()
      )
  }

  /**
   * Gets an instance method of this class with the given name.
   *
   * Note that constructors aren't considered instance methods.
   */
  Function getInstanceMethod(string name) {
    exists(MemberDefinition mem | mem = this.getMember(name) |
      result = mem.getInit() and
      not mem.isStatic() and
      not mem instanceof ConstructorDefinition
    )
  }

  /**
   * Gets the definition of the super class of this class, if it can be determined.
   */
  ClassDefinition getSuperClassDefinition() {
    result = this.getSuperClass().analyze().getAValue().(AbstractClass).getClass()
  }

  override string getAPrimaryQlClass() { result = "ClassDefinition" }

  /**
   * Gets a static initializer of this class, if any.
   */
  BlockStmt getAStaticInitializerBlock() {
    exists(StaticInitializer init | init.getDeclaringClass() = this | result = init.getBody())
  }
}

/**
 * A class declaration statement.
 *
 * Example:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(width, height) {
 *     this.width = width;
 *     this.height = height;
 *   }
 *
 *   area() { return this.width * this.height; }
 * }
 * ```
 */
class ClassDeclStmt extends @class_decl_stmt, ClassDefinition, Stmt {
  override ControlFlowNode getFirstControlFlowNode() {
    if has_declare_keyword(this) then result = this else result = this.getIdentifier()
  }
}

/**
 * A class expression.
 *
 * Example:
 *
 * ```
 * let C =
 * class {                            // class expression
 *   constructor() { this.x = 0; }
 *
 *   bump() { return this.x++; }
 * };
 * ```
 */
class ClassExpr extends @class_expr, ClassDefinition, Expr {
  override string getName() {
    result = ClassDefinition.super.getName()
    or
    not exists(this.getIdentifier()) and
    (
      exists(VarDef vd | this = vd.getSource() | result = vd.getTarget().(VarRef).getName())
      or
      exists(ValueProperty p |
        this = p.getInit() and
        result = p.getName()
      )
      or
      exists(AssignExpr assign, PropAccess prop |
        this = assign.getRhs().getUnderlyingValue() and
        prop = assign.getLhs() and
        result = prop.getPropertyName()
      )
    )
  }

  override predicate isImpure() { none() }

  override ControlFlowNode getFirstControlFlowNode() {
    if exists(this.getIdentifier())
    then result = this.getIdentifier()
    else
      if exists(this.getSuperClass())
      then result = this.getSuperClass().getFirstControlFlowNode()
      else
        if exists(this.getClassInitializedMember())
        then
          result =
            min(ClassInitializedMember m |
              m = this.getClassInitializedMember()
            |
              m order by m.getIndex()
            )
        else result = this
  }

  /** Returns a member that is initialized during the creation of this class. */
  private ClassInitializedMember getClassInitializedMember() { result = this.getAMember() }
}

/**
 * A class member that is initialized at class creation time (as opposed to instance creation time).
 */
private class ClassInitializedMember extends MemberDeclaration {
  ClassInitializedMember() { this instanceof MethodDefinition or this.isStatic() }

  int getIndex() { properties(this, _, result, _, _) }

  override string getAPrimaryQlClass() { result = "ClassInitializedMember" }
}

/**
 * A `super` expression.
 *
 * Example:
 *
 * ```
 * super
 * ```
 */
class SuperExpr extends @super_expr, Expr {
  override predicate isImpure() { none() }

  /**
   * Gets the function whose `super` binding this expression refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getBinder() { result = this.getEnclosingFunction().getThisBinder() }

  override string getAPrimaryQlClass() { result = "SuperExpr" }
}

/**
 * A `super(...)` call.
 *
 * Example:
 *
 * ```
 * super(...args)
 * ```
 */
class SuperCall extends CallExpr {
  SuperCall() { this.getCallee().getUnderlyingValue() instanceof SuperExpr }

  /**
   * Gets the function whose `super` binding this call refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getBinder() { result = this.getCallee().getUnderlyingValue().(SuperExpr).getBinder() }
}

/**
 * A property access on `super`.
 *
 * Example:
 *
 * ```
 * super.f
 * ```
 */
class SuperPropAccess extends PropAccess {
  SuperPropAccess() { this.getBase().getUnderlyingValue() instanceof SuperExpr }
}

/**
 * A `new.target` expression.
 *
 * Example:
 *
 * ```
 * new.target
 * ```
 *
 * When a function `f` is invoked as `new f()`, then `new.target` inside
 * `f` evaluates to `f` ; on the other hand, when `f` is invoked without
 * `new`, it evaluates to `undefined`.
 *
 * See also ECMAScript 2015 Language Specification, Chapter 12.3.8.
 */
class NewTargetExpr extends @newtarget_expr, Expr {
  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "NewTargetExpr" }
}

/**
 * A scope induced by a named class expression or class expression with type parameters.
 */
class ClassExprScope extends @class_expr_scope, Scope {
  override string toString() { result = "class expression scope" }
}

/**
 * A scope induced by a class declaration with type parameters.
 */
class ClassDeclScope extends @class_decl_scope, Scope {
  override string toString() { result = "class declaration scope" }
}

/**
 * A member declaration in a class or interface, that is, either a method declaration or a field declaration.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   width;                            // field declaration
 *   height;                           // field declaration
 *
 *   constructor(height, width) {      // constructor declaration, which is also a method declaration
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {                          // method declaration
 *     return this.width*this.height;
 *   }
 * }
 *
 * interface EventEmitter<T> {
 *   addListener(listener: (x: T) => void): void;  // method declaration
 * }
 * ```
 *
 * The subtype `MemberSignature` contains TypeScript members that are abstract, ambient, or
 * overload signatures.
 *
 * The subtype `MemberDefinition` contains all members that are not signatures. In regular
 * JavaScript, all members are definitions.
 *
 * There are also subtypes for working with specific kinds of members, such as `FieldDeclaration`,
 * `FieldSignature`, and `FieldDefinition`, and similarly named subtypes for methods, constructors, and
 * getters and setters.
 */
class MemberDeclaration extends @property, Documentable {
  MemberDeclaration() {
    // filter out property patterns and object properties and enum members
    exists(ClassOrInterface cl | properties(this, cl, _, _, _))
  }

  /**
   * Holds if this member is static.
   */
  predicate isStatic() { is_static(this) }

  /** Gets a boolean indicating if this member is static. */
  boolean getStaticAsBool() { if this.isStatic() then result = true else result = false }

  /**
   * Holds if this member is abstract.
   *
   * Abstract members occur only in TypeScript.
   */
  predicate isAbstract() { is_abstract_member(this) }

  /**
   * Holds if this member is public, either because it has no access modifier or
   * because it is explicitly annotated as `public`.
   *
   * Class members not declared in a TypeScript file are always considered public.
   */
  predicate isPublic() { not this.isPrivate() and not this.isProtected() }

  /**
   * Holds if this is a TypeScript member explicitly annotated with the `public` keyword.
   */
  predicate hasPublicKeyword() { has_public_keyword(this) }

  /**
   * Holds if this member is considered private.
   *
   * This may occur in two cases:
   * - it is a TypeScript member annotated with the `private` keyword, or
   * - the member has a private name, such as `#foo`, referring to a private field in the class
   */
  predicate isPrivate() { this.hasPrivateKeyword() or this.hasPrivateFieldName() }

  /**
   * Holds if this is a TypeScript member annotated with the `private` keyword.
   */
  predicate hasPrivateKeyword() { has_private_keyword(this) }

  /**
   * Holds if this is a TypeScript member annotated with the `protected` keyword.
   */
  predicate isProtected() { has_protected_keyword(this) }

  /**
   * Holds if the member has a private name, such as `#foo`, referring to a private field in the class.
   *
   * For example:
   * ```js
   * class Foo {
   *   #method() {}
   * }
   * ```
   */
  predicate hasPrivateFieldName() { this.getNameExpr().(Label).getName().charAt(0) = "#" }

  /**
   * Gets the expression specifying the name of this member,
   * or nothing if this is a call signature.
   */
  Expr getNameExpr() { result = this.getChildExpr(0) }

  /**
   * Gets the expression specifying the initial value of the member;
   * for methods and constructors this is always a function, for fields
   * it may not be defined.
   */
  Expr getInit() { result = this.getChildExpr(1) }

  /** Gets the name of this member. */
  string getName() {
    result = this.getNameExpr().(Literal).getValue()
    or
    not this.isComputed() and result = this.getNameExpr().(Identifier).getName()
  }

  /** Holds if the name of this member is computed. */
  predicate isComputed() { is_computed(this) }

  /** Gets the class or interface this member belongs to. */
  ClassOrInterface getDeclaringType() { properties(this, result, _, _, _) }

  /** Gets the class this member belongs to, if any. */
  ClassDefinition getDeclaringClass() { properties(this, result, _, _, _) }

  /** Gets the index of this member within its enclosing type. */
  int getMemberIndex() { properties(this, _, result, _, _) }

  /** Holds if the name of this member is computed by an impure expression. */
  predicate hasImpureNameExpr() { this.isComputed() and this.getNameExpr().isImpure() }

  /**
   * Gets the `i`th decorator applied to this member.
   *
   * For example, a method of the form `@A @B m() { ... }` has
   * `@A` as its 0th decorator and `@B` as its first decorator.
   */
  Decorator getDecorator(int i) { result = this.getChildExpr(-(i + 1)) }

  /**
   * Gets a decorator applied to this member.
   *
   * For example, a method of the form `@A @B m() { ... }` has
   * decorators `@A` and `@B`.
   */
  Decorator getADecorator() { result = this.getDecorator(_) }

  override string toString() { properties(this, _, _, _, result) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = this.getNameExpr().getFirstControlFlowNode()
  }

  /**
   * True if this is neither abstract, ambient, nor part of an overloaded method signature.
   */
  predicate isConcrete() {
    not this.isAbstract() and
    not this.isAmbient() and
    (this instanceof MethodDeclaration implies this.(MethodDeclaration).getBody().hasBody())
  }

  /**
   * True if this is abstract, ambient, or an overload signature.
   */
  predicate isSignature() { not this.isConcrete() }

  override string getAPrimaryQlClass() { result = "MemberDeclaration" }
}

/**
 * A concrete member of a class, that is, a non-abstract, non-ambient field or method with a body.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   width;                            // field declaration
 *   height;                           // field declaration
 *
 *   constructor(height, width) {      // constructor declaration, which is also a method declaration
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {                          // method declaration
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class MemberDefinition extends MemberDeclaration {
  MemberDefinition() { this.isConcrete() }
}

/**
 * A member signature declared in a class or interface, that is, an abstract or ambient field
 * or method without a function body.
 *
 * Example:
 *
 * ```
 * interface EventEmitter<T> {
 *   addListener(listener: (x: T) => void): void;  // method signature
 * }
 * ```
 */
class MemberSignature extends MemberDeclaration {
  MemberSignature() { this.isSignature() }
}

/**
 * A method declaration in a class or interface, either a concrete definition or a signature without a body.
 *
 * Examples:
 *
 * ```
 * abstract class Shape {
 *   abstract area() : number;         // method declaration
 * }
 *
 * class Rectangle extends Shape {
 *   height: number;
 *   width: number;
 *
 *   constructor(height: number, width: number) {  // constructor declaration, which is also a method declaration
 *     super();
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {                          // method declaration
 *     return this.width*this.height;
 *   }
 * }
 * ```
 *
 * Note that TypeScript call signatures are not considered methods.
 */
class MethodDeclaration extends MemberDeclaration {
  MethodDeclaration() { is_method(this) }

  /**
   * Gets the body of this method.
   */
  FunctionExpr getBody() { result = this.getChildExpr(1) }

  /**
   * Holds if this method is overloaded, that is, there are multiple method
   * signatures with its name declared in the enclosing type.
   */
  predicate isOverloaded() {
    not this instanceof ConstructorDeclaration and
    hasOverloadedMethod(this.getDeclaringType(), this.getName())
    or
    this instanceof ConstructorDeclaration and
    hasOverloadedConstructor(this.getDeclaringClass())
  }

  /**
   * Gets the index of this method declaration among all the method declarations
   * with this name.
   *
   * In the rare case of a class containing multiple concrete methods with the same name,
   * the overload index is defined as if only one of them was concrete.
   */
  int getOverloadIndex() {
    exists(ClassOrInterface type, string name, boolean static |
      this =
        rank[result + 1](MethodDeclaration method, int i |
          methodDeclaredInType(type, name, static, i, method)
        |
          method order by i
        )
    )
    or
    exists(ClassDefinition type |
      this =
        rank[result + 1](ConstructorDeclaration ctor, int i |
          ctor = type.getMemberByIndex(i)
        |
          ctor order by i
        )
    )
  }
}

/**
 * Holds if the `index`th member of `type` is `method`, which has the given `name`.
 */
private predicate methodDeclaredInType(
  ClassOrInterface type, string name, boolean static, int index, MethodDeclaration method
) {
  not method instanceof ConstructorDeclaration and // distinguish methods named "constructor" from the constructor
  type.getMemberByIndex(index) = method and
  static = method.getStaticAsBool() and
  method.getName() = name
}

/**
 * Holds if `type` has an overloaded method named `name`.
 */
private predicate hasOverloadedMethod(ClassOrInterface type, string name) {
  exists(MethodDeclaration method |
    method = type.getMethod(name) and
    not method instanceof ConstructorDeclaration and
    method.getOverloadIndex() > 0
  )
}

/** Holds if `type` has an overloaded constructor declaration. */
private predicate hasOverloadedConstructor(ClassDefinition type) {
  type.getConstructor().getOverloadIndex() > 0
}

/** Holds if `type` has an overloaded function call signature. */
private predicate hasOverloadedFunctionCallSignature(ClassOrInterface type) {
  type.getACallSignature().(FunctionCallSignature).getOverloadIndex() > 0
}

/** Holds if `type` has an overloaded constructor call signature. */
private predicate hasOverloadedConstructorCallSignature(ClassOrInterface type) {
  type.getACallSignature().(ConstructorCallSignature).getOverloadIndex() > 0
}

/**
 * A concrete method definition in a class.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {      // constructor definition, which is also a method definition
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {                          // method definition
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class MethodDefinition extends MethodDeclaration, MemberDefinition {
  override string getAPrimaryQlClass() { result = "MethodDefinition" }
}

/**
 * A method signature declared in a class or interface, that is, a method without a function body.
 *
 * Example:
 *
 * ```
 * interface EventEmitter<T> {
 *   addListener(listener: (x: T) => void): void;  // method signature
 * }
 * ```
 *
 * Note that TypeScript call signatures are not considered method signatures.
 */
class MethodSignature extends MethodDeclaration, MemberSignature {
  override string getAPrimaryQlClass() { result = "MethodSignature" }
}

/**
 * A constructor declaration in a class, either a concrete definition or a signature without a body.
 *
 * Example:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {      // constructor declaration
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class ConstructorDeclaration extends MethodDeclaration {
  ConstructorDeclaration() {
    not this.isComputed() and
    not this.isStatic() and
    this.getName() = "constructor"
  }

  /** Holds if this is a synthetic default constructor. */
  predicate isSynthetic() { this.getLocation().isEmpty() }

  override string getAPrimaryQlClass() { result = "ConstructorDeclaration" }
}

/**
 * The concrete constructor definition of a class, possibly a synthetic constructor if the class
 * did not declare any constructors.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {      // constructor definition
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   area() {
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class ConstructorDefinition extends ConstructorDeclaration, MethodDefinition {
  override string getAPrimaryQlClass() { result = "ConstructorDefinition" }
}

/**
 * A constructor signature declared in a class, that is, a constructor without a function body.
 *
 * ```
 * declare class Rectangle {
 *   constructor(width: number, height: number);  // constructor signature
 * }
 * ```
 */
class ConstructorSignature extends ConstructorDeclaration, MethodSignature {
  override string getAPrimaryQlClass() { result = "ConstructorSignature" }
}

/**
 * A function generated by the extractor to implement a synthetic default constructor.
 *
 * Example:
 *
 * ```
 * class Rectangle extends Shape {
 *   // implicitly generated synthetic constructor:
 *   // constructor() { super(); }
 *
 *   area() {
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class SyntheticConstructor extends Function {
  SyntheticConstructor() { this = any(ConstructorDeclaration cd | cd.isSynthetic() | cd.getBody()) }
}

/**
 * An accessor method declaration in a class or interface, either a concrete definition or a signature without a body.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   get area() {                          // accessor method declaration
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
abstract class AccessorMethodDeclaration extends MethodDeclaration {
  /** Get the corresponding getter (if this is a setter) or setter (if this is a getter). */
  AccessorMethodDeclaration getOtherAccessor() {
    getterSetterPair(this, result)
    or
    getterSetterPair(result, this)
  }
}

/**
 * A concrete accessor method definition in a class, that is, an accessor method with a function body.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   get area() {                          // accessor method declaration
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
abstract class AccessorMethodDefinition extends MethodDefinition, AccessorMethodDeclaration { }

/**
 * An accessor method signature declared in a class or interface, that is, an accessor method without a function body.
 *
 * Example:
 *
 * ```
 * abstract class Shape {
 *  abstract get area() : number;  // accessor method signature
 * }
 * ```
 */
abstract class AccessorMethodSignature extends MethodSignature, AccessorMethodDeclaration { }

/**
 * A getter method declaration in a class or interface, either a concrete definition or a signature without a function body.
 *
 * Examples:
 *
 * ```
 * abstract class Shape {
 *  abstract get area() : number;      // getter method signature
 * }
 *
 * class Rectangle extends Shape {
 *   height: number;
 *   width: number;
 *
 *   constructor(height: number, width: number) {
 *     super();
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   get area() {                      // getter method definition
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class GetterMethodDeclaration extends AccessorMethodDeclaration, @property_getter {
  override string getAPrimaryQlClass() { result = "GetterMethodDeclaration" }

  /** Gets the correspinding setter declaration, if any. */
  SetterMethodDeclaration getCorrespondingSetter() { getterSetterPair(this, result) }
}

/**
 * A concrete getter method definition in a class, that is, a getter method with a function body.
 *
 * Examples:
 *
 * ```
 * class Rectangle extends Shape {
 *   constructor(height, width) {
 *     this.height = height;
 *     this.width = width;
 *   }
 *
 *   get area() {                          // getter method definition
 *     return this.width*this.height;
 *   }
 * }
 * ```
 */
class GetterMethodDefinition extends GetterMethodDeclaration, AccessorMethodDefinition {
  override string getAPrimaryQlClass() { result = "GetterMethodDefinition" }
}

/**
 * A getter method signature declared in a class or interface, that is, a getter method without a function body.
 *
 * Example:
 *
 * ```
 * abstract class Shape {
 *  abstract get area() : number;  // getter method signature
 * }
 * ```
 */
class GetterMethodSignature extends GetterMethodDeclaration, AccessorMethodSignature {
  override string getAPrimaryQlClass() { result = "GetterMethodSignature" }
}

/**
 * A setter method declaration in a class or interface, either a concrete definition or a signature without a body.
 *
 * Examples:
 *
 * ```
 * abstract class Cell<T> {
 *  abstract set value(v: any);     // setter method signature
 * }
 *
 * class NumberCell extends Cell<number> {
 *   constructor(private _value: number) {
 *     super();
 *   }
 *
 *   set value(v: any) {            // setter method definition
 *     this._value = +v;
 *   }
 * }
 * ```
 */
class SetterMethodDeclaration extends AccessorMethodDeclaration, @property_setter {
  override string getAPrimaryQlClass() { result = "SetterMethodDeclaration" }

  /** Gets the correspinding getter declaration, if any. */
  GetterMethodDeclaration getCorrespondingGetter() { getterSetterPair(result, this) }
}

/**
 * A concrete setter method definition in a class, that is, a setter method with a function body
 *
 * Examples:
 *
 * ```
 * class NumberCell extends Cell<number> {
 *   constructor(private _value: number) {
 *     super();
 *   }
 *
 *   set value(v: any) {            // setter method definition
 *     this._value = +v;
 *   }
 * }
 * ```
 */
class SetterMethodDefinition extends SetterMethodDeclaration, AccessorMethodDefinition {
  override string getAPrimaryQlClass() { result = "SetterMethodDefinition" }
}

/**
 * A setter method signature declared in a class or interface, that is, a setter method without a function body.
 *
 * Example:
 *
 * ```
 * abstract class Cell<T> {
 *  abstract set value(v: any);     // setter method signature
 * }
 * ```
 */
class SetterMethodSignature extends SetterMethodDeclaration, AccessorMethodSignature {
  override string getAPrimaryQlClass() { result = "SetterMethodSignature" }
}

/**
 * A field declaration in a class or interface, either a concrete definition or an abstract or ambient field signature.
 *
 * Examples:
 *
 * ```
 * class Rectangle {
 *   height;                   // field declaration
 *   width;                    // field declaration
 * }
 *
 * abstract class Counter {
 *  abstract value: number;    // field signature
 * }
 * ```
 */
class FieldDeclaration extends MemberDeclaration, @field {
  /** Gets the type annotation of this field, if any, such as `T` in `{ x: T }`. */
  TypeAnnotation getTypeAnnotation() {
    result = this.getChildTypeExpr(2)
    or
    result = this.getDocumentation().getATagByTitle("type").getType()
  }

  /** Holds if this is a TypeScript field annotated with the `readonly` keyword. */
  predicate isReadonly() { has_readonly_keyword(this) }

  /** Holds if this is a TypeScript field marked as optional with the `?` operator. */
  predicate isOptional() { is_optional_member(this) }

  /** Holds if this is a TypeScript field marked as definitely assigned with the `!` operator. */
  predicate hasDefiniteAssignmentAssertion() { has_definite_assignment_assertion(this) }

  override string getAPrimaryQlClass() { result = "FieldDeclaration" }
}

/**
 * A concrete field definition in a class.
 *
 * Examples:
 *
 * ```
 * class Rectangle {
 *   height;  // field definition
 *   width;   // field definition
 * }
 * ```
 */
class FieldDefinition extends FieldDeclaration, MemberDefinition { }

/**
 * A field signature declared in a class or interface, that is, an abstract or ambient field declaration.
 *
 * Example:
 *
 * ```
 * abstract class Counter {
 *  abstract value: number;    // field signature
 * }
 * ```
 */
class FieldSignature extends FieldDeclaration, MemberSignature { }

/**
 * A field induced by an initializing constructor parameter.
 *
 * Example:
 *
 * ```
 * class C {
 *   constructor(public x: number) {}  // `x` is a parameter field
 * }
 * ```
 */
class ParameterField extends FieldDeclaration, @parameter_field {
  /** Gets the initializing constructor parameter from which this field was induced. */
  Parameter getParameter() {
    exists(FunctionExpr constructor, int index | parameter_fields(this, constructor, index) |
      result = constructor.getParameter(index)
    )
  }

  override Expr getNameExpr() { result = this.getParameter() }

  override TypeAnnotation getTypeAnnotation() { result = this.getParameter().getTypeAnnotation() }
}

/**
 * A static initializer in a class.
 */
class StaticInitializer extends MemberDefinition, @static_initializer {
  /**
   * Gets the body of the static initializer.
   */
  BlockStmt getBody() { result.getParent() = this }

  override Expr getNameExpr() { none() }
}

/**
 * A call signature declared in an interface.
 *
 * Examples:
 *
 * ```
 * interface I {
 *   (x: number): number;      // function call signature
 *   new (x: string): Object;  // constructor call signature
 * }
 * ```
 *
 * Call signatures are either function call signatures or constructor call signatures.
 */
class CallSignature extends @call_signature, MemberSignature {
  FunctionExpr getBody() { result = this.getChildExpr(1) }

  /** Gets the interface or function type that declares this call signature. */
  override InterfaceDefinition getDeclaringType() {
    result = MemberSignature.super.getDeclaringType()
  }
}

/**
 * A function call signature declared in an interface.
 *
 * Example:
 *
 * ```
 * interface I {
 *   (x: number): string;  // function call signature
 * }
 * ```
 */
class FunctionCallSignature extends @function_call_signature, CallSignature {
  /** Gets the index of this function call signature among the function call signatures in the enclosing type. */
  int getOverloadIndex() {
    exists(ClassOrInterface type | type = this.getDeclaringType() |
      this =
        rank[result + 1](FunctionCallSignature sig, int i |
          sig = type.getMemberByIndex(i)
        |
          sig order by i
        )
    )
  }

  /**
   * Holds if this function call signature is overloaded, that is, there are multiple function call
   * signatures declared in the enclosing type.
   */
  predicate isOverloaded() { hasOverloadedFunctionCallSignature(this.getDeclaringType()) }
}

/**
 * A constructor call signature declared in an interface.
 *
 * Example:
 *
 * ```
 * interface I {
 *   new (x: string): Object;  // constructor call signature
 * }
 * ```
 */
class ConstructorCallSignature extends @constructor_call_signature, CallSignature {
  /** Gets the index of this constructor call signature among the constructor call signatures in the enclosing type. */
  int getOverloadIndex() {
    exists(ClassOrInterface type | type = this.getDeclaringType() |
      this =
        rank[result + 1](ConstructorCallSignature sig, int i |
          sig = type.getMemberByIndex(i)
        |
          sig order by i
        )
    )
  }

  /**
   * Holds if this constructor call signature is overloaded, that is, there are multiple constructor call
   * signatures declared in the enclosing type.
   */
  predicate isOverloaded() { hasOverloadedConstructorCallSignature(this.getDeclaringType()) }
}

/**
 * An index signature declared in an interface.
 *
 * Example:
 *
 * ```
 * interface I {
 *   [x: number]: number;  // index signature
 * }
 * ```
 */
class IndexSignature extends @index_signature, MemberSignature {
  FunctionExpr getBody() { result = this.getChildExpr(1) }

  /** Gets the interface or function type that declares this index signature. */
  override InterfaceDefinition getDeclaringType() {
    result = MemberSignature.super.getDeclaringType()
  }

  override string getAPrimaryQlClass() { result = "IndexSignature" }
}

private boolean getStaticness(AccessorMethodDefinition member) {
  member.isStatic() and result = true
  or
  not member.isStatic() and result = false
}

pragma[nomagic]
private AccessorMethodDefinition getAnAccessorFromClass(
  ClassDefinition cls, string name, boolean static
) {
  result = cls.getMember(name) and
  static = getStaticness(result)
}

pragma[nomagic]
private predicate getterSetterPair(GetterMethodDeclaration getter, SetterMethodDeclaration setter) {
  exists(ClassDefinition cls, string name, boolean static |
    getter = getAnAccessorFromClass(cls, name, static) and
    setter = getAnAccessorFromClass(cls, name, static)
  )
}
