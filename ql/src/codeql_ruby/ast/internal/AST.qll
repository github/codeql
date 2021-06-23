import codeql.Locations
private import TreeSitter
private import codeql_ruby.ast.internal.Call
private import codeql_ruby.ast.internal.Parameter
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.AST as AST
private import Synthesis

module MethodName {
  predicate range(Generated::UnderscoreMethodName g) {
    exists(Generated::Undef u | u.getChild(_) = g)
    or
    exists(Generated::Alias a | a.getName() = g or a.getAlias() = g)
  }

  class Token =
    @setter or @token_class_variable or @token_constant or @token_global_variable or
        @token_identifier or @token_instance_variable or @token_operator;
}

private predicate mkSynthChild(SynthKind kind, AST::AstNode parent, int i) {
  any(Synthesis s).child(parent, i, SynthChild(kind))
}

cached
private module Cached {
  cached
  newtype TAstNode =
    TAddExprReal(Generated::Binary g) { g instanceof @binary_plus } or
    TAddExprSynth(AST::AstNode parent, int i) { mkSynthChild(AddExprKind(), parent, i) } or
    TAliasStmt(Generated::Alias g) or
    TArgumentList(Generated::AstNode g) {
      (
        g.getParent() instanceof Generated::Break or
        g.getParent() instanceof Generated::Return or
        g.getParent() instanceof Generated::Next or
        g.getParent() instanceof Generated::Assignment or
        g.getParent() instanceof Generated::OperatorAssignment
      ) and
      (
        strictcount(g.(Generated::ArgumentList).getChild(_)) > 1
        or
        g instanceof Generated::RightAssignmentList
      )
    } or
    TAssignAddExpr(Generated::OperatorAssignment g) { g instanceof @operator_assignment_plusequal } or
    TAssignBitwiseAndExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_ampersandequal
    } or
    TAssignBitwiseOrExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_pipeequal
    } or
    TAssignBitwiseXorExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_caretequal
    } or
    TAssignDivExpr(Generated::OperatorAssignment g) { g instanceof @operator_assignment_slashequal } or
    TAssignExponentExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_starstarequal
    } or
    TAssignExprReal(Generated::Assignment g) or
    TAssignExprSynth(AST::AstNode parent, int i) { mkSynthChild(AssignExprKind(), parent, i) } or
    TAssignLShiftExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_langlelangleequal
    } or
    TAssignLogicalAndExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_ampersandampersandequal
    } or
    TAssignLogicalOrExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_pipepipeequal
    } or
    TAssignModuloExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_percentequal
    } or
    TAssignMulExpr(Generated::OperatorAssignment g) { g instanceof @operator_assignment_starequal } or
    TAssignRShiftExpr(Generated::OperatorAssignment g) {
      g instanceof @operator_assignment_ranglerangleequal
    } or
    TAssignSubExpr(Generated::OperatorAssignment g) { g instanceof @operator_assignment_minusequal } or
    TBareStringLiteral(Generated::BareString g) or
    TBareSymbolLiteral(Generated::BareSymbol g) or
    TBeginBlock(Generated::BeginBlock g) or
    TBeginExpr(Generated::Begin g) or
    TBitwiseAndExprReal(Generated::Binary g) { g instanceof @binary_ampersand } or
    TBitwiseAndExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(BitwiseAndExprKind(), parent, i)
    } or
    TBitwiseOrExprReal(Generated::Binary g) { g instanceof @binary_pipe } or
    TBitwiseOrExprSynth(AST::AstNode parent, int i) { mkSynthChild(BitwiseOrExprKind(), parent, i) } or
    TBitwiseXorExprReal(Generated::Binary g) { g instanceof @binary_caret } or
    TBitwiseXorExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(BitwiseXorExprKind(), parent, i)
    } or
    TBlockArgument(Generated::BlockArgument g) or
    TBlockParameter(Generated::BlockParameter g) or
    TBraceBlock(Generated::Block g) { not g.getParent() instanceof Generated::Lambda } or
    TBreakStmt(Generated::Break g) or
    TCaseEqExpr(Generated::Binary g) { g instanceof @binary_equalequalequal } or
    TCaseExpr(Generated::Case g) or
    TCharacterLiteral(Generated::Character g) or
    TClassDeclaration(Generated::Class g) or
    TClassVariableAccessReal(Generated::ClassVariable g, AST::ClassVariable v) {
      ClassVariableAccess::range(g, v)
    } or
    TClassVariableAccessSynth(AST::AstNode parent, int i, AST::ClassVariable v) {
      mkSynthChild(ClassVariableAccessKind(v), parent, i)
    } or
    TComplementExpr(Generated::Unary g) { g instanceof @unary_tilde } or
    TComplexLiteral(Generated::Complex g) or
    TDefinedExpr(Generated::Unary g) { g instanceof @unary_definedquestion } or
    TDelimitedSymbolLiteral(Generated::DelimitedSymbol g) or
    TDestructuredLeftAssignment(Generated::DestructuredLeftAssignment g) {
      not strictcount(int i | exists(g.getParent().(Generated::LeftAssignmentList).getChild(i))) = 1
    } or
    TDivExprReal(Generated::Binary g) { g instanceof @binary_slash } or
    TDivExprSynth(AST::AstNode parent, int i) { mkSynthChild(DivExprKind(), parent, i) } or
    TDo(Generated::Do g) or
    TDoBlock(Generated::DoBlock g) { not g.getParent() instanceof Generated::Lambda } or
    TElementReference(Generated::ElementReference g) or
    TElse(Generated::Else g) or
    TElsif(Generated::Elsif g) or
    TEmptyStmt(Generated::EmptyStatement g) or
    TEndBlock(Generated::EndBlock g) or
    TEnsure(Generated::Ensure g) or
    TEqExpr(Generated::Binary g) { g instanceof @binary_equalequal } or
    TExponentExprReal(Generated::Binary g) { g instanceof @binary_starstar } or
    TExponentExprSynth(AST::AstNode parent, int i) { mkSynthChild(ExponentExprKind(), parent, i) } or
    TFalseLiteral(Generated::False g) or
    TFloatLiteral(Generated::Float g) { not any(Generated::Rational r).getChild() = g } or
    TForExpr(Generated::For g) or
    TForIn(Generated::In g) or // TODO REMOVE
    TGEExpr(Generated::Binary g) { g instanceof @binary_rangleequal } or
    TGTExpr(Generated::Binary g) { g instanceof @binary_rangle } or
    TGlobalVariableAccessReal(Generated::GlobalVariable g, AST::GlobalVariable v) {
      GlobalVariableAccess::range(g, v)
    } or
    TGlobalVariableAccessSynth(AST::AstNode parent, int i, AST::GlobalVariable v) {
      mkSynthChild(GlobalVariableAccessKind(v), parent, i)
    } or
    THashKeySymbolLiteral(Generated::HashKeySymbol g) or
    THashLiteral(Generated::Hash g) or
    THashSplatExpr(Generated::HashSplatArgument g) or
    THashSplatParameter(Generated::HashSplatParameter g) or
    THereDoc(Generated::HeredocBeginning g) or
    TIdentifierMethodCall(Generated::Identifier g) { isIdentifierMethodCall(g) } or
    TIf(Generated::If g) or
    TIfModifierExpr(Generated::IfModifier g) or
    TInstanceVariableAccessReal(Generated::InstanceVariable g, AST::InstanceVariable v) {
      InstanceVariableAccess::range(g, v)
    } or
    TInstanceVariableAccessSynth(AST::AstNode parent, int i, AST::InstanceVariable v) {
      mkSynthChild(InstanceVariableAccessKind(v), parent, i)
    } or
    TIntegerLiteralReal(Generated::Integer g) { not any(Generated::Rational r).getChild() = g } or
    TIntegerLiteralSynth(AST::AstNode parent, int i, int value) {
      mkSynthChild(IntegerLiteralKind(value), parent, i)
    } or
    TKeywordParameter(Generated::KeywordParameter g) or
    TLEExpr(Generated::Binary g) { g instanceof @binary_langleequal } or
    TLShiftExprReal(Generated::Binary g) { g instanceof @binary_langlelangle } or
    TLShiftExprSynth(AST::AstNode parent, int i) { mkSynthChild(LShiftExprKind(), parent, i) } or
    TLTExpr(Generated::Binary g) { g instanceof @binary_langle } or
    TLambda(Generated::Lambda g) or
    TLeftAssignmentList(Generated::LeftAssignmentList g) or
    TLocalVariableAccessReal(Generated::Identifier g, AST::LocalVariable v) {
      LocalVariableAccess::range(g, v)
    } or
    TLocalVariableAccessSynth(AST::AstNode parent, int i, AST::LocalVariable v) {
      mkSynthChild(LocalVariableAccessRealKind(v), parent, i)
      or
      mkSynthChild(LocalVariableAccessSynthKind(v), parent, i)
    } or
    TLogicalAndExprReal(Generated::Binary g) {
      g instanceof @binary_and or g instanceof @binary_ampersandampersand
    } or
    TLogicalAndExprSynth(AST::AstNode parent, int i) {
      mkSynthChild(LogicalAndExprKind(), parent, i)
    } or
    TLogicalOrExprReal(Generated::Binary g) {
      g instanceof @binary_or or g instanceof @binary_pipepipe
    } or
    TLogicalOrExprSynth(AST::AstNode parent, int i) { mkSynthChild(LogicalOrExprKind(), parent, i) } or
    TMethod(Generated::Method g) or
    TMethodCallSynth(AST::AstNode parent, int i, string name, boolean setter, int arity) {
      mkSynthChild(MethodCallKind(name, setter, arity), parent, i)
    } or
    TModuleDeclaration(Generated::Module g) or
    TModuloExprReal(Generated::Binary g) { g instanceof @binary_percent } or
    TModuloExprSynth(AST::AstNode parent, int i) { mkSynthChild(ModuloExprKind(), parent, i) } or
    TMulExprReal(Generated::Binary g) { g instanceof @binary_star } or
    TMulExprSynth(AST::AstNode parent, int i) { mkSynthChild(MulExprKind(), parent, i) } or
    TNEExpr(Generated::Binary g) { g instanceof @binary_bangequal } or
    TNextStmt(Generated::Next g) or
    TNilLiteral(Generated::Nil g) or
    TNoRegExpMatchExpr(Generated::Binary g) { g instanceof @binary_bangtilde } or
    TNotExpr(Generated::Unary g) { g instanceof @unary_bang or g instanceof @unary_not } or
    TOptionalParameter(Generated::OptionalParameter g) or
    TPair(Generated::Pair g) or
    TParenthesizedExpr(Generated::ParenthesizedStatements g) or
    TRShiftExprReal(Generated::Binary g) { g instanceof @binary_ranglerangle } or
    TRShiftExprSynth(AST::AstNode parent, int i) { mkSynthChild(RShiftExprKind(), parent, i) } or
    TRangeLiteralReal(Generated::Range g) or
    TRangeLiteralSynth(AST::AstNode parent, int i, boolean inclusive) {
      mkSynthChild(RangeLiteralKind(inclusive), parent, i)
    } or
    TRationalLiteral(Generated::Rational g) or
    TRedoStmt(Generated::Redo g) or
    TRegExpLiteral(Generated::Regex g) or
    TRegExpMatchExpr(Generated::Binary g) { g instanceof @binary_equaltilde } or
    TRegularArrayLiteral(Generated::Array g) or
    TRegularMethodCall(Generated::Call g) { isRegularMethodCall(g) } or
    TRegularStringLiteral(Generated::String g) or
    TRegularSuperCall(Generated::Call g) { g.getMethod() instanceof Generated::Super } or
    TRescueClause(Generated::Rescue g) or
    TRescueModifierExpr(Generated::RescueModifier g) or
    TRetryStmt(Generated::Retry g) or
    TReturnStmt(Generated::Return g) or
    TScopeResolutionConstantAccess(Generated::ScopeResolution g, Generated::Constant constant) {
      constant = g.getName() and
      (
        // A tree-sitter `scope_resolution` node with a `constant` name field is a
        // read of that constant in any context where an identifier would be a
        // vcall.
        vcall(g)
        or
        explicitAssignmentNode(g, _)
      )
    } or
    TScopeResolutionMethodCall(Generated::ScopeResolution g, Generated::Identifier i) {
      isScopeResolutionMethodCall(g, i)
    } or
    TSelfReal(Generated::Self g) or
    TSelfSynth(AST::AstNode parent, int i) { mkSynthChild(SelfKind(), parent, i) } or
    TSimpleParameter(Generated::Identifier g) { g instanceof Parameter::Range } or
    TSimpleSymbolLiteral(Generated::SimpleSymbol g) or
    TSingletonClass(Generated::SingletonClass g) or
    TSingletonMethod(Generated::SingletonMethod g) or
    TSpaceshipExpr(Generated::Binary g) { g instanceof @binary_langleequalrangle } or
    TSplatExprReal(Generated::SplatArgument g) or
    TSplatExprSynth(AST::AstNode parent, int i) { mkSynthChild(SplatExprKind(), parent, i) } or
    TSplatParameter(Generated::SplatParameter g) or
    TStmtSequenceSynth(AST::AstNode parent, int i) { mkSynthChild(StmtSequenceKind(), parent, i) } or
    TStringArrayLiteral(Generated::StringArray g) or
    TStringConcatenation(Generated::ChainedString g) or
    TStringEscapeSequenceComponent(Generated::EscapeSequence g) or
    TStringInterpolationComponent(Generated::Interpolation g) or
    TStringTextComponent(Generated::Token g) {
      g instanceof Generated::StringContent or g instanceof Generated::HeredocContent
    } or
    TSubExprReal(Generated::Binary g) { g instanceof @binary_minus } or
    TSubExprSynth(AST::AstNode parent, int i) { mkSynthChild(SubExprKind(), parent, i) } or
    TSubshellLiteral(Generated::Subshell g) or
    TSymbolArrayLiteral(Generated::SymbolArray g) or
    TTernaryIfExpr(Generated::Conditional g) or
    TThen(Generated::Then g) or
    TTokenConstantAccess(Generated::Constant g) {
      // A tree-sitter `constant` token is a read of that constant in any context
      // where an identifier would be a vcall.
      vcall(g)
      or
      explicitAssignmentNode(g, _)
    } or
    TTokenMethodName(MethodName::Token g) { MethodName::range(g) } or
    TTokenSuperCall(Generated::Super g) { vcall(g) } or
    TToplevel(Generated::Program g) { g.getLocation().getFile().getExtension() != "erb" } or
    TTrueLiteral(Generated::True g) or
    TTuplePatternParameter(Generated::DestructuredParameter g) or
    TUnaryMinusExpr(Generated::Unary g) { g instanceof @unary_minus } or
    TUnaryPlusExpr(Generated::Unary g) { g instanceof @unary_plus } or
    TUndefStmt(Generated::Undef g) or
    TUnlessExpr(Generated::Unless g) or
    TUnlessModifierExpr(Generated::UnlessModifier g) or
    TUntilExpr(Generated::Until g) or
    TUntilModifierExpr(Generated::UntilModifier g) or
    TWhenExpr(Generated::When g) or
    TWhileExpr(Generated::While g) or
    TWhileModifierExpr(Generated::WhileModifier g) or
    TYieldCall(Generated::Yield g)

  /**
   * Gets the underlying TreeSitter entity for a given AST node. This does not
   * include synthesized AST nodes, because they are not the primary AST node
   * for any given generated node.
   */
  cached
  Generated::AstNode toGenerated(AST::AstNode n) {
    n = TAddExprReal(result) or
    n = TAliasStmt(result) or
    n = TArgumentList(result) or
    n = TAssignAddExpr(result) or
    n = TAssignBitwiseAndExpr(result) or
    n = TAssignBitwiseOrExpr(result) or
    n = TAssignBitwiseXorExpr(result) or
    n = TAssignDivExpr(result) or
    n = TAssignExponentExpr(result) or
    n = TAssignExprReal(result) or
    n = TAssignLShiftExpr(result) or
    n = TAssignLogicalAndExpr(result) or
    n = TAssignLogicalOrExpr(result) or
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
    n = TBraceBlock(result) or
    n = TBreakStmt(result) or
    n = TCaseEqExpr(result) or
    n = TCaseExpr(result) or
    n = TCharacterLiteral(result) or
    n = TClassDeclaration(result) or
    n = TClassVariableAccessReal(result, _) or
    n = TComplementExpr(result) or
    n = TComplexLiteral(result) or
    n = TDefinedExpr(result) or
    n = TDelimitedSymbolLiteral(result) or
    n = TDestructuredLeftAssignment(result) or
    n = TDivExprReal(result) or
    n = TDo(result) or
    n = TDoBlock(result) or
    n = TElementReference(result) or
    n = TElse(result) or
    n = TElsif(result) or
    n = TEmptyStmt(result) or
    n = TEndBlock(result) or
    n = TEnsure(result) or
    n = TEqExpr(result) or
    n = TExponentExprReal(result) or
    n = TFalseLiteral(result) or
    n = TFloatLiteral(result) or
    n = TForExpr(result) or
    n = TForIn(result) or // TODO REMOVE
    n = TGEExpr(result) or
    n = TGTExpr(result) or
    n = TGlobalVariableAccessReal(result, _) or
    n = THashKeySymbolLiteral(result) or
    n = THashLiteral(result) or
    n = THashSplatExpr(result) or
    n = THashSplatParameter(result) or
    n = THereDoc(result) or
    n = TIdentifierMethodCall(result) or
    n = TIf(result) or
    n = TIfModifierExpr(result) or
    n = TInstanceVariableAccessReal(result, _) or
    n = TIntegerLiteralReal(result) or
    n = TKeywordParameter(result) or
    n = TLEExpr(result) or
    n = TLShiftExprReal(result) or
    n = TLTExpr(result) or
    n = TLambda(result) or
    n = TLeftAssignmentList(result) or
    n = TLocalVariableAccessReal(result, _) or
    n = TLogicalAndExprReal(result) or
    n = TLogicalOrExprReal(result) or
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
    n = TRShiftExprReal(result) or
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
    n = TScopeResolutionConstantAccess(result, _) or
    n = TScopeResolutionMethodCall(result, _) or
    n = TSelfReal(result) or
    n = TSimpleParameter(result) or
    n = TSimpleSymbolLiteral(result) or
    n = TSingletonClass(result) or
    n = TSingletonMethod(result) or
    n = TSpaceshipExpr(result) or
    n = TSplatExprReal(result) or
    n = TSplatParameter(result) or
    n = TStringArrayLiteral(result) or
    n = TStringConcatenation(result) or
    n = TStringEscapeSequenceComponent(result) or
    n = TStringInterpolationComponent(result) or
    n = TStringTextComponent(result) or
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
    n = TTuplePatternParameter(result) or
    n = TUnaryMinusExpr(result) or
    n = TUnaryPlusExpr(result) or
    n = TUndefStmt(result) or
    n = TUnlessExpr(result) or
    n = TUnlessModifierExpr(result) or
    n = TUntilExpr(result) or
    n = TUntilModifierExpr(result) or
    n = TWhenExpr(result) or
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
    result = TClassVariableAccessSynth(parent, i, _)
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
    result = TSelfSynth(parent, i)
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
    any(Synthesis s).child(parent, i, RealChild(child))
  }

  /**
   * Like `toGenerated`, but also returns generated nodes for synthesized AST
   * nodes.
   */
  cached
  Generated::AstNode toGeneratedInclSynth(AST::AstNode n) {
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
}

import Cached

TAstNode fromGenerated(Generated::AstNode n) { n = toGenerated(result) }

class TCall = TMethodCall or TYieldCall;

class TMethodCall =
  TMethodCallSynth or TIdentifierMethodCall or TScopeResolutionMethodCall or TRegularMethodCall or
      TElementReference or TSuperCall;

class TSuperCall = TTokenSuperCall or TRegularSuperCall;

class TConstantAccess = TTokenConstantAccess or TScopeResolutionConstantAccess or TNamespace;

class TControlExpr = TConditionalExpr or TCaseExpr or TLoop;

class TConditionalExpr =
  TIfExpr or TUnlessExpr or TIfModifierExpr or TUnlessModifierExpr or TTernaryIfExpr;

class TIfExpr = TIf or TElsif;

class TConditionalLoop = TWhileExpr or TUntilExpr or TWhileModifierExpr or TUntilModifierExpr;

class TLoop = TConditionalLoop or TForExpr;

class TSelf = TSelfReal or TSelfSynth;

class TExpr =
  TSelf or TArgumentList or TRescueClause or TRescueModifierExpr or TPair or TStringConcatenation or
      TCall or TBlockArgument or TConstantAccess or TControlExpr or TWhenExpr or TLiteral or
      TCallable or TVariableAccess or TStmtSequence or TOperation or TSimpleParameter;

class TSplatExpr = TSplatExprReal or TSplatExprSynth;

class TStmtSequence =
  TBeginBlock or TEndBlock or TThen or TElse or TDo or TEnsure or TStringInterpolationComponent or
      TBlock or TBodyStmt or TParenthesizedExpr or TStmtSequenceSynth;

class TBodyStmt = TBeginExpr or TModuleBase or TMethod or TLambda or TDoBlock or TSingletonMethod;

class TLiteral =
  TNumericLiteral or TNilLiteral or TBooleanLiteral or TStringlikeLiteral or TCharacterLiteral or
      TArrayLiteral or THashLiteral or TRangeLiteral or TTokenMethodName;

class TNumericLiteral = TIntegerLiteral or TFloatLiteral or TRationalLiteral or TComplexLiteral;

class TIntegerLiteral = TIntegerLiteralReal or TIntegerLiteralSynth;

class TBooleanLiteral = TTrueLiteral or TFalseLiteral;

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
  TPatternParameter or TBlockParameter or THashSplatParameter or TKeywordParameter or
      TOptionalParameter or TSplatParameter;

class TPatternParameter = TSimpleParameter or TTuplePatternParameter;

class TNamedParameter =
  TSimpleParameter or TBlockParameter or THashSplatParameter or TKeywordParameter or
      TOptionalParameter or TSplatParameter;

class TTuplePattern = TTuplePatternParameter or TDestructuredLeftAssignment or TLeftAssignmentList;

class TVariableAccess =
  TLocalVariableAccess or TGlobalVariableAccess or TInstanceVariableAccess or TClassVariableAccess;

class TLocalVariableAccess = TLocalVariableAccessReal or TLocalVariableAccessSynth;

class TGlobalVariableAccess = TGlobalVariableAccessReal or TGlobalVariableAccessSynth;

class TInstanceVariableAccess = TInstanceVariableAccessReal or TInstanceVariableAccessSynth;

class TClassVariableAccess = TClassVariableAccessReal or TClassVariableAccessSynth;
