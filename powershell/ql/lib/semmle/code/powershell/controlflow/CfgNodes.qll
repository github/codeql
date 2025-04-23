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

private class AttributeBaseChildMapping extends NonExprChildMapping, AttributeBase {
  override predicate relevantChild(Ast child) { none() }
}

class AttributeBaseCfgNode extends AstCfgNode {
  AttributeBaseCfgNode() { attr = this.getAstNode() }

  override string getAPrimaryQlClass() { result = "AttributeBaseCfgNode" }

  AttributeBaseChildMapping attr;
}

private class AttributeChildMapping extends AttributeBaseChildMapping, Attribute {
  override predicate relevantChild(Ast child) {
    this.relevantChild(child)
    or
    child = this.getANamedArgument()
    or
    child = this.getAPositionalArgument()
  }
}

private class NamedAttributeArgumentChildMapping extends NonExprChildMapping, NamedAttributeArgument
{
  override predicate relevantChild(Ast child) { child = this.getValue() }
}

class NamedAttributeArgumentCfgNode extends AstCfgNode {
  NamedAttributeArgumentCfgNode() { attr = this.getAstNode() }

  override string getAPrimaryQlClass() { result = "NamedAttributeArgumentCfgNode" }

  NamedAttributeArgumentChildMapping attr;

  NamedAttributeArgument getAttr() { result = attr }

  ExprCfgNode getValue() { attr.hasCfgChild(attr.getValue(), this, result) }

  string getName() { result = attr.getName() }
}

class AttributeCfgNode extends AttributeBaseCfgNode {
  override string getAPrimaryQlClass() { result = "AttributeCfgNode" }

  override AttributeChildMapping attr;

  NamedAttributeArgumentCfgNode getNamedArgument(int i) {
    attr.hasCfgChild(attr.getNamedArgument(i), this, result)
  }

  ExprCfgNode getPositionalArgument(int i) {
    attr.hasCfgChild(attr.getPositionalArgument(i), this, result)
  }
}

private class ScriptBlockChildMapping extends NonExprChildMapping, ScriptBlock {
  override predicate relevantChild(Ast child) {
    child = this.getProcessBlock()
    or
    child = this.getBeginBlock()
    or
    child = this.getEndBlock()
    or
    child = this.getDynamicBlock()
    or
    child = this.getAnAttribute()
    or
    child = this.getAParameter()
  }
}

private class ParameterChildMapping extends NonExprChildMapping, Parameter {
  override predicate relevantChild(Ast child) {
    child = this.getAnAttribute() or child = this.getDefaultValue()
  }
}

class ParameterCfgNode extends AstCfgNode {
  ParameterCfgNode() { param = this.getAstNode() }

  override string getAPrimaryQlClass() { result = "ParameterCfgNode" }

  ParameterChildMapping param;

  Parameter getParameter() { result = param }

  ExprCfgNode getDefaultValue() { param.hasCfgChild(param.getDefaultValue(), this, result) }

  AttributeCfgNode getAttribute(int i) { param.hasCfgChild(param.getAttribute(i), this, result) }

  AttributeCfgNode getAnAttribute() { result = this.getAttribute(_) }
}

class ScriptBlockCfgNode extends AstCfgNode {
  ScriptBlockCfgNode() { block = this.getAstNode() }

  override string getAPrimaryQlClass() { result = "ScriptBlockCfgNode" }

  ScriptBlockChildMapping block;

  ScriptBlock getBlock() { result = block }

  ProcessBlockCfgNode getProcessBlock() { block.hasCfgChild(block.getProcessBlock(), this, result) }

  NamedBlockCfgNode getBeginBlock() { block.hasCfgChild(block.getBeginBlock(), this, result) }

  NamedBlockCfgNode getEndBlock() { block.hasCfgChild(block.getEndBlock(), this, result) }

  NamedBlockCfgNode getDynamicBlock() { block.hasCfgChild(block.getDynamicBlock(), this, result) }

  AttributeCfgNode getAttribute(int i) { block.hasCfgChild(block.getAttribute(i), this, result) }

  AttributeCfgNode getAnAttribute() { result = this.getAttribute(_) }

  ParameterCfgNode getParameter(int i) { block.hasCfgChild(block.getParameter(i), this, result) }

  ParameterCfgNode getAParameter() { result = this.getParameter(_) }
}

private class NamedBlockChildMapping extends NonExprChildMapping, NamedBlock {
  override predicate relevantChild(Ast child) {
    child = this.getAStmt() or child = this.getATrapStmt()
  }
}

class NamedBlockCfgNode extends AstCfgNode {
  NamedBlockCfgNode() { block = this.getAstNode() }

  override string getAPrimaryQlClass() { result = "NamedBlockCfgNode" }

  NamedBlockChildMapping block;

  NamedBlock getBlock() { result = block }

  StmtCfgNode getStmt(int i) { block.hasCfgChild(block.getStmt(i), this, result) }

  StmtCfgNode getAStmt() { result = this.getStmt(_) }

  StmtNodes::TrapStmtCfgNode getTrapStmt(int i) {
    block.hasCfgChild(block.getTrapStmt(i), this, result)
  }

  StmtNodes::TrapStmtCfgNode getATrapStmt() { result = this.getTrapStmt(_) }
}

private class ProcessBlockChildMapping extends NamedBlockChildMapping, ProcessBlock {
  override predicate relevantChild(Ast child) {
    super.relevantChild(child)
    or
    child = super.getPipelineParameterAccess()
    or
    child = super.getAPipelineByPropertyNameParameterAccess()
  }
}

class ProcessBlockCfgNode extends NamedBlockCfgNode {
  override string getAPrimaryQlClass() { result = "ProcessBlockCfgNode" }

  override ProcessBlockChildMapping block;

  override ProcessBlock getBlock() { result = block }

  ScriptBlockCfgNode getScriptBlock() { result.getProcessBlock() = this }

  PipelineParameter getPipelineParameter() {
    result.getScriptBlock() = this.getScriptBlock().getAstNode()
  }

  ExprNodes::VarReadAccessCfgNode getPipelineParameterAccess() {
    block.hasCfgChild(block.getPipelineParameterAccess(), this, result)
  }

  PipelineIteratorVariable getPipelineIteratorVariable() {
    result.getProcessBlock().getScriptBlock() = this.getScriptBlock().getAstNode()
  }

  PipelineByPropertyNameIteratorVariable getPipelineBypropertyNameIteratorVariable(string name) {
    result.getPropertyName() = name and
    result.getProcessBlock().getScriptBlock() = this.getScriptBlock().getAstNode()
  }

  PipelineByPropertyNameIteratorVariable getAPipelineBypropertyNameIteratorVariable() {
    result = this.getPipelineBypropertyNameIteratorVariable(_)
  }

  ExprNodes::VarReadAccessCfgNode getPipelineByPropertyNameParameterAccess(string name) {
    block.hasCfgChild(block.getPipelineByPropertyNameParameterAccess(name), this, result)
  }

  ExprNodes::VarReadAccessCfgNode getAPipelineByPropertyNameParameterAccess() {
    result = this.getPipelineByPropertyNameParameterAccess(_)
  }
}

private class CatchClauseChildMapping extends NonExprChildMapping, CatchClause {
  override predicate relevantChild(Ast child) {
    child = this.getBody() or child = this.getACatchType()
  }
}

class CatchClauseCfgNode extends AstCfgNode {
  override string getAPrimaryQlClass() { result = "CatchClauseCfgNode" }

  CatchClauseChildMapping s;

  CatchClause getCatchClause() { result = s }

  StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }

  TypeConstraint getCatchType(int i) { result = s.getCatchType(i) }

  TypeConstraint getACatchType() { result = this.getCatchType(_) }
}

module ExprNodes {
  private class ArrayExprChildMapping extends ExprChildMapping, ArrayExpr {
    override predicate relevantChild(Ast child) {
      child = this.getAnExpr()
      or
      child = this.getStmtBlock()
    }
  }

  class ArrayExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayExprCfgNode" }

    override ArrayExprChildMapping e;

    override ArrayExpr getExpr() { result = e }

    ExprCfgNode getExpr(int i) { e.hasCfgChild(e.getExpr(i), this, result) }

    ExprCfgNode getAnExpr() { result = this.getExpr(_) }

    StmtCfgNode getStmtBlock() { e.hasCfgChild(e.getStmtBlock(), this, result) }
  }

  private class ArrayLiteralChildMapping extends ExprChildMapping, ArrayLiteral {
    override predicate relevantChild(Ast child) { child = this.getAnExpr() }
  }

  class ArrayLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ArrayLiteralCfgNode" }

    override ArrayLiteralChildMapping e;

    override ArrayLiteral getExpr() { result = e }

    ExprCfgNode getExpr(int i) { e.hasCfgChild(e.getExpr(i), this, result) }

    ExprCfgNode getAnExpr() { result = this.getExpr(_) }
  }

  private class ParenExprChildMapping extends ExprChildMapping, ParenExpr {
    override predicate relevantChild(Ast child) { child = this.getExpr() }
  }

  class ParenExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ParenExprCfgNode" }

    override ParenExprChildMapping e;

    override ParenExpr getExpr() { result = e }

    ExprCfgNode getSubExpr() { e.hasCfgChild(e.getExpr(), this, result) }
  }

  private class BinaryExprChildMapping extends ExprChildMapping, BinaryExpr {
    override predicate relevantChild(Ast child) {
      child = this.getLeft()
      or
      child = this.getRight()
    }
  }

  class BinaryExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BinaryExprCfgNode" }

    override BinaryExprChildMapping e;

    override BinaryExpr getExpr() { result = e }

    ExprCfgNode getLeft() { e.hasCfgChild(e.getLeft(), this, result) }

    ExprCfgNode getRight() { e.hasCfgChild(e.getRight(), this, result) }
  }

  private class UnaryExprChildMapping extends ExprChildMapping, UnaryExpr {
    override predicate relevantChild(Ast child) { child = this.getOperand() }
  }

  class UnaryExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "UnaryExprCfgNode" }

    override UnaryExprChildMapping e;

    override UnaryExpr getExpr() { result = e }

    ExprCfgNode getOperand() { e.hasCfgChild(e.getOperand(), this, result) }
  }

  private class ConstExprChildMapping extends ExprChildMapping, ConstExpr {
    override predicate relevantChild(Ast child) { none() }
  }

  class ConstExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConstExprCfgNode" }

    override ConstExprChildMapping e;

    override ConstExpr getExpr() { result = e }
  }

  private class ConvertExprChildMapping extends ExprChildMapping, ConvertExpr {
    override predicate relevantChild(Ast child) { child = this.getExpr() }
  }

  class ConvertExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConvertExprCfgNode" }

    override ConvertExprChildMapping e;

    override ConvertExpr getExpr() { result = e }

    ExprCfgNode getSubExpr() { e.hasCfgChild(e.getExpr(), this, result) }
  }

  private class IndexExprChildMapping extends ExprChildMapping, IndexExpr {
    override predicate relevantChild(Ast child) {
      child = this.getBase()
      or
      child = this.getIndex()
    }
  }

  class IndexExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "IndexExprCfgNode" }

    override IndexExprChildMapping e;

    override IndexExpr getExpr() { result = e }

    ExprCfgNode getBase() { e.hasCfgChild(e.getBase(), this, result) }

    ExprCfgNode getIndex() { e.hasCfgChild(e.getIndex(), this, result) }
  }

  private class IndexExprWriteAccessChildMapping extends IndexExprChildMapping, IndexExprWriteAccess
  {
    override predicate relevantChild(Ast child) {
      super.relevantChild(child) or
      this.isExplicitWrite(child)
    }
  }

  class IndexExprWriteAccessCfgNode extends IndexExprCfgNode {
    override IndexExprWriteAccessChildMapping e;

    override string getAPrimaryQlClass() { result = "IndexExprWriteAccessCfgNode" }

    override IndexExprWriteAccess getExpr() { result = e }

    final StmtNodes::AssignStmtCfgNode getAssignStmt() { this.isExplicitWrite(result) }

    predicate isExplicitWrite(AstCfgNode assignmentCfg) {
      exists(Ast assignment |
        // this.isExplicitWrite(assignment) and
        e.isExplicitWrite(assignment) and
        e.hasCfgChild(assignment, this, assignmentCfg)
      )
    }

    predicate isImplicitWrite() { e.isImplicitWrite() }
  }

  private class IndexExprReadAccessChildMapping extends IndexExprChildMapping, IndexExprReadAccess {
    override predicate relevantChild(Ast child) { super.relevantChild(child) }
  }

  class IndexExprReadAccessCfgNode extends IndexExprCfgNode {
    override IndexExprReadAccessChildMapping e;

    override string getAPrimaryQlClass() { result = "IndexExprAccessCfgNode" }

    override IndexExprReadAccess getExpr() { result = e }
  }

  private class CallExprChildMapping extends ExprChildMapping, CallExpr {
    override predicate relevantChild(Ast child) {
      child = this.getQualifier()
      or
      child = this.getAnArgument()
      or
      child = this.getCallee()
    }
  }

  class CallExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "CallExprCfgNode" }

    override CallExprChildMapping e;

    override CallExpr getExpr() { result = e }

    ExprCfgNode getQualifier() { e.hasCfgChild(e.getQualifier(), this, result) }

    ExprCfgNode getArgument(int i) { e.hasCfgChild(e.getArgument(i), this, result) }

    ExprCfgNode getAnArgument() { result = this.getArgument(_) }

    /** Gets the name that is used to select the callee. */
    string getLowerCaseName() { result = e.getLowerCaseName() }

    predicate hasLowerCaseName(string name) { this.getLowerCaseName() = name }

    /** Gets the i'th positional argument to this call. */
    ExprCfgNode getPositionalArgument(int i) {
      e.hasCfgChild(e.getPositionalArgument(i), this, result)
    }

    /** Holds if an argument with name `name` is provided to this call. */
    final predicate hasNamedArgument(string name) { exists(this.getNamedArgument(name)) }

    /** Gets the argument to this call with the name `name`. */
    ExprCfgNode getNamedArgument(string name) {
      e.hasCfgChild(e.getNamedArgument(name), this, result)
    }

    ExprCfgNode getCallee() { e.hasCfgChild(e.getCallee(), this, result) }

    ExprCfgNode getPipelineArgument() {
      exists(ExprNodes::PipelineCfgNode pipeline, int i |
        pipeline.getComponent(i + 1) = this and
        result = pipeline.getComponent(i)
      )
    }

    predicate isStatic() { this.getExpr().isStatic() }
  }

  private class ObjectCreationChildMapping extends CallExprChildMapping instanceof ObjectCreation {
    override predicate relevantChild(Ast child) { child = super.getConstructedTypeExpr() }
  }

  class ObjectCreationCfgNode extends CallExprCfgNode {
    // TODO: Also calls to Activator.CreateInstance
    override string getAPrimaryQlClass() { result = "CallExprCfgNode" }

    override ObjectCreationChildMapping e;

    override ObjectCreation getExpr() { result = e }

    string getConstructedTypeName() { result = this.getExpr().getConstructedTypeName() }

    ExprCfgNode getConstructedTypeExpr() {
      e.hasCfgChild(this.getExpr().getConstructedTypeExpr(), this, result)
    }
  }

  private class CallOperatorChildMapping extends CallExprChildMapping instanceof CallOperator {
    override predicate relevantChild(Ast child) { super.relevantChild(child) }
  }

  class CallOperatorCfgNode extends CallExprCfgNode {
    override string getAPrimaryQlClass() { result = "CallOperatorCfgNode" }

    override CallOperatorChildMapping e;

    override CallOperator getExpr() { result = e }

    ExprCfgNode getCommand() { result = this.getArgument(0) }
  }

  private class ToStringCallChildmapping extends CallExprChildMapping instanceof ToStringCall {
    override predicate relevantChild(Ast child) { super.relevantChild(child) }
  }

  class ToStringCallCfgNode extends CallExprCfgNode {
    override string getAPrimaryQlClass() { result = "ToStringCallCfgNode" }

    override ToStringCallChildmapping e;

    override ToStringCall getExpr() { result = e }
  }

  private class MemberExprChildMapping extends ExprChildMapping, MemberExpr {
    override predicate relevantChild(Ast child) {
      child = this.getQualifier()
      or
      child = this.getMemberExpr()
    }
  }

  class MemberExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "MemberExprCfgNode" }

    override MemberExprChildMapping e;

    override MemberExpr getExpr() { result = e }

    ExprCfgNode getQualifier() { e.hasCfgChild(e.getQualifier(), this, result) }

    ExprCfgNode getMemberExpr() { e.hasCfgChild(e.getMemberExpr(), this, result) }

    string getMemberName() { result = e.getMemberName() }

    predicate isStatic() { e.isStatic() }
  }

  private class MemberExprWriteAccessChildMapping extends MemberExprChildMapping,
    MemberExprWriteAccess
  {
    override predicate relevantChild(Ast child) {
      super.relevantChild(child) or
      this.isExplicitWrite(child)
    }
  }

  class MemberExprWriteAccessCfgNode extends MemberExprCfgNode {
    override MemberExprWriteAccessChildMapping e;

    override string getAPrimaryQlClass() { result = "MemberExprWriteAccessCfgNode" }

    override MemberExprWriteAccess getExpr() { result = e }

    final StmtNodes::AssignStmtCfgNode getAssignStmt() { this.isExplicitWrite(result) }

    predicate isExplicitWrite(AstCfgNode assignmentCfg) {
      exists(Ast assignment |
        // this.isExplicitWrite(assignment) and
        e.isExplicitWrite(assignment) and
        e.hasCfgChild(assignment, this, assignmentCfg)
      )
    }

    predicate isImplicitWrite() { e.isImplicitWrite() }
  }

  private class MemberExprReadAccessChildMapping extends MemberExprChildMapping,
    MemberExprReadAccess
  {
    override predicate relevantChild(Ast child) { super.relevantChild(child) }
  }

  class MemberExprReadAccessCfgNode extends MemberExprCfgNode {
    override MemberExprReadAccessChildMapping e;

    override string getAPrimaryQlClass() { result = "MemberExprReadAccessCfgNode" }

    override MemberExprReadAccess getExpr() { result = e }
  }

  private class TypeNameExprChildMapping extends ExprChildMapping, TypeNameExpr {
    override predicate relevantChild(Ast child) { none() }
  }

  class TypeNameExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "TypeExprCfgNode" }

    override TypeNameExprChildMapping e;

    override TypeNameExpr getExpr() { result = e }

    string getName() { result = e.getName() }

    string getNamespace() { result = e.getNamespace() }

    string getPossiblyQualifiedName() { result = e.getPossiblyQualifiedName() }

    predicate isQualified() { e.isQualified() }

    predicate hasQualifiedName(string namespace, string typename) {
      e.hasQualifiedName(namespace, typename)
    }
  }

  private class QualifiedTypeNameExprChildMapping extends TypeNameExprChildMapping,
    QualifiedTypeNameExpr
  {
    override predicate relevantChild(Ast child) { super.relevantChild(child) }
  }

  class QualifiedTypeNameExprCfgNode extends TypeNameExprCfgNode {
    override QualifiedTypeNameExprChildMapping e;

    override TypeNameExpr getExpr() { result = e }

    override string getAPrimaryQlClass() { result = "QualifiedTypeNameExprCfgNode" }
  }

  private class ErrorExprChildMapping extends ExprChildMapping, ErrorExpr {
    override predicate relevantChild(Ast child) { none() }
  }

  class ErrorExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ErrorExprCfgNode" }

    override ErrorExprChildMapping e;

    override ErrorExpr getExpr() { result = e }
  }

  private class ScriptBlockExprChildMapping extends ExprChildMapping, ScriptBlockExpr {
    override predicate relevantChild(Ast child) { child = this.getBody() }
  }

  class ScriptBlockExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ScriptBlockExprCfgNode" }

    override ScriptBlockExprChildMapping e;

    override ScriptBlockExpr getExpr() { result = e }

    ScriptBlockCfgNode getBody() { e.hasCfgChild(e.getBody(), this, result) }
  }

  private class StringLiteralExprChildMapping extends ExprChildMapping, StringConstExpr {
    override predicate relevantChild(Ast child) { none() }
  }

  class StringLiteralExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "StringLiteralExprCfgNode" }

    override StringLiteralExprChildMapping e;

    override StringConstExpr getExpr() { result = e }

    string getValueString() { result = e.getValueString() }
  }

  private class ExpandableStringExprChildMapping extends ExprChildMapping, ExpandableStringExpr {
    override predicate relevantChild(Ast child) { child = this.getAnExpr() }
  }

  class ExpandableStringExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ExpandableStringExprCfgNode" }

    override ExpandableStringExprChildMapping e;

    override ExpandableStringExpr getExpr() { result = e }

    ExprCfgNode getExpr(int i) { e.hasCfgChild(e.getExpr(i), this, result) }

    ExprCfgNode getAnExpr() { result = this.getExpr(_) }
  }

  class VarAccessCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "VarAccessExprCfgNode" }

    override VarAccess e;

    override VarAccess getExpr() { result = e }

    Variable getVariable() { result = e.getVariable() }
  }

  private class VarWriteAccessChildMapping extends ExprChildMapping, VarWriteAccess {
    override predicate relevantChild(Ast child) { this.isExplicitWrite(child) }
  }

  class VarWriteAccessCfgNode extends VarAccessCfgNode {
    override VarWriteAccessChildMapping e;

    override string getAPrimaryQlClass() { result = "VarWriteAccessCfgNode" }

    override VarWriteAccess getExpr() { result = e }

    final StmtNodes::AssignStmtCfgNode getAssignStmt() { this.isExplicitWrite(result) }

    predicate isExplicitWrite(AstCfgNode assignmentCfg) {
      exists(Ast assignment |
        e.isExplicitWrite(assignment) and
        e.hasCfgChild(assignment, this, assignmentCfg)
      )
    }

    predicate isImplicitWrite() { e.isImplicitWrite() }
  }

  class VarReadAccessCfgNode extends VarAccessCfgNode {
    override VarReadAccess e;

    override string getAPrimaryQlClass() { result = "VarReadAccessCfgNode" }

    override VarReadAccess getExpr() { result = e }
  }

  private class HashTableExprChildMapping extends ExprChildMapping, HashTableExpr {
    override predicate relevantChild(Ast child) {
      child = this.getAKey()
      or
      child = this.getAValue()
    }
  }

  class HashTableExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "HashTableExprCfgNode" }

    override HashTableExprChildMapping e;

    override HashTableExpr getExpr() { result = e }

    ExprCfgNode getKey(int i) { e.hasCfgChild(e.getKey(i), this, result) }

    ExprCfgNode getAnKey() { result = this.getKey(_) }

    ExprCfgNode getValue(int i) { e.hasCfgChild(e.getValue(i), this, result) }

    ExprCfgNode getValueFromKey(ExprCfgNode key) {
      exists(int i |
        this.getKey(i) = key and
        result = this.getValue(i)
      )
    }

    ExprCfgNode getAValue() { result = this.getValue(_) }
  }

  private class PipelineChildMapping extends ExprChildMapping, Pipeline {
    override predicate relevantChild(Ast child) { child = this.getAComponent() }
  }

  class PipelineCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "PipelineCfgNode" }

    override PipelineChildMapping e;

    override Pipeline getExpr() { result = e }

    ExprCfgNode getComponent(int i) { e.hasCfgChild(e.getComponent(i), this, result) }

    ExprCfgNode getAComponent() { result = this.getComponent(_) }

    ExprCfgNode getLastComponent() { e.hasCfgChild(e.getLastComponent(), this, result) }
  }

  private class PipelineChainChildMapping extends ExprChildMapping, PipelineChain {
    override predicate relevantChild(Ast child) {
      child = this.getLeft() or child = this.getRight()
    }
  }

  class PipelineChainCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "PipelineChainCfgNode" }

    override PipelineChainChildMapping e;

    override PipelineChain getExpr() { result = e }

    ExprCfgNode getLeft() { e.hasCfgChild(e.getLeft(), this, result) }

    ExprCfgNode getRight() { e.hasCfgChild(e.getRight(), this, result) }
  }

  private class ConditionalExprChildMapping extends ExprChildMapping, ConditionalExpr {
    override predicate relevantChild(Ast child) {
      child = this.getCondition()
      or
      child = this.getIfTrue()
      or
      child = this.getIfFalse()
    }
  }

  class ConditionalExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ConditionalExprCfgNode" }

    override ConditionalExprChildMapping e;

    override ConditionalExpr getExpr() { result = e }

    ExprCfgNode getCondition() { e.hasCfgChild(e.getCondition(), this, result) }

    ExprCfgNode getIfTrue() { e.hasCfgChild(e.getIfTrue(), this, result) }

    ExprCfgNode getIfFalse() { e.hasCfgChild(e.getIfFalse(), this, result) }

    ExprCfgNode getBranch(boolean b) {
      b = true and
      result = this.getIfTrue()
      or
      b = false and
      result = this.getIfFalse()
    }

    ExprCfgNode getABranch() { result = this.getBranch(_) }
  }

  private class ExpandableSubExprChildMapping extends ExprChildMapping, ExpandableSubExpr {
    override predicate relevantChild(Ast child) { child = this.getExpr() }
  }

  class ExpandableSubExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "ExpandableSubExprCfgNode" }

    override ExpandableSubExprChildMapping e;

    override ExpandableSubExpr getExpr() { result = e }

    ExprCfgNode getSubExpr() { e.hasCfgChild(e.getExpr(), this, result) }
  }

  private class UsingExprChildMapping extends ExprChildMapping, UsingExpr {
    override predicate relevantChild(Ast child) { child = this.getExpr() }
  }

  class UsingExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "UsingExprCfgNode" }

    override UsingExprChildMapping e;

    override UsingExpr getExpr() { result = e }

    ExprCfgNode getSubExpr() { e.hasCfgChild(e.getExpr(), this, result) }
  }

  private class AttributedExprChildMapping extends ExprChildMapping, AttributedExpr {
    override predicate relevantChild(Ast child) {
      child = this.getExpr() or
      child = this.getAttribute()
    }
  }

  class AttributedExprCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "TAttributedExprCfgNode" }

    override AttributedExprChildMapping e;

    override AttributedExpr getExpr() { result = e }

    ExprCfgNode getSubExpr() { e.hasCfgChild(e.getExpr(), this, result) }

    ExprCfgNode getAttribute() { e.hasCfgChild(e.getAttribute(), this, result) }
  }

  private class IfChildMapping extends ExprChildMapping, If {
    override predicate relevantChild(Ast child) {
      child = this.getACondition()
      or
      child = this.getAThen()
      or
      child = this.getElse()
    }
  }

  class IfCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "IfCfgNode" }

    override IfChildMapping e;

    override If getExpr() { result = e }

    ExprCfgNode getCondition(int i) { e.hasCfgChild(e.getCondition(i), this, result) }

    ExprCfgNode getACondition() { result = this.getCondition(_) }

    StmtCfgNode getThen(int i) { e.hasCfgChild(e.getThen(i), this, result) }

    StmtCfgNode getAThen() { result = this.getThen(_) }

    StmtCfgNode getElse() { e.hasCfgChild(e.getElse(), this, result) }

    StmtCfgNode getABranch(boolean b) {
      b = true and
      result = this.getAThen()
      or
      b = false and
      result = this.getElse()
    }

    StmtCfgNode getABranch() { result = this.getABranch(_) }
  }

  private class LiteralChildMapping extends ExprChildMapping, Literal {
    override predicate relevantChild(Ast child) { none() }
  }

  class LiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "LiteralCfgNode" }

    override LiteralChildMapping e;

    override Literal getExpr() { result = e }
  }

  private class BoolLiteralChildMapping extends ExprChildMapping, BoolLiteral {
    override predicate relevantChild(Ast child) { none() }
  }

  class BoolLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "BoolLiteralCfgNode" }

    override BoolLiteralChildMapping e;

    override BoolLiteral getExpr() { result = e }
  }

  private class NullLiteralChildMapping extends ExprChildMapping, NullLiteral {
    override predicate relevantChild(Ast child) { none() }
  }

  class NullLiteralCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "NullLiteralCfgNode" }

    override NullLiteralChildMapping e;

    override NullLiteral getExpr() { result = e }
  }

  class ArgumentCfgNode extends ExprCfgNode {
    override Argument e;

    CallExprCfgNode getCall() { result.getAnArgument() = this }

    string getLowerCaseName() { result = e.getLowerCaseName() }

    int getPosition() { result = e.getPosition() }
  }

  class QualifierCfgNode extends ExprCfgNode {
    override Qualifier e;

    CallExprCfgNode getCall() { result.getQualifier() = this }
  }

  class PipelineArgumentCfgNode extends ExprCfgNode {
    override PipelineArgument e;

    CallExprCfgNode getCall() { result.getPipelineArgument() = this }
  }

  private class EnvVariableChildMapping extends ExprChildMapping, EnvVariable {
    override predicate relevantChild(Ast child) { none() }
  }

  class EnvVariableCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "EnvVariableCfgNode" }

    override EnvVariableChildMapping e;

    override EnvVariable getExpr() { result = e }

    string getName() { result = e.getName() }
  }

  private class OperationChildMapping extends ExprChildMapping, Operation {
    override predicate relevantChild(Ast child) { child = this.getAnOperand() }
  }

  class OperationCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "OperationCfgNode" }

    override OperationChildMapping e;

    override Operation getExpr() { result = e }

    ExprCfgNode getAnOperand() { e.hasCfgChild(e.getAnOperand(), this, result) }
  }

  private class AutomaticVariableChildMapping extends ExprChildMapping, AutomaticVariable {
    override predicate relevantChild(Ast child) { none() }
  }

  class AutomaticVariableCfgNode extends ExprCfgNode {
    override string getAPrimaryQlClass() { result = "AutomaticVariableCfgNode" }

    override AutomaticVariableChildMapping e;

    override AutomaticVariable getExpr() { result = e }

    string getName() { result = e.getName() }
  }
}

module StmtNodes {
  private class AssignStmtChildMapping extends NonExprChildMapping, AssignStmt {
    override predicate relevantChild(Ast child) {
      child = this.getLeftHandSide()
      or
      child = this.getRightHandSide()
    }
  }

  class AssignStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "AssignStmtCfgNode" }

    override AssignStmtChildMapping s;

    override AssignStmt getStmt() { result = s }

    ExprCfgNode getLeftHandSide() { s.hasCfgChild(s.getLeftHandSide(), this, result) }

    ExprCfgNode getRightHandSide() { s.hasCfgChild(s.getRightHandSide(), this, result) }
  }

  private class BreakStmtChildMapping extends NonExprChildMapping, BreakStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class BreakStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "BreakStmtCfgNode" }

    override BreakStmtChildMapping s;

    override BreakStmt getStmt() { result = s }
  }

  private class ContinueStmtChildMapping extends NonExprChildMapping, ContinueStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class ContinueStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ContinueStmtCfgNode" }

    override ContinueStmtChildMapping s;

    override ContinueStmt getStmt() { result = s }
  }

  private class DataStmtChildMapping extends NonExprChildMapping, DataStmt {
    override predicate relevantChild(Ast child) {
      child = this.getACmdAllowed() or child = this.getBody()
    }
  }

  class DataStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "DataStmtCfgNode" }

    override DataStmtChildMapping s;

    override DataStmt getStmt() { result = s }

    ExprCfgNode getCmdAllowed(int i) { s.hasCfgChild(s.getCmdAllowed(i), this, result) }

    ExprCfgNode getACmdAllowed() { result = this.getCmdAllowed(_) }

    StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }
  }

  private class LoopStmtChildMapping extends NonExprChildMapping, LoopStmt {
    override predicate relevantChild(Ast child) { child = this.getBody() }
  }

  class LoopStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "LoopStmtCfgNode" }

    override LoopStmtChildMapping s;

    override LoopStmt getStmt() { result = s }

    StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }
  }

  private class DoUntilStmtChildMapping extends LoopStmtChildMapping, DoUntilStmt {
    override predicate relevantChild(Ast child) {
      child = this.getCondition() or super.relevantChild(child)
    }
  }

  class DoUntilStmtCfgNode extends LoopStmtCfgNode {
    override string getAPrimaryQlClass() { result = "DoUntilStmtCfgNode" }

    override DoUntilStmtChildMapping s;

    override DoUntilStmt getStmt() { result = s }

    ExprCfgNode getCondition() { s.hasCfgChild(s.getCondition(), this, result) }
  }

  private class DoWhileStmtChildMapping extends LoopStmtChildMapping, DoWhileStmt {
    override predicate relevantChild(Ast child) {
      child = this.getCondition() or super.relevantChild(child)
    }
  }

  class DoWhileStmtCfgNode extends LoopStmtCfgNode {
    override string getAPrimaryQlClass() { result = "DoWhileStmtCfgNode" }

    override DoWhileStmtChildMapping s;

    override DoWhileStmt getStmt() { result = s }

    ExprCfgNode getCondition() { s.hasCfgChild(s.getCondition(), this, result) }
  }

  private class ErrorStmtChildMapping extends NonExprChildMapping, ErrorStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class ErrorStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ErrorStmtCfgNode" }

    override ErrorStmtChildMapping s;

    override ErrorStmt getStmt() { result = s }
  }

  private class ExitStmtChildMapping extends NonExprChildMapping, ExitStmt {
    override predicate relevantChild(Ast child) { child = this.getPipeline() }
  }

  class ExitStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ExitStmtCfgNode" }

    override ExitStmtChildMapping s;

    override ExitStmt getStmt() { result = s }

    ExprCfgNode getPipeline() { s.hasCfgChild(s.getPipeline(), this, result) }
  }

  private class DynamicStmtChildMapping extends NonExprChildMapping, DynamicStmt {
    override predicate relevantChild(Ast child) {
      child = this.getName() or child = this.getScriptBlock() or child = this.getHashTableExpr()
    }
  }

  class DynamicStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "DynamicStmtCfgNode" }

    override DynamicStmtChildMapping s;

    override DynamicStmt getStmt() { result = s }

    ExprCfgNode getName() { s.hasCfgChild(s.getName(), this, result) }

    ExprCfgNode getScriptBlock() { s.hasCfgChild(s.getScriptBlock(), this, result) }

    ExprCfgNode getHashTableExpr() { s.hasCfgChild(s.getHashTableExpr(), this, result) }
  }

  private class ForEachStmtChildMapping extends LoopStmtChildMapping, ForEachStmt {
    override predicate relevantChild(Ast child) {
      child = this.getVarAccess() or child = this.getIterableExpr() or super.relevantChild(child)
    }
  }

  class ForEachStmtCfgNode extends LoopStmtCfgNode {
    override string getAPrimaryQlClass() { result = "ForEachStmtCfgNode" }

    override ForEachStmtChildMapping s;

    override ForEachStmt getStmt() { result = s }

    ExprCfgNode getVarAccess() { s.hasCfgChild(s.getVarAccess(), this, result) }

    ExprCfgNode getIterableExpr() { s.hasCfgChild(s.getIterableExpr(), this, result) }
  }

  private class ForStmtChildMapping extends LoopStmtChildMapping, ForStmt {
    override predicate relevantChild(Ast child) {
      child = this.getInitializer() or
      child = this.getCondition() or
      child = this.getIterator() or
      super.relevantChild(child)
    }
  }

  class ForStmtCfgNode extends LoopStmtCfgNode {
    override string getAPrimaryQlClass() { result = "ForStmtCfgNode" }

    override ForStmtChildMapping s;

    override ForStmt getStmt() { result = s }

    AstCfgNode getInitializer() { s.hasCfgChild(s.getInitializer(), this, result) }

    ExprCfgNode getCondition() { s.hasCfgChild(s.getCondition(), this, result) }

    AstCfgNode getIterator() { s.hasCfgChild(s.getIterator(), this, result) }
  }

  private class GotoStmtChildMapping extends NonExprChildMapping, GotoStmt {
    override predicate relevantChild(Ast child) { child = this.getLabel() }
  }

  class GotoStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "GotoStmtCfgNode" }

    override GotoStmtChildMapping s;

    override GotoStmt getStmt() { result = s }

    ExprCfgNode getLabel() { s.hasCfgChild(s.getLabel(), this, result) }
  }

  private class ReturnStmtChildMapping extends NonExprChildMapping, ReturnStmt {
    override predicate relevantChild(Ast child) { child = this.getPipeline() }
  }

  class ReturnStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ReturnStmtCfgNode" }

    override ReturnStmtChildMapping s;

    override ReturnStmt getStmt() { result = s }

    ExprCfgNode getPipeline() { s.hasCfgChild(s.getPipeline(), this, result) }
  }

  private class StmtBlockChildMapping extends NonExprChildMapping, StmtBlock {
    override predicate relevantChild(Ast child) { child = this.getAStmt() }
  }

  class StmtBlockCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "StmtBlockCfgNode" }

    override StmtBlockChildMapping s;

    override StmtBlock getStmt() { result = s }

    StmtCfgNode getStmt(int i) { s.hasCfgChild(s.getStmt(i), this, result) }

    StmtCfgNode getAStmt() { result = this.getStmt(_) }
  }

  private class SwitchStmtChildMapping extends NonExprChildMapping, SwitchStmt {
    override predicate relevantChild(Ast child) {
      child = this.getCondition() or
      child = this.getDefault() or
      child = this.getACase() or
      child = this.getAPattern()
    }
  }

  class SwitchStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "SwitchStmtCfgNode" }

    override SwitchStmtChildMapping s;

    override SwitchStmt getStmt() { result = s }

    ExprCfgNode getCondition() { s.hasCfgChild(s.getCondition(), this, result) }

    StmtCfgNode getDefault() { s.hasCfgChild(s.getDefault(), this, result) }

    StmtCfgNode getCase(int i) { s.hasCfgChild(s.getCase(i), this, result) }

    StmtCfgNode getACase() { result = this.getCase(_) }

    ExprCfgNode getPattern(int i) { s.hasCfgChild(s.getPattern(i), this, result) }

    ExprCfgNode getAPattern() { result = this.getPattern(_) }
  }

  private class ThrowStmtChildMapping extends NonExprChildMapping, ThrowStmt {
    override predicate relevantChild(Ast child) { child = this.getPipeline() }
  }

  class ThrowStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ThrowStmtCfgNode" }

    override ThrowStmtChildMapping s;

    override ThrowStmt getStmt() { result = s }

    ExprCfgNode getPipeline() { s.hasCfgChild(s.getPipeline(), this, result) }
  }

  private class TrapStmtChildMapping extends NonExprChildMapping, TrapStmt {
    override predicate relevantChild(Ast child) { child = this.getBody() }
  }

  class TrapStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "TrapStmtCfgNode" }

    override TrapStmtChildMapping s;

    override TrapStmt getStmt() { result = s }

    StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }
  }

  private class TryStmtChildMapping extends NonExprChildMapping, TryStmt {
    override predicate relevantChild(Ast child) {
      child = this.getBody() or
      child = this.getFinally() or
      child = this.getACatchClause()
    }
  }

  class TryStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "TryStmtCfgNode" }

    override TryStmtChildMapping s;

    override TryStmt getStmt() { result = s }

    StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }

    StmtCfgNode getFinally() { s.hasCfgChild(s.getFinally(), this, result) }

    StmtCfgNode getCatchClause(int i) { s.hasCfgChild(s.getCatchClause(i), this, result) }
  }

  private class UsingStmtChildMapping extends NonExprChildMapping, UsingStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class UsingStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "UsingStmtCfgNode" }

    override UsingStmtChildMapping s;

    override UsingStmt getStmt() { result = s }
  }

  private class WhileStmtChildMapping extends LoopStmtChildMapping, WhileStmt {
    override predicate relevantChild(Ast child) {
      child = this.getCondition() or
      super.relevantChild(child)
    }
  }

  class WhileStmtCfgNode extends LoopStmtCfgNode {
    override string getAPrimaryQlClass() { result = "WhileStmtCfgNode" }

    override WhileStmtChildMapping s;

    override WhileStmt getStmt() { result = s }

    ExprCfgNode getCondition() { s.hasCfgChild(s.getCondition(), this, result) }
  }

  private class ConfigurationChildMapping extends NonExprChildMapping, Configuration {
    override predicate relevantChild(Ast child) { child = this.getName() or child = this.getBody() }
  }

  class ConfigurationCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ConfigurationCfgNode" }

    override ConfigurationChildMapping s;

    override Configuration getStmt() { result = s }

    ExprCfgNode getName() { s.hasCfgChild(s.getName(), this, result) }

    StmtCfgNode getBody() { s.hasCfgChild(s.getBody(), this, result) }
  }

  private class TypeStmtChildMapping extends NonExprChildMapping, TypeDefinitionStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class TypeDefinitionStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "TypeStmtCfgNode" }

    override TypeStmtChildMapping s;

    override TypeDefinitionStmt getStmt() { result = s }

    Member getMember(int i) { result = s.getMember(i) }

    Member getAMember() { result = this.getMember(_) }

    TypeConstraint getBaseType(int i) { result = s.getBaseType(i) }

    TypeConstraint getABaseType() { result = this.getBaseType(_) }

    Type getType() { result = s.getType() }

    string getName() { result = s.getName() }
  }

  private class FunctionDefinitionChildMapping extends NonExprChildMapping, FunctionDefinitionStmt {
    override predicate relevantChild(Ast child) { none() }
  }

  class FunctionDefinitionCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "FunctionDefinitionCfgNode" }

    override FunctionDefinitionChildMapping s;

    override FunctionDefinitionStmt getStmt() { result = s }

    FunctionBase getFunction() { result = s.getFunction() }
  }

  private class ExprStmtChildMapping extends NonExprChildMapping, ExprStmt {
    override predicate relevantChild(Ast child) { child = this.getExpr() }
  }

  class ExprStmtCfgNode extends StmtCfgNode {
    override string getAPrimaryQlClass() { result = "ExprStmtCfgNode" }

    override ExprStmtChildMapping s;

    override ExprStmt getStmt() { result = s }

    ExprCfgNode getExpr() { s.hasCfgChild(s.getExpr(), this, result) }
  }
}
