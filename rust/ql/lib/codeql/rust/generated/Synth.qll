/**
 * INTERNAL: Do not use.
 * This module defines the IPA layer on top of raw DB entities, and the conversions between the two
 * layers.
 */

private import codeql.rust.generated.SynthConstructors
private import codeql.rust.generated.Raw

cached
module Synth {
  /**
   * INTERNAL: Do not use.
   * The synthesized type of all elements.
   */
  cached
  newtype TElement =
    /**
     * INTERNAL: Do not use.
     */
    TAsmExpr(Raw::AsmExpr id) { constructAsmExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAsyncBlockExpr(Raw::AsyncBlockExpr id) { constructAsyncBlockExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAwaitExpr(Raw::AwaitExpr id) { constructAwaitExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBecomeExpr(Raw::BecomeExpr id) { constructBecomeExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBinExpr(Raw::BinExpr id) { constructBinExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBlockExpr(Raw::BlockExpr id) { constructBlockExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoxExpr(Raw::BoxExpr id) { constructBoxExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoxPat(Raw::BoxPat id) { constructBoxPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBreakExpr(Raw::BreakExpr id) { constructBreakExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCallExpr(Raw::CallExpr id) { constructCallExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCastExpr(Raw::CastExpr id) { constructCastExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TClosureExpr(Raw::ClosureExpr id) { constructClosureExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConstBlockPat(Raw::ConstBlockPat id) { constructConstBlockPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConstExpr(Raw::ConstExpr id) { constructConstExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TContinueExpr(Raw::ContinueExpr id) { constructContinueExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TElementListExpr(Raw::ElementListExpr id) { constructElementListExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExprStmt(Raw::ExprStmt id) { constructExprStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFieldExpr(Raw::FieldExpr id) { constructFieldExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFunction(Raw::Function id) { constructFunction(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TGenericArgList(Raw::GenericArgList id) { constructGenericArgList(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIdentPat(Raw::IdentPat id) { constructIdentPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIfExpr(Raw::IfExpr id) { constructIfExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIndexExpr(Raw::IndexExpr id) { constructIndexExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TItemStmt(Raw::ItemStmt id) { constructItemStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLabel(Raw::Label id) { constructLabel(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLetExpr(Raw::LetExpr id) { constructLetExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLetStmt(Raw::LetStmt id) { constructLetStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLiteral(Raw::Literal id) { constructLiteral(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLiteralPat(Raw::LiteralPat id) { constructLiteralPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLoopExpr(Raw::LoopExpr id) { constructLoopExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMatchArm(Raw::MatchArm id) { constructMatchArm(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMatchExpr(Raw::MatchExpr id) { constructMatchExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMethodCallExpr(Raw::MethodCallExpr id) { constructMethodCallExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMissingExpr(Raw::MissingExpr id) { constructMissingExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMissingPat(Raw::MissingPat id) { constructMissingPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TModule(Raw::Module id) { constructModule(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOffsetOfExpr(Raw::OffsetOfExpr id) { constructOffsetOfExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOrPat(Raw::OrPat id) { constructOrPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPath(Raw::Path id) { constructPath(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPathExpr(Raw::PathExpr id) { constructPathExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPathPat(Raw::PathPat id) { constructPathPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPrefixExpr(Raw::PrefixExpr id) { constructPrefixExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRangeExpr(Raw::RangeExpr id) { constructRangeExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRangePat(Raw::RangePat id) { constructRangePat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordExpr(Raw::RecordExpr id) { constructRecordExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordExprField(Raw::RecordExprField id) { constructRecordExprField(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordPat(Raw::RecordPat id) { constructRecordPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordPatField(Raw::RecordPatField id) { constructRecordPatField(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRefExpr(Raw::RefExpr id) { constructRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRefPat(Raw::RefPat id) { constructRefPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRepeatExpr(Raw::RepeatExpr id) { constructRepeatExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TReturnExpr(Raw::ReturnExpr id) { constructReturnExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSlicePat(Raw::SlicePat id) { constructSlicePat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTupleExpr(Raw::TupleExpr id) { constructTupleExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTuplePat(Raw::TuplePat id) { constructTuplePat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTupleStructPat(Raw::TupleStructPat id) { constructTupleStructPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TType(Raw::Type id) { constructType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnderscoreExpr(Raw::UnderscoreExpr id) { constructUnderscoreExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnimplementedDeclaration(Raw::UnimplementedDeclaration id) {
      constructUnimplementedDeclaration(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TUnsafeBlockExpr(Raw::UnsafeBlockExpr id) { constructUnsafeBlockExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TWildcardPat(Raw::WildcardPat id) { constructWildcardPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TYeetExpr(Raw::YeetExpr id) { constructYeetExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TYieldExpr(Raw::YieldExpr id) { constructYieldExpr(id) }

  /**
   * INTERNAL: Do not use.
   */
  class TArrayExpr = TElementListExpr or TRepeatExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TAstNode =
    TDeclaration or TExpr or TGenericArgList or TLabel or TMatchArm or TPat or TPath or
        TRecordExprField or TRecordPatField or TStmt or TType;

  /**
   * INTERNAL: Do not use.
   */
  class TBlockExprBase = TAsyncBlockExpr or TBlockExpr or TUnsafeBlockExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TDeclaration = TFunction or TModule or TUnimplementedDeclaration;

  /**
   * INTERNAL: Do not use.
   */
  class TExpr =
    TArrayExpr or TAsmExpr or TAwaitExpr or TBecomeExpr or TBinExpr or TBlockExprBase or TBoxExpr or
        TBreakExpr or TCallExpr or TCastExpr or TClosureExpr or TConstExpr or TContinueExpr or
        TFieldExpr or TIfExpr or TIndexExpr or TLetExpr or TLiteral or TLoopExpr or TMatchExpr or
        TMethodCallExpr or TMissingExpr or TOffsetOfExpr or TPathExpr or TPrefixExpr or
        TRangeExpr or TRecordExpr or TRefExpr or TReturnExpr or TTupleExpr or TUnderscoreExpr or
        TYeetExpr or TYieldExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TLocatable = TAstNode;

  /**
   * INTERNAL: Do not use.
   */
  class TPat =
    TBoxPat or TConstBlockPat or TIdentPat or TLiteralPat or TMissingPat or TOrPat or TPathPat or
        TRangePat or TRecordPat or TRefPat or TSlicePat or TTuplePat or TTupleStructPat or
        TWildcardPat;

  /**
   * INTERNAL: Do not use.
   */
  class TStmt = TExprStmt or TItemStmt or TLetStmt;

  /**
   * INTERNAL: Do not use.
   */
  class TUnimplemented = TGenericArgList or TPath or TType or TUnimplementedDeclaration;

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAsmExpr`, if possible.
   */
  cached
  TAsmExpr convertAsmExprFromRaw(Raw::Element e) { result = TAsmExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAsyncBlockExpr`, if possible.
   */
  cached
  TAsyncBlockExpr convertAsyncBlockExprFromRaw(Raw::Element e) { result = TAsyncBlockExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAwaitExpr`, if possible.
   */
  cached
  TAwaitExpr convertAwaitExprFromRaw(Raw::Element e) { result = TAwaitExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBecomeExpr`, if possible.
   */
  cached
  TBecomeExpr convertBecomeExprFromRaw(Raw::Element e) { result = TBecomeExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBinExpr`, if possible.
   */
  cached
  TBinExpr convertBinExprFromRaw(Raw::Element e) { result = TBinExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBlockExpr`, if possible.
   */
  cached
  TBlockExpr convertBlockExprFromRaw(Raw::Element e) { result = TBlockExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoxExpr`, if possible.
   */
  cached
  TBoxExpr convertBoxExprFromRaw(Raw::Element e) { result = TBoxExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoxPat`, if possible.
   */
  cached
  TBoxPat convertBoxPatFromRaw(Raw::Element e) { result = TBoxPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBreakExpr`, if possible.
   */
  cached
  TBreakExpr convertBreakExprFromRaw(Raw::Element e) { result = TBreakExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCallExpr`, if possible.
   */
  cached
  TCallExpr convertCallExprFromRaw(Raw::Element e) { result = TCallExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCastExpr`, if possible.
   */
  cached
  TCastExpr convertCastExprFromRaw(Raw::Element e) { result = TCastExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TClosureExpr`, if possible.
   */
  cached
  TClosureExpr convertClosureExprFromRaw(Raw::Element e) { result = TClosureExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConstBlockPat`, if possible.
   */
  cached
  TConstBlockPat convertConstBlockPatFromRaw(Raw::Element e) { result = TConstBlockPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConstExpr`, if possible.
   */
  cached
  TConstExpr convertConstExprFromRaw(Raw::Element e) { result = TConstExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TContinueExpr`, if possible.
   */
  cached
  TContinueExpr convertContinueExprFromRaw(Raw::Element e) { result = TContinueExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TElementListExpr`, if possible.
   */
  cached
  TElementListExpr convertElementListExprFromRaw(Raw::Element e) { result = TElementListExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExprStmt`, if possible.
   */
  cached
  TExprStmt convertExprStmtFromRaw(Raw::Element e) { result = TExprStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFieldExpr`, if possible.
   */
  cached
  TFieldExpr convertFieldExprFromRaw(Raw::Element e) { result = TFieldExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFunction`, if possible.
   */
  cached
  TFunction convertFunctionFromRaw(Raw::Element e) { result = TFunction(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TGenericArgList`, if possible.
   */
  cached
  TGenericArgList convertGenericArgListFromRaw(Raw::Element e) { result = TGenericArgList(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIdentPat`, if possible.
   */
  cached
  TIdentPat convertIdentPatFromRaw(Raw::Element e) { result = TIdentPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIfExpr`, if possible.
   */
  cached
  TIfExpr convertIfExprFromRaw(Raw::Element e) { result = TIfExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIndexExpr`, if possible.
   */
  cached
  TIndexExpr convertIndexExprFromRaw(Raw::Element e) { result = TIndexExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TItemStmt`, if possible.
   */
  cached
  TItemStmt convertItemStmtFromRaw(Raw::Element e) { result = TItemStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLabel`, if possible.
   */
  cached
  TLabel convertLabelFromRaw(Raw::Element e) { result = TLabel(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLetExpr`, if possible.
   */
  cached
  TLetExpr convertLetExprFromRaw(Raw::Element e) { result = TLetExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLetStmt`, if possible.
   */
  cached
  TLetStmt convertLetStmtFromRaw(Raw::Element e) { result = TLetStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLiteral`, if possible.
   */
  cached
  TLiteral convertLiteralFromRaw(Raw::Element e) { result = TLiteral(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLiteralPat`, if possible.
   */
  cached
  TLiteralPat convertLiteralPatFromRaw(Raw::Element e) { result = TLiteralPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLoopExpr`, if possible.
   */
  cached
  TLoopExpr convertLoopExprFromRaw(Raw::Element e) { result = TLoopExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMatchArm`, if possible.
   */
  cached
  TMatchArm convertMatchArmFromRaw(Raw::Element e) { result = TMatchArm(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMatchExpr`, if possible.
   */
  cached
  TMatchExpr convertMatchExprFromRaw(Raw::Element e) { result = TMatchExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMethodCallExpr`, if possible.
   */
  cached
  TMethodCallExpr convertMethodCallExprFromRaw(Raw::Element e) { result = TMethodCallExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMissingExpr`, if possible.
   */
  cached
  TMissingExpr convertMissingExprFromRaw(Raw::Element e) { result = TMissingExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMissingPat`, if possible.
   */
  cached
  TMissingPat convertMissingPatFromRaw(Raw::Element e) { result = TMissingPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TModule`, if possible.
   */
  cached
  TModule convertModuleFromRaw(Raw::Element e) { result = TModule(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOffsetOfExpr`, if possible.
   */
  cached
  TOffsetOfExpr convertOffsetOfExprFromRaw(Raw::Element e) { result = TOffsetOfExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOrPat`, if possible.
   */
  cached
  TOrPat convertOrPatFromRaw(Raw::Element e) { result = TOrPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPath`, if possible.
   */
  cached
  TPath convertPathFromRaw(Raw::Element e) { result = TPath(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPathExpr`, if possible.
   */
  cached
  TPathExpr convertPathExprFromRaw(Raw::Element e) { result = TPathExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPathPat`, if possible.
   */
  cached
  TPathPat convertPathPatFromRaw(Raw::Element e) { result = TPathPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPrefixExpr`, if possible.
   */
  cached
  TPrefixExpr convertPrefixExprFromRaw(Raw::Element e) { result = TPrefixExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRangeExpr`, if possible.
   */
  cached
  TRangeExpr convertRangeExprFromRaw(Raw::Element e) { result = TRangeExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRangePat`, if possible.
   */
  cached
  TRangePat convertRangePatFromRaw(Raw::Element e) { result = TRangePat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordExpr`, if possible.
   */
  cached
  TRecordExpr convertRecordExprFromRaw(Raw::Element e) { result = TRecordExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordExprField`, if possible.
   */
  cached
  TRecordExprField convertRecordExprFieldFromRaw(Raw::Element e) { result = TRecordExprField(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordPat`, if possible.
   */
  cached
  TRecordPat convertRecordPatFromRaw(Raw::Element e) { result = TRecordPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordPatField`, if possible.
   */
  cached
  TRecordPatField convertRecordPatFieldFromRaw(Raw::Element e) { result = TRecordPatField(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRefExpr`, if possible.
   */
  cached
  TRefExpr convertRefExprFromRaw(Raw::Element e) { result = TRefExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRefPat`, if possible.
   */
  cached
  TRefPat convertRefPatFromRaw(Raw::Element e) { result = TRefPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRepeatExpr`, if possible.
   */
  cached
  TRepeatExpr convertRepeatExprFromRaw(Raw::Element e) { result = TRepeatExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TReturnExpr`, if possible.
   */
  cached
  TReturnExpr convertReturnExprFromRaw(Raw::Element e) { result = TReturnExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSlicePat`, if possible.
   */
  cached
  TSlicePat convertSlicePatFromRaw(Raw::Element e) { result = TSlicePat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTupleExpr`, if possible.
   */
  cached
  TTupleExpr convertTupleExprFromRaw(Raw::Element e) { result = TTupleExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTuplePat`, if possible.
   */
  cached
  TTuplePat convertTuplePatFromRaw(Raw::Element e) { result = TTuplePat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTupleStructPat`, if possible.
   */
  cached
  TTupleStructPat convertTupleStructPatFromRaw(Raw::Element e) { result = TTupleStructPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TType`, if possible.
   */
  cached
  TType convertTypeFromRaw(Raw::Element e) { result = TType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnderscoreExpr`, if possible.
   */
  cached
  TUnderscoreExpr convertUnderscoreExprFromRaw(Raw::Element e) { result = TUnderscoreExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnimplementedDeclaration`, if possible.
   */
  cached
  TUnimplementedDeclaration convertUnimplementedDeclarationFromRaw(Raw::Element e) {
    result = TUnimplementedDeclaration(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnsafeBlockExpr`, if possible.
   */
  cached
  TUnsafeBlockExpr convertUnsafeBlockExprFromRaw(Raw::Element e) { result = TUnsafeBlockExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TWildcardPat`, if possible.
   */
  cached
  TWildcardPat convertWildcardPatFromRaw(Raw::Element e) { result = TWildcardPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TYeetExpr`, if possible.
   */
  cached
  TYeetExpr convertYeetExprFromRaw(Raw::Element e) { result = TYeetExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TYieldExpr`, if possible.
   */
  cached
  TYieldExpr convertYieldExprFromRaw(Raw::Element e) { result = TYieldExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TArrayExpr`, if possible.
   */
  cached
  TArrayExpr convertArrayExprFromRaw(Raw::Element e) {
    result = convertElementListExprFromRaw(e)
    or
    result = convertRepeatExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAstNode`, if possible.
   */
  cached
  TAstNode convertAstNodeFromRaw(Raw::Element e) {
    result = convertDeclarationFromRaw(e)
    or
    result = convertExprFromRaw(e)
    or
    result = convertGenericArgListFromRaw(e)
    or
    result = convertLabelFromRaw(e)
    or
    result = convertMatchArmFromRaw(e)
    or
    result = convertPatFromRaw(e)
    or
    result = convertPathFromRaw(e)
    or
    result = convertRecordExprFieldFromRaw(e)
    or
    result = convertRecordPatFieldFromRaw(e)
    or
    result = convertStmtFromRaw(e)
    or
    result = convertTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TBlockExprBase`, if possible.
   */
  cached
  TBlockExprBase convertBlockExprBaseFromRaw(Raw::Element e) {
    result = convertAsyncBlockExprFromRaw(e)
    or
    result = convertBlockExprFromRaw(e)
    or
    result = convertUnsafeBlockExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TDeclaration`, if possible.
   */
  cached
  TDeclaration convertDeclarationFromRaw(Raw::Element e) {
    result = convertFunctionFromRaw(e)
    or
    result = convertModuleFromRaw(e)
    or
    result = convertUnimplementedDeclarationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TElement`, if possible.
   */
  cached
  TElement convertElementFromRaw(Raw::Element e) {
    result = convertLocatableFromRaw(e)
    or
    result = convertUnimplementedFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TExpr`, if possible.
   */
  cached
  TExpr convertExprFromRaw(Raw::Element e) {
    result = convertArrayExprFromRaw(e)
    or
    result = convertAsmExprFromRaw(e)
    or
    result = convertAwaitExprFromRaw(e)
    or
    result = convertBecomeExprFromRaw(e)
    or
    result = convertBinExprFromRaw(e)
    or
    result = convertBlockExprBaseFromRaw(e)
    or
    result = convertBoxExprFromRaw(e)
    or
    result = convertBreakExprFromRaw(e)
    or
    result = convertCallExprFromRaw(e)
    or
    result = convertCastExprFromRaw(e)
    or
    result = convertClosureExprFromRaw(e)
    or
    result = convertConstExprFromRaw(e)
    or
    result = convertContinueExprFromRaw(e)
    or
    result = convertFieldExprFromRaw(e)
    or
    result = convertIfExprFromRaw(e)
    or
    result = convertIndexExprFromRaw(e)
    or
    result = convertLetExprFromRaw(e)
    or
    result = convertLiteralFromRaw(e)
    or
    result = convertLoopExprFromRaw(e)
    or
    result = convertMatchExprFromRaw(e)
    or
    result = convertMethodCallExprFromRaw(e)
    or
    result = convertMissingExprFromRaw(e)
    or
    result = convertOffsetOfExprFromRaw(e)
    or
    result = convertPathExprFromRaw(e)
    or
    result = convertPrefixExprFromRaw(e)
    or
    result = convertRangeExprFromRaw(e)
    or
    result = convertRecordExprFromRaw(e)
    or
    result = convertRefExprFromRaw(e)
    or
    result = convertReturnExprFromRaw(e)
    or
    result = convertTupleExprFromRaw(e)
    or
    result = convertUnderscoreExprFromRaw(e)
    or
    result = convertYeetExprFromRaw(e)
    or
    result = convertYieldExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLocatable`, if possible.
   */
  cached
  TLocatable convertLocatableFromRaw(Raw::Element e) { result = convertAstNodeFromRaw(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TPat`, if possible.
   */
  cached
  TPat convertPatFromRaw(Raw::Element e) {
    result = convertBoxPatFromRaw(e)
    or
    result = convertConstBlockPatFromRaw(e)
    or
    result = convertIdentPatFromRaw(e)
    or
    result = convertLiteralPatFromRaw(e)
    or
    result = convertMissingPatFromRaw(e)
    or
    result = convertOrPatFromRaw(e)
    or
    result = convertPathPatFromRaw(e)
    or
    result = convertRangePatFromRaw(e)
    or
    result = convertRecordPatFromRaw(e)
    or
    result = convertRefPatFromRaw(e)
    or
    result = convertSlicePatFromRaw(e)
    or
    result = convertTuplePatFromRaw(e)
    or
    result = convertTupleStructPatFromRaw(e)
    or
    result = convertWildcardPatFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TStmt`, if possible.
   */
  cached
  TStmt convertStmtFromRaw(Raw::Element e) {
    result = convertExprStmtFromRaw(e)
    or
    result = convertItemStmtFromRaw(e)
    or
    result = convertLetStmtFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TUnimplemented`, if possible.
   */
  cached
  TUnimplemented convertUnimplementedFromRaw(Raw::Element e) {
    result = convertGenericArgListFromRaw(e)
    or
    result = convertPathFromRaw(e)
    or
    result = convertTypeFromRaw(e)
    or
    result = convertUnimplementedDeclarationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAsmExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAsmExprToRaw(TAsmExpr e) { e = TAsmExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAsyncBlockExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAsyncBlockExprToRaw(TAsyncBlockExpr e) { e = TAsyncBlockExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAwaitExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAwaitExprToRaw(TAwaitExpr e) { e = TAwaitExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBecomeExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBecomeExprToRaw(TBecomeExpr e) { e = TBecomeExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBinExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBinExprToRaw(TBinExpr e) { e = TBinExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBlockExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBlockExprToRaw(TBlockExpr e) { e = TBlockExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoxExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoxExprToRaw(TBoxExpr e) { e = TBoxExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoxPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoxPatToRaw(TBoxPat e) { e = TBoxPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBreakExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBreakExprToRaw(TBreakExpr e) { e = TBreakExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCallExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCallExprToRaw(TCallExpr e) { e = TCallExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCastExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCastExprToRaw(TCastExpr e) { e = TCastExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClosureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClosureExprToRaw(TClosureExpr e) { e = TClosureExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConstBlockPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConstBlockPatToRaw(TConstBlockPat e) { e = TConstBlockPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConstExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConstExprToRaw(TConstExpr e) { e = TConstExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TContinueExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertContinueExprToRaw(TContinueExpr e) { e = TContinueExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TElementListExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertElementListExprToRaw(TElementListExpr e) { e = TElementListExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExprStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprStmtToRaw(TExprStmt e) { e = TExprStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFieldExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFieldExprToRaw(TFieldExpr e) { e = TFieldExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionToRaw(TFunction e) { e = TFunction(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericArgList` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericArgListToRaw(TGenericArgList e) { e = TGenericArgList(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIdentPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIdentPatToRaw(TIdentPat e) { e = TIdentPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIfExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfExprToRaw(TIfExpr e) { e = TIfExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIndexExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIndexExprToRaw(TIndexExpr e) { e = TIndexExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TItemStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertItemStmtToRaw(TItemStmt e) { e = TItemStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLabel` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLabelToRaw(TLabel e) { e = TLabel(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLetExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLetExprToRaw(TLetExpr e) { e = TLetExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLetStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLetStmtToRaw(TLetStmt e) { e = TLetStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLiteral` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLiteralToRaw(TLiteral e) { e = TLiteral(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLiteralPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLiteralPatToRaw(TLiteralPat e) { e = TLiteralPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLoopExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLoopExprToRaw(TLoopExpr e) { e = TLoopExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMatchArm` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMatchArmToRaw(TMatchArm e) { e = TMatchArm(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMatchExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMatchExprToRaw(TMatchExpr e) { e = TMatchExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMethodCallExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMethodCallExprToRaw(TMethodCallExpr e) { e = TMethodCallExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMissingExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMissingExprToRaw(TMissingExpr e) { e = TMissingExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMissingPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMissingPatToRaw(TMissingPat e) { e = TMissingPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TModule` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertModuleToRaw(TModule e) { e = TModule(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOffsetOfExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOffsetOfExprToRaw(TOffsetOfExpr e) { e = TOffsetOfExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOrPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOrPatToRaw(TOrPat e) { e = TOrPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPath` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPathToRaw(TPath e) { e = TPath(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPathExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPathExprToRaw(TPathExpr e) { e = TPathExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPathPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPathPatToRaw(TPathPat e) { e = TPathPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPrefixExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPrefixExprToRaw(TPrefixExpr e) { e = TPrefixExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRangeExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRangeExprToRaw(TRangeExpr e) { e = TRangeExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRangePat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRangePatToRaw(TRangePat e) { e = TRangePat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordExprToRaw(TRecordExpr e) { e = TRecordExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordExprField` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordExprFieldToRaw(TRecordExprField e) { e = TRecordExprField(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordPatToRaw(TRecordPat e) { e = TRecordPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordPatField` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordPatFieldToRaw(TRecordPatField e) { e = TRecordPatField(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRefExprToRaw(TRefExpr e) { e = TRefExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRefPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRefPatToRaw(TRefPat e) { e = TRefPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRepeatExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRepeatExprToRaw(TRepeatExpr e) { e = TRepeatExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TReturnExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertReturnExprToRaw(TReturnExpr e) { e = TReturnExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSlicePat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSlicePatToRaw(TSlicePat e) { e = TSlicePat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTupleExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleExprToRaw(TTupleExpr e) { e = TTupleExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTuplePat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTuplePatToRaw(TTuplePat e) { e = TTuplePat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTupleStructPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleStructPatToRaw(TTupleStructPat e) { e = TTupleStructPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeToRaw(TType e) { e = TType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnderscoreExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnderscoreExprToRaw(TUnderscoreExpr e) { e = TUnderscoreExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnimplementedDeclaration` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnimplementedDeclarationToRaw(TUnimplementedDeclaration e) {
    e = TUnimplementedDeclaration(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnsafeBlockExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnsafeBlockExprToRaw(TUnsafeBlockExpr e) { e = TUnsafeBlockExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TWildcardPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertWildcardPatToRaw(TWildcardPat e) { e = TWildcardPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TYeetExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertYeetExprToRaw(TYeetExpr e) { e = TYeetExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TYieldExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertYieldExprToRaw(TYieldExpr e) { e = TYieldExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArrayExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArrayExprToRaw(TArrayExpr e) {
    result = convertElementListExprToRaw(e)
    or
    result = convertRepeatExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAstNode` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAstNodeToRaw(TAstNode e) {
    result = convertDeclarationToRaw(e)
    or
    result = convertExprToRaw(e)
    or
    result = convertGenericArgListToRaw(e)
    or
    result = convertLabelToRaw(e)
    or
    result = convertMatchArmToRaw(e)
    or
    result = convertPatToRaw(e)
    or
    result = convertPathToRaw(e)
    or
    result = convertRecordExprFieldToRaw(e)
    or
    result = convertRecordPatFieldToRaw(e)
    or
    result = convertStmtToRaw(e)
    or
    result = convertTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBlockExprBase` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBlockExprBaseToRaw(TBlockExprBase e) {
    result = convertAsyncBlockExprToRaw(e)
    or
    result = convertBlockExprToRaw(e)
    or
    result = convertUnsafeBlockExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDeclaration` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeclarationToRaw(TDeclaration e) {
    result = convertFunctionToRaw(e)
    or
    result = convertModuleToRaw(e)
    or
    result = convertUnimplementedDeclarationToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertElementToRaw(TElement e) {
    result = convertLocatableToRaw(e)
    or
    result = convertUnimplementedToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprToRaw(TExpr e) {
    result = convertArrayExprToRaw(e)
    or
    result = convertAsmExprToRaw(e)
    or
    result = convertAwaitExprToRaw(e)
    or
    result = convertBecomeExprToRaw(e)
    or
    result = convertBinExprToRaw(e)
    or
    result = convertBlockExprBaseToRaw(e)
    or
    result = convertBoxExprToRaw(e)
    or
    result = convertBreakExprToRaw(e)
    or
    result = convertCallExprToRaw(e)
    or
    result = convertCastExprToRaw(e)
    or
    result = convertClosureExprToRaw(e)
    or
    result = convertConstExprToRaw(e)
    or
    result = convertContinueExprToRaw(e)
    or
    result = convertFieldExprToRaw(e)
    or
    result = convertIfExprToRaw(e)
    or
    result = convertIndexExprToRaw(e)
    or
    result = convertLetExprToRaw(e)
    or
    result = convertLiteralToRaw(e)
    or
    result = convertLoopExprToRaw(e)
    or
    result = convertMatchExprToRaw(e)
    or
    result = convertMethodCallExprToRaw(e)
    or
    result = convertMissingExprToRaw(e)
    or
    result = convertOffsetOfExprToRaw(e)
    or
    result = convertPathExprToRaw(e)
    or
    result = convertPrefixExprToRaw(e)
    or
    result = convertRangeExprToRaw(e)
    or
    result = convertRecordExprToRaw(e)
    or
    result = convertRefExprToRaw(e)
    or
    result = convertReturnExprToRaw(e)
    or
    result = convertTupleExprToRaw(e)
    or
    result = convertUnderscoreExprToRaw(e)
    or
    result = convertYeetExprToRaw(e)
    or
    result = convertYieldExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLocatable` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLocatableToRaw(TLocatable e) { result = convertAstNodeToRaw(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPatToRaw(TPat e) {
    result = convertBoxPatToRaw(e)
    or
    result = convertConstBlockPatToRaw(e)
    or
    result = convertIdentPatToRaw(e)
    or
    result = convertLiteralPatToRaw(e)
    or
    result = convertMissingPatToRaw(e)
    or
    result = convertOrPatToRaw(e)
    or
    result = convertPathPatToRaw(e)
    or
    result = convertRangePatToRaw(e)
    or
    result = convertRecordPatToRaw(e)
    or
    result = convertRefPatToRaw(e)
    or
    result = convertSlicePatToRaw(e)
    or
    result = convertTuplePatToRaw(e)
    or
    result = convertTupleStructPatToRaw(e)
    or
    result = convertWildcardPatToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStmtToRaw(TStmt e) {
    result = convertExprStmtToRaw(e)
    or
    result = convertItemStmtToRaw(e)
    or
    result = convertLetStmtToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnimplemented` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnimplementedToRaw(TUnimplemented e) {
    result = convertGenericArgListToRaw(e)
    or
    result = convertPathToRaw(e)
    or
    result = convertTypeToRaw(e)
    or
    result = convertUnimplementedDeclarationToRaw(e)
  }
}
