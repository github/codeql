/**
 * Provides C++-specific definitions for use in the data flow library.
 */

private import cpp
// The `ValueNumbering` library has to be imported right after `cpp` to ensure
// that the cached IR gets the same checksum here as it does in queries that use
// `ValueNumbering` without `DataFlow`.
private import semmle.code.cpp.ir.ValueNumbering
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.controlflow.IRGuards
private import semmle.code.cpp.models.interfaces.DataFlow

private newtype TIRDataFlowNode =
  TInstructionNode(Instruction i) or
  TVariableNode(Variable var) or
  TStoreNode(StoreChain chain) or
  TLoadNode(LoadChain load)

/**
 * A node in a data flow graph.
 *
 * A node can be either an expression, a parameter, or an uninitialized local
 * variable. Such nodes are created with `DataFlow::exprNode`,
 * `DataFlow::parameterNode`, and `DataFlow::uninitializedNode` respectively.
 */
class Node extends TIRDataFlowNode {
  /**
   * INTERNAL: Do not use.
   */
  Declaration getEnclosingCallable() { none() } // overridden in subclasses

  /** Gets the function to which this node belongs, if any. */
  Function getFunction() { none() } // overridden in subclasses

  /** Gets the type of this node. */
  Type getType() { none() } // overridden in subclasses

  /** Gets the instruction corresponding to this node, if any. */
  Instruction asInstruction() { result = this.(InstructionNode).getInstruction() }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `asConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr asExpr() { result = this.(ExprNode).getExpr() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr asConvertedExpr() { result = this.(ExprNode).getConvertedExpr() }

  /** Gets the argument that defines this `DefinitionByReferenceNode`, if any. */
  Expr asDefiningArgument() { result = this.(DefinitionByReferenceNode).getArgument() }

  /** Gets the positional parameter corresponding to this node, if any. */
  Parameter asParameter() { result = this.(ExplicitParameterNode).getParameter() }

  /**
   * Gets the variable corresponding to this node, if any. This can be used for
   * modelling flow in and out of global variables.
   */
  Variable asVariable() { result = this.(VariableNode).getVariable() }

  /**
   * Gets the expression that is partially defined by this node, if any.
   *
   * Partial definitions are created for field stores (`x.y = taint();` is a partial
   * definition of `x`), and for calls that may change the value of an object (so
   * `x.set(taint())` is a partial definition of `x`, and `transfer(&x, taint())` is
   * a partial definition of `&x`).
   */
  Expr asPartialDefinition() { result = this.(PartialDefinitionNode).getDefinedExpr() }

  /**
   * DEPRECATED: See UninitializedNode.
   *
   * Gets the uninitialized local variable corresponding to this node, if
   * any.
   */
  LocalVariable asUninitialized() { none() }

  /**
   * Gets an upper bound on the type of this node.
   */
  Type getTypeBound() { result = getType() }

  /** Gets the location of this element. */
  Location getLocation() { none() } // overridden by subclasses

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /** Gets a textual representation of this element. */
  string toString() { none() } // overridden by subclasses
}

/**
 * An instruction, viewed as a node in a data flow graph.
 */
class InstructionNode extends Node, TInstructionNode {
  Instruction instr;

  InstructionNode() { this = TInstructionNode(instr) }

  /** Gets the instruction corresponding to this node. */
  Instruction getInstruction() { result = instr }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = instr.getEnclosingFunction() }

  override Type getType() { result = instr.getResultType() }

  override Location getLocation() { result = instr.getLocation() }

  override string toString() {
    // This predicate is overridden in subclasses. This default implementation
    // does not use `Instruction.toString` because that's expensive to compute.
    result = this.getInstruction().getOpcode().toString()
  }
}

/**
 * An expression, viewed as a node in a data flow graph.
 */
class ExprNode extends InstructionNode {
  ExprNode() { exists(instr.getConvertedResultExpression()) }

  /**
   * Gets the non-conversion expression corresponding to this node, if any. If
   * this node strictly (in the sense of `getConvertedExpr`) corresponds to a
   * `Conversion`, then the result is that `Conversion`'s non-`Conversion` base
   * expression.
   */
  Expr getExpr() { result = instr.getUnconvertedResultExpression() }

  /**
   * Gets the expression corresponding to this node, if any. The returned
   * expression may be a `Conversion`.
   */
  Expr getConvertedExpr() { result = instr.getConvertedResultExpression() }

  override string toString() { result = this.asConvertedExpr().toString() }
}

/**
 * INTERNAL: do not use. Translates a parameter/argument index into a negative
 * number that denotes the index of its side effect (pointer indirection).
 */
bindingset[index]
int getArgumentPosOfSideEffect(int index) {
  // -1 -> -2
  //  0 -> -3
  //  1 -> -4
  // ...
  result = -3 - index
}

/**
 * The value of a parameter at function entry, viewed as a node in a data
 * flow graph. This includes both explicit parameters such as `x` in `f(x)`
 * and implicit parameters such as `this` in `x.f()`.
 *
 * To match a specific kind of parameter, consider using one of the subclasses
 * `ExplicitParameterNode`, `ThisParameterNode`, or
 * `ParameterIndirectionNode`.
 */
class ParameterNode extends InstructionNode {
  ParameterNode() {
    // To avoid making this class abstract, we enumerate its values here
    instr instanceof InitializeParameterInstruction
    or
    instr instanceof InitializeIndirectionInstruction
  }

  /**
   * Holds if this node is the parameter of `f` at the specified position. The
   * implicit `this` parameter is considered to have position `-1`, and
   * pointer-indirection parameters are at further negative positions.
   */
  predicate isParameterOf(Function f, int pos) { none() } // overridden by subclasses
}

/** An explicit positional parameter, not including `this` or `...`. */
private class ExplicitParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ExplicitParameterNode() { exists(instr.getParameter()) }

  override predicate isParameterOf(Function f, int pos) {
    f.getParameter(pos) = instr.getParameter()
  }

  /** Gets the `Parameter` associated with this node. */
  Parameter getParameter() { result = instr.getParameter() }

  override string toString() { result = instr.getParameter().toString() }
}

/** An implicit `this` parameter. */
class ThisParameterNode extends ParameterNode {
  override InitializeParameterInstruction instr;

  ThisParameterNode() { instr.getIRVariable() instanceof IRThisVariable }

  override predicate isParameterOf(Function f, int pos) {
    pos = -1 and instr.getEnclosingFunction() = f
  }

  override string toString() { result = "this" }
}

/** A synthetic parameter to model the pointed-to object of a pointer parameter. */
class ParameterIndirectionNode extends ParameterNode {
  override InitializeIndirectionInstruction instr;

  override predicate isParameterOf(Function f, int pos) {
    exists(int index |
      f.getParameter(index) = instr.getParameter()
      or
      index = -1 and
      instr.getIRVariable().(IRThisVariable).getEnclosingFunction() = f
    |
      pos = getArgumentPosOfSideEffect(index)
    )
  }

  override string toString() { result = "*" + instr.getIRVariable().toString() }
}

/**
 * DEPRECATED: Data flow was never an accurate way to determine what
 * expressions might be uninitialized. It errs on the side of saying that
 * everything is uninitialized, and this is even worse in the IR because the IR
 * doesn't use syntactic hints to rule out variables that are definitely
 * initialized.
 *
 * The value of an uninitialized local variable, viewed as a node in a data
 * flow graph.
 */
deprecated class UninitializedNode extends Node {
  UninitializedNode() { none() }

  LocalVariable getLocalVariable() { none() }
}

/**
 * A node associated with an object after an operation that might have
 * changed its state.
 *
 * This can be either the argument to a callable after the callable returns
 * (which might have mutated the argument), or the qualifier of a field after
 * an update to the field.
 *
 * Nodes corresponding to AST elements, for example `ExprNode`, usually refer
 * to the value before the update with the exception of `ClassInstanceExpr`,
 * which represents the value after the constructor has run.
 *
 * This class exists to match the interface used by Java. There are currently no non-abstract
 * classes that extend it. When we implement field flow, we can revisit this.
 */
abstract class PostUpdateNode extends Node {
  /**
   * Gets the node before the state update.
   */
  abstract Node getPreUpdateNode();
}

/**
 * The base class for nodes that perform "partial definitions".
 *
 * In contrast to a normal "definition", which provides a new value for
 * something, a partial definition is an expression that may affect a
 * value, but does not necessarily replace it entirely. For example:
 * ```
 * x.y = 1; // a partial definition of the object `x`.
 * x.y.z = 1; // a partial definition of the objects `x.y` and `x`.
 * x.setY(1); // a partial definition of the object `x`.
 * setY(&x); // a partial definition of the object `x`.
 * ```
 */
abstract private class PartialDefinitionNode extends PostUpdateNode {
  abstract Expr getDefinedExpr();
}

/**
 * A node that represents the value of a variable after a function call that
 * may have changed the variable because it's passed by reference.
 *
 * A typical example would be a call `f(&x)`. Firstly, there will be flow into
 * `x` from previous definitions of `x`. Secondly, there will be a
 * `DefinitionByReferenceNode` to represent the value of `x` after the call has
 * returned. This node will have its `getArgument()` equal to `&x` and its
 * `getVariableAccess()` equal to `x`.
 */
class DefinitionByReferenceNode extends InstructionNode {
  override WriteSideEffectInstruction instr;

  /** Gets the argument corresponding to this node. */
  Expr getArgument() {
    result =
      instr
          .getPrimaryInstruction()
          .(CallInstruction)
          .getPositionalArgument(instr.getIndex())
          .getUnconvertedResultExpression()
    or
    result =
      instr
          .getPrimaryInstruction()
          .(CallInstruction)
          .getThisArgument()
          .getUnconvertedResultExpression() and
    instr.getIndex() = -1
  }

  /** Gets the parameter through which this value is assigned. */
  Parameter getParameter() {
    exists(CallInstruction ci | result = ci.getStaticCallTarget().getParameter(instr.getIndex()))
  }

  override string toString() {
    // This string should be unique enough to be helpful but common enough to
    // avoid storing too many different strings.
    result =
      instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget().getName() +
        " output argument"
    or
    not exists(instr.getPrimaryInstruction().(CallInstruction).getStaticCallTarget()) and
    result = "output argument"
  }
}

/**
 * A node representing the memory pointed to by a function argument.
 *
 * This class exists only in order to override `toString`, which would
 * otherwise be the default implementation inherited from `InstructionNode`.
 */
private class ArgumentIndirectionNode extends InstructionNode {
  override ReadSideEffectInstruction instr;

  override string toString() { result = "Argument " + instr.getIndex() + " indirection" }
}

/**
 * A `Node` corresponding to a variable in the program, as opposed to the
 * value of that variable at some particular point. This can be used for
 * modelling flow in and out of global variables.
 */
class VariableNode extends Node, TVariableNode {
  Variable v;

  VariableNode() { this = TVariableNode(v) }

  /** Gets the variable corresponding to this node. */
  Variable getVariable() { result = v }

  override Function getFunction() { none() }

  override Declaration getEnclosingCallable() {
    // When flow crosses from one _enclosing callable_ to another, the
    // interprocedural data-flow library discards call contexts and inserts a
    // node in the big-step relation used for human-readable path explanations.
    // Therefore we want a distinct enclosing callable for each `VariableNode`,
    // and that can be the `Variable` itself.
    result = v
  }

  override Type getType() { result = v.getType() }

  override Location getLocation() { result = v.getLocation() }

  override string toString() { result = v.toString() }
}

/** The target node of a `readStep`. */
abstract class ReadStepNode extends Node {
  /** Get the field that is read. */
  abstract Field getAField();

  /** Get the node representing the value that is read. */
  abstract Node getReadValue();
}

/** The target node of a `storeStep`. */
abstract class StoreStepNode extends PostUpdateNode {
  /** Get the field that is stored into. */
  abstract Field getAField();

  /** Get the node representing the value that is stored. */
  abstract Node getStoredValue();
}

/**
 * Sometimes a sequence of `FieldAddressInstruction`s does not end with a `StoreInstruction`.
 * This class abstracts out the information needed to end a `StoreChain`.
 */
abstract private class StoreChainEndInstruction extends Instruction {
  abstract FieldAddressInstruction getFieldInstruction();

  abstract Instruction getBeginInstruction();

  abstract Node getPreUpdateNode();
}

/**
 * A `StoreInstruction` that ends a sequence of `FieldAddressInstruction`s.
 */
private class StoreChainEndInstructionStoreWithChi extends StoreChainEndInstruction, ChiInstruction {
  StoreInstruction store;
  FieldAddressInstruction fi;

  StoreChainEndInstructionStoreWithChi() {
    this.getPartial() = store and
    fi = skipConversion*(store.getDestinationAddress())
  }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override Node getPreUpdateNode() { result.asInstruction() = this.getTotal() }

  override Instruction getBeginInstruction() { result = store }
}

/**
 * Not every store instruction generates a chi instruction that we can attach a PostUpdateNode to.
 * For instance, an update to a field of a struct containing only one field. For these cases we
 * attach the PostUpdateNode to the store instruction. There's no obvious pre update node for this case
 * (as the entire memory is updated), so `getPreUpdateNode` is implemented as `none()`.
 */
private class StoreChainEndInstructionStoreWithoutChi extends StoreChainEndInstruction,
  StoreInstruction {
  FieldAddressInstruction fi;

  StoreChainEndInstructionStoreWithoutChi() {
    not exists(ChiInstruction chi | chi.getPartial() = this) and
    fi = skipConversion*(this.getDestinationAddress())
  }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override Node getPreUpdateNode() { none() }

  override Instruction getBeginInstruction() { result = this.getSourceValue() }
}

/**
 * When traversing dependencies between an instruction and its operands
 * it is sometimes convenient to ignore certain instructions. For instance,
 * the `LoadChain` for `((B&)a.b).c` inserts a `CopyValueInstruction`
 * between the computed address for `b` and the `FieldAddressInstruction`
 * for `c`.
 */
private Instruction skipConversion(Instruction instr) {
  result = instr.(CopyInstruction).getSourceValue()
  or
  result = instr.(ConvertInstruction).getUnary()
  or
  result = instr.(CheckedConvertOrNullInstruction).getUnary()
  or
  result = instr.(InheritanceConversionInstruction).getUnary()
}

/**
 * Ends a `StoreChain` with a `WriteSideEffectInstruction` such that we build up
 * the correct access paths. For example in:
 * ```
 * void setter(B *b, int data) {
 *   b->c = data;
 * }
 * ...
 * setter(&a.b, source());
 * sink(a.b.c)
 * ```
 * In order to register `a.b.c` as a `readStep`, the access path must
 * contain `[a, b, c]`, and thus the access path must be `[a, b]`
 * before entering `setter`.
 */
private class StoreChainEndInstructionSideEffect extends StoreChainEndInstruction, ChiInstruction {
  WriteSideEffectInstruction sideEffect;
  FieldAddressInstruction fi;

  StoreChainEndInstructionSideEffect() {
    this.getPartial() = sideEffect and
    fi = skipConversion*(sideEffect.getArgumentDef())
  }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override Node getPreUpdateNode() { result.asInstruction() = this.getTotal() }

  override Instruction getBeginInstruction() { result = sideEffect }
}

private newtype TStoreChain =
  TStoreChainConsNil(FieldAddressInstruction f, StoreChainEndInstruction end) {
    end.getFieldInstruction() = f
  } or
  TStoreChainConsCons(FieldAddressInstruction f, TStoreChain next) {
    exists(FieldAddressInstruction g | skipConversion*(g.getObjectAddress()) = f |
      next = TStoreChainConsCons(g, _) or
      next = TStoreChainConsNil(g, _)
    )
  }

/**
 * A `StoreChain` represents a series of field lookups that compute the destination of a store.
 * For example, given an assignment such as `a.b.c = x`, there are two `StoreChain`s:
 * One corresponding to the field `b`, and one corresponding to the field `c`. Here, `b` is the parent
 * `StoreChain` of `c`.
 */
private class StoreChain extends TStoreChain {
  string toString() { none() }

  /**
   * Gets the parent of this `StoreChain`, if any. For example, for the assignment
   * ```
   * a.b.c = x;
   * ```
   * the parent of `c` is `b`, and `b` has no parent.
   */
  final StoreChainConsCons getParent() { result.getChild() = this }

  /** Gets the child of this `StoreChain`, if any. */
  StoreChain getChild() { none() }

  /**
   * Gets the instruction that receives flow from the outermost `StoreChain` of this chain (i.e.,
   * the `StoreChain` with no parent).
   */
  StoreChainEndInstruction getEndInstruction() { none() }

  /**
   * Gets the instruction that flows to the innermost `StoreChain` of this chain (i.e.,
   * the `StoreChain` with no child).
   */
  Instruction getBeginInstruction() { none() }

  /** Gets the `FieldAddressInstruction` of this `StoreChain` */
  FieldAddressInstruction getFieldInstruction() { none() }

  /** Gets the `FieldAddressInstruction` of any `StoreChain` in this chain. */
  FieldAddressInstruction getAFieldInstruction() { none() }

  final Location getLocation() { result = getFieldInstruction().getLocation() }
}

private class StoreChainConsNil extends StoreChain, TStoreChainConsNil {
  FieldAddressInstruction fi;
  StoreChainEndInstruction end;

  StoreChainConsNil() { this = TStoreChainConsNil(fi, end) }

  override string toString() { result = fi.getField().toString() }

  override StoreChainEndInstruction getEndInstruction() { result = end }

  override Instruction getBeginInstruction() { result = end.getBeginInstruction() }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override FieldAddressInstruction getAFieldInstruction() { result = fi }
}

private class StoreChainConsCons extends StoreChain, TStoreChainConsCons {
  FieldAddressInstruction fi;
  StoreChain next;

  StoreChainConsCons() { this = TStoreChainConsCons(fi, next) }

  override string toString() { result = fi.getField().toString() + "." + next.toString() }

  override StoreChain getChild() { result = next }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override FieldAddressInstruction getAFieldInstruction() {
    result = [fi, next.getAFieldInstruction()]
  }

  override StoreChainEndInstruction getEndInstruction() { result = next.getEndInstruction() }

  override Instruction getBeginInstruction() { result = next.getBeginInstruction() }
}

private newtype TLoadChain =
  TLoadChainConsNil(FieldAddressInstruction fi, LoadChainEndInstruction end) {
    end.getFieldInstruction() = fi
  } or
  TLoadChainConsCons(FieldAddressInstruction fi, TLoadChain next) {
    exists(FieldAddressInstruction nextFi | skipConversion*(nextFi.getObjectAddress()) = fi |
      next = TLoadChainConsCons(nextFi, _) or
      next = TLoadChainConsNil(nextFi, _)
    )
  }

/** This class abstracts out the information needed to end a `LoadChain`. */
abstract private class LoadChainEndInstruction extends Instruction {
  abstract FieldAddressInstruction getFieldInstruction();

  abstract Instruction getReadValue();
}

/**
 * A `LoadInstruction` that ends a sequence of `FieldAddressInstruction`s.
 */
private class LoadChainEndInstructionLoad extends LoadChainEndInstruction, LoadInstruction {
  FieldAddressInstruction fi;

  LoadChainEndInstructionLoad() { fi = skipConversion*(this.getSourceAddress()) }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override Instruction getReadValue() { result = getSourceValueOperand().getAnyDef() }
}

/**
 * Ends a `LoadChain` with a `ReadSideEffectInstruction`. This ensures that we pop content from the
 * access path when passing an argument that reads a field. For example in:
 * ```
 * void read_f(Inner* inner) {
 *   sink(inner->f);
 * }
 * ...
 * outer.inner.f = taint();
 * read_f(&outer.inner);
 * ```
 * In order to register `inner->f` as a `readStep`, the head of the access path must
 * be `f`, and thus reading `&outer.inner` must pop `inner` from the access path
 * before entering `read_f`.
 */
private class LoadChainEndInstructionSideEffect extends LoadChainEndInstruction,
  ReadSideEffectInstruction {
  FieldAddressInstruction fi;

  LoadChainEndInstructionSideEffect() { fi = skipConversion*(this.getArgumentDef()) }

  override FieldAddressInstruction getFieldInstruction() { result = fi }

  override Instruction getReadValue() { result = getSideEffectOperand().getAnyDef() }
}

/**
 * A `LoadChain` represents a series of field lookups that compute the source address of a load.
 * For example, given the field lookup in `f(a.b.c)`, there are two `LoadChains`s:
 * One corresponding to the field `b`, and one corresponding to the field `c`. Here, `b` is the parent
 * `LoadChain` of `c`.
 */
private class LoadChain extends TLoadChain {
  string toString() { none() }

  /**
   * Gets the instruction that receives flow from the innermost `LoadChain` of this chain (i.e.,
   * the `LoadChain` with no child).
   */
  LoadChainEndInstruction getEndInstruction() { none() }

  /**
   * Gets the parent of this `LoadChain`, if any. For example in `f(a.b.c)` the parent of `c` is `b`,
   * and `b` has no parent.
   */
  final LoadChainConsCons getParent() { result.getChild() = this }

  /** Gets the child of this `LoadChain`, if any. */
  LoadChain getChild() { none() }

  /** Gets the `FieldAddressInstruction` of this `LoadChain` */
  FieldAddressInstruction getFieldInstruction() { none() }

  final Location getLocation() { result = getFieldInstruction().getLocation() }
}

private class LoadChainConsNil extends LoadChain, TLoadChainConsNil {
  FieldAddressInstruction fi;
  LoadChainEndInstruction end;

  LoadChainConsNil() { this = TLoadChainConsNil(fi, end) }

  override string toString() { result = fi.getField().toString() }

  override LoadChainEndInstruction getEndInstruction() { result = end }

  override FieldAddressInstruction getFieldInstruction() { result = fi }
}

private class LoadChainConsCons extends LoadChain, TLoadChainConsCons {
  FieldAddressInstruction fi;
  LoadChain next;

  LoadChainConsCons() { this = TLoadChainConsCons(fi, next) }

  override string toString() { result = fi.getField().toString() + "." + next.toString() }

  override LoadChainEndInstruction getEndInstruction() { result = next.getEndInstruction() }

  override LoadChain getChild() { result = next }

  override FieldAddressInstruction getFieldInstruction() { result = fi }
}

/**
 * A dataflow node generated by a partial definition.
 * The `StoreNode` class extends `ReadStepNode` to participate in reverse read steps.
 * A reverse read is a store step that is "inferred" by the DataFlow library. For example in the
 * assignment:
 * ```
 *  a.b.c = x;
 * ```
 * Here, the access path after the store must reflect that a value has been stored into the field `c` of
 * the object at field `b`. The field `c` is added to the access path through a `storeStep`, and the
 * field `b` is inferred by the DataFlow library because there's a read step (reading the field `b`) from
 * the pre update node for `b.c` to the pre update node for `c`.
 */
private class StoreNode extends TStoreNode, StoreStepNode, ReadStepNode, PartialDefinitionNode {
  StoreChain storeChain;

  StoreNode() { this = TStoreNode(storeChain) }

  override string toString() { result = storeChain.toString() }

  StoreChain getStoreChain() { result = storeChain }

  override Node getPreUpdateNode() {
    result.(StoreNode).getStoreChain() = storeChain.getParent()
    or
    not exists(storeChain.getParent()) and
    result = storeChain.getEndInstruction().getPreUpdateNode()
  }

  override Field getAField() { result = storeChain.getFieldInstruction().getField() }

  override Node getStoredValue() {
    // Only the `StoreNode` attached to the end of the `StoreChain` has a `getStoredValue()`, so
    // this is the only `StoreNode` that matches storeStep.
    not exists(storeChain.getChild()) and result.asInstruction() = storeChain.getBeginInstruction()
  }

  override Node getReadValue() { result = getPreUpdateNode() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = storeChain.getEndInstruction().getEnclosingFunction() }

  override Type getType() { result = storeChain.getEndInstruction().getResultType() }

  override Location getLocation() { result = storeChain.getEndInstruction().getLocation() }

  override Expr getDefinedExpr() {
    result = storeChain.getAFieldInstruction().getObjectAddress().getUnconvertedResultExpression()
  }
}

/** A dataflow node generated by loading from an address computed by a sequence of fields lookups. */
private class LoadNode extends TLoadNode, ReadStepNode {
  LoadChain loadChain;

  LoadNode() { this = TLoadNode(loadChain) }

  override Field getAField() { result = loadChain.getFieldInstruction().getField() }

  override Node getReadValue() {
    result.(LoadNode).getLoadChain() = loadChain.getParent()
    or
    not exists(loadChain.getParent()) and
    result.asInstruction() = loadChain.getEndInstruction().getReadValue()
  }

  LoadChain getLoadChain() { result = loadChain }

  override string toString() { result = loadChain.toString() }

  override Declaration getEnclosingCallable() { result = this.getFunction() }

  override Function getFunction() { result = loadChain.getEndInstruction().getEnclosingFunction() }

  override Type getType() { result = loadChain.getEndInstruction().getResultType() }

  override Location getLocation() { result = loadChain.getEndInstruction().getLocation() }
}

/**
 * Gets the node corresponding to `instr`.
 */
InstructionNode instructionNode(Instruction instr) { result.getInstruction() = instr }

/**
 * Gets the `Node` corresponding to a definition by reference of the variable
 * that is passed as `argument` of a call.
 */
DefinitionByReferenceNode definitionByReferenceNode(Expr e) { result.getArgument() = e }

/**
 * Gets a `Node` corresponding to `e` or any of its conversions. There is no
 * result if `e` is a `Conversion`.
 */
ExprNode exprNode(Expr e) { result.getExpr() = e }

/**
 * Gets the `Node` corresponding to `e`, if any. Here, `e` may be a
 * `Conversion`.
 */
ExprNode convertedExprNode(Expr e) { result.getConvertedExpr() = e }

/**
 * Gets the `Node` corresponding to the value of `p` at function entry.
 */
ExplicitParameterNode parameterNode(Parameter p) { result.getParameter() = p }

/** Gets the `VariableNode` corresponding to the variable `v`. */
VariableNode variableNode(Variable v) { result.getVariable() = v }

/**
 * DEPRECATED: See UninitializedNode.
 *
 * Gets the `Node` corresponding to the value of an uninitialized local
 * variable `v`.
 */
Node uninitializedNode(LocalVariable v) { none() }

/**
 * Holds if data flows from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localFlowStep(Node nodeFrom, Node nodeTo) { simpleLocalFlowStep(nodeFrom, nodeTo) }

/**
 * INTERNAL: do not use.
 *
 * This is the local flow predicate that's used as a building block in global
 * data flow. It may have less flow than the `localFlowStep` predicate.
 */
predicate simpleLocalFlowStep(Node nodeFrom, Node nodeTo) {
  simpleInstructionLocalFlowStep(nodeFrom.asInstruction(), nodeTo.asInstruction())
  or
  // When flow has gone all the way through the chain of field accesses
  // `[f1,f2, ..., fn]` (from right to left) we add flow from f1 to the end instruction.
  exists(StoreNode synthFrom |
    synthFrom = nodeFrom and
    not exists(synthFrom.getStoreChain().getParent()) and
    synthFrom.getStoreChain().getEndInstruction() = nodeTo.asInstruction()
  )
  or
  // When flow has gone all the way through the chain of field accesses
  // `[f1, f2, ..., fn]` (from left to right) we add flow from fn to the end instruction.
  exists(LoadNode synthFrom |
    synthFrom = nodeFrom and
    not exists(synthFrom.getLoadChain().getChild()) and
    synthFrom.getLoadChain().getEndInstruction() = nodeTo.asInstruction()
  )
}

pragma[noinline]
private predicate getFieldSizeOfClass(Class c, Type type, int size) {
  exists(Field f |
    f.getDeclaringType() = c and
    f.getType() = type and
    type.getSize() = size
  )
}

cached
private predicate simpleInstructionLocalFlowStep(Instruction iFrom, Instruction iTo) {
  iTo.(CopyInstruction).getSourceValue() = iFrom
  or
  iTo.(PhiInstruction).getAnOperand().getDef() = iFrom
  or
  // A read side effect is almost never exact since we don't know exactly how
  // much memory the callee will read.
  iTo.(ReadSideEffectInstruction).getSideEffectOperand().getAnyDef() = iFrom and
  not iFrom.isResultConflated()
  or
  // Loading a single `int` from an `int *` parameter is not an exact load since
  // the parameter may point to an entire array rather than a single `int`. The
  // following rule ensures that any flow going into the
  // `InitializeIndirectionInstruction`, even if it's for a different array
  // element, will propagate to a load of the first element.
  //
  // Since we're linking `InitializeIndirectionInstruction` and
  // `LoadInstruction` together directly, this rule will break if there's any
  // reassignment of the parameter indirection, including a conditional one that
  // leads to a phi node.
  exists(InitializeIndirectionInstruction init |
    iFrom = init and
    iTo.(LoadInstruction).getSourceValueOperand().getAnyDef() = init and
    // Check that the types match. Otherwise we can get flow from an object to
    // its fields, which leads to field conflation when there's flow from other
    // fields to the object elsewhere.
    init.getParameter().getType().getUnspecifiedType().(DerivedType).getBaseType() =
      iTo.getResultType().getUnspecifiedType()
  )
  or
  // Treat all conversions as flow, even conversions between different numeric types.
  iTo.(ConvertInstruction).getUnary() = iFrom
  or
  iTo.(CheckedConvertOrNullInstruction).getUnary() = iFrom
  or
  iTo.(InheritanceConversionInstruction).getUnary() = iFrom
  or
  // A chi instruction represents a point where a new value (the _partial_
  // operand) may overwrite an old value (the _total_ operand), but the alias
  // analysis couldn't determine that it surely will overwrite every bit of it or
  // that it surely will overwrite no bit of it.
  //
  // By allowing flow through the total operand, we ensure that flow is not lost
  // due to shortcomings of the alias analysis. We may get false flow in cases
  // where the data is indeed overwritten.
  //
  // Flow through the partial operand belongs in the taint-tracking libraries
  // for now.
  iTo.getAnOperand().(ChiTotalOperand).getDef() = iFrom
  or
  // Add flow from write side-effects to non-conflated chi instructions through their
  // partial operands. From there, a `readStep` will find subsequent reads of that field.
  // Consider the following example:
  // ```
  // void setX(Point* p, int new_x) {
  //   p->x = new_x;
  // }
  // ...
  // setX(&p, taint());
  // ```
  // Here, a `WriteSideEffectInstruction` will provide a new definition for `p->x` after the call to
  // `setX`, which will be melded into `p` through a chi instruction.
  exists(ChiInstruction chi | chi = iTo |
    chi.getPartialOperand().getDef() = iFrom.(WriteSideEffectInstruction) and
    not chi.isResultConflated()
  )
  or
  // Flow from stores to structs with a single field to a load of that field.
  iTo.(LoadInstruction).getSourceValueOperand().getAnyDef() = iFrom and
  exists(int size, Type type, Class cTo |
    type = iFrom.getResultType() and
    cTo = iTo.getResultType() and
    cTo.getSize() = size and
    getFieldSizeOfClass(cTo, type, size)
  )
  or
  // Flow through modeled functions
  modelFlow(iFrom, iTo)
}

private predicate modelFlow(Instruction iFrom, Instruction iTo) {
  exists(
    CallInstruction call, DataFlowFunction func, FunctionInput modelIn, FunctionOutput modelOut
  |
    call.getStaticCallTarget() = func and
    func.hasDataFlow(modelIn, modelOut)
  |
    (
      modelOut.isReturnValue() and
      iTo = call
      or
      // TODO: Add write side effects for return values
      modelOut.isReturnValueDeref() and
      iTo = call
      or
      exists(int index, WriteSideEffectInstruction outNode |
        modelOut.isParameterDeref(index) and
        iTo = outNode and
        outNode = getSideEffectFor(call, index)
      )
      // TODO: add write side effects for qualifiers
    ) and
    (
      exists(int index |
        modelIn.isParameter(index) and
        iFrom = call.getPositionalArgument(index)
      )
      or
      exists(int index, ReadSideEffectInstruction read |
        modelIn.isParameterDeref(index) and
        read = getSideEffectFor(call, index) and
        iFrom = read.getSideEffectOperand().getAnyDef()
      )
      or
      modelIn.isQualifierAddress() and
      iFrom = call.getThisArgument()
      // TODO: add read side effects for qualifiers
    )
  )
}

/**
 * Holds if the result is a side effect for instruction `call` on argument
 * index `argument`. This helper predicate makes it easy to join on both of
 * these columns at once, avoiding pathological join orders in case the
 * argument index should get joined first.
 */
pragma[noinline]
SideEffectInstruction getSideEffectFor(CallInstruction call, int argument) {
  call = result.getPrimaryInstruction() and
  argument = result.(IndexedInstruction).getIndex()
}

/**
 * Holds if data flows from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localFlow(Node source, Node sink) { localFlowStep*(source, sink) }

/**
 * Holds if data can flow from `i1` to `i2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localInstructionFlow(Instruction e1, Instruction e2) {
  localFlow(instructionNode(e1), instructionNode(e2))
}

/**
 * Holds if data can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprFlow(Expr e1, Expr e2) { localFlow(exprNode(e1), exprNode(e2)) }

/**
 * A guard that validates some instruction.
 *
 * To use this in a configuration, extend the class and provide a
 * characteristic predicate precisely specifying the guard, and override
 * `checks` to specify what is being validated and in which branch.
 *
 * It is important that all extending classes in scope are disjoint.
 */
class BarrierGuard extends IRGuardCondition {
  /** Override this predicate to hold if this guard validates `instr` upon evaluating to `b`. */
  abstract predicate checks(Instruction instr, boolean b);

  /** Gets a node guarded by this guard. */
  final Node getAGuardedNode() {
    exists(ValueNumber value, boolean edge |
      result.asInstruction() = value.getAnInstruction() and
      this.checks(value.getAnInstruction(), edge) and
      this.controls(result.asInstruction().getBlock(), edge)
    )
  }
}
