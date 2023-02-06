/**
 * Provides classes and predicates for working with Ruby Interface (RBI) files
 * and concepts. RBI files are valid Ruby files that can contain type
 * information used by Sorbet for typechecking.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.CfgNodes

/**
 * Provides classes and predicates for working with Ruby Interface (RBI) files
 * and concepts. RBI files are valid Ruby files that can contain type
 * information used by Sorbet for typechecking.
 */
module Rbi {
  /**
   * Contains classes representing RBI types.
   */
  private module RbiTypes {
    /**
     * A node representing a Ruby Interface (RBI) type.
     */
    abstract class RbiType extends Expr { }

    /**
     * A `ConstantReadAccess` as an RBI type. This is typically a reference to a
     * class or a constant representing a type alias - for example, the read
     * accesses to `MyList1`, `Integer` and `MyList2` in:
     * ```rb
     * class MyList1; end
     * MyList2 = T.type_alias(MyList1)
     * sig { params(l: MyList2).returns(Integer) }
     *  def len(l); end
     * ```
     */
    class ConstantReadAccessAsRbiType extends RbiType, ConstantReadAccess { }

    /** A method call where the receiver is `T`. */
    private class MethodCallAgainstT extends MethodCall {
      MethodCallAgainstT() { this.getReceiver().(ConstantReadAccess).getName() = "T" }
    }

    /**
     * A call to `T.any` - a method that takes `RbiType` parameters, and returns
     * a type representing the union of those types.
     */
    class RbiUnionType extends RbiType, MethodCallAgainstT {
      RbiUnionType() { this.getMethodName() = "any" }

      /**
       * Gets a constituent type of this type union.
       */
      RbiType getAType() { result = this.getArgument(_) }
    }

    /**
     * A call to `T.untyped`.
     */
    class RbiUntypedType extends RbiType, MethodCallAgainstT {
      RbiUntypedType() { this.getMethodName() = "untyped" }
    }

    /**
     * A call to `T.nilable`, creating a nilable version of the type provided as
     * an argument.
     */
    class RbiNilableType extends RbiType, MethodCallAgainstT {
      RbiNilableType() { this.getMethodName() = "nilable" }

      /** Gets the type that this may represent if not nil. */
      RbiType getUnderlyingType() { result = this.getArgument(0) }
    }

    /**
     * A call to `T.type_alias`. The return value of this call can be assigned to
     * create a type alias.
     */
    class RbiTypeAlias extends RbiType, MethodCallAgainstT {
      RbiTypeAlias() { this.getMethodName() = "type_alias" }

      /**
       * Gets the type aliased by this call.
       */
      RbiType getAliasedType() {
        exists(ExprNodes::MethodCallCfgNode n | n.getExpr() = this |
          result = n.getBlock().(ExprNodes::StmtSequenceCfgNode).getLastStmt().getExpr()
        )
      }
    }

    /**
     * A call to `T.self_type`.
     */
    class RbiSelfType extends RbiType, MethodCallAgainstT {
      RbiSelfType() { this.getMethodName() = "self_type" }
    }

    /**
     * A call to `T.noreturn`.
     */
    class RbiNoreturnType extends RbiType, MethodCallAgainstT {
      RbiNoreturnType() { this.getMethodName() = "noreturn" }
    }

    /**
     * A `ConstantReadAccess` where the constant is from the `T` module.
     */
    private class ConstantReadAccessFromT extends ConstantReadAccess {
      ConstantReadAccessFromT() { this.getScopeExpr().(ConstantReadAccess).getName() = "T" }
    }

    /**
     * A use of `T::Boolean`.
     */
    class RbiBooleanType extends RbiType, ConstantReadAccessFromT {
      RbiBooleanType() { this.getName() = "Boolean" }
    }

    /**
     * A use of `T::Array`.
     */
    class RbiArrayType extends RbiType, ConstantReadAccessFromT {
      RbiArrayType() { this.getName() = "Array" }

      /** Gets the type of elements of this array. */
      RbiType getElementType() {
        exists(ElementReference refNode | refNode.getReceiver() = this |
          result = refNode.getArgument(0)
        )
      }
    }

    /**
     * A use of `T::Hash`.
     */
    class RbiHashType extends RbiType, ConstantReadAccessFromT {
      RbiHashType() { this.getName() = "Hash" }

      private ElementReference getRefNode() { result.getReceiver() = this }

      /** Gets the type of keys of this hash type. */
      Expr getKeyType() { result = this.getRefNode().getArgument(0) }

      /** Gets the type of values of this hash type. */
      Expr getValueType() { result = this.getRefNode().getArgument(1) }
    }

    /** A type instantiated with type arguments, such as `T::Array[String]`. */
    class RbiInstantiatedType extends RbiType, ElementReference {
      RbiInstantiatedType() { this.getReceiver() instanceof RbiType }
    }

    /**
     * A call to `T.proc`. This defines a type signature for a proc or block
     */
    class ProcCall extends RbiType, SignatureCall, MethodCallAgainstT {
      ProcCall() { this.getMethodName() = "proc" }

      override ReturnsTypeCall getReturnsTypeCall() {
        result.(ProcReturnsTypeCall).getProcCall() = this
      }

      override ProcParamsCall getParamsCall() { result.getProcCall() = this }

      // TODO: widen type for procs/blocks
      override MethodBase getAssociatedMethod() { none() }
    }
  }

  import RbiTypes

  /**
   * A Ruby Interface (RBI) File. These are valid Ruby files that can contain
   * type information used by Sorbet for typechecking.
   *
   * RBI files can contain project source code, or act as external type
   * definition files for existing Ruby code, which may include code in gems.
   */
  class RbiFile extends File {
    RbiFile() { this.getExtension() = "rbi" }
  }

  private newtype TReturnType =
    TRbiType(RbiType t) { exists(ReturnsCall r | r.getRbiType() = t) } or
    TVoidType()

  /** A return type of a method. */
  class ReturnType extends TReturnType {
    /** Gets a textual representation of this node. */
    cached
    string toString() {
      result = this.getRbiType().toString()
      or
      this.isVoidType() and result = "(void)"
    }

    /** Gets the underlying RbiType, if any. */
    RbiType getRbiType() { exists(RbiType t | this = TRbiType(t) | result = t) }

    /** Holds if this is the void type. */
    predicate isVoidType() { this = TVoidType() }
  }

  /**
   * A call that defines a type signature for a method or proc.
   */
  abstract class SignatureCall extends MethodCall {
    abstract ParamsCall getParamsCall();

    abstract ReturnsTypeCall getReturnsTypeCall();

    abstract MethodBase getAssociatedMethod();
  }

  private predicate isMethodSignatureCallNode(CfgNode n) {
    n.(ExprCfgNode).getExpr() instanceof MethodSignatureCall
  }

  /**
   * Holds if `n` is the `i`th transitive successor node of `sigNode` where there
   * are no intervening nodes corresponding to `MethodSignatureCall`s.
   */
  private predicate methodSignatureSuccessorNodeRanked(CfgNode sigNode, CfgNode n, int i) {
    // direct successor
    i = 1 and
    n = sigNode.getASuccessor() and
    not isMethodSignatureCallNode(n)
    or
    // transitive successor
    i > 1 and
    exists(CfgNode np | n = np.getASuccessor() |
      methodSignatureSuccessorNodeRanked(sigNode, np, i - 1) and
      not isMethodSignatureCallNode(np)
    )
  }

  /**
   * A call to a method named `attr_reader` or `attr_accessor`, used to define
   * attribute reader methods for a named attribute.
   */
  class AttrReaderMethodCall extends MethodCall {
    AttrReaderMethodCall() { this.getMethodName() = ["attr_reader", "attr_accessor"] }

    /** Gets a name of an attribute defined by this call. */
    string getAnAttributeName() {
      result = this.getAnArgument().getConstantValue().getStringlikeValue()
    }
  }

  /** A call to `sig` to define the type signature of a method. */
  class MethodSignatureCall extends SignatureCall {
    MethodSignatureCall() { this.getMethodName() = "sig" }

    override ReturnsTypeCall getReturnsTypeCall() {
      result.(MethodReturnsTypeCall).getMethodSignatureCall() = this
    }

    override MethodParamsCall getParamsCall() { result.getMethodSignatureCall() = this }

    private ExprCfgNode getCfgNode() { result.getExpr() = this }

    /**
     * Gets the method whose type signature is defined by this call.
     */
    override MethodBase getAssociatedMethod() {
      result =
        min(ExprCfgNode methodCfgNode, int i |
          methodSignatureSuccessorNodeRanked(this.getCfgNode(), methodCfgNode, i) and
          methodCfgNode.getExpr() instanceof MethodBase
        |
          methodCfgNode order by i
        ).getExpr()
    }

    /**
     * Gets a call to `attr_reader` or `attr_accessor` where the return type of
     * the generated method is described by this call.
     */
    AttrReaderMethodCall getAssociatedAttrReaderCall() {
      result =
        min(ExprNodes::MethodCallCfgNode c, int i |
          c.getExpr() instanceof AttrReaderMethodCall and
          methodSignatureSuccessorNodeRanked(this.getCfgNode(), c, i)
        |
          c order by i
        ).getExpr()
    }

    /**
     * Gets the return type of this type signature.
     */
    ReturnType getReturnType() { result = this.getReturnsTypeCall().getReturnType() }
  }

  /**
   * A method call that defines either:
   *  - the parameters to, or
   *  - the return type of
   * a method.
   */
  class MethodSignatureDefiningCall extends MethodCall {
    private MethodSignatureCall sigCall;

    MethodSignatureDefiningCall() {
      exists(MethodCall c | c = sigCall.getBlock().getAChild() |
        // The typical pattern for the contents of a `sig` block is something
        // like `params(<param defs>).returns(<return type>)` - we want to
        // pick up both of these calls.
        this = c.getReceiver*()
      )
    }

    /**
     * Gets the enclosing `sig` call that defines the overall type signature
     * for the method associated with this call.
     */
    MethodSignatureCall getMethodSignatureCall() { result = sigCall }
  }

  /**
   * A call to `params`. This defines the types of parameters to a method or proc.
   */
  class ParamsCall extends MethodCall {
    ParamsCall() { this.getMethodName() = "params" }

    /**
     * Gets the type of a positional parameter defined by this call.
     */
    ParameterType getPositionalParameterType(int i) {
      result = this.getArgument(i) and
      // explicitly exclude keyword parameters
      not this.getAssociatedParameter(result.getName()) instanceof KeywordParameter and
      // and exclude block arguments
      not this.getAssociatedParameter(result.getName()) instanceof BlockParameter
    }

    /** Gets the type of the keyword parameter named `keyword`. */
    ParameterType getKeywordParameterType(string keyword) {
      exists(KeywordParameter kp |
        kp = this.getAssociatedParameter(keyword) and
        kp.getName() = keyword and
        result.getType() = this.getKeywordArgument(keyword)
      )
    }

    /** Gets the type of the block parameter to the associated method. */
    ParameterType getBlockParameterType() {
      this.getAssociatedParameter(result.getName()) instanceof BlockParameter and
      result = this.getArgument(_)
    }

    /** Gets the parameter with the given name. */
    NamedParameter getAssociatedParameter(string name) {
      result = this.getSignatureCall().getAssociatedMethod().getAParameter() and
      result.getName() = name
    }

    /** Gets the signature call which this params call belongs to. */
    SignatureCall getSignatureCall() { this = result.getParamsCall() }

    /** Gets a parameter type associated with this call */
    ParameterType getAParameterType() {
      result = this.getPositionalParameterType(_) or
      result = this.getKeywordParameterType(_) or
      result = this.getBlockParameterType()
    }
  }

  /**
   * A call that defines a return type for an associated method.
   * The return type is either a specific type, or the void type (i.e. "don't care").
   */
  abstract class ReturnsTypeCall extends MethodCall {
    /** Get the `ReturnType` corresponding to this call. */
    abstract ReturnType getReturnType();
  }

  /**
   * A call to `returns`. Defines the return type of a method or proc.
   */
  class ReturnsCall extends MethodCall {
    ReturnsCall() { this.getMethodName() = "returns" }

    /**
     * Gets the `RbiType` return type of this call.
     */
    RbiType getRbiType() { result = this.getArgument(0) }

    /**
     * Gets the wrapped `ReturnType` of this call.
     */
    ReturnType getReturnType() { result.getRbiType() = this.getRbiType() }
  }

  /**
   * A call to `void`. Essentially a "don't-care" for the return type of a method or proc.
   */
  class VoidCall extends MethodCall {
    VoidCall() { this.getMethodName() = "void" }

    /**
     * Gets the wrapped `ReturnType` of this call.
     */
    ReturnType getReturnType() { result.isVoidType() }
  }

  /** A call that defines the return type of a method. */
  abstract class MethodReturnsTypeCall extends ReturnsTypeCall, MethodSignatureDefiningCall { }

  /** A call to `params` that defines the parameter types of a method */
  class MethodParamsCall extends ParamsCall, MethodSignatureDefiningCall { }

  /** A call to `returns` that defines the return type of a method. */
  class MethodReturnsCall extends MethodReturnsTypeCall instanceof ReturnsCall {
    override ReturnType getReturnType() { result = ReturnsCall.super.getReturnType() }
  }

  /** A call to `void` that specifies that a given method does not return a useful value. */
  class MethodVoidCall extends MethodReturnsTypeCall instanceof VoidCall {
    override ReturnType getReturnType() { result = VoidCall.super.getReturnType() }
  }

  /** A call that defines part of the type signature of a proc or block argument. */
  class ProcSignatureDefiningCall extends MethodCall, RbiType {
    private ProcCall procCall;

    ProcSignatureDefiningCall() { this.getReceiver+() = procCall }

    /**
     * Gets the `proc` call that defines the complete type signature for the
     * associated proc or block argument.
     */
    ProcCall getProcCall() { result = procCall }
  }

  /** A call that defines the return type of a proc or block */
  abstract class ProcReturnsTypeCall extends ReturnsTypeCall, ProcSignatureDefiningCall { }

  /** A call that defines the parameter types of a proc or block. */
  // TODO: there is currently no way to map from this to parameter types with actual associated parameters
  class ProcParamsCall extends ParamsCall, ProcSignatureDefiningCall { }

  /** A call that defines the return type of a non-void proc or block. */
  class ProcReturnsCall extends ProcReturnsTypeCall instanceof ReturnsCall {
    override ReturnType getReturnType() { result = ReturnsCall.super.getReturnType() }
  }

  /**
   * A call to `void` that specifies that a given proc or block does not return
   * a useful value.
   */
  class ProcVoidCall extends ProcReturnsTypeCall instanceof VoidCall {
    override ReturnType getReturnType() { result = VoidCall.super.getReturnType() }
  }

  /**
   * A pair defining the type of a parameter to a method.
   *
   * This is an argument to some call to `params`.
   */
  class ParameterType extends Pair {
    private ParamsCall paramsCall;

    ParameterType() { paramsCall.getAnArgument() = this }

    private SignatureCall getMethodSignatureCall() { paramsCall = result.getParamsCall() }

    private MethodBase getAssociatedMethod() {
      result = this.getMethodSignatureCall().(MethodSignatureCall).getAssociatedMethod()
    }

    /** Gets the `RbiType` of this parameter. */
    RbiType getType() { result = this.getValue() }

    /** Gets the name of this parameter. */
    string getName() { result = this.getKey().getConstantValue().getStringlikeValue() }

    /** Gets the `NamedParameter` to which this type applies. */
    NamedParameter getParameter() {
      result = this.getAssociatedMethod().getAParameter() and
      result.getName() = this.getName()
    }
  }
}
