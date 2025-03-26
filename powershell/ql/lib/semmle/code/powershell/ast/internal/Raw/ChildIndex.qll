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
