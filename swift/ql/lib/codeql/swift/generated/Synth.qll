/**
 * INTERNAL: Do not use.
 * This module defines the IPA layer on top of raw DB entities, and the conversions between the two
 * layers.
 */

private import codeql.swift.generated.SynthConstructors
private import codeql.swift.generated.Raw

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
    TAvailabilityInfo(Raw::AvailabilityInfo id) { constructAvailabilityInfo(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TComment(Raw::Comment id) { constructComment(id) } or
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
    TDiagnostics(Raw::Diagnostics id) { constructDiagnostics(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TKeyPathComponent(Raw::KeyPathComponent id) { constructKeyPathComponent(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOtherAvailabilitySpec(Raw::OtherAvailabilitySpec id) { constructOtherAvailabilitySpec(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPlatformVersionAvailabilitySpec(Raw::PlatformVersionAvailabilitySpec id) {
      constructPlatformVersionAvailabilitySpec(id)
    } or
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
    TUnspecifiedElement(Raw::UnspecifiedElement id) { constructUnspecifiedElement(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAccessor(Raw::Accessor id) { constructAccessor(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAssociatedTypeDecl(Raw::AssociatedTypeDecl id) { constructAssociatedTypeDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCapturedDecl(Raw::CapturedDecl id) { constructCapturedDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TClassDecl(Raw::ClassDecl id) { constructClassDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConcreteVarDecl(Raw::ConcreteVarDecl id) { constructConcreteVarDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDeinitializer(Raw::Deinitializer id) { constructDeinitializer(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumCaseDecl(Raw::EnumCaseDecl id) { constructEnumCaseDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumDecl(Raw::EnumDecl id) { constructEnumDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumElementDecl(Raw::EnumElementDecl id) { constructEnumElementDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExtensionDecl(Raw::ExtensionDecl id) { constructExtensionDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TGenericTypeParamDecl(Raw::GenericTypeParamDecl id) { constructGenericTypeParamDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIfConfigDecl(Raw::IfConfigDecl id) { constructIfConfigDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TImportDecl(Raw::ImportDecl id) { constructImportDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInfixOperatorDecl(Raw::InfixOperatorDecl id) { constructInfixOperatorDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInitializer(Raw::Initializer id) { constructInitializer(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMissingMemberDecl(Raw::MissingMemberDecl id) { constructMissingMemberDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TModuleDecl(Raw::ModuleDecl id) { constructModuleDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TNamedFunction(Raw::NamedFunction id) { constructNamedFunction(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOpaqueTypeDecl(Raw::OpaqueTypeDecl id) { constructOpaqueTypeDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TParamDecl(Raw::ParamDecl id) { constructParamDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPatternBindingDecl(Raw::PatternBindingDecl id) { constructPatternBindingDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPostfixOperatorDecl(Raw::PostfixOperatorDecl id) { constructPostfixOperatorDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPoundDiagnosticDecl(Raw::PoundDiagnosticDecl id) { constructPoundDiagnosticDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPrecedenceGroupDecl(Raw::PrecedenceGroupDecl id) { constructPrecedenceGroupDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPrefixOperatorDecl(Raw::PrefixOperatorDecl id) { constructPrefixOperatorDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TProtocolDecl(Raw::ProtocolDecl id) { constructProtocolDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TStructDecl(Raw::StructDecl id) { constructStructDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSubscriptDecl(Raw::SubscriptDecl id) { constructSubscriptDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTopLevelCodeDecl(Raw::TopLevelCodeDecl id) { constructTopLevelCodeDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTypeAliasDecl(Raw::TypeAliasDecl id) { constructTypeAliasDecl(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAbiSafeConversionExpr(Raw::AbiSafeConversionExpr id) { constructAbiSafeConversionExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAnyHashableErasureExpr(Raw::AnyHashableErasureExpr id) { constructAnyHashableErasureExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAppliedPropertyWrapperExpr(Raw::AppliedPropertyWrapperExpr id) {
      constructAppliedPropertyWrapperExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TArchetypeToSuperExpr(Raw::ArchetypeToSuperExpr id) { constructArchetypeToSuperExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TArgument(Raw::Argument id) { constructArgument(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TArrayExpr(Raw::ArrayExpr id) { constructArrayExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TArrayToPointerExpr(Raw::ArrayToPointerExpr id) { constructArrayToPointerExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAssignExpr(Raw::AssignExpr id) { constructAssignExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAutoClosureExpr(Raw::AutoClosureExpr id) { constructAutoClosureExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAwaitExpr(Raw::AwaitExpr id) { constructAwaitExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBinaryExpr(Raw::BinaryExpr id) { constructBinaryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBindOptionalExpr(Raw::BindOptionalExpr id) { constructBindOptionalExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBooleanLiteralExpr(Raw::BooleanLiteralExpr id) { constructBooleanLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBridgeFromObjCExpr(Raw::BridgeFromObjCExpr id) { constructBridgeFromObjCExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBridgeToObjCExpr(Raw::BridgeToObjCExpr id) { constructBridgeToObjCExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCallExpr(Raw::CallExpr id) { constructCallExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCaptureListExpr(Raw::CaptureListExpr id) { constructCaptureListExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TClassMetatypeToObjectExpr(Raw::ClassMetatypeToObjectExpr id) {
      constructClassMetatypeToObjectExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TCoerceExpr(Raw::CoerceExpr id) { constructCoerceExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCollectionUpcastConversionExpr(Raw::CollectionUpcastConversionExpr id) {
      constructCollectionUpcastConversionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TConditionalBridgeFromObjCExpr(Raw::ConditionalBridgeFromObjCExpr id) {
      constructConditionalBridgeFromObjCExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TConditionalCheckedCastExpr(Raw::ConditionalCheckedCastExpr id) {
      constructConditionalCheckedCastExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TCovariantFunctionConversionExpr(Raw::CovariantFunctionConversionExpr id) {
      constructCovariantFunctionConversionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TCovariantReturnConversionExpr(Raw::CovariantReturnConversionExpr id) {
      constructCovariantReturnConversionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TDeclRefExpr(Raw::DeclRefExpr id) { constructDeclRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDefaultArgumentExpr(Raw::DefaultArgumentExpr id) { constructDefaultArgumentExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDerivedToBaseExpr(Raw::DerivedToBaseExpr id) { constructDerivedToBaseExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDestructureTupleExpr(Raw::DestructureTupleExpr id) { constructDestructureTupleExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDictionaryExpr(Raw::DictionaryExpr id) { constructDictionaryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDifferentiableFunctionExpr(Raw::DifferentiableFunctionExpr id) {
      constructDifferentiableFunctionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TDifferentiableFunctionExtractOriginalExpr(Raw::DifferentiableFunctionExtractOriginalExpr id) {
      constructDifferentiableFunctionExtractOriginalExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TDiscardAssignmentExpr(Raw::DiscardAssignmentExpr id) { constructDiscardAssignmentExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDotSelfExpr(Raw::DotSelfExpr id) { constructDotSelfExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDotSyntaxBaseIgnoredExpr(Raw::DotSyntaxBaseIgnoredExpr id) {
      constructDotSyntaxBaseIgnoredExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TDotSyntaxCallExpr(Raw::DotSyntaxCallExpr id) { constructDotSyntaxCallExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDynamicMemberRefExpr(Raw::DynamicMemberRefExpr id) { constructDynamicMemberRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDynamicSubscriptExpr(Raw::DynamicSubscriptExpr id) { constructDynamicSubscriptExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDynamicTypeExpr(Raw::DynamicTypeExpr id) { constructDynamicTypeExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumIsCaseExpr(Raw::EnumIsCaseExpr id) { constructEnumIsCaseExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TErasureExpr(Raw::ErasureExpr id) { constructErasureExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TErrorExpr(Raw::ErrorExpr id) { constructErrorExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExistentialMetatypeToObjectExpr(Raw::ExistentialMetatypeToObjectExpr id) {
      constructExistentialMetatypeToObjectExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TExplicitClosureExpr(Raw::ExplicitClosureExpr id) { constructExplicitClosureExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFloatLiteralExpr(Raw::FloatLiteralExpr id) { constructFloatLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TForceTryExpr(Raw::ForceTryExpr id) { constructForceTryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TForceValueExpr(Raw::ForceValueExpr id) { constructForceValueExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TForcedCheckedCastExpr(Raw::ForcedCheckedCastExpr id) { constructForcedCheckedCastExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TForeignObjectConversionExpr(Raw::ForeignObjectConversionExpr id) {
      constructForeignObjectConversionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TFunctionConversionExpr(Raw::FunctionConversionExpr id) { constructFunctionConversionExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIfExpr(Raw::IfExpr id) { constructIfExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInOutExpr(Raw::InOutExpr id) { constructInOutExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInOutToPointerExpr(Raw::InOutToPointerExpr id) { constructInOutToPointerExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInitializerRefCallExpr(Raw::InitializerRefCallExpr id) { constructInitializerRefCallExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInjectIntoOptionalExpr(Raw::InjectIntoOptionalExpr id) { constructInjectIntoOptionalExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIntegerLiteralExpr(Raw::IntegerLiteralExpr id) { constructIntegerLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInterpolatedStringLiteralExpr(Raw::InterpolatedStringLiteralExpr id) {
      constructInterpolatedStringLiteralExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TIsExpr(Raw::IsExpr id) { constructIsExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TKeyPathApplicationExpr(Raw::KeyPathApplicationExpr id) { constructKeyPathApplicationExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TKeyPathDotExpr(Raw::KeyPathDotExpr id) { constructKeyPathDotExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TKeyPathExpr(Raw::KeyPathExpr id) { constructKeyPathExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLazyInitializationExpr(Raw::LazyInitializationExpr id) { constructLazyInitializationExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLinearFunctionExpr(Raw::LinearFunctionExpr id) { constructLinearFunctionExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLinearFunctionExtractOriginalExpr(Raw::LinearFunctionExtractOriginalExpr id) {
      constructLinearFunctionExtractOriginalExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TLinearToDifferentiableFunctionExpr(Raw::LinearToDifferentiableFunctionExpr id) {
      constructLinearToDifferentiableFunctionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TLoadExpr(Raw::LoadExpr id) { constructLoadExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMagicIdentifierLiteralExpr(Raw::MagicIdentifierLiteralExpr id) {
      constructMagicIdentifierLiteralExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TMakeTemporarilyEscapableExpr(Raw::MakeTemporarilyEscapableExpr id) {
      constructMakeTemporarilyEscapableExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TMemberRefExpr(Raw::MemberRefExpr id) { constructMemberRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMetatypeConversionExpr(Raw::MetatypeConversionExpr id) { constructMetatypeConversionExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMethodLookupExpr(Raw::SelfApplyExpr id) { constructMethodLookupExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TNilLiteralExpr(Raw::NilLiteralExpr id) { constructNilLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TObjCSelectorExpr(Raw::ObjCSelectorExpr id) { constructObjCSelectorExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TObjectLiteralExpr(Raw::ObjectLiteralExpr id) { constructObjectLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOneWayExpr(Raw::OneWayExpr id) { constructOneWayExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOpaqueValueExpr(Raw::OpaqueValueExpr id) { constructOpaqueValueExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOpenExistentialExpr(Raw::OpenExistentialExpr id) { constructOpenExistentialExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOptionalEvaluationExpr(Raw::OptionalEvaluationExpr id) { constructOptionalEvaluationExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOptionalTryExpr(Raw::OptionalTryExpr id) { constructOptionalTryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOtherInitializerRefExpr(Raw::OtherInitializerRefExpr id) {
      constructOtherInitializerRefExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TOverloadedDeclRefExpr(Raw::OverloadedDeclRefExpr id) { constructOverloadedDeclRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TParenExpr(Raw::ParenExpr id) { constructParenExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPointerToPointerExpr(Raw::PointerToPointerExpr id) { constructPointerToPointerExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPostfixUnaryExpr(Raw::PostfixUnaryExpr id) { constructPostfixUnaryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPrefixUnaryExpr(Raw::PrefixUnaryExpr id) { constructPrefixUnaryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPropertyWrapperValuePlaceholderExpr(Raw::PropertyWrapperValuePlaceholderExpr id) {
      constructPropertyWrapperValuePlaceholderExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TProtocolMetatypeToObjectExpr(Raw::ProtocolMetatypeToObjectExpr id) {
      constructProtocolMetatypeToObjectExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TRebindSelfInInitializerExpr(Raw::RebindSelfInInitializerExpr id) {
      constructRebindSelfInInitializerExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TRegexLiteralExpr(Raw::RegexLiteralExpr id) { constructRegexLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSequenceExpr(Raw::SequenceExpr id) { constructSequenceExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TStringLiteralExpr(Raw::StringLiteralExpr id) { constructStringLiteralExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TStringToPointerExpr(Raw::StringToPointerExpr id) { constructStringToPointerExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSubscriptExpr(Raw::SubscriptExpr id) { constructSubscriptExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSuperRefExpr(Raw::SuperRefExpr id) { constructSuperRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTapExpr(Raw::TapExpr id) { constructTapExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTryExpr(Raw::TryExpr id) { constructTryExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTupleElementExpr(Raw::TupleElementExpr id) { constructTupleElementExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTupleExpr(Raw::TupleExpr id) { constructTupleExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTypeExpr(Raw::TypeExpr id) { constructTypeExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnderlyingToOpaqueExpr(Raw::UnderlyingToOpaqueExpr id) { constructUnderlyingToOpaqueExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnevaluatedInstanceExpr(Raw::UnevaluatedInstanceExpr id) {
      constructUnevaluatedInstanceExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedDeclRefExpr(Raw::UnresolvedDeclRefExpr id) { constructUnresolvedDeclRefExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedDotExpr(Raw::UnresolvedDotExpr id) { constructUnresolvedDotExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedMemberChainResultExpr(Raw::UnresolvedMemberChainResultExpr id) {
      constructUnresolvedMemberChainResultExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedMemberExpr(Raw::UnresolvedMemberExpr id) { constructUnresolvedMemberExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedPatternExpr(Raw::UnresolvedPatternExpr id) { constructUnresolvedPatternExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedSpecializeExpr(Raw::UnresolvedSpecializeExpr id) {
      constructUnresolvedSpecializeExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedTypeConversionExpr(Raw::UnresolvedTypeConversionExpr id) {
      constructUnresolvedTypeConversionExpr(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TVarargExpansionExpr(Raw::VarargExpansionExpr id) { constructVarargExpansionExpr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TAnyPattern(Raw::AnyPattern id) { constructAnyPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBindingPattern(Raw::BindingPattern id) { constructBindingPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoolPattern(Raw::BoolPattern id) { constructBoolPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumElementPattern(Raw::EnumElementPattern id) { constructEnumElementPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExprPattern(Raw::ExprPattern id) { constructExprPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIsPattern(Raw::IsPattern id) { constructIsPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TNamedPattern(Raw::NamedPattern id) { constructNamedPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOptionalSomePattern(Raw::OptionalSomePattern id) { constructOptionalSomePattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TParenPattern(Raw::ParenPattern id) { constructParenPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTuplePattern(Raw::TuplePattern id) { constructTuplePattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTypedPattern(Raw::TypedPattern id) { constructTypedPattern(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBraceStmt(Raw::BraceStmt id) { constructBraceStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBreakStmt(Raw::BreakStmt id) { constructBreakStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCaseLabelItem(Raw::CaseLabelItem id) { constructCaseLabelItem(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TCaseStmt(Raw::CaseStmt id) { constructCaseStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TConditionElement(Raw::ConditionElement id) { constructConditionElement(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TContinueStmt(Raw::ContinueStmt id) { constructContinueStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDeferStmt(Raw::DeferStmt id) { constructDeferStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDoCatchStmt(Raw::DoCatchStmt id) { constructDoCatchStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDoStmt(Raw::DoStmt id) { constructDoStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFailStmt(Raw::FailStmt id) { constructFailStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFallthroughStmt(Raw::FallthroughStmt id) { constructFallthroughStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TForEachStmt(Raw::ForEachStmt id) { constructForEachStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TGuardStmt(Raw::GuardStmt id) { constructGuardStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TIfStmt(Raw::IfStmt id) { constructIfStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPoundAssertStmt(Raw::PoundAssertStmt id) { constructPoundAssertStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TRepeatWhileStmt(Raw::RepeatWhileStmt id) { constructRepeatWhileStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TReturnStmt(Raw::ReturnStmt id) { constructReturnStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TStmtCondition(Raw::StmtCondition id) { constructStmtCondition(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TSwitchStmt(Raw::SwitchStmt id) { constructSwitchStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TThrowStmt(Raw::ThrowStmt id) { constructThrowStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TWhileStmt(Raw::WhileStmt id) { constructWhileStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TYieldStmt(Raw::YieldStmt id) { constructYieldStmt(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TArraySliceType(Raw::ArraySliceType id) { constructArraySliceType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoundGenericClassType(Raw::BoundGenericClassType id) { constructBoundGenericClassType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoundGenericEnumType(Raw::BoundGenericEnumType id) { constructBoundGenericEnumType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBoundGenericStructType(Raw::BoundGenericStructType id) { constructBoundGenericStructType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinBridgeObjectType(Raw::BuiltinBridgeObjectType id) {
      constructBuiltinBridgeObjectType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinDefaultActorStorageType(Raw::BuiltinDefaultActorStorageType id) {
      constructBuiltinDefaultActorStorageType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinExecutorType(Raw::BuiltinExecutorType id) { constructBuiltinExecutorType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinFloatType(Raw::BuiltinFloatType id) { constructBuiltinFloatType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinIntegerLiteralType(Raw::BuiltinIntegerLiteralType id) {
      constructBuiltinIntegerLiteralType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinIntegerType(Raw::BuiltinIntegerType id) { constructBuiltinIntegerType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinJobType(Raw::BuiltinJobType id) { constructBuiltinJobType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinNativeObjectType(Raw::BuiltinNativeObjectType id) {
      constructBuiltinNativeObjectType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinRawPointerType(Raw::BuiltinRawPointerType id) { constructBuiltinRawPointerType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinRawUnsafeContinuationType(Raw::BuiltinRawUnsafeContinuationType id) {
      constructBuiltinRawUnsafeContinuationType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinUnsafeValueBufferType(Raw::BuiltinUnsafeValueBufferType id) {
      constructBuiltinUnsafeValueBufferType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TBuiltinVectorType(Raw::BuiltinVectorType id) { constructBuiltinVectorType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TClassType(Raw::ClassType id) { constructClassType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDependentMemberType(Raw::DependentMemberType id) { constructDependentMemberType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDictionaryType(Raw::DictionaryType id) { constructDictionaryType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TDynamicSelfType(Raw::DynamicSelfType id) { constructDynamicSelfType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TEnumType(Raw::EnumType id) { constructEnumType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TErrorType(Raw::ErrorType id) { constructErrorType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TExistentialMetatypeType(Raw::ExistentialMetatypeType id) {
      constructExistentialMetatypeType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TExistentialType(Raw::ExistentialType id) { constructExistentialType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TFunctionType(Raw::FunctionType id) { constructFunctionType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TGenericFunctionType(Raw::GenericFunctionType id) { constructGenericFunctionType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TGenericTypeParamType(Raw::GenericTypeParamType id) { constructGenericTypeParamType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TInOutType(Raw::InOutType id) { constructInOutType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TLValueType(Raw::LValueType id) { constructLValueType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TMetatypeType(Raw::MetatypeType id) { constructMetatypeType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TModuleType(Raw::ModuleType id) { constructModuleType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOpaqueTypeArchetypeType(Raw::OpaqueTypeArchetypeType id) {
      constructOpaqueTypeArchetypeType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TOpenedArchetypeType(Raw::OpenedArchetypeType id) { constructOpenedArchetypeType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TOptionalType(Raw::OptionalType id) { constructOptionalType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TParameterizedProtocolType(Raw::ParameterizedProtocolType id) {
      constructParameterizedProtocolType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TParenType(Raw::ParenType id) { constructParenType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TPrimaryArchetypeType(Raw::PrimaryArchetypeType id) { constructPrimaryArchetypeType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TProtocolCompositionType(Raw::ProtocolCompositionType id) {
      constructProtocolCompositionType(id)
    } or
    /**
     * INTERNAL: Do not use.
     */
    TProtocolType(Raw::ProtocolType id) { constructProtocolType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TStructType(Raw::StructType id) { constructStructType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTupleType(Raw::TupleType id) { constructTupleType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTypeAliasType(Raw::TypeAliasType id) { constructTypeAliasType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TTypeRepr(Raw::TypeRepr id) { constructTypeRepr(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnboundGenericType(Raw::UnboundGenericType id) { constructUnboundGenericType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnmanagedStorageType(Raw::UnmanagedStorageType id) { constructUnmanagedStorageType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnownedStorageType(Raw::UnownedStorageType id) { constructUnownedStorageType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TUnresolvedType(Raw::UnresolvedType id) { constructUnresolvedType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TVariadicSequenceType(Raw::VariadicSequenceType id) { constructVariadicSequenceType(id) } or
    /**
     * INTERNAL: Do not use.
     */
    TWeakStorageType(Raw::WeakStorageType id) { constructWeakStorageType(id) }

  /**
   * INTERNAL: Do not use.
   */
  class TAstNode =
    TAvailabilityInfo or TAvailabilitySpec or TCaseLabelItem or TConditionElement or TDecl or
        TExpr or TKeyPathComponent or TPattern or TStmt or TStmtCondition or TTypeRepr;

  /**
   * INTERNAL: Do not use.
   */
  class TAvailabilitySpec = TOtherAvailabilitySpec or TPlatformVersionAvailabilitySpec;

  /**
   * INTERNAL: Do not use.
   */
  class TCallable = TClosureExpr or TFunction;

  /**
   * INTERNAL: Do not use.
   */
  class TErrorElement =
    TErrorExpr or TErrorType or TOverloadedDeclRefExpr or TUnresolvedDeclRefExpr or
        TUnresolvedDotExpr or TUnresolvedMemberChainResultExpr or TUnresolvedMemberExpr or
        TUnresolvedPatternExpr or TUnresolvedSpecializeExpr or TUnresolvedType or
        TUnresolvedTypeConversionExpr or TUnspecifiedElement;

  /**
   * INTERNAL: Do not use.
   */
  class TFile = TDbFile or TUnknownFile;

  /**
   * INTERNAL: Do not use.
   */
  class TLocatable = TArgument or TAstNode or TComment or TDiagnostics or TErrorElement;

  /**
   * INTERNAL: Do not use.
   */
  class TLocation = TDbLocation or TUnknownLocation;

  /**
   * INTERNAL: Do not use.
   */
  class TAbstractStorageDecl = TSubscriptDecl or TVarDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TAbstractTypeParamDecl = TAssociatedTypeDecl or TGenericTypeParamDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TAccessorOrNamedFunction = TAccessor or TNamedFunction;

  /**
   * INTERNAL: Do not use.
   */
  class TDecl =
    TCapturedDecl or TEnumCaseDecl or TExtensionDecl or TIfConfigDecl or TImportDecl or
        TMissingMemberDecl or TOperatorDecl or TPatternBindingDecl or TPoundDiagnosticDecl or
        TPrecedenceGroupDecl or TTopLevelCodeDecl or TValueDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TFunction = TAccessorOrNamedFunction or TDeinitializer or TInitializer;

  /**
   * INTERNAL: Do not use.
   */
  class TGenericContext = TExtensionDecl or TFunction or TGenericTypeDecl or TSubscriptDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TGenericTypeDecl = TNominalTypeDecl or TOpaqueTypeDecl or TTypeAliasDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TNominalTypeDecl = TClassDecl or TEnumDecl or TProtocolDecl or TStructDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TOperatorDecl = TInfixOperatorDecl or TPostfixOperatorDecl or TPrefixOperatorDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TTypeDecl = TAbstractTypeParamDecl or TGenericTypeDecl or TModuleDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TValueDecl = TAbstractStorageDecl or TEnumElementDecl or TFunction or TTypeDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TVarDecl = TConcreteVarDecl or TParamDecl;

  /**
   * INTERNAL: Do not use.
   */
  class TAnyTryExpr = TForceTryExpr or TOptionalTryExpr or TTryExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TApplyExpr =
    TBinaryExpr or TCallExpr or TPostfixUnaryExpr or TPrefixUnaryExpr or TSelfApplyExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TBuiltinLiteralExpr =
    TBooleanLiteralExpr or TMagicIdentifierLiteralExpr or TNumberLiteralExpr or TStringLiteralExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TCheckedCastExpr = TConditionalCheckedCastExpr or TForcedCheckedCastExpr or TIsExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TClosureExpr = TAutoClosureExpr or TExplicitClosureExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TCollectionExpr = TArrayExpr or TDictionaryExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TDynamicLookupExpr = TDynamicMemberRefExpr or TDynamicSubscriptExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TExplicitCastExpr = TCheckedCastExpr or TCoerceExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TExpr =
    TAnyTryExpr or TAppliedPropertyWrapperExpr or TApplyExpr or TAssignExpr or TBindOptionalExpr or
        TCaptureListExpr or TClosureExpr or TCollectionExpr or TDeclRefExpr or
        TDefaultArgumentExpr or TDiscardAssignmentExpr or TDotSyntaxBaseIgnoredExpr or
        TDynamicTypeExpr or TEnumIsCaseExpr or TErrorExpr or TExplicitCastExpr or TForceValueExpr or
        TIdentityExpr or TIfExpr or TImplicitConversionExpr or TInOutExpr or
        TKeyPathApplicationExpr or TKeyPathDotExpr or TKeyPathExpr or TLazyInitializationExpr or
        TLiteralExpr or TLookupExpr or TMakeTemporarilyEscapableExpr or TObjCSelectorExpr or
        TOneWayExpr or TOpaqueValueExpr or TOpenExistentialExpr or TOptionalEvaluationExpr or
        TOtherInitializerRefExpr or TOverloadedDeclRefExpr or
        TPropertyWrapperValuePlaceholderExpr or TRebindSelfInInitializerExpr or TSequenceExpr or
        TSuperRefExpr or TTapExpr or TTupleElementExpr or TTupleExpr or TTypeExpr or
        TUnresolvedDeclRefExpr or TUnresolvedDotExpr or TUnresolvedMemberExpr or
        TUnresolvedPatternExpr or TUnresolvedSpecializeExpr or TVarargExpansionExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TIdentityExpr =
    TAwaitExpr or TDotSelfExpr or TParenExpr or TUnresolvedMemberChainResultExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TImplicitConversionExpr =
    TAbiSafeConversionExpr or TAnyHashableErasureExpr or TArchetypeToSuperExpr or
        TArrayToPointerExpr or TBridgeFromObjCExpr or TBridgeToObjCExpr or
        TClassMetatypeToObjectExpr or TCollectionUpcastConversionExpr or
        TConditionalBridgeFromObjCExpr or TCovariantFunctionConversionExpr or
        TCovariantReturnConversionExpr or TDerivedToBaseExpr or TDestructureTupleExpr or
        TDifferentiableFunctionExpr or TDifferentiableFunctionExtractOriginalExpr or TErasureExpr or
        TExistentialMetatypeToObjectExpr or TForeignObjectConversionExpr or
        TFunctionConversionExpr or TInOutToPointerExpr or TInjectIntoOptionalExpr or
        TLinearFunctionExpr or TLinearFunctionExtractOriginalExpr or
        TLinearToDifferentiableFunctionExpr or TLoadExpr or TMetatypeConversionExpr or
        TPointerToPointerExpr or TProtocolMetatypeToObjectExpr or TStringToPointerExpr or
        TUnderlyingToOpaqueExpr or TUnevaluatedInstanceExpr or TUnresolvedTypeConversionExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TLiteralExpr =
    TBuiltinLiteralExpr or TInterpolatedStringLiteralExpr or TNilLiteralExpr or
        TObjectLiteralExpr or TRegexLiteralExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TLookupExpr = TDynamicLookupExpr or TMemberRefExpr or TMethodLookupExpr or TSubscriptExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TNumberLiteralExpr = TFloatLiteralExpr or TIntegerLiteralExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TSelfApplyExpr = TDotSyntaxCallExpr or TInitializerRefCallExpr;

  /**
   * INTERNAL: Do not use.
   */
  class TPattern =
    TAnyPattern or TBindingPattern or TBoolPattern or TEnumElementPattern or TExprPattern or
        TIsPattern or TNamedPattern or TOptionalSomePattern or TParenPattern or TTuplePattern or
        TTypedPattern;

  /**
   * INTERNAL: Do not use.
   */
  class TLabeledConditionalStmt = TGuardStmt or TIfStmt or TWhileStmt;

  /**
   * INTERNAL: Do not use.
   */
  class TLabeledStmt =
    TDoCatchStmt or TDoStmt or TForEachStmt or TLabeledConditionalStmt or TRepeatWhileStmt or
        TSwitchStmt;

  /**
   * INTERNAL: Do not use.
   */
  class TStmt =
    TBraceStmt or TBreakStmt or TCaseStmt or TContinueStmt or TDeferStmt or TFailStmt or
        TFallthroughStmt or TLabeledStmt or TPoundAssertStmt or TReturnStmt or TThrowStmt or
        TYieldStmt;

  /**
   * INTERNAL: Do not use.
   */
  class TAnyBuiltinIntegerType = TBuiltinIntegerLiteralType or TBuiltinIntegerType;

  /**
   * INTERNAL: Do not use.
   */
  class TAnyFunctionType = TFunctionType or TGenericFunctionType;

  /**
   * INTERNAL: Do not use.
   */
  class TAnyGenericType = TNominalOrBoundGenericNominalType or TUnboundGenericType;

  /**
   * INTERNAL: Do not use.
   */
  class TAnyMetatypeType = TExistentialMetatypeType or TMetatypeType;

  /**
   * INTERNAL: Do not use.
   */
  class TArchetypeType = TOpaqueTypeArchetypeType or TOpenedArchetypeType or TPrimaryArchetypeType;

  /**
   * INTERNAL: Do not use.
   */
  class TBoundGenericType =
    TBoundGenericClassType or TBoundGenericEnumType or TBoundGenericStructType;

  /**
   * INTERNAL: Do not use.
   */
  class TBuiltinType =
    TAnyBuiltinIntegerType or TBuiltinBridgeObjectType or TBuiltinDefaultActorStorageType or
        TBuiltinExecutorType or TBuiltinFloatType or TBuiltinJobType or TBuiltinNativeObjectType or
        TBuiltinRawPointerType or TBuiltinRawUnsafeContinuationType or
        TBuiltinUnsafeValueBufferType or TBuiltinVectorType;

  /**
   * INTERNAL: Do not use.
   */
  class TNominalOrBoundGenericNominalType = TBoundGenericType or TNominalType;

  /**
   * INTERNAL: Do not use.
   */
  class TNominalType = TClassType or TEnumType or TProtocolType or TStructType;

  /**
   * INTERNAL: Do not use.
   */
  class TReferenceStorageType = TUnmanagedStorageType or TUnownedStorageType or TWeakStorageType;

  /**
   * INTERNAL: Do not use.
   */
  class TSubstitutableType = TArchetypeType or TGenericTypeParamType;

  /**
   * INTERNAL: Do not use.
   */
  class TSugarType = TParenType or TSyntaxSugarType or TTypeAliasType;

  /**
   * INTERNAL: Do not use.
   */
  class TSyntaxSugarType = TDictionaryType or TUnarySyntaxSugarType;

  /**
   * INTERNAL: Do not use.
   */
  class TType =
    TAnyFunctionType or TAnyGenericType or TAnyMetatypeType or TBuiltinType or
        TDependentMemberType or TDynamicSelfType or TErrorType or TExistentialType or TInOutType or
        TLValueType or TModuleType or TParameterizedProtocolType or TProtocolCompositionType or
        TReferenceStorageType or TSubstitutableType or TSugarType or TTupleType or TUnresolvedType;

  /**
   * INTERNAL: Do not use.
   */
  class TUnarySyntaxSugarType = TArraySliceType or TOptionalType or TVariadicSequenceType;

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAvailabilityInfo`, if possible.
   */
  cached
  TAvailabilityInfo convertAvailabilityInfoFromRaw(Raw::Element e) { result = TAvailabilityInfo(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TComment`, if possible.
   */
  cached
  TComment convertCommentFromRaw(Raw::Element e) { result = TComment(e) }

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
   * Converts a raw element to a synthesized `TDiagnostics`, if possible.
   */
  cached
  TDiagnostics convertDiagnosticsFromRaw(Raw::Element e) { result = TDiagnostics(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TKeyPathComponent`, if possible.
   */
  cached
  TKeyPathComponent convertKeyPathComponentFromRaw(Raw::Element e) { result = TKeyPathComponent(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOtherAvailabilitySpec`, if possible.
   */
  cached
  TOtherAvailabilitySpec convertOtherAvailabilitySpecFromRaw(Raw::Element e) {
    result = TOtherAvailabilitySpec(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPlatformVersionAvailabilitySpec`, if possible.
   */
  cached
  TPlatformVersionAvailabilitySpec convertPlatformVersionAvailabilitySpecFromRaw(Raw::Element e) {
    result = TPlatformVersionAvailabilitySpec(e)
  }

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
   * Converts a raw element to a synthesized `TUnspecifiedElement`, if possible.
   */
  cached
  TUnspecifiedElement convertUnspecifiedElementFromRaw(Raw::Element e) {
    result = TUnspecifiedElement(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAccessor`, if possible.
   */
  cached
  TAccessor convertAccessorFromRaw(Raw::Element e) { result = TAccessor(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAssociatedTypeDecl`, if possible.
   */
  cached
  TAssociatedTypeDecl convertAssociatedTypeDeclFromRaw(Raw::Element e) {
    result = TAssociatedTypeDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCapturedDecl`, if possible.
   */
  cached
  TCapturedDecl convertCapturedDeclFromRaw(Raw::Element e) { result = TCapturedDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TClassDecl`, if possible.
   */
  cached
  TClassDecl convertClassDeclFromRaw(Raw::Element e) { result = TClassDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConcreteVarDecl`, if possible.
   */
  cached
  TConcreteVarDecl convertConcreteVarDeclFromRaw(Raw::Element e) { result = TConcreteVarDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDeinitializer`, if possible.
   */
  cached
  TDeinitializer convertDeinitializerFromRaw(Raw::Element e) { result = TDeinitializer(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumCaseDecl`, if possible.
   */
  cached
  TEnumCaseDecl convertEnumCaseDeclFromRaw(Raw::Element e) { result = TEnumCaseDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumDecl`, if possible.
   */
  cached
  TEnumDecl convertEnumDeclFromRaw(Raw::Element e) { result = TEnumDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumElementDecl`, if possible.
   */
  cached
  TEnumElementDecl convertEnumElementDeclFromRaw(Raw::Element e) { result = TEnumElementDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExtensionDecl`, if possible.
   */
  cached
  TExtensionDecl convertExtensionDeclFromRaw(Raw::Element e) { result = TExtensionDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TGenericTypeParamDecl`, if possible.
   */
  cached
  TGenericTypeParamDecl convertGenericTypeParamDeclFromRaw(Raw::Element e) {
    result = TGenericTypeParamDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIfConfigDecl`, if possible.
   */
  cached
  TIfConfigDecl convertIfConfigDeclFromRaw(Raw::Element e) { result = TIfConfigDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TImportDecl`, if possible.
   */
  cached
  TImportDecl convertImportDeclFromRaw(Raw::Element e) { result = TImportDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInfixOperatorDecl`, if possible.
   */
  cached
  TInfixOperatorDecl convertInfixOperatorDeclFromRaw(Raw::Element e) {
    result = TInfixOperatorDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInitializer`, if possible.
   */
  cached
  TInitializer convertInitializerFromRaw(Raw::Element e) { result = TInitializer(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMissingMemberDecl`, if possible.
   */
  cached
  TMissingMemberDecl convertMissingMemberDeclFromRaw(Raw::Element e) {
    result = TMissingMemberDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TModuleDecl`, if possible.
   */
  cached
  TModuleDecl convertModuleDeclFromRaw(Raw::Element e) { result = TModuleDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TNamedFunction`, if possible.
   */
  cached
  TNamedFunction convertNamedFunctionFromRaw(Raw::Element e) { result = TNamedFunction(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOpaqueTypeDecl`, if possible.
   */
  cached
  TOpaqueTypeDecl convertOpaqueTypeDeclFromRaw(Raw::Element e) { result = TOpaqueTypeDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TParamDecl`, if possible.
   */
  cached
  TParamDecl convertParamDeclFromRaw(Raw::Element e) { result = TParamDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPatternBindingDecl`, if possible.
   */
  cached
  TPatternBindingDecl convertPatternBindingDeclFromRaw(Raw::Element e) {
    result = TPatternBindingDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPostfixOperatorDecl`, if possible.
   */
  cached
  TPostfixOperatorDecl convertPostfixOperatorDeclFromRaw(Raw::Element e) {
    result = TPostfixOperatorDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPoundDiagnosticDecl`, if possible.
   */
  cached
  TPoundDiagnosticDecl convertPoundDiagnosticDeclFromRaw(Raw::Element e) {
    result = TPoundDiagnosticDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPrecedenceGroupDecl`, if possible.
   */
  cached
  TPrecedenceGroupDecl convertPrecedenceGroupDeclFromRaw(Raw::Element e) {
    result = TPrecedenceGroupDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPrefixOperatorDecl`, if possible.
   */
  cached
  TPrefixOperatorDecl convertPrefixOperatorDeclFromRaw(Raw::Element e) {
    result = TPrefixOperatorDecl(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TProtocolDecl`, if possible.
   */
  cached
  TProtocolDecl convertProtocolDeclFromRaw(Raw::Element e) { result = TProtocolDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TStructDecl`, if possible.
   */
  cached
  TStructDecl convertStructDeclFromRaw(Raw::Element e) { result = TStructDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSubscriptDecl`, if possible.
   */
  cached
  TSubscriptDecl convertSubscriptDeclFromRaw(Raw::Element e) { result = TSubscriptDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTopLevelCodeDecl`, if possible.
   */
  cached
  TTopLevelCodeDecl convertTopLevelCodeDeclFromRaw(Raw::Element e) { result = TTopLevelCodeDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTypeAliasDecl`, if possible.
   */
  cached
  TTypeAliasDecl convertTypeAliasDeclFromRaw(Raw::Element e) { result = TTypeAliasDecl(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAbiSafeConversionExpr`, if possible.
   */
  cached
  TAbiSafeConversionExpr convertAbiSafeConversionExprFromRaw(Raw::Element e) {
    result = TAbiSafeConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAnyHashableErasureExpr`, if possible.
   */
  cached
  TAnyHashableErasureExpr convertAnyHashableErasureExprFromRaw(Raw::Element e) {
    result = TAnyHashableErasureExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAppliedPropertyWrapperExpr`, if possible.
   */
  cached
  TAppliedPropertyWrapperExpr convertAppliedPropertyWrapperExprFromRaw(Raw::Element e) {
    result = TAppliedPropertyWrapperExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArchetypeToSuperExpr`, if possible.
   */
  cached
  TArchetypeToSuperExpr convertArchetypeToSuperExprFromRaw(Raw::Element e) {
    result = TArchetypeToSuperExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArgument`, if possible.
   */
  cached
  TArgument convertArgumentFromRaw(Raw::Element e) { result = TArgument(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArrayExpr`, if possible.
   */
  cached
  TArrayExpr convertArrayExprFromRaw(Raw::Element e) { result = TArrayExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArrayToPointerExpr`, if possible.
   */
  cached
  TArrayToPointerExpr convertArrayToPointerExprFromRaw(Raw::Element e) {
    result = TArrayToPointerExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAssignExpr`, if possible.
   */
  cached
  TAssignExpr convertAssignExprFromRaw(Raw::Element e) { result = TAssignExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAutoClosureExpr`, if possible.
   */
  cached
  TAutoClosureExpr convertAutoClosureExprFromRaw(Raw::Element e) { result = TAutoClosureExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAwaitExpr`, if possible.
   */
  cached
  TAwaitExpr convertAwaitExprFromRaw(Raw::Element e) { result = TAwaitExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBinaryExpr`, if possible.
   */
  cached
  TBinaryExpr convertBinaryExprFromRaw(Raw::Element e) { result = TBinaryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBindOptionalExpr`, if possible.
   */
  cached
  TBindOptionalExpr convertBindOptionalExprFromRaw(Raw::Element e) { result = TBindOptionalExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBooleanLiteralExpr`, if possible.
   */
  cached
  TBooleanLiteralExpr convertBooleanLiteralExprFromRaw(Raw::Element e) {
    result = TBooleanLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBridgeFromObjCExpr`, if possible.
   */
  cached
  TBridgeFromObjCExpr convertBridgeFromObjCExprFromRaw(Raw::Element e) {
    result = TBridgeFromObjCExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBridgeToObjCExpr`, if possible.
   */
  cached
  TBridgeToObjCExpr convertBridgeToObjCExprFromRaw(Raw::Element e) { result = TBridgeToObjCExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCallExpr`, if possible.
   */
  cached
  TCallExpr convertCallExprFromRaw(Raw::Element e) { result = TCallExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCaptureListExpr`, if possible.
   */
  cached
  TCaptureListExpr convertCaptureListExprFromRaw(Raw::Element e) { result = TCaptureListExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TClassMetatypeToObjectExpr`, if possible.
   */
  cached
  TClassMetatypeToObjectExpr convertClassMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TClassMetatypeToObjectExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCoerceExpr`, if possible.
   */
  cached
  TCoerceExpr convertCoerceExprFromRaw(Raw::Element e) { result = TCoerceExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCollectionUpcastConversionExpr`, if possible.
   */
  cached
  TCollectionUpcastConversionExpr convertCollectionUpcastConversionExprFromRaw(Raw::Element e) {
    result = TCollectionUpcastConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConditionalBridgeFromObjCExpr`, if possible.
   */
  cached
  TConditionalBridgeFromObjCExpr convertConditionalBridgeFromObjCExprFromRaw(Raw::Element e) {
    result = TConditionalBridgeFromObjCExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConditionalCheckedCastExpr`, if possible.
   */
  cached
  TConditionalCheckedCastExpr convertConditionalCheckedCastExprFromRaw(Raw::Element e) {
    result = TConditionalCheckedCastExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCovariantFunctionConversionExpr`, if possible.
   */
  cached
  TCovariantFunctionConversionExpr convertCovariantFunctionConversionExprFromRaw(Raw::Element e) {
    result = TCovariantFunctionConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCovariantReturnConversionExpr`, if possible.
   */
  cached
  TCovariantReturnConversionExpr convertCovariantReturnConversionExprFromRaw(Raw::Element e) {
    result = TCovariantReturnConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDeclRefExpr`, if possible.
   */
  cached
  TDeclRefExpr convertDeclRefExprFromRaw(Raw::Element e) { result = TDeclRefExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDefaultArgumentExpr`, if possible.
   */
  cached
  TDefaultArgumentExpr convertDefaultArgumentExprFromRaw(Raw::Element e) {
    result = TDefaultArgumentExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDerivedToBaseExpr`, if possible.
   */
  cached
  TDerivedToBaseExpr convertDerivedToBaseExprFromRaw(Raw::Element e) {
    result = TDerivedToBaseExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDestructureTupleExpr`, if possible.
   */
  cached
  TDestructureTupleExpr convertDestructureTupleExprFromRaw(Raw::Element e) {
    result = TDestructureTupleExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDictionaryExpr`, if possible.
   */
  cached
  TDictionaryExpr convertDictionaryExprFromRaw(Raw::Element e) { result = TDictionaryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDifferentiableFunctionExpr`, if possible.
   */
  cached
  TDifferentiableFunctionExpr convertDifferentiableFunctionExprFromRaw(Raw::Element e) {
    result = TDifferentiableFunctionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDifferentiableFunctionExtractOriginalExpr`, if possible.
   */
  cached
  TDifferentiableFunctionExtractOriginalExpr convertDifferentiableFunctionExtractOriginalExprFromRaw(
    Raw::Element e
  ) {
    result = TDifferentiableFunctionExtractOriginalExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDiscardAssignmentExpr`, if possible.
   */
  cached
  TDiscardAssignmentExpr convertDiscardAssignmentExprFromRaw(Raw::Element e) {
    result = TDiscardAssignmentExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDotSelfExpr`, if possible.
   */
  cached
  TDotSelfExpr convertDotSelfExprFromRaw(Raw::Element e) { result = TDotSelfExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDotSyntaxBaseIgnoredExpr`, if possible.
   */
  cached
  TDotSyntaxBaseIgnoredExpr convertDotSyntaxBaseIgnoredExprFromRaw(Raw::Element e) {
    result = TDotSyntaxBaseIgnoredExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDotSyntaxCallExpr`, if possible.
   */
  cached
  TDotSyntaxCallExpr convertDotSyntaxCallExprFromRaw(Raw::Element e) {
    result = TDotSyntaxCallExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDynamicMemberRefExpr`, if possible.
   */
  cached
  TDynamicMemberRefExpr convertDynamicMemberRefExprFromRaw(Raw::Element e) {
    result = TDynamicMemberRefExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDynamicSubscriptExpr`, if possible.
   */
  cached
  TDynamicSubscriptExpr convertDynamicSubscriptExprFromRaw(Raw::Element e) {
    result = TDynamicSubscriptExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDynamicTypeExpr`, if possible.
   */
  cached
  TDynamicTypeExpr convertDynamicTypeExprFromRaw(Raw::Element e) { result = TDynamicTypeExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumIsCaseExpr`, if possible.
   */
  cached
  TEnumIsCaseExpr convertEnumIsCaseExprFromRaw(Raw::Element e) { result = TEnumIsCaseExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TErasureExpr`, if possible.
   */
  cached
  TErasureExpr convertErasureExprFromRaw(Raw::Element e) { result = TErasureExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TErrorExpr`, if possible.
   */
  cached
  TErrorExpr convertErrorExprFromRaw(Raw::Element e) { result = TErrorExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExistentialMetatypeToObjectExpr`, if possible.
   */
  cached
  TExistentialMetatypeToObjectExpr convertExistentialMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TExistentialMetatypeToObjectExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExplicitClosureExpr`, if possible.
   */
  cached
  TExplicitClosureExpr convertExplicitClosureExprFromRaw(Raw::Element e) {
    result = TExplicitClosureExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFloatLiteralExpr`, if possible.
   */
  cached
  TFloatLiteralExpr convertFloatLiteralExprFromRaw(Raw::Element e) { result = TFloatLiteralExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TForceTryExpr`, if possible.
   */
  cached
  TForceTryExpr convertForceTryExprFromRaw(Raw::Element e) { result = TForceTryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TForceValueExpr`, if possible.
   */
  cached
  TForceValueExpr convertForceValueExprFromRaw(Raw::Element e) { result = TForceValueExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TForcedCheckedCastExpr`, if possible.
   */
  cached
  TForcedCheckedCastExpr convertForcedCheckedCastExprFromRaw(Raw::Element e) {
    result = TForcedCheckedCastExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TForeignObjectConversionExpr`, if possible.
   */
  cached
  TForeignObjectConversionExpr convertForeignObjectConversionExprFromRaw(Raw::Element e) {
    result = TForeignObjectConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFunctionConversionExpr`, if possible.
   */
  cached
  TFunctionConversionExpr convertFunctionConversionExprFromRaw(Raw::Element e) {
    result = TFunctionConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIfExpr`, if possible.
   */
  cached
  TIfExpr convertIfExprFromRaw(Raw::Element e) { result = TIfExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInOutExpr`, if possible.
   */
  cached
  TInOutExpr convertInOutExprFromRaw(Raw::Element e) { result = TInOutExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInOutToPointerExpr`, if possible.
   */
  cached
  TInOutToPointerExpr convertInOutToPointerExprFromRaw(Raw::Element e) {
    result = TInOutToPointerExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInitializerRefCallExpr`, if possible.
   */
  cached
  TInitializerRefCallExpr convertInitializerRefCallExprFromRaw(Raw::Element e) {
    result = TInitializerRefCallExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInjectIntoOptionalExpr`, if possible.
   */
  cached
  TInjectIntoOptionalExpr convertInjectIntoOptionalExprFromRaw(Raw::Element e) {
    result = TInjectIntoOptionalExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIntegerLiteralExpr`, if possible.
   */
  cached
  TIntegerLiteralExpr convertIntegerLiteralExprFromRaw(Raw::Element e) {
    result = TIntegerLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInterpolatedStringLiteralExpr`, if possible.
   */
  cached
  TInterpolatedStringLiteralExpr convertInterpolatedStringLiteralExprFromRaw(Raw::Element e) {
    result = TInterpolatedStringLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIsExpr`, if possible.
   */
  cached
  TIsExpr convertIsExprFromRaw(Raw::Element e) { result = TIsExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TKeyPathApplicationExpr`, if possible.
   */
  cached
  TKeyPathApplicationExpr convertKeyPathApplicationExprFromRaw(Raw::Element e) {
    result = TKeyPathApplicationExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TKeyPathDotExpr`, if possible.
   */
  cached
  TKeyPathDotExpr convertKeyPathDotExprFromRaw(Raw::Element e) { result = TKeyPathDotExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TKeyPathExpr`, if possible.
   */
  cached
  TKeyPathExpr convertKeyPathExprFromRaw(Raw::Element e) { result = TKeyPathExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLazyInitializationExpr`, if possible.
   */
  cached
  TLazyInitializationExpr convertLazyInitializationExprFromRaw(Raw::Element e) {
    result = TLazyInitializationExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLinearFunctionExpr`, if possible.
   */
  cached
  TLinearFunctionExpr convertLinearFunctionExprFromRaw(Raw::Element e) {
    result = TLinearFunctionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLinearFunctionExtractOriginalExpr`, if possible.
   */
  cached
  TLinearFunctionExtractOriginalExpr convertLinearFunctionExtractOriginalExprFromRaw(Raw::Element e) {
    result = TLinearFunctionExtractOriginalExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLinearToDifferentiableFunctionExpr`, if possible.
   */
  cached
  TLinearToDifferentiableFunctionExpr convertLinearToDifferentiableFunctionExprFromRaw(
    Raw::Element e
  ) {
    result = TLinearToDifferentiableFunctionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLoadExpr`, if possible.
   */
  cached
  TLoadExpr convertLoadExprFromRaw(Raw::Element e) { result = TLoadExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMagicIdentifierLiteralExpr`, if possible.
   */
  cached
  TMagicIdentifierLiteralExpr convertMagicIdentifierLiteralExprFromRaw(Raw::Element e) {
    result = TMagicIdentifierLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMakeTemporarilyEscapableExpr`, if possible.
   */
  cached
  TMakeTemporarilyEscapableExpr convertMakeTemporarilyEscapableExprFromRaw(Raw::Element e) {
    result = TMakeTemporarilyEscapableExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMemberRefExpr`, if possible.
   */
  cached
  TMemberRefExpr convertMemberRefExprFromRaw(Raw::Element e) { result = TMemberRefExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMetatypeConversionExpr`, if possible.
   */
  cached
  TMetatypeConversionExpr convertMetatypeConversionExprFromRaw(Raw::Element e) {
    result = TMetatypeConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMethodLookupExpr`, if possible.
   */
  cached
  TMethodLookupExpr convertMethodLookupExprFromRaw(Raw::Element e) { result = TMethodLookupExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TNilLiteralExpr`, if possible.
   */
  cached
  TNilLiteralExpr convertNilLiteralExprFromRaw(Raw::Element e) { result = TNilLiteralExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TObjCSelectorExpr`, if possible.
   */
  cached
  TObjCSelectorExpr convertObjCSelectorExprFromRaw(Raw::Element e) { result = TObjCSelectorExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TObjectLiteralExpr`, if possible.
   */
  cached
  TObjectLiteralExpr convertObjectLiteralExprFromRaw(Raw::Element e) {
    result = TObjectLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOneWayExpr`, if possible.
   */
  cached
  TOneWayExpr convertOneWayExprFromRaw(Raw::Element e) { result = TOneWayExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOpaqueValueExpr`, if possible.
   */
  cached
  TOpaqueValueExpr convertOpaqueValueExprFromRaw(Raw::Element e) { result = TOpaqueValueExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOpenExistentialExpr`, if possible.
   */
  cached
  TOpenExistentialExpr convertOpenExistentialExprFromRaw(Raw::Element e) {
    result = TOpenExistentialExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOptionalEvaluationExpr`, if possible.
   */
  cached
  TOptionalEvaluationExpr convertOptionalEvaluationExprFromRaw(Raw::Element e) {
    result = TOptionalEvaluationExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOptionalTryExpr`, if possible.
   */
  cached
  TOptionalTryExpr convertOptionalTryExprFromRaw(Raw::Element e) { result = TOptionalTryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOtherInitializerRefExpr`, if possible.
   */
  cached
  TOtherInitializerRefExpr convertOtherInitializerRefExprFromRaw(Raw::Element e) {
    result = TOtherInitializerRefExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOverloadedDeclRefExpr`, if possible.
   */
  cached
  TOverloadedDeclRefExpr convertOverloadedDeclRefExprFromRaw(Raw::Element e) {
    result = TOverloadedDeclRefExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TParenExpr`, if possible.
   */
  cached
  TParenExpr convertParenExprFromRaw(Raw::Element e) { result = TParenExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPointerToPointerExpr`, if possible.
   */
  cached
  TPointerToPointerExpr convertPointerToPointerExprFromRaw(Raw::Element e) {
    result = TPointerToPointerExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPostfixUnaryExpr`, if possible.
   */
  cached
  TPostfixUnaryExpr convertPostfixUnaryExprFromRaw(Raw::Element e) { result = TPostfixUnaryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPrefixUnaryExpr`, if possible.
   */
  cached
  TPrefixUnaryExpr convertPrefixUnaryExprFromRaw(Raw::Element e) { result = TPrefixUnaryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPropertyWrapperValuePlaceholderExpr`, if possible.
   */
  cached
  TPropertyWrapperValuePlaceholderExpr convertPropertyWrapperValuePlaceholderExprFromRaw(
    Raw::Element e
  ) {
    result = TPropertyWrapperValuePlaceholderExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TProtocolMetatypeToObjectExpr`, if possible.
   */
  cached
  TProtocolMetatypeToObjectExpr convertProtocolMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TProtocolMetatypeToObjectExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRebindSelfInInitializerExpr`, if possible.
   */
  cached
  TRebindSelfInInitializerExpr convertRebindSelfInInitializerExprFromRaw(Raw::Element e) {
    result = TRebindSelfInInitializerExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRegexLiteralExpr`, if possible.
   */
  cached
  TRegexLiteralExpr convertRegexLiteralExprFromRaw(Raw::Element e) { result = TRegexLiteralExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSequenceExpr`, if possible.
   */
  cached
  TSequenceExpr convertSequenceExprFromRaw(Raw::Element e) { result = TSequenceExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TStringLiteralExpr`, if possible.
   */
  cached
  TStringLiteralExpr convertStringLiteralExprFromRaw(Raw::Element e) {
    result = TStringLiteralExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TStringToPointerExpr`, if possible.
   */
  cached
  TStringToPointerExpr convertStringToPointerExprFromRaw(Raw::Element e) {
    result = TStringToPointerExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSubscriptExpr`, if possible.
   */
  cached
  TSubscriptExpr convertSubscriptExprFromRaw(Raw::Element e) { result = TSubscriptExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSuperRefExpr`, if possible.
   */
  cached
  TSuperRefExpr convertSuperRefExprFromRaw(Raw::Element e) { result = TSuperRefExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTapExpr`, if possible.
   */
  cached
  TTapExpr convertTapExprFromRaw(Raw::Element e) { result = TTapExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTryExpr`, if possible.
   */
  cached
  TTryExpr convertTryExprFromRaw(Raw::Element e) { result = TTryExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTupleElementExpr`, if possible.
   */
  cached
  TTupleElementExpr convertTupleElementExprFromRaw(Raw::Element e) { result = TTupleElementExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTupleExpr`, if possible.
   */
  cached
  TTupleExpr convertTupleExprFromRaw(Raw::Element e) { result = TTupleExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTypeExpr`, if possible.
   */
  cached
  TTypeExpr convertTypeExprFromRaw(Raw::Element e) { result = TTypeExpr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnderlyingToOpaqueExpr`, if possible.
   */
  cached
  TUnderlyingToOpaqueExpr convertUnderlyingToOpaqueExprFromRaw(Raw::Element e) {
    result = TUnderlyingToOpaqueExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnevaluatedInstanceExpr`, if possible.
   */
  cached
  TUnevaluatedInstanceExpr convertUnevaluatedInstanceExprFromRaw(Raw::Element e) {
    result = TUnevaluatedInstanceExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedDeclRefExpr`, if possible.
   */
  cached
  TUnresolvedDeclRefExpr convertUnresolvedDeclRefExprFromRaw(Raw::Element e) {
    result = TUnresolvedDeclRefExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedDotExpr`, if possible.
   */
  cached
  TUnresolvedDotExpr convertUnresolvedDotExprFromRaw(Raw::Element e) {
    result = TUnresolvedDotExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedMemberChainResultExpr`, if possible.
   */
  cached
  TUnresolvedMemberChainResultExpr convertUnresolvedMemberChainResultExprFromRaw(Raw::Element e) {
    result = TUnresolvedMemberChainResultExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedMemberExpr`, if possible.
   */
  cached
  TUnresolvedMemberExpr convertUnresolvedMemberExprFromRaw(Raw::Element e) {
    result = TUnresolvedMemberExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedPatternExpr`, if possible.
   */
  cached
  TUnresolvedPatternExpr convertUnresolvedPatternExprFromRaw(Raw::Element e) {
    result = TUnresolvedPatternExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedSpecializeExpr`, if possible.
   */
  cached
  TUnresolvedSpecializeExpr convertUnresolvedSpecializeExprFromRaw(Raw::Element e) {
    result = TUnresolvedSpecializeExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedTypeConversionExpr`, if possible.
   */
  cached
  TUnresolvedTypeConversionExpr convertUnresolvedTypeConversionExprFromRaw(Raw::Element e) {
    result = TUnresolvedTypeConversionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TVarargExpansionExpr`, if possible.
   */
  cached
  TVarargExpansionExpr convertVarargExpansionExprFromRaw(Raw::Element e) {
    result = TVarargExpansionExpr(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TAnyPattern`, if possible.
   */
  cached
  TAnyPattern convertAnyPatternFromRaw(Raw::Element e) { result = TAnyPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBindingPattern`, if possible.
   */
  cached
  TBindingPattern convertBindingPatternFromRaw(Raw::Element e) { result = TBindingPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoolPattern`, if possible.
   */
  cached
  TBoolPattern convertBoolPatternFromRaw(Raw::Element e) { result = TBoolPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumElementPattern`, if possible.
   */
  cached
  TEnumElementPattern convertEnumElementPatternFromRaw(Raw::Element e) {
    result = TEnumElementPattern(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExprPattern`, if possible.
   */
  cached
  TExprPattern convertExprPatternFromRaw(Raw::Element e) { result = TExprPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIsPattern`, if possible.
   */
  cached
  TIsPattern convertIsPatternFromRaw(Raw::Element e) { result = TIsPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TNamedPattern`, if possible.
   */
  cached
  TNamedPattern convertNamedPatternFromRaw(Raw::Element e) { result = TNamedPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOptionalSomePattern`, if possible.
   */
  cached
  TOptionalSomePattern convertOptionalSomePatternFromRaw(Raw::Element e) {
    result = TOptionalSomePattern(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TParenPattern`, if possible.
   */
  cached
  TParenPattern convertParenPatternFromRaw(Raw::Element e) { result = TParenPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTuplePattern`, if possible.
   */
  cached
  TTuplePattern convertTuplePatternFromRaw(Raw::Element e) { result = TTuplePattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTypedPattern`, if possible.
   */
  cached
  TTypedPattern convertTypedPatternFromRaw(Raw::Element e) { result = TTypedPattern(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBraceStmt`, if possible.
   */
  cached
  TBraceStmt convertBraceStmtFromRaw(Raw::Element e) { result = TBraceStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBreakStmt`, if possible.
   */
  cached
  TBreakStmt convertBreakStmtFromRaw(Raw::Element e) { result = TBreakStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCaseLabelItem`, if possible.
   */
  cached
  TCaseLabelItem convertCaseLabelItemFromRaw(Raw::Element e) { result = TCaseLabelItem(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TCaseStmt`, if possible.
   */
  cached
  TCaseStmt convertCaseStmtFromRaw(Raw::Element e) { result = TCaseStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TConditionElement`, if possible.
   */
  cached
  TConditionElement convertConditionElementFromRaw(Raw::Element e) { result = TConditionElement(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TContinueStmt`, if possible.
   */
  cached
  TContinueStmt convertContinueStmtFromRaw(Raw::Element e) { result = TContinueStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDeferStmt`, if possible.
   */
  cached
  TDeferStmt convertDeferStmtFromRaw(Raw::Element e) { result = TDeferStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDoCatchStmt`, if possible.
   */
  cached
  TDoCatchStmt convertDoCatchStmtFromRaw(Raw::Element e) { result = TDoCatchStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDoStmt`, if possible.
   */
  cached
  TDoStmt convertDoStmtFromRaw(Raw::Element e) { result = TDoStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFailStmt`, if possible.
   */
  cached
  TFailStmt convertFailStmtFromRaw(Raw::Element e) { result = TFailStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFallthroughStmt`, if possible.
   */
  cached
  TFallthroughStmt convertFallthroughStmtFromRaw(Raw::Element e) { result = TFallthroughStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TForEachStmt`, if possible.
   */
  cached
  TForEachStmt convertForEachStmtFromRaw(Raw::Element e) { result = TForEachStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TGuardStmt`, if possible.
   */
  cached
  TGuardStmt convertGuardStmtFromRaw(Raw::Element e) { result = TGuardStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TIfStmt`, if possible.
   */
  cached
  TIfStmt convertIfStmtFromRaw(Raw::Element e) { result = TIfStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPoundAssertStmt`, if possible.
   */
  cached
  TPoundAssertStmt convertPoundAssertStmtFromRaw(Raw::Element e) { result = TPoundAssertStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TRepeatWhileStmt`, if possible.
   */
  cached
  TRepeatWhileStmt convertRepeatWhileStmtFromRaw(Raw::Element e) { result = TRepeatWhileStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TReturnStmt`, if possible.
   */
  cached
  TReturnStmt convertReturnStmtFromRaw(Raw::Element e) { result = TReturnStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TStmtCondition`, if possible.
   */
  cached
  TStmtCondition convertStmtConditionFromRaw(Raw::Element e) { result = TStmtCondition(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TSwitchStmt`, if possible.
   */
  cached
  TSwitchStmt convertSwitchStmtFromRaw(Raw::Element e) { result = TSwitchStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TThrowStmt`, if possible.
   */
  cached
  TThrowStmt convertThrowStmtFromRaw(Raw::Element e) { result = TThrowStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TWhileStmt`, if possible.
   */
  cached
  TWhileStmt convertWhileStmtFromRaw(Raw::Element e) { result = TWhileStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TYieldStmt`, if possible.
   */
  cached
  TYieldStmt convertYieldStmtFromRaw(Raw::Element e) { result = TYieldStmt(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TArraySliceType`, if possible.
   */
  cached
  TArraySliceType convertArraySliceTypeFromRaw(Raw::Element e) { result = TArraySliceType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoundGenericClassType`, if possible.
   */
  cached
  TBoundGenericClassType convertBoundGenericClassTypeFromRaw(Raw::Element e) {
    result = TBoundGenericClassType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoundGenericEnumType`, if possible.
   */
  cached
  TBoundGenericEnumType convertBoundGenericEnumTypeFromRaw(Raw::Element e) {
    result = TBoundGenericEnumType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBoundGenericStructType`, if possible.
   */
  cached
  TBoundGenericStructType convertBoundGenericStructTypeFromRaw(Raw::Element e) {
    result = TBoundGenericStructType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinBridgeObjectType`, if possible.
   */
  cached
  TBuiltinBridgeObjectType convertBuiltinBridgeObjectTypeFromRaw(Raw::Element e) {
    result = TBuiltinBridgeObjectType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinDefaultActorStorageType`, if possible.
   */
  cached
  TBuiltinDefaultActorStorageType convertBuiltinDefaultActorStorageTypeFromRaw(Raw::Element e) {
    result = TBuiltinDefaultActorStorageType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinExecutorType`, if possible.
   */
  cached
  TBuiltinExecutorType convertBuiltinExecutorTypeFromRaw(Raw::Element e) {
    result = TBuiltinExecutorType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinFloatType`, if possible.
   */
  cached
  TBuiltinFloatType convertBuiltinFloatTypeFromRaw(Raw::Element e) { result = TBuiltinFloatType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinIntegerLiteralType`, if possible.
   */
  cached
  TBuiltinIntegerLiteralType convertBuiltinIntegerLiteralTypeFromRaw(Raw::Element e) {
    result = TBuiltinIntegerLiteralType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinIntegerType`, if possible.
   */
  cached
  TBuiltinIntegerType convertBuiltinIntegerTypeFromRaw(Raw::Element e) {
    result = TBuiltinIntegerType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinJobType`, if possible.
   */
  cached
  TBuiltinJobType convertBuiltinJobTypeFromRaw(Raw::Element e) { result = TBuiltinJobType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinNativeObjectType`, if possible.
   */
  cached
  TBuiltinNativeObjectType convertBuiltinNativeObjectTypeFromRaw(Raw::Element e) {
    result = TBuiltinNativeObjectType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinRawPointerType`, if possible.
   */
  cached
  TBuiltinRawPointerType convertBuiltinRawPointerTypeFromRaw(Raw::Element e) {
    result = TBuiltinRawPointerType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinRawUnsafeContinuationType`, if possible.
   */
  cached
  TBuiltinRawUnsafeContinuationType convertBuiltinRawUnsafeContinuationTypeFromRaw(Raw::Element e) {
    result = TBuiltinRawUnsafeContinuationType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinUnsafeValueBufferType`, if possible.
   */
  cached
  TBuiltinUnsafeValueBufferType convertBuiltinUnsafeValueBufferTypeFromRaw(Raw::Element e) {
    result = TBuiltinUnsafeValueBufferType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TBuiltinVectorType`, if possible.
   */
  cached
  TBuiltinVectorType convertBuiltinVectorTypeFromRaw(Raw::Element e) {
    result = TBuiltinVectorType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TClassType`, if possible.
   */
  cached
  TClassType convertClassTypeFromRaw(Raw::Element e) { result = TClassType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDependentMemberType`, if possible.
   */
  cached
  TDependentMemberType convertDependentMemberTypeFromRaw(Raw::Element e) {
    result = TDependentMemberType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDictionaryType`, if possible.
   */
  cached
  TDictionaryType convertDictionaryTypeFromRaw(Raw::Element e) { result = TDictionaryType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TDynamicSelfType`, if possible.
   */
  cached
  TDynamicSelfType convertDynamicSelfTypeFromRaw(Raw::Element e) { result = TDynamicSelfType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TEnumType`, if possible.
   */
  cached
  TEnumType convertEnumTypeFromRaw(Raw::Element e) { result = TEnumType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TErrorType`, if possible.
   */
  cached
  TErrorType convertErrorTypeFromRaw(Raw::Element e) { result = TErrorType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExistentialMetatypeType`, if possible.
   */
  cached
  TExistentialMetatypeType convertExistentialMetatypeTypeFromRaw(Raw::Element e) {
    result = TExistentialMetatypeType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TExistentialType`, if possible.
   */
  cached
  TExistentialType convertExistentialTypeFromRaw(Raw::Element e) { result = TExistentialType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TFunctionType`, if possible.
   */
  cached
  TFunctionType convertFunctionTypeFromRaw(Raw::Element e) { result = TFunctionType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TGenericFunctionType`, if possible.
   */
  cached
  TGenericFunctionType convertGenericFunctionTypeFromRaw(Raw::Element e) {
    result = TGenericFunctionType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TGenericTypeParamType`, if possible.
   */
  cached
  TGenericTypeParamType convertGenericTypeParamTypeFromRaw(Raw::Element e) {
    result = TGenericTypeParamType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TInOutType`, if possible.
   */
  cached
  TInOutType convertInOutTypeFromRaw(Raw::Element e) { result = TInOutType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TLValueType`, if possible.
   */
  cached
  TLValueType convertLValueTypeFromRaw(Raw::Element e) { result = TLValueType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TMetatypeType`, if possible.
   */
  cached
  TMetatypeType convertMetatypeTypeFromRaw(Raw::Element e) { result = TMetatypeType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TModuleType`, if possible.
   */
  cached
  TModuleType convertModuleTypeFromRaw(Raw::Element e) { result = TModuleType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOpaqueTypeArchetypeType`, if possible.
   */
  cached
  TOpaqueTypeArchetypeType convertOpaqueTypeArchetypeTypeFromRaw(Raw::Element e) {
    result = TOpaqueTypeArchetypeType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOpenedArchetypeType`, if possible.
   */
  cached
  TOpenedArchetypeType convertOpenedArchetypeTypeFromRaw(Raw::Element e) {
    result = TOpenedArchetypeType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TOptionalType`, if possible.
   */
  cached
  TOptionalType convertOptionalTypeFromRaw(Raw::Element e) { result = TOptionalType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TParameterizedProtocolType`, if possible.
   */
  cached
  TParameterizedProtocolType convertParameterizedProtocolTypeFromRaw(Raw::Element e) {
    result = TParameterizedProtocolType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TParenType`, if possible.
   */
  cached
  TParenType convertParenTypeFromRaw(Raw::Element e) { result = TParenType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TPrimaryArchetypeType`, if possible.
   */
  cached
  TPrimaryArchetypeType convertPrimaryArchetypeTypeFromRaw(Raw::Element e) {
    result = TPrimaryArchetypeType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TProtocolCompositionType`, if possible.
   */
  cached
  TProtocolCompositionType convertProtocolCompositionTypeFromRaw(Raw::Element e) {
    result = TProtocolCompositionType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TProtocolType`, if possible.
   */
  cached
  TProtocolType convertProtocolTypeFromRaw(Raw::Element e) { result = TProtocolType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TStructType`, if possible.
   */
  cached
  TStructType convertStructTypeFromRaw(Raw::Element e) { result = TStructType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTupleType`, if possible.
   */
  cached
  TTupleType convertTupleTypeFromRaw(Raw::Element e) { result = TTupleType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTypeAliasType`, if possible.
   */
  cached
  TTypeAliasType convertTypeAliasTypeFromRaw(Raw::Element e) { result = TTypeAliasType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TTypeRepr`, if possible.
   */
  cached
  TTypeRepr convertTypeReprFromRaw(Raw::Element e) { result = TTypeRepr(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnboundGenericType`, if possible.
   */
  cached
  TUnboundGenericType convertUnboundGenericTypeFromRaw(Raw::Element e) {
    result = TUnboundGenericType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnmanagedStorageType`, if possible.
   */
  cached
  TUnmanagedStorageType convertUnmanagedStorageTypeFromRaw(Raw::Element e) {
    result = TUnmanagedStorageType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnownedStorageType`, if possible.
   */
  cached
  TUnownedStorageType convertUnownedStorageTypeFromRaw(Raw::Element e) {
    result = TUnownedStorageType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TUnresolvedType`, if possible.
   */
  cached
  TUnresolvedType convertUnresolvedTypeFromRaw(Raw::Element e) { result = TUnresolvedType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TVariadicSequenceType`, if possible.
   */
  cached
  TVariadicSequenceType convertVariadicSequenceTypeFromRaw(Raw::Element e) {
    result = TVariadicSequenceType(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw element to a synthesized `TWeakStorageType`, if possible.
   */
  cached
  TWeakStorageType convertWeakStorageTypeFromRaw(Raw::Element e) { result = TWeakStorageType(e) }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAstNode`, if possible.
   */
  cached
  TAstNode convertAstNodeFromRaw(Raw::Element e) {
    result = convertAvailabilityInfoFromRaw(e)
    or
    result = convertAvailabilitySpecFromRaw(e)
    or
    result = convertCaseLabelItemFromRaw(e)
    or
    result = convertConditionElementFromRaw(e)
    or
    result = convertDeclFromRaw(e)
    or
    result = convertExprFromRaw(e)
    or
    result = convertKeyPathComponentFromRaw(e)
    or
    result = convertPatternFromRaw(e)
    or
    result = convertStmtFromRaw(e)
    or
    result = convertStmtConditionFromRaw(e)
    or
    result = convertTypeReprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAvailabilitySpec`, if possible.
   */
  cached
  TAvailabilitySpec convertAvailabilitySpecFromRaw(Raw::Element e) {
    result = convertOtherAvailabilitySpecFromRaw(e)
    or
    result = convertPlatformVersionAvailabilitySpecFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TCallable`, if possible.
   */
  cached
  TCallable convertCallableFromRaw(Raw::Element e) {
    result = convertClosureExprFromRaw(e)
    or
    result = convertFunctionFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TElement`, if possible.
   */
  cached
  TElement convertElementFromRaw(Raw::Element e) {
    result = convertCallableFromRaw(e)
    or
    result = convertFileFromRaw(e)
    or
    result = convertGenericContextFromRaw(e)
    or
    result = convertLocatableFromRaw(e)
    or
    result = convertLocationFromRaw(e)
    or
    result = convertTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TErrorElement`, if possible.
   */
  cached
  TErrorElement convertErrorElementFromRaw(Raw::Element e) {
    result = convertErrorExprFromRaw(e)
    or
    result = convertErrorTypeFromRaw(e)
    or
    result = convertOverloadedDeclRefExprFromRaw(e)
    or
    result = convertUnresolvedDeclRefExprFromRaw(e)
    or
    result = convertUnresolvedDotExprFromRaw(e)
    or
    result = convertUnresolvedMemberChainResultExprFromRaw(e)
    or
    result = convertUnresolvedMemberExprFromRaw(e)
    or
    result = convertUnresolvedPatternExprFromRaw(e)
    or
    result = convertUnresolvedSpecializeExprFromRaw(e)
    or
    result = convertUnresolvedTypeFromRaw(e)
    or
    result = convertUnresolvedTypeConversionExprFromRaw(e)
    or
    result = convertUnspecifiedElementFromRaw(e)
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
    result = convertArgumentFromRaw(e)
    or
    result = convertAstNodeFromRaw(e)
    or
    result = convertCommentFromRaw(e)
    or
    result = convertDiagnosticsFromRaw(e)
    or
    result = convertErrorElementFromRaw(e)
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
   * Converts a raw DB element to a synthesized `TAbstractStorageDecl`, if possible.
   */
  cached
  TAbstractStorageDecl convertAbstractStorageDeclFromRaw(Raw::Element e) {
    result = convertSubscriptDeclFromRaw(e)
    or
    result = convertVarDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAbstractTypeParamDecl`, if possible.
   */
  cached
  TAbstractTypeParamDecl convertAbstractTypeParamDeclFromRaw(Raw::Element e) {
    result = convertAssociatedTypeDeclFromRaw(e)
    or
    result = convertGenericTypeParamDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAccessorOrNamedFunction`, if possible.
   */
  cached
  TAccessorOrNamedFunction convertAccessorOrNamedFunctionFromRaw(Raw::Element e) {
    result = convertAccessorFromRaw(e)
    or
    result = convertNamedFunctionFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TDecl`, if possible.
   */
  cached
  TDecl convertDeclFromRaw(Raw::Element e) {
    result = convertCapturedDeclFromRaw(e)
    or
    result = convertEnumCaseDeclFromRaw(e)
    or
    result = convertExtensionDeclFromRaw(e)
    or
    result = convertIfConfigDeclFromRaw(e)
    or
    result = convertImportDeclFromRaw(e)
    or
    result = convertMissingMemberDeclFromRaw(e)
    or
    result = convertOperatorDeclFromRaw(e)
    or
    result = convertPatternBindingDeclFromRaw(e)
    or
    result = convertPoundDiagnosticDeclFromRaw(e)
    or
    result = convertPrecedenceGroupDeclFromRaw(e)
    or
    result = convertTopLevelCodeDeclFromRaw(e)
    or
    result = convertValueDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TFunction`, if possible.
   */
  cached
  TFunction convertFunctionFromRaw(Raw::Element e) {
    result = convertAccessorOrNamedFunctionFromRaw(e)
    or
    result = convertDeinitializerFromRaw(e)
    or
    result = convertInitializerFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TGenericContext`, if possible.
   */
  cached
  TGenericContext convertGenericContextFromRaw(Raw::Element e) {
    result = convertExtensionDeclFromRaw(e)
    or
    result = convertFunctionFromRaw(e)
    or
    result = convertGenericTypeDeclFromRaw(e)
    or
    result = convertSubscriptDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TGenericTypeDecl`, if possible.
   */
  cached
  TGenericTypeDecl convertGenericTypeDeclFromRaw(Raw::Element e) {
    result = convertNominalTypeDeclFromRaw(e)
    or
    result = convertOpaqueTypeDeclFromRaw(e)
    or
    result = convertTypeAliasDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TNominalTypeDecl`, if possible.
   */
  cached
  TNominalTypeDecl convertNominalTypeDeclFromRaw(Raw::Element e) {
    result = convertClassDeclFromRaw(e)
    or
    result = convertEnumDeclFromRaw(e)
    or
    result = convertProtocolDeclFromRaw(e)
    or
    result = convertStructDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TOperatorDecl`, if possible.
   */
  cached
  TOperatorDecl convertOperatorDeclFromRaw(Raw::Element e) {
    result = convertInfixOperatorDeclFromRaw(e)
    or
    result = convertPostfixOperatorDeclFromRaw(e)
    or
    result = convertPrefixOperatorDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TTypeDecl`, if possible.
   */
  cached
  TTypeDecl convertTypeDeclFromRaw(Raw::Element e) {
    result = convertAbstractTypeParamDeclFromRaw(e)
    or
    result = convertGenericTypeDeclFromRaw(e)
    or
    result = convertModuleDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TValueDecl`, if possible.
   */
  cached
  TValueDecl convertValueDeclFromRaw(Raw::Element e) {
    result = convertAbstractStorageDeclFromRaw(e)
    or
    result = convertEnumElementDeclFromRaw(e)
    or
    result = convertFunctionFromRaw(e)
    or
    result = convertTypeDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TVarDecl`, if possible.
   */
  cached
  TVarDecl convertVarDeclFromRaw(Raw::Element e) {
    result = convertConcreteVarDeclFromRaw(e)
    or
    result = convertParamDeclFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAnyTryExpr`, if possible.
   */
  cached
  TAnyTryExpr convertAnyTryExprFromRaw(Raw::Element e) {
    result = convertForceTryExprFromRaw(e)
    or
    result = convertOptionalTryExprFromRaw(e)
    or
    result = convertTryExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TApplyExpr`, if possible.
   */
  cached
  TApplyExpr convertApplyExprFromRaw(Raw::Element e) {
    result = convertBinaryExprFromRaw(e)
    or
    result = convertCallExprFromRaw(e)
    or
    result = convertPostfixUnaryExprFromRaw(e)
    or
    result = convertPrefixUnaryExprFromRaw(e)
    or
    result = convertSelfApplyExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TBuiltinLiteralExpr`, if possible.
   */
  cached
  TBuiltinLiteralExpr convertBuiltinLiteralExprFromRaw(Raw::Element e) {
    result = convertBooleanLiteralExprFromRaw(e)
    or
    result = convertMagicIdentifierLiteralExprFromRaw(e)
    or
    result = convertNumberLiteralExprFromRaw(e)
    or
    result = convertStringLiteralExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TCheckedCastExpr`, if possible.
   */
  cached
  TCheckedCastExpr convertCheckedCastExprFromRaw(Raw::Element e) {
    result = convertConditionalCheckedCastExprFromRaw(e)
    or
    result = convertForcedCheckedCastExprFromRaw(e)
    or
    result = convertIsExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TClosureExpr`, if possible.
   */
  cached
  TClosureExpr convertClosureExprFromRaw(Raw::Element e) {
    result = convertAutoClosureExprFromRaw(e)
    or
    result = convertExplicitClosureExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TCollectionExpr`, if possible.
   */
  cached
  TCollectionExpr convertCollectionExprFromRaw(Raw::Element e) {
    result = convertArrayExprFromRaw(e)
    or
    result = convertDictionaryExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TDynamicLookupExpr`, if possible.
   */
  cached
  TDynamicLookupExpr convertDynamicLookupExprFromRaw(Raw::Element e) {
    result = convertDynamicMemberRefExprFromRaw(e)
    or
    result = convertDynamicSubscriptExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TExplicitCastExpr`, if possible.
   */
  cached
  TExplicitCastExpr convertExplicitCastExprFromRaw(Raw::Element e) {
    result = convertCheckedCastExprFromRaw(e)
    or
    result = convertCoerceExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TExpr`, if possible.
   */
  cached
  TExpr convertExprFromRaw(Raw::Element e) {
    result = convertAnyTryExprFromRaw(e)
    or
    result = convertAppliedPropertyWrapperExprFromRaw(e)
    or
    result = convertApplyExprFromRaw(e)
    or
    result = convertAssignExprFromRaw(e)
    or
    result = convertBindOptionalExprFromRaw(e)
    or
    result = convertCaptureListExprFromRaw(e)
    or
    result = convertClosureExprFromRaw(e)
    or
    result = convertCollectionExprFromRaw(e)
    or
    result = convertDeclRefExprFromRaw(e)
    or
    result = convertDefaultArgumentExprFromRaw(e)
    or
    result = convertDiscardAssignmentExprFromRaw(e)
    or
    result = convertDotSyntaxBaseIgnoredExprFromRaw(e)
    or
    result = convertDynamicTypeExprFromRaw(e)
    or
    result = convertEnumIsCaseExprFromRaw(e)
    or
    result = convertErrorExprFromRaw(e)
    or
    result = convertExplicitCastExprFromRaw(e)
    or
    result = convertForceValueExprFromRaw(e)
    or
    result = convertIdentityExprFromRaw(e)
    or
    result = convertIfExprFromRaw(e)
    or
    result = convertImplicitConversionExprFromRaw(e)
    or
    result = convertInOutExprFromRaw(e)
    or
    result = convertKeyPathApplicationExprFromRaw(e)
    or
    result = convertKeyPathDotExprFromRaw(e)
    or
    result = convertKeyPathExprFromRaw(e)
    or
    result = convertLazyInitializationExprFromRaw(e)
    or
    result = convertLiteralExprFromRaw(e)
    or
    result = convertLookupExprFromRaw(e)
    or
    result = convertMakeTemporarilyEscapableExprFromRaw(e)
    or
    result = convertObjCSelectorExprFromRaw(e)
    or
    result = convertOneWayExprFromRaw(e)
    or
    result = convertOpaqueValueExprFromRaw(e)
    or
    result = convertOpenExistentialExprFromRaw(e)
    or
    result = convertOptionalEvaluationExprFromRaw(e)
    or
    result = convertOtherInitializerRefExprFromRaw(e)
    or
    result = convertOverloadedDeclRefExprFromRaw(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprFromRaw(e)
    or
    result = convertRebindSelfInInitializerExprFromRaw(e)
    or
    result = convertSequenceExprFromRaw(e)
    or
    result = convertSuperRefExprFromRaw(e)
    or
    result = convertTapExprFromRaw(e)
    or
    result = convertTupleElementExprFromRaw(e)
    or
    result = convertTupleExprFromRaw(e)
    or
    result = convertTypeExprFromRaw(e)
    or
    result = convertUnresolvedDeclRefExprFromRaw(e)
    or
    result = convertUnresolvedDotExprFromRaw(e)
    or
    result = convertUnresolvedMemberExprFromRaw(e)
    or
    result = convertUnresolvedPatternExprFromRaw(e)
    or
    result = convertUnresolvedSpecializeExprFromRaw(e)
    or
    result = convertVarargExpansionExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TIdentityExpr`, if possible.
   */
  cached
  TIdentityExpr convertIdentityExprFromRaw(Raw::Element e) {
    result = convertAwaitExprFromRaw(e)
    or
    result = convertDotSelfExprFromRaw(e)
    or
    result = convertParenExprFromRaw(e)
    or
    result = convertUnresolvedMemberChainResultExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TImplicitConversionExpr`, if possible.
   */
  cached
  TImplicitConversionExpr convertImplicitConversionExprFromRaw(Raw::Element e) {
    result = convertAbiSafeConversionExprFromRaw(e)
    or
    result = convertAnyHashableErasureExprFromRaw(e)
    or
    result = convertArchetypeToSuperExprFromRaw(e)
    or
    result = convertArrayToPointerExprFromRaw(e)
    or
    result = convertBridgeFromObjCExprFromRaw(e)
    or
    result = convertBridgeToObjCExprFromRaw(e)
    or
    result = convertClassMetatypeToObjectExprFromRaw(e)
    or
    result = convertCollectionUpcastConversionExprFromRaw(e)
    or
    result = convertConditionalBridgeFromObjCExprFromRaw(e)
    or
    result = convertCovariantFunctionConversionExprFromRaw(e)
    or
    result = convertCovariantReturnConversionExprFromRaw(e)
    or
    result = convertDerivedToBaseExprFromRaw(e)
    or
    result = convertDestructureTupleExprFromRaw(e)
    or
    result = convertDifferentiableFunctionExprFromRaw(e)
    or
    result = convertDifferentiableFunctionExtractOriginalExprFromRaw(e)
    or
    result = convertErasureExprFromRaw(e)
    or
    result = convertExistentialMetatypeToObjectExprFromRaw(e)
    or
    result = convertForeignObjectConversionExprFromRaw(e)
    or
    result = convertFunctionConversionExprFromRaw(e)
    or
    result = convertInOutToPointerExprFromRaw(e)
    or
    result = convertInjectIntoOptionalExprFromRaw(e)
    or
    result = convertLinearFunctionExprFromRaw(e)
    or
    result = convertLinearFunctionExtractOriginalExprFromRaw(e)
    or
    result = convertLinearToDifferentiableFunctionExprFromRaw(e)
    or
    result = convertLoadExprFromRaw(e)
    or
    result = convertMetatypeConversionExprFromRaw(e)
    or
    result = convertPointerToPointerExprFromRaw(e)
    or
    result = convertProtocolMetatypeToObjectExprFromRaw(e)
    or
    result = convertStringToPointerExprFromRaw(e)
    or
    result = convertUnderlyingToOpaqueExprFromRaw(e)
    or
    result = convertUnevaluatedInstanceExprFromRaw(e)
    or
    result = convertUnresolvedTypeConversionExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLiteralExpr`, if possible.
   */
  cached
  TLiteralExpr convertLiteralExprFromRaw(Raw::Element e) {
    result = convertBuiltinLiteralExprFromRaw(e)
    or
    result = convertInterpolatedStringLiteralExprFromRaw(e)
    or
    result = convertNilLiteralExprFromRaw(e)
    or
    result = convertObjectLiteralExprFromRaw(e)
    or
    result = convertRegexLiteralExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLookupExpr`, if possible.
   */
  cached
  TLookupExpr convertLookupExprFromRaw(Raw::Element e) {
    result = convertDynamicLookupExprFromRaw(e)
    or
    result = convertMemberRefExprFromRaw(e)
    or
    result = convertMethodLookupExprFromRaw(e)
    or
    result = convertSubscriptExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TNumberLiteralExpr`, if possible.
   */
  cached
  TNumberLiteralExpr convertNumberLiteralExprFromRaw(Raw::Element e) {
    result = convertFloatLiteralExprFromRaw(e)
    or
    result = convertIntegerLiteralExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TSelfApplyExpr`, if possible.
   */
  cached
  TSelfApplyExpr convertSelfApplyExprFromRaw(Raw::Element e) {
    result = convertDotSyntaxCallExprFromRaw(e)
    or
    result = convertInitializerRefCallExprFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TPattern`, if possible.
   */
  cached
  TPattern convertPatternFromRaw(Raw::Element e) {
    result = convertAnyPatternFromRaw(e)
    or
    result = convertBindingPatternFromRaw(e)
    or
    result = convertBoolPatternFromRaw(e)
    or
    result = convertEnumElementPatternFromRaw(e)
    or
    result = convertExprPatternFromRaw(e)
    or
    result = convertIsPatternFromRaw(e)
    or
    result = convertNamedPatternFromRaw(e)
    or
    result = convertOptionalSomePatternFromRaw(e)
    or
    result = convertParenPatternFromRaw(e)
    or
    result = convertTuplePatternFromRaw(e)
    or
    result = convertTypedPatternFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLabeledConditionalStmt`, if possible.
   */
  cached
  TLabeledConditionalStmt convertLabeledConditionalStmtFromRaw(Raw::Element e) {
    result = convertGuardStmtFromRaw(e)
    or
    result = convertIfStmtFromRaw(e)
    or
    result = convertWhileStmtFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TLabeledStmt`, if possible.
   */
  cached
  TLabeledStmt convertLabeledStmtFromRaw(Raw::Element e) {
    result = convertDoCatchStmtFromRaw(e)
    or
    result = convertDoStmtFromRaw(e)
    or
    result = convertForEachStmtFromRaw(e)
    or
    result = convertLabeledConditionalStmtFromRaw(e)
    or
    result = convertRepeatWhileStmtFromRaw(e)
    or
    result = convertSwitchStmtFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TStmt`, if possible.
   */
  cached
  TStmt convertStmtFromRaw(Raw::Element e) {
    result = convertBraceStmtFromRaw(e)
    or
    result = convertBreakStmtFromRaw(e)
    or
    result = convertCaseStmtFromRaw(e)
    or
    result = convertContinueStmtFromRaw(e)
    or
    result = convertDeferStmtFromRaw(e)
    or
    result = convertFailStmtFromRaw(e)
    or
    result = convertFallthroughStmtFromRaw(e)
    or
    result = convertLabeledStmtFromRaw(e)
    or
    result = convertPoundAssertStmtFromRaw(e)
    or
    result = convertReturnStmtFromRaw(e)
    or
    result = convertThrowStmtFromRaw(e)
    or
    result = convertYieldStmtFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAnyBuiltinIntegerType`, if possible.
   */
  cached
  TAnyBuiltinIntegerType convertAnyBuiltinIntegerTypeFromRaw(Raw::Element e) {
    result = convertBuiltinIntegerLiteralTypeFromRaw(e)
    or
    result = convertBuiltinIntegerTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAnyFunctionType`, if possible.
   */
  cached
  TAnyFunctionType convertAnyFunctionTypeFromRaw(Raw::Element e) {
    result = convertFunctionTypeFromRaw(e)
    or
    result = convertGenericFunctionTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAnyGenericType`, if possible.
   */
  cached
  TAnyGenericType convertAnyGenericTypeFromRaw(Raw::Element e) {
    result = convertNominalOrBoundGenericNominalTypeFromRaw(e)
    or
    result = convertUnboundGenericTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TAnyMetatypeType`, if possible.
   */
  cached
  TAnyMetatypeType convertAnyMetatypeTypeFromRaw(Raw::Element e) {
    result = convertExistentialMetatypeTypeFromRaw(e)
    or
    result = convertMetatypeTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TArchetypeType`, if possible.
   */
  cached
  TArchetypeType convertArchetypeTypeFromRaw(Raw::Element e) {
    result = convertOpaqueTypeArchetypeTypeFromRaw(e)
    or
    result = convertOpenedArchetypeTypeFromRaw(e)
    or
    result = convertPrimaryArchetypeTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TBoundGenericType`, if possible.
   */
  cached
  TBoundGenericType convertBoundGenericTypeFromRaw(Raw::Element e) {
    result = convertBoundGenericClassTypeFromRaw(e)
    or
    result = convertBoundGenericEnumTypeFromRaw(e)
    or
    result = convertBoundGenericStructTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TBuiltinType`, if possible.
   */
  cached
  TBuiltinType convertBuiltinTypeFromRaw(Raw::Element e) {
    result = convertAnyBuiltinIntegerTypeFromRaw(e)
    or
    result = convertBuiltinBridgeObjectTypeFromRaw(e)
    or
    result = convertBuiltinDefaultActorStorageTypeFromRaw(e)
    or
    result = convertBuiltinExecutorTypeFromRaw(e)
    or
    result = convertBuiltinFloatTypeFromRaw(e)
    or
    result = convertBuiltinJobTypeFromRaw(e)
    or
    result = convertBuiltinNativeObjectTypeFromRaw(e)
    or
    result = convertBuiltinRawPointerTypeFromRaw(e)
    or
    result = convertBuiltinRawUnsafeContinuationTypeFromRaw(e)
    or
    result = convertBuiltinUnsafeValueBufferTypeFromRaw(e)
    or
    result = convertBuiltinVectorTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TNominalOrBoundGenericNominalType`, if possible.
   */
  cached
  TNominalOrBoundGenericNominalType convertNominalOrBoundGenericNominalTypeFromRaw(Raw::Element e) {
    result = convertBoundGenericTypeFromRaw(e)
    or
    result = convertNominalTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TNominalType`, if possible.
   */
  cached
  TNominalType convertNominalTypeFromRaw(Raw::Element e) {
    result = convertClassTypeFromRaw(e)
    or
    result = convertEnumTypeFromRaw(e)
    or
    result = convertProtocolTypeFromRaw(e)
    or
    result = convertStructTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TReferenceStorageType`, if possible.
   */
  cached
  TReferenceStorageType convertReferenceStorageTypeFromRaw(Raw::Element e) {
    result = convertUnmanagedStorageTypeFromRaw(e)
    or
    result = convertUnownedStorageTypeFromRaw(e)
    or
    result = convertWeakStorageTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TSubstitutableType`, if possible.
   */
  cached
  TSubstitutableType convertSubstitutableTypeFromRaw(Raw::Element e) {
    result = convertArchetypeTypeFromRaw(e)
    or
    result = convertGenericTypeParamTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TSugarType`, if possible.
   */
  cached
  TSugarType convertSugarTypeFromRaw(Raw::Element e) {
    result = convertParenTypeFromRaw(e)
    or
    result = convertSyntaxSugarTypeFromRaw(e)
    or
    result = convertTypeAliasTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TSyntaxSugarType`, if possible.
   */
  cached
  TSyntaxSugarType convertSyntaxSugarTypeFromRaw(Raw::Element e) {
    result = convertDictionaryTypeFromRaw(e)
    or
    result = convertUnarySyntaxSugarTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TType`, if possible.
   */
  cached
  TType convertTypeFromRaw(Raw::Element e) {
    result = convertAnyFunctionTypeFromRaw(e)
    or
    result = convertAnyGenericTypeFromRaw(e)
    or
    result = convertAnyMetatypeTypeFromRaw(e)
    or
    result = convertBuiltinTypeFromRaw(e)
    or
    result = convertDependentMemberTypeFromRaw(e)
    or
    result = convertDynamicSelfTypeFromRaw(e)
    or
    result = convertErrorTypeFromRaw(e)
    or
    result = convertExistentialTypeFromRaw(e)
    or
    result = convertInOutTypeFromRaw(e)
    or
    result = convertLValueTypeFromRaw(e)
    or
    result = convertModuleTypeFromRaw(e)
    or
    result = convertParameterizedProtocolTypeFromRaw(e)
    or
    result = convertProtocolCompositionTypeFromRaw(e)
    or
    result = convertReferenceStorageTypeFromRaw(e)
    or
    result = convertSubstitutableTypeFromRaw(e)
    or
    result = convertSugarTypeFromRaw(e)
    or
    result = convertTupleTypeFromRaw(e)
    or
    result = convertUnresolvedTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a raw DB element to a synthesized `TUnarySyntaxSugarType`, if possible.
   */
  cached
  TUnarySyntaxSugarType convertUnarySyntaxSugarTypeFromRaw(Raw::Element e) {
    result = convertArraySliceTypeFromRaw(e)
    or
    result = convertOptionalTypeFromRaw(e)
    or
    result = convertVariadicSequenceTypeFromRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAvailabilityInfo` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAvailabilityInfoToRaw(TAvailabilityInfo e) { e = TAvailabilityInfo(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TComment` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCommentToRaw(TComment e) { e = TComment(result) }

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
   * Converts a synthesized `TDiagnostics` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDiagnosticsToRaw(TDiagnostics e) { e = TDiagnostics(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TKeyPathComponent` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertKeyPathComponentToRaw(TKeyPathComponent e) { e = TKeyPathComponent(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOtherAvailabilitySpec` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOtherAvailabilitySpecToRaw(TOtherAvailabilitySpec e) {
    e = TOtherAvailabilitySpec(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPlatformVersionAvailabilitySpec` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPlatformVersionAvailabilitySpecToRaw(TPlatformVersionAvailabilitySpec e) {
    e = TPlatformVersionAvailabilitySpec(result)
  }

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
   * Converts a synthesized `TUnspecifiedElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnspecifiedElementToRaw(TUnspecifiedElement e) {
    e = TUnspecifiedElement(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAccessor` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAccessorToRaw(TAccessor e) { e = TAccessor(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAssociatedTypeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAssociatedTypeDeclToRaw(TAssociatedTypeDecl e) {
    e = TAssociatedTypeDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCapturedDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCapturedDeclToRaw(TCapturedDecl e) { e = TCapturedDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClassDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClassDeclToRaw(TClassDecl e) { e = TClassDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConcreteVarDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConcreteVarDeclToRaw(TConcreteVarDecl e) { e = TConcreteVarDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDeinitializer` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeinitializerToRaw(TDeinitializer e) { e = TDeinitializer(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumCaseDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumCaseDeclToRaw(TEnumCaseDecl e) { e = TEnumCaseDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumDeclToRaw(TEnumDecl e) { e = TEnumDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumElementDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumElementDeclToRaw(TEnumElementDecl e) { e = TEnumElementDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExtensionDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExtensionDeclToRaw(TExtensionDecl e) { e = TExtensionDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericTypeParamDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericTypeParamDeclToRaw(TGenericTypeParamDecl e) {
    e = TGenericTypeParamDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIfConfigDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfConfigDeclToRaw(TIfConfigDecl e) { e = TIfConfigDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TImportDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertImportDeclToRaw(TImportDecl e) { e = TImportDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInfixOperatorDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInfixOperatorDeclToRaw(TInfixOperatorDecl e) {
    e = TInfixOperatorDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInitializer` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInitializerToRaw(TInitializer e) { e = TInitializer(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMissingMemberDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMissingMemberDeclToRaw(TMissingMemberDecl e) {
    e = TMissingMemberDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TModuleDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertModuleDeclToRaw(TModuleDecl e) { e = TModuleDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNamedFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNamedFunctionToRaw(TNamedFunction e) { e = TNamedFunction(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOpaqueTypeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOpaqueTypeDeclToRaw(TOpaqueTypeDecl e) { e = TOpaqueTypeDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TParamDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertParamDeclToRaw(TParamDecl e) { e = TParamDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPatternBindingDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPatternBindingDeclToRaw(TPatternBindingDecl e) {
    e = TPatternBindingDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPostfixOperatorDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPostfixOperatorDeclToRaw(TPostfixOperatorDecl e) {
    e = TPostfixOperatorDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPoundDiagnosticDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPoundDiagnosticDeclToRaw(TPoundDiagnosticDecl e) {
    e = TPoundDiagnosticDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPrecedenceGroupDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPrecedenceGroupDeclToRaw(TPrecedenceGroupDecl e) {
    e = TPrecedenceGroupDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPrefixOperatorDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPrefixOperatorDeclToRaw(TPrefixOperatorDecl e) {
    e = TPrefixOperatorDecl(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TProtocolDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertProtocolDeclToRaw(TProtocolDecl e) { e = TProtocolDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStructDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStructDeclToRaw(TStructDecl e) { e = TStructDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSubscriptDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSubscriptDeclToRaw(TSubscriptDecl e) { e = TSubscriptDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTopLevelCodeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTopLevelCodeDeclToRaw(TTopLevelCodeDecl e) { e = TTopLevelCodeDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypeAliasDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeAliasDeclToRaw(TTypeAliasDecl e) { e = TTypeAliasDecl(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAbiSafeConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAbiSafeConversionExprToRaw(TAbiSafeConversionExpr e) {
    e = TAbiSafeConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyHashableErasureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyHashableErasureExprToRaw(TAnyHashableErasureExpr e) {
    e = TAnyHashableErasureExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAppliedPropertyWrapperExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAppliedPropertyWrapperExprToRaw(TAppliedPropertyWrapperExpr e) {
    e = TAppliedPropertyWrapperExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArchetypeToSuperExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArchetypeToSuperExprToRaw(TArchetypeToSuperExpr e) {
    e = TArchetypeToSuperExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArgument` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArgumentToRaw(TArgument e) { e = TArgument(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArrayExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArrayExprToRaw(TArrayExpr e) { e = TArrayExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArrayToPointerExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArrayToPointerExprToRaw(TArrayToPointerExpr e) {
    e = TArrayToPointerExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAssignExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAssignExprToRaw(TAssignExpr e) { e = TAssignExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAutoClosureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAutoClosureExprToRaw(TAutoClosureExpr e) { e = TAutoClosureExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAwaitExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAwaitExprToRaw(TAwaitExpr e) { e = TAwaitExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBinaryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBinaryExprToRaw(TBinaryExpr e) { e = TBinaryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBindOptionalExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBindOptionalExprToRaw(TBindOptionalExpr e) { e = TBindOptionalExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBooleanLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBooleanLiteralExprToRaw(TBooleanLiteralExpr e) {
    e = TBooleanLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBridgeFromObjCExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBridgeFromObjCExprToRaw(TBridgeFromObjCExpr e) {
    e = TBridgeFromObjCExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBridgeToObjCExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBridgeToObjCExprToRaw(TBridgeToObjCExpr e) { e = TBridgeToObjCExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCallExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCallExprToRaw(TCallExpr e) { e = TCallExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCaptureListExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCaptureListExprToRaw(TCaptureListExpr e) { e = TCaptureListExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClassMetatypeToObjectExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClassMetatypeToObjectExprToRaw(TClassMetatypeToObjectExpr e) {
    e = TClassMetatypeToObjectExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCoerceExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCoerceExprToRaw(TCoerceExpr e) { e = TCoerceExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCollectionUpcastConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCollectionUpcastConversionExprToRaw(TCollectionUpcastConversionExpr e) {
    e = TCollectionUpcastConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConditionalBridgeFromObjCExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConditionalBridgeFromObjCExprToRaw(TConditionalBridgeFromObjCExpr e) {
    e = TConditionalBridgeFromObjCExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConditionalCheckedCastExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConditionalCheckedCastExprToRaw(TConditionalCheckedCastExpr e) {
    e = TConditionalCheckedCastExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCovariantFunctionConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCovariantFunctionConversionExprToRaw(TCovariantFunctionConversionExpr e) {
    e = TCovariantFunctionConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCovariantReturnConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCovariantReturnConversionExprToRaw(TCovariantReturnConversionExpr e) {
    e = TCovariantReturnConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDeclRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeclRefExprToRaw(TDeclRefExpr e) { e = TDeclRefExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDefaultArgumentExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDefaultArgumentExprToRaw(TDefaultArgumentExpr e) {
    e = TDefaultArgumentExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDerivedToBaseExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDerivedToBaseExprToRaw(TDerivedToBaseExpr e) {
    e = TDerivedToBaseExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDestructureTupleExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDestructureTupleExprToRaw(TDestructureTupleExpr e) {
    e = TDestructureTupleExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDictionaryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDictionaryExprToRaw(TDictionaryExpr e) { e = TDictionaryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDifferentiableFunctionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDifferentiableFunctionExprToRaw(TDifferentiableFunctionExpr e) {
    e = TDifferentiableFunctionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDifferentiableFunctionExtractOriginalExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDifferentiableFunctionExtractOriginalExprToRaw(
    TDifferentiableFunctionExtractOriginalExpr e
  ) {
    e = TDifferentiableFunctionExtractOriginalExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDiscardAssignmentExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDiscardAssignmentExprToRaw(TDiscardAssignmentExpr e) {
    e = TDiscardAssignmentExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDotSelfExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDotSelfExprToRaw(TDotSelfExpr e) { e = TDotSelfExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDotSyntaxBaseIgnoredExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDotSyntaxBaseIgnoredExprToRaw(TDotSyntaxBaseIgnoredExpr e) {
    e = TDotSyntaxBaseIgnoredExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDotSyntaxCallExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDotSyntaxCallExprToRaw(TDotSyntaxCallExpr e) {
    e = TDotSyntaxCallExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDynamicMemberRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDynamicMemberRefExprToRaw(TDynamicMemberRefExpr e) {
    e = TDynamicMemberRefExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDynamicSubscriptExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDynamicSubscriptExprToRaw(TDynamicSubscriptExpr e) {
    e = TDynamicSubscriptExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDynamicTypeExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDynamicTypeExprToRaw(TDynamicTypeExpr e) { e = TDynamicTypeExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumIsCaseExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumIsCaseExprToRaw(TEnumIsCaseExpr e) { e = TEnumIsCaseExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TErasureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertErasureExprToRaw(TErasureExpr e) { e = TErasureExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TErrorExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertErrorExprToRaw(TErrorExpr e) { e = TErrorExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExistentialMetatypeToObjectExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExistentialMetatypeToObjectExprToRaw(TExistentialMetatypeToObjectExpr e) {
    e = TExistentialMetatypeToObjectExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExplicitClosureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExplicitClosureExprToRaw(TExplicitClosureExpr e) {
    e = TExplicitClosureExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFloatLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFloatLiteralExprToRaw(TFloatLiteralExpr e) { e = TFloatLiteralExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TForceTryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertForceTryExprToRaw(TForceTryExpr e) { e = TForceTryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TForceValueExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertForceValueExprToRaw(TForceValueExpr e) { e = TForceValueExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TForcedCheckedCastExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertForcedCheckedCastExprToRaw(TForcedCheckedCastExpr e) {
    e = TForcedCheckedCastExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TForeignObjectConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertForeignObjectConversionExprToRaw(TForeignObjectConversionExpr e) {
    e = TForeignObjectConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunctionConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionConversionExprToRaw(TFunctionConversionExpr e) {
    e = TFunctionConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIfExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfExprToRaw(TIfExpr e) { e = TIfExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInOutExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInOutExprToRaw(TInOutExpr e) { e = TInOutExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInOutToPointerExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInOutToPointerExprToRaw(TInOutToPointerExpr e) {
    e = TInOutToPointerExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInitializerRefCallExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInitializerRefCallExprToRaw(TInitializerRefCallExpr e) {
    e = TInitializerRefCallExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInjectIntoOptionalExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInjectIntoOptionalExprToRaw(TInjectIntoOptionalExpr e) {
    e = TInjectIntoOptionalExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIntegerLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIntegerLiteralExprToRaw(TIntegerLiteralExpr e) {
    e = TIntegerLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInterpolatedStringLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInterpolatedStringLiteralExprToRaw(TInterpolatedStringLiteralExpr e) {
    e = TInterpolatedStringLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIsExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIsExprToRaw(TIsExpr e) { e = TIsExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TKeyPathApplicationExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertKeyPathApplicationExprToRaw(TKeyPathApplicationExpr e) {
    e = TKeyPathApplicationExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TKeyPathDotExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertKeyPathDotExprToRaw(TKeyPathDotExpr e) { e = TKeyPathDotExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TKeyPathExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertKeyPathExprToRaw(TKeyPathExpr e) { e = TKeyPathExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLazyInitializationExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLazyInitializationExprToRaw(TLazyInitializationExpr e) {
    e = TLazyInitializationExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLinearFunctionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLinearFunctionExprToRaw(TLinearFunctionExpr e) {
    e = TLinearFunctionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLinearFunctionExtractOriginalExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLinearFunctionExtractOriginalExprToRaw(TLinearFunctionExtractOriginalExpr e) {
    e = TLinearFunctionExtractOriginalExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLinearToDifferentiableFunctionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLinearToDifferentiableFunctionExprToRaw(TLinearToDifferentiableFunctionExpr e) {
    e = TLinearToDifferentiableFunctionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLoadExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLoadExprToRaw(TLoadExpr e) { e = TLoadExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMagicIdentifierLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMagicIdentifierLiteralExprToRaw(TMagicIdentifierLiteralExpr e) {
    e = TMagicIdentifierLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMakeTemporarilyEscapableExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMakeTemporarilyEscapableExprToRaw(TMakeTemporarilyEscapableExpr e) {
    e = TMakeTemporarilyEscapableExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMemberRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMemberRefExprToRaw(TMemberRefExpr e) { e = TMemberRefExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMetatypeConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMetatypeConversionExprToRaw(TMetatypeConversionExpr e) {
    e = TMetatypeConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMethodLookupExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMethodLookupExprToRaw(TMethodLookupExpr e) { e = TMethodLookupExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNilLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNilLiteralExprToRaw(TNilLiteralExpr e) { e = TNilLiteralExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TObjCSelectorExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertObjCSelectorExprToRaw(TObjCSelectorExpr e) { e = TObjCSelectorExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TObjectLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertObjectLiteralExprToRaw(TObjectLiteralExpr e) {
    e = TObjectLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOneWayExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOneWayExprToRaw(TOneWayExpr e) { e = TOneWayExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOpaqueValueExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOpaqueValueExprToRaw(TOpaqueValueExpr e) { e = TOpaqueValueExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOpenExistentialExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOpenExistentialExprToRaw(TOpenExistentialExpr e) {
    e = TOpenExistentialExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOptionalEvaluationExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOptionalEvaluationExprToRaw(TOptionalEvaluationExpr e) {
    e = TOptionalEvaluationExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOptionalTryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOptionalTryExprToRaw(TOptionalTryExpr e) { e = TOptionalTryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOtherInitializerRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOtherInitializerRefExprToRaw(TOtherInitializerRefExpr e) {
    e = TOtherInitializerRefExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOverloadedDeclRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOverloadedDeclRefExprToRaw(TOverloadedDeclRefExpr e) {
    e = TOverloadedDeclRefExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TParenExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertParenExprToRaw(TParenExpr e) { e = TParenExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPointerToPointerExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPointerToPointerExprToRaw(TPointerToPointerExpr e) {
    e = TPointerToPointerExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPostfixUnaryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPostfixUnaryExprToRaw(TPostfixUnaryExpr e) { e = TPostfixUnaryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPrefixUnaryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPrefixUnaryExprToRaw(TPrefixUnaryExpr e) { e = TPrefixUnaryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPropertyWrapperValuePlaceholderExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPropertyWrapperValuePlaceholderExprToRaw(
    TPropertyWrapperValuePlaceholderExpr e
  ) {
    e = TPropertyWrapperValuePlaceholderExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TProtocolMetatypeToObjectExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertProtocolMetatypeToObjectExprToRaw(TProtocolMetatypeToObjectExpr e) {
    e = TProtocolMetatypeToObjectExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRebindSelfInInitializerExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRebindSelfInInitializerExprToRaw(TRebindSelfInInitializerExpr e) {
    e = TRebindSelfInInitializerExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRegexLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRegexLiteralExprToRaw(TRegexLiteralExpr e) { e = TRegexLiteralExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSequenceExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSequenceExprToRaw(TSequenceExpr e) { e = TSequenceExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStringLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStringLiteralExprToRaw(TStringLiteralExpr e) {
    e = TStringLiteralExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStringToPointerExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStringToPointerExprToRaw(TStringToPointerExpr e) {
    e = TStringToPointerExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSubscriptExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSubscriptExprToRaw(TSubscriptExpr e) { e = TSubscriptExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSuperRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSuperRefExprToRaw(TSuperRefExpr e) { e = TSuperRefExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTapExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTapExprToRaw(TTapExpr e) { e = TTapExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTryExprToRaw(TTryExpr e) { e = TTryExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTupleElementExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleElementExprToRaw(TTupleElementExpr e) { e = TTupleElementExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTupleExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleExprToRaw(TTupleExpr e) { e = TTupleExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypeExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeExprToRaw(TTypeExpr e) { e = TTypeExpr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnderlyingToOpaqueExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnderlyingToOpaqueExprToRaw(TUnderlyingToOpaqueExpr e) {
    e = TUnderlyingToOpaqueExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnevaluatedInstanceExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnevaluatedInstanceExprToRaw(TUnevaluatedInstanceExpr e) {
    e = TUnevaluatedInstanceExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedDeclRefExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedDeclRefExprToRaw(TUnresolvedDeclRefExpr e) {
    e = TUnresolvedDeclRefExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedDotExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedDotExprToRaw(TUnresolvedDotExpr e) {
    e = TUnresolvedDotExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedMemberChainResultExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedMemberChainResultExprToRaw(TUnresolvedMemberChainResultExpr e) {
    e = TUnresolvedMemberChainResultExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedMemberExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedMemberExprToRaw(TUnresolvedMemberExpr e) {
    e = TUnresolvedMemberExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedPatternExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedPatternExprToRaw(TUnresolvedPatternExpr e) {
    e = TUnresolvedPatternExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedSpecializeExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedSpecializeExprToRaw(TUnresolvedSpecializeExpr e) {
    e = TUnresolvedSpecializeExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedTypeConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedTypeConversionExprToRaw(TUnresolvedTypeConversionExpr e) {
    e = TUnresolvedTypeConversionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TVarargExpansionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertVarargExpansionExprToRaw(TVarargExpansionExpr e) {
    e = TVarargExpansionExpr(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyPatternToRaw(TAnyPattern e) { e = TAnyPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBindingPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBindingPatternToRaw(TBindingPattern e) { e = TBindingPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoolPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoolPatternToRaw(TBoolPattern e) { e = TBoolPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumElementPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumElementPatternToRaw(TEnumElementPattern e) {
    e = TEnumElementPattern(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExprPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprPatternToRaw(TExprPattern e) { e = TExprPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIsPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIsPatternToRaw(TIsPattern e) { e = TIsPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNamedPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNamedPatternToRaw(TNamedPattern e) { e = TNamedPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOptionalSomePattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOptionalSomePatternToRaw(TOptionalSomePattern e) {
    e = TOptionalSomePattern(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TParenPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertParenPatternToRaw(TParenPattern e) { e = TParenPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTuplePattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTuplePatternToRaw(TTuplePattern e) { e = TTuplePattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypedPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypedPatternToRaw(TTypedPattern e) { e = TTypedPattern(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBraceStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBraceStmtToRaw(TBraceStmt e) { e = TBraceStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBreakStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBreakStmtToRaw(TBreakStmt e) { e = TBreakStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCaseLabelItem` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCaseLabelItemToRaw(TCaseLabelItem e) { e = TCaseLabelItem(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCaseStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCaseStmtToRaw(TCaseStmt e) { e = TCaseStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TConditionElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertConditionElementToRaw(TConditionElement e) { e = TConditionElement(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TContinueStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertContinueStmtToRaw(TContinueStmt e) { e = TContinueStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDeferStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeferStmtToRaw(TDeferStmt e) { e = TDeferStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDoCatchStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDoCatchStmtToRaw(TDoCatchStmt e) { e = TDoCatchStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDoStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDoStmtToRaw(TDoStmt e) { e = TDoStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFailStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFailStmtToRaw(TFailStmt e) { e = TFailStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFallthroughStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFallthroughStmtToRaw(TFallthroughStmt e) { e = TFallthroughStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TForEachStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertForEachStmtToRaw(TForEachStmt e) { e = TForEachStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGuardStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGuardStmtToRaw(TGuardStmt e) { e = TGuardStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIfStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIfStmtToRaw(TIfStmt e) { e = TIfStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPoundAssertStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPoundAssertStmtToRaw(TPoundAssertStmt e) { e = TPoundAssertStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TRepeatWhileStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertRepeatWhileStmtToRaw(TRepeatWhileStmt e) { e = TRepeatWhileStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TReturnStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertReturnStmtToRaw(TReturnStmt e) { e = TReturnStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStmtCondition` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStmtConditionToRaw(TStmtCondition e) { e = TStmtCondition(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSwitchStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSwitchStmtToRaw(TSwitchStmt e) { e = TSwitchStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TThrowStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertThrowStmtToRaw(TThrowStmt e) { e = TThrowStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TWhileStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertWhileStmtToRaw(TWhileStmt e) { e = TWhileStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TYieldStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertYieldStmtToRaw(TYieldStmt e) { e = TYieldStmt(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArraySliceType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArraySliceTypeToRaw(TArraySliceType e) { e = TArraySliceType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoundGenericClassType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoundGenericClassTypeToRaw(TBoundGenericClassType e) {
    e = TBoundGenericClassType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoundGenericEnumType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoundGenericEnumTypeToRaw(TBoundGenericEnumType e) {
    e = TBoundGenericEnumType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoundGenericStructType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoundGenericStructTypeToRaw(TBoundGenericStructType e) {
    e = TBoundGenericStructType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinBridgeObjectType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinBridgeObjectTypeToRaw(TBuiltinBridgeObjectType e) {
    e = TBuiltinBridgeObjectType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinDefaultActorStorageType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinDefaultActorStorageTypeToRaw(TBuiltinDefaultActorStorageType e) {
    e = TBuiltinDefaultActorStorageType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinExecutorType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinExecutorTypeToRaw(TBuiltinExecutorType e) {
    e = TBuiltinExecutorType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinFloatType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinFloatTypeToRaw(TBuiltinFloatType e) { e = TBuiltinFloatType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinIntegerLiteralType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinIntegerLiteralTypeToRaw(TBuiltinIntegerLiteralType e) {
    e = TBuiltinIntegerLiteralType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinIntegerType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinIntegerTypeToRaw(TBuiltinIntegerType e) {
    e = TBuiltinIntegerType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinJobType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinJobTypeToRaw(TBuiltinJobType e) { e = TBuiltinJobType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinNativeObjectType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinNativeObjectTypeToRaw(TBuiltinNativeObjectType e) {
    e = TBuiltinNativeObjectType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinRawPointerType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinRawPointerTypeToRaw(TBuiltinRawPointerType e) {
    e = TBuiltinRawPointerType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinRawUnsafeContinuationType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinRawUnsafeContinuationTypeToRaw(TBuiltinRawUnsafeContinuationType e) {
    e = TBuiltinRawUnsafeContinuationType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinUnsafeValueBufferType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinUnsafeValueBufferTypeToRaw(TBuiltinUnsafeValueBufferType e) {
    e = TBuiltinUnsafeValueBufferType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinVectorType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinVectorTypeToRaw(TBuiltinVectorType e) {
    e = TBuiltinVectorType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClassType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClassTypeToRaw(TClassType e) { e = TClassType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDependentMemberType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDependentMemberTypeToRaw(TDependentMemberType e) {
    e = TDependentMemberType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDictionaryType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDictionaryTypeToRaw(TDictionaryType e) { e = TDictionaryType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDynamicSelfType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDynamicSelfTypeToRaw(TDynamicSelfType e) { e = TDynamicSelfType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TEnumType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertEnumTypeToRaw(TEnumType e) { e = TEnumType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TErrorType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertErrorTypeToRaw(TErrorType e) { e = TErrorType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExistentialMetatypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExistentialMetatypeTypeToRaw(TExistentialMetatypeType e) {
    e = TExistentialMetatypeType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExistentialType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExistentialTypeToRaw(TExistentialType e) { e = TExistentialType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunctionType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionTypeToRaw(TFunctionType e) { e = TFunctionType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericFunctionType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericFunctionTypeToRaw(TGenericFunctionType e) {
    e = TGenericFunctionType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericTypeParamType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericTypeParamTypeToRaw(TGenericTypeParamType e) {
    e = TGenericTypeParamType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TInOutType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertInOutTypeToRaw(TInOutType e) { e = TInOutType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLValueType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLValueTypeToRaw(TLValueType e) { e = TLValueType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TMetatypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertMetatypeTypeToRaw(TMetatypeType e) { e = TMetatypeType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TModuleType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertModuleTypeToRaw(TModuleType e) { e = TModuleType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOpaqueTypeArchetypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOpaqueTypeArchetypeTypeToRaw(TOpaqueTypeArchetypeType e) {
    e = TOpaqueTypeArchetypeType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOpenedArchetypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOpenedArchetypeTypeToRaw(TOpenedArchetypeType e) {
    e = TOpenedArchetypeType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOptionalType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOptionalTypeToRaw(TOptionalType e) { e = TOptionalType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TParameterizedProtocolType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertParameterizedProtocolTypeToRaw(TParameterizedProtocolType e) {
    e = TParameterizedProtocolType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TParenType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertParenTypeToRaw(TParenType e) { e = TParenType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPrimaryArchetypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPrimaryArchetypeTypeToRaw(TPrimaryArchetypeType e) {
    e = TPrimaryArchetypeType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TProtocolCompositionType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertProtocolCompositionTypeToRaw(TProtocolCompositionType e) {
    e = TProtocolCompositionType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TProtocolType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertProtocolTypeToRaw(TProtocolType e) { e = TProtocolType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStructType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStructTypeToRaw(TStructType e) { e = TStructType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTupleType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTupleTypeToRaw(TTupleType e) { e = TTupleType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypeAliasType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeAliasTypeToRaw(TTypeAliasType e) { e = TTypeAliasType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypeRepr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeReprToRaw(TTypeRepr e) { e = TTypeRepr(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnboundGenericType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnboundGenericTypeToRaw(TUnboundGenericType e) {
    e = TUnboundGenericType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnmanagedStorageType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnmanagedStorageTypeToRaw(TUnmanagedStorageType e) {
    e = TUnmanagedStorageType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnownedStorageType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnownedStorageTypeToRaw(TUnownedStorageType e) {
    e = TUnownedStorageType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnresolvedType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnresolvedTypeToRaw(TUnresolvedType e) { e = TUnresolvedType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TVariadicSequenceType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertVariadicSequenceTypeToRaw(TVariadicSequenceType e) {
    e = TVariadicSequenceType(result)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TWeakStorageType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertWeakStorageTypeToRaw(TWeakStorageType e) { e = TWeakStorageType(result) }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAstNode` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAstNodeToRaw(TAstNode e) {
    result = convertAvailabilityInfoToRaw(e)
    or
    result = convertAvailabilitySpecToRaw(e)
    or
    result = convertCaseLabelItemToRaw(e)
    or
    result = convertConditionElementToRaw(e)
    or
    result = convertDeclToRaw(e)
    or
    result = convertExprToRaw(e)
    or
    result = convertKeyPathComponentToRaw(e)
    or
    result = convertPatternToRaw(e)
    or
    result = convertStmtToRaw(e)
    or
    result = convertStmtConditionToRaw(e)
    or
    result = convertTypeReprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAvailabilitySpec` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAvailabilitySpecToRaw(TAvailabilitySpec e) {
    result = convertOtherAvailabilitySpecToRaw(e)
    or
    result = convertPlatformVersionAvailabilitySpecToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCallable` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCallableToRaw(TCallable e) {
    result = convertClosureExprToRaw(e)
    or
    result = convertFunctionToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertElementToRaw(TElement e) {
    result = convertCallableToRaw(e)
    or
    result = convertFileToRaw(e)
    or
    result = convertGenericContextToRaw(e)
    or
    result = convertLocatableToRaw(e)
    or
    result = convertLocationToRaw(e)
    or
    result = convertTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TErrorElement` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertErrorElementToRaw(TErrorElement e) {
    result = convertErrorExprToRaw(e)
    or
    result = convertErrorTypeToRaw(e)
    or
    result = convertOverloadedDeclRefExprToRaw(e)
    or
    result = convertUnresolvedDeclRefExprToRaw(e)
    or
    result = convertUnresolvedDotExprToRaw(e)
    or
    result = convertUnresolvedMemberChainResultExprToRaw(e)
    or
    result = convertUnresolvedMemberExprToRaw(e)
    or
    result = convertUnresolvedPatternExprToRaw(e)
    or
    result = convertUnresolvedSpecializeExprToRaw(e)
    or
    result = convertUnresolvedTypeToRaw(e)
    or
    result = convertUnresolvedTypeConversionExprToRaw(e)
    or
    result = convertUnspecifiedElementToRaw(e)
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
    result = convertArgumentToRaw(e)
    or
    result = convertAstNodeToRaw(e)
    or
    result = convertCommentToRaw(e)
    or
    result = convertDiagnosticsToRaw(e)
    or
    result = convertErrorElementToRaw(e)
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
   * Converts a synthesized `TAbstractStorageDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAbstractStorageDeclToRaw(TAbstractStorageDecl e) {
    result = convertSubscriptDeclToRaw(e)
    or
    result = convertVarDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAbstractTypeParamDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAbstractTypeParamDeclToRaw(TAbstractTypeParamDecl e) {
    result = convertAssociatedTypeDeclToRaw(e)
    or
    result = convertGenericTypeParamDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAccessorOrNamedFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAccessorOrNamedFunctionToRaw(TAccessorOrNamedFunction e) {
    result = convertAccessorToRaw(e)
    or
    result = convertNamedFunctionToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDeclToRaw(TDecl e) {
    result = convertCapturedDeclToRaw(e)
    or
    result = convertEnumCaseDeclToRaw(e)
    or
    result = convertExtensionDeclToRaw(e)
    or
    result = convertIfConfigDeclToRaw(e)
    or
    result = convertImportDeclToRaw(e)
    or
    result = convertMissingMemberDeclToRaw(e)
    or
    result = convertOperatorDeclToRaw(e)
    or
    result = convertPatternBindingDeclToRaw(e)
    or
    result = convertPoundDiagnosticDeclToRaw(e)
    or
    result = convertPrecedenceGroupDeclToRaw(e)
    or
    result = convertTopLevelCodeDeclToRaw(e)
    or
    result = convertValueDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TFunction` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertFunctionToRaw(TFunction e) {
    result = convertAccessorOrNamedFunctionToRaw(e)
    or
    result = convertDeinitializerToRaw(e)
    or
    result = convertInitializerToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericContext` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericContextToRaw(TGenericContext e) {
    result = convertExtensionDeclToRaw(e)
    or
    result = convertFunctionToRaw(e)
    or
    result = convertGenericTypeDeclToRaw(e)
    or
    result = convertSubscriptDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TGenericTypeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertGenericTypeDeclToRaw(TGenericTypeDecl e) {
    result = convertNominalTypeDeclToRaw(e)
    or
    result = convertOpaqueTypeDeclToRaw(e)
    or
    result = convertTypeAliasDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNominalTypeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNominalTypeDeclToRaw(TNominalTypeDecl e) {
    result = convertClassDeclToRaw(e)
    or
    result = convertEnumDeclToRaw(e)
    or
    result = convertProtocolDeclToRaw(e)
    or
    result = convertStructDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TOperatorDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertOperatorDeclToRaw(TOperatorDecl e) {
    result = convertInfixOperatorDeclToRaw(e)
    or
    result = convertPostfixOperatorDeclToRaw(e)
    or
    result = convertPrefixOperatorDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TTypeDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeDeclToRaw(TTypeDecl e) {
    result = convertAbstractTypeParamDeclToRaw(e)
    or
    result = convertGenericTypeDeclToRaw(e)
    or
    result = convertModuleDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TValueDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertValueDeclToRaw(TValueDecl e) {
    result = convertAbstractStorageDeclToRaw(e)
    or
    result = convertEnumElementDeclToRaw(e)
    or
    result = convertFunctionToRaw(e)
    or
    result = convertTypeDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TVarDecl` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertVarDeclToRaw(TVarDecl e) {
    result = convertConcreteVarDeclToRaw(e)
    or
    result = convertParamDeclToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyTryExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyTryExprToRaw(TAnyTryExpr e) {
    result = convertForceTryExprToRaw(e)
    or
    result = convertOptionalTryExprToRaw(e)
    or
    result = convertTryExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TApplyExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertApplyExprToRaw(TApplyExpr e) {
    result = convertBinaryExprToRaw(e)
    or
    result = convertCallExprToRaw(e)
    or
    result = convertPostfixUnaryExprToRaw(e)
    or
    result = convertPrefixUnaryExprToRaw(e)
    or
    result = convertSelfApplyExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinLiteralExprToRaw(TBuiltinLiteralExpr e) {
    result = convertBooleanLiteralExprToRaw(e)
    or
    result = convertMagicIdentifierLiteralExprToRaw(e)
    or
    result = convertNumberLiteralExprToRaw(e)
    or
    result = convertStringLiteralExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCheckedCastExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCheckedCastExprToRaw(TCheckedCastExpr e) {
    result = convertConditionalCheckedCastExprToRaw(e)
    or
    result = convertForcedCheckedCastExprToRaw(e)
    or
    result = convertIsExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TClosureExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertClosureExprToRaw(TClosureExpr e) {
    result = convertAutoClosureExprToRaw(e)
    or
    result = convertExplicitClosureExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TCollectionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertCollectionExprToRaw(TCollectionExpr e) {
    result = convertArrayExprToRaw(e)
    or
    result = convertDictionaryExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TDynamicLookupExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertDynamicLookupExprToRaw(TDynamicLookupExpr e) {
    result = convertDynamicMemberRefExprToRaw(e)
    or
    result = convertDynamicSubscriptExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExplicitCastExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExplicitCastExprToRaw(TExplicitCastExpr e) {
    result = convertCheckedCastExprToRaw(e)
    or
    result = convertCoerceExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertExprToRaw(TExpr e) {
    result = convertAnyTryExprToRaw(e)
    or
    result = convertAppliedPropertyWrapperExprToRaw(e)
    or
    result = convertApplyExprToRaw(e)
    or
    result = convertAssignExprToRaw(e)
    or
    result = convertBindOptionalExprToRaw(e)
    or
    result = convertCaptureListExprToRaw(e)
    or
    result = convertClosureExprToRaw(e)
    or
    result = convertCollectionExprToRaw(e)
    or
    result = convertDeclRefExprToRaw(e)
    or
    result = convertDefaultArgumentExprToRaw(e)
    or
    result = convertDiscardAssignmentExprToRaw(e)
    or
    result = convertDotSyntaxBaseIgnoredExprToRaw(e)
    or
    result = convertDynamicTypeExprToRaw(e)
    or
    result = convertEnumIsCaseExprToRaw(e)
    or
    result = convertErrorExprToRaw(e)
    or
    result = convertExplicitCastExprToRaw(e)
    or
    result = convertForceValueExprToRaw(e)
    or
    result = convertIdentityExprToRaw(e)
    or
    result = convertIfExprToRaw(e)
    or
    result = convertImplicitConversionExprToRaw(e)
    or
    result = convertInOutExprToRaw(e)
    or
    result = convertKeyPathApplicationExprToRaw(e)
    or
    result = convertKeyPathDotExprToRaw(e)
    or
    result = convertKeyPathExprToRaw(e)
    or
    result = convertLazyInitializationExprToRaw(e)
    or
    result = convertLiteralExprToRaw(e)
    or
    result = convertLookupExprToRaw(e)
    or
    result = convertMakeTemporarilyEscapableExprToRaw(e)
    or
    result = convertObjCSelectorExprToRaw(e)
    or
    result = convertOneWayExprToRaw(e)
    or
    result = convertOpaqueValueExprToRaw(e)
    or
    result = convertOpenExistentialExprToRaw(e)
    or
    result = convertOptionalEvaluationExprToRaw(e)
    or
    result = convertOtherInitializerRefExprToRaw(e)
    or
    result = convertOverloadedDeclRefExprToRaw(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprToRaw(e)
    or
    result = convertRebindSelfInInitializerExprToRaw(e)
    or
    result = convertSequenceExprToRaw(e)
    or
    result = convertSuperRefExprToRaw(e)
    or
    result = convertTapExprToRaw(e)
    or
    result = convertTupleElementExprToRaw(e)
    or
    result = convertTupleExprToRaw(e)
    or
    result = convertTypeExprToRaw(e)
    or
    result = convertUnresolvedDeclRefExprToRaw(e)
    or
    result = convertUnresolvedDotExprToRaw(e)
    or
    result = convertUnresolvedMemberExprToRaw(e)
    or
    result = convertUnresolvedPatternExprToRaw(e)
    or
    result = convertUnresolvedSpecializeExprToRaw(e)
    or
    result = convertVarargExpansionExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TIdentityExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertIdentityExprToRaw(TIdentityExpr e) {
    result = convertAwaitExprToRaw(e)
    or
    result = convertDotSelfExprToRaw(e)
    or
    result = convertParenExprToRaw(e)
    or
    result = convertUnresolvedMemberChainResultExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TImplicitConversionExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertImplicitConversionExprToRaw(TImplicitConversionExpr e) {
    result = convertAbiSafeConversionExprToRaw(e)
    or
    result = convertAnyHashableErasureExprToRaw(e)
    or
    result = convertArchetypeToSuperExprToRaw(e)
    or
    result = convertArrayToPointerExprToRaw(e)
    or
    result = convertBridgeFromObjCExprToRaw(e)
    or
    result = convertBridgeToObjCExprToRaw(e)
    or
    result = convertClassMetatypeToObjectExprToRaw(e)
    or
    result = convertCollectionUpcastConversionExprToRaw(e)
    or
    result = convertConditionalBridgeFromObjCExprToRaw(e)
    or
    result = convertCovariantFunctionConversionExprToRaw(e)
    or
    result = convertCovariantReturnConversionExprToRaw(e)
    or
    result = convertDerivedToBaseExprToRaw(e)
    or
    result = convertDestructureTupleExprToRaw(e)
    or
    result = convertDifferentiableFunctionExprToRaw(e)
    or
    result = convertDifferentiableFunctionExtractOriginalExprToRaw(e)
    or
    result = convertErasureExprToRaw(e)
    or
    result = convertExistentialMetatypeToObjectExprToRaw(e)
    or
    result = convertForeignObjectConversionExprToRaw(e)
    or
    result = convertFunctionConversionExprToRaw(e)
    or
    result = convertInOutToPointerExprToRaw(e)
    or
    result = convertInjectIntoOptionalExprToRaw(e)
    or
    result = convertLinearFunctionExprToRaw(e)
    or
    result = convertLinearFunctionExtractOriginalExprToRaw(e)
    or
    result = convertLinearToDifferentiableFunctionExprToRaw(e)
    or
    result = convertLoadExprToRaw(e)
    or
    result = convertMetatypeConversionExprToRaw(e)
    or
    result = convertPointerToPointerExprToRaw(e)
    or
    result = convertProtocolMetatypeToObjectExprToRaw(e)
    or
    result = convertStringToPointerExprToRaw(e)
    or
    result = convertUnderlyingToOpaqueExprToRaw(e)
    or
    result = convertUnevaluatedInstanceExprToRaw(e)
    or
    result = convertUnresolvedTypeConversionExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLiteralExprToRaw(TLiteralExpr e) {
    result = convertBuiltinLiteralExprToRaw(e)
    or
    result = convertInterpolatedStringLiteralExprToRaw(e)
    or
    result = convertNilLiteralExprToRaw(e)
    or
    result = convertObjectLiteralExprToRaw(e)
    or
    result = convertRegexLiteralExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLookupExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLookupExprToRaw(TLookupExpr e) {
    result = convertDynamicLookupExprToRaw(e)
    or
    result = convertMemberRefExprToRaw(e)
    or
    result = convertMethodLookupExprToRaw(e)
    or
    result = convertSubscriptExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNumberLiteralExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNumberLiteralExprToRaw(TNumberLiteralExpr e) {
    result = convertFloatLiteralExprToRaw(e)
    or
    result = convertIntegerLiteralExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSelfApplyExpr` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSelfApplyExprToRaw(TSelfApplyExpr e) {
    result = convertDotSyntaxCallExprToRaw(e)
    or
    result = convertInitializerRefCallExprToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TPattern` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertPatternToRaw(TPattern e) {
    result = convertAnyPatternToRaw(e)
    or
    result = convertBindingPatternToRaw(e)
    or
    result = convertBoolPatternToRaw(e)
    or
    result = convertEnumElementPatternToRaw(e)
    or
    result = convertExprPatternToRaw(e)
    or
    result = convertIsPatternToRaw(e)
    or
    result = convertNamedPatternToRaw(e)
    or
    result = convertOptionalSomePatternToRaw(e)
    or
    result = convertParenPatternToRaw(e)
    or
    result = convertTuplePatternToRaw(e)
    or
    result = convertTypedPatternToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLabeledConditionalStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLabeledConditionalStmtToRaw(TLabeledConditionalStmt e) {
    result = convertGuardStmtToRaw(e)
    or
    result = convertIfStmtToRaw(e)
    or
    result = convertWhileStmtToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TLabeledStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertLabeledStmtToRaw(TLabeledStmt e) {
    result = convertDoCatchStmtToRaw(e)
    or
    result = convertDoStmtToRaw(e)
    or
    result = convertForEachStmtToRaw(e)
    or
    result = convertLabeledConditionalStmtToRaw(e)
    or
    result = convertRepeatWhileStmtToRaw(e)
    or
    result = convertSwitchStmtToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TStmt` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertStmtToRaw(TStmt e) {
    result = convertBraceStmtToRaw(e)
    or
    result = convertBreakStmtToRaw(e)
    or
    result = convertCaseStmtToRaw(e)
    or
    result = convertContinueStmtToRaw(e)
    or
    result = convertDeferStmtToRaw(e)
    or
    result = convertFailStmtToRaw(e)
    or
    result = convertFallthroughStmtToRaw(e)
    or
    result = convertLabeledStmtToRaw(e)
    or
    result = convertPoundAssertStmtToRaw(e)
    or
    result = convertReturnStmtToRaw(e)
    or
    result = convertThrowStmtToRaw(e)
    or
    result = convertYieldStmtToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyBuiltinIntegerType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyBuiltinIntegerTypeToRaw(TAnyBuiltinIntegerType e) {
    result = convertBuiltinIntegerLiteralTypeToRaw(e)
    or
    result = convertBuiltinIntegerTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyFunctionType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyFunctionTypeToRaw(TAnyFunctionType e) {
    result = convertFunctionTypeToRaw(e)
    or
    result = convertGenericFunctionTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyGenericType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyGenericTypeToRaw(TAnyGenericType e) {
    result = convertNominalOrBoundGenericNominalTypeToRaw(e)
    or
    result = convertUnboundGenericTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TAnyMetatypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertAnyMetatypeTypeToRaw(TAnyMetatypeType e) {
    result = convertExistentialMetatypeTypeToRaw(e)
    or
    result = convertMetatypeTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TArchetypeType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertArchetypeTypeToRaw(TArchetypeType e) {
    result = convertOpaqueTypeArchetypeTypeToRaw(e)
    or
    result = convertOpenedArchetypeTypeToRaw(e)
    or
    result = convertPrimaryArchetypeTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBoundGenericType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBoundGenericTypeToRaw(TBoundGenericType e) {
    result = convertBoundGenericClassTypeToRaw(e)
    or
    result = convertBoundGenericEnumTypeToRaw(e)
    or
    result = convertBoundGenericStructTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TBuiltinType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertBuiltinTypeToRaw(TBuiltinType e) {
    result = convertAnyBuiltinIntegerTypeToRaw(e)
    or
    result = convertBuiltinBridgeObjectTypeToRaw(e)
    or
    result = convertBuiltinDefaultActorStorageTypeToRaw(e)
    or
    result = convertBuiltinExecutorTypeToRaw(e)
    or
    result = convertBuiltinFloatTypeToRaw(e)
    or
    result = convertBuiltinJobTypeToRaw(e)
    or
    result = convertBuiltinNativeObjectTypeToRaw(e)
    or
    result = convertBuiltinRawPointerTypeToRaw(e)
    or
    result = convertBuiltinRawUnsafeContinuationTypeToRaw(e)
    or
    result = convertBuiltinUnsafeValueBufferTypeToRaw(e)
    or
    result = convertBuiltinVectorTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNominalOrBoundGenericNominalType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNominalOrBoundGenericNominalTypeToRaw(TNominalOrBoundGenericNominalType e) {
    result = convertBoundGenericTypeToRaw(e)
    or
    result = convertNominalTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TNominalType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertNominalTypeToRaw(TNominalType e) {
    result = convertClassTypeToRaw(e)
    or
    result = convertEnumTypeToRaw(e)
    or
    result = convertProtocolTypeToRaw(e)
    or
    result = convertStructTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TReferenceStorageType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertReferenceStorageTypeToRaw(TReferenceStorageType e) {
    result = convertUnmanagedStorageTypeToRaw(e)
    or
    result = convertUnownedStorageTypeToRaw(e)
    or
    result = convertWeakStorageTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSubstitutableType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSubstitutableTypeToRaw(TSubstitutableType e) {
    result = convertArchetypeTypeToRaw(e)
    or
    result = convertGenericTypeParamTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSugarType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSugarTypeToRaw(TSugarType e) {
    result = convertParenTypeToRaw(e)
    or
    result = convertSyntaxSugarTypeToRaw(e)
    or
    result = convertTypeAliasTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TSyntaxSugarType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertSyntaxSugarTypeToRaw(TSyntaxSugarType e) {
    result = convertDictionaryTypeToRaw(e)
    or
    result = convertUnarySyntaxSugarTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertTypeToRaw(TType e) {
    result = convertAnyFunctionTypeToRaw(e)
    or
    result = convertAnyGenericTypeToRaw(e)
    or
    result = convertAnyMetatypeTypeToRaw(e)
    or
    result = convertBuiltinTypeToRaw(e)
    or
    result = convertDependentMemberTypeToRaw(e)
    or
    result = convertDynamicSelfTypeToRaw(e)
    or
    result = convertErrorTypeToRaw(e)
    or
    result = convertExistentialTypeToRaw(e)
    or
    result = convertInOutTypeToRaw(e)
    or
    result = convertLValueTypeToRaw(e)
    or
    result = convertModuleTypeToRaw(e)
    or
    result = convertParameterizedProtocolTypeToRaw(e)
    or
    result = convertProtocolCompositionTypeToRaw(e)
    or
    result = convertReferenceStorageTypeToRaw(e)
    or
    result = convertSubstitutableTypeToRaw(e)
    or
    result = convertSugarTypeToRaw(e)
    or
    result = convertTupleTypeToRaw(e)
    or
    result = convertUnresolvedTypeToRaw(e)
  }

  /**
   * INTERNAL: Do not use.
   * Converts a synthesized `TUnarySyntaxSugarType` to a raw DB element, if possible.
   */
  cached
  Raw::Element convertUnarySyntaxSugarTypeToRaw(TUnarySyntaxSugarType e) {
    result = convertArraySliceTypeToRaw(e)
    or
    result = convertOptionalTypeToRaw(e)
    or
    result = convertVariadicSequenceTypeToRaw(e)
  }
}
