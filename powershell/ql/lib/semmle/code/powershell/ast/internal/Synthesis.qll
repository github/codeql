private import TAst
private import Ast
private import Location
private import Variable
private import TypeConstraint
private import Expr
private import Parameter
private import ExprStmt
private import NamedBlock
private import FunctionBase
private import ScriptBlock
private import Command
private import Internal::Private
private import Type
private import Scopes
private import BoolLiteral
private import Member
private import EnvVariable
private import Raw.Raw as Raw
private import codeql.util.Boolean
private import AutomaticVariable

newtype VarKind =
  ThisVarKind() or
  ParamVarRealKind() or
  PipelineIteratorKind() or
  PipelineByPropertyNameIteratorKind(string name) {
    exists(Raw::ProcessBlock pb |
      name = pb.getScriptBlock().getParamBlock().getAPipelineByPropertyNameParameter().getName()
    )
  }

newtype SynthKind =
  ExprStmtKind() or
  VarAccessRealKind(VariableReal v) or
  VarAccessSynthKind(VariableSynth v) or
  FunctionSynthKind() or
  TypeSynthKind() or
  BoolLiteralKind(Boolean b) or
  NullLiteralKind() or
  EnvVariableKind(string var) { Raw::isEnvVariableAccess(_, var) } or
  AutomaticVariableKind(string var) { Raw::isAutomaticVariableAccess(_, var) } or
  VarSynthKind(VarKind k)

newtype Child =
  SynthChild(SynthKind kind) or
  RealChildRef(TAstReal n) or
  SynthChildRef(TAstSynth n)

pragma[inline]
private Child childRef(TAst n) {
  result = RealChildRef(n)
  or
  result = SynthChildRef(n)
}

private newtype TSynthesis = MkSynthesis()

class Synthesis extends TSynthesis {
  predicate child(Raw::Ast parent, ChildIndex i, Child child) { none() }

  Location getLocation(Ast n) { none() }

  predicate isRelevant(Raw::Ast a) { none() }

  string toString(Ast n) { none() }

  Ast getResultAstImpl(Raw::Ast r) { none() }

  predicate explicitAssignment(Raw::Ast dest, string name, Raw::Ast assignment) { none() }

  predicate implicitAssignment(Raw::Ast dest, string name) { none() }

  predicate variableSynthName(VariableSynth v, string name) { none() }

  predicate exprStmtExpr(ExprStmt e, Expr expr) { none() }

  predicate parameterStaticType(Parameter p, string type) { none() }

  predicate pipelineParameterHasIndex(Raw::ScriptBlock s, int i) { none() }

  predicate functionName(FunctionBase f, string name) { none() }

  predicate getAnAccess(VarAccessSynth va, Variable v) { none() }

  predicate memberName(Member m, string name) { none() }

  predicate typeName(Type t, string name) { none() }

  predicate typeMember(Type t, int i, Member m) { none() }

  predicate functionScriptBlock(FunctionBase f, ScriptBlock block) { none() }

  predicate isNamedArgument(CmdCall call, int i, string name) { none() }

  predicate booleanValue(BoolLiteral b, boolean value) { none() }

  predicate envVariableName(EnvVariable var, string name) { none() }

  predicate automaticVariableName(AutomaticVariable var, string name) { none() }

  final string toString() { none() }
}

/** Gets the user-facing AST element that is generated from `r`. */
Ast getResultAst(Raw::Ast r) {
  not any(Synthesis s).isRelevant(r) and
  toRaw(result) = r
  or
  any(Synthesis s).isRelevant(r) and
  result = any(Synthesis s).getResultAstImpl(r)
}

Raw::Ast getRawAst(Ast r) { r = getResultAst(result) }

private module ThisSynthesis {
  private class ThisSynthesis extends Synthesis {
    private predicate thisAccess(Raw::Ast parent, ChildIndex i, Child child, Raw::Scope scope) {
      scope = parent.getScope() and
      parent.getChild(toRawChildIndex(i)).(Raw::VarAccess).getUserPath().toLowerCase() = "this" and
      child = SynthChild(VarAccessSynthKind(TVariableSynth(scope, ThisVar())))
    }

    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      parent instanceof Raw::MethodScriptBlock and
      i = ThisVar() and
      child = SynthChild(VarSynthKind(ThisVarKind()))
      or
      this.thisAccess(parent, i, child, _)
    }

    final override predicate getAnAccess(VarAccessSynth va, Variable v) {
      exists(Raw::Ast parent, Raw::Scope scope, ChildIndex i |
        this.thisAccess(parent, i, _, scope) and
        v = TVariableSynth(scope, ThisVar()) and
        va = TVarAccessSynth(parent, i)
      )
    }

    override predicate variableSynthName(VariableSynth v, string name) {
      v = TVariableSynth(_, ThisVar()) and
      name = "this"
    }

    override Location getLocation(Ast n) {
      exists(Raw::Ast scope |
        n = TVariableSynth(scope, ThisVar()) and
        result = scope.getLocation()
      )
    }
  }
}

private module SetVariableAssignment {
  private class SetVariableAssignment extends Synthesis {
    override predicate explicitAssignment(Raw::Ast dest, string name, Raw::Ast assignment) {
      exists(Raw::Cmd cmd |
        assignment = cmd and
        cmd.getCommandName().toLowerCase() = "set-variable" and
        cmd.getNamedArgument("name") = dest and
        name = dest.(Raw::StringConstExpr).getValue().getValue()
      )
    }
  }
}

/** Gets the pipeline parameter associated with `s`. */
TVariable getPipelineParameter(Raw::ScriptBlock s) {
  exists(ChildIndex i |
    any(ParameterSynth::ParameterSynth ps).isPipelineParameterChild(s, _, i, _, _) and
    result = TVariableSynth(s, i)
  )
}

/**
 * Syntesize parameters from parameter blocks and function definitions
 * so that they have a uniform API.
 */
private module ParameterSynth {
  class ParameterSynth extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) { a = any(Scope::Range r).getAParameter() }

    private predicate parameter(Raw::Ast parent, ChildIndex i, Raw::Parameter p, Child child) {
      exists(Scope::Range r, int index |
        p = r.getParameter(index) and
        parent = r and
        i = funParam(index) and
        child = SynthChild(VarSynthKind(ParamVarRealKind()))
      )
    }

    override predicate implicitAssignment(Raw::Ast dest, string name) {
      exists(Raw::Parameter p |
        dest = p and
        name = p.getName()
      )
    }

    final override predicate variableSynthName(VariableSynth v, string name) {
      exists(Raw::Ast parent, ChildIndex i | v = TVariableSynth(parent, i) |
        exists(Raw::Parameter p |
          this.parameter(parent, i, p, _) and
          name = p.getName()
        )
        or
        this.isPipelineParameterChild(parent, _, i, _, true) and
        name = "[synth] pipeline"
      )
    }

    predicate isPipelineParameterChild(
      Raw::Ast parent, int index, ChildIndex i, Child child, boolean synthesized
    ) {
      exists(Scope::Range r |
        parent = r and
        i = funParam(index) and
        child = SynthChild(VarSynthKind(ParamVarRealKind()))
      |
        r.getParameter(index) instanceof Raw::PipelineParameter and
        synthesized = false
        or
        not r.getAParameter() instanceof Raw::PipelineParameter and
        index = synthPipelineParameterChildIndex(r) and
        synthesized = true
      )
    }

    final override predicate pipelineParameterHasIndex(Raw::ScriptBlock s, int i) {
      this.isPipelineParameterChild(s, i, _, _, _)
    }

    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      // Synthesize parameters
      this.parameter(parent, i, _, child)
      or
      // Synthesize implicit pipeline parameter, if necessary
      this.isPipelineParameterChild(parent, _, i, child, true)
      or
      // Synthesize default values
      exists(Raw::Parameter q |
        parent = q and
        this.parameter(_, _, q, _)
      |
        i = paramDefaultVal() and
        child = childRef(getResultAst(q.getDefaultValue()))
        or
        exists(int index |
          i = paramAttr(index) and
          child = childRef(getResultAst(q.getAttribute(index)))
        )
      )
    }

    final override Parameter getResultAstImpl(Raw::Ast r) {
      exists(Raw::Ast parent, ChildIndex i |
        this.parameter(parent, i, r, _) and
        result = TVariableSynth(parent, i)
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, ChildIndex i | n = TVariableSynth(parent, i) |
        exists(Raw::Parameter p |
          this.parameter(parent, i, p, _) and
          result = p.getLocation()
        )
        or
        this.isPipelineParameterChild(parent, _, i, _, true) and
        result = parent.getLocation()
      )
    }

    final override predicate parameterStaticType(Parameter n, string type) {
      exists(Raw::Ast parent, Raw::Parameter p, ChildIndex i |
        // No need to consider the synthesized pipeline parameter as it never
        // has a static type.
        this.parameter(parent, i, p, _) and
        n = TVariableSynth(parent, i) and
        type = p.getStaticType()
      )
    }
  }
}

/**
 * Holds if `child` is a child of `n` that is a `Stmt` in the raw AST, but should
 * be mapped to an `Expr` in the synthesized AST.
 */
private predicate mustHaveExprChild(Raw::Ast n, Raw::Stmt child) {
  n.(Raw::AssignStmt).getRightHandSide() = child
  or
  n.(Raw::Pipeline).getAComponent() = child
  or
  n.(Raw::ReturnStmt).getPipeline() = child
  or
  n.(Raw::HashTableExpr).getAStmt() = child
  or
  n.(Raw::ParenExpr).getBase() = child
  or
  n.(Raw::DoUntilStmt).getCondition() = child
  or
  n.(Raw::DoWhileStmt).getCondition() = child
  or
  n.(Raw::ExitStmt).getPipeline() = child
  or
  n.(Raw::ForEachStmt).getIterableExpr() = child
  or
  // TODO: What to do about initializer and iterator?
  exists(Raw::ForStmt for | n = for | for.getCondition() = child)
  or
  n.(Raw::IfStmt).getACondition() = child
  or
  n.(Raw::SwitchStmt).getCondition() = child
  or
  n.(Raw::ThrowStmt).getPipeline() = child
  or
  n.(Raw::WhileStmt).getCondition() = child
}

private class RawStmtThatShouldBeExpr extends Raw::Stmt {
  RawStmtThatShouldBeExpr() {
    this instanceof Raw::Cmd or
    this instanceof Raw::Pipeline or
    this instanceof Raw::PipelineChain or
    this instanceof Raw::IfStmt
  }

  Expr getExpr() {
    result = TCmd(this)
    or
    result = TPipeline(this)
    or
    result = TPipelineChain(this)
    or
    result = TIf(this)
  }
}

/**
 * Insert expr-to-stmt conversions where needed.
 */
private module ExprToStmtSynth {
  private class ExprToStmtSynth extends Synthesis {
    private predicate exprToSynthStmtChild(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt, Expr e) {
      this.child(parent, i, SynthChild(ExprStmtKind()), stmt) and
      e = stmt.(RawStmtThatShouldBeExpr).getExpr()
    }

    private predicate child(Raw::Ast parent, ChildIndex i, Child child, Raw::Stmt stmt) {
      // Synthesize the expr-to-stmt conversion
      child = SynthChild(ExprStmtKind()) and
      stmt instanceof RawStmtThatShouldBeExpr and
      parent.getChild(toRawChildIndex(i)) = stmt and
      not mustHaveExprChild(parent, stmt)
    }

    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      this.child(parent, i, child, _)
    }

    final override predicate exprStmtExpr(ExprStmt e, Expr expr) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        e = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, expr)
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        n = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, _) and
        result = stmt.getLocation()
      )
    }

    final override string toString(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        n = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, _) and
        result = stmt.toString()
      )
    }
  }
}

predicate excludeFunctionDefinitionStmt(Raw::FunctionDefinitionStmt f) {
  // We don't care about function definition statements which define methods
  // because they live inside a type anyway (and we don't have control-flow
  // inside a type).
  parent(f, any(Raw::Method m))
}

/**
 * Synthesize function "declarations" from function definitions statements.
 */
private module FunctionSynth {
  private class FunctionSynth extends Synthesis {
    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      i = funDefFun() and
      child = SynthChild(FunctionSynthKind()) and
      exists(Raw::FunctionDefinitionStmt fundefStmt |
        if excludeFunctionDefinitionStmt(fundefStmt)
        then parent(fundefStmt, parent)
        else parent = fundefStmt
      )
    }

    override predicate functionName(FunctionBase f, string name) {
      exists(Raw::FunctionDefinitionStmt fundefStmt |
        f = TFunctionSynth(fundefStmt, _) and
        fundefStmt.getName() = name
      )
      or
      exists(Raw::TopLevelScriptBlock topLevelScriptBlock |
        f = TTopLevelFunction(topLevelScriptBlock) and
        name = "toplevel function for " + topLevelScriptBlock.getLocation().getFile().getBaseName()
      )
    }

    override predicate functionScriptBlock(FunctionBase f, ScriptBlock block) {
      exists(Raw::FunctionDefinitionStmt fundefStmt |
        f = TFunctionSynth(fundefStmt, _) and
        getResultAst(fundefStmt.getBody()) = block
      )
      or
      exists(Raw::TopLevelScriptBlock topLevelScriptBlock |
        block = getResultAst(topLevelScriptBlock) and
        f = TTopLevelFunction(topLevelScriptBlock)
      )
    }

    override Location getLocation(Ast n) {
      exists(Raw::FunctionDefinitionStmt fundefStmt |
        n = TFunctionSynth(fundefStmt, _) and
        result = fundefStmt.getLocation()
      )
      or
      exists(Raw::TopLevelScriptBlock topLevelScriptBlock |
        n = TTopLevelFunction(topLevelScriptBlock) and
        result = topLevelScriptBlock.getLocation()
      )
    }
  }
}

private module TypeSynth {
  private class TypeSynth extends Synthesis {
    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      parent instanceof Raw::TypeStmt and
      i = typeDefType() and
      child = SynthChild(TypeSynthKind())
    }

    final override predicate typeMember(Type t, int i, Member m) {
      exists(Raw::TypeStmt typeStmt |
        t = TTypeSynth(typeStmt, _) and
        m = getResultAst(typeStmt.getMember(i))
      )
    }

    override predicate typeName(Type t, string name) {
      exists(Raw::TypeStmt typeStmt |
        t = TTypeSynth(typeStmt, _) and
        typeStmt.getName() = name
      )
    }

    override Location getLocation(Ast n) {
      exists(Raw::TypeStmt typeStmt |
        n = TTypeSynth(typeStmt, _) and
        result = typeStmt.getLocation()
      )
    }
  }
}

/**
 * Remove the implicit expr-to-pipeline conversion.
 */
private module CmdExprRemoval {
  private class CmdExprRemoval extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) { a instanceof Raw::CmdExpr }

    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      // Remove the CmdExpr. There are two cases:
      // - If the expression under the cmd expr exists in a place an expr is expected, then we're done
      // - Otherwise, we need to synthesize an expr-to-stmt conversion with the expression as a child
      exists(Raw::CmdExpr e, boolean exprCtx | this.parentHasCmdExpr(parent, i, e, exprCtx) |
        if exprCtx = true
        then child = childRef(getResultAst(e.getExpr()))
        else child = SynthChild(ExprStmtKind())
      )
      or
      // Synthesize the redirections from the redirections on the CmdExpr
      exists(int index, Raw::CmdExpr e |
        parent = e.getExpr() and
        i = exprRedirection(index) and
        child = childRef(getResultAst(e.getRedirection(index)))
      )
    }

    final override predicate exprStmtExpr(ExprStmt e, Expr expr) {
      exists(Raw::Ast parent, ChildIndex i, Raw::CmdExpr cmd, Raw::Expr e0 |
        e = TExprStmtSynth(parent, i) and
        this.parentHasCmdExpr(parent, i, cmd, _) and
        e0 = cmd.getExpr() and
        expr = getResultAst(e0)
      )
    }

    final override Ast getResultAstImpl(Raw::Ast r) {
      exists(
        Raw::CmdExpr cmdExpr, Raw::Expr e, Raw::ChildIndex rawIndex, Raw::Ast cmdParent,
        ChildIndex i
      |
        r = cmdExpr and
        cmdExpr.getExpr() = e and
        cmdParent.getChild(rawIndex) = cmdExpr and
        not mustHaveExprChild(cmdParent, cmdExpr) and
        rawIndex = toRawChildIndex(i) and
        result = TExprStmtSynth(cmdParent, i)
      )
    }

    pragma[nomagic]
    private predicate parentHasCmdExpr(
      Raw::Ast parent, ChildIndex i, Raw::CmdExpr cmdExpr, boolean exprCtx
    ) {
      exists(Raw::ChildIndex rawIndex |
        rawIndex = toRawChildIndex(i) and
        parent.getChild(rawIndex) = cmdExpr and
        if mustHaveExprChild(parent, cmdExpr) then exprCtx = true else exprCtx = false
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::CmdExpr cmdStmt |
        n = TExprStmtSynth(parent, i) and
        this.parentHasCmdExpr(parent, i, cmdStmt, false) and
        result = cmdStmt.getLocation()
      )
    }
  }
}

/**
 * Clean up arguments to commands by:
 * - Removing the parameter name as an argument.
 */
private module CmdArguments {
  private class CmdParameterRemoval extends Synthesis {
    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      exists(Raw::Expr e |
        this.rawChild(parent, i, e) and
        child = childRef(getResultAst(e))
      )
    }

    private predicate rawChild(Raw::Cmd cmd, ChildIndex i, Raw::Expr child) {
      exists(int index |
        i = cmdArgument(index) and
        child = cmd.getArgument(index)
      )
    }

    override predicate isNamedArgument(CmdCall call, int i, string name) {
      exists(Raw::Cmd cmd, Raw::Expr e, Raw::CmdParameter p |
        this.rawChild(cmd, cmdArgument(i), e) and
        call = getResultAst(cmd) and
        p.getName().toLowerCase() = name
      |
        p.getExpr() = e
        or
        exists(ChildIndex j, int jndex |
          j = cmdElement_(jndex) and
          not exists(p.getExpr()) and
          cmd.getChild(toRawChildIndex(j)) = p and
          cmd.getChild(toRawChildIndex(cmdElement_(jndex + 1))) = e
        )
      )
    }
  }
}

/**
 * Synthesize literals from known constant strings.
 */
private module LiteralSynth {
  pragma[nomagic]
  private predicate assignmentHasLocation(
    Raw::Scope scope, string name, File file, int startLine, int startColumn
  ) {
    Raw::isAutomaticVariableAccess(_, name) and
    exists(Raw::Ast n, Location loc |
      scopeAssigns(scope, name, n) and
      loc = n.getLocation() and
      file = loc.getFile() and
      startLine = loc.getStartLine() and
      startColumn = loc.getStartColumn()
    )
  }

  pragma[nomagic]
  private predicate varAccessHasLocation(
    Raw::VarAccess va, File file, int startLine, int startColumn
  ) {
    exists(Location loc |
      loc = va.getLocation() and
      loc.getFile() = file and
      loc.getStartLine() = startLine and
      loc.getStartColumn() = startColumn
    )
  }

  /**
   * Holds if `va` is an access to the automatic variable named `name`.
   *
   * Unlike `Raw::isAutomaticVariableAccess`, this predicate also checks for
   * shadowing.
   */
  private predicate isAutomaticVariableAccess(Raw::VarAccess va, string name) {
    Raw::isAutomaticVariableAccess(va, name) and
    exists(Raw::Scope scope, File file, int startLine, int startColumn |
      scope = Raw::scopeOf(va) and
      varAccessHasLocation(va, file, startLine, startColumn)
    |
      // If it's a read then make sure there is no assignment precedeeding it
      va.isReadAccess() and
      not exists(int assignStartLine, int assignStartCoumn |
        assignmentHasLocation(scope, name, file, assignStartLine, assignStartCoumn)
      |
        assignStartLine < startLine
        or
        assignStartLine = startLine and
        assignStartCoumn < startColumn
      )
    )
  }

  private class LiteralSynth extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) {
      exists(Raw::VarAccess va | a = va |
        va.getUserPath().toLowerCase() = "true"
        or
        va.getUserPath().toLowerCase() = "false"
        or
        va.getUserPath().toLowerCase() = "null"
        or
        Raw::isEnvVariableAccess(va, _)
        or
        isAutomaticVariableAccess(va, _)
      )
    }

    final override Expr getResultAstImpl(Raw::Ast r) {
      exists(Raw::Ast parent, ChildIndex i | this.child(parent, i, _, r) |
        result = TBoolLiteral(parent, i) or
        result = TNullLiteral(parent, i) or
        result = TEnvVariable(parent, i) or
        result = TAutomaticVariable(parent, i)
      )
    }

    private predicate child(Raw::Ast parent, ChildIndex i, Child child, Raw::VarAccess va) {
      exists(string s |
        parent.getChild(toRawChildIndex(i)) = va and
        va.getUserPath().toLowerCase() = s
      |
        s = "true" and
        child = SynthChild(BoolLiteralKind(true))
        or
        s = "false" and
        child = SynthChild(BoolLiteralKind(false))
        or
        s = "null" and
        child = SynthChild(NullLiteralKind())
        or
        exists(string s0 |
          s = "env:" + s0 and
          Raw::isEnvVariableAccess(va, s0) and
          child = SynthChild(EnvVariableKind(s0))
        )
        or
        isAutomaticVariableAccess(va, s) and
        child = SynthChild(AutomaticVariableKind(s))
      )
    }

    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      this.child(parent, i, child, _)
    }

    final override predicate booleanValue(BoolLiteral b, boolean value) {
      exists(Raw::Ast parent, ChildIndex i |
        b = TBoolLiteral(parent, i) and
        this.child(parent, i, SynthChild(BoolLiteralKind(value)))
      )
    }

    final override predicate envVariableName(EnvVariable var, string name) {
      exists(Raw::Ast parent, ChildIndex i |
        var = TEnvVariable(parent, i) and
        this.child(parent, i, SynthChild(EnvVariableKind(name)))
      )
    }

    final override predicate automaticVariableName(AutomaticVariable var, string name) {
      exists(Raw::Ast parent, ChildIndex i |
        var = TAutomaticVariable(parent, i) and
        this.child(parent, i, SynthChild(AutomaticVariableKind(name)))
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::VarAccess va |
        this.child(_, _, _, va) and
        n = getResultAst(va) and
        result = va.getLocation()
      )
    }
  }
}

/**
 * Synthesize variable accesses for pipeline iterators inside a process block.
 */
private module IteratorAccessSynth {
  private class PipelineOrPipelineByPropertyNameIteratorVariable extends VariableSynth {
    PipelineOrPipelineByPropertyNameIteratorVariable() {
      this instanceof PipelineIteratorVariable
      or
      this instanceof PipelineByPropertyNameIteratorVariable
    }

    string getPropertyName() {
      result = this.(PipelineByPropertyNameIteratorVariable).getPropertyName()
    }

    predicate isPipelineIterator() { this instanceof PipelineIteratorVariable }
  }

  bindingset[pb, v]
  private string getAPipelineIteratorName(
    Raw::ProcessBlock pb, PipelineOrPipelineByPropertyNameIteratorVariable v
  ) {
    v.isPipelineIterator() and
    (
      result = "_"
      or
      // or
      // result = "psitem" // TODO: This is also an automatic variable
      result = pb.getScriptBlock().getParamBlock().getPipelineParameter().getName().toLowerCase()
    )
    or
    // TODO: We could join on something other than the string if we wanted (i.e., the raw parameter).
    v.getPropertyName().toLowerCase() = result and
    result =
      pb.getScriptBlock()
          .getParamBlock()
          .getAPipelineByPropertyNameParameter()
          .getName()
          .toLowerCase()
  }

  private class IteratorAccessSynth extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) {
      exists(Raw::ProcessBlock pb, Raw::VarAccess va |
        va = a and
        pb = va.getParent+()
      |
        va.getUserPath() = "_"
        or
        va.getUserPath().toLowerCase() =
          pb.getScriptBlock().getParamBlock().getPipelineParameter().getName().toLowerCase()
        or
        va.getUserPath().toLowerCase() =
          pb.getScriptBlock()
              .getParamBlock()
              .getAPipelineByPropertyNameParameter()
              .getName()
              .toLowerCase()
      )
    }

    private predicate expr(Raw::Ast rawParent, ChildIndex i, Raw::VarAccess va, Child child) {
      rawParent.getChild(toRawChildIndex(i)) = va and
      child = SynthChild(VarAccessSynthKind(this.varAccess(va)))
    }

    private predicate stmt(Raw::Ast rawParent, ChildIndex i, Raw::CmdExpr cmdExpr, Child child) {
      exists(this.varAccess(cmdExpr.getExpr())) and
      rawParent.getChild(toRawChildIndex(i)) = cmdExpr and
      not mustHaveExprChild(rawParent, cmdExpr) and
      child = SynthChild(ExprStmtKind())
    }

    private PipelineOrPipelineByPropertyNameIteratorVariable varAccess(Raw::VarAccess va) {
      exists(Raw::ProcessBlock pb |
        pb = va.getParent+() and
        result = TVariableSynth(pb, _) and
        va.getUserPath().toLowerCase() = getAPipelineIteratorName(pb, result)
      )
    }

    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      this.expr(parent, i, _, child)
      or
      this.stmt(parent, i, _, child)
      or
      exists(Raw::ProcessBlock pb | parent = pb |
        i = PipelineIteratorVar() and
        child = SynthChild(VarSynthKind(PipelineIteratorKind()))
        or
        exists(Raw::Parameter p |
          p = pb.getScriptBlock().getParamBlock().getAPipelineByPropertyNameParameter() and
          child = SynthChild(VarSynthKind(PipelineByPropertyNameIteratorKind(p.getName()))) and
          i = PipelineByPropertyNameIteratorVar(p)
        )
      )
    }

    final override predicate getAnAccess(VarAccessSynth va, Variable v) {
      exists(Raw::Ast parent, ChildIndex i, Raw::VarAccess r |
        this.expr(parent, i, r, _) and
        va = TVarAccessSynth(parent, i) and
        v = this.varAccess(r)
      )
    }

    override predicate exprStmtExpr(ExprStmt e, Expr expr) {
      exists(Raw::Ast p, Raw::VarAccess va, Raw::CmdExpr cmdExpr, ChildIndex i1, ChildIndex i2 |
        this.stmt(p, i1, _, _) and
        this.expr(cmdExpr, i2, va, _) and
        e = TExprStmtSynth(p, i1) and
        expr = TVarAccessSynth(cmdExpr, i2)
      )
    }

    final override Expr getResultAstImpl(Raw::Ast r) {
      exists(Raw::Ast parent, ChildIndex i | this.expr(parent, i, r, _) |
        result = TVarAccessSynth(parent, i)
      )
    }

    override predicate variableSynthName(VariableSynth v, string name) {
      v = TVariableSynth(_, PipelineIteratorVar()) and
      name = "__pipeline_iterator"
      or
      exists(Raw::PipelineByPropertyNameParameter p |
        v = TVariableSynth(_, PipelineByPropertyNameIteratorVar(p)) and
        name = "__pipeline_iterator for " + p.getName()
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::CmdExpr cmdExpr |
        this.stmt(parent, i, cmdExpr, _) and
        n = TExprStmtSynth(parent, i) and
        result = cmdExpr.getLocation()
      )
      or
      exists(Raw::Ast parent, ChildIndex i |
        i instanceof PipelineIteratorVar or i instanceof PipelineByPropertyNameIteratorVar
      |
        n = TVariableSynth(parent, i) and
        result = parent.getLocation()
      )
    }
  }
}

private module PipelineAccess {
  private class PipelineAccess extends Synthesis {
    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      exists(Raw::ProcessBlock pb | parent = pb |
        i = processBlockPipelineVarReadAccess() and
        exists(PipelineParameter pipelineVar |
          pipelineVar = getPipelineParameter(pb.getScriptBlock()) and
          child = SynthChild(VarAccessSynthKind(pipelineVar))
        )
        or
        exists(PipelineByPropertyNameParameter pipelineVar, Raw::PipelineByPropertyNameParameter p |
          i = processBlockPipelineByPropertyNameVarReadAccess(p.getName()) and
          getResultAst(p) = pipelineVar and
          child = SynthChild(VarAccessSynthKind(pipelineVar))
        )
      )
    }

    final override Location getLocation(Ast n) {
      exists(ProcessBlock pb |
        pb.getPipelineParameterAccess() = n or pb.getAPipelineByPropertyNameParameterAccess() = n
      |
        result = pb.getLocation()
      )
    }

    final override predicate getAnAccess(VarAccessSynth va, Variable v) {
      exists(ProcessBlock pb |
        pb.getPipelineParameterAccess() = va and
        v = pb.getPipelineParameter()
        or
        exists(string name |
          pb.getPipelineByPropertyNameParameterAccess(name) = va and
          v = pb.getPipelineByPropertyNameParameter(name)
        )
      )
    }
  }
}

private module ImplicitAssignmentInForEach {
  private class ForEachAssignment extends Synthesis {
    override predicate implicitAssignment(Raw::Ast dest, string name) {
      exists(Raw::ForEachStmt forEach, Raw::VarAccess va |
        va = forEach.getVarAccess() and
        va = dest and
        va.getUserPath() = name
      )
    }
  }
}
