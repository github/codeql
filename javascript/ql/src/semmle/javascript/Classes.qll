/**
 * Provides classes for working with ECMAScript 2015 classes.
 *
 * Class declarations and class expressions are modeled by (QL) classes `ClassDeclaration`
 * and `ClassExpression`, respectively, which are both subclasses of `ClassDefinition`.
 */

import javascript

/**
 * A class or interface definition.
 */
class ClassOrInterface extends @classorinterface, TypeParameterized {
  /** Gets the identifier naming the declared type, if any. */
  Identifier getIdentifier() { none() } // Overridden in subtypes.

  /**
   * Gets the name of the defined class or interface, possibly inferred
   * from the context if this is an anonymous class expression.
   *
   * Has no result if no name could be determined.
   */
  string getName() {
    result = getIdentifier().getName() // Overridden in ClassExpr
  }

  /** Gets the nearest enclosing function or toplevel in which this class or interface occurs. */
  StmtContainer getContainer() { result = this.(ExprOrStmt).getContainer() }

  /** Gets a member declared in this class or interface. */
  MemberDeclaration getAMember() { result.getDeclaringType() = this }

  /** Gets the member with the given name declared in this class or interface. */
  MemberDeclaration getMember(string name) {
    result = getAMember() and
    result.getName() = name
  }

  /** Gets a method declared in this class or interface. */
  MethodDeclaration getAMethod() { result = getAMember() }

  /** Gets the method with the given name declared in this class or interface. */
  MethodDeclaration getMethod(string name) { result = getMember(name) }

  /** Gets a field declared in this class or interface. */
  FieldDeclaration getAField() { result = getAMember() }

  /** Gets the field with the given name declared in this class or interface. */
  FieldDeclaration getField(string name) { result = getMember(name) }

  /** Gets a call signature declared in this interface. */
  CallSignature getACallSignature() { result = getAMember() }

  /** Gets an index signature declared in this interface. */
  IndexSignature getAnIndexSignature() { result = getAMember() }

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
  TypeExpr getASuperInterface() { result = getSuperInterface(_) }

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
}

/**
 * A class definition, that is, either a class declaration statement or a
 * class expression.
 */
class ClassDefinition extends @classdefinition, ClassOrInterface, AST::ValueNode {
  /** Gets the variable holding this class. */
  Variable getVariable() { result = getIdentifier().getVariable() }

  /** Gets the identifier naming the defined class, if any. */
  override VarDecl getIdentifier() { result = getChildExpr(0) }

  override TypeParameter getTypeParameter(int i) {
    // AST indices for type parameters: -3, -6, -9, ...
    exists(int astIndex | typeexprs(result, _, this, astIndex, _) |
      astIndex <= -3 and astIndex % 3 = 0 and i = -(astIndex + 3) / 3
    )
  }

  /** Gets the expression denoting the super class of the defined class, if any. */
  override Expr getSuperClass() { result = getChildExpr(1) }

  /** Gets the `n`th type from the `implements` clause of this class, starting at 0. */
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
  ConstructorDeclaration getConstructor() { result = getAMethod() }

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
  Decorator getADecorator() { result = getDecorator(_) }

  /**
   * Holds if this class has the `abstract` modifier.
   */
  override predicate isAbstract() { isAbstractClass(this) }

  override string describe() {
    if exists(inferNameFromVarDef())
    then result = inferNameFromVarDef()
    else result = "anonymous class"
  }

  /**
   * Gets a description of this class, based on its declared name or the name
   * of the variable it is assigned to, if any.
   */
  private string inferNameFromVarDef() {
    // in ambiguous cases like `let C = class D {}`, prefer `D` to `C`
    if exists(getIdentifier())
    then result = "class " + getIdentifier().getName()
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
    exists(MemberDefinition mem | mem = getMember(name) |
      result = mem.getInit() and
      not mem.isStatic() and
      not mem instanceof ConstructorDefinition
    )
  }

  /**
   * Gets the definition of the super class of this class, if it can be determined.
   */
  ClassDefinition getSuperClassDefinition() {
    result = getSuperClass().analyze().getAValue().(AbstractClass).getClass()
  }
}

/**
 * A class declaration statement.
 */
class ClassDeclStmt extends @classdeclstmt, ClassDefinition, Stmt {
  /** Gets the nearest enclosing function or toplevel in which this class declaration occurs. */
  override StmtContainer getContainer() { result = Stmt.super.getContainer() }

  override ControlFlowNode getFirstControlFlowNode() {
    if hasDeclareKeyword(this) then result = this else result = getIdentifier()
  }
}

/**
 * A class expression.
 */
class ClassExpr extends @classexpr, ClassDefinition, Expr {
  override string getName() {
    result = ClassDefinition.super.getName()
    or
    not exists(getIdentifier()) and
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

  /** Gets the nearest enclosing function or toplevel in which this class expression occurs. */
  override StmtContainer getContainer() { result = Expr.super.getContainer() }

  override ControlFlowNode getFirstControlFlowNode() {
    if exists(getIdentifier())
    then result = getIdentifier()
    else
      if exists(getSuperClass())
      then result = getSuperClass().getFirstControlFlowNode()
      else
        if exists(getClassInitializedMember())
        then
          result = min(ClassInitializedMember m |
              m = getClassInitializedMember()
            |
              m order by m.getIndex()
            )
        else result = this
  }

  /** Returns a member that is initialized during the creation of this class. */
  private ClassInitializedMember getClassInitializedMember() { result = getAMember() }
}

/** Members that are initialized at class creation time (as opposed to instance creation time). */
private class ClassInitializedMember extends MemberDeclaration {
  ClassInitializedMember() { this instanceof MethodDefinition or this.isStatic() }

  int getIndex() { properties(this, _, result, _, _) }
}

/**
 * A `super` expression.
 */
class SuperExpr extends @superexpr, Expr {
  override predicate isImpure() { none() }

  /**
   * Gets the function whose `super` binding this expression refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getBinder() { result = getEnclosingFunction().getThisBinder() }
}

/**
 * A `super(...)` call.
 */
class SuperCall extends CallExpr {
  SuperCall() { getCallee().getUnderlyingValue() instanceof SuperExpr }

  /**
   * Gets the function whose `super` binding this call refers to,
   * which is the nearest enclosing non-arrow function.
   */
  Function getBinder() { result = getCallee().getUnderlyingValue().(SuperExpr).getBinder() }
}

/**
 * A property access on `super`.
 */
class SuperPropAccess extends PropAccess {
  SuperPropAccess() { getBase().getUnderlyingValue() instanceof SuperExpr }
}

/**
 * A `new.target` expression.
 *
 * When a function `f` is invoked as `new f()`, then `new.target` inside
 * `f` evaluates to `f` ; on the other hand, when `f` is invoked without
 * `new`, it evaluates to `undefined`.
 *
 * See also ECMAScript 2015 Language Specification, Chapter 12.3.8.
 */
class NewTargetExpr extends @newtargetexpr, Expr {
  override predicate isImpure() { none() }
}

/**
 * A scope induced by a named class expression or class expression with type parameters.
 */
class ClassExprScope extends @classexprscope, Scope {
  override string toString() { result = "class expression scope" }
}

/**
 * A scope induced by a class declaration with type parameters.
 */
class ClassDeclScope extends @classdeclscope, Scope {
  override string toString() { result = "class declaration scope" }
}

/**
 * A member declaration in a class or interface, that is, either a method declaration or a field declaration.
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
  predicate isStatic() { isStatic(this) }

  /**
   * Holds if this member is abstract.
   *
   * Abstract members occur only in TypeScript.
   */
  predicate isAbstract() { isAbstractMember(this) }

  /**
   * Holds if this member is public, either because it has no access modifier or
   * because it is explicitly annotated as `public`.
   *
   * Class members not declared in a TypeScript file are always considered public.
   */
  predicate isPublic() { not isPrivate() and not isProtected() }

  /**
   * Holds if this is a TypeScript member explicitly annotated with the `public` keyword.
   */
  predicate hasPublicKeyword() { hasPublicKeyword(this) }

  /**
   * Holds if this is a TypeScript member annotated with the `private` keyword.
   */
  predicate isPrivate() { hasPrivateKeyword(this) }

  /**
   * Holds if this is a TypeScript member annotated with the `protected` keyword.
   */
  predicate isProtected() { hasProtectedKeyword(this) }

  /**
   * Gets the expression specifying the name of this member,
   * or nothing if this is a call signature.
   */
  Expr getNameExpr() { result = getChildExpr(0) }

  /**
   * Gets the expression specifying the initial value of the member;
   * for methods and constructors this is always a function, for fields
   * it may not be defined.
   */
  Expr getInit() { result = getChildExpr(1) }

  /** Gets the name of this member. */
  string getName() {
    result = getNameExpr().(Literal).getValue()
    or
    not isComputed() and result = getNameExpr().(Identifier).getName()
  }

  /** Holds if the name of this member is computed. */
  predicate isComputed() { isComputed(this) }

  /** Gets the class or interface this member belongs to. */
  ClassOrInterface getDeclaringType() { properties(this, result, _, _, _) }

  /** Gets the class this member belongs to, if any. */
  ClassDefinition getDeclaringClass() { properties(this, result, _, _, _) }

  /** Gets the nearest enclosing function or toplevel in which this member occurs. */
  StmtContainer getContainer() { result = getDeclaringType().getContainer() }

  /** Holds if the name of this member is computed by an impure expression. */
  predicate hasImpureNameExpr() { isComputed() and getNameExpr().isImpure() }

  /**
   * Gets the `i`th decorator applied to this member.
   *
   * For example, a method of the form `@A @B m() { ... }` has
   * `@A` as its 0th decorator and `@B` as its first decorator.
   */
  Decorator getDecorator(int i) { result = getChildExpr(-(i + 1)) }

  /**
   * Gets a decorator applied to this member.
   *
   * For example, a method of the form `@A @B m() { ... }` has
   * decorators `@A` and `@B`.
   */
  Decorator getADecorator() { result = getDecorator(_) }

  override string toString() { properties(this, _, _, _, result) }

  override ControlFlowNode getFirstControlFlowNode() {
    result = getNameExpr().getFirstControlFlowNode()
  }

  /**
   * True if this is neither abstract, ambient, nor part of an overloaded method signature.
   */
  predicate isConcrete() {
    not isAbstract() and
    not isAmbient() and
    (this instanceof MethodDeclaration implies this.(MethodDeclaration).getBody().hasBody())
  }

  /**
   * True if this is abstract, ambient, or an overload signature.
   */
  predicate isSignature() { not isConcrete() }
}

/**
 * A concrete member of a class, that is, a non-abstract, non-ambient field or method with a body.
 */
class MemberDefinition extends MemberDeclaration {
  MemberDefinition() { isConcrete() }
}

/**
 * A member signature declared in a class or interface, that is, an abstract or ambient field or method without a function body.
 */
class MemberSignature extends MemberDeclaration {
  MemberSignature() { isSignature() }
}

/**
 * A method declaration in a class or interface, either a concrete definition or a signature without a body.
 *
 * Note that TypeScript call signatures are not considered methods.
 */
class MethodDeclaration extends MemberDeclaration {
  MethodDeclaration() { isMethod(this) }

  /**
   * Gets the body of this method.
   */
  FunctionExpr getBody() { result = getChildExpr(1) }
}

/**
 * A concrete method definition in a class.
 */
class MethodDefinition extends MethodDeclaration, MemberDefinition { }

/**
 * A method signature declared in a class or interface, that is, a method without a function body.
 *
 * Note that TypeScript call signatures are not considered method signatures.
 */
class MethodSignature extends MethodDeclaration, MemberSignature { }

/**
 * A constructor declaration in a class, either a concrete definition or a signature without a body.
 */
class ConstructorDeclaration extends MethodDeclaration {
  ConstructorDeclaration() {
    not isComputed() and
    not isStatic() and
    getName() = "constructor"
  }

  /** Holds if this is a synthetic default constructor. */
  predicate isSynthetic() { getLocation().isEmpty() }
}

/**
 * The concrete constructor definition of a class, possibly a synthetic constructor if the class
 * did not declare any constructors.
 */
class ConstructorDefinition extends ConstructorDeclaration, MethodDefinition { }

/**
 * A constructor signature declared in a class, that is, a constructor without a function body.
 */
class ConstructorSignature extends ConstructorDeclaration, MethodSignature { }

/**
 * A function generated by the extractor to implement a synthetic default constructor.
 */
class SyntheticConstructor extends Function {
  SyntheticConstructor() { this = any(ConstructorDeclaration cd | cd.isSynthetic() | cd.getBody()) }
}

/**
 * An accessor method declaration in a class or interface, either a concrete definition or a signature without a body.
 */
abstract class AccessorMethodDeclaration extends MethodDeclaration { }

/**
 * A concrete accessor method definition in a class, that is, an accessor method with a function body.
 */
abstract class AccessorMethodDefinition extends MethodDefinition, AccessorMethodDeclaration { }

/**
 * An accessor method signature declared in a class or interface, that is, an accessor method without a function body.
 */
abstract class AccessorMethodSignature extends MethodSignature, AccessorMethodDeclaration { }

/**
 * A getter method declaration in a class or interface, either a concrete definition or a signature without a function body.
 */
class GetterMethodDeclaration extends AccessorMethodDeclaration, @property_getter { }

/**
 * A concrete getter method definition in a class, that is, a getter method with a function body.
 */
class GetterMethodDefinition extends GetterMethodDeclaration, AccessorMethodDefinition { }

/**
 * A getter method signature declared in a class or interface, that is, a getter method without a function body.
 */
class GetterMethodSignature extends GetterMethodDeclaration, AccessorMethodSignature { }

/**
 * A setter method declaration in a class or interface, either a concrete definition or a signature without a body.
 */
class SetterMethodDeclaration extends AccessorMethodDeclaration, @property_setter { }

/**
 * A concrete setter method definition in a class, that is, a setter method with a function body
 */
class SetterMethodDefinition extends SetterMethodDeclaration, AccessorMethodDefinition { }

/**
 * A setter method signature declared in a class or interface, that is, a setter method without a function body.
 */
class SetterMethodSignature extends SetterMethodDeclaration, AccessorMethodSignature { }

/**
 * A field declaration in a class or interface, either a concrete definition or an abstract or ambient field signature.
 */
class FieldDeclaration extends MemberDeclaration, @field {
  /** Gets the type annotation of this field, if any, such as `T` in `{ x: T }`. */
  TypeAnnotation getTypeAnnotation() {
    result = getChildTypeExpr(2)
    or
    result = getDocumentation().getATagByTitle("type").getType()
  }

  /** Holds if this is a TypeScript field annotated with the `readonly` keyword. */
  predicate isReadonly() { hasReadonlyKeyword(this) }

  /** Holds if this is a TypeScript field marked as optional with the `?` operator. */
  predicate isOptional() { isOptionalMember(this) }

  /** Holds if this is a TypeScript field marked as definitely assigned with the `!` operator. */
  predicate hasDefiniteAssignmentAssertion() { hasDefiniteAssignmentAssertion(this) }
}

/**
 * A concrete field definition in a class.
 */
class FieldDefinition extends FieldDeclaration, MemberDefinition { }

/**
 * A field signature declared in a class or interface, that is, an abstract or ambient field declaration.
 */
class FieldSignature extends FieldDeclaration, MemberSignature { }

/**
 * A field induced by an initializing constructor parameter, such as the field `x` in:
 * ```
 * class C {
 *   constructor(public x: number) {}
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

  override Expr getNameExpr() { result = getParameter() }

  override TypeAnnotation getTypeAnnotation() { result = getParameter().getTypeAnnotation() }
}

/**
 * A call signature declared in an interface, such as in:
 * ```
 * interface I {
 *   (x: number): number;
 *   new (x: string): Object;
 * }
 * ```
 *
 * Call signatures are either function call signatures or constructor call signatures.
 */
class CallSignature extends @call_signature, MemberSignature {
  FunctionExpr getBody() { result = getChildExpr(1) }

  /** Gets the interface or function type that declares this call signature. */
  override InterfaceDefinition getDeclaringType() {
    result = MemberSignature.super.getDeclaringType()
  }
}

/**
 * A function call signature declared in an interface, such as in:
 * ```
 * interface I { (x: number): string; }
 * ```
 */
class FunctionCallSignature extends @function_call_signature, CallSignature { }

/**
 * A constructor call signature declared in an interface, such as in:
 * ```
 * interface I { new (x: string): Object; }
 * ```
 */
class ConstructorCallSignature extends @constructor_call_signature, CallSignature { }

/**
 * An index signature declared in an interface, such as in:
 * ```
 * interface I {
 *   [x: number]: number;
 * }
 * ```
 */
class IndexSignature extends @index_signature, MemberSignature {
  FunctionExpr getBody() { result = getChildExpr(1) }

  /** Gets the interface or function type that declares this index signature. */
  override InterfaceDefinition getDeclaringType() {
    result = MemberSignature.super.getDeclaringType()
  }
}
