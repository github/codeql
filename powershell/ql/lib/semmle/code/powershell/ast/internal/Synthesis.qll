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
  ParamVarPipelineKind() or
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

  predicate isPipelineParameter(Parameter p) { none() }

  predicate pipelineParameterHasIndex(ScriptBlock s, int i) { none() }

  predicate functionName(FunctionBase f, string name) { none() }

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
    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      parent instanceof Raw::MethodScriptBlock and
      i = ThisVar() and
      child = SynthChild(VarSynthKind(ThisVarKind()))
      or
      parent.getChild(toRawChildIndex(i)).(Raw::VarAccess).getUserPath().toLowerCase() = "this" and
      child = SynthChild(VarAccessSynthKind(TVariableSynth(parent.getScope(), ThisVar())))
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

/**
 * Syntesize parameters from parameter blocks and function definitions
 * so that they have a uniform API.
 */
private module ParameterSynth {
  private class ParameterSynth extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) { a = any(Scope::Range r).getAParameter() }

    private predicate parameter(
      Raw::Ast parent, ChildIndex i, Raw::Parameter p, Child child, boolean isPipelineParameter
    ) {
      exists(Scope::Range r, int index |
        p = r.getParameter(index) and
        parent = r and
        i = funParam(index) and
        child = SynthChild(VarSynthKind(ParamVarRealKind())) and
        if p instanceof Raw::PipelineParameter
        then isPipelineParameter = true
        else isPipelineParameter = false
      )
    }

    final override predicate isPipelineParameter(Parameter p) {
      exists(Raw::Ast parent, ChildIndex i |
        parent = getRawAst(p.getFunction().getBody()) and
        this.isPipelineParameterChild(parent, _, i) and
        p = TVariableSynth(parent, i)
      )
    }

    override predicate implicitAssignment(Raw::Ast dest, string name) {
      exists(Raw::Parameter p |
        dest = p and
        name = p.getName()
      )
    }

    final override predicate variableSynthName(VariableSynth v, string name) {
      exists(Raw::Ast parent, int i, Raw::Parameter p |
        this.parameter(parent, FunParam(i), p, _, false) and
        v = TVariableSynth(parent, FunParam(i)) and
        name = p.getName()
      )
      or
      exists(Raw::Ast parent |
        this.child(parent, PipelineParamVar(), _) and
        v = TVariableSynth(parent, PipelineParamVar()) and
        name = "[synth] pipeline"
      )
    }

    private predicate isPipelineParameterChild(Raw::Ast parent, int index, ChildIndex i) {
      exists(Scope::Range r | parent = r and i = PipelineParamVar() |
        r.getParameter(index) instanceof Raw::PipelineParameter
        or
        not r.getAParameter() instanceof Raw::PipelineParameter and
        index = synthPipelineParameterChildIndex(r)
      )
    }

    final override predicate pipelineParameterHasIndex(ScriptBlock s, int i) {
      exists(Raw::ScriptBlock scriptBlock |
        s = TScriptBlock(scriptBlock) and
        this.isPipelineParameterChild(scriptBlock, i, _)
      )
    }

    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      // Synthesize parameters
      this.parameter(parent, i, _, child, false)
      or
      // Synthesize pipeline parameter
      child = SynthChild(VarSynthKind(ParamVarPipelineKind())) and
      this.isPipelineParameterChild(parent, _, i)
      or
      // Synthesize default values
      exists(Raw::Parameter q |
        parent = q and
        this.parameter(_, _, q, _, _)
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
      exists(Raw::Ast parent, int i |
        this.parameter(parent, FunParam(i), r, _, false) and
        result = TVariableSynth(parent, FunParam(i))
      )
      or
      exists(Scope::Range scope, int i, ChildIndex index |
        scope.getParameter(i) = r and
        this.isPipelineParameterChild(scope, i, index) and
        result = TVariableSynth(scope, index)
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, Raw::Parameter p, int i |
        this.parameter(parent, _, p, _, _) and
        n = TVariableSynth(parent, FunParam(i)) and
        result = p.getLocation()
      )
    }

    final override predicate parameterStaticType(Parameter n, string type) {
      exists(Raw::Ast parent, int i, Raw::Parameter p |
        this.parameter(parent, FunParam(i), p, _, false) and
        n = TVariableSynth(parent, FunParam(i)) and
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
        Raw::isAutomaticVariableAccess(va, _)
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
        Raw::isEnvVariableAccess(va, s) and
        child = SynthChild(EnvVariableKind(s))
        or
        Raw::isAutomaticVariableAccess(va, s) and
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
    private predicate expr(Raw::Ast rawParent, ChildIndex i, Raw::VarAccess va, Child child) {
      rawParent.getChild(toRawChildIndex(i)) = va and
      child = SynthChild(VarAccessSynthKind(this.varAccess(va)))
    }

    private predicate stmt(Raw::Ast rawParent, ChildIndex i, Raw::CmdExpr cmdExpr, Child child) {
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

    override predicate exprStmtExpr(ExprStmt e, Expr expr) {
      exists(Raw::Ast p, Raw::VarAccess va, Raw::CmdExpr cmdExpr, ChildIndex i1, ChildIndex i2 |
        this.stmt(p, i1, _, _) and
        this.expr(cmdExpr, i2, va, _) and
        e = TExprStmtSynth(p, i1) and
        expr = TVarAccessSynth(cmdExpr, i2, this.varAccess(va))
      )
    }

    final override Expr getResultAstImpl(Raw::Ast r) {
      exists(Raw::Ast parent, ChildIndex i | this.expr(parent, i, r, _) |
        result = TVarAccessSynth(parent, i, this.varAccess(r))
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
      exists(Raw::Ast parent |
        n = TVariableSynth(parent, _) and
        result = parent.getLocation()
      )
    }
  }
}
