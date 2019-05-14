/**
 * Provides classes and predicates for working with members of Java classes and interfaces,
 * that is, methods, constructors, fields and nested types.
 */

import Element
import Type
import Annotation
import Exception
import metrics.MetricField
private import dispatch.VirtualDispatch

/**
 * A common abstraction for type member declarations,
 * including methods, constructors, fields, and nested types.
 */
class Member extends Element, Annotatable, Modifiable, @member {
  Member() { declaresMember(_, this) }

  /** Gets the type in which this member is declared. */
  RefType getDeclaringType() { declaresMember(result, this) }

  /** Gets the qualified name of this member. */
  string getQualifiedName() { result = getDeclaringType().getName() + "." + getName() }

  /** Holds if this member is package protected, that is, neither public nor private nor protected. */
  predicate isPackageProtected() {
    not isPrivate() and
    not isProtected() and
    not isPublic()
  }

  /**
   * Gets the immediately enclosing callable, if this member is declared in
   * an anonymous or local class.
   */
  Callable getEnclosingCallable() {
    exists(NestedClass nc | this.getDeclaringType() = nc |
      nc.(AnonymousClass).getClassInstanceExpr().getEnclosingCallable() = result or
      nc.(LocalClass).getLocalClassDeclStmt().getEnclosingCallable() = result
    )
  }
}

/** A callable is a method or constructor. */
class Callable extends StmtParent, Member, @callable {
  /**
   * Gets the declared return type of this callable (`void` for
   * constructors).
   */
  Type getReturnType() {
    constrs(this, _, _, result, _, _) or
    methods(this, _, _, result, _, _)
  }

  /**
   * Gets a callee that may be called from this callable.
   */
  Callable getACallee() { this.calls(result) }

  /** Gets the call site of a call from this callable to a callee. */
  Call getACallSite(Callable callee) {
    result.getCaller() = this and
    result.getCallee() = callee
  }

  /**
   * Gets the bytecode method descriptor, encoding parameter and return types,
   * but not the name of the callable.
   */
  string getMethodDescriptor() {
    exists(string return | return = this.getReturnType().getTypeDescriptor() |
      result = "(" + descriptorUpTo(this.getNumberOfParameters()) + ")" + return
    )
  }

  private string descriptorUpTo(int n) {
    n = 0 and result = ""
    or
    exists(Parameter p | p = this.getParameter(n - 1) |
      result = descriptorUpTo(n - 1) + p.getType().getTypeDescriptor()
    )
  }

  /** Holds if this callable calls `target`. */
  predicate calls(Callable target) { exists(getACallSite(target)) }

  /**
   * Holds if this callable calls `target`
   * using a `super(...)` constructor call.
   */
  predicate callsSuperConstructor(Constructor target) {
    getACallSite(target) instanceof SuperConstructorInvocationStmt
  }

  /**
   * Holds if this callable calls `target`
   * using a `this(...)` constructor call.
   */
  predicate callsThis(Constructor target) {
    getACallSite(target) instanceof ThisConstructorInvocationStmt
  }

  /**
   * Holds if this callable calls `target`
   * using a `super` method call.
   */
  predicate callsSuper(Method target) { getACallSite(target) instanceof SuperMethodAccess }

  /**
   * Holds if this callable calls `c` using
   * either a `super(...)` constructor call
   * or a `this(...)` constructor call.
   */
  predicate callsConstructor(Constructor c) { this.callsSuperConstructor(c) or this.callsThis(c) }

  /**
   * Holds if this callable may call the specified callable,
   * taking virtual dispatch into account.
   *
   * This includes both static call targets and dynamic dispatch targets.
   */
  predicate polyCalls(Callable m) {
    this.calls(m) or this.callsImpl(m)
  }

  /**
   * Holds if `c` is a viable implementation of a callable called by this
   * callable, taking virtual dispatch resolution into account.
   */
  predicate callsImpl(Callable c) {
    exists(Call call |
      call.getCaller() = this and
      viableCallable(call) = c
    )
  }

  /**
   * Holds if field `f` may be assigned a value
   * within the body of this callable.
   */
  predicate writes(Field f) { f.getAnAccess().(LValue).getEnclosingCallable() = this }

  /**
   * Holds if field `f` may be read
   * within the body of this callable.
   */
  predicate reads(Field f) { f.getAnAccess().(RValue).getEnclosingCallable() = this }

  /**
   * Holds if field `f` may be either read or written
   * within the body of this callable.
   */
  predicate accesses(Field f) { this.writes(f) or this.reads(f) }

  /**
   * Gets a field accessed in this callable.
   */
  Field getAnAccessedField() { this.accesses(result) }

  /** Gets the type of a formal parameter of this callable. */
  Type getAParamType() { result = getParameterType(_) }

  /** Holds if this callable does not have any formal parameters. */
  predicate hasNoParameters() { not exists(getAParameter()) }

  /** Gets the number of formal parameters of this callable. */
  int getNumberOfParameters() { result = count(getAParameter()) }

  /** Gets a formal parameter of this callable. */
  Parameter getAParameter() { result.getCallable() = this }

  /** Gets the formal parameter at the specified (zero-based) position. */
  Parameter getParameter(int n) { params(result, _, n, this, _) }

  /** Gets the type of the formal parameter at the specified (zero-based) position. */
  Type getParameterType(int n) { params(_, result, n, this, _) }

  /**
   * Gets the signature of this callable, including its name and the types of all its parameters,
   * identified by their simple (unqualified) names.
   *
   * Use `getSignature` to obtain a signature including fully qualified type names.
   */
  string getStringSignature() { result = this.getName() + this.paramsString() }

  /** Gets a parenthesized string containing all parameter types of this callable, separated by a comma. */
  pragma[nomagic]
  string paramsString() {
    exists(int n | n = getNumberOfParameters() |
      n = 0 and result = "()"
      or
      n > 0 and result = "(" + this.paramUpTo(n - 1) + ")"
    )
  }

  /**
   * Gets a string containing the parameter types of this callable
   * from left to right, up to (and including) the `n`-th parameter.
   */
  private string paramUpTo(int n) {
    n = 0 and result = getParameterType(0).toString()
    or
    n > 0 and result = paramUpTo(n - 1) + ", " + getParameterType(n)
  }

  /** Holds if this callable has the specified string signature. */
  predicate hasStringSignature(string sig) { sig = this.getStringSignature() }

  /** Gets an exception that occurs in the `throws` clause of this callable. */
  Exception getAnException() { exceptions(result, _, this) }

  /** Gets an exception type that occurs in the `throws` clause of this callable. */
  RefType getAThrownExceptionType() { result = getAnException().getType() }

  /** Gets a call site that references this callable. */
  Call getAReference() { result.getCallee() = this }

  /** Gets the body of this callable, if any. */
  Block getBody() { result.getParent() = this }

  /**
   * Gets the source declaration of this callable.
   *
   * For parameterized instances of generic methods, the
   * source declaration is the corresponding generic method.
   *
   * For non-parameterized callables declared inside a parameterized
   * instance of a generic type, the source declaration is the
   * corresponding callable in the generic type.
   *
   * For all other callables, the source declaration is the callable itself.
   */
  Callable getSourceDeclaration() { result = this }

  /** Holds if this callable is the same as its source declaration. */
  predicate isSourceDeclaration() { this.getSourceDeclaration() = this }

  /** Cast this callable to a class that provides access to metrics information. */
  MetricCallable getMetrics() { result = this }

  /** Holds if the last parameter of this callable is a varargs (variable arity) parameter. */
  predicate isVarargs() { this.getAParameter().isVarargs() }

  /**
   * Gets the signature of this callable, where all types in the signature have a fully-qualified name.
   *
   * For example, method `void m(String s)` has the signature `m(java.lang.String)`.
   */
  string getSignature() {
    constrs(this, _, result, _, _, _) or
    methods(this, _, result, _, _, _)
  }
}

/** Holds if method `m1` overrides method `m2`. */
private predicate overrides(Method m1, Method m2) {
  exists(RefType t1, RefType t2 | overridesIgnoringAccess(m1, t1, m2, t2) |
    m2.isPublic()
    or
    m2.isProtected()
    or
    m2.isPackageProtected() and t1.getPackage() = t2.getPackage()
  )
}

/**
 * Auxiliary predicate: whether method `m1` overrides method `m2`,
 * ignoring any access modifiers. Additionally, this predicate binds
 * `t1` to the type declaring `m1` and `t2` to the type declaring `m2`.
 */
pragma[noopt]
predicate overridesIgnoringAccess(Method m1, RefType t1, Method m2, RefType t2) {
  exists(string sig |
    virtualMethodWithSignature(sig, t1, m1) and
    t1.extendsOrImplements+(t2) and
    virtualMethodWithSignature(sig, t2, m2)
  )
}

private predicate virtualMethodWithSignature(string sig, RefType t, Method m) {
  methods(m, _, _, _, t, _) and
  sig = m.getSignature() and
  m.isVirtual()
}

private predicate potentialInterfaceImplementationWithSignature(string sig, RefType t, Method impl) {
  t.hasMethod(impl, _) and
  sig = impl.getSignature() and
  impl.isVirtual() and
  impl.isPublic() and
  not t instanceof Interface and
  not t.isAbstract()
}

pragma[nomagic]
private predicate implementsInterfaceMethod(SrcMethod impl, SrcMethod m) {
  exists(RefType t, Interface i, Method minst, Method implinst |
    m = minst.getSourceDeclaration() and
    i = minst.getDeclaringType() and
    t.extendsOrImplements+(i) and
    t.isSourceDeclaration() and
    potentialInterfaceImplementationWithSignature(minst.getSignature(), t, implinst) and
    impl = implinst.getSourceDeclaration()
  )
}

/** A method is a particular kind of callable. */
class Method extends Callable, @method {
  /** Holds if this method (directly) overrides the specified callable. */
  predicate overrides(Method m) { overrides(this, m) }

  /**
   * Holds if this method either overrides `m`, or `m` is the
   * source declaration of this method (and not equal to it).
   */
  predicate overridesOrInstantiates(Method m) {
    this.overrides(m)
    or
    this.getSourceDeclaration() = m and this != m
  }

  /** Gets a method (directly or transitively) overridden by this method. */
  Method getAnOverride() { this.overrides+(result) }

  /** Gets the source declaration of a method overridden by this method. */
  SrcMethod getASourceOverriddenMethod() {
    exists(Method m | this.overrides(m) and result = m.getSourceDeclaration())
  }

  override string getSignature() { methods(this, _, result, _, _, _) }

  /**
   * Holds if this method and method `m` are declared in the same type
   * and have the same parameter types.
   */
  predicate sameParamTypes(Method m) {
    // `this` and `m` are different methods,
    this != m and
    // `this` and `m` are declared in the same type,
    this.getDeclaringType() = m.getDeclaringType() and
    // `this` and `m` are of the same arity, and
    this.getNumberOfParameters() = m.getNumberOfParameters() and
    // there does not exist a pair of parameters whose types differ.
    not exists(int n | this.getParameterType(n) != m.getParameterType(n))
  }

  override SrcMethod getSourceDeclaration() { methods(this, _, _, _, _, result) }

  /**
   * All the methods that could possibly be called when this method
   * is called. For class methods this includes the method itself and all its
   * overriding methods (if any), and for interface methods this includes
   * matching methods defined on or inherited by implementing classes.
   *
   * Only includes method implementations, not abstract or non-default interface methods.
   * Native methods are included, since they have an implementation (just not in Java).
   */
  SrcMethod getAPossibleImplementation() {
    this.getSourceDeclaration().getAPossibleImplementationOfSrcMethod() = result
  }

  override MethodAccess getAReference() { result = Callable.super.getAReference() }

  override predicate isPublic() {
    Callable.super.isPublic() or
    // JLS 9.4: Every method declaration in the body of an interface is implicitly public.
    getDeclaringType() instanceof Interface or
    exists(FunctionalExpr func | func.asMethod() = this)
  }

  override predicate isAbstract() {
    Callable.super.isAbstract()
    or
    // JLS 9.4: An interface method lacking a `default` modifier or a `static` modifier
    // is implicitly abstract.
    this.getDeclaringType() instanceof Interface and
    not this.isDefault() and
    not this.isStatic()
  }

  override predicate isStrictfp() {
    Callable.super.isStrictfp()
    or
    // JLS 8.1.1.3, JLS 9.1.1.2
    getDeclaringType().isStrictfp()
  }

  /**
   * Holds if this method is neither private nor a static interface method
   * nor an initializer method, and hence could be inherited.
   */
  predicate isInheritable() {
    not isPrivate() and
    not (isStatic() and getDeclaringType() instanceof Interface) and
    not this instanceof InitializerMethod
  }

  /**
   * Holds if this method is neither private nor static, and hence
   * uses dynamic dispatch.
   */
  predicate isVirtual() { not isPrivate() and not isStatic() }

  /** Holds if this method can be overridden. */
  predicate isOverridable() {
    isVirtual() and
    not isFinal() and
    not getDeclaringType().isFinal()
  }
}

/** A method that is the same as its source declaration. */
class SrcMethod extends Method {
  SrcMethod() { methods(_, _, _, _, _, this) }

  /**
   * All the methods that could possibly be called when this method
   * is called. For class methods this includes the method itself and all its
   * overriding methods (if any), and for interface methods this includes
   * matching methods defined on or inherited by implementing classes.
   *
   * Only includes method implementations, not abstract or non-default interface methods.
   * Native methods are included, since they have an implementation (just not in Java).
   */
  SrcMethod getAPossibleImplementationOfSrcMethod() {
    (
      if this.getDeclaringType() instanceof Interface and this.isVirtual()
      then implementsInterfaceMethod(result, this)
      else result.getASourceOverriddenMethod*() = this
    ) and
    (exists(result.getBody()) or result.hasModifier("native"))
  }
}

/**
 * A _setter_ method is a method with the following properties:
 *
 * - it has exactly one parameter,
 * - its body contains exactly one statement
 *   that assigns the value of the method parameter to a field
 *   declared in the same type as the method.
 */
class SetterMethod extends Method {
  SetterMethod() {
    this.getNumberOfParameters() = 1 and
    exists(ExprStmt s, Assignment a |
      s = this.getBody().(SingletonBlock).getStmt() and a = s.getExpr()
    |
      exists(Field f | f.getDeclaringType() = this.getDeclaringType() |
        a.getDest() = f.getAnAccess() and
        a.getSource() = this.getAParameter().getAnAccess()
      )
    )
  }

  /** Gets the field assigned by this setter method. */
  Field getField() {
    exists(Assignment a | a.getEnclosingCallable() = this | a.getDest() = result.getAnAccess())
  }
}

/**
 * A _getter_ method is a method with the following properties:
 *
 * - it has no parameters,
 * - its body contains exactly one statement
 *   that returns the value of a field.
 */
class GetterMethod extends Method {
  GetterMethod() {
    this.hasNoParameters() and
    exists(ReturnStmt s, Field f | s = this.getBody().(SingletonBlock).getStmt() |
      s.getResult() = f.getAnAccess()
    )
  }

  /** Gets the field whose value is returned by this getter method. */
  Field getField() {
    exists(ReturnStmt r | r.getEnclosingCallable() = this | r.getResult() = result.getAnAccess())
  }
}

/**
 * A finalizer method, with name `finalize`,
 * return type `void` and modifier `protected`.
 */
class FinalizeMethod extends Method {
  FinalizeMethod() {
    this.hasName("finalize") and
    this.getReturnType().hasName("void") and
    this.isProtected()
  }
}

/** A constructor is a particular kind of callable. */
class Constructor extends Callable, @constructor {
  /** Holds if this is a default constructor, not explicitly declared in source code. */
  predicate isDefaultConstructor() { isDefConstr(this) }

  override Constructor getSourceDeclaration() { constrs(this, _, _, _, _, result) }

  override string getSignature() { constrs(this, _, result, _, _, _) }
}

/**
 * A compiler-generated initializer method (could be static or
 * non-static), which is used to hold (static or non-static) field
 * initializers, as well as explicit initializer blocks.
 */
abstract class InitializerMethod extends Method { }

/**
 * A static initializer is a method that contains all static
 * field initializations and static initializer blocks.
 */
class StaticInitializer extends InitializerMethod {
  StaticInitializer() { hasName("<clinit>") }
}

/**
 * An instance initializer is a method that contains field initializations
 * and explicit instance initializer blocks.
 */
class InstanceInitializer extends InitializerMethod {
  InstanceInitializer() { this.hasName("<obinit>") }
}

/** A field declaration that declares one or more class or instance fields. */
class FieldDeclaration extends ExprParent, @fielddecl, Annotatable {
  /** Gets the access to the type of the field(s) in this declaration. */
  Expr getTypeAccess() { result.getParent() = this }

  /** Gets a field declared in this declaration. */
  Field getAField() { fieldDeclaredIn(result, this, _) }

  /** Gets the field declared at the specified (zero-based) position in this declaration */
  Field getField(int idx) { fieldDeclaredIn(result, this, idx) }

  /** Gets the number of fields declared in this declaration. */
  int getNumField() { result = max(int idx | fieldDeclaredIn(_, this, idx) | idx) + 1 }

  override string toString() {
    if this.getNumField() = 0
    then result = this.getTypeAccess() + " " + this.getField(0) + ";"
    else result = this.getTypeAccess() + " " + this.getField(0) + ", ...;"
  }
}

/** A class or instance field. */
class Field extends Member, ExprParent, @field, Variable {
  /** Gets the declared type of this field. */
  override Type getType() { fields(this, _, result, _, _) }

  /** Gets the type in which this field is declared. */
  override RefType getDeclaringType() { fields(this, _, _, result, _) }

  /**
   * Gets the field declaration in which this field is declared.
   *
   * Note that this declaration is only available if the field occurs in source code.
   */
  FieldDeclaration getDeclaration() { result.getAField() = this }

  /** Gets the initializer expression of this field, if any. */
  override Expr getInitializer() {
    exists(AssignExpr e, InitializerMethod im |
      e.getDest() = this.getAnAccess() and
      e.getSource() = result and
      result.getEnclosingCallable() = im and
      // This rules out updates in explicit initializer blocks as they are nested inside the compiler generated initializer blocks.
      e.getEnclosingStmt().getParent() = im.getBody()
    )
  }

  /**
   * Gets the source declaration of this field.
   *
   * For fields that are members of a parameterized
   * instance of a generic type, the source declaration is the
   * corresponding field in the generic type.
   *
   * For all other fields, the source declaration is the field itself.
   */
  Field getSourceDeclaration() { fields(this, _, _, _, result) }

  /** Holds if this field is the same as its source declaration. */
  predicate isSourceDeclaration() { this.getSourceDeclaration() = this }

  override predicate isPublic() {
    Member.super.isPublic()
    or
    // JLS 9.3: Every field declaration in the body of an interface is
    // implicitly public, static, and final
    getDeclaringType() instanceof Interface
  }

  override predicate isStatic() {
    Member.super.isStatic()
    or
    // JLS 9.3: Every field declaration in the body of an interface is
    // implicitly public, static, and final
    this.getDeclaringType() instanceof Interface
  }

  override predicate isFinal() {
    Member.super.isFinal()
    or
    // JLS 9.3: Every field declaration in the body of an interface is
    // implicitly public, static, and final
    this.getDeclaringType() instanceof Interface
  }

  /** Cast this field to a class that provides access to metrics information. */
  MetricField getMetrics() { result = this }
}

/** An instance field. */
class InstanceField extends Field {
  InstanceField() { not this.isStatic() }
}
