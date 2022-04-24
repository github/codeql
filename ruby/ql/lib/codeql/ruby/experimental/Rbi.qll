/**
 * Provides classes and predicates for working with Ruby Interface (RBI) files
 * and concepts. RBI files are valid Ruby files that can contain type
 * information used by Sorbet for typechecking.
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.AST
private import codeql.ruby.CFG
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow

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
    abstract class RbiType extends DataFlow::Node { }

    class ConstantReadAccessAsRbiType extends RbiType {
      private ExprNodes::ConstantReadAccessCfgNode acc;

      ConstantReadAccessAsRbiType() {
        acc = this.asExpr()
        // TODO: should this class be more restrictive?
      }
    }

    /**
     * A call to `T.any` - a method that takes `RbiType` parameters, and returns
     * a type representing the union of those types.
     */
    class RbiUnionType extends RbiType, DataFlow::CallNode {
      RbiUnionType() { this = API::getTopLevelMember("T").getAMethodCall("any") }

      /**
       * Gets a constituent type of this type union.
       */
      RbiType getAType() { result = this.getArgument(_) }
    }

    /**
     * A call to `T.untyped`.
     */
    class RbiUntypedType extends RbiType, DataFlow::CallNode {
      RbiUntypedType() { this = API::getTopLevelMember("T").getAMethodCall("untyped") }
    }

    /**
     * A call to `T.nilable`, creating a nilable version of the type provided as
     * an argument.
     */
    class RbiNilableType extends RbiType, DataFlow::CallNode {
      RbiNilableType() { this = API::getTopLevelMember("T").getAMethodCall("nilable") }

      /** Gets the type that this may represent if not nil. */
      RbiType getUnderlyingType() { result = this.getArgument(0) }
    }

    /**
     * A call to `T.type_alias`. The return value of this call can be assigned to
     * create a type alias.
     */
    class RbiTypeAlias extends RbiType, DataFlow::CallNode {
      RbiTypeAlias() { this = API::getTopLevelMember("T").getAMethodCall("type_alias") }

      // TODO: avoid mapping to AST layer
      /**
       * Gets the type aliased by this call.
       */
      RbiType getAliasedType() {
        result.asExpr().getExpr() =
          this.getBlock().asExpr().(ExprNodes::StmtSequenceCfgNode).getExpr().getLastStmt()
      }
    }

    /**
     * A call to `T.self_type`.
     */
    class RbiSelfType extends RbiType, DataFlow::CallNode {
      RbiSelfType() { this = API::getTopLevelMember("T").getAMethodCall("self_type") }
    }

    /**
     * A call to `T.noreturn`.
     */
    class RbiNoreturnType extends RbiType, DataFlow::CallNode {
      RbiNoreturnType() { this = API::getTopLevelMember("T").getAMethodCall("noreturn") }
    }

    /**
     * A use of `T::Boolean`.
     */
    class RbiBooleanType extends RbiType {
      RbiBooleanType() { this = API::getTopLevelMember("T").getMember("Boolean").getAUse() }
    }

    /**
     * A use of `T::Array`.
     */
    class RbiArrayType extends RbiType {
      RbiArrayType() { this = API::getTopLevelMember("T").getMember("Array").getAUse() }

      /** Gets the type of elements of this array. */
      RbiType getElementType() {
        exists(DataFlow::CallNode refNode |
          refNode.getReceiver() = this and
          refNode.asExpr() instanceof ExprNodes::ElementReferenceCfgNode
        |
          result = refNode.getArgument(0)
        )
      }
    }

    class RbiHashType extends RbiType {
      RbiHashType() { this = API::getTopLevelMember("T").getMember("Hash").getAUse() }

      private DataFlow::CallNode getRefNode() {
        result.getReceiver() = this and
        result.asExpr() instanceof ExprNodes::ElementReferenceCfgNode
      }

      /** Gets the type of keys of this hash type. */
      DataFlow::Node getKeyType() { result = this.getRefNode().getArgument(0) }

      /** Gets the type of values of this hash type. */
      DataFlow::Node getValueType() { result = this.getRefNode().getArgument(1) }
    }

    /**
     * A call to `T.proc`. This defines a type signature for a proc or block
     */
    class ProcCall extends RbiType, SignatureCall {
      ProcCall() { this = API::getTopLevelMember("T").getAMethodCall("proc") }

      private ProcReturnsTypeCall getReturnsTypeCall() { result.getProcCall() = this }

      private ProcParamsCall getParamsCall() { result.getProcCall() = this }

      /**
       * Gets the return type of this type signature.
       */
      override ReturnType getReturnType() { result = this.getReturnsTypeCall().getReturnType() }

      /**
       * Gets the type of a parameter of this type signature.
       */
      override ParameterType getAParameterType() {
        result = this.getParamsCall().getAParameterType()
      }
      // TODO: get associated method to which this can be passed
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
  abstract class SignatureCall extends DataFlow::CallNode {
    /**
     * Gets the return type of this type signature.
     */
    abstract ReturnType getReturnType();

    /**
     * Gets the type of a parameter of this type signature.
     */
    abstract ParameterType getAParameterType();
  }

  /**
   * Holds if `n` is the `r`th transitive successor node of `sig` where there are
   * no intervening `MethodSignatureCall`s.
   */
  private predicate methodSignatureSuccessorNodeRanked(MethodSignatureCall sig, CfgNode n, int r) {
    exists(CfgNode p2 | not exists(MethodSignatureCall s | s.asExpr() = p2) |
      r = 1 and p2 = sig.asExpr().getASuccessor() and p2 = n
      or
      // set an arbitrary limit on how long the successor chain can be
      r = [2 .. 6] and
      methodSignatureSuccessorNodeRanked(sig, p2, r - 1) and
      n = p2.getASuccessor()
    )
  }

  /** A call to `sig` to define the type signature of a method. */
  class MethodSignatureCall extends SignatureCall {
    MethodSignatureCall() { this.getMethodName() = "sig" }

    private MethodReturnsTypeCall getReturnsTypeCall() { result.getMethodSignatureCall() = this }

    private MethodParamsCall getParamsCall() { result.getMethodSignatureCall() = this }

    /**
     * Gets the method whose type signature is defined by this call.
     */
    ExprNodes::MethodBaseCfgNode getAssociatedMethod() {
      result =
        min(ExprNodes::MethodBaseCfgNode m, int i |
          methodSignatureSuccessorNodeRanked(this, m, i)
        |
          m order by i
        )
    }

    /**
     * Gets a call to `attr_reader` or `attr_accessor` where the return type of
     * the generated method is described by this call.
     */
    ExprNodes::MethodCallCfgNode getAssociatedAttrReaderCall() {
      result =
        min(ExprNodes::MethodCallCfgNode c, int i |
          c.getExpr().getMethodName() = ["attr_reader", "attr_accessor"] and
          methodSignatureSuccessorNodeRanked(this, c, i)
        |
          c order by i
        )
    }

    /**
     * Gets the return type of this type signature.
     */
    override ReturnType getReturnType() { result = this.getReturnsTypeCall().getReturnType() }

    /**
     * Gets the type of a parameter of this type signature.
     */
    override ParameterType getAParameterType() { result = this.getParamsCall().getAParameterType() }
  }

  /**
   * A method call that defines either:
   *  - the parameters to, or
   *  - the return type of
   * a method.
   */
  class MethodSignatureDefiningCall extends DataFlow::CallNode {
    private MethodSignatureCall sigCall;

    MethodSignatureDefiningCall() {
      // TODO: avoid mapping to AST layer
      exists(MethodCall c | c = sigCall.getBlock().asExpr().getExpr().getAChild() |
        // The typical pattern for the contents of a `sig` block is something
        // like `params(<param defs>).returns(<return type>)` - we want to
        // pick up both of these calls.
        this.asExpr().getExpr() = c.getReceiver*()
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
  class ParamsCall extends DataFlow::CallNode {
    ParamsCall() { this.getMethodName() = "params" }

    /**
     * Gets the type of a parameter defined by this call.
     */
    ParameterType getAParameterType() { result = this.getArgument(_).asExpr() }
  }

  abstract class ReturnsTypeCall extends DataFlow::CallNode {
    abstract ReturnType getReturnType();
  }

  /**
   * A call to `returns`. Defines the return type of a method or proc.
   */
  class ReturnsCall extends DataFlow::CallNode {
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
  class VoidCall extends DataFlow::CallNode {
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

  /** A call to `void` that spcifies that a given method does not return a useful value. */
  class MethodVoidCall extends MethodReturnsTypeCall instanceof VoidCall {
    override ReturnType getReturnType() { result = VoidCall.super.getReturnType() }
  }

  /** A call that defines part of the type signature of a proc or block argument. */
  class ProcSignatureDefiningCall extends DataFlow::CallNode, RbiType {
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
  class ProcParamsCall extends ParamsCall, ProcSignatureDefiningCall { }

  /** A call that defines the return type of a non-void proc or block. */
  class ProcReturnsCall extends ProcReturnsTypeCall instanceof ReturnsCall {
    override ReturnType getReturnType() { result = ReturnsCall.super.getReturnType() }
  }

  /**
   * A call to `void` that spcifies that a given proc or block does not return
   * a useful value.
   */
  class ProcVoidCall extends ProcReturnsTypeCall instanceof VoidCall {
    override ReturnType getReturnType() { result = VoidCall.super.getReturnType() }
  }

  /**
   * A pair defining the type of a parameter to a method.
   */
  class ParameterType extends ExprNodes::PairCfgNode {
    private RbiType t;

    ParameterType() { t.asExpr() = this.getValue() }

    /** Gets the `RbiType` of this parameter. */
    RbiType getType() { result = t }

    private SignatureCall getOuterMethodSignatureCall() { this = result.getAParameterType() }

    private ExprNodes::MethodBaseCfgNode getAssociatedMethod() {
      result = this.getOuterMethodSignatureCall().(MethodSignatureCall).getAssociatedMethod()
    }

    /** Gets the parameter to which this type applies. */
    NamedParameter getParameter() {
      result = this.getAssociatedMethod().getExpr().getAParameter() and
      result.getName() = this.getKey().getConstantValue().getStringlikeValue()
    }
  }
}
