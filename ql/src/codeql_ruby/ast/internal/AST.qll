import codeql.Locations
private import TreeSitter
private import codeql_ruby.ast.internal.Parameter
private import codeql_ruby.ast.internal.Variable
private import codeql_ruby.AST as AST

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

cached
private module Cached {
  cached
  newtype TAstNode =
    TAddExpr(Generated::Binary g) { g instanceof @binary_plus } or
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
    TAssignExpr(Generated::Assignment g) or
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
    TBitwiseAndExpr(Generated::Binary g) { g instanceof @binary_ampersand } or
    TBitwiseOrExpr(Generated::Binary g) { g instanceof @binary_pipe } or
    TBitwiseXorExpr(Generated::Binary g) { g instanceof @binary_caret } or
    TBlockArgument(Generated::BlockArgument g) or
    TBlockParameter(Generated::BlockParameter g) or
    TBraceBlock(Generated::Block g) { not g.getParent() instanceof Generated::Lambda } or
    TBreakStmt(Generated::Break g) or
    TCaseEqExpr(Generated::Binary g) { g instanceof @binary_equalequalequal } or
    TCaseExpr(Generated::Case g) or
    TCharacterLiteral(Generated::Character g) or
    TClass(Generated::Class g) or
    TClassVariableAccess(Generated::ClassVariable g, AST::ClassVariable v) {
      ClassVariableAccess::range(g, v)
    } or
    TComplementExpr(Generated::Unary g) { g instanceof @unary_tilde } or
    TComplexLiteral(Generated::Complex g) or
    TDefinedExpr(Generated::Unary g) { g instanceof @unary_definedquestion } or
    TDelimitedSymbolLiteral(Generated::DelimitedSymbol g) or
    TDestructuredLeftAssignment(Generated::DestructuredLeftAssignment g) or
    TDivExpr(Generated::Binary g) { g instanceof @binary_slash } or
    TDo(Generated::Do g) or
    TDoBlock(Generated::DoBlock g) { not g.getParent() instanceof Generated::Lambda } or
    TElementReference(Generated::ElementReference g) or
    TElse(Generated::Else g) or
    TElsif(Generated::Elsif g) or
    TEmptyStmt(Generated::EmptyStatement g) or
    TEndBlock(Generated::EndBlock g) or
    TEnsure(Generated::Ensure g) or
    TEqExpr(Generated::Binary g) { g instanceof @binary_equalequal } or
    TExponentExpr(Generated::Binary g) { g instanceof @binary_starstar } or
    TFalseLiteral(Generated::False g) or
    TFloatLiteral(Generated::Float g) { not any(Generated::Rational r).getChild() = g } or
    TForExpr(Generated::For g) or
    TForIn(Generated::In g) or // TODO REMOVE
    TGEExpr(Generated::Binary g) { g instanceof @binary_rangleequal } or
    TGTExpr(Generated::Binary g) { g instanceof @binary_rangle } or
    TGlobalVariableAccess(Generated::GlobalVariable g, AST::GlobalVariable v) {
      GlobalVariableAccess::range(g, v)
    } or
    THashKeySymbolLiteral(Generated::HashKeySymbol g) or
    THashLiteral(Generated::Hash g) or
    THashSplatArgument(Generated::HashSplatArgument g) or
    THashSplatParameter(Generated::HashSplatParameter g) or
    THereDoc(Generated::HeredocBeginning g) or
    TIdentifierMethodCall(Generated::Identifier g) { vcall(g) and not access(g, _) } or
    TIf(Generated::If g) or
    TIfModifierExpr(Generated::IfModifier g) or
    TInstanceVariableAccess(Generated::InstanceVariable g, AST::InstanceVariable v) {
      InstanceVariableAccess::range(g, v)
    } or
    TIntegerLiteral(Generated::Integer g) { not any(Generated::Rational r).getChild() = g } or
    TKeywordParameter(Generated::KeywordParameter g) or
    TLEExpr(Generated::Binary g) { g instanceof @binary_langleequal } or
    TLShiftExpr(Generated::Binary g) { g instanceof @binary_langlelangle } or
    TLTExpr(Generated::Binary g) { g instanceof @binary_langle } or
    TLambda(Generated::Lambda g) or
    TLeftAssignmentList(Generated::LeftAssignmentList g) or
    TLocalVariableAccess(Generated::Identifier g, AST::LocalVariable v) {
      LocalVariableAccess::range(g, v)
    } or
    TLogicalAndExpr(Generated::Binary g) {
      g instanceof @binary_and or g instanceof @binary_ampersandampersand
    } or
    TLogicalOrExpr(Generated::Binary g) { g instanceof @binary_or or g instanceof @binary_pipepipe } or
    TMethod(Generated::Method g) or
    TModule(Generated::Module g) or
    TModuloExpr(Generated::Binary g) { g instanceof @binary_percent } or
    TMulExpr(Generated::Binary g) { g instanceof @binary_star } or
    TNEExpr(Generated::Binary g) { g instanceof @binary_bangequal } or
    TNextStmt(Generated::Next g) or
    TNilLiteral(Generated::Nil g) or
    TNoRegexMatchExpr(Generated::Binary g) { g instanceof @binary_bangtilde } or
    TNotExpr(Generated::Unary g) { g instanceof @unary_bang or g instanceof @unary_not } or
    TOptionalParameter(Generated::OptionalParameter g) or
    TPair(Generated::Pair g) or
    TParenthesizedExpr(Generated::ParenthesizedStatements g) or
    TRShiftExpr(Generated::Binary g) { g instanceof @binary_ranglerangle } or
    TRangeLiteral(Generated::Range g) or
    TRationalLiteral(Generated::Rational g) or
    TRedoStmt(Generated::Redo g) or
    TRegexLiteral(Generated::Regex g) or
    TRegexMatchExpr(Generated::Binary g) { g instanceof @binary_equaltilde } or
    TRegularArrayLiteral(Generated::Array g) or
    TRegularMethodCall(Generated::Call g) { not g.getMethod() instanceof Generated::Super } or
    TRegularStringLiteral(Generated::String g) or
    TRegularSuperCall(Generated::Call g) { g.getMethod() instanceof Generated::Super } or
    TRescueClause(Generated::Rescue g) or
    TRescueModifierExpr(Generated::RescueModifier g) or
    TRetryStmt(Generated::Retry g) or
    TReturnStmt(Generated::Return g) or
    TScopeResolutionConstantReadAccess(Generated::ScopeResolution g, Generated::Constant constant) {
      // A tree-sitter `scope_resolution` node with a `constant` name field is a
      // read of that constant in any context where an identifier would be a
      // vcall.
      constant = g.getName() and
      vcall(g)
    } or
    TScopeResolutionConstantWriteAccess(Generated::ScopeResolution g, Generated::Constant constant) {
      explicitAssignmentNode(g, _) and constant = g.getName()
    } or
    TScopeResolutionMethodCall(Generated::ScopeResolution g, Generated::Identifier i) {
      i = g.getName() and
      not exists(Generated::Call c | c.getMethod() = g)
    } or
    TSelf(Generated::Self g) or
    TSimpleParameter(Generated::Identifier g) { g instanceof Parameter::Range } or
    TSimpleSymbolLiteral(Generated::SimpleSymbol g) or
    TSingletonClass(Generated::SingletonClass g) or
    TSingletonMethod(Generated::SingletonMethod g) or
    TSpaceshipExpr(Generated::Binary g) { g instanceof @binary_langleequalrangle } or
    TSplatArgument(Generated::SplatArgument g) or
    TSplatParameter(Generated::SplatParameter g) or
    TStringArrayLiteral(Generated::StringArray g) or
    TStringConcatenation(Generated::ChainedString g) or
    TStringEscapeSequenceComponent(Generated::EscapeSequence g) or
    TStringInterpolationComponent(Generated::Interpolation g) or
    TStringTextComponent(Generated::Token g) {
      g instanceof Generated::StringContent or g instanceof Generated::HeredocContent
    } or
    TSubExpr(Generated::Binary g) { g instanceof @binary_minus } or
    TSubshellLiteral(Generated::Subshell g) or
    TSymbolArrayLiteral(Generated::SymbolArray g) or
    TTernaryIfExpr(Generated::Conditional g) or
    TThen(Generated::Then g) or
    TTokenConstantReadAccess(Generated::Constant g) {
      // A tree-sitter `constant` token is a read of that constant in any context
      // where an identifier would be a vcall.
      vcall(g)
    } or
    TTokenConstantWriteAccess(Generated::Constant g) { explicitAssignmentNode(g, _) } or
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

  /** Gets the underlying TreeSitter entity for a given AST node. */
  cached
  Generated::AstNode toTreeSitter(AST::AstNode n) {
    n = TAddExpr(result) or
    n = TAliasStmt(result) or
    n = TArgumentList(result) or
    n = TAssignAddExpr(result) or
    n = TAssignBitwiseAndExpr(result) or
    n = TAssignBitwiseOrExpr(result) or
    n = TAssignBitwiseXorExpr(result) or
    n = TAssignDivExpr(result) or
    n = TAssignExponentExpr(result) or
    n = TAssignExpr(result) or
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
    n = TBitwiseAndExpr(result) or
    n = TBitwiseOrExpr(result) or
    n = TBitwiseXorExpr(result) or
    n = TBlockArgument(result) or
    n = TBlockParameter(result) or
    n = TBraceBlock(result) or
    n = TBreakStmt(result) or
    n = TCaseEqExpr(result) or
    n = TCaseExpr(result) or
    n = TCharacterLiteral(result) or
    n = TClass(result) or
    n = TClassVariableAccess(result, _) or
    n = TComplementExpr(result) or
    n = TComplexLiteral(result) or
    n = TDefinedExpr(result) or
    n = TDelimitedSymbolLiteral(result) or
    n = TDestructuredLeftAssignment(result) or
    n = TDivExpr(result) or
    n = TDo(result) or
    n = TDoBlock(result) or
    n = TElementReference(result) or
    n = TElse(result) or
    n = TElsif(result) or
    n = TEmptyStmt(result) or
    n = TEndBlock(result) or
    n = TEnsure(result) or
    n = TEqExpr(result) or
    n = TExponentExpr(result) or
    n = TFalseLiteral(result) or
    n = TFloatLiteral(result) or
    n = TForExpr(result) or
    n = TForIn(result) or // TODO REMOVE
    n = TGEExpr(result) or
    n = TGTExpr(result) or
    n = TGlobalVariableAccess(result, _) or
    n = THashKeySymbolLiteral(result) or
    n = THashLiteral(result) or
    n = THashSplatArgument(result) or
    n = THashSplatParameter(result) or
    n = THereDoc(result) or
    n = TIdentifierMethodCall(result) or
    n = TIf(result) or
    n = TIfModifierExpr(result) or
    n = TInstanceVariableAccess(result, _) or
    n = TIntegerLiteral(result) or
    n = TKeywordParameter(result) or
    n = TLEExpr(result) or
    n = TLShiftExpr(result) or
    n = TLTExpr(result) or
    n = TLambda(result) or
    n = TLeftAssignmentList(result) or
    n = TLocalVariableAccess(result, _) or
    n = TLogicalAndExpr(result) or
    n = TLogicalOrExpr(result) or
    n = TMethod(result) or
    n = TModule(result) or
    n = TModuloExpr(result) or
    n = TMulExpr(result) or
    n = TNEExpr(result) or
    n = TNextStmt(result) or
    n = TNilLiteral(result) or
    n = TNoRegexMatchExpr(result) or
    n = TNotExpr(result) or
    n = TOptionalParameter(result) or
    n = TPair(result) or
    n = TParenthesizedExpr(result) or
    n = TRShiftExpr(result) or
    n = TRangeLiteral(result) or
    n = TRationalLiteral(result) or
    n = TRedoStmt(result) or
    n = TRegexLiteral(result) or
    n = TRegexMatchExpr(result) or
    n = TRegularArrayLiteral(result) or
    n = TRegularMethodCall(result) or
    n = TRegularStringLiteral(result) or
    n = TRegularSuperCall(result) or
    n = TRescueClause(result) or
    n = TRescueModifierExpr(result) or
    n = TRetryStmt(result) or
    n = TReturnStmt(result) or
    n = TScopeResolutionConstantReadAccess(result, _) or
    n = TScopeResolutionConstantWriteAccess(result, _) or
    n = TScopeResolutionMethodCall(result, _) or
    n = TSelf(result) or
    n = TSimpleParameter(result) or
    n = TSimpleSymbolLiteral(result) or
    n = TSingletonClass(result) or
    n = TSingletonMethod(result) or
    n = TSpaceshipExpr(result) or
    n = TSplatArgument(result) or
    n = TSplatParameter(result) or
    n = TStringArrayLiteral(result) or
    n = TStringConcatenation(result) or
    n = TStringEscapeSequenceComponent(result) or
    n = TStringInterpolationComponent(result) or
    n = TStringTextComponent(result) or
    n = TSubExpr(result) or
    n = TSubshellLiteral(result) or
    n = TSymbolArrayLiteral(result) or
    n = TTernaryIfExpr(result) or
    n = TThen(result) or
    n = TTokenConstantReadAccess(result) or
    n = TTokenConstantWriteAccess(result) or
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
}

import Cached

TAstNode fromTreeSitter(Generated::AstNode n) { n = toTreeSitter(result) }

class TCall = TMethodCall or TYieldCall;

class TMethodCall =
  TIdentifierMethodCall or TScopeResolutionMethodCall or TRegularMethodCall or TElementReference or
      TSuperCall;

class TSuperCall = TTokenSuperCall or TRegularSuperCall;

class TConstantAccess = TConstantReadAccess or TConstantWriteAccess;

class TConstantReadAccess = TTokenConstantReadAccess or TScopeResolutionConstantReadAccess;

class TConstantWriteAccess = TConstantAssignment or TNamespace;

class TConstantAssignment = TTokenConstantWriteAccess or TScopeResolutionConstantWriteAccess;

class TControlExpr = TConditionalExpr or TCaseExpr or TLoop;

class TConditionalExpr =
  TIfExpr or TUnlessExpr or TIfModifierExpr or TUnlessModifierExpr or TTernaryIfExpr;

class TIfExpr = TIf or TElsif;

class TConditionalLoop = TWhileExpr or TUntilExpr or TWhileModifierExpr or TUntilModifierExpr;

class TLoop = TConditionalLoop or TForExpr;

class TExpr =
  TSelf or TArgumentList or TRescueClause or TRescueModifierExpr or TPair or TStringConcatenation or
      TCall or TBlockArgument or TSplatArgument or THashSplatArgument or TConstantAccess or
      TControlExpr or TWhenExpr or TLiteral or TCallable or TVariableAccess or TStmtSequence or
      TOperation or TSimpleParameter;

class TStmtSequence =
  TBeginBlock or TEndBlock or TThen or TElse or TDo or TEnsure or TStringInterpolationComponent or
      TBlock or TBodyStmt or TParenthesizedExpr;

class TBodyStmt = TBeginExpr or TModuleBase or TMethod or TLambda or TDoBlock or TSingletonMethod;

class TLiteral =
  TNumericLiteral or TNilLiteral or TBooleanLiteral or TStringlikeLiteral or TCharacterLiteral or
      TArrayLiteral or THashLiteral or TRangeLiteral or TTokenMethodName;

class TNumericLiteral = TIntegerLiteral or TFloatLiteral or TRationalLiteral or TComplexLiteral;

class TBooleanLiteral = TTrueLiteral or TFalseLiteral;

class TStringComponent =
  TStringTextComponent or TStringEscapeSequenceComponent or TStringInterpolationComponent;

class TStringlikeLiteral =
  TStringLiteral or TRegexLiteral or TSymbolLiteral or TSubshellLiteral or THereDoc;

class TStringLiteral = TRegularStringLiteral or TBareStringLiteral;

class TSymbolLiteral = TSimpleSymbolLiteral or TComplexSymbolLiteral or THashKeySymbolLiteral;

class TComplexSymbolLiteral = TDelimitedSymbolLiteral or TBareSymbolLiteral;

class TArrayLiteral = TRegularArrayLiteral or TStringArrayLiteral or TSymbolArrayLiteral;

class TCallable = TMethodBase or TLambda or TBlock;

class TMethodBase = TMethod or TSingletonMethod;

class TBlock = TDoBlock or TBraceBlock;

class TModuleBase = TToplevel or TNamespace or TSingletonClass;

class TNamespace = TClass or TModule;

class TOperation = TUnaryOperation or TBinaryOperation or TAssignment;

class TUnaryOperation =
  TUnaryLogicalOperation or TUnaryArithmeticOperation or TUnaryBitwiseOperation or TDefinedExpr;

class TUnaryLogicalOperation = TNotExpr;

class TUnaryArithmeticOperation = TUnaryPlusExpr or TUnaryMinusExpr;

class TUnaryBitwiseOperation = TComplementExpr;

class TBinaryOperation =
  TBinaryArithmeticOperation or TBinaryLogicalOperation or TBinaryBitwiseOperation or
      TComparisonOperation or TSpaceshipExpr or TRegexMatchExpr or TNoRegexMatchExpr;

class TBinaryArithmeticOperation =
  TAddExpr or TSubExpr or TMulExpr or TDivExpr or TModuloExpr or TExponentExpr;

class TBinaryLogicalOperation = TLogicalAndExpr or TLogicalOrExpr;

class TBinaryBitwiseOperation =
  TLShiftExpr or TRShiftExpr or TBitwiseAndExpr or TBitwiseOrExpr or TBitwiseXorExpr;

class TComparisonOperation = TEqualityOperation or TRelationalOperation;

class TEqualityOperation = TEqExpr or TNEExpr or TCaseEqExpr;

class TRelationalOperation = TGTExpr or TGEExpr or TLTExpr or TLEExpr;

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
