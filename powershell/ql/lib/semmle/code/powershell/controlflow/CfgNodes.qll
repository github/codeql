/** Provides classes representing nodes in a control flow graph. */

private import powershell
private import BasicBlocks
private import ControlFlowGraph
private import internal.ControlFlowGraphImpl as CfgImpl

/** An entry node for a given scope. */
class EntryNode extends CfgNode, CfgImpl::EntryNode {
  override string getAPrimaryQlClass() { result = "EntryNode" }

  final override EntryBasicBlock getBasicBlock() { result = super.getBasicBlock() }
}

/** An exit node for a given scope, annotated with the type of exit. */
class AnnotatedExitNode extends CfgNode, CfgImpl::AnnotatedExitNode {
  override string getAPrimaryQlClass() { result = "AnnotatedExitNode" }

  final override AnnotatedExitBasicBlock getBasicBlock() { result = super.getBasicBlock() }
}

/** An exit node for a given scope. */
class ExitNode extends CfgNode, CfgImpl::ExitNode {
  override string getAPrimaryQlClass() { result = "ExitNode" }
}

/**
 * A node for an AST node.
 *
 * Each AST node maps to zero or more `AstCfgNode`s: zero when the node is unreachable
 * (dead) code or not important for control flow, and multiple when there are different
 * splits for the AST node.
 */
class AstCfgNode extends CfgNode, CfgImpl::AstCfgNode {
  /** Gets the name of the primary QL class for this node. */
  override string getAPrimaryQlClass() { result = "AstCfgNode" }
}

/** A control-flow node that wraps an AST expression. */
class ExprCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "ExprCfgNode" }

  Expr e;

  ExprCfgNode() { e = this.getAstNode() }

  /** Gets the underlying expression. */
  Expr getExpr() { result = e }

  final ConstantValue getValue() { result = e.getValue() }
}

/** A control-flow node that wraps an AST statement. */
class StmtCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "StmtCfgNode" }

  Stmt s;

  StmtCfgNode() { s = this.getAstNode() }

  /** Gets the underlying expression. */
  Stmt getStmt() { result = s }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ChildMapping extends Ast {
  /**
   * Holds if `child` is a (possibly nested) child of this expression
   * for which we would like to find a matching CFG child.
   */
  abstract predicate relevantChild(Ast child);

  pragma[nomagic]
  abstract predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb);

  /**
   * Holds if there is a control-flow path from `cfn` to `cfnChild`, where `cfn`
   * is a control-flow node for this expression, and `cfnChild` is a control-flow
   * node for `child`.
   *
   * The path never escapes the syntactic scope of this expression.
   */
  cached
  predicate hasCfgChild(Ast child, CfgNode cfn, CfgNode cfnChild) {
    this.reachesBasicBlock(child, cfn, cfnChild.getBasicBlock()) and
    cfnChild.getAstNode() = child
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class ExprChildMapping extends Expr, ChildMapping {
  pragma[nomagic]
  override predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn.getAstNode() = this and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getAPredecessor() and
      not mid.getANode().getAstNode() = child
    )
  }
}

/**
 * A class for mapping parent-child AST nodes to parent-child CFG nodes.
 */
abstract private class NonExprChildMapping extends ChildMapping {
  NonExprChildMapping() { not this instanceof Expr }

  pragma[nomagic]
  override predicate reachesBasicBlock(Ast child, CfgNode cfn, BasicBlock bb) {
    this.relevantChild(child) and
    cfn.getAstNode() = this and
    bb.getANode() = cfn
    or
    exists(BasicBlock mid |
      this.reachesBasicBlock(child, cfn, mid) and
      bb = mid.getASuccessor() and
      not mid.getANode().getAstNode() = child
    )
  }
}

abstract private class AbstractCallCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "CfgCall" }

  /** Holds if this call invokes a function with the name `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /** Gets the name of the function that is invoked by this call. */
  abstract string getName();

  /** Gets the qualifier of this call, if any. */
  ExprCfgNode getQualifier() { none() }

  /** Gets the i'th argument to this call. */
  abstract ExprCfgNode getArgument(int i);

  /** Gets the i'th positional argument to this call. */
  abstract ExprCfgNode getPositionalArgument(int i);

  /** Gets the argument with the name `name`, if any. */
  abstract ExprCfgNode getNamedArgument(string name);

  /**
   * Gets any argument of this call.
   *
   * Note that this predicate doesn't get the pipeline argument, if any.
   */
  abstract ExprCfgNode getAnArgument();

  /**
   * Gets the expression that provides the call target of this call, if any.
   */
  abstract ExprCfgNode getCommand();

  int getNumberOfArguments() { result = count(this.getAnArgument()) }
}

final class CallCfgNode = AbstractCallCfgNode;

class ObjectCreationCfgNode extends CallCfgNode {
  ObjectCreation objectCreation;

  ObjectCreationCfgNode() { this.getAstNode() = objectCreation }

  ObjectCreation getObjectCreation() { result = objectCreation }

  Type getConstructedType() { result = objectCreation.getConstructedType() }

  string getConstructedTypeName() { result = objectCreation.getConstructedTypeName() }
}

private class NamedBlockChildMapping extends NonExprChildMapping, NamedBlock {
  override predicate relevantChild(Ast n) { n = this.getAStmt() } // TODO: Handle getATrap
}

class NamedBlockCfgNode extends AstCfgNode {
  NamedBlockChildMapping block;

  NamedBlockCfgNode() { this.getAstNode() = block }

  NamedBlock getBlock() { result = block }

  StmtCfgNode getStmt(int i) { block.hasCfgChild(block.getStmt(i), this, result) }

  StmtCfgNode getAStmt() { block.hasCfgChild(block.getAStmt(), this, result) }
}

private class ProcessBlockChildMapping extends NamedBlockChildMapping, ProcessBlock { }

class ProcessBlockCfgNode extends NamedBlockCfgNode {
  override ProcessBlockChildMapping block;

  override ProcessBlock getBlock() { result = block }

  PipelineParameter getPipelineParameter() { result = block.getPipelineParameter() }

  PipelineByPropertyNameParameter getAPipelineByPropertyNameParameter() {
    result = block.getAPipelineByPropertyNameParameter()
  }
}

private class StmtBlockChildMapping extends NonExprChildMapping, StmtBlock {
  override predicate relevantChild(Ast n) { n = this.getAStmt() or n = this.getAnElement() }
}

class StmtBlockCfgNode extends AstCfgNode {
  StmtBlockChildMapping block;

  StmtBlockCfgNode() { this.getAstNode() = block }

  StmtBlock getBlock() { result = block }

  StmtCfgNode getStmt(int i) { block.hasCfgChild(block.getStmt(i), this, result) }

  StmtCfgNode getAStmt() { block.hasCfgChild(block.getAStmt(), this, result) }

  /** Gets an AST element that may be returned from this `StmtBlockCfgNode`. */
  AstCfgNode getAnElement() { block.hasCfgChild(block.getAnElement(), this, result) }
}

/** Provides classes for control-flow nodes that wrap AST expressions. */
module ExprNodes {
  private class VarAccessChildMapping extends ExprChildMapping, VarAccess {
    override predicate relevantChild(Ast n) { none() }
  }

  class VarAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "VarAccessCfgNode" }

    override VarAccessChildMapping e;

    override VarAccess getExpr() { result = super.getExpr() }

    Variable getVariable() { result = e.getVariable() }
  }

  private class VarReadAccessChildMapping extends VarAccessChildMapping, VarReadAccess { }

  class VarReadAccessCfgNode extends VarAccessCfgNode {
    override string getAPrimaryQlClass() { result = "VarReadAccessCfgNode" }

    override VarReadAccessChildMapping e;

    override VarReadAccess getExpr() { result = super.getExpr() }
  }

  private class VarWriteAccessChildMapping extends VarAccessChildMapping, VarWriteAccess { }

  class VarWriteAccessCfgNode extends VarAccessCfgNode {
    override string getAPrimaryQlClass() { result = "VarWriteAccessCfgNode" }

    override VarWriteAccessChildMapping e;

    override VarWriteAccess getExpr() { result = super.getExpr() }

    predicate isExplicitWrite(StmtNodes::AssignStmtCfgNode assignment) {
      this = assignment.getLeftHandSide()
    }

    predicate isImplicitWrite() { e.isImplicit() }
  }

  /** A control-flow node that wraps an argument expression. */
  class ArgumentCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArgumentCfgNode" }

    override Argument e;

    final override Argument getExpr() { result = super.getExpr() }

    /** Gets the position of this argument, if any. */
    int getPosition() { result = e.getPosition() }

    /** Gets the name of this argument, if any. */
    string getName() { result = e.getName() }

    /** Holds if `this` is a qualifier to a call. */
    predicate isQualifier() { e.isQualifier() }

    /** Gets the call for which this is an argument. */
    CallCfgNode getCall() { result.getAnArgument() = this or result.getQualifier() = this }
  }

  private class InvokeMemberChildMapping extends ExprChildMapping, InvokeMemberExpr {
    override predicate relevantChild(Ast n) { n = this.getQualifier() or n = this.getAnArgument() }
  }

  /** A control-flow node that wraps an `InvokeMemberExpr` expression. */
  class InvokeMemberCfgNode extends ExprCfgNode, AbstractCallCfgNode {
    override string getAPrimaryQlClass() { result = "InvokeMemberCfgNode" }

    override InvokeMemberChildMapping e;

    override InvokeMemberExpr getExpr() { result = super.getExpr() }

    final override ExprCfgNode getQualifier() { e.hasCfgChild(e.getQualifier(), this, result) }

    final override ExprCfgNode getArgument(int i) { e.hasCfgChild(e.getArgument(i), this, result) }

    final override ExprCfgNode getPositionalArgument(int i) { result = this.getArgument(i) }

    final override ExprCfgNode getNamedArgument(string name) { none() }

    final override ExprCfgNode getAnArgument() { e.hasCfgChild(e.getAnArgument(), this, result) }

    final override string getName() { result = e.getName() }

    final override ExprCfgNode getCommand() { none() }
  }

  /** A control-flow node that wraps an `ConstructorCall` expression. */
  class ConstructorCallCfgNode extends InvokeMemberCfgNode {
    ConstructorCallCfgNode() { super.getExpr() instanceof ConstructorCall }

    final override ConstructorCall getExpr() { result = super.getExpr() }

    Type getConstructedType() { result = this.getExpr().getConstructedType() }
  }

  /** A control-flow node that wraps a qualifier expression. */
  class QualifierCfgNode extends ExprCfgNode {
    QualifierCfgNode() { this = any(InvokeMemberCfgNode invoke).getQualifier() }

    InvokeMemberCfgNode getInvokeMember() { this = result.getQualifier() }
  }

  class TypeNameChildMapping extends ExprChildMapping, TypeNameExpr {
    override predicate relevantChild(Ast n) { none() }
  }

  /** A control-flow node that wraps a `TypeName` expression. */
  class TypeNameCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "TypeNameCfgNode" }

    override TypeNameChildMapping e;

    override TypeNameExpr getExpr() { result = super.getExpr() }

    Type getType() { result = this.getExpr().getType() }

    string getTypeName() { result = this.getExpr().getName() }
  }

  class ConditionalChildMapping extends ExprChildMapping, ConditionalExpr {
    override predicate relevantChild(Ast n) { n = this.getCondition() or n = this.getABranch() }
  }

  /** A control-flow node that wraps a `ConditionalExpr` expression. */
  class ConditionalCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConditionalCfgNode" }

    override ConditionalChildMapping e;

    final override ConditionalExpr getExpr() { result = super.getExpr() }

    final ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    final ExprCfgNode getBranch(boolean value) { e.hasCfgChild(e.getBranch(value), this, result) }

    final ExprCfgNode getABranch() { result = this.getBranch(_) }

    final ExprCfgNode getIfTrue() { e.hasCfgChild(e.getIfTrue(), this, result) }

    final ExprCfgNode getIfFalse() { e.hasCfgChild(e.getIfFalse(), this, result) }
  }

  class MemberChildMapping extends ExprChildMapping, MemberExpr {
    override predicate relevantChild(Ast n) { n = this.getQualifier() or n = this.getMember() }
  }

  /** A control-flow node that wraps a `MemberExpr` expression. */
  class MemberCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "MemberCfgNode" }

    override MemberChildMapping e;

    final override MemberExpr getExpr() { result = super.getExpr() }

    final ExprCfgNode getQualifier() { e.hasCfgChild(e.getQualifier(), this, result) }

    final string getMemberName() { result = e.getMemberName() }

    predicate isStatic() { e.isStatic() }
  }

  /** A control-flow node that wraps a `MemberExpr` expression that is being written to. */
  class MemberCfgWriteAccessNode extends MemberCfgNode {
    MemberCfgWriteAccessNode() { this.getExpr() instanceof MemberExprWriteAccess }

    StmtNodes::AssignStmtCfgNode getAssignStmt() { result.getLeftHandSide() = this }
  }

  /** A control-flow node that wraps a `MemberExpr` expression that is being read from. */
  class MemberCfgReadAccessNode extends MemberCfgNode {
    MemberCfgReadAccessNode() { this.getExpr() instanceof MemberExprReadAccess }
  }

  class ArrayLiteralChildMapping extends ExprChildMapping, ArrayLiteral {
    override predicate relevantChild(Ast n) { n = this.getAnElement() }
  }

  class ArrayLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayLiteralCfgNode" }

    override ArrayLiteralChildMapping e;

    ExprCfgNode getElement(int i) { e.hasCfgChild(e.getElement(i), this, result) }

    ExprCfgNode getAnElement() { e.hasCfgChild(e.getAnElement(), this, result) }
  }

  class IndexChildMapping extends ExprChildMapping, IndexExpr {
    override predicate relevantChild(Ast n) { n = this.getBase() or n = this.getIndex() }
  }

  /** A control-flow node that wraps a `MemberExpr` expression. */
  class IndexCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "IndexCfgNode" }

    override IndexChildMapping e;

    final ExprCfgNode getBase() { e.hasCfgChild(e.getBase(), this, result) }

    final ExprCfgNode getIndex() { e.hasCfgChild(e.getIndex(), this, result) }
  }

  /** A control-flow node that wraps a `MemberExpr` expression that is being written to. */
  class IndexCfgWriteNode extends IndexCfgNode {
    IndexCfgWriteNode() { this.getExpr() instanceof IndexExprWrite }

    StmtNodes::AssignStmtCfgNode getAssignStmt() { result.getLeftHandSide() = this }
  }

  /** A control-flow node that wraps a `MemberExpr` expression that is being read from. */
  class IndexCfgReadNode extends IndexCfgNode {
    IndexCfgReadNode() { this.getExpr() instanceof IndexExprRead }
  }

  class ArrayExprChildMapping extends ExprChildMapping, ArrayExpr {
    override predicate relevantChild(Ast n) { n = this.getStmtBlock() or n = this.getAnElement() }
  }

  class ArrayExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayExprCfgNode" }

    override ArrayExprChildMapping e;

    ExprCfgNode getElement(int i) { e.hasCfgChild(e.getElement(i), this, result) }

    ExprCfgNode getAnElement() { result = this.getElement(_) }

    StmtBlockCfgNode getStmtBlock() { e.hasCfgChild(e.getStmtBlock(), this, result) }
  }

  class HashTableChildMapping extends ExprChildMapping, HashTableExpr {
    override predicate relevantChild(Ast n) { this.hasEntry(_, _, n) or this.hasEntry(_, n, _) }
  }

  class HashTableCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "HashMapCfgNode" }

    override HashTableChildMapping e;

    override HashTableExpr getExpr() { result = super.getExpr() }

    StmtCfgNode getElement(ExprCfgNode key) {
      exists(Expr eKey |
        eKey = key.getAstNode() and
        e.hasCfgChild(eKey, this, key) and
        e.hasCfgChild(e.getElement(eKey), this, result)
      )
    }

    predicate hasKey(ExprCfgNode key) { exists(this.getElement(key)) }

    StmtCfgNode getAnElement() { result = this.getElement(_) }

    predicate hasEntry(int index, ExprCfgNode key, StmtCfgNode value) {
      exists(Expr eKey, Stmt sValue |
        e.hasCfgChild(eKey, this, key) and
        e.hasCfgChild(sValue, this, value) and
        e.hasEntry(index, eKey, sValue)
      )
    }
  }

  class ConvertExprChildMapping extends ExprChildMapping, ConvertExpr {
    override predicate relevantChild(Ast n) { n = this.getBase() }
  }

  class ConvertCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConvertCfgNode" }

    override ConvertExprChildMapping e;

    override ConvertExpr getExpr() { result = e }

    final ExprCfgNode getBase() { e.hasCfgChild(e.getBase(), this, result) }

    TypeConstraint getType() { result = e.getType() }
  }

  class ParenExprChildMapping extends ExprChildMapping, ParenExpr {
    override predicate relevantChild(Ast n) { n = this.getBase() }
  }

  class ParenCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ParenExprCfgNode" }

    override ParenExprChildMapping e;

    override ParenExpr getExpr() { result = e }

    final StmtCfgNode getBase() { e.hasCfgChild(e.getBase(), this, result) }
  }

  class UnaryExprChildMapping extends ExprChildMapping, UnaryExpr {
    override predicate relevantChild(Ast n) { n = this.getOperand() }
  }

  class UnaryCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "UnaryExprCfgNode" }

    override UnaryExprChildMapping e;

    override UnaryExpr getExpr() { result = e }

    final ExprCfgNode getOperand() { e.hasCfgChild(e.getOperand(), this, result) }
  }

  class BinaryExprChildMapping extends ExprChildMapping, BinaryExpr {
    override predicate relevantChild(Ast n) { n = this.getLeft() or n = this.getRight() }
  }

  class BinaryCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BinaryExprCfgNode" }

    override BinaryExprChildMapping e;

    override BinaryExpr getExpr() { result = e }

    final ExprCfgNode getLeft() { e.hasCfgChild(e.getLeft(), this, result) }

    final ExprCfgNode getRight() { e.hasCfgChild(e.getRight(), this, result) }
  }

  class OperationChildMapping extends ExprChildMapping instanceof Operation {
    override predicate relevantChild(Ast n) { n = super.getAnOperand() }
  }

  class OperationCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "OperationCfgNode" }

    override OperationChildMapping e;

    override Operation getExpr() { result = e }

    final ExprCfgNode getAnOperand() { e.hasCfgChild(this.getExpr().getAnOperand(), this, result) }
  }

  class ExpandableStringChildMappinig extends ExprChildMapping, ExpandableStringExpr {
    override predicate relevantChild(Ast n) { n = this.getAnExpr() }
  }

  class ExpandableStringCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ExpandableStringCfgNode" }

    override ExpandableStringChildMappinig e;

    override ExpandableStringExpr getExpr() { result = e }

    ExprCfgNode getExpr(int i) { e.hasCfgChild(e.getExpr(i), this, result) }

    ExprCfgNode getAnExpr() { result = this.getExpr(_) }
  }
}

module StmtNodes {
  private class CmdChildMapping extends CmdBaseChildMapping, Cmd {
    override predicate relevantChild(Ast n) { n = this.getAnArgument() or n = this.getCommand() }
  }

  /** A control-flow node that wraps a `Cmd` AST expression. */
  class CmdCfgNode extends CmdBaseCfgNode, AbstractCallCfgNode {
    override string getAPrimaryQlClass() { result = "CmdCfgNode" }

    override CmdChildMapping s;

    override Cmd getStmt() { result = super.getStmt() }

    override ExprCfgNode getArgument(int i) { s.hasCfgChild(s.getArgument(i), this, result) }

    override ExprCfgNode getPositionalArgument(int i) {
      s.hasCfgChild(s.getPositionalArgument(i), this, result)
    }

    override ExprCfgNode getNamedArgument(string name) {
      s.hasCfgChild(s.getNamedArgument(name), this, result)
    }

    override ExprCfgNode getAnArgument() { s.hasCfgChild(s.getAnArgument(), this, result) }

    final override ExprCfgNode getCommand() { s.hasCfgChild(s.getCommand(), this, result) }

    final override string getName() { result = s.getCmdName().getValue().getValue() }
  }

  /** A control-flow node that wraps a call to operator `&` */
  class CallOperatorCfgNode extends CmdCfgNode {
    CallOperatorCfgNode() { this.getStmt() instanceof CallOperator }
  }

  private class AssignStmtChildMapping extends PipelineBaseChildMapping, AssignStmt {
    override predicate relevantChild(Ast n) {
      n = this.getLeftHandSide() or n = this.getRightHandSide()
    }
  }

  /** A control-flow node that wraps an `AssignStmt` AST expression. */
  class AssignStmtCfgNode extends PipelineBaseCfgNode {
    override string getAPrimaryQlClass() { result = "AssignCfgNode" }

    override AssignStmtChildMapping s;

    override AssignStmt getStmt() { result = super.getStmt() }

    /** Gets the LHS of this assignment. */
    final ExprCfgNode getLeftHandSide() { s.hasCfgChild(s.getLeftHandSide(), this, result) }

    /** Gets the RHS of this assignment. */
    final StmtCfgNode getRightHandSide() { s.hasCfgChild(s.getRightHandSide(), this, result) }
  }

  class CmdExprChildMapping extends CmdBaseChildMapping, CmdExpr {
    override predicate relevantChild(Ast n) { n = this.getExpr() }
  }

  /** A control-flow node that wraps a `CmdExpr` expression. */
  class CmdExprCfgNode extends CmdBaseCfgNode {
    override string getAPrimaryQlClass() { result = "CmdExprCfgNode" }

    override CmdExprChildMapping s;

    override CmdExpr getStmt() { result = super.getStmt() }

    final ExprCfgNode getExpr() { s.hasCfgChild(s.getExpr(), this, result) }
  }

  class PipelineBaseChildMapping extends NonExprChildMapping, PipelineBase {
    override predicate relevantChild(Ast n) { none() }
  }

  class PipelineBaseCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "PipelineBaseCfgNode" }

    override PipelineBaseChildMapping s;

    override PipelineBase getStmt() { result = super.getStmt() }
  }

  class ChainableChildMapping extends PipelineBaseChildMapping, Chainable {
    override predicate relevantChild(Ast n) { none() }
  }

  class ChainableCfgNode extends PipelineBaseCfgNode {
    override string getAPrimaryQlClass() { result = "ChainableCfgNode" }

    override ChainableChildMapping s;

    override Chainable getStmt() { result = super.getStmt() }
  }

  class PipelineChainChildMapping extends ChainableChildMapping, PipelineChain {
    override predicate relevantChild(Ast n) { n = this.getLeft() or n = this.getRight() }
  }

  class PipelineChainCfgNode extends ChainableCfgNode {
    override string getAPrimaryQlClass() { result = "PipelineChainCfgNode" }

    override PipelineChainChildMapping s;

    override PipelineChain getStmt() { result = super.getStmt() }

    final ChainableCfgNode getLeft() { s.hasCfgChild(s.getLeft(), this, result) }

    final ChainableCfgNode getRight() { s.hasCfgChild(s.getRight(), this, result) }
  }

  class CmdBaseChildMapping extends ChainableChildMapping, CmdBase { }

  class CmdBaseCfgNode extends ChainableCfgNode {
    override string getAPrimaryQlClass() { result = "CmdBaseCfgNode" }

    override CmdBaseChildMapping s;

    override CmdBase getStmt() { result = super.getStmt() }
  }

  class PipelineChildMapping extends ChainableChildMapping, Pipeline {
    override predicate relevantChild(Ast n) { n = this.getAComponent() }
  }

  class PipelineCfgNode extends ChainableCfgNode {
    override string getAPrimaryQlClass() { result = "PipelineCfgNode" }

    override PipelineChildMapping s;

    override Pipeline getStmt() { result = super.getStmt() }

    final CmdBaseCfgNode getComponent(int i) { s.hasCfgChild(s.getComponent(i), this, result) }

    final CmdBaseCfgNode getAComponent() { s.hasCfgChild(s.getAComponent(), this, result) }
  }
}
