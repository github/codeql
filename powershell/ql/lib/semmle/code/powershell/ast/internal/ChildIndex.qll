private import Raw.Raw as Raw
private import Scopes
private import TAst

newtype ChildIndex =
  RawChildIndex(Raw::ChildIndex index) or
  ParamPipeline() or
  ParamDefaultVal() or
  ParamAttr(int i) { exists(any(Raw::Parameter p).getAttribute(i)) } or
  FunctionBody() or
  ScriptBlockAttr(int i) { exists(any(Raw::ParamBlock sb).getAttribute(i)) } or
  FunParam(int i) {
    exists(any(Raw::ParamBlock pb).getParameter(i))
    or
    exists(any(Raw::FunctionDefinitionStmt func).getParameter(i))
    or
    // Synth an extra parameter index for a pipeline parameter if none is provided
    exists(Raw::ParamBlock pb |
      not pb.getAParameter() instanceof Raw::PipelineParameter and
      i = pb.getNumParameters()
    )
  } or
  CmdArgument(int i) { exists(any(Raw::Cmd cmd).getArgument(i)) } or
  ExprStmtExpr() or
  MethodBody() or
  ExprRedirection(int i) { exists(any(Raw::Cmd cmdExpr).getRedirection(i)) } or
  FunDefFun() or
  TypeDefType() or
  TypeMember(int i) {
    exists(any(Raw::TypeStmt typedef).getMember(i))
    // or
    // hasMemberInType(_, _, i, _)
  } or
  ThisVar() or
  PipelineIteratorVar() or
  PipelineByPropertyNameIteratorVar(Raw::PipelineByPropertyNameParameter p) or
  RealVar(string name) { name = variableNameInScope(_, _) } or
  ProcessBlockPipelineVarReadAccess() or
  ProcessBlockPipelineByPropertyNameVarReadAccess(string name) {
    name = any(Raw::PipelineByPropertyNameParameter p).getName()
  }

int synthPipelineParameterChildIndex(Raw::ScriptBlock sb) {
  // If there is a parameter block, but no pipeline parameter
  exists(Raw::ParamBlock pb |
    pb = sb.getParamBlock() and
    not pb.getAParameter() instanceof Raw::PipelineParameter and
    result = pb.getNumParameters()
  )
  or
  // There is no parameter block
  not exists(sb.getParamBlock()) and
  exists(Raw::FunctionDefinitionStmt funDefStmt |
    funDefStmt.getBody() = sb and
    result = funDefStmt.getNumParameters()
  )
}

string stringOfChildIndex(ChildIndex i) {
  exists(Raw::ChildIndex rawIndex |
    i = RawChildIndex(rawIndex) and
    result = Raw::stringOfChildIndex(rawIndex)
  )
  or
  i = ParamPipeline() and
  result = "ParamPipeline"
  or
  i = ParamDefaultVal() and
  result = "ParamDefaultVal"
  or
  i = FunParam(_) and
  result = "FunParam"
  or
  i = CmdArgument(_) and
  result = "CmdArgument"
  or
  i = ExprStmtExpr() and
  result = "ExprStmtExpr"
  or
  i = MethodBody() and
  result = "MethodBody"
  or
  i = ThisVar() and
  result = "ThisVar"
  or
  i = PipelineIteratorVar() and
  result = "PipelineIteratorVar"
  or
  i = PipelineByPropertyNameIteratorVar(_) and
  result = "PipelineByPropertyNameIteratorVar"
  or
  i = RealVar(_) and
  result = "RealVar"
  or
  i = ExprRedirection(_) and
  result = "ExprRedirection"
  or
  i = FunDefFun() and
  result = "FunDefFun"
  or
  i = TypeDefType() and
  result = "TypeDefType"
  or
  i = TypeMember(_) and
  result = "TypeMember"
  or
  i = ScriptBlockAttr(_) and
  result = "ScriptBlockAttr"
  or
  i = ParamAttr(_) and
  result = "ParamAttr"
  or
  i = FunctionBody() and
  result = "FunctionBody"
  or
  i = ProcessBlockPipelineVarReadAccess() and
  result = "ProcessBlockPipelineVarReadAccess"
}

Raw::ChildIndex toRawChildIndex(ChildIndex i) { i = RawChildIndex(result) }

ChildIndex arrayExprStmtBlock() { result = RawChildIndex(Raw::ArrayExprStmtBlock()) }

ChildIndex arrayLiteralExpr(int i) { result = RawChildIndex(Raw::ArrayLiteralExpr(i)) }

ChildIndex assignStmtLeftHandSide() { result = RawChildIndex(Raw::AssignStmtLeftHandSide()) }

ChildIndex assignStmtRightHandSide() { result = RawChildIndex(Raw::AssignStmtRightHandSide()) }

ChildIndex memberAttr(int i) { result = RawChildIndex(Raw::MemberAttr(i)) }

ChildIndex memberTypeConstraint() { result = RawChildIndex(Raw::MemberTypeConstraint()) }

ChildIndex attributeNamedArg(int i) { result = RawChildIndex(Raw::AttributeNamedArg(i)) }

ChildIndex attributePosArg(int i) { result = RawChildIndex(Raw::AttributePosArg(i)) }

ChildIndex attributedExprExpr() { result = RawChildIndex(Raw::AttributedExprExpr()) }

ChildIndex attributedExprAttr() { result = RawChildIndex(Raw::AttributedExprAttr()) }

ChildIndex binaryExprLeft() { result = RawChildIndex(Raw::BinaryExprLeft()) }

ChildIndex binaryExprRight() { result = RawChildIndex(Raw::BinaryExprRight()) }

ChildIndex catchClauseBody() { result = RawChildIndex(Raw::CatchClauseBody()) }

ChildIndex catchClauseType(int i) { result = RawChildIndex(Raw::CatchClauseType(i)) }

ChildIndex cmdCallee() { result = RawChildIndex(Raw::CmdCallee()) }

ChildIndex cmdArgument(int i) { result = CmdArgument(i) }

ChildIndex cmdRedirection(int i) { result = RawChildIndex(Raw::CmdRedirection(i)) }

ChildIndex cmdElement_(int i) { result = RawChildIndex(Raw::CmdElement_(i)) }

ChildIndex cmdExprExpr() { result = RawChildIndex(Raw::CmdExprExpr()) }

ChildIndex configurationName() { result = RawChildIndex(Raw::ConfigurationName()) }

ChildIndex configurationBody() { result = RawChildIndex(Raw::ConfigurationBody()) }

ChildIndex convertExprExpr() { result = RawChildIndex(Raw::ConvertExprExpr()) }

ChildIndex convertExprType() { result = RawChildIndex(Raw::ConvertExprType()) }

ChildIndex convertExprAttr() { result = RawChildIndex(Raw::ConvertExprAttr()) }

ChildIndex dataStmtBody() { result = RawChildIndex(Raw::DataStmtBody()) }

ChildIndex dataStmtCmdAllowed(int i) { result = RawChildIndex(Raw::DataStmtCmdAllowed(i)) }

ChildIndex doUntilStmtCond() { result = RawChildIndex(Raw::DoUntilStmtCond()) }

ChildIndex doUntilStmtBody() { result = RawChildIndex(Raw::DoUntilStmtBody()) }

ChildIndex doWhileStmtCond() { result = RawChildIndex(Raw::DoWhileStmtCond()) }

ChildIndex doWhileStmtBody() { result = RawChildIndex(Raw::DoWhileStmtBody()) }

ChildIndex dynamicStmtName() { result = RawChildIndex(Raw::DynamicStmtName()) }

ChildIndex dynamicStmtBody() { result = RawChildIndex(Raw::DynamicStmtBody()) }

ChildIndex exprStmtExpr() { result = ExprStmtExpr() }

ChildIndex exprRedirection(int i) { result = ExprRedirection(i) }

ChildIndex exitStmtPipeline() { result = RawChildIndex(Raw::ExitStmtPipeline()) }

ChildIndex expandableStringExprExpr(int i) {
  result = RawChildIndex(Raw::ExpandableStringExprExpr(i))
}

ChildIndex forEachStmtVar() { result = RawChildIndex(Raw::ForEachStmtVar()) }

ChildIndex forEachStmtIter() { result = RawChildIndex(Raw::ForEachStmtIter()) }

ChildIndex forEachStmtBody() { result = RawChildIndex(Raw::ForEachStmtBody()) }

ChildIndex forStmtInit() { result = RawChildIndex(Raw::ForStmtInit()) }

ChildIndex forStmtCond() { result = RawChildIndex(Raw::ForStmtCond()) }

ChildIndex forStmtIter() { result = RawChildIndex(Raw::ForStmtIter()) }

ChildIndex forStmtBody() { result = RawChildIndex(Raw::ForStmtBody()) }

ChildIndex functionBody() { result = FunctionBody() }

ChildIndex funDefStmtBody() { result = RawChildIndex(Raw::FunDefStmtBody()) }

ChildIndex funDefStmtParam(int i) { result = RawChildIndex(Raw::FunDefStmtParam(i)) }

ChildIndex funDefFun() { result = FunDefFun() }

ChildIndex typeDefType() { result = TypeDefType() }

ChildIndex typeMember(int i) { result = TypeMember(i) }

ChildIndex gotoStmtLabel() { result = RawChildIndex(Raw::GotoStmtLabel()) }

ChildIndex hashTableExprKey(int i) { result = RawChildIndex(Raw::HashTableExprKey(i)) }

ChildIndex hashTableExprStmt(int i) { result = RawChildIndex(Raw::HashTableExprStmt(i)) }

ChildIndex ifStmtElse() { result = RawChildIndex(Raw::IfStmtElse()) }

ChildIndex ifStmtCond(int i) { result = RawChildIndex(Raw::IfStmtCond(i)) }

ChildIndex ifStmtThen(int i) { result = RawChildIndex(Raw::IfStmtThen(i)) }

ChildIndex indexExprIndex() { result = RawChildIndex(Raw::IndexExprIndex()) }

ChildIndex indexExprBase() { result = RawChildIndex(Raw::IndexExprBase()) }

ChildIndex invokeMemberExprQual() { result = RawChildIndex(Raw::InvokeMemberExprQual()) }

ChildIndex invokeMemberExprCallee() { result = RawChildIndex(Raw::InvokeMemberExprCallee()) }

ChildIndex invokeMemberExprArg(int i) { result = RawChildIndex(Raw::InvokeMemberExprArg(i)) }

ChildIndex memberExprQual() { result = RawChildIndex(Raw::MemberExprQual()) }

ChildIndex memberExprMember() { result = RawChildIndex(Raw::MemberExprMember()) }

ChildIndex methodBody() { result = MethodBody() }

ChildIndex namedAttributeArgVal() { result = RawChildIndex(Raw::NamedAttributeArgVal()) }

ChildIndex namedBlockStmt(int i) { result = RawChildIndex(Raw::NamedBlockStmt(i)) }

ChildIndex namedBlockTrap(int i) { result = RawChildIndex(Raw::NamedBlockTrap(i)) }

ChildIndex paramBlockAttr(int i) { result = RawChildIndex(Raw::ParamBlockAttr(i)) }

ChildIndex paramBlockParam(int i) { result = RawChildIndex(Raw::ParamBlockParam(i)) }

ChildIndex paramAttr(int i) { result = ParamAttr(i) }

ChildIndex paramDefaultVal() { result = ParamDefaultVal() }

ChildIndex parenExprExpr() { result = RawChildIndex(Raw::ParenExprExpr()) }

ChildIndex pipelineComp(int i) { result = RawChildIndex(Raw::PipelineComp(i)) }

ChildIndex pipelineChainLeft() { result = RawChildIndex(Raw::PipelineChainLeft()) }

ChildIndex pipelineChainRight() { result = RawChildIndex(Raw::PipelineChainRight()) }

ChildIndex returnStmtPipeline() { result = RawChildIndex(Raw::ReturnStmtPipeline()) }

ChildIndex scriptBlockUsing(int i) { result = RawChildIndex(Raw::ScriptBlockUsing(i)) }

ChildIndex scriptBlockParamBlock() { result = RawChildIndex(Raw::ScriptBlockParamBlock()) }

ChildIndex scriptBlockBeginBlock() { result = RawChildIndex(Raw::ScriptBlockBeginBlock()) }

ChildIndex scriptBlockCleanBlock() { result = RawChildIndex(Raw::ScriptBlockCleanBlock()) }

ChildIndex scriptBlockDynParamBlock() { result = RawChildIndex(Raw::ScriptBlockDynParamBlock()) }

ChildIndex scriptBlockEndBlock() { result = RawChildIndex(Raw::ScriptBlockEndBlock()) }

ChildIndex scriptBlockProcessBlock() { result = RawChildIndex(Raw::ScriptBlockProcessBlock()) }

ChildIndex scriptBlockExprBody() { result = RawChildIndex(Raw::ScriptBlockExprBody()) }

ChildIndex scriptBlockAttr(int i) { result = ScriptBlockAttr(i) }

ChildIndex trapStmtBody() { result = RawChildIndex(Raw::TrapStmtBody()) }

ChildIndex trapStmtTypeConstraint() { result = RawChildIndex(Raw::TrapStmtTypeConstraint()) }

ChildIndex redirectionExpr() { result = RawChildIndex(Raw::RedirectionExpr()) }

ChildIndex funParam(int i) { result = FunParam(i) }

ChildIndex stmtBlockStmt(int i) { result = RawChildIndex(Raw::StmtBlockStmt(i)) }

ChildIndex stmtBlockTrapStmt(int i) { result = RawChildIndex(Raw::StmtBlockTrapStmt(i)) }

ChildIndex expandableSubExprExpr() { result = RawChildIndex(Raw::ExpandableSubExprExpr()) }

ChildIndex switchStmtCond() { result = RawChildIndex(Raw::SwitchStmtCond()) }

ChildIndex switchStmtDefault() { result = RawChildIndex(Raw::SwitchStmtDefault()) }

ChildIndex switchStmtCase(int i) { result = RawChildIndex(Raw::SwitchStmtCase(i)) }

ChildIndex switchStmtPat(int i) { result = RawChildIndex(Raw::SwitchStmtPat(i)) }

ChildIndex condExprCond() { result = RawChildIndex(Raw::CondExprCond()) }

ChildIndex condExprTrue() { result = RawChildIndex(Raw::CondExprTrue()) }

ChildIndex condExprFalse() { result = RawChildIndex(Raw::CondExprFalse()) }

ChildIndex throwStmtPipeline() { result = RawChildIndex(Raw::ThrowStmtPipeline()) }

ChildIndex tryStmtBody() { result = RawChildIndex(Raw::TryStmtBody()) }

ChildIndex tryStmtCatchClause(int i) { result = RawChildIndex(Raw::TryStmtCatchClause(i)) }

ChildIndex tryStmtFinally() { result = RawChildIndex(Raw::TryStmtFinally()) }

ChildIndex typeStmtMember(int i) { result = RawChildIndex(Raw::TypeStmtMember(i)) }

ChildIndex typeStmtBaseType(int i) { result = RawChildIndex(Raw::TypeStmtBaseType(i)) }

ChildIndex unaryExprOp() { result = RawChildIndex(Raw::UnaryExprOp()) }

ChildIndex usingExprExpr() { result = RawChildIndex(Raw::UsingExprExpr()) }

ChildIndex whileStmtCond() { result = RawChildIndex(Raw::WhileStmtCond()) }

ChildIndex whileStmtBody() { result = RawChildIndex(Raw::WhileStmtBody()) }

ChildIndex processBlockPipelineVarReadAccess() { result = ProcessBlockPipelineVarReadAccess() }

ChildIndex processBlockPipelineByPropertyNameVarReadAccess(string name) {
  result = ProcessBlockPipelineByPropertyNameVarReadAccess(name)
}
