import codeql.Locations
private import TreeSitter
private import codeql.ruby.ast.internal.Call
private import codeql.ruby.ast.internal.Parameter
private import codeql.ruby.ast.internal.Pattern
private import codeql.ruby.ast.internal.Variable
private import codeql.ruby.AST as AST
private import Synthesis

module MethodName {
  predicate range(Ruby::UnderscoreMethodName g) {
    exists(Ruby::Undef u | u.getChild(_) = g)
    or
    exists(Ruby::Alias a | a.getName() = g or a.getAlias() = g)
  }

  class Token =
    @ruby_setter or @ruby_token_class_variable or @ruby_token_constant or
        @ruby_token_global_variable or @ruby_token_identifier or @ruby_token_instance_variable or
        @ruby_token_operator;
}

private predicate mkSynthChild(SynthKind kind, AST::AstNode parent, int i) {
  any(Synthesis s).child(parent, i, SynthChild(kind))
}

cached
private module Cached {
  cached
  newtype TAstNode =
    TAddExprReal(Ruby::Binary g) { g instanceof @ruby_binary_plus } or
    TAddExprSynth(AST::AstNode parent, int i) { mkSynthChild(AddExprKind(), parent, i) } or
    TAliasStmt(Ruby::Alias g) or
    TAlternativePattern(Ruby::AlternativePattern g) or
    TArgumentList(Ruby::AstNode g) {
      (
        g.getParent() instanceof Ruby::Break or
        g.getParent() instanceof Ruby::Return or
        g.getParent() instanceof Ruby::Next or
        g.getParent() instanceof Ruby::Assignment or
        g.getParent() instanceof Ruby::OperatorAssignment
      ) and
      (
        strictcount(g.(Ruby::ArgumentList).getChild(_)) > 1
        or
        g instanceof Ruby::RightAssignmentList
      )
    } or
    TArrayPattern(Ruby::ArrayPattern g) or
    TAssignAddExpr(Ruby::OperatorAssignment g) { g instanceof @ruby_operator_assignment_plusequal } or
    TAssignBitwiseAndExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_ampersandequal
    } or
    TAssignBitwiseOrExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_pipeequal
    } or
    TAssignBitwiseXorExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_caretequal
    } or
    TAssignDivExpr(Ruby::OperatorAssignment g) { g instanceof @ruby_operator_assignment_slashequal } or
    TAssignExponentExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_starstarequal
    } or
    TAssignExprReal(Ruby::Assignment g) or
    TAssignExprSynth(AST::AstNode parent, int i) { mkSynthChild(AssignExprKind(), parent, i) } or
    TAssignLShiftExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_langlelangleequal
    } or
    TAssignLogicalAndExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_ampersandampersandequal
    } or
    TAssignLogicalOrExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_pipepipeequal
    } or
    TAssignModuloExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_percentequal
    } or
    TAssignMulExpr(Ruby::OperatorAssignment g) { g instanceof @ruby_operator_assignment_starequal } or
    TAssignRShiftExpr(Ruby::OperatorAssignment g) {
      g instanceof @ruby_operator_assignment_ranglerangleequal
    } or
    TAssignSubExpr(Ruby::OperatorAssignment g) { g instanceof @ruby_operator_assignment_minusequal } or
    TAsPattern(Ruby::AsPattern g) or
    TBareStringLiteral(Ruby::BareString g) or
    TBareSymbolLiteral(Ruby::BareSymbol g) or
    TBeginBlock(Ruby::BeginBlock g) or
    TBeginExpr(Ruby::Begin g) or
    TBitwiseAndExprReal(Ruby::Binary g) { g instanceof @ruby_binary_ampersand } or
    TBitwiseAndExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(BitwiseAndExprKind(), parent, i)
    } or
    TBitwiseOrExprReal(Ruby::Binary g) { g instanceof @ruby_binary_pipe } or
    TBitwiseOrExprSynth(AST::AstNode parent, int i) { mkSynthChild(BitwiseOrExprKind(), parent, i) } or
    TBitwiseXorExprReal(Ruby::Binary g) { g instanceof @ruby_binary_caret } or
    TBitwiseXorExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(BitwiseXorExprKind(), parent, i)
    } or
    TBlockArgument(Ruby::BlockArgument g) or
    TBlockParameter(Ruby::BlockParameter g) or
    TBraceBlockSynth(AST::AstNode parent, int i) { mkSynthChild(BraceBlockKind(), parent, i) } or
    TBraceBlockReal(Ruby::Block g) { not g.getParent() instanceof Ruby::Lambda } or
    TBreakStmt(Ruby::Break g) or
    TCaseEqExpr(Ruby::Binary g) { g instanceof @ruby_binary_equalequalequal } or
    TCaseExpr(Ruby::Case g) or
    TCaseMatch(Ruby::CaseMatch g) or
    TCharacterLiteral(Ruby::Character g) or
    TClassDeclaration(Ruby::Class g) or
    TClassVariableAccessReal(Ruby::ClassVariable g, AST::ClassVariable v) {
      ClassVariableAccess::range(g, v)
    } or
    TClassVariableAccessSynth(AST::AstNode parent, int i, AST::ClassVariable v) {
      mkSynthChild(ClassVariableAccessKind(v), parent, i)
    } or
    TComplementExpr(Ruby::Unary g) { g instanceof @ruby_unary_tilde } or
    TComplexLiteral(Ruby::Complex g) or
    TConstantReadAccessSynth(AST::AstNode parent, int i, string value) {
      mkSynthChild(ConstantReadAccessKind(value), parent, i)
    } or
    TDefinedExpr(Ruby::Unary g) { g instanceof @ruby_unary_definedquestion } or
    TDelimitedSymbolLiteral(Ruby::DelimitedSymbol g) or
    TDestructuredLeftAssignment(Ruby::DestructuredLeftAssignment g) {
      not strictcount(int i | exists(g.getParent().(Ruby::LeftAssignmentList).getChild(i))) = 1
    } or
    TDivExprReal(Ruby::Binary g) { g instanceof @ruby_binary_slash } or
    TDivExprSynth(AST::AstNode parent, int i) { mkSynthChild(DivExprKind(), parent, i) } or
    TDo(Ruby::Do g) or
    TDoBlock(Ruby::DoBlock g) { not g.getParent() instanceof Ruby::Lambda } or
    TElementReference(Ruby::ElementReference g) or
    TElse(Ruby::Else g) or
    TElsif(Ruby::Elsif g) or
    TEmptyStmt(Ruby::EmptyStatement g) or
    TEncoding(Ruby::Encoding g) or
    TEndBlock(Ruby::EndBlock g) or
    TEnsure(Ruby::Ensure g) or
    TEqExpr(Ruby::Binary g) { g instanceof @ruby_binary_equalequal } or
    TExponentExprReal(Ruby::Binary g) { g instanceof @ruby_binary_starstar } or
    TExponentExprSynth(AST::AstNode parent, int i) { mkSynthChild(ExponentExprKind(), parent, i) } or
    TFalseLiteral(Ruby::False g) or
    TFile(Ruby::File g) or
    TFindPattern(Ruby::FindPattern g) or
    TFloatLiteral(Ruby::Float g) { not any(Ruby::Rational r).getChild() = g } or
    TForExpr(Ruby::For g) or
    TForwardParameter(Ruby::ForwardParameter g) or
    TForwardArgument(Ruby::ForwardArgument g) or
    TGEExpr(Ruby::Binary g) { g instanceof @ruby_binary_rangleequal } or
    TGTExpr(Ruby::Binary g) { g instanceof @ruby_binary_rangle } or
    TGlobalVariableAccessReal(Ruby::GlobalVariable g, AST::GlobalVariable v) {
      GlobalVariableAccess::range(g, v)
    } or
    TGlobalVariableAccessSynth(AST::AstNode parent, int i, AST::GlobalVariable v) {
      mkSynthChild(GlobalVariableAccessKind(v), parent, i)
    } or
    THashKeySymbolLiteral(Ruby::HashKeySymbol g) or
    THashLiteral(Ruby::Hash g) or
    THashPattern(Ruby::HashPattern g) or
    THashSplatExpr(Ruby::HashSplatArgument g) or
    THashSplatNilParameter(Ruby::HashSplatNil g) { not g.getParent() instanceof Ruby::HashPattern } or
    THashSplatParameter(Ruby::HashSplatParameter g) {
      not g.getParent() instanceof Ruby::HashPattern
    } or
    THereDoc(Ruby::HeredocBeginning g) or
    TIdentifierMethodCall(Ruby::Identifier g) { isIdentifierMethodCall(g) } or
    TIf(Ruby::If g) or
    TIfModifierExpr(Ruby::IfModifier g) or
    TInClause(Ruby::InClause g) or
    TInstanceVariableAccessReal(Ruby::InstanceVariable g, AST::InstanceVariable v) {
      InstanceVariableAccess::range(g, v)
    } or
    TInstanceVariableAccessSynth(AST::AstNode parent, int i, AST::InstanceVariable v) {
      mkSynthChild(InstanceVariableAccessKind(v), parent, i)
    } or
    TIntegerLiteralReal(Ruby::Integer g) { not any(Ruby::Rational r).getChild() = g } or
    TIntegerLiteralSynth(AST::AstNode parent, int i, int value) {
      mkSynthChild(IntegerLiteralKind(value), parent, i)
    } or
    TKeywordParameter(Ruby::KeywordParameter g) or
    TLEExpr(Ruby::Binary g) { g instanceof @ruby_binary_langleequal } or
    TLShiftExprReal(Ruby::Binary g) { g instanceof @ruby_binary_langlelangle } or
    TLShiftExprSynth(AST::AstNode parent, int i) { mkSynthChild(LShiftExprKind(), parent, i) } or
    TLTExpr(Ruby::Binary g) { g instanceof @ruby_binary_langle } or
    TLambda(Ruby::Lambda g) or
    TLine(Ruby::Line g) or
    TLeftAssignmentList(Ruby::LeftAssignmentList g) or
    TLocalVariableAccessReal(Ruby::Identifier g, TLocalVariableReal v) {
      LocalVariableAccess::range(g, v)
    } or
    TLocalVariableAccessSynth(AST::AstNode parent, int i, AST::LocalVariable v) {
      mkSynthChild(LocalVariableAccessRealKind(v), parent, i)
      or
      mkSynthChild(LocalVariableAccessSynthKind(v), parent, i)
    } or
    TLogicalAndExprReal(Ruby::Binary g) {
      g instanceof @ruby_binary_and or g instanceof @ruby_binary_ampersandampersand
    } or
    TLogicalAndExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(LogicalAndExprKind(), parent, i)
    } or
    TLogicalOrExprReal(Ruby::Binary g) {
      g instanceof @ruby_binary_or or g instanceof @ruby_binary_pipepipe
    } or
    TLogicalOrExprSynth(AST::AstNode parent, int i) { mkSynthChild(LogicalOrExprKind(), parent, i) } or
    TMethod(Ruby::Method g) or
    TMethodCallSynth(AST::AstNode parent, int i, string name, boolean setter, int arity) {
      mkSynthChild(MethodCallKind(name, setter, arity), parent, i)
    } or
    TModuleDeclaration(Ruby::Module g) or
    TModuloExprReal(Ruby::Binary g) { g instanceof @ruby_binary_percent } or
    TModuloExprSynth(AST::AstNode parent, int i) { mkSynthChild(ModuloExprKind(), parent, i) } or
    TMulExprReal(Ruby::Binary g) { g instanceof @ruby_binary_star } or
    TMulExprSynth(AST::AstNode parent, int i) { mkSynthChild(MulExprKind(), parent, i) } or
    TNEExpr(Ruby::Binary g) { g instanceof @ruby_binary_bangequal } or
    TNextStmt(Ruby::Next g) or
    TNilLiteral(Ruby::Nil g) or
    TNoRegExpMatchExpr(Ruby::Binary g) { g instanceof @ruby_binary_bangtilde } or
    TNotExpr(Ruby::Unary g) { g instanceof @ruby_unary_bang or g instanceof @ruby_unary_not } or
    TOptionalParameter(Ruby::OptionalParameter g) or
    TPair(Ruby::Pair g) or
    TParenthesizedExpr(Ruby::ParenthesizedStatements g) or
    TParenthesizedPattern(Ruby::ParenthesizedPattern g) or
    TRShiftExprReal(Ruby::Binary g) { g instanceof @ruby_binary_ranglerangle } or
    TRShiftExprSynth(AST::AstNode parent, int i) { mkSynthChild(RShiftExprKind(), parent, i) } or
    TRangeLiteralReal(Ruby::Range g) or
    TRangeLiteralSynth(AST::AstNode parent, int i, boolean inclusive) {
      mkSynthChild(RangeLiteralKind(inclusive), parent, i)
    } or
    TRationalLiteral(Ruby::Rational g) or
    TRedoStmt(Ruby::Redo g) or
    TRegExpLiteral(Ruby::Regex g) or
    TRegExpMatchExpr(Ruby::Binary g) { g instanceof @ruby_binary_equaltilde } or
    TRegularArrayLiteral(Ruby::Array g) or
    TRegularMethodCall(Ruby::Call g) { isRegularMethodCall(g) } or
    TRegularStringLiteral(Ruby::String g) or
    TRegularSuperCall(Ruby::Call g) { g.getMethod() instanceof Ruby::Super } or
    TRescueClause(Ruby::Rescue g) or
    TRescueModifierExpr(Ruby::RescueModifier g) or
    TRetryStmt(Ruby::Retry g) or
    TReturnStmt(Ruby::Return g) or
    TScopeResolutionConstantAccess(Ruby::ScopeResolution g, Ruby::Constant constant) {
      constant = g.getName() and
      (
        // A tree-sitter `scope_resolution` node with a `constant` name field is a
        // read of that constant in any context where an identifier would be a
        // vcall.
        vcall(g)
        or
        explicitAssignmentNode(g, _)
        or
        casePattern(g)
      )
    } or
    TScopeResolutionMethodCall(Ruby::ScopeResolution g, Ruby::Identifier i) {
      isScopeResolutionMethodCall(g, i)
    } or
    TSelfReal(Ruby::Self g) or
    TSelfSynth(AST::AstNode parent, int i, AST::SelfVariable v) {
      mkSynthChild(SelfKind(v), parent, i)
    } or
    TSimpleParameterReal(Ruby::Identifier g) { g instanceof Parameter::Range } or
    TSimpleParameterSynth(AST::AstNode parent, int i) {
      mkSynthChild(SimpleParameterKind(), parent, i)
    } or
    TSimpleSymbolLiteral(Ruby::SimpleSymbol g) or
    TSingletonClass(Ruby::SingletonClass g) or
    TSingletonMethod(Ruby::SingletonMethod g) or
    TSpaceshipExpr(Ruby::Binary g) { g instanceof @ruby_binary_langleequalrangle } or
    TSplatExprReal(Ruby::SplatArgument g) or
    TSplatExprSynth(AST::AstNode parent, int i) { mkSynthChild(SplatExprKind(), parent, i) } or
    TSplatParameter(Ruby::SplatParameter g) {
      not g.getParent() instanceof Ruby::ArrayPattern and
      not g.getParent() instanceof Ruby::FindPattern
    } or
    TStmtSequenceSynth(AST::AstNode parent, int i) { mkSynthChild(StmtSequenceKind(), parent, i) } or
    TStringArrayLiteral(Ruby::StringArray g) or
    TStringConcatenation(Ruby::ChainedString g) or
    TStringEscapeSequenceComponentNonRegexp(Ruby::EscapeSequence g) {
      not g.getParent() instanceof Ruby::Regex
    } or
    TStringEscapeSequenceComponentRegexp(Ruby::EscapeSequence g) {
      g.getParent() instanceof Ruby::Regex
    } or
    TStringInterpolationComponentNonRegexp(Ruby::Interpolation g) {
      not g.getParent() instanceof Ruby::Regex
    } or
    TStringInterpolationComponentRegexp(Ruby::Interpolation g) {
      g.getParent() instanceof Ruby::Regex
    } or
    TStringTextComponentNonRegexpStringOrHeredocContent(Ruby::Token g) {
      (g instanceof Ruby::StringContent or g instanceof Ruby::HeredocContent) and
      not g.getParent() instanceof Ruby::Regex
    } or
    TStringTextComponentNonRegexpSimpleSymbol(Ruby::SimpleSymbol g) or
    TStringTextComponentNonRegexpHashKeySymbol(Ruby::HashKeySymbol g) or
    TStringTextComponentRegexp(Ruby::Token g) {
      (g instanceof Ruby::StringContent or g instanceof Ruby::HeredocContent) and
      g.getParent() instanceof Ruby::Regex
    } or
    TSubExprReal(Ruby::Binary g) { g instanceof @ruby_binary_minus } or
    TSubExprSynth(AST::AstNode parent, int i) { mkSynthChild(SubExprKind(), parent, i) } or
    TSubshellLiteral(Ruby::Subshell g) or
    TSymbolArrayLiteral(Ruby::SymbolArray g) or
    TTernaryIfExpr(Ruby::Conditional g) or
    TThen(Ruby::Then g) or
    TTokenConstantAccess(Ruby::Constant g) {
      // A tree-sitter `constant` token is a read of that constant in any context
      // where an identifier would be a vcall.
      vcall(g)
      or
      explicitAssignmentNode(g, _)
      or
      casePattern(g)
    } or
    TTokenMethodName(MethodName::Token g) { MethodName::range(g) } or
    TTokenSuperCall(Ruby::Super g) { vcall(g) } or
    TToplevel(Ruby::Program g) or
    TTrueLiteral(Ruby::True g) or
    TDestructuredParameter(Ruby::DestructuredParameter g) or
    TUnaryMinusExpr(Ruby::Unary g) { g instanceof @ruby_unary_minus } or
    TUnaryPlusExpr(Ruby::Unary g) { g instanceof @ruby_unary_plus } or
    TUndefStmt(Ruby::Undef g) or
    TUnlessExpr(Ruby::Unless g) or
    TUnlessModifierExpr(Ruby::UnlessModifier g) or
    TUntilExpr(Ruby::Until g) or
    TUntilModifierExpr(Ruby::UntilModifier g) or
    TVariableReferencePattern(Ruby::VariableReferencePattern g) or
    TExpressionReferencePattern(Ruby::ExpressionReferencePattern g) or
    TWhenClause(Ruby::When g) or
    TWhileExpr(Ruby::While g) or
    TWhileModifierExpr(Ruby::WhileModifier g) or
    TYieldCall(Ruby::Yield g)

  class TReferencePattern = TVariableReferencePattern or TExpressionReferencePattern;

  class TAstNodeReal =
    TAddExprReal or TAliasStmt or TAlternativePattern or TArgumentList or TArrayPattern or
        TAsPattern or TAssignAddExpr or TAssignBitwiseAndExpr or TAssignBitwiseOrExpr or
        TAssignBitwiseXorExpr or TAssignDivExpr or TAssignExponentExpr or TAssignExprReal or
        TAssignLShiftExpr or TAssignLogicalAndExpr or TAssignLogicalOrExpr or TAssignModuloExpr or
        TAssignMulExpr or TAssignRShiftExpr or TAssignSubExpr or TBareStringLiteral or
        TBareSymbolLiteral or TBeginBlock or TBeginExpr or TBitwiseAndExprReal or
        TBitwiseOrExprReal or TBitwiseXorExprReal or TBlockArgument or TBlockParameter or
        TBraceBlockReal or TBreakStmt or TCaseEqExpr or TCaseExpr or TCaseMatch or
        TCharacterLiteral or TClassDeclaration or TClassVariableAccessReal or TComplementExpr or
        TComplexLiteral or TDefinedExpr or TDelimitedSymbolLiteral or TDestructuredLeftAssignment or
        TDestructuredParameter or TDivExprReal or TDo or TDoBlock or TElementReference or TElse or
        TElsif or TEmptyStmt or TEncoding or TEndBlock or TEnsure or TEqExpr or TExponentExprReal or
        TFalseLiteral or TFile or TFindPattern or TFloatLiteral or TForExpr or TForwardParameter or
        TForwardArgument or TGEExpr or TGTExpr or TGlobalVariableAccessReal or
        THashKeySymbolLiteral or THashLiteral or THashPattern or THashSplatExpr or
        THashSplatNilParameter or THashSplatParameter or THereDoc or TIdentifierMethodCall or TIf or
        TIfModifierExpr or TInClause or TInstanceVariableAccessReal or TIntegerLiteralReal or
        TKeywordParameter or TLEExpr or TLShiftExprReal or TLTExpr or TLambda or
        TLeftAssignmentList or TLine or TLocalVariableAccessReal or TLogicalAndExprReal or
        TLogicalOrExprReal or TMethod or TModuleDeclaration or TModuloExprReal or TMulExprReal or
        TNEExpr or TNextStmt or TNilLiteral or TNoRegExpMatchExpr or TNotExpr or
        TOptionalParameter or TPair or TParenthesizedExpr or TParenthesizedPattern or
        TRShiftExprReal or TRangeLiteralReal or TRationalLiteral or TRedoStmt or TRegExpLiteral or
        TRegExpMatchExpr or TRegularArrayLiteral or TRegularMethodCall or TRegularStringLiteral or
        TRegularSuperCall or TRescueClause or TRescueModifierExpr or TRetryStmt or TReturnStmt or
        TScopeResolutionConstantAccess or TScopeResolutionMethodCall or TSelfReal or
        TSimpleParameterReal or TSimpleSymbolLiteral or TSingletonClass or TSingletonMethod or
        TSpaceshipExpr or TSplatExprReal or TSplatParameter or TStringArrayLiteral or
        TStringConcatenation or TStringEscapeSequenceComponent or TStringInterpolationComponent or
        TStringTextComponent or TSubExprReal or TSubshellLiteral or TSymbolArrayLiteral or
        TTernaryIfExpr or TThen or TTokenConstantAccess or TTokenMethodName or TTokenSuperCall or
        TToplevel or TTrueLiteral or TUnaryMinusExpr or TUnaryPlusExpr or TUndefStmt or
        TUnlessExpr or TUnlessModifierExpr or TUntilExpr or TUntilModifierExpr or
        TReferencePattern or TWhenClause or TWhileExpr or TWhileModifierExpr or TYieldCall;

  class TAstNodeSynth =
    TAddExprSynth or TAssignExprSynth or TBitwiseAndExprSynth or TBitwiseOrExprSynth or
        TBitwiseXorExprSynth or TBraceBlockSynth or TClassVariableAccessSynth or
        TConstantReadAccessSynth or TDivExprSynth or TExponentExprSynth or
        TGlobalVariableAccessSynth or TInstanceVariableAccessSynth or TIntegerLiteralSynth or
        TLShiftExprSynth or TLocalVariableAccessSynth or TLogicalAndExprSynth or
        TLogicalOrExprSynth or TMethodCallSynth or TModuloExprSynth or TMulExprSynth or
        TRShiftExprSynth or TRangeLiteralSynth or TSelfSynth or TSimpleParameterSynth or
        TSplatExprSynth or TStmtSequenceSynth or TSubExprSynth;

  /**
   * Gets the underlying TreeSitter entity for a given AST node. This does not
   * include synthesized AST nodes, because they are not the primary AST node
   * for any given generated node.
   */
  cached
  Ruby::AstNode toGenerated(TAstNodeReal n) {
    n = TAddExprReal(result) or
    n = TAliasStmt(result) or
    n = TAlternativePattern(result) or
    n = TArgumentList(result) or
    n = TArrayPattern(result) or
    n = TAsPattern(result) or
    n = TAssignAddExpr(result) or
    n = TAssignBitwiseAndExpr(result) or
    n = TAssignBitwiseOrExpr(result) or
    n = TAssignBitwiseXorExpr(result) or
    n = TAssignDivExpr(result) or
    n = TAssignExponentExpr(result) or
    n = TAssignExprReal(result) or
    n = TAssignLogicalAndExpr(result) or
    n = TAssignLogicalOrExpr(result) or
    n = TAssignLShiftExpr(result) or
    n = TAssignModuloExpr(result) or
    n = TAssignMulExpr(result) or
    n = TAssignRShiftExpr(result) or
    n = TAssignSubExpr(result) or
    n = TBareStringLiteral(result) or
    n = TBareSymbolLiteral(result) or
    n = TBeginBlock(result) or
    n = TBeginExpr(result) or
    n = TBitwiseAndExprReal(result) or
    n = TBitwiseOrExprReal(result) or
    n = TBitwiseXorExprReal(result) or
    n = TBlockArgument(result) or
    n = TBlockParameter(result) or
    n = TBraceBlockReal(result) or
    n = TBreakStmt(result) or
    n = TCaseEqExpr(result) or
    n = TCaseExpr(result) or
    n = TCaseMatch(result) or
    n = TCharacterLiteral(result) or
    n = TClassDeclaration(result) or
    n = TClassVariableAccessReal(result, _) or
    n = TComplementExpr(result) or
    n = TComplexLiteral(result) or
    n = TDefinedExpr(result) or
    n = TDelimitedSymbolLiteral(result) or
    n = TDestructuredLeftAssignment(result) or
    n = TDivExprReal(result) or
    n = TDoBlock(result) or
    n = TDo(result) or
    n = TElementReference(result) or
    n = TElse(result) or
    n = TElsif(result) or
    n = TEmptyStmt(result) or
    n = TEncoding(result) or
    n = TEndBlock(result) or
    n = TEnsure(result) or
    n = TEqExpr(result) or
    n = TExponentExprReal(result) or
    n = TFalseLiteral(result) or
    n = TFile(result) or
    n = TFindPattern(result) or
    n = TFloatLiteral(result) or
    n = TForExpr(result) or
    n = TForwardArgument(result) or
    n = TForwardParameter(result) or
    n = TGEExpr(result) or
    n = TGlobalVariableAccessReal(result, _) or
    n = TGTExpr(result) or
    n = THashKeySymbolLiteral(result) or
    n = THashLiteral(result) or
    n = THashPattern(result) or
    n = THashSplatExpr(result) or
    n = THashSplatNilParameter(result) or
    n = THashSplatParameter(result) or
    n = THereDoc(result) or
    n = TIdentifierMethodCall(result) or
    n = TIfModifierExpr(result) or
    n = TIf(result) or
    n = TInClause(result) or
    n = TInstanceVariableAccessReal(result, _) or
    n = TIntegerLiteralReal(result) or
    n = TKeywordParameter(result) or
    n = TLambda(result) or
    n = TLEExpr(result) or
    n = TLeftAssignmentList(result) or
    n = TLine(result) or
    n = TLocalVariableAccessReal(result, _) or
    n = TLogicalAndExprReal(result) or
    n = TLogicalOrExprReal(result) or
    n = TLShiftExprReal(result) or
    n = TLTExpr(result) or
    n = TMethod(result) or
    n = TModuleDeclaration(result) or
    n = TModuloExprReal(result) or
    n = TMulExprReal(result) or
    n = TNEExpr(result) or
    n = TNextStmt(result) or
    n = TNilLiteral(result) or
    n = TNoRegExpMatchExpr(result) or
    n = TNotExpr(result) or
    n = TOptionalParameter(result) or
    n = TPair(result) or
    n = TParenthesizedExpr(result) or
    n = TParenthesizedPattern(result) or
    n = TRangeLiteralReal(result) or
    n = TRationalLiteral(result) or
    n = TRedoStmt(result) or
    n = TRegExpLiteral(result) or
    n = TRegExpMatchExpr(result) or
    n = TRegularArrayLiteral(result) or
    n = TRegularMethodCall(result) or
    n = TRegularStringLiteral(result) or
    n = TRegularSuperCall(result) or
    n = TRescueClause(result) or
    n = TRescueModifierExpr(result) or
    n = TRetryStmt(result) or
    n = TReturnStmt(result) or
    n = TRShiftExprReal(result) or
    n = TScopeResolutionConstantAccess(result, _) or
    n = TScopeResolutionMethodCall(result, _) or
    n = TSelfReal(result) or
    n = TSimpleParameterReal(result) or
    n = TSimpleSymbolLiteral(result) or
    n = TSingletonClass(result) or
    n = TSingletonMethod(result) or
    n = TSpaceshipExpr(result) or
    n = TSplatExprReal(result) or
    n = TSplatParameter(result) or
    n = TStringArrayLiteral(result) or
    n = TStringConcatenation(result) or
    n = TStringEscapeSequenceComponentNonRegexp(result) or
    n = TStringEscapeSequenceComponentRegexp(result) or
    n = TStringInterpolationComponentNonRegexp(result) or
    n = TStringInterpolationComponentRegexp(result) or
    n = TStringTextComponentNonRegexpStringOrHeredocContent(result) or
    n = TStringTextComponentNonRegexpSimpleSymbol(result) or
    n = TStringTextComponentNonRegexpHashKeySymbol(result) or
    n = TStringTextComponentRegexp(result) or
    n = TSubExprReal(result) or
    n = TSubshellLiteral(result) or
    n = TSymbolArrayLiteral(result) or
    n = TTernaryIfExpr(result) or
    n = TThen(result) or
    n = TTokenConstantAccess(result) or
    n = TTokenMethodName(result) or
    n = TTokenSuperCall(result) or
    n = TToplevel(result) or
    n = TTrueLiteral(result) or
    n = TDestructuredParameter(result) or
    n = TUnaryMinusExpr(result) or
    n = TUnaryPlusExpr(result) or
    n = TUndefStmt(result) or
    n = TUnlessExpr(result) or
    n = TUnlessModifierExpr(result) or
    n = TUntilExpr(result) or
    n = TUntilModifierExpr(result) or
    n = TVariableReferencePattern(result) or
    n = TExpressionReferencePattern(result) or
    n = TWhenClause(result) or
    n = TWhileExpr(result) or
    n = TWhileModifierExpr(result) or
    n = TYieldCall(result)
  }

  /** Gets the `i`th synthesized child of `parent`. */
  cached
  AST::AstNode getSynthChild(AST::AstNode parent, int i) {
    result = TAddExprSynth(parent, i)
    or
    result = TAssignExprSynth(parent, i)
    or
    result = TBitwiseAndExprSynth(parent, i)
    or
    result = TBitwiseOrExprSynth(parent, i)
    or
    result = TBitwiseXorExprSynth(parent, i)
    or
    result = TBraceBlockSynth(parent, i)
    or
    result = TClassVariableAccessSynth(parent, i, _)
    or
    result = TConstantReadAccessSynth(parent, i, _)
    or
    result = TDivExprSynth(parent, i)
    or
    result = TExponentExprSynth(parent, i)
    or
    result = TGlobalVariableAccessSynth(parent, i, _)
    or
    result = TInstanceVariableAccessSynth(parent, i, _)
    or
    result = TIntegerLiteralSynth(parent, i, _)
    or
    result = TLShiftExprSynth(parent, i)
    or
    result = TLocalVariableAccessSynth(parent, i, _)
    or
    result = TLogicalAndExprSynth(parent, i)
    or
    result = TLogicalOrExprSynth(parent, i)
    or
    result = TMethodCallSynth(parent, i, _, _, _)
    or
    result = TModuloExprSynth(parent, i)
    or
    result = TMulExprSynth(parent, i)
    or
    result = TRangeLiteralSynth(parent, i, _)
    or
    result = TRShiftExprSynth(parent, i)
    or
    result = TSelfSynth(parent, i, _)
    or
    result = TSimpleParameterSynth(parent, i)
    or
    result = TSplatExprSynth(parent, i)
    or
    result = TStmtSequenceSynth(parent, i)
    or
    result = TSubExprSynth(parent, i)
  }

  /**
   * Holds if the `i`th child of `parent` is `child`. Either `parent` or
   * `child` (or both) is a synthesized node.
   */
  cached
  predicate synthChild(AST::AstNode parent, int i, AST::AstNode child) {
    child = getSynthChild(parent, i)
    or
    any(Synthesis s).child(parent, i, RealChildRef(child))
    or
    any(Synthesis s).child(parent, i, SynthChildRef(child))
  }

  /**
   * Like `toGenerated`, but also returns generated nodes for synthesized AST
   * nodes.
   */
  cached
  Ruby::AstNode toGeneratedInclSynth(AST::AstNode n) {
    result = toGenerated(n)
    or
    not exists(toGenerated(n)) and
    exists(AST::AstNode parent |
      synthChild(parent, _, n) and
      result = toGeneratedInclSynth(parent)
    )
  }

  cached
  Location getLocation(AST::AstNode n) {
    synthLocation(n, result)
    or
    n.isSynthesized() and
    not synthLocation(n, _) and
    result = getLocation(n.getParent())
    or
    result = toGenerated(n).getLocation()
  }

  cached
  predicate lhsExpr(AST::Expr e) {
    explicitAssignmentNode(toGenerated(e), _)
    or
    implicitAssignmentNode(toGenerated(e))
    or
    e = getSynthChild(any(AST::AssignExpr ae), 0)
  }
}

import Cached

TAstNodeReal fromGenerated(Ruby::AstNode n) { n = toGenerated(result) }

class TCall = TMethodCall or TYieldCall;

class TCase = TCaseExpr or TCaseMatch;

class TMethodCall =
  TMethodCallSynth or TIdentifierMethodCall or TScopeResolutionMethodCall or TRegularMethodCall or
      TElementReference or TSuperCall or TUnaryOperation or TBinaryOperation;

class TSuperCall = TTokenSuperCall or TRegularSuperCall;

class TConstantAccess =
  TTokenConstantAccess or TScopeResolutionConstantAccess or TNamespace or TConstantReadAccessSynth;

class TControlExpr = TConditionalExpr or TCaseExpr or TCaseMatch or TLoop;

class TConditionalExpr =
  TIfExpr or TUnlessExpr or TIfModifierExpr or TUnlessModifierExpr or TTernaryIfExpr;

class TIfExpr = TIf or TElsif;

class TConditionalLoop = TWhileExpr or TUntilExpr or TWhileModifierExpr or TUntilModifierExpr;

class TLoop = TConditionalLoop or TForExpr;

class TSelf = TSelfReal or TSelfSynth;

class TDestructuredLhsExpr = TDestructuredLeftAssignment or TLeftAssignmentList;

class TExpr =
  TSelf or TArgumentList or TRescueClause or TRescueModifierExpr or TPair or TStringConcatenation or
      TCall or TBlockArgument or TConstantAccess or TControlExpr or TLiteral or TCallable or
      TVariableAccess or TStmtSequence or TOperation or TForwardArgument or TDestructuredLhsExpr;

class TSplatExpr = TSplatExprReal or TSplatExprSynth;

class TStmtSequence =
  TBeginBlock or TEndBlock or TThen or TElse or TDo or TEnsure or TStringInterpolationComponent or
      TBlock or TBodyStmt or TParenthesizedExpr or TStmtSequenceSynth;

class TBodyStmt = TBeginExpr or TModuleBase or TMethod or TLambda or TDoBlock or TSingletonMethod;

class TLiteral =
  TEncoding or TFile or TLine or TNumericLiteral or TNilLiteral or TBooleanLiteral or
      TStringlikeLiteral or TCharacterLiteral or TArrayLiteral or THashLiteral or TRangeLiteral or
      TTokenMethodName;

class TNumericLiteral = TIntegerLiteral or TFloatLiteral or TRationalLiteral or TComplexLiteral;

class TIntegerLiteral = TIntegerLiteralReal or TIntegerLiteralSynth;

class TBooleanLiteral = TTrueLiteral or TFalseLiteral;

class TStringTextComponentNonRegexp =
  TStringTextComponentNonRegexpStringOrHeredocContent or
      TStringTextComponentNonRegexpSimpleSymbol or TStringTextComponentNonRegexpHashKeySymbol;

class TStringTextComponent = TStringTextComponentNonRegexp or TStringTextComponentRegexp;

class TStringEscapeSequenceComponent =
  TStringEscapeSequenceComponentNonRegexp or TStringEscapeSequenceComponentRegexp;

class TStringInterpolationComponent =
  TStringInterpolationComponentNonRegexp or TStringInterpolationComponentRegexp;

class TStringComponent =
  TStringTextComponent or TStringEscapeSequenceComponent or TStringInterpolationComponent;

class TStringlikeLiteral =
  TStringLiteral or TRegExpLiteral or TSymbolLiteral or TSubshellLiteral or THereDoc;

class TStringLiteral = TRegularStringLiteral or TBareStringLiteral;

class TSymbolLiteral = TSimpleSymbolLiteral or TComplexSymbolLiteral or THashKeySymbolLiteral;

class TComplexSymbolLiteral = TDelimitedSymbolLiteral or TBareSymbolLiteral;

class TArrayLiteral = TRegularArrayLiteral or TStringArrayLiteral or TSymbolArrayLiteral;

class TCallable = TMethodBase or TLambda or TBlock;

class TMethodBase = TMethod or TSingletonMethod;

class TBraceBlock = TBraceBlockReal or TBraceBlockSynth;

class TBlock = TDoBlock or TBraceBlock;

class TModuleBase = TToplevel or TNamespace or TSingletonClass;

class TNamespace = TClassDeclaration or TModuleDeclaration;

class TOperation = TUnaryOperation or TBinaryOperation or TAssignment;

class TUnaryOperation =
  TUnaryLogicalOperation or TUnaryArithmeticOperation or TUnaryBitwiseOperation or TDefinedExpr or
      TSplatExpr or THashSplatExpr;

class TUnaryLogicalOperation = TNotExpr;

class TUnaryArithmeticOperation = TUnaryPlusExpr or TUnaryMinusExpr;

class TUnaryBitwiseOperation = TComplementExpr;

class TBinaryOperation =
  TBinaryArithmeticOperation or TBinaryLogicalOperation or TBinaryBitwiseOperation or
      TComparisonOperation or TSpaceshipExpr or TRegExpMatchExpr or TNoRegExpMatchExpr;

class TBinaryArithmeticOperation =
  TAddExpr or TSubExpr or TMulExpr or TDivExpr or TModuloExpr or TExponentExpr;

class TAddExpr = TAddExprReal or TAddExprSynth;

class TSubExpr = TSubExprReal or TSubExprSynth;

class TMulExpr = TMulExprReal or TMulExprSynth;

class TDivExpr = TDivExprReal or TDivExprSynth;

class TModuloExpr = TModuloExprReal or TModuloExprSynth;

class TExponentExpr = TExponentExprReal or TExponentExprSynth;

class TBinaryLogicalOperation = TLogicalAndExpr or TLogicalOrExpr;

class TLogicalAndExpr = TLogicalAndExprReal or TLogicalAndExprSynth;

class TLogicalOrExpr = TLogicalOrExprReal or TLogicalOrExprSynth;

class TBinaryBitwiseOperation =
  TLShiftExpr or TRShiftExpr or TBitwiseAndExpr or TBitwiseOrExpr or TBitwiseXorExpr;

class TLShiftExpr = TLShiftExprReal or TLShiftExprSynth;

class TRangeLiteral = TRangeLiteralReal or TRangeLiteralSynth;

class TRShiftExpr = TRShiftExprReal or TRShiftExprSynth;

class TBitwiseAndExpr = TBitwiseAndExprReal or TBitwiseAndExprSynth;

class TBitwiseOrExpr = TBitwiseOrExprReal or TBitwiseOrExprSynth;

class TBitwiseXorExpr = TBitwiseXorExprReal or TBitwiseXorExprSynth;

class TComparisonOperation = TEqualityOperation or TRelationalOperation;

class TEqualityOperation = TEqExpr or TNEExpr or TCaseEqExpr;

class TRelationalOperation = TGTExpr or TGEExpr or TLTExpr or TLEExpr;

class TAssignExpr = TAssignExprReal or TAssignExprSynth;

class TAssignment = TAssignExpr or TAssignOperation;

class TAssignOperation =
  TAssignArithmeticOperation or TAssignLogicalOperation or TAssignBitwiseOperation;

class TAssignArithmeticOperation =
  TAssignAddExpr or TAssignSubExpr or TAssignMulExpr or TAssignDivExpr or TAssignModuloExpr or
      TAssignExponentExpr;

class TAssignLogicalOperation = TAssignLogicalAndExpr or TAssignLogicalOrExpr;

class TAssignBitwiseOperation =
  TAssignLShiftExpr or TAssignRShiftExpr or TAssignBitwiseAndExpr or TAssignBitwiseOrExpr or
      TAssignBitwiseXorExpr;

class TStmt =
  TEmptyStmt or TBodyStmt or TStmtSequence or TUndefStmt or TAliasStmt or TReturningStmt or
      TRedoStmt or TRetryStmt or TExpr;

class TReturningStmt = TReturnStmt or TBreakStmt or TNextStmt;

class TParameter =
  TSimpleParameter or TDestructuredParameter or TBlockParameter or THashSplatParameter or
      THashSplatNilParameter or TKeywordParameter or TOptionalParameter or TSplatParameter or
      TForwardParameter;

class TSimpleParameter = TSimpleParameterReal or TSimpleParameterSynth;

deprecated class TPatternParameter = TSimpleParameter or TDestructuredParameter;

class TNamedParameter =
  TSimpleParameter or TBlockParameter or THashSplatParameter or TKeywordParameter or
      TOptionalParameter or TSplatParameter;

deprecated class TTuplePattern =
  TDestructuredParameter or TDestructuredLeftAssignment or TLeftAssignmentList;

class TVariableAccess =
  TLocalVariableAccess or TGlobalVariableAccess or TInstanceVariableAccess or
      TClassVariableAccess or TSelfVariableAccess;

class TLocalVariableAccess =
  TLocalVariableAccessReal or TLocalVariableAccessSynth or TSelfVariableAccess;

class TGlobalVariableAccess = TGlobalVariableAccessReal or TGlobalVariableAccessSynth;

class TInstanceVariableAccess = TInstanceVariableAccessReal or TInstanceVariableAccessSynth;

class TClassVariableAccess = TClassVariableAccessReal or TClassVariableAccessSynth;

class TSelfVariableAccess = TSelfReal or TSelfSynth;
