/**
 * Provides classes for methods.
 *
 * Methods and implementations are different because there can be several implementations for the same
 * method in different assemblies. It is not really possible to guarantee which methods will be loaded
 * at run-time.
 */

private import CIL
private import dotnet

/**
 * An implementation of a method in an assembly.
 */
class MethodImplementation extends EntryPoint, @cil_method_implementation {
  /** Gets the method of this implementation. */
  Method getMethod() { cil_method_implementation(this, result, _) }

  override MethodImplementation getImplementation() { result = this }

  /** Gets the location of this implementation. */
  Assembly getLocation() { cil_method_implementation(this, _, result) }

  /** Gets the instruction at index `index`. */
  Instruction getInstruction(int index) { cil_instruction(result, _, index, this) }

  /** Gets the `n`th local variable of this implementation. */
  LocalVariable getLocalVariable(int n) { cil_local_variable(result, this, n, _) }

  /** Gets a local variable of this implementation, if any. */
  LocalVariable getALocalVariable() { result = getLocalVariable(_) }

  /** Gets an instruction in this implementation, if any. */
  Instruction getAnInstruction() { result = getInstruction(_) }

  /** Gets the total number of instructions in this implementation. */
  int getNumberOfInstructions() { result = count(getAnInstruction()) }

  /** Gets the `i`th handler in this implementation. */
  Handler getHandler(int i) { result.getImplementation() = this and result.getIndex() = i }

  /** Gets a handler in this implementation, if any. */
  Handler getAHandler() { result.getImplementation() = this }

  override Instruction getASuccessorType(FlowType t) {
    t instanceof NormalFlow and result.getImplementation() = this and result.getIndex() = 0
  }

  /** Gets the maximum stack size of this implementation. */
  int getStackSize() { cil_method_stack_size(this, result) }

  override string toString() { result = getMethod().toString() }

  /** Gets a string representing the disassembly of this implementation. */
  string getDisassembly() {
    result =
      concat(Instruction i |
        i = this.getAnInstruction()
      |
        i.toStringExtra(), ", " order by i.getIndex()
      )
  }
}

/**
 * A method, which corresponds to any callable in C#, including constructors,
 * destructors, operators, accessors and so on.
 */
class Method extends DotNet::Callable, Element, Member, TypeContainer, DataFlowNode, @cil_method {
  /**
   * Gets a method implementation, if any. Note that there can
   * be several implementations in different assemblies.
   */
  MethodImplementation getAnImplementation() { result.getMethod() = this }

  /** Gets the "best" implementation of this method, if any. */
  BestImplementation getImplementation() { result = getAnImplementation() }

  override Method getMethod() { result = this }

  override string getName() { cil_method(this, result, _, _) }

  override string toString() { result = this.getName() }

  override Type getDeclaringType() { cil_method(this, _, result, _) }

  override Location getLocation() { result = Element.super.getLocation() }

  override Location getALocation() { cil_method_location(this.getSourceDeclaration(), result) }

  override Parameter getRawParameter(int n) { cil_parameter(result, this, n, _) }

  override Parameter getParameter(int n) {
    if isStatic() then result = getRawParameter(n) else (result = getRawParameter(n + 1) and n >= 0)
  }

  override Type getType() { result = getReturnType() }

  /** Gets the return type of this method. */
  override Type getReturnType() { cil_method(this, _, _, result) }

  /** Holds if the return type is `void`. */
  predicate returnsVoid() { getReturnType() instanceof VoidType }

  /** Gets the number of stack items pushed in a call to this method. */
  int getCallPushCount() { if returnsVoid() then result = 0 else result = 1 }

  /** Gets the number of stack items popped in a call to this method. */
  int getCallPopCount() { result = count(getRawParameter(_)) }

  /** Gets a method called by this method. */
  Method getACallee() { result = getImplementation().getAnInstruction().(Call).getTarget() }

  /** Holds if this method is `virtual`. */
  predicate isVirtual() { cil_virtual(this) }

  /** Holds if the name of this method is special, for example an operator. */
  predicate isSpecial() { cil_specialname(this) }

  /** Holds of this method is marked as secure. */
  predicate isSecureObject() { cil_requiresecobject(this) }

  /** Holds if the method does not override an existing method. */
  predicate isNew() { cil_newslot(this) }

  override predicate isStatic() { cil_static(this) }

  /** Gets the unbound declaration of this method, or the method itself. */
  Method getUnboundMethod() { cil_method_source_declaration(this, result) }

  override Method getSourceDeclaration() { result = getUnboundMethod() }

  /** Holds if this method is an instance constructor. */
  predicate isInstanceConstructor() { isSpecial() and getName() = ".ctor" }

  /** Holds if this method is a static class constructor. */
  predicate isStaticConstructor() { isSpecial() and getName() = ".cctor" }

  /** Holds if this method is a constructor (static or instance). */
  predicate isConstructor() { isStaticConstructor() or isInstanceConstructor() }

  /** Holds if this method is a destructor/finalizer. */
  predicate isFinalizer() { getOverriddenMethod*().getQualifiedName() = "System.Object.Finalize" }

  /** Holds if this method is an operator. */
  predicate isOperator() { isSpecial() and getName().matches("op\\_%") }

  /** Holds if this method is a getter. */
  predicate isGetter() { isSpecial() and getName().matches("get\\_%") }

  /** Holds if this method is a setter. */
  predicate isSetter() { isSpecial() and getName().matches("set\\_%") }

  /** Holds if this method is an adder/add event accessor. */
  predicate isAdder() { isSpecial() and getName().matches("add\\_%") }

  /** Holds if this method is a remover/remove event accessor. */
  predicate isRemove() { isSpecial() and getName().matches("remove\\_%") }

  /** Holds if this method is an implicit conversion operator. */
  predicate isImplicitConversion() { isSpecial() and getName() = "op_Implicit" }

  /** Holds if this method is an explicit conversion operator. */
  predicate isExplicitConversion() { isSpecial() and getName() = "op_Explicit" }

  /** Holds if this method is a conversion operator. */
  predicate isConversion() { isImplicitConversion() or isExplicitConversion() }

  /**
   * Gets a method that is overridden, either in a base class
   * or in an interface.
   */
  Method getOverriddenMethod() { cil_implements(this, result) }

  /** Gets a method that overrides this method, if any. */
  final Method getAnOverrider() { result.getOverriddenMethod() = this }

  override predicate hasBody() { exists(getImplementation()) }

  override predicate canReturn(DotNet::Expr expr) {
    exists(Return ret | ret.getImplementation() = this.getImplementation() and expr = ret.getExpr())
  }
}

/** A destructor/finalizer. */
class Destructor extends Method, DotNet::Destructor {
  Destructor() { this.isFinalizer() }
}

/** A constructor. */
class Constructor extends Method, DotNet::Constructor {
  Constructor() { this.isConstructor() }
}

/** A static/class constructor. */
class StaticConstructor extends Constructor {
  StaticConstructor() { this.isStaticConstructor() }
}

/** An instance constructor. */
class InstanceConstructor extends Constructor {
  InstanceConstructor() { this.isInstanceConstructor() }
}

/** A method that always returns the `this` parameter. */
class ChainingMethod extends Method {
  ChainingMethod() {
    forex(Return ret | ret = getImplementation().getAnInstruction() |
      ret.getExpr() instanceof ThisAccess
    )
  }
}

/** An accessor. */
abstract class Accessor extends Method {
  /** Gets the property declaring this accessor. */
  abstract Property getProperty();
}

/** A getter. */
class Getter extends Accessor {
  Getter() { cil_getter(_, this) }

  override Property getProperty() { cil_getter(result, this) }
}

/**
 * A method that does nothing but retrieve a field.
 * Note that this is not necessarily a property getter.
 */
class TrivialGetter extends Method {
  TrivialGetter() {
    exists(MethodImplementation impl | impl = getAnImplementation() |
      impl.getInstruction(0) instanceof ThisAccess and
      impl.getInstruction(1) instanceof FieldReadAccess and
      impl.getInstruction(2) instanceof Return
    )
  }

  /** Gets the underlying field of this getter. */
  Field getField() { getImplementation().getAnInstruction().(FieldReadAccess).getTarget() = result }
}

/** A setter. */
class Setter extends Accessor {
  Setter() { cil_setter(_, this) }

  override Property getProperty() { cil_setter(result, this) }
}

/**
 * A method that does nothing but set a field.
 * This is not necessarily a property setter.
 */
class TrivialSetter extends Method {
  TrivialSetter() {
    exists(MethodImplementation impl | impl = getImplementation() |
      impl.getInstruction(0) instanceof ThisAccess and
      impl.getInstruction(1).(ParameterReadAccess).getTarget().getIndex() = 1 and
      impl.getInstruction(2) instanceof FieldWriteAccess
    )
  }

  /** Gets the underlying field of this setter. */
  Field getField() {
    result = getImplementation().getAnInstruction().(FieldWriteAccess).getTarget()
  }
}

/** An alias for `Method` for compatibility with the C# data model. */
class Callable = Method;

/** An operator. */
class Operator extends Method {
  Operator() { this.isOperator() }

  /** Gets the name of the implementing method (for compatibility with C# data model). */
  string getFunctionName() { result = getName() }
}
