private import Raw.Raw as Raw
private import Location
private import Ast as Ast
private import Synthesis
private import Expr
private import Internal::Private
private import Internal::Public

private predicate mkSynthChild(SynthKind kind, Raw::Ast parent, ChildIndex i) {
  any(Synthesis s).child(parent, i, SynthChild(kind))
}

string variableNameInScope(Raw::Ast n, Scope::Range scope) {
  scope = Raw::scopeOf(n) and
  (
    result = n.(Raw::VarAccess).getUserPath() and
    not scope.getAParameter().(Raw::PipelineByPropertyNameParameter).getName() = result and
    not result.toLowerCase() = ["_", "this", "false", "true", "null"] and
    not parameter(_, n, _, _) and
    not Raw::isEnvVariableAccess(n, _)
    or
    any(Synthesis s).explicitAssignment(n, result, _)
    or
    any(Synthesis s).implicitAssignment(n, result)
  )
}

predicate scopeAssigns(Scope::Range scope, string name, Raw::Ast n) {
  (explicitAssignment(n, _) or implicitAssignment(n)) and
  name = variableNameInScope(n, scope)
}

private predicate scopeDefinesParameterVariable(Scope::Range scope, string name) {
  exists(Raw::Parameter p |
    any(Synthesis s).implicitAssignment(p, name) and
    p.getScope() = scope
  )
}

private predicate inherits(Scope::Range scope, string name, Scope::Range outer) {
  not scopeDefinesParameterVariable(scope, name) and
  (
    outer = scope.getOuterScope() and
    (
      scopeDefinesParameterVariable(outer, name)
      or
      exists(Raw::Ast n |
        scopeAssigns(outer, name, n) and
        n.getLocation().strictlyBefore(scope.getLocation())
      )
    )
    or
    inherits(scope.getOuterScope(), name, outer)
  )
}

pragma[nomagic]
private predicate hasScopeAndName(VariableImpl variable, Scope::Range scope, string name) {
  variable.getNameImpl() = name and
  scope = variable.getDeclaringScopeImpl()
}

predicate access(Raw::VarAccess va, VariableImpl v) {
  exists(string name, Scope::Range scope |
    pragma[only_bind_into](name) = variableNameInScope(va, scope)
  |
    hasScopeAndName(v, scope, name)
    or
    exists(Scope::Range declScope |
      hasScopeAndName(v, declScope, pragma[only_bind_into](name)) and
      inherits(scope, name, declScope)
    )
  )
}

cached
private module Cached {
  private predicate excludeStringConstExpr(Raw::StringConstExpr e) {
    // i.e., "Node" or "Script"
    dynamic_keyword_statement_command_elements(_, 0, e)
  }

  cached
  newtype TAst =
    TAttributedExpr(Raw::AttributedExpr a) or
    TArrayExpr(Raw::ArrayExpr e) or
    TArrayLiteral(Raw::ArrayLiteral lit) or
    TAssignStmt(Raw::AssignStmt s) or
    TAttribute(Raw::Attribute a) or
    TBinaryExpr(Raw::BinaryExpr bin) or
    TBreakStmt(Raw::BreakStmt br) or
    TCatchClause(Raw::CatchClause cc) or
    TCmd(Raw::Cmd c) or
    TExprStmtSynth(Raw::Ast parent, ChildIndex i) { mkSynthChild(ExprStmtKind(), parent, i) } or
    TTopLevelFunction(Raw::TopLevelScriptBlock scriptBlock) or
    TFunctionSynth(Raw::Ast parent, ChildIndex i) { mkSynthChild(FunctionSynthKind(), parent, i) } or
    TConfiguration(Raw::Configuration c) or
    TConstExpr(Raw::ConstExpr c) or
    TContinueStmt(Raw::ContinueStmt c) or
    TConvertExpr(Raw::ConvertExpr c) or
    TDataStmt(Raw::DataStmt d) or
    TDoUntilStmt(Raw::DoUntilStmt d) or
    TDoWhileStmt(Raw::DoWhileStmt d) or
    TDynamicStmt(Raw::DynamicStmt d) or
    TErrorExpr(Raw::ErrorExpr e) or
    TErrorStmt(Raw::ErrorStmt e) or
    TExitStmt(Raw::ExitStmt e) or
    TExpandableStringExpr(Raw::ExpandableStringExpr e) or
    TFunctionDefinitionStmt(Raw::FunctionDefinitionStmt f) { not excludeFunctionDefinitionStmt(f) } or
    TForEachStmt(Raw::ForEachStmt f) or
    TForStmt(Raw::ForStmt f) or
    THashTableExpr(Raw::HashTableExpr h) or
    TIf(Raw::IfStmt i) or
    TIndexExpr(Raw::IndexExpr i) or
    TInvokeMemberExpr(Raw::InvokeMemberExpr i) or
    TMethod(Raw::Method m) or
    TMemberExpr(Raw::MemberExpr m) or
    TNamedAttributeArgument(Raw::NamedAttributeArgument n) or
    TNamedBlock(Raw::NamedBlock n) or
    TParenExpr(Raw::ParenExpr p) or
    TPipeline(Raw::Pipeline p) or
    TPipelineChain(Raw::PipelineChain p) or
    TPropertyMember(Raw::PropertyMember p) or
    TRedirection(Raw::Redirection r) or
    TReturnStmt(Raw::ReturnStmt r) or
    TScriptBlock(Raw::ScriptBlock s) or
    TScriptBlockExpr(Raw::ScriptBlockExpr s) or
    TExpandableSubExpr(Raw::ExpandableSubExpr e) or
    TStmtBlock(Raw::StmtBlock s) or
    TStringConstExpr(Raw::StringConstExpr s) { not excludeStringConstExpr(s) } or
    TSwitchStmt(Raw::SwitchStmt s) or
    TConditionalExpr(Raw::ConditionalExpr t) or
    TThrowStmt(Raw::ThrowStmt t) or
    TTrapStmt(Raw::TrapStmt t) or
    TThisExprReal(Raw::ThisAccess t) or
    TTryStmt(Raw::TryStmt t) or
    TTypeDefinitionStmt(Raw::TypeStmt t) or
    TTypeSynth(Raw::Ast parent, ChildIndex i) { mkSynthChild(TypeSynthKind(), parent, i) } or
    TTypeConstraint(Raw::TypeConstraint t) or
    TUnaryExpr(Raw::UnaryExpr u) or
    TUsingStmt(Raw::UsingStmt u) or
    TVariableReal(Scope::Range scope, string name, Raw::Ast n) {
      not n instanceof Raw::Parameter and // we synthesize all parameters
      n =
        min(Raw::Ast other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TVariableSynth(Raw::Ast scope, ChildIndex i) { mkSynthChild(VarSynthKind(_), scope, i) } or
    TVarAccessReal(Raw::VarAccess va) { access(va, _) } or
    TVarAccessSynth(Raw::Ast parent, ChildIndex i) {
      mkSynthChild(VarAccessRealKind(_), parent, i)
      or
      mkSynthChild(VarAccessSynthKind(_), parent, i)
    } or
    TWhileStmt(Raw::WhileStmt w) or
    TTypeNameExpr(Raw::TypeNameExpr t) or
    TUsingExpr(Raw::UsingExpr u) or
    TBoolLiteral(Raw::Ast parent, ChildIndex i) { mkSynthChild(BoolLiteralKind(_), parent, i) } or
    TNullLiteral(Raw::Ast parent, ChildIndex i) { mkSynthChild(NullLiteralKind(), parent, i) } or
    TEnvVariable(Raw::Ast parent, ChildIndex i) { mkSynthChild(EnvVariableKind(_), parent, i) } or
    TAutomaticVariable(Raw::Ast parent, ChildIndex i) {
      mkSynthChild(AutomaticVariableKind(_), parent, i)
    }

  class TAstReal =
    TArrayExpr or TArrayLiteral or TAssignStmt or TAttribute or TOperation or TBreakStmt or
        TCatchClause or TCmd or TConfiguration or TConstExpr or TContinueStmt or TConvertExpr or
        TDataStmt or TDoUntilStmt or TDoWhileStmt or TDynamicStmt or TErrorExpr or TErrorStmt or
        TExitStmt or TExpandableStringExpr or TForEachStmt or TForStmt or TGotoStmt or
        THashTableExpr or TIf or TIndexExpr or TInvokeMemberExpr or TMemberExpr or
        TNamedAttributeArgument or TNamedBlock or TPipeline or TPipelineChain or TPropertyMember or
        TRedirection or TReturnStmt or TScriptBlock or TScriptBlockExpr or TStmtBlock or
        TStringConstExpr or TSwitchStmt or TConditionalExpr or TThrowStmt or TTrapStmt or
        TTryStmt or TTypeDefinitionStmt or TTypeConstraint or TUsingStmt or TVarAccessReal or
        TWhileStmt or TFunctionDefinitionStmt or TExpandableSubExpr or TMethod or TTypeNameExpr or
        TAttributedExpr or TUsingExpr or TThisExprReal or TParenExpr or TVariableReal;

  class TAstSynth =
    TExprStmtSynth or TFunctionSynth or TBoolLiteral or TNullLiteral or TVarAccessSynth or
        TEnvVariable or TTypeSynth or TAutomaticVariable or TVariableSynth;

  class TExpr =
    TArrayExpr or TArrayLiteral or TOperation or TConstExpr or TConvertExpr or TErrorExpr or
        THashTableExpr or TIndexExpr or TInvokeMemberExpr or TCmd or TMemberExpr or TPipeline or
        TPipelineChain or TStringConstExpr or TConditionalExpr or TVarAccess or
        TExpandableStringExpr or TScriptBlockExpr or TExpandableSubExpr or TTypeNameExpr or
        TUsingExpr or TAttributedExpr or TIf or TBoolLiteral or TNullLiteral or TThisExpr or
        TEnvVariable or TAutomaticVariable or TParenExpr;

  class TStmt =
    TAssignStmt or TBreakStmt or TContinueStmt or TDataStmt or TDoUntilStmt or TDoWhileStmt or
        TDynamicStmt or TErrorStmt or TExitStmt or TForEachStmt or TForStmt or TGotoStmt or
        TReturnStmt or TStmtBlock or TSwitchStmt or TThrowStmt or TTrapStmt or TTryStmt or
        TUsingStmt or TWhileStmt or TConfiguration or TTypeDefinitionStmt or
        TFunctionDefinitionStmt or TExprStmt;

  class TType = TTypeSynth;

  class TOperation = TBinaryExpr or TUnaryExpr;

  class TMember = TPropertyMember or TMethod;

  class TExprStmt = TExprStmtSynth;

  class TAttributeBase = TAttribute or TTypeConstraint;

  class TFunction = TFunctionSynth or TTopLevelFunction;

  class TFunctionBase = TFunction or TMethod;

  class TAttributedExprBase = TAttributedExpr or TConvertExpr;

  class TCallExpr = TCmd or TInvokeMemberExpr;

  class TLoopStmt = TDoUntilStmt or TDoWhileStmt or TForEachStmt or TForStmt or TWhileStmt;

  class TVarAccess = TVarAccessReal or TVarAccessSynth;

  class TLiteral = TBoolLiteral or TNullLiteral;

  class TGotoStmt = TContinueStmt or TBreakStmt;

  class TThisExpr = TThisExprReal;

  cached
  Raw::Ast toRaw(TAstReal n) {
    n = TArrayExpr(result) or
    n = TArrayLiteral(result) or
    n = TAssignStmt(result) or
    n = TAttribute(result) or
    n = TBinaryExpr(result) or
    n = TBreakStmt(result) or
    n = TCatchClause(result) or
    n = TCmd(result) or
    n = TConfiguration(result) or
    n = TConstExpr(result) or
    n = TContinueStmt(result) or
    n = TConvertExpr(result) or
    n = TDataStmt(result) or
    n = TDoUntilStmt(result) or
    n = TDoWhileStmt(result) or
    n = TDynamicStmt(result) or
    n = TErrorExpr(result) or
    n = TErrorStmt(result) or
    n = TExitStmt(result) or
    n = TExpandableStringExpr(result) or
    n = TForEachStmt(result) or
    n = TForStmt(result) or
    n = THashTableExpr(result) or
    n = TIf(result) or
    n = TIndexExpr(result) or
    n = TInvokeMemberExpr(result) or
    n = TMemberExpr(result) or
    n = TNamedAttributeArgument(result) or
    n = TNamedBlock(result) or
    n = TPipeline(result) or
    n = TParenExpr(result) or
    n = TPipelineChain(result) or
    n = TPropertyMember(result) or
    n = TRedirection(result) or
    n = TReturnStmt(result) or
    n = TScriptBlock(result) or
    n = TScriptBlockExpr(result) or
    n = TStmtBlock(result) or
    n = TStringConstExpr(result) or
    n = TSwitchStmt(result) or
    n = TConditionalExpr(result) or
    n = TThrowStmt(result) or
    n = TTrapStmt(result) or
    n = TTryStmt(result) or
    n = TTypeDefinitionStmt(result) or
    n = TThisExprReal(result) or
    n = TTypeConstraint(result) or
    n = TUnaryExpr(result) or
    n = TUsingStmt(result) or
    n = TVarAccessReal(result) or
    n = TWhileStmt(result) or
    n = TFunctionDefinitionStmt(result) or
    n = TExpandableSubExpr(result) or
    n = TTypeNameExpr(result) or
    n = TMethod(result) or
    n = TAttributedExpr(result) or
    n = TUsingExpr(result) or
    n = TVariableReal(_, _, result)
  }

  cached
  Raw::Ast toRawIncludingSynth(Ast::Ast n) {
    result = toRaw(n)
    or
    not exists(toRaw(n)) and
    exists(Raw::Ast parent |
      synthChild(parent, _, n) and
      result = parent
    )
  }

  cached
  TAstReal fromRaw(Raw::Ast a) { toRaw(result) = a }

  cached
  Ast::Ast getSynthChild(Raw::Ast parent, ChildIndex i) {
    result = TExprStmtSynth(parent, i) or
    result = TFunctionSynth(parent, i) or
    result = TBoolLiteral(parent, i) or
    result = TNullLiteral(parent, i) or
    result = TVarAccessSynth(parent, i) or
    result = TEnvVariable(parent, i) or
    result = TTypeSynth(parent, i) or
    result = TAutomaticVariable(parent, i) or
    result = TVariableSynth(parent, i)
  }

  cached
  predicate synthChild(Raw::Ast parent, ChildIndex i, Ast::Ast child) {
    child = getSynthChild(parent, i)
    or
    any(Synthesis s).child(parent, i, RealChildRef(child))
    or
    any(Synthesis s).child(parent, i, SynthChildRef(child))
  }
}

import Cached
