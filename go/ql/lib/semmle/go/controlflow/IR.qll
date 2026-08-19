/**
 * Provides classes and predicates for working with an intermediate representation (IR) of Go
 * programs that is used as the foundation of the control flow and data flow graphs.
 *
 * In the IR, the program is represented as a set of instructions, which correspond to expressions
 * and statements that compute a value or perform an operation (as opposed to providing syntactic
 * structure or type information).
 *
 * Each instruction is also a control-flow node, but there are control-flow nodes that are not
 * instructions (synthetic entry and exit nodes, as well as before/after nodes).
 */
overlay[local]
module;

import go
private import ControlFlowGraphShared
private import codeql.controlflow.SuccessorType

/** Provides predicates and classes for working with IR constructs. */
module IR {
  /**
   * Holds if `n` is the control-flow node representing a successful match of
   * the type-switch case clause `cc` that implicitly declares a variable.
   *
   * This node dominates the case body and is where the implicit per-case
   * variable declaration/assignment is materialised (see
   * `TypeSwitchImplicitVariableInstruction`).
   */
  private predicate typeSwitchCaseMatch(ControlFlow::Node n, CaseClause cc) {
    cc = any(TypeSwitchStmt ts).getACase() and
    exists(cc.getImplicitlyDeclaredVariable()) and
    n.isAfterValue(cc, any(MatchingSuccessor t | t.isMatch()))
  }

  /**
   * Holds if `n` records a boolean outcome, or the matching outcome of an
   * expressionless switch case condition.
   */
  private predicate isConditionGuardNode(ControlFlow::Node n) {
    n.isAfterTrue(_)
    or
    n.isAfterFalse(_)
    or
    exists(Expr condition, MatchingSuccessor successor |
      condition =
        any(ExpressionSwitchStmt switch | not exists(switch.getExpr())).getACase().getAnExpr() and
      n.isAfterValue(condition, successor)
    )
  }

  /**
   * An IR instruction.
   */
  class Instruction extends ControlFlow::Node {
    Instruction() {
      this.isIn(_)
      or
      this.isAdditional(_, _)
      or
      isConditionGuardNode(this)
      or
      // The successful-match node of a type-switch case that binds an implicit
      // variable hosts that variable's declaration/assignment (see
      // `TypeSwitchImplicitVariableInstruction`).
      typeSwitchCaseMatch(this, _)
      or
      // `NotExpr` and `LogicalBinaryExpr` are not in `postOrInOrder`, so they
      // have no `isIn` node. Use their combined after-node as the value-producing
      // instruction, but not a value-specific after-node, which is already a
      // `ConditionGuardInstruction`.
      exists(Expr e |
        (e instanceof NotExpr or e instanceof LogicalBinaryExpr) and
        this.isAfter(e) and
        not this.isAfterValue(e, _)
      )
      or
      // A named parameter is represented by a single CFG node (the merged
      // "before"/"after" leaf node for its declaration), which hosts the
      // initialization write (see `InitParameterInstruction`).
      this.isBefore(any(FuncDef fd).getParameter(_).getDeclaration())
    }

    /** Holds if this instruction reads the value of variable or constant `v`. */
    predicate reads(ValueEntity v) { this.readsField(_, v) or this.readsMethod(_, v) }

    /** Holds if this instruction updates variable or constant `v` to the value of `rhs`. */
    predicate writes(ValueEntity v, Instruction rhs) { this.writesField(_, v, rhs) }

    /** Holds if this instruction reads the value of field `f` on the value of `base`. */
    predicate readsField(Instruction base, Field f) { none() }

    /** Holds if this instruction updates the value of field `f` on the value of `base`. */
    predicate writesField(Instruction base, Field f, Instruction rhs) { none() }

    /** Holds if this instruction looks up method `m` on the value of `receiver`. */
    predicate readsMethod(Instruction receiver, Method m) { none() }

    /** Holds if this instruction reads the value of element `index` on the value of `base`. */
    predicate readsElement(Instruction base, Instruction index) { none() }

    /** Holds if this instruction updates the value of element `index` on the value of `base`. */
    predicate writesElement(Instruction base, Instruction index) { none() }

    /** Gets the type of the result of this instruction, if any. */
    Type getResultType() { none() }

    /** Gets the float value of the result of this instruction, if it can be determined. */
    float getFloatValue() { none() }

    /** Gets the int value of the result of this instruction, if it can be determined. */
    int getIntValue() { none() }

    /**
     * Holds if the complex value of the result of this instruction has real part `real` and
     * imaginary part `imag`.
     */
    predicate hasComplexValue(float real, float imag) { none() }

    /** Gets either `getFloatValue` or `getIntValue` */
    float getNumericValue() { result = this.getFloatValue() or result = this.getIntValue() }

    /**
     * Gets the string representation of the exact value of the result of this instruction,
     * if any.
     *
     * For example, for the constant 3.141592653589793238462, this will
     * result in 1570796326794896619231/500000000000000000000
     */
    string getExactValue() { none() }

    /** Gets the string value of the result of this instruction, if it can be determined. */
    string getStringValue() { none() }

    /** Gets the Boolean value of the result of this instruction, if it can be determined. */
    boolean getBoolValue() { none() }

    /** Holds if the result of this instruction is known at compile time. */
    predicate isConst() { none() }

    /**
     * Holds if the result of this instruction is known at compile time, and is guaranteed not to
     * depend on the platform where it is evaluated.
     */
    predicate isPlatformIndependentConstant() { none() }

    /** Gets a textual representation of the kind of this instruction. */
    string getInsnKind() {
      this instanceof EvalInstruction and result = "expression"
      or
      this instanceof InitLiteralComponentInstruction and result = "element init"
      or
      this instanceof AssignInstruction and result = "assignment"
      or
      this instanceof EvalCompoundAssignRhsInstruction and
      result = "right-hand side of compound assignment"
      or
      this instanceof ExtractTupleElementInstruction and result = "tuple element extraction"
      or
      this instanceof EvalImplicitInitInstruction and result = "zero value"
      or
      this instanceof DeclareFunctionInstruction and result = "function declaration"
      or
      this instanceof DeferInstruction and result = "defer"
      or
      this instanceof GoInstruction and result = "go"
      or
      this instanceof ConditionGuardInstruction and result = "condition guard"
      or
      this instanceof ReturnInstruction and result = "return"
      or
      this instanceof WriteResultInstruction and result = "result write"
      or
      this instanceof ReadResultInstruction and result = "result read"
      or
      this instanceof InitParameterInstruction and result = "parameter initialization"
      or
      this instanceof GetNextEntryInstruction and result = "next key-value pair"
      or
      this instanceof EvalImplicitTrueInstruction and result = "implicit true"
      or
      this instanceof CaseInstruction and result = "case"
      or
      this instanceof TypeSwitchImplicitVariableInstruction and
      result = "type switch implicit variable declaration"
      or
      this instanceof EvalImplicitDerefInstruction and result = "implicit dereference"
      or
      this instanceof ImplicitFieldReadInstruction and result = "implicit field selection"
    }
  }

  /** A condition guard instruction, representing a known boolean outcome for a condition. */
  private class ConditionGuardInstruction extends Instruction {
    ConditionGuardInstruction() { isConditionGuardNode(this) }
  }

  /**
   * An IR instruction representing the evaluation of an expression.
   */
  class EvalInstruction extends Instruction {
    Expr e;

    EvalInstruction() {
      this.isIn(e)
      or
      // The call of a `defer` statement is pre-order (it has no in-order
      // "invocation" node at the statement), so its value is produced by the
      // `defer-invoke` node that models the call at function exit.
      this.isAdditional(e, "defer-invoke")
      or
      // Non-constant `NotExpr` and `LogicalBinaryExpr` are not in
      // `postOrInOrder`, so they don't have an `isIn` node; their value is
      // produced by the after-node. (Constant ones are folded and get a leaf
      // `isIn` node via `constRoot`, handled by the first disjunct above, so
      // they are excluded here to avoid a duplicate value node.) Value-specific
      // after-nodes are condition guards rather than expression evaluations.
      (e instanceof NotExpr or e instanceof LogicalBinaryExpr) and
      not e.isConst() and
      this.isAfter(e) and
      not this.isAfterValue(_, _)
    }

    /** Gets the expression underlying this instruction. */
    Expr getExpr() { result = e }

    override predicate reads(ValueEntity v) { e = v.getAReference() }

    override Type getResultType() { result = e.getType() }

    override ControlFlow::Root getRoot() { result.isRootOf(e) }

    override float getFloatValue() { result = e.getFloatValue() }

    override int getIntValue() { result = e.getIntValue() }

    override predicate hasComplexValue(float real, float imag) { e.hasComplexValue(real, imag) }

    override string getExactValue() { result = e.getExactValue() }

    override string getStringValue() { result = e.getStringValue() }

    override boolean getBoolValue() { result = e.getBoolValue() }

    override predicate isConst() { e.isConst() }

    override predicate isPlatformIndependentConstant() { e.isPlatformIndependentConstant() }
  }

  /**
   * An IR instruction that reads the value of a variable, constant, field or array element,
   * or refers to a function.
   */
  class ReadInstruction extends Instruction {
    ReadInstruction() {
      exists(Expr e | e = this.(EvalInstruction).getExpr() |
        (e instanceof ValueName or e instanceof IndexExpr) and
        e.(ReferenceExpr).isRvalue()
      )
      or
      this instanceof ReadResultInstruction
      or
      this instanceof ImplicitFieldReadInstruction
    }
  }

  /**
   * Gets the effective base of a selector, index or slice expression, taking implicit dereferences
   * and implicit field reads into account.
   */
  private Instruction selectorBase(Expr e) {
    exists(ImplicitFieldReadInstruction fri | fri.getSelectorExpr() = e and fri.getIndex() = 1 |
      result = fri
    )
    or
    not exists(ImplicitFieldReadInstruction fri | fri.getSelectorExpr() = e and fri.getIndex() = 1) and
    exists(Expr base |
      base = e.(SelectorExpr).getBase()
      or
      base = e.(IndexExpr).getBase()
      or
      base = e.(SliceExpr).getBase()
    |
      result = implicitDerefInstruction(base)
      or
      not exists(implicitDerefInstruction(base)) and
      result = evalExprInstruction(base)
    )
  }

  /**
   * An IR instruction that reads a component from a composite object.
   */
  class ComponentReadInstruction extends ReadInstruction {
    ComponentReadInstruction() {
      exists(Expr e | e = this.(EvalInstruction).getExpr() |
        e instanceof IndexExpr
        or
        e.(SelectorExpr).getBase() instanceof ValueExpr and
        not e.(SelectorExpr).getSelector() = any(Method method).getAReference()
      )
      or
      this instanceof ImplicitFieldReadInstruction
    }

    /** Gets the instruction computing the base value on which the field or element is read. */
    Instruction getBase() {
      result = this.(ImplicitFieldReadInstruction).getBaseInstruction()
      or
      result = selectorBase(this.(EvalInstruction).getExpr())
    }
  }

  /**
   * An IR instruction that reads the value of a field.
   */
  class FieldReadInstruction extends ComponentReadInstruction {
    SelectorExpr e;
    int index;
    Field field;

    FieldReadInstruction() {
      e = this.(EvalInstruction).getExpr() and
      index = 0 and
      field.getAReference() = e.getSelector()
      or
      this.(ImplicitFieldReadInstruction).getSelectorExpr() = e and
      this.(ImplicitFieldReadInstruction).getIndex() = index and
      this.(ImplicitFieldReadInstruction).getField() = field
    }

    /** Gets the `SelectorExpr` of this field read. */
    SelectorExpr getSelectorExpr() { result = e }

    /** Gets the index of this field read. */
    int getIndex() { result = index }

    /** Gets the field being read. */
    Field getField() { result = field }

    Instruction getBaseInstruction() {
      exists(ImplicitFieldReadInstruction fri |
        fri.getSelectorExpr() = e and fri.getIndex() = pragma[only_bind_into](index + 1)
      |
        result = fri
      )
      or
      not exists(ImplicitFieldReadInstruction fri |
        fri.getSelectorExpr() = e and fri.getIndex() = pragma[only_bind_into](index + 1)
      ) and
      (
        result = implicitDerefInstruction(e.getBase())
        or
        not exists(implicitDerefInstruction(e.getBase())) and
        result = evalExprInstruction(e.getBase())
      )
    }

    override predicate readsField(Instruction base, Field f) {
      base = this.getBaseInstruction() and f = field
    }
  }

  /**
   * An IR instruction for an implicit field read as part of reading a promoted field.
   */
  class ImplicitFieldReadInstruction extends Instruction {
    SelectorExpr sel;
    int idx;
    Field fld;

    ImplicitFieldReadInstruction() {
      this.isAdditional(sel, "implicit-field:" + idx.toString()) and
      CfgImpl::implicitFieldSelection(sel, idx, fld)
    }

    /** Gets the `SelectorExpr` for which this is an implicit field read. */
    SelectorExpr getSelectorExpr() { result = sel }

    /** Gets the index of this implicit field read. */
    int getIndex() { result = idx }

    /** Gets the field being read. */
    Field getField() { result = fld }

    /** Gets the instruction computing the base value on which the field is read. */
    Instruction getBaseInstruction() {
      exists(ImplicitFieldReadInstruction fri |
        fri.getSelectorExpr() = sel and fri.getIndex() = pragma[only_bind_into](idx + 1)
      |
        result = fri
      )
      or
      not exists(ImplicitFieldReadInstruction fri |
        fri.getSelectorExpr() = sel and fri.getIndex() = pragma[only_bind_into](idx + 1)
      ) and
      (
        result = implicitDerefInstruction(sel.getBase())
        or
        not exists(implicitDerefInstruction(sel.getBase())) and
        result = evalExprInstruction(sel.getBase())
      )
    }

    override predicate reads(ValueEntity v) { v = fld }

    override Type getResultType() { result = lookThroughPointerType(fld.getType()) }

    override ControlFlow::Root getRoot() { result.isRootOf(sel) }
  }

  /**
   * An IR instruction that looks up a method.
   */
  class MethodReadInstruction extends ReadInstruction, EvalInstruction {
    Method method;
    override SelectorExpr e;

    MethodReadInstruction() { e.getSelector() = method.getAReference() }

    /** Gets the instruction computing the receiver value on which the method is looked up. */
    Instruction getReceiver() { result = selectorBase(e) }

    /** Gets the method being looked up. */
    Method getMethod() { result = method }

    override predicate readsMethod(Instruction receiver, Method m) {
      receiver = this.getReceiver() and m = this.getMethod()
    }
  }

  /**
   * An IR instruction that reads an element of an array, slice, map or string.
   */
  class ElementReadInstruction extends ComponentReadInstruction, EvalInstruction {
    override IndexExpr e;

    /** Gets the instruction computing the index of the element being looked up. */
    Instruction getIndex() { result = evalExprInstruction(e.getIndex()) }

    override predicate readsElement(Instruction base, Instruction index) {
      base = this.getBase() and index = this.getIndex()
    }
  }

  /**
   * An IR instruction that constructs a slice.
   */
  class SliceInstruction extends EvalInstruction {
    override SliceExpr e;

    /** Gets the instruction computing the base value from which the slice is constructed. */
    Instruction getBase() { result = selectorBase(e) }

    /** Gets the instruction computing the lower bound of the slice, if it is explicit. */
    Instruction getLow() { result = evalExprInstruction(e.getLow()) }

    /** Gets the instruction computing the upper bound of the slice, if it is explicit. */
    Instruction getHigh() { result = evalExprInstruction(e.getHigh()) }

    /** Gets the instruction computing the capacity of the slice, if it is explicit. */
    Instruction getMax() { result = evalExprInstruction(e.getMax()) }
  }

  /**
   * An IR instruction that writes a memory location.
   */
  class WriteInstruction extends Instruction {
    WriteTarget lhs;
    Boolean initialization;

    WriteInstruction() {
      (
        lhs = MkLhs(this, _)
        or
        lhs = MkResultWriteTarget(this)
      ) and
      initialization = false
      or
      lhs = MkLiteralElementTarget(this) and initialization = true
    }

    /** Gets the target to which this instruction writes. */
    WriteTarget getLhs() { result = lhs }

    /** Holds if this instruction initializes a literal. */
    predicate isInitialization() { initialization = true }

    /** Gets the instruction computing the value this instruction writes. */
    Instruction getRhs() { none() }

    override predicate writes(ValueEntity v, Instruction rhs) {
      this.getLhs().refersTo(v) and
      rhs = this.getRhs()
    }
  }

  /**
   * An IR instruction that initializes a component of a composite literal.
   */
  class InitLiteralComponentInstruction extends WriteInstruction {
    CompositeLit lit;
    int litIdx;
    Expr elt;

    InitLiteralComponentInstruction() {
      this.isAdditional(elt, "lit-init") and
      elt = lit.getElement(litIdx)
    }

    /** Gets the instruction allocating the composite literal. */
    Instruction getBase() { result = evalExprInstruction(lit) }

    override Instruction getRhs() {
      not elt instanceof KeyValueExpr and result = evalExprInstruction(elt)
      or
      result = evalExprInstruction(elt.(KeyValueExpr).getValue())
    }

    override ControlFlow::Root getRoot() { result.isRootOf(elt) }
  }

  /**
   * An IR instruction that initializes a field of a struct literal.
   */
  class InitLiteralStructFieldInstruction extends InitLiteralComponentInstruction {
    override StructLit lit;

    /** Gets the name of the initialized field. */
    pragma[nomagic]
    string getFieldName() {
      if elt instanceof KeyValueExpr
      then result = elt.(KeyValueExpr).getKey().(Ident).getName()
      else pragma[only_bind_out](lit.getStructType()).hasOwnField(litIdx, result, _, _)
    }

    /** Gets the initialized field. */
    Field getField() {
      result.getDeclaringType() = lit.getStructType() and
      result.getName() = this.getFieldName()
    }
  }

  /**
   * An IR instruction that initializes an element of an array, slice or map literal.
   */
  class InitLiteralElementInstruction extends InitLiteralComponentInstruction {
    Type literalType;

    InitLiteralElementInstruction() {
      literalType = lit.getType().getUnderlyingType() and
      (
        literalType instanceof ArrayType or
        literalType instanceof SliceType or
        literalType instanceof MapType
      )
    }

    /** Gets the instruction computing the index of the initialized element. */
    Instruction getIndex() {
      result = evalExprInstruction(elt.(KeyValueExpr).getKey())
      or
      // A positional array/slice element has an implicit index. Array/slice
      // content flow is index-insensitive, so rather than materialise a
      // separate index node the element-init instruction acts as its own
      // (opaque) index.
      not elt instanceof KeyValueExpr and result = this
    }
  }

  /** An IR instruction that initializes an element of an array literal. */
  class InitLiteralArrayElementInstruction extends InitLiteralElementInstruction {
    override ArrayType literalType;
  }

  /** An IR instruction that initializes an element of a slice literal. */
  class InitLiteralSliceElementInstruction extends InitLiteralElementInstruction {
    override SliceType literalType;
  }

  /** An IR instruction that initializes an element of a map literal. */
  class InitLiteralMapElementInstruction extends InitLiteralElementInstruction {
    override MapType literalType;
  }

  /** An IR instruction that writes to a field. */
  class FieldWriteInstruction extends WriteInstruction {
    override FieldTarget lhs;

    /** Gets the instruction computing the base value on which the field is written. */
    Instruction getBase() { result = lhs.getBase() }

    /** Gets the field being written. */
    Field getField() { result = lhs.getField() }

    override predicate writesField(Instruction base, Field f, Instruction rhs) {
      this.getBase() = base and this.getField() = f and this.getRhs() = rhs
    }
  }

  /** An IR instruction that writes to an element of an array, slice, or map. */
  class ElementWriteInstruction extends WriteInstruction {
    override ElementTarget lhs;

    /** Gets the instruction computing the base value on which the element is written. */
    Instruction getBase() { result = lhs.getBase() }

    /** Gets the instruction computing the element index being written. */
    Instruction getIndex() { result = lhs.getIndex() }

    override predicate writesElement(Instruction base, Instruction index) {
      this.getBase() = base and this.getIndex() = index
    }
  }

  /**
   * An instruction assigning to a variable or field.
   */
  class AssignInstruction extends WriteInstruction {
    AstNode assgn;
    int i;

    AssignInstruction() {
      this.isAdditional(assgn, "assign:" + i.toString()) and
      (
        exists(assgn.(Assignment).getLhs(i))
        or
        // A `ValueSpec` without an initializer (`var x int`) is written by its
        // `zero-init` node directly (see `EvalImplicitInitInstruction`), so only
        // specs *with* an initializer produce an `assign` node.
        exists(assgn.(ValueSpec).getNameExpr(i)) and
        exists(assgn.(ValueSpec).getAnInit())
      )
    }

    override Instruction getRhs() {
      exists(SimpleAssignStmt a | a = assgn |
        a.getNumLhs() = a.getNumRhs() and
        result = evalExprInstruction(a.getRhs(i))
      )
      or
      exists(ValueSpec spec | spec = assgn |
        spec.getNumName() = spec.getNumInit() and
        result = evalExprInstruction(spec.getInit(i))
      )
    }

    override ControlFlow::Root getRoot() { result.isRootOf(assgn) }
  }

  /**
   * An instruction that computes the (implicit) right-hand side of a compound
   * assignment (the `x + y` in `x += y`) or an increment/decrement (the
   * `x + 1` in `x++`), and writes the resulting value to the left-hand side.
   */
  class EvalCompoundAssignRhsInstruction extends WriteInstruction {
    AstNode s;

    EvalCompoundAssignRhsInstruction() {
      this.isAdditional(s, "compound-rhs") and
      (s instanceof CompoundAssignStmt or s instanceof IncDecStmt)
    }

    /** Gets the corresponding compound assignment statement, if it is one. */
    CompoundAssignStmt getAssignment() { result = s }

    /**
     * Gets the corresponding compound assignment (`x += y`) or increment/decrement
     * (`x++`, `x--`) statement.
     */
    AstNode getStmt() { result = s }

    override Instruction getRhs() { result = this }

    override Type getResultType() {
      result = s.(CompoundAssignStmt).getRhs().getType()
      or
      result = s.(IncDecStmt).getOperand().getType()
    }

    override ControlFlow::Root getRoot() { result.isRootOf(s) }
  }

  /** An instruction extracting a component of a tuple value. */
  class ExtractTupleElementInstruction extends Instruction {
    AstNode s;
    int i;

    ExtractTupleElementInstruction() {
      this.isAdditional(s, "extract:" + i.toString()) and
      (
        exists(s.(Assignment).getLhs(i))
        or
        exists(s.(ValueSpec).getNameExpr(i))
        or
        s instanceof RangeElementExpr and i in [0, 1]
        or
        exists(s.(ReturnStmt).getEnclosingFunction().getType().(SignatureType).getResultType(i))
        or
        exists(
          s.(CallExpr)
              .getArgument(0)
              .stripParens()
              .(CallExpr)
              .getType()
              .(TupleType)
              .getComponentType(i)
        )
      )
    }

    /** Gets the instruction computing the tuple value from which the element is extracted. */
    Instruction getBase() {
      exists(Expr baseExpr |
        baseExpr = s.(Assignment).getRhs() or
        baseExpr = s.(ValueSpec).getInit()
      |
        result = evalExprInstruction(baseExpr)
      )
      or
      result.(GetNextEntryInstruction).isAdditional(s, "next")
      or
      result = evalExprInstruction(s.(ReturnStmt).getExpr())
      or
      result = evalExprInstruction(s.(CallExpr).getArgument(0).stripParens())
    }

    /** Holds if this instruction extracts element `idx` from the tuple `base`. */
    predicate extractsElement(Instruction base, int idx) { base = this.getBase() and idx = i }

    override Type getResultType() {
      exists(Expr e | this.getBase() = evalExprInstruction(e) |
        result = e.getType().(TupleType).getComponentType(pragma[only_bind_into](i))
      )
      or
      exists(Type rangeType |
        rangeType = s.(RangeElementExpr).getDomain().getType().getUnderlyingType()
      |
        exists(Type baseType |
          baseType = rangeType.(ArrayType).getElementType() or
          baseType =
            rangeType.(PointerType).getBaseType().getUnderlyingType().(ArrayType).getElementType() or
          baseType = rangeType.(SliceType).getElementType()
        |
          i = 0 and result instanceof IntType
          or
          i = 1 and result = baseType
        )
        or
        rangeType instanceof StringType and
        (
          i = 0 and result instanceof IntType
          or
          result = Builtin::rune().getType()
        )
        or
        exists(MapType map | map = rangeType |
          i = 0 and result = map.getKeyType()
          or
          i = 1 and result = map.getValueType()
        )
        or
        i = 0 and result = rangeType.(RecvChanType).getElementType()
        or
        i = 0 and result = rangeType.(SendRecvChanType).getElementType()
      )
    }

    override ControlFlow::Root getRoot() { result.isRootOf(s) }
  }

  /**
   * An `ExtractTupleElementInstruction` that also writes the extracted component
   * to a left-hand side, as in a tuple-destructuring assignment (`x, y = f()`),
   * a multi-variable declaration (`var x, y = f()`), or a `range` statement
   * (`k, v := range m`).
   *
   * The extraction node performs the write directly, rather than feeding a
   * separate `assign` node.
   */
  class ExtractWriteInstruction extends WriteInstruction, ExtractTupleElementInstruction {
    override Instruction getRhs() { result = this }
  }

  /**
   * An instruction initializing a variable declared without an initializer
   * (a local `var x int`, or a named function result) to its zero value.
   *
   * The zero-value instruction performs the write of the variable directly,
   * rather than feeding a separate write node.
   */
  class EvalImplicitInitInstruction extends WriteInstruction {
    ValueEntity v;

    EvalImplicitInitInstruction() {
      exists(ValueSpec spec, int idx |
        this.isAdditional(spec, "zero-init:" + idx.toString()) and
        spec.getNameExpr(idx) = v.getDeclaration()
      )
      or
      exists(FuncDef fd, int idx |
        this.isAdditional(fd.getBody(), "zero-init:" + idx.toString()) and
        v = fd.getResultVar(idx)
      )
    }

    override Instruction getRhs() { result = this }

    /** Gets the variable (a local or a named result) being zero-initialized. */
    ValueEntity getVariable() { result = v }

    override Type getResultType() { result = v.getType() }

    override ControlFlow::Root getRoot() { result.isRootOf(v.getDeclaration()) }

    override int getIntValue() {
      v.getType().getUnderlyingType() instanceof IntegerType and result = 0
    }

    override float getFloatValue() {
      v.getType().getUnderlyingType() instanceof FloatType and result = 0.0
    }

    override string getStringValue() {
      v.getType().getUnderlyingType() instanceof StringType and result = ""
    }

    override boolean getBoolValue() {
      v.getType().getUnderlyingType() instanceof BoolType and result = false
    }

    override string getExactValue() {
      result = this.getIntValue().toString() or
      result = this.getFloatValue().toString() or
      result = this.getStringValue().toString() or
      result = this.getBoolValue().toString()
    }

    override predicate isConst() { any() }

    override predicate isPlatformIndependentConstant() { any() }
  }

  /** An instruction that declares a function. */
  class DeclareFunctionInstruction extends Instruction {
    FuncDecl fd;

    DeclareFunctionInstruction() { this.isIn(fd) }

    override Type getResultType() { result = fd.getType() }
  }

  /** An instruction that corresponds to a `defer` statement. */
  class DeferInstruction extends Instruction {
    DeferStmt defer;

    DeferInstruction() { this.isIn(defer) }

    override ControlFlow::Root getRoot() { result.isRootOf(defer) }
  }

  /** An instruction that corresponds to a `go` statement. */
  class GoInstruction extends Instruction {
    GoStmt go;

    GoInstruction() { this.isIn(go) }

    override ControlFlow::Root getRoot() { result.isRootOf(go) }
  }

  /** An instruction corresponding to a return from a function. */
  class ReturnInstruction extends Instruction {
    ReturnStmt ret;

    ReturnInstruction() { this.isIn(ret) }

    /** Gets the corresponding `ReturnStmt`. */
    ReturnStmt getReturnStmt() { result = ret }

    /** Holds if this statement returns multiple results. */
    predicate returnsMultipleResults() {
      exists(ExtractTupleElementInstruction ext | ext.isAdditional(ret, _))
      or
      ret.getNumExpr() > 1
    }

    /** Gets the instruction whose result is the (unique) result returned by this statement. */
    Instruction getResult() {
      not this.returnsMultipleResults() and
      result = evalExprInstruction(ret.getExpr())
    }

    /** Gets the instruction whose result is the `i`th result returned by this statement. */
    Instruction getResult(int i) {
      result.isAdditional(ret, _) and
      result.(ExtractTupleElementInstruction).extractsElement(_, i)
      or
      not exists(ExtractTupleElementInstruction ext | ext.isAdditional(ret, _)) and
      result = evalExprInstruction(ret.getExpr(i))
    }

    override ControlFlow::Root getRoot() { result.isRootOf(ret) }
  }

  /**
   * An instruction that represents the implicit assignment to a result variable
   * performed by a return statement.
   */
  class WriteResultInstruction extends WriteInstruction {
    ResultVariable var;
    int idx;
    ReturnStmt retStmt;

    WriteResultInstruction() {
      this.isAdditional(retStmt, "result-write:" + idx.toString()) and
      var = retStmt.getEnclosingFunction().getResultVar(idx) and
      exists(retStmt.getAnExpr())
    }

    private ReturnInstruction getReturnInstruction() { result.getReturnStmt() = retStmt }

    override Instruction getRhs() { result = this.getReturnInstruction().getResult(idx) }

    /** Gets the result variable being assigned. */
    ResultVariable getResultVariable() { result = var }

    override Type getResultType() { result = var.getType() }

    override ControlFlow::Root getRoot() { var = result.(FuncDef).getAResultVar() }
  }

  /**
   * An instruction that reads the final value of a result variable upon returning
   * from a function.
   */
  class ReadResultInstruction extends Instruction {
    ResultVariable var;
    int idx;
    FuncDef fd;

    ReadResultInstruction() {
      this.isAdditional(fd.getBody(), "result-read:" + idx.toString()) and
      var = fd.getResultVar(idx)
    }

    override predicate reads(ValueEntity v) { v = var }

    override Type getResultType() { result = var.getType() }

    override ControlFlow::Root getRoot() { var = result.(FuncDef).getAResultVar() }
  }

  /** An instruction initializing a parameter to the corresponding argument. */
  class InitParameterInstruction extends WriteInstruction {
    Parameter parm;
    int idx;
    FuncDef fd;

    InitParameterInstruction() {
      this.isBefore(parm.getDeclaration()) and
      parm = fd.getParameter(idx)
    }

    override Instruction getRhs() { result = this }

    override Type getResultType() { result = parm.getType() }

    override ControlFlow::Root getRoot() { result = parm.getFunction() }
  }

  /** An instruction that gets the next key-value pair in a range loop. */
  class GetNextEntryInstruction extends Instruction {
    RangeElementExpr p;

    GetNextEntryInstruction() { this.isAdditional(p, "next") }

    /**
     * Gets the instruction computing the value whose key-value pairs this instruction reads.
     */
    Instruction getDomain() { result = evalExprInstruction(p.getDomain()) }

    override ControlFlow::Root getRoot() { result.isRootOf(p.getRangeStmt()) }
  }

  /**
   * An instruction computing the implicit `true` value in an expression-less `switch` statement.
   */
  class EvalImplicitTrueInstruction extends Instruction {
    ExpressionSwitchStmt stmt;

    EvalImplicitTrueInstruction() { this.isAdditional(stmt, "implicit-true") }

    override Type getResultType() { result instanceof BoolType }

    override ControlFlow::Root getRoot() { result.isRootOf(stmt) }

    override boolean getBoolValue() { result = true }

    override string getExactValue() { result = "true" }

    override predicate isConst() { any() }

    override predicate isPlatformIndependentConstant() { any() }
  }

  /**
   * An instruction corresponding to the implicit comparison or type check performed by an
   * expression in a `case` clause.
   */
  class CaseInstruction extends Instruction {
    CaseClause cc;
    int i;

    CaseInstruction() {
      this.isAdditional(cc, "case-check:" + i.toString()) and
      exists(cc.getExpr(i))
    }

    override ControlFlow::Root getRoot() { result.isRootOf(cc) }
  }

  /**
   * An instruction corresponding to the implicit declaration and assignment of a variable
   * in a type switch case clause.
   */
  class TypeSwitchImplicitVariableInstruction extends Instruction {
    CaseClause cc;

    TypeSwitchImplicitVariableInstruction() { typeSwitchCaseMatch(this, cc) }

    override predicate writes(ValueEntity v, Instruction rhs) {
      v = cc.getImplicitlyDeclaredVariable() and
      exists(TypeSwitchStmt ts | cc = ts.getACase() | rhs = evalExprInstruction(ts.getExpr()))
    }

    override ControlFlow::Root getRoot() { result.isRootOf(cc) }
  }

  /**
   * An instruction computing the implicit dereference of a pointer used as the base of a field
   * or method access, element access, or slice expression.
   */
  class EvalImplicitDerefInstruction extends Instruction {
    Expr e;

    EvalImplicitDerefInstruction() { this.isAdditional(e, "implicit-deref") }

    /** Gets the operand that is being dereferenced. */
    Expr getOperand() { result = e }

    override Type getResultType() {
      result = e.getType().getUnderlyingType().(PointerType).getBaseType()
    }

    override ControlFlow::Root getRoot() { result.isRootOf(e) }
  }

  /** A representation of the target of a write instruction. */
  newtype TWriteTarget =
    /** A left-hand side of an assignment. */
    MkLhs(ControlFlow::Node write, Expr lhs) {
      exists(AstNode assgn, int i | write.isAdditional(assgn, "assign:" + i.toString()) |
        lhs = assgn.(Assignment).getLhs(i).stripParens()
        or
        lhs = assgn.(ValueSpec).getNameExpr(i)
        or
        exists(RangeElementExpr p | p = assgn |
          i = 0 and lhs = p.getKey().stripParens()
          or
          i = 1 and lhs = p.getValue().stripParens()
        )
      )
      or
      exists(CompoundAssignStmt ca | write.isAdditional(ca, "compound-rhs") |
        lhs = ca.getLhs().stripParens()
      )
      or
      exists(IncDecStmt ids | write.isAdditional(ids, "compound-rhs") |
        lhs = ids.getOperand().stripParens()
      )
      or
      exists(FuncDef fd, int idx |
        write.isBefore(fd.getParameter(idx).getDeclaration()) and
        lhs = fd.getParameter(idx).getDeclaration()
      )
      or
      // The `zero-init` node writes the variable it initializes: a named
      // function result or a local declared without an initializer.
      exists(int idx, AstNode an | write.isAdditional(an, "zero-init:" + idx.toString()) |
        an = any(FuncDef fd | lhs = fd.getResultVar(idx).getDeclaration()).getBody()
        or
        an = any(ValueSpec spec | lhs = spec.getNameExpr(idx))
      )
      or
      // A tuple-destructuring `extract` node writes its component directly (see
      // `ExtractWriteInstruction`); blank-identifier targets are not written.
      exists(AstNode assgn, int i | write.isAdditional(assgn, "extract:" + i.toString()) |
        (
          lhs = assgn.(Assignment).getLhs(i).stripParens()
          or
          lhs = assgn.(ValueSpec).getNameExpr(i)
          or
          exists(RangeElementExpr p | p = assgn |
            i = 0 and lhs = p.getKey().stripParens()
            or
            i = 1 and lhs = p.getValue().stripParens()
          )
        ) and
        not lhs instanceof BlankIdent
      )
    } or
    /** A composite literal element target. */
    MkLiteralElementTarget(ControlFlow::Node write) {
      write.isAdditional(any(CompositeLit lit).getAnElement(), "lit-init")
    } or
    /**
     * A result variable write target. Parameterized by `ControlFlow::Node`
     * rather than `WriteResultInstruction` to avoid a circular dependency:
     * `WriteResultInstruction extends WriteInstruction` needs
     * `MkResultWriteTarget(this)` to hold, which would in turn require
     * `this` to already be a `WriteResultInstruction`.
     */
    MkResultWriteTarget(ControlFlow::Node w) {
      exists(ReturnStmt ret, int idx |
        w.isAdditional(ret, "result-write:" + idx.toString()) and
        exists(ret.getEnclosingFunction().getResultVar(idx)) and
        exists(ret.getAnExpr())
      )
    }

  /** A representation of the target of a write instruction. */
  class WriteTarget extends TWriteTarget {
    ControlFlow::Node w;

    WriteTarget() {
      this = MkLhs(w, _) or this = MkLiteralElementTarget(w) or this = MkResultWriteTarget(w)
    }

    /** Gets the write instruction of which this is the target. */
    WriteInstruction getWrite() { result = w }

    /** Gets the left-hand side expression being written to, if any. */
    Expr getExpr() { this = MkLhs(_, result) }

    /** Gets the name of the variable or field being written to, if any. */
    string getName() { none() }

    /** Gets the SSA variable being written to, if any. */
    SsaVariable asSsaVariable() {
      this.getWrite() = result.getDefinition().(SsaExplicitDefinition).getInstruction()
    }

    /** Holds if `e` is the variable or field being written to. */
    predicate refersTo(ValueEntity e) { none() }

    /** Gets a textual representation of this target. */
    string toString() { result = "write target" }

    /** Gets the source location for this element. */
    Location getLocation() { none() }

    /**
     * DEPRECATED: Use `getLocation()` instead.
     *
     * Holds if this element is at the specified location.
     */
    deprecated predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      or
      not exists(this.getLocation()) and
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }
  }

  /** A reference to a variable or constant, used as the target of a write. */
  class VarOrConstTarget extends WriteTarget {
    Expr loc;

    VarOrConstTarget() {
      this = MkLhs(_, loc) and
      (
        loc instanceof Ident
        or
        loc instanceof SelectorExpr and
        not loc.(SelectorExpr).getBase() instanceof ReferenceExpr
      )
      or
      exists(WriteResultInstruction wr |
        this = MkResultWriteTarget(wr) and
        evalExprInstruction(loc) = wr.getRhs()
      )
    }

    override predicate refersTo(ValueEntity e) {
      this instanceof MkLhs and
      pragma[only_bind_out](loc) = e.getAReference()
      or
      exists(WriteResultInstruction wr | this = MkResultWriteTarget(wr) |
        e = wr.getResultVariable()
      )
    }

    override string getName() {
      this = MkLhs(_, loc) and
      (
        result = loc.(Ident).getName()
        or
        result = loc.(SelectorExpr).getSelector().getName()
      )
      or
      exists(WriteResultInstruction wr | this = MkResultWriteTarget(wr) |
        result = wr.getResultVariable().getName()
      )
    }

    /** Gets the variable this refers to, if any. */
    Variable getVariable() { this.refersTo(result) }

    /** Gets the constant this refers to, if any. */
    Constant getConstant() { this.refersTo(result) }
  }

  /** A reference to a field, used as the target of a write. */
  class FieldTarget extends WriteTarget {
    FieldTarget() {
      exists(SelectorExpr sel | this = MkLhs(_, sel) | sel.getBase() instanceof ValueExpr)
      or
      w instanceof InitLiteralStructFieldInstruction
    }

    /** Gets the instruction computing the base value on which this field is accessed. */
    Instruction getBase() {
      exists(SelectorExpr sel | this = MkLhs(_, sel) | result = selectorBase(sel))
      or
      result = w.(InitLiteralStructFieldInstruction).getBase()
    }

    /** Gets the type of the base of this field access, that is, the type that contains the field. */
    Type getBaseType() { result = this.getBase().getResultType() }

    override predicate refersTo(ValueEntity e) {
      exists(SelectorExpr sel | this = MkLhs(_, sel) | sel.uses(e))
      or
      e = w.(InitLiteralStructFieldInstruction).getField()
    }

    override string getName() { exists(Field f | this.refersTo(f) | result = f.getName()) }

    /** Gets the field this refers to, if it can be determined. */
    Field getField() { this.refersTo(result) }
  }

  /**
   * A reference to an element of an array, slice, or map, used as the target of a write.
   */
  class ElementTarget extends WriteTarget {
    ElementTarget() {
      this = MkLhs(_, any(IndexExpr idx))
      or
      w instanceof InitLiteralElementInstruction
    }

    /** Gets the instruction computing the base value of this element reference. */
    Instruction getBase() {
      exists(IndexExpr idx | this = MkLhs(_, idx) | result = selectorBase(idx))
      or
      result = w.(InitLiteralComponentInstruction).getBase()
    }

    /** Gets the instruction computing the index of this element reference. */
    Instruction getIndex() {
      exists(IndexExpr idx | this = MkLhs(_, idx) | result = evalExprInstruction(idx.getIndex()))
      or
      result = w.(InitLiteralElementInstruction).getIndex()
    }
  }

  /**
   * A pointer dereference, used as the target of a write.
   */
  class PointerTarget extends WriteTarget {
    Expr lhs;

    PointerTarget() {
      this = MkLhs(_, lhs) and
      (lhs instanceof StarExpr or lhs instanceof DerefExpr)
    }

    /** Gets the instruction computing the pointer value being dereferenced. */
    Instruction getBase() {
      exists(Expr base | base = lhs.(StarExpr).getBase() or base = lhs.(DerefExpr).getOperand() |
        result = evalExprInstruction(base)
      )
    }
  }

  /**
   * Gets the (final) instruction computing the value of `e`.
   */
  Instruction evalExprInstruction(Expr e) {
    result.(EvalInstruction).getExpr() = e
    or
    result = evalExprInstruction(e.(ParenExpr).getExpr())
  }

  /**
   * Gets the instruction corresponding to the initialization of `r`.
   */
  InitParameterInstruction initRecvInstruction(ReceiverVariable r) {
    exists(FuncDef fd, int i |
      fd.getParameter(i) = r and result.isBefore(fd.getParameter(i).getDeclaration())
    )
  }

  /**
   * Gets the instruction corresponding to the initialization of `p`.
   */
  InitParameterInstruction initParamInstruction(Parameter p) {
    exists(FuncDef fd, int i |
      fd.getParameter(i) = p and result.isBefore(fd.getParameter(i).getDeclaration())
    )
  }

  /**
   * Gets the instruction corresponding to the `i`th assignment happening at
   * `assgn` (0-based).
   */
  AssignInstruction assignInstruction(Assignment assgn, int i) {
    result.isAdditional(assgn, "assign:" + i.toString()) and
    exists(assgn.getLhs(i))
  }

  /**
   * Gets the instruction corresponding to the `i`th initialization happening
   * at `spec` (0-based).
   */
  AssignInstruction initInstruction(ValueSpec spec, int i) {
    result.isAdditional(spec, "assign:" + i.toString()) and
    exists(spec.getNameExpr(i))
  }

  /**
   * Gets the instruction corresponding to the assignment of the key variable
   * of range statement `rs`.
   */
  ExtractWriteInstruction assignKeyInstruction(RangeStmt rs) {
    result.isAdditional(rs.getPattern(), "extract:0")
  }

  /**
   * Gets the instruction corresponding to the assignment of the value variable
   * of range statement `rs`.
   */
  ExtractWriteInstruction assignValueInstruction(RangeStmt rs) {
    result.isAdditional(rs.getPattern(), "extract:1")
  }

  /**
   * Gets the instruction corresponding to the implicit initialization of `v`
   * to its zero value.
   */
  EvalImplicitInitInstruction implicitInitInstruction(ValueEntity v) { result.getVariable() = v }

  /**
   * Gets the instruction corresponding to the extraction of the `idx`th element
   * of the tuple produced by `base`.
   */
  ExtractTupleElementInstruction extractTupleElement(Instruction base, int idx) {
    result.extractsElement(base, idx)
  }

  /**
   * Gets the implicit dereference instruction for `e`, where `e` is a pointer used as the base
   * in a field/method access, element access, or slice expression.
   */
  EvalImplicitDerefInstruction implicitDerefInstruction(Expr e) {
    result.isAdditional(e, "implicit-deref")
  }

  /** Gets the base of `insn`, if `insn` is an implicit field read. */
  Instruction lookThroughImplicitFieldRead(Instruction insn) {
    result = insn.(ImplicitFieldReadInstruction).getBaseInstruction()
  }
}
