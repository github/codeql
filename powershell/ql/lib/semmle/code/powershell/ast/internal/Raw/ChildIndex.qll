private import Raw

newtype ChildIndex =
  ArrayExprStmtBlock() or
  ArrayLiteralExpr(int i) { exists(any(ArrayLiteral lit).getElement(i)) } or
  AssignStmtLeftHandSide() or
  AssignStmtRightHandSide() or
  AttributeNamedArg(int i) { exists(any(Attribute a).getNamedArgument(i)) } or
  AttributePosArg(int i) { exists(any(Attribute a).getPositionalArgument(i)) } or
  AttributedExprExpr() or
  AttributedExprAttr() or
  BinaryExprLeft() or
  BinaryExprRight() or
  CatchClauseBody() or
  CatchClauseType(int i) { exists(any(CatchClause c).getCatchType(i)) } or
  CmdElement_(int i) { exists(any(Cmd cmd).getElement(i)) } or // TODO: Get rid of this?
  CmdCallee() or
  CmdRedirection(int i) { exists(any(Cmd cmd).getRedirection(i)) } or
  CmdExprExpr() or
  ConfigurationName() or
  ConfigurationBody() or
  ConvertExprExpr() or
  ConvertExprType() or
  ConvertExprAttr() or
  DataStmtBody() or
  DataStmtCmdAllowed(int i) { exists(any(DataStmt d).getCmdAllowed(i)) } or
  DoUntilStmtCond() or
  DoUntilStmtBody() or
  DoWhileStmtCond() or
  DoWhileStmtBody() or
  DynamicStmtName() or
  DynamicStmtBody() or
  ExitStmtPipeline() or
  ExpandableStringExprExpr(int i) { exists(any(ExpandableStringExpr e).getExpr(i)) } or
  ForEachStmtVar() or
  ForEachStmtIter() or
  ForEachStmtBody() or
  ForStmtInit() or
  ForStmtCond() or
  ForStmtIter() or
  ForStmtBody() or
  FunDefStmtBody() or
  FunDefStmtParam(int i) { exists(any(FunctionDefinitionStmt def).getParameter(i)) } or
  GotoStmtLabel() or
  HashTableExprKey(int i) { exists(any(HashTableExpr e).getKey(i)) } or
  HashTableExprStmt(int i) { exists(any(HashTableExpr e).getStmt(i)) } or
  IfStmtElse() or
  IfStmtCond(int i) { exists(any(IfStmt ifstmt).getCondition(i)) } or
  IfStmtThen(int i) { exists(any(IfStmt ifstmt).getThen(i)) } or
  IndexExprIndex() or
  IndexExprBase() or
  InvokeMemberExprQual() or
  InvokeMemberExprCallee() or
  InvokeMemberExprArg(int i) { exists(any(InvokeMemberExpr e).getArgument(i)) } or
  MemberExprQual() or
  MemberExprMember() or
  NamedAttributeArgVal() or
  MemberAttr(int i) { exists(any(Member m).getAttribute(i)) } or
  MemberTypeConstraint() or
  NamedBlockStmt(int i) { exists(any(NamedBlock b).getStmt(i)) } or
  NamedBlockTrap(int i) { exists(any(NamedBlock b).getTrap(i)) } or
  ParamBlockAttr(int i) { exists(any(ParamBlock p).getAttribute(i)) } or
  ParamBlockParam(int i) { exists(any(ParamBlock p).getParameter(i)) } or
  ParamAttr(int i) { exists(any(Parameter p).getAttribute(i)) } or
  ParamDefaultVal() or
  ParenExprExpr() or
  PipelineComp(int i) { exists(any(Pipeline p).getComponent(i)) } or
  PipelineChainLeft() or
  PipelineChainRight() or
  ReturnStmtPipeline() or
  RedirectionExpr() or
  ScriptBlockUsing(int i) { exists(any(ScriptBlock s).getUsing(i)) } or
  ScriptBlockParamBlock() or
  ScriptBlockBeginBlock() or
  ScriptBlockCleanBlock() or
  ScriptBlockDynParamBlock() or
  ScriptBlockEndBlock() or
  ScriptBlockProcessBlock() or
  ScriptBlockExprBody() or
  StmtBlockStmt(int i) { exists(any(StmtBlock b).getStmt(i)) } or
  StmtBlockTrapStmt(int i) { exists(any(StmtBlock b).getTrapStmt(i)) } or
  ExpandableSubExprExpr() or
  SwitchStmtCond() or
  SwitchStmtDefault() or
  SwitchStmtCase(int i) { exists(any(SwitchStmt s).getCase(i)) } or
  SwitchStmtPat(int i) { exists(any(SwitchStmt s).getPattern(i)) } or
  CondExprCond() or
  CondExprTrue() or
  CondExprFalse() or
  ThrowStmtPipeline() or
  TryStmtBody() or
  TryStmtCatchClause(int i) { exists(any(TryStmt t).getCatchClause(i)) } or
  TryStmtFinally() or
  TypeStmtMember(int i) { exists(any(TypeStmt t).getMember(i)) } or
  TypeStmtBaseType(int i) { exists(any(TypeStmt t).getBaseType(i)) } or
  TrapStmtBody() or
  TrapStmtTypeConstraint() or
  UnaryExprOp() or
  UsingExprExpr() or
  WhileStmtCond() or
  WhileStmtBody()

string stringOfChildIndex(ChildIndex i) {
  i = ArrayExprStmtBlock() and result = "ArrayExprStmtBlock"
  or
  i = ArrayLiteralExpr(_) and result = "ArrayLiteralExpr"
  or
  i = AssignStmtLeftHandSide() and result = "AssignStmtLeftHandSide"
  or
  i = AssignStmtRightHandSide() and result = "AssignStmtRightHandSide"
  or
  i = AttributeNamedArg(_) and result = "AttributeNamedArg"
  or
  i = AttributePosArg(_) and result = "AttributePosArg"
  or
  i = AttributedExprExpr() and result = "AttributedExprExpr"
  or
  i = AttributedExprAttr() and result = "AttributedExprAttr"
  or
  i = BinaryExprLeft() and result = "BinaryExprLeft"
  or
  i = BinaryExprRight() and result = "BinaryExprRight"
  or
  i = CatchClauseBody() and result = "CatchClauseBody"
  or
  i = CatchClauseType(_) and result = "CatchClauseType"
  or
  i = CmdElement_(_) and result = "CmdElement"
  or
  i = CmdCallee() and result = "CmdCallee"
  or
  i = CmdRedirection(_) and result = "CmdRedirection"
  or
  i = CmdExprExpr() and result = "CmdExprExpr"
  or
  i = ConfigurationName() and result = "ConfigurationName"
  or
  i = ConfigurationBody() and result = "ConfigurationBody"
  or
  i = ConvertExprExpr() and result = "ConvertExprExpr"
  or
  i = ConvertExprType() and result = "ConvertExprType"
  or
  i = ConvertExprAttr() and result = "ConvertExprAttr"
  or
  i = DataStmtBody() and result = "DataStmtBody"
  or
  i = DataStmtCmdAllowed(_) and result = "DataStmtCmdAllowed"
  or
  i = DoUntilStmtCond() and result = "DoUntilStmtCond"
  or
  i = DoUntilStmtBody() and result = "DoUntilStmtBody"
  or
  i = DoWhileStmtCond() and result = "DoWhileStmtCond"
  or
  i = DoWhileStmtBody() and result = "DoWhileStmtBody"
  or
  i = DynamicStmtName() and result = "DynamicStmtName"
  or
  i = DynamicStmtBody() and result = "DynamicStmtBody"
  or
  i = ExitStmtPipeline() and result = "ExitStmtPipeline"
  or
  i = ExpandableStringExprExpr(_) and result = "ExpandableStringExprExpr"
  or
  i = ForEachStmtVar() and result = "ForEachStmtVar"
  or
  i = ForEachStmtIter() and result = "ForEachStmtIter"
  or
  i = ForEachStmtBody() and result = "ForEachStmtBody"
  or
  i = ForStmtInit() and result = "ForStmtInit"
  or
  i = ForStmtCond() and result = "ForStmtCond"
  or
  i = ForStmtIter() and result = "ForStmtIter"
  or
  i = ForStmtBody() and result = "ForStmtBody"
  or
  i = FunDefStmtBody() and result = "FunDefStmtBody"
  or
  i = FunDefStmtParam(_) and result = "FunDefStmtParam"
  or
  i = GotoStmtLabel() and result = "GotoStmtLabel"
  or
  i = HashTableExprKey(_) and result = "HashTableExprKey"
  or
  i = HashTableExprStmt(_) and result = "HashTableExprStmt"
  or
  i = IfStmtElse() and result = "IfStmtElse"
  or
  i = IfStmtCond(_) and result = "IfStmtCond"
  or
  i = IfStmtThen(_) and result = "IfStmtThen"
  or
  i = IndexExprIndex() and result = "IndexExprIndex"
  or
  i = IndexExprBase() and result = "IndexExprBase"
  or
  i = InvokeMemberExprQual() and result = "InvokeMemberExprQual"
  or
  i = InvokeMemberExprCallee() and result = "InvokeMemberExprCallee"
  or
  i = InvokeMemberExprArg(_) and result = "InvokeMemberExprArg"
  or
  i = MemberExprQual() and result = "MemberExprQual"
  or
  i = MemberExprMember() and result = "MemberExprMember"
  or
  i = NamedAttributeArgVal() and result = "NamedAttributeArgVal"
  or
  i = MemberAttr(_) and result = "MemberAttr"
  or
  i = MemberTypeConstraint() and result = "MemberTypeConstraint"
  or
  i = NamedBlockStmt(_) and result = "NamedBlockStmt"
  or
  i = NamedBlockTrap(_) and result = "NamedBlockTrap"
  or
  i = ParamBlockAttr(_) and result = "ParamBlockAttr"
  or
  i = ParamBlockParam(_) and result = "ParamBlockParam"
  or
  i = ParamAttr(_) and result = "ParamAttr"
  or
  i = ParamDefaultVal() and result = "ParamDefaultVal"
  or
  i = ParenExprExpr() and result = "ParenExprExpr"
  or
  i = PipelineComp(_) and result = "PipelineComp"
  or
  i = PipelineChainLeft() and result = "PipelineChainLeft"
  or
  i = PipelineChainRight() and result = "PipelineChainRight"
  or
  i = ReturnStmtPipeline() and result = "ReturnStmtPipeline"
  or
  i = RedirectionExpr() and result = "RedirectionExpr"
  or
  i = ScriptBlockUsing(_) and result = "ScriptBlockUsing"
  or
  i = ScriptBlockParamBlock() and result = "ScriptBlockParamBlock"
  or
  i = ScriptBlockBeginBlock() and result = "ScriptBlockBeginBlock"
  or
  i = ScriptBlockCleanBlock() and result = "ScriptBlockCleanBlock"
  or
  i = ScriptBlockDynParamBlock() and result = "ScriptBlockDynParamBlock"
  or
  i = ScriptBlockEndBlock() and result = "ScriptBlockEndBlock"
  or
  i = ScriptBlockProcessBlock() and result = "ScriptBlockProcessBlock"
  or
  i = ScriptBlockExprBody() and result = "ScriptBlockExprBody"
  or
  i = StmtBlockStmt(_) and result = "StmtBlockStmt"
  or
  i = StmtBlockTrapStmt(_) and result = "StmtBlockTrapStmt"
  or
  i = ExpandableSubExprExpr() and result = "ExpandableSubExprExpr"
  or
  i = SwitchStmtCond() and result = "SwitchStmtCond"
  or
  i = SwitchStmtDefault() and result = "SwitchStmtDefault"
  or
  i = SwitchStmtCase(_) and result = "SwitchStmtCase"
  or
  i = SwitchStmtPat(_) and result = "SwitchStmtPat"
  or
  i = CondExprCond() and result = "CondExprCond"
  or
  i = CondExprTrue() and result = "CondExprTrue"
  or
  i = CondExprFalse() and result = "CondExprFalse"
  or
  i = ThrowStmtPipeline() and result = "ThrowStmtPipeline"
  or
  i = TryStmtBody() and result = "TryStmtBody"
  or
  i = TryStmtCatchClause(_) and result = "TryStmtCatchClause"
  or
  i = TryStmtFinally() and result = "TryStmtFinally"
  or
  i = TypeStmtMember(_) and result = "TypeStmtMember"
  or
  i = TypeStmtBaseType(_) and result = "TypeStmtBaseType"
  or
  i = TrapStmtBody() and result = "TrapStmtBody"
  or
  i = TrapStmtTypeConstraint() and result = "TrapStmtTypeConstraint"
  or
  i = UnaryExprOp() and result = "UnaryExprOp"
  or
  i = UsingExprExpr() and result = "UsingExprExpr"
  or
  i = WhileStmtCond() and result = "WhileStmtCond"
  or
  i = WhileStmtBody() and result = "WhileStmtBody"
}
