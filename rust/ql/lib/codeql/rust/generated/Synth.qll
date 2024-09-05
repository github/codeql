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
    TArray(Raw::Array id) { constructArray(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAsync(Raw::Async id) { constructAsync(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAwait(Raw::Await id) { constructAwait(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBecome(Raw::Become id) { constructBecome(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBinaryOp(Raw::BinaryOp id) { constructBinaryOp(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBindPat(Raw::BindPat id) { constructBindPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBox(Raw::Box id) { constructBox(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoxPat(Raw::BoxPat id) { constructBoxPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBreak(Raw::Break id) { constructBreak(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCall(Raw::Call id) { constructCall(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCast(Raw::Cast id) { constructCast(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TClosure(Raw::Closure id) { constructClosure(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConst(Raw::Const id) { constructConst(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConstBlockPat(Raw::ConstBlockPat id) { constructConstBlockPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TContinue(Raw::Continue id) { constructContinue(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDbFile(Raw::DbFile id) { constructDbFile(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDbLocation(Raw::DbLocation id) { constructDbLocation(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExprStmt(Raw::ExprStmt id) { constructExprStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TField(Raw::Field id) { constructField(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFunction(Raw::Function id) { constructFunction(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIf(Raw::If id) { constructIf(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIfLet(Raw::IfLet id) { constructIfLet(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIndex(Raw::Index id) { constructIndex(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInlineAsm(Raw::InlineAsm id) { constructInlineAsm(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TItemStmt(Raw::ItemStmt id) { constructItemStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLet(Raw::Let id) { constructLet(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLitPat(Raw::LitPat id) { constructLitPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLiteral(Raw::Literal id) { constructLiteral(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLoop(Raw::Loop id) { constructLoop(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMatch(Raw::Match id) { constructMatch(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMatchArm(Raw::MatchArm id) { constructMatchArm(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMethodCall(Raw::MethodCall id) { constructMethodCall(id) } or
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
    TOffsetOf(Raw::OffsetOf id) { constructOffsetOf(id) } or
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
    TPathPat(Raw::PathPat id) { constructPathPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRange(Raw::Range id) { constructRange(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRangePat(Raw::RangePat id) { constructRangePat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordLit(Raw::RecordLit id) { constructRecordLit(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRecordPat(Raw::RecordPat id) { constructRecordPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRef(Raw::Ref id) { constructRef(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRefPat(Raw::RefPat id) { constructRefPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TReturn(Raw::Return id) { constructReturn(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSlicePat(Raw::SlicePat id) { constructSlicePat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTuple(Raw::Tuple id) { constructTuple(id) } or
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
    TTypeRef(Raw::TypeRef id) { constructTypeRef(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnaryExpr(Raw::UnaryExpr id) { constructUnaryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnderscore(Raw::Underscore id) { constructUnderscore(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnknownFile() or
    /**
     * INTERNAL: Do not use.
     */
    TUnknownLocation() or
    /**
     * INTERNAL: Do not use.
     */
    TUnsafe(Raw::Unsafe id) { constructUnsafe(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TWildPat(Raw::WildPat id) { constructWildPat(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TYeet(Raw::Yeet id) { constructYeet(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TYield(Raw::Yield id) { constructYield(id) }

  /**
   * INTERNAL: Do not use.
   */
  class TBlock = TAsync or TUnsafe;

  /**
   * INTERNAL: Do not use.
   */
  class TDeclaration = TFunction or TModule;

  /**
   * INTERNAL: Do not use.
   */
  class TExpr =
    TArray or TAwait or TBecome or TBinaryOp or TBlock or TBox or TBreak or TCall or TCast or
        TClosure or TConst or TContinue or TField or TIf or TIndex or TInlineAsm or TLet or
        TLiteral or TLoop or TMatch or TMethodCall or TMissingExpr or TOffsetOf or TPath or
        TRange or TRecordLit or TRef or TReturn or TTuple or TUnaryExpr or TUnderscore or TYeet or
        TYield;

  /**
   * INTERNAL: Do not use.
   */
  class TFile = TDbFile or TUnknownFile;

  /**
   * INTERNAL: Do not use.
   */
  class TLocatable = TDeclaration or TExpr or TMatchArm or TPat or TStmt or TTypeRef;

  /**
   * INTERNAL: Do not use.
   */
  class TLocation = TDbLocation or TUnknownLocation;

  /**
   * INTERNAL: Do not use.
   */
  class TPat =
    TBindPat or TBoxPat or TConstBlockPat or TLitPat or TMissingPat or TOrPat or TPathPat or
        TRangePat or TRecordPat or TRefPat or TSlicePat or TTuplePat or TTupleStructPat or TWildPat;

  /**
   * INTERNAL: Do not use.
   */
  class TStmt = TExprStmt or TIfLet or TItemStmt;

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArray`, if possible.
   */
  cached
  TArray convertArrayFromRaw(Raw::Element e) { result = TArray(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAsync`, if possible.
   */
  cached
  TAsync convertAsyncFromRaw(Raw::Element e) { result = TAsync(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAwait`, if possible.
   */
  cached
  TAwait convertAwaitFromRaw(Raw::Element e) { result = TAwait(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBecome`, if possible.
   */
  cached
  TBecome convertBecomeFromRaw(Raw::Element e) { result = TBecome(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBinaryOp`, if possible.
   */
  cached
  TBinaryOp convertBinaryOpFromRaw(Raw::Element e) { result = TBinaryOp(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBindPat`, if possible.
   */
  cached
  TBindPat convertBindPatFromRaw(Raw::Element e) { result = TBindPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBox`, if possible.
   */
  cached
  TBox convertBoxFromRaw(Raw::Element e) { result = TBox(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoxPat`, if possible.
   */
  cached
  TBoxPat convertBoxPatFromRaw(Raw::Element e) { result = TBoxPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBreak`, if possible.
   */
  cached
  TBreak convertBreakFromRaw(Raw::Element e) { result = TBreak(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCall`, if possible.
   */
  cached
  TCall convertCallFromRaw(Raw::Element e) { result = TCall(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCast`, if possible.
   */
  cached
  TCast convertCastFromRaw(Raw::Element e) { result = TCast(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TClosure`, if possible.
   */
  cached
  TClosure convertClosureFromRaw(Raw::Element e) { result = TClosure(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConst`, if possible.
   */
  cached
  TConst convertConstFromRaw(Raw::Element e) { result = TConst(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConstBlockPat`, if possible.
   */
  cached
  TConstBlockPat convertConstBlockPatFromRaw(Raw::Element e) { result = TConstBlockPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TContinue`, if possible.
   */
  cached
  TContinue convertContinueFromRaw(Raw::Element e) { result = TContinue(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDbFile`, if possible.
   */
  cached
  TDbFile convertDbFileFromRaw(Raw::Element e) { result = TDbFile(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDbLocation`, if possible.
   */
  cached
  TDbLocation convertDbLocationFromRaw(Raw::Element e) { result = TDbLocation(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExprStmt`, if possible.
   */
  cached
  TExprStmt convertExprStmtFromRaw(Raw::Element e) { result = TExprStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TField`, if possible.
   */
  cached
  TField convertFieldFromRaw(Raw::Element e) { result = TField(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFunction`, if possible.
   */
  cached
  TFunction convertFunctionFromRaw(Raw::Element e) { result = TFunction(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIf`, if possible.
   */
  cached
  TIf convertIfFromRaw(Raw::Element e) { result = TIf(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIfLet`, if possible.
   */
  cached
  TIfLet convertIfLetFromRaw(Raw::Element e) { result = TIfLet(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIndex`, if possible.
   */
  cached
  TIndex convertIndexFromRaw(Raw::Element e) { result = TIndex(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInlineAsm`, if possible.
   */
  cached
  TInlineAsm convertInlineAsmFromRaw(Raw::Element e) { result = TInlineAsm(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TItemStmt`, if possible.
   */
  cached
  TItemStmt convertItemStmtFromRaw(Raw::Element e) { result = TItemStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLet`, if possible.
   */
  cached
  TLet convertLetFromRaw(Raw::Element e) { result = TLet(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLitPat`, if possible.
   */
  cached
  TLitPat convertLitPatFromRaw(Raw::Element e) { result = TLitPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLiteral`, if possible.
   */
  cached
  TLiteral convertLiteralFromRaw(Raw::Element e) { result = TLiteral(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLoop`, if possible.
   */
  cached
  TLoop convertLoopFromRaw(Raw::Element e) { result = TLoop(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMatch`, if possible.
   */
  cached
  TMatch convertMatchFromRaw(Raw::Element e) { result = TMatch(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMatchArm`, if possible.
   */
  cached
  TMatchArm convertMatchArmFromRaw(Raw::Element e) { result = TMatchArm(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMethodCall`, if possible.
   */
  cached
  TMethodCall convertMethodCallFromRaw(Raw::Element e) { result = TMethodCall(e) }

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
   * Converts a raw element to a synthesized `TOffsetOf`, if possible.
   */
  cached
  TOffsetOf convertOffsetOfFromRaw(Raw::Element e) { result = TOffsetOf(e) }

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
   * Converts a raw element to a synthesized `TPathPat`, if possible.
   */
  cached
  TPathPat convertPathPatFromRaw(Raw::Element e) { result = TPathPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRange`, if possible.
   */
  cached
  TRange convertRangeFromRaw(Raw::Element e) { result = TRange(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRangePat`, if possible.
   */
  cached
  TRangePat convertRangePatFromRaw(Raw::Element e) { result = TRangePat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordLit`, if possible.
   */
  cached
  TRecordLit convertRecordLitFromRaw(Raw::Element e) { result = TRecordLit(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRecordPat`, if possible.
   */
  cached
  TRecordPat convertRecordPatFromRaw(Raw::Element e) { result = TRecordPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRef`, if possible.
   */
  cached
  TRef convertRefFromRaw(Raw::Element e) { result = TRef(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRefPat`, if possible.
   */
  cached
  TRefPat convertRefPatFromRaw(Raw::Element e) { result = TRefPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TReturn`, if possible.
   */
  cached
  TReturn convertReturnFromRaw(Raw::Element e) { result = TReturn(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSlicePat`, if possible.
   */
  cached
  TSlicePat convertSlicePatFromRaw(Raw::Element e) { result = TSlicePat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTuple`, if possible.
   */
  cached
  TTuple convertTupleFromRaw(Raw::Element e) { result = TTuple(e) }

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
   * Converts a raw element to a synthesized `TTypeRef`, if possible.
   */
  cached
  TTypeRef convertTypeRefFromRaw(Raw::Element e) { result = TTypeRef(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnaryExpr`, if possible.
   */
  cached
  TUnaryExpr convertUnaryExprFromRaw(Raw::Element e) { result = TUnaryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnderscore`, if possible.
   */
  cached
  TUnderscore convertUnderscoreFromRaw(Raw::Element e) { result = TUnderscore(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnknownFile`, if possible.
   */
  cached
  TUnknownFile convertUnknownFileFromRaw(Raw::Element e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnknownLocation`, if possible.
   */
  cached
  TUnknownLocation convertUnknownLocationFromRaw(Raw::Element e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnsafe`, if possible.
   */
  cached
  TUnsafe convertUnsafeFromRaw(Raw::Element e) { result = TUnsafe(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TWildPat`, if possible.
   */
  cached
  TWildPat convertWildPatFromRaw(Raw::Element e) { result = TWildPat(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TYeet`, if possible.
   */
  cached
  TYeet convertYeetFromRaw(Raw::Element e) { result = TYeet(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TYield`, if possible.
   */
  cached
  TYield convertYieldFromRaw(Raw::Element e) { result = TYield(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TBlock`, if possible.
   */
  cached
  TBlock convertBlockFromRaw(Raw::Element e) {
    result = convertAsyncFromRaw(e)
    or
    result = convertUnsafeFromRaw(e)
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
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TElement`, if possible.
   */
  cached
  TElement convertElementFromRaw(Raw::Element e) {
    result = convertFileFromRaw(e)
    or
    result = convertLocatableFromRaw(e)
    or
    result = convertLocationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TExpr`, if possible.
   */
  cached
  TExpr convertExprFromRaw(Raw::Element e) {
    result = convertArrayFromRaw(e)
    or
    result = convertAwaitFromRaw(e)
    or
    result = convertBecomeFromRaw(e)
    or
    result = convertBinaryOpFromRaw(e)
    or
    result = convertBlockFromRaw(e)
    or
    result = convertBoxFromRaw(e)
    or
    result = convertBreakFromRaw(e)
    or
    result = convertCallFromRaw(e)
    or
    result = convertCastFromRaw(e)
    or
    result = convertClosureFromRaw(e)
    or
    result = convertConstFromRaw(e)
    or
    result = convertContinueFromRaw(e)
    or
    result = convertFieldFromRaw(e)
    or
    result = convertIfFromRaw(e)
    or
    result = convertIndexFromRaw(e)
    or
    result = convertInlineAsmFromRaw(e)
    or
    result = convertLetFromRaw(e)
    or
    result = convertLiteralFromRaw(e)
    or
    result = convertLoopFromRaw(e)
    or
    result = convertMatchFromRaw(e)
    or
    result = convertMethodCallFromRaw(e)
    or
    result = convertMissingExprFromRaw(e)
    or
    result = convertOffsetOfFromRaw(e)
    or
    result = convertPathFromRaw(e)
    or
    result = convertRangeFromRaw(e)
    or
    result = convertRecordLitFromRaw(e)
    or
    result = convertRefFromRaw(e)
    or
    result = convertReturnFromRaw(e)
    or
    result = convertTupleFromRaw(e)
    or
    result = convertUnaryExprFromRaw(e)
    or
    result = convertUnderscoreFromRaw(e)
    or
    result = convertYeetFromRaw(e)
    or
    result = convertYieldFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TFile`, if possible.
   */
  cached
  TFile convertFileFromRaw(Raw::Element e) {
    result = convertDbFileFromRaw(e)
    or
    result = convertUnknownFileFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLocatable`, if possible.
   */
  cached
  TLocatable convertLocatableFromRaw(Raw::Element e) {
    result = convertDeclarationFromRaw(e)
    or
    result = convertExprFromRaw(e)
    or
    result = convertMatchArmFromRaw(e)
    or
    result = convertPatFromRaw(e)
    or
    result = convertStmtFromRaw(e)
    or
    result = convertTypeRefFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLocation`, if possible.
   */
  cached
  TLocation convertLocationFromRaw(Raw::Element e) {
    result = convertDbLocationFromRaw(e)
    or
    result = convertUnknownLocationFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TPat`, if possible.
   */
  cached
  TPat convertPatFromRaw(Raw::Element e) {
    result = convertBindPatFromRaw(e)
    or
    result = convertBoxPatFromRaw(e)
    or
    result = convertConstBlockPatFromRaw(e)
    or
    result = convertLitPatFromRaw(e)
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
    result = convertWildPatFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TStmt`, if possible.
   */
  cached
  TStmt convertStmtFromRaw(Raw::Element e) {
    result = convertExprStmtFromRaw(e)
    or
    result = convertIfLetFromRaw(e)
    or
    result = convertItemStmtFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArray` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArrayToRaw(TArray e) { e = TArray(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAsync` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAsyncToRaw(TAsync e) { e = TAsync(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAwait` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAwaitToRaw(TAwait e) { e = TAwait(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBecome` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBecomeToRaw(TBecome e) { e = TBecome(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBinaryOp` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBinaryOpToRaw(TBinaryOp e) { e = TBinaryOp(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBindPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBindPatToRaw(TBindPat e) { e = TBindPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBox` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoxToRaw(TBox e) { e = TBox(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoxPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoxPatToRaw(TBoxPat e) { e = TBoxPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBreak` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBreakToRaw(TBreak e) { e = TBreak(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCall` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCallToRaw(TCall e) { e = TCall(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCast` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCastToRaw(TCast e) { e = TCast(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClosure` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClosureToRaw(TClosure e) { e = TClosure(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConst` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConstToRaw(TConst e) { e = TConst(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConstBlockPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConstBlockPatToRaw(TConstBlockPat e) { e = TConstBlockPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TContinue` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertContinueToRaw(TContinue e) { e = TContinue(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDbFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDbFileToRaw(TDbFile e) { e = TDbFile(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDbLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDbLocationToRaw(TDbLocation e) { e = TDbLocation(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExprStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprStmtToRaw(TExprStmt e) { e = TExprStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TField` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFieldToRaw(TField e) { e = TField(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionToRaw(TFunction e) { e = TFunction(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIf` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfToRaw(TIf e) { e = TIf(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIfLet` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfLetToRaw(TIfLet e) { e = TIfLet(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIndex` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIndexToRaw(TIndex e) { e = TIndex(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInlineAsm` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInlineAsmToRaw(TInlineAsm e) { e = TInlineAsm(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TItemStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertItemStmtToRaw(TItemStmt e) { e = TItemStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLet` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLetToRaw(TLet e) { e = TLet(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLitPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLitPatToRaw(TLitPat e) { e = TLitPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLiteral` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLiteralToRaw(TLiteral e) { e = TLiteral(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLoop` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLoopToRaw(TLoop e) { e = TLoop(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMatch` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMatchToRaw(TMatch e) { e = TMatch(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMatchArm` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMatchArmToRaw(TMatchArm e) { e = TMatchArm(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMethodCall` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMethodCallToRaw(TMethodCall e) { e = TMethodCall(result) }

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
   * Converts a synthesized `TOffsetOf` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOffsetOfToRaw(TOffsetOf e) { e = TOffsetOf(result) }

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
   * Converts a synthesized `TPathPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPathPatToRaw(TPathPat e) { e = TPathPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRange` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRangeToRaw(TRange e) { e = TRange(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRangePat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRangePatToRaw(TRangePat e) { e = TRangePat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordLit` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordLitToRaw(TRecordLit e) { e = TRecordLit(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRecordPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRecordPatToRaw(TRecordPat e) { e = TRecordPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRef` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRefToRaw(TRef e) { e = TRef(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRefPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRefPatToRaw(TRefPat e) { e = TRefPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TReturn` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertReturnToRaw(TReturn e) { e = TReturn(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSlicePat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSlicePatToRaw(TSlicePat e) { e = TSlicePat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTuple` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleToRaw(TTuple e) { e = TTuple(result) }

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
   * Converts a synthesized `TTypeRef` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeRefToRaw(TTypeRef e) { e = TTypeRef(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnaryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnaryExprToRaw(TUnaryExpr e) { e = TUnaryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnderscore` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnderscoreToRaw(TUnderscore e) { e = TUnderscore(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnknownFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnknownFileToRaw(TUnknownFile e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnknownLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnknownLocationToRaw(TUnknownLocation e) { none() }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnsafe` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnsafeToRaw(TUnsafe e) { e = TUnsafe(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TWildPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertWildPatToRaw(TWildPat e) { e = TWildPat(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TYeet` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertYeetToRaw(TYeet e) { e = TYeet(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TYield` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertYieldToRaw(TYield e) { e = TYield(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBlock` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBlockToRaw(TBlock e) {
    result = convertAsyncToRaw(e)
    or
    result = convertUnsafeToRaw(e)
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
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertElementToRaw(TElement e) {
    result = convertFileToRaw(e)
    or
    result = convertLocatableToRaw(e)
    or
    result = convertLocationToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprToRaw(TExpr e) {
    result = convertArrayToRaw(e)
    or
    result = convertAwaitToRaw(e)
    or
    result = convertBecomeToRaw(e)
    or
    result = convertBinaryOpToRaw(e)
    or
    result = convertBlockToRaw(e)
    or
    result = convertBoxToRaw(e)
    or
    result = convertBreakToRaw(e)
    or
    result = convertCallToRaw(e)
    or
    result = convertCastToRaw(e)
    or
    result = convertClosureToRaw(e)
    or
    result = convertConstToRaw(e)
    or
    result = convertContinueToRaw(e)
    or
    result = convertFieldToRaw(e)
    or
    result = convertIfToRaw(e)
    or
    result = convertIndexToRaw(e)
    or
    result = convertInlineAsmToRaw(e)
    or
    result = convertLetToRaw(e)
    or
    result = convertLiteralToRaw(e)
    or
    result = convertLoopToRaw(e)
    or
    result = convertMatchToRaw(e)
    or
    result = convertMethodCallToRaw(e)
    or
    result = convertMissingExprToRaw(e)
    or
    result = convertOffsetOfToRaw(e)
    or
    result = convertPathToRaw(e)
    or
    result = convertRangeToRaw(e)
    or
    result = convertRecordLitToRaw(e)
    or
    result = convertRefToRaw(e)
    or
    result = convertReturnToRaw(e)
    or
    result = convertTupleToRaw(e)
    or
    result = convertUnaryExprToRaw(e)
    or
    result = convertUnderscoreToRaw(e)
    or
    result = convertYeetToRaw(e)
    or
    result = convertYieldToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFile` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFileToRaw(TFile e) {
    result = convertDbFileToRaw(e)
    or
    result = convertUnknownFileToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLocatable` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLocatableToRaw(TLocatable e) {
    result = convertDeclarationToRaw(e)
    or
    result = convertExprToRaw(e)
    or
    result = convertMatchArmToRaw(e)
    or
    result = convertPatToRaw(e)
    or
    result = convertStmtToRaw(e)
    or
    result = convertTypeRefToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLocation` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLocationToRaw(TLocation e) {
    result = convertDbLocationToRaw(e)
    or
    result = convertUnknownLocationToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPat` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPatToRaw(TPat e) {
    result = convertBindPatToRaw(e)
    or
    result = convertBoxPatToRaw(e)
    or
    result = convertConstBlockPatToRaw(e)
    or
    result = convertLitPatToRaw(e)
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
    result = convertWildPatToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStmtToRaw(TStmt e) {
    result = convertExprStmtToRaw(e)
    or
    result = convertIfLetToRaw(e)
    or
    result = convertItemStmtToRaw(e)
  }
}
