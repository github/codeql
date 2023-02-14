private import codeql.swift.generated.SynthConstructors
private import codeql.swift.generated.Raw

cached
module Synth {
  cached
  newtype TElement =
    TAvailabilityInfo(Raw::AvailabilityInfo id) { constructAvailabilityInfo(id) } or
    TComment(Raw::Comment id) { constructComment(id) } or
    TDbFile(Raw::DbFile id) { constructDbFile(id) } or
    TDbLocation(Raw::DbLocation id) { constructDbLocation(id) } or
    TDiagnostics(Raw::Diagnostics id) { constructDiagnostics(id) } or
    TOtherAvailabilitySpec(Raw::OtherAvailabilitySpec id) { constructOtherAvailabilitySpec(id) } or
    TPlatformVersionAvailabilitySpec(Raw::PlatformVersionAvailabilitySpec id) {
      constructPlatformVersionAvailabilitySpec(id)
    } or
    TUnknownFile() or
    TUnknownLocation() or
    TUnspecifiedElement(Raw::UnspecifiedElement id) { constructUnspecifiedElement(id) } or
    TAccessorDecl(Raw::AccessorDecl id) { constructAccessorDecl(id) } or
    TAssociatedTypeDecl(Raw::AssociatedTypeDecl id) { constructAssociatedTypeDecl(id) } or
    TCapturedDecl(Raw::CapturedDecl id) { constructCapturedDecl(id) } or
    TClassDecl(Raw::ClassDecl id) { constructClassDecl(id) } or
    TConcreteFuncDecl(Raw::ConcreteFuncDecl id) { constructConcreteFuncDecl(id) } or
    TConcreteVarDecl(Raw::ConcreteVarDecl id) { constructConcreteVarDecl(id) } or
    TConstructorDecl(Raw::ConstructorDecl id) { constructConstructorDecl(id) } or
    TDestructorDecl(Raw::DestructorDecl id) { constructDestructorDecl(id) } or
    TEnumCaseDecl(Raw::EnumCaseDecl id) { constructEnumCaseDecl(id) } or
    TEnumDecl(Raw::EnumDecl id) { constructEnumDecl(id) } or
    TEnumElementDecl(Raw::EnumElementDecl id) { constructEnumElementDecl(id) } or
    TExtensionDecl(Raw::ExtensionDecl id) { constructExtensionDecl(id) } or
    TGenericTypeParamDecl(Raw::GenericTypeParamDecl id) { constructGenericTypeParamDecl(id) } or
    TIfConfigDecl(Raw::IfConfigDecl id) { constructIfConfigDecl(id) } or
    TImportDecl(Raw::ImportDecl id) { constructImportDecl(id) } or
    TInfixOperatorDecl(Raw::InfixOperatorDecl id) { constructInfixOperatorDecl(id) } or
    TMissingMemberDecl(Raw::MissingMemberDecl id) { constructMissingMemberDecl(id) } or
    TModuleDecl(Raw::ModuleDecl id) { constructModuleDecl(id) } or
    TOpaqueTypeDecl(Raw::OpaqueTypeDecl id) { constructOpaqueTypeDecl(id) } or
    TParamDecl(Raw::ParamDecl id) { constructParamDecl(id) } or
    TPatternBindingDecl(Raw::PatternBindingDecl id) { constructPatternBindingDecl(id) } or
    TPostfixOperatorDecl(Raw::PostfixOperatorDecl id) { constructPostfixOperatorDecl(id) } or
    TPoundDiagnosticDecl(Raw::PoundDiagnosticDecl id) { constructPoundDiagnosticDecl(id) } or
    TPrecedenceGroupDecl(Raw::PrecedenceGroupDecl id) { constructPrecedenceGroupDecl(id) } or
    TPrefixOperatorDecl(Raw::PrefixOperatorDecl id) { constructPrefixOperatorDecl(id) } or
    TProtocolDecl(Raw::ProtocolDecl id) { constructProtocolDecl(id) } or
    TStructDecl(Raw::StructDecl id) { constructStructDecl(id) } or
    TSubscriptDecl(Raw::SubscriptDecl id) { constructSubscriptDecl(id) } or
    TTopLevelCodeDecl(Raw::TopLevelCodeDecl id) { constructTopLevelCodeDecl(id) } or
    TTypeAliasDecl(Raw::TypeAliasDecl id) { constructTypeAliasDecl(id) } or
    TAbiSafeConversionExpr(Raw::AbiSafeConversionExpr id) { constructAbiSafeConversionExpr(id) } or
    TAnyHashableErasureExpr(Raw::AnyHashableErasureExpr id) { constructAnyHashableErasureExpr(id) } or
    TAppliedPropertyWrapperExpr(Raw::AppliedPropertyWrapperExpr id) {
      constructAppliedPropertyWrapperExpr(id)
    } or
    TArchetypeToSuperExpr(Raw::ArchetypeToSuperExpr id) { constructArchetypeToSuperExpr(id) } or
    TArgument(Raw::Argument id) { constructArgument(id) } or
    TArrayExpr(Raw::ArrayExpr id) { constructArrayExpr(id) } or
    TArrayToPointerExpr(Raw::ArrayToPointerExpr id) { constructArrayToPointerExpr(id) } or
    TAssignExpr(Raw::AssignExpr id) { constructAssignExpr(id) } or
    TAutoClosureExpr(Raw::AutoClosureExpr id) { constructAutoClosureExpr(id) } or
    TAwaitExpr(Raw::AwaitExpr id) { constructAwaitExpr(id) } or
    TBinaryExpr(Raw::BinaryExpr id) { constructBinaryExpr(id) } or
    TBindOptionalExpr(Raw::BindOptionalExpr id) { constructBindOptionalExpr(id) } or
    TBooleanLiteralExpr(Raw::BooleanLiteralExpr id) { constructBooleanLiteralExpr(id) } or
    TBridgeFromObjCExpr(Raw::BridgeFromObjCExpr id) { constructBridgeFromObjCExpr(id) } or
    TBridgeToObjCExpr(Raw::BridgeToObjCExpr id) { constructBridgeToObjCExpr(id) } or
    TCallExpr(Raw::CallExpr id) { constructCallExpr(id) } or
    TCaptureListExpr(Raw::CaptureListExpr id) { constructCaptureListExpr(id) } or
    TClassMetatypeToObjectExpr(Raw::ClassMetatypeToObjectExpr id) {
      constructClassMetatypeToObjectExpr(id)
    } or
    TClosureExpr(Raw::ClosureExpr id) { constructClosureExpr(id) } or
    TCoerceExpr(Raw::CoerceExpr id) { constructCoerceExpr(id) } or
    TCollectionUpcastConversionExpr(Raw::CollectionUpcastConversionExpr id) {
      constructCollectionUpcastConversionExpr(id)
    } or
    TConditionalBridgeFromObjCExpr(Raw::ConditionalBridgeFromObjCExpr id) {
      constructConditionalBridgeFromObjCExpr(id)
    } or
    TConditionalCheckedCastExpr(Raw::ConditionalCheckedCastExpr id) {
      constructConditionalCheckedCastExpr(id)
    } or
    TConstructorRefCallExpr(Raw::ConstructorRefCallExpr id) { constructConstructorRefCallExpr(id) } or
    TCovariantFunctionConversionExpr(Raw::CovariantFunctionConversionExpr id) {
      constructCovariantFunctionConversionExpr(id)
    } or
    TCovariantReturnConversionExpr(Raw::CovariantReturnConversionExpr id) {
      constructCovariantReturnConversionExpr(id)
    } or
    TDeclRefExpr(Raw::DeclRefExpr id) { constructDeclRefExpr(id) } or
    TDefaultArgumentExpr(Raw::DefaultArgumentExpr id) { constructDefaultArgumentExpr(id) } or
    TDerivedToBaseExpr(Raw::DerivedToBaseExpr id) { constructDerivedToBaseExpr(id) } or
    TDestructureTupleExpr(Raw::DestructureTupleExpr id) { constructDestructureTupleExpr(id) } or
    TDictionaryExpr(Raw::DictionaryExpr id) { constructDictionaryExpr(id) } or
    TDifferentiableFunctionExpr(Raw::DifferentiableFunctionExpr id) {
      constructDifferentiableFunctionExpr(id)
    } or
    TDifferentiableFunctionExtractOriginalExpr(Raw::DifferentiableFunctionExtractOriginalExpr id) {
      constructDifferentiableFunctionExtractOriginalExpr(id)
    } or
    TDiscardAssignmentExpr(Raw::DiscardAssignmentExpr id) { constructDiscardAssignmentExpr(id) } or
    TDotSelfExpr(Raw::DotSelfExpr id) { constructDotSelfExpr(id) } or
    TDotSyntaxBaseIgnoredExpr(Raw::DotSyntaxBaseIgnoredExpr id) {
      constructDotSyntaxBaseIgnoredExpr(id)
    } or
    TDotSyntaxCallExpr(Raw::DotSyntaxCallExpr id) { constructDotSyntaxCallExpr(id) } or
    TDynamicMemberRefExpr(Raw::DynamicMemberRefExpr id) { constructDynamicMemberRefExpr(id) } or
    TDynamicSubscriptExpr(Raw::DynamicSubscriptExpr id) { constructDynamicSubscriptExpr(id) } or
    TDynamicTypeExpr(Raw::DynamicTypeExpr id) { constructDynamicTypeExpr(id) } or
    TEnumIsCaseExpr(Raw::EnumIsCaseExpr id) { constructEnumIsCaseExpr(id) } or
    TErasureExpr(Raw::ErasureExpr id) { constructErasureExpr(id) } or
    TErrorExpr(Raw::ErrorExpr id) { constructErrorExpr(id) } or
    TExistentialMetatypeToObjectExpr(Raw::ExistentialMetatypeToObjectExpr id) {
      constructExistentialMetatypeToObjectExpr(id)
    } or
    TFloatLiteralExpr(Raw::FloatLiteralExpr id) { constructFloatLiteralExpr(id) } or
    TForceTryExpr(Raw::ForceTryExpr id) { constructForceTryExpr(id) } or
    TForceValueExpr(Raw::ForceValueExpr id) { constructForceValueExpr(id) } or
    TForcedCheckedCastExpr(Raw::ForcedCheckedCastExpr id) { constructForcedCheckedCastExpr(id) } or
    TForeignObjectConversionExpr(Raw::ForeignObjectConversionExpr id) {
      constructForeignObjectConversionExpr(id)
    } or
    TFunctionConversionExpr(Raw::FunctionConversionExpr id) { constructFunctionConversionExpr(id) } or
    TIfExpr(Raw::IfExpr id) { constructIfExpr(id) } or
    TInOutExpr(Raw::InOutExpr id) { constructInOutExpr(id) } or
    TInOutToPointerExpr(Raw::InOutToPointerExpr id) { constructInOutToPointerExpr(id) } or
    TInjectIntoOptionalExpr(Raw::InjectIntoOptionalExpr id) { constructInjectIntoOptionalExpr(id) } or
    TIntegerLiteralExpr(Raw::IntegerLiteralExpr id) { constructIntegerLiteralExpr(id) } or
    TInterpolatedStringLiteralExpr(Raw::InterpolatedStringLiteralExpr id) {
      constructInterpolatedStringLiteralExpr(id)
    } or
    TIsExpr(Raw::IsExpr id) { constructIsExpr(id) } or
    TKeyPathApplicationExpr(Raw::KeyPathApplicationExpr id) { constructKeyPathApplicationExpr(id) } or
    TKeyPathDotExpr(Raw::KeyPathDotExpr id) { constructKeyPathDotExpr(id) } or
    TKeyPathExpr(Raw::KeyPathExpr id) { constructKeyPathExpr(id) } or
    TLazyInitializerExpr(Raw::LazyInitializerExpr id) { constructLazyInitializerExpr(id) } or
    TLinearFunctionExpr(Raw::LinearFunctionExpr id) { constructLinearFunctionExpr(id) } or
    TLinearFunctionExtractOriginalExpr(Raw::LinearFunctionExtractOriginalExpr id) {
      constructLinearFunctionExtractOriginalExpr(id)
    } or
    TLinearToDifferentiableFunctionExpr(Raw::LinearToDifferentiableFunctionExpr id) {
      constructLinearToDifferentiableFunctionExpr(id)
    } or
    TLoadExpr(Raw::LoadExpr id) { constructLoadExpr(id) } or
    TMagicIdentifierLiteralExpr(Raw::MagicIdentifierLiteralExpr id) {
      constructMagicIdentifierLiteralExpr(id)
    } or
    TMakeTemporarilyEscapableExpr(Raw::MakeTemporarilyEscapableExpr id) {
      constructMakeTemporarilyEscapableExpr(id)
    } or
    TMemberRefExpr(Raw::MemberRefExpr id) { constructMemberRefExpr(id) } or
    TMetatypeConversionExpr(Raw::MetatypeConversionExpr id) { constructMetatypeConversionExpr(id) } or
    TMethodLookupExpr(Raw::SelfApplyExpr id) { constructMethodLookupExpr(id) } or
    TNilLiteralExpr(Raw::NilLiteralExpr id) { constructNilLiteralExpr(id) } or
    TObjCSelectorExpr(Raw::ObjCSelectorExpr id) { constructObjCSelectorExpr(id) } or
    TObjectLiteralExpr(Raw::ObjectLiteralExpr id) { constructObjectLiteralExpr(id) } or
    TOneWayExpr(Raw::OneWayExpr id) { constructOneWayExpr(id) } or
    TOpaqueValueExpr(Raw::OpaqueValueExpr id) { constructOpaqueValueExpr(id) } or
    TOpenExistentialExpr(Raw::OpenExistentialExpr id) { constructOpenExistentialExpr(id) } or
    TOptionalEvaluationExpr(Raw::OptionalEvaluationExpr id) { constructOptionalEvaluationExpr(id) } or
    TOptionalTryExpr(Raw::OptionalTryExpr id) { constructOptionalTryExpr(id) } or
    TOtherConstructorDeclRefExpr(Raw::OtherConstructorDeclRefExpr id) {
      constructOtherConstructorDeclRefExpr(id)
    } or
    TOverloadedDeclRefExpr(Raw::OverloadedDeclRefExpr id) { constructOverloadedDeclRefExpr(id) } or
    TParenExpr(Raw::ParenExpr id) { constructParenExpr(id) } or
    TPointerToPointerExpr(Raw::PointerToPointerExpr id) { constructPointerToPointerExpr(id) } or
    TPostfixUnaryExpr(Raw::PostfixUnaryExpr id) { constructPostfixUnaryExpr(id) } or
    TPrefixUnaryExpr(Raw::PrefixUnaryExpr id) { constructPrefixUnaryExpr(id) } or
    TPropertyWrapperValuePlaceholderExpr(Raw::PropertyWrapperValuePlaceholderExpr id) {
      constructPropertyWrapperValuePlaceholderExpr(id)
    } or
    TProtocolMetatypeToObjectExpr(Raw::ProtocolMetatypeToObjectExpr id) {
      constructProtocolMetatypeToObjectExpr(id)
    } or
    TRebindSelfInConstructorExpr(Raw::RebindSelfInConstructorExpr id) {
      constructRebindSelfInConstructorExpr(id)
    } or
    TRegexLiteralExpr(Raw::RegexLiteralExpr id) { constructRegexLiteralExpr(id) } or
    TSequenceExpr(Raw::SequenceExpr id) { constructSequenceExpr(id) } or
    TStringLiteralExpr(Raw::StringLiteralExpr id) { constructStringLiteralExpr(id) } or
    TStringToPointerExpr(Raw::StringToPointerExpr id) { constructStringToPointerExpr(id) } or
    TSubscriptExpr(Raw::SubscriptExpr id) { constructSubscriptExpr(id) } or
    TSuperRefExpr(Raw::SuperRefExpr id) { constructSuperRefExpr(id) } or
    TTapExpr(Raw::TapExpr id) { constructTapExpr(id) } or
    TTryExpr(Raw::TryExpr id) { constructTryExpr(id) } or
    TTupleElementExpr(Raw::TupleElementExpr id) { constructTupleElementExpr(id) } or
    TTupleExpr(Raw::TupleExpr id) { constructTupleExpr(id) } or
    TTypeExpr(Raw::TypeExpr id) { constructTypeExpr(id) } or
    TUnderlyingToOpaqueExpr(Raw::UnderlyingToOpaqueExpr id) { constructUnderlyingToOpaqueExpr(id) } or
    TUnevaluatedInstanceExpr(Raw::UnevaluatedInstanceExpr id) {
      constructUnevaluatedInstanceExpr(id)
    } or
    TUnresolvedDeclRefExpr(Raw::UnresolvedDeclRefExpr id) { constructUnresolvedDeclRefExpr(id) } or
    TUnresolvedDotExpr(Raw::UnresolvedDotExpr id) { constructUnresolvedDotExpr(id) } or
    TUnresolvedMemberChainResultExpr(Raw::UnresolvedMemberChainResultExpr id) {
      constructUnresolvedMemberChainResultExpr(id)
    } or
    TUnresolvedMemberExpr(Raw::UnresolvedMemberExpr id) { constructUnresolvedMemberExpr(id) } or
    TUnresolvedPatternExpr(Raw::UnresolvedPatternExpr id) { constructUnresolvedPatternExpr(id) } or
    TUnresolvedSpecializeExpr(Raw::UnresolvedSpecializeExpr id) {
      constructUnresolvedSpecializeExpr(id)
    } or
    TUnresolvedTypeConversionExpr(Raw::UnresolvedTypeConversionExpr id) {
      constructUnresolvedTypeConversionExpr(id)
    } or
    TVarargExpansionExpr(Raw::VarargExpansionExpr id) { constructVarargExpansionExpr(id) } or
    TAnyPattern(Raw::AnyPattern id) { constructAnyPattern(id) } or
    TBindingPattern(Raw::BindingPattern id) { constructBindingPattern(id) } or
    TBoolPattern(Raw::BoolPattern id) { constructBoolPattern(id) } or
    TEnumElementPattern(Raw::EnumElementPattern id) { constructEnumElementPattern(id) } or
    TExprPattern(Raw::ExprPattern id) { constructExprPattern(id) } or
    TIsPattern(Raw::IsPattern id) { constructIsPattern(id) } or
    TNamedPattern(Raw::NamedPattern id) { constructNamedPattern(id) } or
    TOptionalSomePattern(Raw::OptionalSomePattern id) { constructOptionalSomePattern(id) } or
    TParenPattern(Raw::ParenPattern id) { constructParenPattern(id) } or
    TTuplePattern(Raw::TuplePattern id) { constructTuplePattern(id) } or
    TTypedPattern(Raw::TypedPattern id) { constructTypedPattern(id) } or
    TBraceStmt(Raw::BraceStmt id) { constructBraceStmt(id) } or
    TBreakStmt(Raw::BreakStmt id) { constructBreakStmt(id) } or
    TCaseLabelItem(Raw::CaseLabelItem id) { constructCaseLabelItem(id) } or
    TCaseStmt(Raw::CaseStmt id) { constructCaseStmt(id) } or
    TConditionElement(Raw::ConditionElement id) { constructConditionElement(id) } or
    TContinueStmt(Raw::ContinueStmt id) { constructContinueStmt(id) } or
    TDeferStmt(Raw::DeferStmt id) { constructDeferStmt(id) } or
    TDoCatchStmt(Raw::DoCatchStmt id) { constructDoCatchStmt(id) } or
    TDoStmt(Raw::DoStmt id) { constructDoStmt(id) } or
    TFailStmt(Raw::FailStmt id) { constructFailStmt(id) } or
    TFallthroughStmt(Raw::FallthroughStmt id) { constructFallthroughStmt(id) } or
    TForEachStmt(Raw::ForEachStmt id) { constructForEachStmt(id) } or
    TGuardStmt(Raw::GuardStmt id) { constructGuardStmt(id) } or
    TIfStmt(Raw::IfStmt id) { constructIfStmt(id) } or
    TPoundAssertStmt(Raw::PoundAssertStmt id) { constructPoundAssertStmt(id) } or
    TRepeatWhileStmt(Raw::RepeatWhileStmt id) { constructRepeatWhileStmt(id) } or
    TReturnStmt(Raw::ReturnStmt id) { constructReturnStmt(id) } or
    TStmtCondition(Raw::StmtCondition id) { constructStmtCondition(id) } or
    TSwitchStmt(Raw::SwitchStmt id) { constructSwitchStmt(id) } or
    TThrowStmt(Raw::ThrowStmt id) { constructThrowStmt(id) } or
    TWhileStmt(Raw::WhileStmt id) { constructWhileStmt(id) } or
    TYieldStmt(Raw::YieldStmt id) { constructYieldStmt(id) } or
    TArraySliceType(Raw::ArraySliceType id) { constructArraySliceType(id) } or
    TBoundGenericClassType(Raw::BoundGenericClassType id) { constructBoundGenericClassType(id) } or
    TBoundGenericEnumType(Raw::BoundGenericEnumType id) { constructBoundGenericEnumType(id) } or
    TBoundGenericStructType(Raw::BoundGenericStructType id) { constructBoundGenericStructType(id) } or
    TBuiltinBridgeObjectType(Raw::BuiltinBridgeObjectType id) {
      constructBuiltinBridgeObjectType(id)
    } or
    TBuiltinDefaultActorStorageType(Raw::BuiltinDefaultActorStorageType id) {
      constructBuiltinDefaultActorStorageType(id)
    } or
    TBuiltinExecutorType(Raw::BuiltinExecutorType id) { constructBuiltinExecutorType(id) } or
    TBuiltinFloatType(Raw::BuiltinFloatType id) { constructBuiltinFloatType(id) } or
    TBuiltinIntegerLiteralType(Raw::BuiltinIntegerLiteralType id) {
      constructBuiltinIntegerLiteralType(id)
    } or
    TBuiltinIntegerType(Raw::BuiltinIntegerType id) { constructBuiltinIntegerType(id) } or
    TBuiltinJobType(Raw::BuiltinJobType id) { constructBuiltinJobType(id) } or
    TBuiltinNativeObjectType(Raw::BuiltinNativeObjectType id) {
      constructBuiltinNativeObjectType(id)
    } or
    TBuiltinRawPointerType(Raw::BuiltinRawPointerType id) { constructBuiltinRawPointerType(id) } or
    TBuiltinRawUnsafeContinuationType(Raw::BuiltinRawUnsafeContinuationType id) {
      constructBuiltinRawUnsafeContinuationType(id)
    } or
    TBuiltinUnsafeValueBufferType(Raw::BuiltinUnsafeValueBufferType id) {
      constructBuiltinUnsafeValueBufferType(id)
    } or
    TBuiltinVectorType(Raw::BuiltinVectorType id) { constructBuiltinVectorType(id) } or
    TClassType(Raw::ClassType id) { constructClassType(id) } or
    TDependentMemberType(Raw::DependentMemberType id) { constructDependentMemberType(id) } or
    TDictionaryType(Raw::DictionaryType id) { constructDictionaryType(id) } or
    TDynamicSelfType(Raw::DynamicSelfType id) { constructDynamicSelfType(id) } or
    TEnumType(Raw::EnumType id) { constructEnumType(id) } or
    TErrorType(Raw::ErrorType id) { constructErrorType(id) } or
    TExistentialMetatypeType(Raw::ExistentialMetatypeType id) {
      constructExistentialMetatypeType(id)
    } or
    TExistentialType(Raw::ExistentialType id) { constructExistentialType(id) } or
    TFunctionType(Raw::FunctionType id) { constructFunctionType(id) } or
    TGenericFunctionType(Raw::GenericFunctionType id) { constructGenericFunctionType(id) } or
    TGenericTypeParamType(Raw::GenericTypeParamType id) { constructGenericTypeParamType(id) } or
    TInOutType(Raw::InOutType id) { constructInOutType(id) } or
    TLValueType(Raw::LValueType id) { constructLValueType(id) } or
    TMetatypeType(Raw::MetatypeType id) { constructMetatypeType(id) } or
    TModuleType(Raw::ModuleType id) { constructModuleType(id) } or
    TOpaqueTypeArchetypeType(Raw::OpaqueTypeArchetypeType id) {
      constructOpaqueTypeArchetypeType(id)
    } or
    TOpenedArchetypeType(Raw::OpenedArchetypeType id) { constructOpenedArchetypeType(id) } or
    TOptionalType(Raw::OptionalType id) { constructOptionalType(id) } or
    TParameterizedProtocolType(Raw::ParameterizedProtocolType id) {
      constructParameterizedProtocolType(id)
    } or
    TParenType(Raw::ParenType id) { constructParenType(id) } or
    TPrimaryArchetypeType(Raw::PrimaryArchetypeType id) { constructPrimaryArchetypeType(id) } or
    TProtocolCompositionType(Raw::ProtocolCompositionType id) {
      constructProtocolCompositionType(id)
    } or
    TProtocolType(Raw::ProtocolType id) { constructProtocolType(id) } or
    TStructType(Raw::StructType id) { constructStructType(id) } or
    TTupleType(Raw::TupleType id) { constructTupleType(id) } or
    TTypeAliasType(Raw::TypeAliasType id) { constructTypeAliasType(id) } or
    TTypeRepr(Raw::TypeRepr id) { constructTypeRepr(id) } or
    TUnboundGenericType(Raw::UnboundGenericType id) { constructUnboundGenericType(id) } or
    TUnmanagedStorageType(Raw::UnmanagedStorageType id) { constructUnmanagedStorageType(id) } or
    TUnownedStorageType(Raw::UnownedStorageType id) { constructUnownedStorageType(id) } or
    TUnresolvedType(Raw::UnresolvedType id) { constructUnresolvedType(id) } or
    TVariadicSequenceType(Raw::VariadicSequenceType id) { constructVariadicSequenceType(id) } or
    TWeakStorageType(Raw::WeakStorageType id) { constructWeakStorageType(id) }

  class TAstNode =
    TAvailabilityInfo or TAvailabilitySpec or TCaseLabelItem or TConditionElement or TDecl or
        TExpr or TPattern or TStmt or TStmtCondition or TTypeRepr;

  class TAvailabilitySpec = TOtherAvailabilitySpec or TPlatformVersionAvailabilitySpec;

  class TCallable = TAbstractClosureExpr or TAbstractFunctionDecl;

  class TErrorElement =
    TErrorExpr or TErrorType or TOverloadedDeclRefExpr or TUnresolvedDeclRefExpr or
        TUnresolvedDotExpr or TUnresolvedMemberChainResultExpr or TUnresolvedMemberExpr or
        TUnresolvedPatternExpr or TUnresolvedSpecializeExpr or TUnresolvedType or
        TUnresolvedTypeConversionExpr or TUnspecifiedElement;

  class TFile = TDbFile or TUnknownFile;

  class TLocatable = TArgument or TAstNode or TComment or TDiagnostics or TErrorElement;

  class TLocation = TDbLocation or TUnknownLocation;

  class TAbstractFunctionDecl = TConstructorDecl or TDestructorDecl or TFuncDecl;

  class TAbstractStorageDecl = TSubscriptDecl or TVarDecl;

  class TAbstractTypeParamDecl = TAssociatedTypeDecl or TGenericTypeParamDecl;

  class TDecl =
    TCapturedDecl or TEnumCaseDecl or TExtensionDecl or TIfConfigDecl or TImportDecl or
        TMissingMemberDecl or TOperatorDecl or TPatternBindingDecl or TPoundDiagnosticDecl or
        TPrecedenceGroupDecl or TTopLevelCodeDecl or TValueDecl;

  class TFuncDecl = TAccessorDecl or TConcreteFuncDecl;

  class TGenericContext =
    TAbstractFunctionDecl or TExtensionDecl or TGenericTypeDecl or TSubscriptDecl;

  class TGenericTypeDecl = TNominalTypeDecl or TOpaqueTypeDecl or TTypeAliasDecl;

  class TNominalTypeDecl = TClassDecl or TEnumDecl or TProtocolDecl or TStructDecl;

  class TOperatorDecl = TInfixOperatorDecl or TPostfixOperatorDecl or TPrefixOperatorDecl;

  class TTypeDecl = TAbstractTypeParamDecl or TGenericTypeDecl or TModuleDecl;

  class TValueDecl = TAbstractFunctionDecl or TAbstractStorageDecl or TEnumElementDecl or TTypeDecl;

  class TVarDecl = TConcreteVarDecl or TParamDecl;

  class TAbstractClosureExpr = TAutoClosureExpr or TClosureExpr;

  class TAnyTryExpr = TForceTryExpr or TOptionalTryExpr or TTryExpr;

  class TApplyExpr =
    TBinaryExpr or TCallExpr or TPostfixUnaryExpr or TPrefixUnaryExpr or TSelfApplyExpr;

  class TBuiltinLiteralExpr =
    TBooleanLiteralExpr or TMagicIdentifierLiteralExpr or TNumberLiteralExpr or TStringLiteralExpr;

  class TCheckedCastExpr = TConditionalCheckedCastExpr or TForcedCheckedCastExpr or TIsExpr;

  class TCollectionExpr = TArrayExpr or TDictionaryExpr;

  class TDynamicLookupExpr = TDynamicMemberRefExpr or TDynamicSubscriptExpr;

  class TExplicitCastExpr = TCheckedCastExpr or TCoerceExpr;

  class TExpr =
    TAbstractClosureExpr or TAnyTryExpr or TAppliedPropertyWrapperExpr or TApplyExpr or
        TAssignExpr or TBindOptionalExpr or TCaptureListExpr or TCollectionExpr or TDeclRefExpr or
        TDefaultArgumentExpr or TDiscardAssignmentExpr or TDotSyntaxBaseIgnoredExpr or
        TDynamicTypeExpr or TEnumIsCaseExpr or TErrorExpr or TExplicitCastExpr or TForceValueExpr or
        TIdentityExpr or TIfExpr or TImplicitConversionExpr or TInOutExpr or
        TKeyPathApplicationExpr or TKeyPathDotExpr or TKeyPathExpr or TLazyInitializerExpr or
        TLiteralExpr or TLookupExpr or TMakeTemporarilyEscapableExpr or TObjCSelectorExpr or
        TOneWayExpr or TOpaqueValueExpr or TOpenExistentialExpr or TOptionalEvaluationExpr or
        TOtherConstructorDeclRefExpr or TOverloadedDeclRefExpr or
        TPropertyWrapperValuePlaceholderExpr or TRebindSelfInConstructorExpr or TSequenceExpr or
        TSuperRefExpr or TTapExpr or TTupleElementExpr or TTupleExpr or TTypeExpr or
        TUnresolvedDeclRefExpr or TUnresolvedDotExpr or TUnresolvedMemberExpr or
        TUnresolvedPatternExpr or TUnresolvedSpecializeExpr or TVarargExpansionExpr;

  class TIdentityExpr =
    TAwaitExpr or TDotSelfExpr or TParenExpr or TUnresolvedMemberChainResultExpr;

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

  class TLiteralExpr =
    TBuiltinLiteralExpr or TInterpolatedStringLiteralExpr or TNilLiteralExpr or
        TObjectLiteralExpr or TRegexLiteralExpr;

  class TLookupExpr = TDynamicLookupExpr or TMemberRefExpr or TMethodLookupExpr or TSubscriptExpr;

  class TNumberLiteralExpr = TFloatLiteralExpr or TIntegerLiteralExpr;

  class TSelfApplyExpr = TConstructorRefCallExpr or TDotSyntaxCallExpr;

  class TPattern =
    TAnyPattern or TBindingPattern or TBoolPattern or TEnumElementPattern or TExprPattern or
        TIsPattern or TNamedPattern or TOptionalSomePattern or TParenPattern or TTuplePattern or
        TTypedPattern;

  class TLabeledConditionalStmt = TGuardStmt or TIfStmt or TWhileStmt;

  class TLabeledStmt =
    TDoCatchStmt or TDoStmt or TForEachStmt or TLabeledConditionalStmt or TRepeatWhileStmt or
        TSwitchStmt;

  class TStmt =
    TBraceStmt or TBreakStmt or TCaseStmt or TContinueStmt or TDeferStmt or TFailStmt or
        TFallthroughStmt or TLabeledStmt or TPoundAssertStmt or TReturnStmt or TThrowStmt or
        TYieldStmt;

  class TAnyBuiltinIntegerType = TBuiltinIntegerLiteralType or TBuiltinIntegerType;

  class TAnyFunctionType = TFunctionType or TGenericFunctionType;

  class TAnyGenericType = TNominalOrBoundGenericNominalType or TUnboundGenericType;

  class TAnyMetatypeType = TExistentialMetatypeType or TMetatypeType;

  class TArchetypeType = TOpaqueTypeArchetypeType or TOpenedArchetypeType or TPrimaryArchetypeType;

  class TBoundGenericType =
    TBoundGenericClassType or TBoundGenericEnumType or TBoundGenericStructType;

  class TBuiltinType =
    TAnyBuiltinIntegerType or TBuiltinBridgeObjectType or TBuiltinDefaultActorStorageType or
        TBuiltinExecutorType or TBuiltinFloatType or TBuiltinJobType or TBuiltinNativeObjectType or
        TBuiltinRawPointerType or TBuiltinRawUnsafeContinuationType or
        TBuiltinUnsafeValueBufferType or TBuiltinVectorType;

  class TNominalOrBoundGenericNominalType = TBoundGenericType or TNominalType;

  class TNominalType = TClassType or TEnumType or TProtocolType or TStructType;

  class TReferenceStorageType = TUnmanagedStorageType or TUnownedStorageType or TWeakStorageType;

  class TSubstitutableType = TArchetypeType or TGenericTypeParamType;

  class TSugarType = TParenType or TSyntaxSugarType or TTypeAliasType;

  class TSyntaxSugarType = TDictionaryType or TUnarySyntaxSugarType;

  class TType =
    TAnyFunctionType or TAnyGenericType or TAnyMetatypeType or TBuiltinType or
        TDependentMemberType or TDynamicSelfType or TErrorType or TExistentialType or TInOutType or
        TLValueType or TModuleType or TParameterizedProtocolType or TProtocolCompositionType or
        TReferenceStorageType or TSubstitutableType or TSugarType or TTupleType or TUnresolvedType;

  class TUnarySyntaxSugarType = TArraySliceType or TOptionalType or TVariadicSequenceType;

  cached
  TAvailabilityInfo convertAvailabilityInfoFromRaw(Raw::Element e) { result = TAvailabilityInfo(e) }

  cached
  TComment convertCommentFromRaw(Raw::Element e) { result = TComment(e) }

  cached
  TDbFile convertDbFileFromRaw(Raw::Element e) { result = TDbFile(e) }

  cached
  TDbLocation convertDbLocationFromRaw(Raw::Element e) { result = TDbLocation(e) }

  cached
  TDiagnostics convertDiagnosticsFromRaw(Raw::Element e) { result = TDiagnostics(e) }

  cached
  TOtherAvailabilitySpec convertOtherAvailabilitySpecFromRaw(Raw::Element e) {
    result = TOtherAvailabilitySpec(e)
  }

  cached
  TPlatformVersionAvailabilitySpec convertPlatformVersionAvailabilitySpecFromRaw(Raw::Element e) {
    result = TPlatformVersionAvailabilitySpec(e)
  }

  cached
  TUnknownFile convertUnknownFileFromRaw(Raw::Element e) { none() }

  cached
  TUnknownLocation convertUnknownLocationFromRaw(Raw::Element e) { none() }

  cached
  TUnspecifiedElement convertUnspecifiedElementFromRaw(Raw::Element e) {
    result = TUnspecifiedElement(e)
  }

  cached
  TAccessorDecl convertAccessorDeclFromRaw(Raw::Element e) { result = TAccessorDecl(e) }

  cached
  TAssociatedTypeDecl convertAssociatedTypeDeclFromRaw(Raw::Element e) {
    result = TAssociatedTypeDecl(e)
  }

  cached
  TCapturedDecl convertCapturedDeclFromRaw(Raw::Element e) { result = TCapturedDecl(e) }

  cached
  TClassDecl convertClassDeclFromRaw(Raw::Element e) { result = TClassDecl(e) }

  cached
  TConcreteFuncDecl convertConcreteFuncDeclFromRaw(Raw::Element e) { result = TConcreteFuncDecl(e) }

  cached
  TConcreteVarDecl convertConcreteVarDeclFromRaw(Raw::Element e) { result = TConcreteVarDecl(e) }

  cached
  TConstructorDecl convertConstructorDeclFromRaw(Raw::Element e) { result = TConstructorDecl(e) }

  cached
  TDestructorDecl convertDestructorDeclFromRaw(Raw::Element e) { result = TDestructorDecl(e) }

  cached
  TEnumCaseDecl convertEnumCaseDeclFromRaw(Raw::Element e) { result = TEnumCaseDecl(e) }

  cached
  TEnumDecl convertEnumDeclFromRaw(Raw::Element e) { result = TEnumDecl(e) }

  cached
  TEnumElementDecl convertEnumElementDeclFromRaw(Raw::Element e) { result = TEnumElementDecl(e) }

  cached
  TExtensionDecl convertExtensionDeclFromRaw(Raw::Element e) { result = TExtensionDecl(e) }

  cached
  TGenericTypeParamDecl convertGenericTypeParamDeclFromRaw(Raw::Element e) {
    result = TGenericTypeParamDecl(e)
  }

  cached
  TIfConfigDecl convertIfConfigDeclFromRaw(Raw::Element e) { result = TIfConfigDecl(e) }

  cached
  TImportDecl convertImportDeclFromRaw(Raw::Element e) { result = TImportDecl(e) }

  cached
  TInfixOperatorDecl convertInfixOperatorDeclFromRaw(Raw::Element e) {
    result = TInfixOperatorDecl(e)
  }

  cached
  TMissingMemberDecl convertMissingMemberDeclFromRaw(Raw::Element e) {
    result = TMissingMemberDecl(e)
  }

  cached
  TModuleDecl convertModuleDeclFromRaw(Raw::Element e) { result = TModuleDecl(e) }

  cached
  TOpaqueTypeDecl convertOpaqueTypeDeclFromRaw(Raw::Element e) { result = TOpaqueTypeDecl(e) }

  cached
  TParamDecl convertParamDeclFromRaw(Raw::Element e) { result = TParamDecl(e) }

  cached
  TPatternBindingDecl convertPatternBindingDeclFromRaw(Raw::Element e) {
    result = TPatternBindingDecl(e)
  }

  cached
  TPostfixOperatorDecl convertPostfixOperatorDeclFromRaw(Raw::Element e) {
    result = TPostfixOperatorDecl(e)
  }

  cached
  TPoundDiagnosticDecl convertPoundDiagnosticDeclFromRaw(Raw::Element e) {
    result = TPoundDiagnosticDecl(e)
  }

  cached
  TPrecedenceGroupDecl convertPrecedenceGroupDeclFromRaw(Raw::Element e) {
    result = TPrecedenceGroupDecl(e)
  }

  cached
  TPrefixOperatorDecl convertPrefixOperatorDeclFromRaw(Raw::Element e) {
    result = TPrefixOperatorDecl(e)
  }

  cached
  TProtocolDecl convertProtocolDeclFromRaw(Raw::Element e) { result = TProtocolDecl(e) }

  cached
  TStructDecl convertStructDeclFromRaw(Raw::Element e) { result = TStructDecl(e) }

  cached
  TSubscriptDecl convertSubscriptDeclFromRaw(Raw::Element e) { result = TSubscriptDecl(e) }

  cached
  TTopLevelCodeDecl convertTopLevelCodeDeclFromRaw(Raw::Element e) { result = TTopLevelCodeDecl(e) }

  cached
  TTypeAliasDecl convertTypeAliasDeclFromRaw(Raw::Element e) { result = TTypeAliasDecl(e) }

  cached
  TAbiSafeConversionExpr convertAbiSafeConversionExprFromRaw(Raw::Element e) {
    result = TAbiSafeConversionExpr(e)
  }

  cached
  TAnyHashableErasureExpr convertAnyHashableErasureExprFromRaw(Raw::Element e) {
    result = TAnyHashableErasureExpr(e)
  }

  cached
  TAppliedPropertyWrapperExpr convertAppliedPropertyWrapperExprFromRaw(Raw::Element e) {
    result = TAppliedPropertyWrapperExpr(e)
  }

  cached
  TArchetypeToSuperExpr convertArchetypeToSuperExprFromRaw(Raw::Element e) {
    result = TArchetypeToSuperExpr(e)
  }

  cached
  TArgument convertArgumentFromRaw(Raw::Element e) { result = TArgument(e) }

  cached
  TArrayExpr convertArrayExprFromRaw(Raw::Element e) { result = TArrayExpr(e) }

  cached
  TArrayToPointerExpr convertArrayToPointerExprFromRaw(Raw::Element e) {
    result = TArrayToPointerExpr(e)
  }

  cached
  TAssignExpr convertAssignExprFromRaw(Raw::Element e) { result = TAssignExpr(e) }

  cached
  TAutoClosureExpr convertAutoClosureExprFromRaw(Raw::Element e) { result = TAutoClosureExpr(e) }

  cached
  TAwaitExpr convertAwaitExprFromRaw(Raw::Element e) { result = TAwaitExpr(e) }

  cached
  TBinaryExpr convertBinaryExprFromRaw(Raw::Element e) { result = TBinaryExpr(e) }

  cached
  TBindOptionalExpr convertBindOptionalExprFromRaw(Raw::Element e) { result = TBindOptionalExpr(e) }

  cached
  TBooleanLiteralExpr convertBooleanLiteralExprFromRaw(Raw::Element e) {
    result = TBooleanLiteralExpr(e)
  }

  cached
  TBridgeFromObjCExpr convertBridgeFromObjCExprFromRaw(Raw::Element e) {
    result = TBridgeFromObjCExpr(e)
  }

  cached
  TBridgeToObjCExpr convertBridgeToObjCExprFromRaw(Raw::Element e) { result = TBridgeToObjCExpr(e) }

  cached
  TCallExpr convertCallExprFromRaw(Raw::Element e) { result = TCallExpr(e) }

  cached
  TCaptureListExpr convertCaptureListExprFromRaw(Raw::Element e) { result = TCaptureListExpr(e) }

  cached
  TClassMetatypeToObjectExpr convertClassMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TClassMetatypeToObjectExpr(e)
  }

  cached
  TClosureExpr convertClosureExprFromRaw(Raw::Element e) { result = TClosureExpr(e) }

  cached
  TCoerceExpr convertCoerceExprFromRaw(Raw::Element e) { result = TCoerceExpr(e) }

  cached
  TCollectionUpcastConversionExpr convertCollectionUpcastConversionExprFromRaw(Raw::Element e) {
    result = TCollectionUpcastConversionExpr(e)
  }

  cached
  TConditionalBridgeFromObjCExpr convertConditionalBridgeFromObjCExprFromRaw(Raw::Element e) {
    result = TConditionalBridgeFromObjCExpr(e)
  }

  cached
  TConditionalCheckedCastExpr convertConditionalCheckedCastExprFromRaw(Raw::Element e) {
    result = TConditionalCheckedCastExpr(e)
  }

  cached
  TConstructorRefCallExpr convertConstructorRefCallExprFromRaw(Raw::Element e) {
    result = TConstructorRefCallExpr(e)
  }

  cached
  TCovariantFunctionConversionExpr convertCovariantFunctionConversionExprFromRaw(Raw::Element e) {
    result = TCovariantFunctionConversionExpr(e)
  }

  cached
  TCovariantReturnConversionExpr convertCovariantReturnConversionExprFromRaw(Raw::Element e) {
    result = TCovariantReturnConversionExpr(e)
  }

  cached
  TDeclRefExpr convertDeclRefExprFromRaw(Raw::Element e) { result = TDeclRefExpr(e) }

  cached
  TDefaultArgumentExpr convertDefaultArgumentExprFromRaw(Raw::Element e) {
    result = TDefaultArgumentExpr(e)
  }

  cached
  TDerivedToBaseExpr convertDerivedToBaseExprFromRaw(Raw::Element e) {
    result = TDerivedToBaseExpr(e)
  }

  cached
  TDestructureTupleExpr convertDestructureTupleExprFromRaw(Raw::Element e) {
    result = TDestructureTupleExpr(e)
  }

  cached
  TDictionaryExpr convertDictionaryExprFromRaw(Raw::Element e) { result = TDictionaryExpr(e) }

  cached
  TDifferentiableFunctionExpr convertDifferentiableFunctionExprFromRaw(Raw::Element e) {
    result = TDifferentiableFunctionExpr(e)
  }

  cached
  TDifferentiableFunctionExtractOriginalExpr convertDifferentiableFunctionExtractOriginalExprFromRaw(
    Raw::Element e
  ) {
    result = TDifferentiableFunctionExtractOriginalExpr(e)
  }

  cached
  TDiscardAssignmentExpr convertDiscardAssignmentExprFromRaw(Raw::Element e) {
    result = TDiscardAssignmentExpr(e)
  }

  cached
  TDotSelfExpr convertDotSelfExprFromRaw(Raw::Element e) { result = TDotSelfExpr(e) }

  cached
  TDotSyntaxBaseIgnoredExpr convertDotSyntaxBaseIgnoredExprFromRaw(Raw::Element e) {
    result = TDotSyntaxBaseIgnoredExpr(e)
  }

  cached
  TDotSyntaxCallExpr convertDotSyntaxCallExprFromRaw(Raw::Element e) {
    result = TDotSyntaxCallExpr(e)
  }

  cached
  TDynamicMemberRefExpr convertDynamicMemberRefExprFromRaw(Raw::Element e) {
    result = TDynamicMemberRefExpr(e)
  }

  cached
  TDynamicSubscriptExpr convertDynamicSubscriptExprFromRaw(Raw::Element e) {
    result = TDynamicSubscriptExpr(e)
  }

  cached
  TDynamicTypeExpr convertDynamicTypeExprFromRaw(Raw::Element e) { result = TDynamicTypeExpr(e) }

  cached
  TEnumIsCaseExpr convertEnumIsCaseExprFromRaw(Raw::Element e) { result = TEnumIsCaseExpr(e) }

  cached
  TErasureExpr convertErasureExprFromRaw(Raw::Element e) { result = TErasureExpr(e) }

  cached
  TErrorExpr convertErrorExprFromRaw(Raw::Element e) { result = TErrorExpr(e) }

  cached
  TExistentialMetatypeToObjectExpr convertExistentialMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TExistentialMetatypeToObjectExpr(e)
  }

  cached
  TFloatLiteralExpr convertFloatLiteralExprFromRaw(Raw::Element e) { result = TFloatLiteralExpr(e) }

  cached
  TForceTryExpr convertForceTryExprFromRaw(Raw::Element e) { result = TForceTryExpr(e) }

  cached
  TForceValueExpr convertForceValueExprFromRaw(Raw::Element e) { result = TForceValueExpr(e) }

  cached
  TForcedCheckedCastExpr convertForcedCheckedCastExprFromRaw(Raw::Element e) {
    result = TForcedCheckedCastExpr(e)
  }

  cached
  TForeignObjectConversionExpr convertForeignObjectConversionExprFromRaw(Raw::Element e) {
    result = TForeignObjectConversionExpr(e)
  }

  cached
  TFunctionConversionExpr convertFunctionConversionExprFromRaw(Raw::Element e) {
    result = TFunctionConversionExpr(e)
  }

  cached
  TIfExpr convertIfExprFromRaw(Raw::Element e) { result = TIfExpr(e) }

  cached
  TInOutExpr convertInOutExprFromRaw(Raw::Element e) { result = TInOutExpr(e) }

  cached
  TInOutToPointerExpr convertInOutToPointerExprFromRaw(Raw::Element e) {
    result = TInOutToPointerExpr(e)
  }

  cached
  TInjectIntoOptionalExpr convertInjectIntoOptionalExprFromRaw(Raw::Element e) {
    result = TInjectIntoOptionalExpr(e)
  }

  cached
  TIntegerLiteralExpr convertIntegerLiteralExprFromRaw(Raw::Element e) {
    result = TIntegerLiteralExpr(e)
  }

  cached
  TInterpolatedStringLiteralExpr convertInterpolatedStringLiteralExprFromRaw(Raw::Element e) {
    result = TInterpolatedStringLiteralExpr(e)
  }

  cached
  TIsExpr convertIsExprFromRaw(Raw::Element e) { result = TIsExpr(e) }

  cached
  TKeyPathApplicationExpr convertKeyPathApplicationExprFromRaw(Raw::Element e) {
    result = TKeyPathApplicationExpr(e)
  }

  cached
  TKeyPathDotExpr convertKeyPathDotExprFromRaw(Raw::Element e) { result = TKeyPathDotExpr(e) }

  cached
  TKeyPathExpr convertKeyPathExprFromRaw(Raw::Element e) { result = TKeyPathExpr(e) }

  cached
  TLazyInitializerExpr convertLazyInitializerExprFromRaw(Raw::Element e) {
    result = TLazyInitializerExpr(e)
  }

  cached
  TLinearFunctionExpr convertLinearFunctionExprFromRaw(Raw::Element e) {
    result = TLinearFunctionExpr(e)
  }

  cached
  TLinearFunctionExtractOriginalExpr convertLinearFunctionExtractOriginalExprFromRaw(Raw::Element e) {
    result = TLinearFunctionExtractOriginalExpr(e)
  }

  cached
  TLinearToDifferentiableFunctionExpr convertLinearToDifferentiableFunctionExprFromRaw(
    Raw::Element e
  ) {
    result = TLinearToDifferentiableFunctionExpr(e)
  }

  cached
  TLoadExpr convertLoadExprFromRaw(Raw::Element e) { result = TLoadExpr(e) }

  cached
  TMagicIdentifierLiteralExpr convertMagicIdentifierLiteralExprFromRaw(Raw::Element e) {
    result = TMagicIdentifierLiteralExpr(e)
  }

  cached
  TMakeTemporarilyEscapableExpr convertMakeTemporarilyEscapableExprFromRaw(Raw::Element e) {
    result = TMakeTemporarilyEscapableExpr(e)
  }

  cached
  TMemberRefExpr convertMemberRefExprFromRaw(Raw::Element e) { result = TMemberRefExpr(e) }

  cached
  TMetatypeConversionExpr convertMetatypeConversionExprFromRaw(Raw::Element e) {
    result = TMetatypeConversionExpr(e)
  }

  cached
  TMethodLookupExpr convertMethodLookupExprFromRaw(Raw::Element e) { result = TMethodLookupExpr(e) }

  cached
  TNilLiteralExpr convertNilLiteralExprFromRaw(Raw::Element e) { result = TNilLiteralExpr(e) }

  cached
  TObjCSelectorExpr convertObjCSelectorExprFromRaw(Raw::Element e) { result = TObjCSelectorExpr(e) }

  cached
  TObjectLiteralExpr convertObjectLiteralExprFromRaw(Raw::Element e) {
    result = TObjectLiteralExpr(e)
  }

  cached
  TOneWayExpr convertOneWayExprFromRaw(Raw::Element e) { result = TOneWayExpr(e) }

  cached
  TOpaqueValueExpr convertOpaqueValueExprFromRaw(Raw::Element e) { result = TOpaqueValueExpr(e) }

  cached
  TOpenExistentialExpr convertOpenExistentialExprFromRaw(Raw::Element e) {
    result = TOpenExistentialExpr(e)
  }

  cached
  TOptionalEvaluationExpr convertOptionalEvaluationExprFromRaw(Raw::Element e) {
    result = TOptionalEvaluationExpr(e)
  }

  cached
  TOptionalTryExpr convertOptionalTryExprFromRaw(Raw::Element e) { result = TOptionalTryExpr(e) }

  cached
  TOtherConstructorDeclRefExpr convertOtherConstructorDeclRefExprFromRaw(Raw::Element e) {
    result = TOtherConstructorDeclRefExpr(e)
  }

  cached
  TOverloadedDeclRefExpr convertOverloadedDeclRefExprFromRaw(Raw::Element e) {
    result = TOverloadedDeclRefExpr(e)
  }

  cached
  TParenExpr convertParenExprFromRaw(Raw::Element e) { result = TParenExpr(e) }

  cached
  TPointerToPointerExpr convertPointerToPointerExprFromRaw(Raw::Element e) {
    result = TPointerToPointerExpr(e)
  }

  cached
  TPostfixUnaryExpr convertPostfixUnaryExprFromRaw(Raw::Element e) { result = TPostfixUnaryExpr(e) }

  cached
  TPrefixUnaryExpr convertPrefixUnaryExprFromRaw(Raw::Element e) { result = TPrefixUnaryExpr(e) }

  cached
  TPropertyWrapperValuePlaceholderExpr convertPropertyWrapperValuePlaceholderExprFromRaw(
    Raw::Element e
  ) {
    result = TPropertyWrapperValuePlaceholderExpr(e)
  }

  cached
  TProtocolMetatypeToObjectExpr convertProtocolMetatypeToObjectExprFromRaw(Raw::Element e) {
    result = TProtocolMetatypeToObjectExpr(e)
  }

  cached
  TRebindSelfInConstructorExpr convertRebindSelfInConstructorExprFromRaw(Raw::Element e) {
    result = TRebindSelfInConstructorExpr(e)
  }

  cached
  TRegexLiteralExpr convertRegexLiteralExprFromRaw(Raw::Element e) { result = TRegexLiteralExpr(e) }

  cached
  TSequenceExpr convertSequenceExprFromRaw(Raw::Element e) { result = TSequenceExpr(e) }

  cached
  TStringLiteralExpr convertStringLiteralExprFromRaw(Raw::Element e) {
    result = TStringLiteralExpr(e)
  }

  cached
  TStringToPointerExpr convertStringToPointerExprFromRaw(Raw::Element e) {
    result = TStringToPointerExpr(e)
  }

  cached
  TSubscriptExpr convertSubscriptExprFromRaw(Raw::Element e) { result = TSubscriptExpr(e) }

  cached
  TSuperRefExpr convertSuperRefExprFromRaw(Raw::Element e) { result = TSuperRefExpr(e) }

  cached
  TTapExpr convertTapExprFromRaw(Raw::Element e) { result = TTapExpr(e) }

  cached
  TTryExpr convertTryExprFromRaw(Raw::Element e) { result = TTryExpr(e) }

  cached
  TTupleElementExpr convertTupleElementExprFromRaw(Raw::Element e) { result = TTupleElementExpr(e) }

  cached
  TTupleExpr convertTupleExprFromRaw(Raw::Element e) { result = TTupleExpr(e) }

  cached
  TTypeExpr convertTypeExprFromRaw(Raw::Element e) { result = TTypeExpr(e) }

  cached
  TUnderlyingToOpaqueExpr convertUnderlyingToOpaqueExprFromRaw(Raw::Element e) {
    result = TUnderlyingToOpaqueExpr(e)
  }

  cached
  TUnevaluatedInstanceExpr convertUnevaluatedInstanceExprFromRaw(Raw::Element e) {
    result = TUnevaluatedInstanceExpr(e)
  }

  cached
  TUnresolvedDeclRefExpr convertUnresolvedDeclRefExprFromRaw(Raw::Element e) {
    result = TUnresolvedDeclRefExpr(e)
  }

  cached
  TUnresolvedDotExpr convertUnresolvedDotExprFromRaw(Raw::Element e) {
    result = TUnresolvedDotExpr(e)
  }

  cached
  TUnresolvedMemberChainResultExpr convertUnresolvedMemberChainResultExprFromRaw(Raw::Element e) {
    result = TUnresolvedMemberChainResultExpr(e)
  }

  cached
  TUnresolvedMemberExpr convertUnresolvedMemberExprFromRaw(Raw::Element e) {
    result = TUnresolvedMemberExpr(e)
  }

  cached
  TUnresolvedPatternExpr convertUnresolvedPatternExprFromRaw(Raw::Element e) {
    result = TUnresolvedPatternExpr(e)
  }

  cached
  TUnresolvedSpecializeExpr convertUnresolvedSpecializeExprFromRaw(Raw::Element e) {
    result = TUnresolvedSpecializeExpr(e)
  }

  cached
  TUnresolvedTypeConversionExpr convertUnresolvedTypeConversionExprFromRaw(Raw::Element e) {
    result = TUnresolvedTypeConversionExpr(e)
  }

  cached
  TVarargExpansionExpr convertVarargExpansionExprFromRaw(Raw::Element e) {
    result = TVarargExpansionExpr(e)
  }

  cached
  TAnyPattern convertAnyPatternFromRaw(Raw::Element e) { result = TAnyPattern(e) }

  cached
  TBindingPattern convertBindingPatternFromRaw(Raw::Element e) { result = TBindingPattern(e) }

  cached
  TBoolPattern convertBoolPatternFromRaw(Raw::Element e) { result = TBoolPattern(e) }

  cached
  TEnumElementPattern convertEnumElementPatternFromRaw(Raw::Element e) {
    result = TEnumElementPattern(e)
  }

  cached
  TExprPattern convertExprPatternFromRaw(Raw::Element e) { result = TExprPattern(e) }

  cached
  TIsPattern convertIsPatternFromRaw(Raw::Element e) { result = TIsPattern(e) }

  cached
  TNamedPattern convertNamedPatternFromRaw(Raw::Element e) { result = TNamedPattern(e) }

  cached
  TOptionalSomePattern convertOptionalSomePatternFromRaw(Raw::Element e) {
    result = TOptionalSomePattern(e)
  }

  cached
  TParenPattern convertParenPatternFromRaw(Raw::Element e) { result = TParenPattern(e) }

  cached
  TTuplePattern convertTuplePatternFromRaw(Raw::Element e) { result = TTuplePattern(e) }

  cached
  TTypedPattern convertTypedPatternFromRaw(Raw::Element e) { result = TTypedPattern(e) }

  cached
  TBraceStmt convertBraceStmtFromRaw(Raw::Element e) { result = TBraceStmt(e) }

  cached
  TBreakStmt convertBreakStmtFromRaw(Raw::Element e) { result = TBreakStmt(e) }

  cached
  TCaseLabelItem convertCaseLabelItemFromRaw(Raw::Element e) { result = TCaseLabelItem(e) }

  cached
  TCaseStmt convertCaseStmtFromRaw(Raw::Element e) { result = TCaseStmt(e) }

  cached
  TConditionElement convertConditionElementFromRaw(Raw::Element e) { result = TConditionElement(e) }

  cached
  TContinueStmt convertContinueStmtFromRaw(Raw::Element e) { result = TContinueStmt(e) }

  cached
  TDeferStmt convertDeferStmtFromRaw(Raw::Element e) { result = TDeferStmt(e) }

  cached
  TDoCatchStmt convertDoCatchStmtFromRaw(Raw::Element e) { result = TDoCatchStmt(e) }

  cached
  TDoStmt convertDoStmtFromRaw(Raw::Element e) { result = TDoStmt(e) }

  cached
  TFailStmt convertFailStmtFromRaw(Raw::Element e) { result = TFailStmt(e) }

  cached
  TFallthroughStmt convertFallthroughStmtFromRaw(Raw::Element e) { result = TFallthroughStmt(e) }

  cached
  TForEachStmt convertForEachStmtFromRaw(Raw::Element e) { result = TForEachStmt(e) }

  cached
  TGuardStmt convertGuardStmtFromRaw(Raw::Element e) { result = TGuardStmt(e) }

  cached
  TIfStmt convertIfStmtFromRaw(Raw::Element e) { result = TIfStmt(e) }

  cached
  TPoundAssertStmt convertPoundAssertStmtFromRaw(Raw::Element e) { result = TPoundAssertStmt(e) }

  cached
  TRepeatWhileStmt convertRepeatWhileStmtFromRaw(Raw::Element e) { result = TRepeatWhileStmt(e) }

  cached
  TReturnStmt convertReturnStmtFromRaw(Raw::Element e) { result = TReturnStmt(e) }

  cached
  TStmtCondition convertStmtConditionFromRaw(Raw::Element e) { result = TStmtCondition(e) }

  cached
  TSwitchStmt convertSwitchStmtFromRaw(Raw::Element e) { result = TSwitchStmt(e) }

  cached
  TThrowStmt convertThrowStmtFromRaw(Raw::Element e) { result = TThrowStmt(e) }

  cached
  TWhileStmt convertWhileStmtFromRaw(Raw::Element e) { result = TWhileStmt(e) }

  cached
  TYieldStmt convertYieldStmtFromRaw(Raw::Element e) { result = TYieldStmt(e) }

  cached
  TArraySliceType convertArraySliceTypeFromRaw(Raw::Element e) { result = TArraySliceType(e) }

  cached
  TBoundGenericClassType convertBoundGenericClassTypeFromRaw(Raw::Element e) {
    result = TBoundGenericClassType(e)
  }

  cached
  TBoundGenericEnumType convertBoundGenericEnumTypeFromRaw(Raw::Element e) {
    result = TBoundGenericEnumType(e)
  }

  cached
  TBoundGenericStructType convertBoundGenericStructTypeFromRaw(Raw::Element e) {
    result = TBoundGenericStructType(e)
  }

  cached
  TBuiltinBridgeObjectType convertBuiltinBridgeObjectTypeFromRaw(Raw::Element e) {
    result = TBuiltinBridgeObjectType(e)
  }

  cached
  TBuiltinDefaultActorStorageType convertBuiltinDefaultActorStorageTypeFromRaw(Raw::Element e) {
    result = TBuiltinDefaultActorStorageType(e)
  }

  cached
  TBuiltinExecutorType convertBuiltinExecutorTypeFromRaw(Raw::Element e) {
    result = TBuiltinExecutorType(e)
  }

  cached
  TBuiltinFloatType convertBuiltinFloatTypeFromRaw(Raw::Element e) { result = TBuiltinFloatType(e) }

  cached
  TBuiltinIntegerLiteralType convertBuiltinIntegerLiteralTypeFromRaw(Raw::Element e) {
    result = TBuiltinIntegerLiteralType(e)
  }

  cached
  TBuiltinIntegerType convertBuiltinIntegerTypeFromRaw(Raw::Element e) {
    result = TBuiltinIntegerType(e)
  }

  cached
  TBuiltinJobType convertBuiltinJobTypeFromRaw(Raw::Element e) { result = TBuiltinJobType(e) }

  cached
  TBuiltinNativeObjectType convertBuiltinNativeObjectTypeFromRaw(Raw::Element e) {
    result = TBuiltinNativeObjectType(e)
  }

  cached
  TBuiltinRawPointerType convertBuiltinRawPointerTypeFromRaw(Raw::Element e) {
    result = TBuiltinRawPointerType(e)
  }

  cached
  TBuiltinRawUnsafeContinuationType convertBuiltinRawUnsafeContinuationTypeFromRaw(Raw::Element e) {
    result = TBuiltinRawUnsafeContinuationType(e)
  }

  cached
  TBuiltinUnsafeValueBufferType convertBuiltinUnsafeValueBufferTypeFromRaw(Raw::Element e) {
    result = TBuiltinUnsafeValueBufferType(e)
  }

  cached
  TBuiltinVectorType convertBuiltinVectorTypeFromRaw(Raw::Element e) {
    result = TBuiltinVectorType(e)
  }

  cached
  TClassType convertClassTypeFromRaw(Raw::Element e) { result = TClassType(e) }

  cached
  TDependentMemberType convertDependentMemberTypeFromRaw(Raw::Element e) {
    result = TDependentMemberType(e)
  }

  cached
  TDictionaryType convertDictionaryTypeFromRaw(Raw::Element e) { result = TDictionaryType(e) }

  cached
  TDynamicSelfType convertDynamicSelfTypeFromRaw(Raw::Element e) { result = TDynamicSelfType(e) }

  cached
  TEnumType convertEnumTypeFromRaw(Raw::Element e) { result = TEnumType(e) }

  cached
  TErrorType convertErrorTypeFromRaw(Raw::Element e) { result = TErrorType(e) }

  cached
  TExistentialMetatypeType convertExistentialMetatypeTypeFromRaw(Raw::Element e) {
    result = TExistentialMetatypeType(e)
  }

  cached
  TExistentialType convertExistentialTypeFromRaw(Raw::Element e) { result = TExistentialType(e) }

  cached
  TFunctionType convertFunctionTypeFromRaw(Raw::Element e) { result = TFunctionType(e) }

  cached
  TGenericFunctionType convertGenericFunctionTypeFromRaw(Raw::Element e) {
    result = TGenericFunctionType(e)
  }

  cached
  TGenericTypeParamType convertGenericTypeParamTypeFromRaw(Raw::Element e) {
    result = TGenericTypeParamType(e)
  }

  cached
  TInOutType convertInOutTypeFromRaw(Raw::Element e) { result = TInOutType(e) }

  cached
  TLValueType convertLValueTypeFromRaw(Raw::Element e) { result = TLValueType(e) }

  cached
  TMetatypeType convertMetatypeTypeFromRaw(Raw::Element e) { result = TMetatypeType(e) }

  cached
  TModuleType convertModuleTypeFromRaw(Raw::Element e) { result = TModuleType(e) }

  cached
  TOpaqueTypeArchetypeType convertOpaqueTypeArchetypeTypeFromRaw(Raw::Element e) {
    result = TOpaqueTypeArchetypeType(e)
  }

  cached
  TOpenedArchetypeType convertOpenedArchetypeTypeFromRaw(Raw::Element e) {
    result = TOpenedArchetypeType(e)
  }

  cached
  TOptionalType convertOptionalTypeFromRaw(Raw::Element e) { result = TOptionalType(e) }

  cached
  TParameterizedProtocolType convertParameterizedProtocolTypeFromRaw(Raw::Element e) {
    result = TParameterizedProtocolType(e)
  }

  cached
  TParenType convertParenTypeFromRaw(Raw::Element e) { result = TParenType(e) }

  cached
  TPrimaryArchetypeType convertPrimaryArchetypeTypeFromRaw(Raw::Element e) {
    result = TPrimaryArchetypeType(e)
  }

  cached
  TProtocolCompositionType convertProtocolCompositionTypeFromRaw(Raw::Element e) {
    result = TProtocolCompositionType(e)
  }

  cached
  TProtocolType convertProtocolTypeFromRaw(Raw::Element e) { result = TProtocolType(e) }

  cached
  TStructType convertStructTypeFromRaw(Raw::Element e) { result = TStructType(e) }

  cached
  TTupleType convertTupleTypeFromRaw(Raw::Element e) { result = TTupleType(e) }

  cached
  TTypeAliasType convertTypeAliasTypeFromRaw(Raw::Element e) { result = TTypeAliasType(e) }

  cached
  TTypeRepr convertTypeReprFromRaw(Raw::Element e) { result = TTypeRepr(e) }

  cached
  TUnboundGenericType convertUnboundGenericTypeFromRaw(Raw::Element e) {
    result = TUnboundGenericType(e)
  }

  cached
  TUnmanagedStorageType convertUnmanagedStorageTypeFromRaw(Raw::Element e) {
    result = TUnmanagedStorageType(e)
  }

  cached
  TUnownedStorageType convertUnownedStorageTypeFromRaw(Raw::Element e) {
    result = TUnownedStorageType(e)
  }

  cached
  TUnresolvedType convertUnresolvedTypeFromRaw(Raw::Element e) { result = TUnresolvedType(e) }

  cached
  TVariadicSequenceType convertVariadicSequenceTypeFromRaw(Raw::Element e) {
    result = TVariadicSequenceType(e)
  }

  cached
  TWeakStorageType convertWeakStorageTypeFromRaw(Raw::Element e) { result = TWeakStorageType(e) }

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
    result = convertPatternFromRaw(e)
    or
    result = convertStmtFromRaw(e)
    or
    result = convertStmtConditionFromRaw(e)
    or
    result = convertTypeReprFromRaw(e)
  }

  cached
  TAvailabilitySpec convertAvailabilitySpecFromRaw(Raw::Element e) {
    result = convertOtherAvailabilitySpecFromRaw(e)
    or
    result = convertPlatformVersionAvailabilitySpecFromRaw(e)
  }

  cached
  TCallable convertCallableFromRaw(Raw::Element e) {
    result = convertAbstractClosureExprFromRaw(e)
    or
    result = convertAbstractFunctionDeclFromRaw(e)
  }

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

  cached
  TFile convertFileFromRaw(Raw::Element e) {
    result = convertDbFileFromRaw(e)
    or
    result = convertUnknownFileFromRaw(e)
  }

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

  cached
  TLocation convertLocationFromRaw(Raw::Element e) {
    result = convertDbLocationFromRaw(e)
    or
    result = convertUnknownLocationFromRaw(e)
  }

  cached
  TAbstractFunctionDecl convertAbstractFunctionDeclFromRaw(Raw::Element e) {
    result = convertConstructorDeclFromRaw(e)
    or
    result = convertDestructorDeclFromRaw(e)
    or
    result = convertFuncDeclFromRaw(e)
  }

  cached
  TAbstractStorageDecl convertAbstractStorageDeclFromRaw(Raw::Element e) {
    result = convertSubscriptDeclFromRaw(e)
    or
    result = convertVarDeclFromRaw(e)
  }

  cached
  TAbstractTypeParamDecl convertAbstractTypeParamDeclFromRaw(Raw::Element e) {
    result = convertAssociatedTypeDeclFromRaw(e)
    or
    result = convertGenericTypeParamDeclFromRaw(e)
  }

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

  cached
  TFuncDecl convertFuncDeclFromRaw(Raw::Element e) {
    result = convertAccessorDeclFromRaw(e)
    or
    result = convertConcreteFuncDeclFromRaw(e)
  }

  cached
  TGenericContext convertGenericContextFromRaw(Raw::Element e) {
    result = convertAbstractFunctionDeclFromRaw(e)
    or
    result = convertExtensionDeclFromRaw(e)
    or
    result = convertGenericTypeDeclFromRaw(e)
    or
    result = convertSubscriptDeclFromRaw(e)
  }

  cached
  TGenericTypeDecl convertGenericTypeDeclFromRaw(Raw::Element e) {
    result = convertNominalTypeDeclFromRaw(e)
    or
    result = convertOpaqueTypeDeclFromRaw(e)
    or
    result = convertTypeAliasDeclFromRaw(e)
  }

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

  cached
  TOperatorDecl convertOperatorDeclFromRaw(Raw::Element e) {
    result = convertInfixOperatorDeclFromRaw(e)
    or
    result = convertPostfixOperatorDeclFromRaw(e)
    or
    result = convertPrefixOperatorDeclFromRaw(e)
  }

  cached
  TTypeDecl convertTypeDeclFromRaw(Raw::Element e) {
    result = convertAbstractTypeParamDeclFromRaw(e)
    or
    result = convertGenericTypeDeclFromRaw(e)
    or
    result = convertModuleDeclFromRaw(e)
  }

  cached
  TValueDecl convertValueDeclFromRaw(Raw::Element e) {
    result = convertAbstractFunctionDeclFromRaw(e)
    or
    result = convertAbstractStorageDeclFromRaw(e)
    or
    result = convertEnumElementDeclFromRaw(e)
    or
    result = convertTypeDeclFromRaw(e)
  }

  cached
  TVarDecl convertVarDeclFromRaw(Raw::Element e) {
    result = convertConcreteVarDeclFromRaw(e)
    or
    result = convertParamDeclFromRaw(e)
  }

  cached
  TAbstractClosureExpr convertAbstractClosureExprFromRaw(Raw::Element e) {
    result = convertAutoClosureExprFromRaw(e)
    or
    result = convertClosureExprFromRaw(e)
  }

  cached
  TAnyTryExpr convertAnyTryExprFromRaw(Raw::Element e) {
    result = convertForceTryExprFromRaw(e)
    or
    result = convertOptionalTryExprFromRaw(e)
    or
    result = convertTryExprFromRaw(e)
  }

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

  cached
  TCheckedCastExpr convertCheckedCastExprFromRaw(Raw::Element e) {
    result = convertConditionalCheckedCastExprFromRaw(e)
    or
    result = convertForcedCheckedCastExprFromRaw(e)
    or
    result = convertIsExprFromRaw(e)
  }

  cached
  TCollectionExpr convertCollectionExprFromRaw(Raw::Element e) {
    result = convertArrayExprFromRaw(e)
    or
    result = convertDictionaryExprFromRaw(e)
  }

  cached
  TDynamicLookupExpr convertDynamicLookupExprFromRaw(Raw::Element e) {
    result = convertDynamicMemberRefExprFromRaw(e)
    or
    result = convertDynamicSubscriptExprFromRaw(e)
  }

  cached
  TExplicitCastExpr convertExplicitCastExprFromRaw(Raw::Element e) {
    result = convertCheckedCastExprFromRaw(e)
    or
    result = convertCoerceExprFromRaw(e)
  }

  cached
  TExpr convertExprFromRaw(Raw::Element e) {
    result = convertAbstractClosureExprFromRaw(e)
    or
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
    result = convertLazyInitializerExprFromRaw(e)
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
    result = convertOtherConstructorDeclRefExprFromRaw(e)
    or
    result = convertOverloadedDeclRefExprFromRaw(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprFromRaw(e)
    or
    result = convertRebindSelfInConstructorExprFromRaw(e)
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

  cached
  TNumberLiteralExpr convertNumberLiteralExprFromRaw(Raw::Element e) {
    result = convertFloatLiteralExprFromRaw(e)
    or
    result = convertIntegerLiteralExprFromRaw(e)
  }

  cached
  TSelfApplyExpr convertSelfApplyExprFromRaw(Raw::Element e) {
    result = convertConstructorRefCallExprFromRaw(e)
    or
    result = convertDotSyntaxCallExprFromRaw(e)
  }

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

  cached
  TLabeledConditionalStmt convertLabeledConditionalStmtFromRaw(Raw::Element e) {
    result = convertGuardStmtFromRaw(e)
    or
    result = convertIfStmtFromRaw(e)
    or
    result = convertWhileStmtFromRaw(e)
  }

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

  cached
  TAnyBuiltinIntegerType convertAnyBuiltinIntegerTypeFromRaw(Raw::Element e) {
    result = convertBuiltinIntegerLiteralTypeFromRaw(e)
    or
    result = convertBuiltinIntegerTypeFromRaw(e)
  }

  cached
  TAnyFunctionType convertAnyFunctionTypeFromRaw(Raw::Element e) {
    result = convertFunctionTypeFromRaw(e)
    or
    result = convertGenericFunctionTypeFromRaw(e)
  }

  cached
  TAnyGenericType convertAnyGenericTypeFromRaw(Raw::Element e) {
    result = convertNominalOrBoundGenericNominalTypeFromRaw(e)
    or
    result = convertUnboundGenericTypeFromRaw(e)
  }

  cached
  TAnyMetatypeType convertAnyMetatypeTypeFromRaw(Raw::Element e) {
    result = convertExistentialMetatypeTypeFromRaw(e)
    or
    result = convertMetatypeTypeFromRaw(e)
  }

  cached
  TArchetypeType convertArchetypeTypeFromRaw(Raw::Element e) {
    result = convertOpaqueTypeArchetypeTypeFromRaw(e)
    or
    result = convertOpenedArchetypeTypeFromRaw(e)
    or
    result = convertPrimaryArchetypeTypeFromRaw(e)
  }

  cached
  TBoundGenericType convertBoundGenericTypeFromRaw(Raw::Element e) {
    result = convertBoundGenericClassTypeFromRaw(e)
    or
    result = convertBoundGenericEnumTypeFromRaw(e)
    or
    result = convertBoundGenericStructTypeFromRaw(e)
  }

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

  cached
  TNominalOrBoundGenericNominalType convertNominalOrBoundGenericNominalTypeFromRaw(Raw::Element e) {
    result = convertBoundGenericTypeFromRaw(e)
    or
    result = convertNominalTypeFromRaw(e)
  }

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

  cached
  TReferenceStorageType convertReferenceStorageTypeFromRaw(Raw::Element e) {
    result = convertUnmanagedStorageTypeFromRaw(e)
    or
    result = convertUnownedStorageTypeFromRaw(e)
    or
    result = convertWeakStorageTypeFromRaw(e)
  }

  cached
  TSubstitutableType convertSubstitutableTypeFromRaw(Raw::Element e) {
    result = convertArchetypeTypeFromRaw(e)
    or
    result = convertGenericTypeParamTypeFromRaw(e)
  }

  cached
  TSugarType convertSugarTypeFromRaw(Raw::Element e) {
    result = convertParenTypeFromRaw(e)
    or
    result = convertSyntaxSugarTypeFromRaw(e)
    or
    result = convertTypeAliasTypeFromRaw(e)
  }

  cached
  TSyntaxSugarType convertSyntaxSugarTypeFromRaw(Raw::Element e) {
    result = convertDictionaryTypeFromRaw(e)
    or
    result = convertUnarySyntaxSugarTypeFromRaw(e)
  }

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

  cached
  TUnarySyntaxSugarType convertUnarySyntaxSugarTypeFromRaw(Raw::Element e) {
    result = convertArraySliceTypeFromRaw(e)
    or
    result = convertOptionalTypeFromRaw(e)
    or
    result = convertVariadicSequenceTypeFromRaw(e)
  }

  cached
  Raw::Element convertAvailabilityInfoToRaw(TAvailabilityInfo e) { e = TAvailabilityInfo(result) }

  cached
  Raw::Element convertCommentToRaw(TComment e) { e = TComment(result) }

  cached
  Raw::Element convertDbFileToRaw(TDbFile e) { e = TDbFile(result) }

  cached
  Raw::Element convertDbLocationToRaw(TDbLocation e) { e = TDbLocation(result) }

  cached
  Raw::Element convertDiagnosticsToRaw(TDiagnostics e) { e = TDiagnostics(result) }

  cached
  Raw::Element convertOtherAvailabilitySpecToRaw(TOtherAvailabilitySpec e) {
    e = TOtherAvailabilitySpec(result)
  }

  cached
  Raw::Element convertPlatformVersionAvailabilitySpecToRaw(TPlatformVersionAvailabilitySpec e) {
    e = TPlatformVersionAvailabilitySpec(result)
  }

  cached
  Raw::Element convertUnknownFileToRaw(TUnknownFile e) { none() }

  cached
  Raw::Element convertUnknownLocationToRaw(TUnknownLocation e) { none() }

  cached
  Raw::Element convertUnspecifiedElementToRaw(TUnspecifiedElement e) {
    e = TUnspecifiedElement(result)
  }

  cached
  Raw::Element convertAccessorDeclToRaw(TAccessorDecl e) { e = TAccessorDecl(result) }

  cached
  Raw::Element convertAssociatedTypeDeclToRaw(TAssociatedTypeDecl e) {
    e = TAssociatedTypeDecl(result)
  }

  cached
  Raw::Element convertCapturedDeclToRaw(TCapturedDecl e) { e = TCapturedDecl(result) }

  cached
  Raw::Element convertClassDeclToRaw(TClassDecl e) { e = TClassDecl(result) }

  cached
  Raw::Element convertConcreteFuncDeclToRaw(TConcreteFuncDecl e) { e = TConcreteFuncDecl(result) }

  cached
  Raw::Element convertConcreteVarDeclToRaw(TConcreteVarDecl e) { e = TConcreteVarDecl(result) }

  cached
  Raw::Element convertConstructorDeclToRaw(TConstructorDecl e) { e = TConstructorDecl(result) }

  cached
  Raw::Element convertDestructorDeclToRaw(TDestructorDecl e) { e = TDestructorDecl(result) }

  cached
  Raw::Element convertEnumCaseDeclToRaw(TEnumCaseDecl e) { e = TEnumCaseDecl(result) }

  cached
  Raw::Element convertEnumDeclToRaw(TEnumDecl e) { e = TEnumDecl(result) }

  cached
  Raw::Element convertEnumElementDeclToRaw(TEnumElementDecl e) { e = TEnumElementDecl(result) }

  cached
  Raw::Element convertExtensionDeclToRaw(TExtensionDecl e) { e = TExtensionDecl(result) }

  cached
  Raw::Element convertGenericTypeParamDeclToRaw(TGenericTypeParamDecl e) {
    e = TGenericTypeParamDecl(result)
  }

  cached
  Raw::Element convertIfConfigDeclToRaw(TIfConfigDecl e) { e = TIfConfigDecl(result) }

  cached
  Raw::Element convertImportDeclToRaw(TImportDecl e) { e = TImportDecl(result) }

  cached
  Raw::Element convertInfixOperatorDeclToRaw(TInfixOperatorDecl e) {
    e = TInfixOperatorDecl(result)
  }

  cached
  Raw::Element convertMissingMemberDeclToRaw(TMissingMemberDecl e) {
    e = TMissingMemberDecl(result)
  }

  cached
  Raw::Element convertModuleDeclToRaw(TModuleDecl e) { e = TModuleDecl(result) }

  cached
  Raw::Element convertOpaqueTypeDeclToRaw(TOpaqueTypeDecl e) { e = TOpaqueTypeDecl(result) }

  cached
  Raw::Element convertParamDeclToRaw(TParamDecl e) { e = TParamDecl(result) }

  cached
  Raw::Element convertPatternBindingDeclToRaw(TPatternBindingDecl e) {
    e = TPatternBindingDecl(result)
  }

  cached
  Raw::Element convertPostfixOperatorDeclToRaw(TPostfixOperatorDecl e) {
    e = TPostfixOperatorDecl(result)
  }

  cached
  Raw::Element convertPoundDiagnosticDeclToRaw(TPoundDiagnosticDecl e) {
    e = TPoundDiagnosticDecl(result)
  }

  cached
  Raw::Element convertPrecedenceGroupDeclToRaw(TPrecedenceGroupDecl e) {
    e = TPrecedenceGroupDecl(result)
  }

  cached
  Raw::Element convertPrefixOperatorDeclToRaw(TPrefixOperatorDecl e) {
    e = TPrefixOperatorDecl(result)
  }

  cached
  Raw::Element convertProtocolDeclToRaw(TProtocolDecl e) { e = TProtocolDecl(result) }

  cached
  Raw::Element convertStructDeclToRaw(TStructDecl e) { e = TStructDecl(result) }

  cached
  Raw::Element convertSubscriptDeclToRaw(TSubscriptDecl e) { e = TSubscriptDecl(result) }

  cached
  Raw::Element convertTopLevelCodeDeclToRaw(TTopLevelCodeDecl e) { e = TTopLevelCodeDecl(result) }

  cached
  Raw::Element convertTypeAliasDeclToRaw(TTypeAliasDecl e) { e = TTypeAliasDecl(result) }

  cached
  Raw::Element convertAbiSafeConversionExprToRaw(TAbiSafeConversionExpr e) {
    e = TAbiSafeConversionExpr(result)
  }

  cached
  Raw::Element convertAnyHashableErasureExprToRaw(TAnyHashableErasureExpr e) {
    e = TAnyHashableErasureExpr(result)
  }

  cached
  Raw::Element convertAppliedPropertyWrapperExprToRaw(TAppliedPropertyWrapperExpr e) {
    e = TAppliedPropertyWrapperExpr(result)
  }

  cached
  Raw::Element convertArchetypeToSuperExprToRaw(TArchetypeToSuperExpr e) {
    e = TArchetypeToSuperExpr(result)
  }

  cached
  Raw::Element convertArgumentToRaw(TArgument e) { e = TArgument(result) }

  cached
  Raw::Element convertArrayExprToRaw(TArrayExpr e) { e = TArrayExpr(result) }

  cached
  Raw::Element convertArrayToPointerExprToRaw(TArrayToPointerExpr e) {
    e = TArrayToPointerExpr(result)
  }

  cached
  Raw::Element convertAssignExprToRaw(TAssignExpr e) { e = TAssignExpr(result) }

  cached
  Raw::Element convertAutoClosureExprToRaw(TAutoClosureExpr e) { e = TAutoClosureExpr(result) }

  cached
  Raw::Element convertAwaitExprToRaw(TAwaitExpr e) { e = TAwaitExpr(result) }

  cached
  Raw::Element convertBinaryExprToRaw(TBinaryExpr e) { e = TBinaryExpr(result) }

  cached
  Raw::Element convertBindOptionalExprToRaw(TBindOptionalExpr e) { e = TBindOptionalExpr(result) }

  cached
  Raw::Element convertBooleanLiteralExprToRaw(TBooleanLiteralExpr e) {
    e = TBooleanLiteralExpr(result)
  }

  cached
  Raw::Element convertBridgeFromObjCExprToRaw(TBridgeFromObjCExpr e) {
    e = TBridgeFromObjCExpr(result)
  }

  cached
  Raw::Element convertBridgeToObjCExprToRaw(TBridgeToObjCExpr e) { e = TBridgeToObjCExpr(result) }

  cached
  Raw::Element convertCallExprToRaw(TCallExpr e) { e = TCallExpr(result) }

  cached
  Raw::Element convertCaptureListExprToRaw(TCaptureListExpr e) { e = TCaptureListExpr(result) }

  cached
  Raw::Element convertClassMetatypeToObjectExprToRaw(TClassMetatypeToObjectExpr e) {
    e = TClassMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertClosureExprToRaw(TClosureExpr e) { e = TClosureExpr(result) }

  cached
  Raw::Element convertCoerceExprToRaw(TCoerceExpr e) { e = TCoerceExpr(result) }

  cached
  Raw::Element convertCollectionUpcastConversionExprToRaw(TCollectionUpcastConversionExpr e) {
    e = TCollectionUpcastConversionExpr(result)
  }

  cached
  Raw::Element convertConditionalBridgeFromObjCExprToRaw(TConditionalBridgeFromObjCExpr e) {
    e = TConditionalBridgeFromObjCExpr(result)
  }

  cached
  Raw::Element convertConditionalCheckedCastExprToRaw(TConditionalCheckedCastExpr e) {
    e = TConditionalCheckedCastExpr(result)
  }

  cached
  Raw::Element convertConstructorRefCallExprToRaw(TConstructorRefCallExpr e) {
    e = TConstructorRefCallExpr(result)
  }

  cached
  Raw::Element convertCovariantFunctionConversionExprToRaw(TCovariantFunctionConversionExpr e) {
    e = TCovariantFunctionConversionExpr(result)
  }

  cached
  Raw::Element convertCovariantReturnConversionExprToRaw(TCovariantReturnConversionExpr e) {
    e = TCovariantReturnConversionExpr(result)
  }

  cached
  Raw::Element convertDeclRefExprToRaw(TDeclRefExpr e) { e = TDeclRefExpr(result) }

  cached
  Raw::Element convertDefaultArgumentExprToRaw(TDefaultArgumentExpr e) {
    e = TDefaultArgumentExpr(result)
  }

  cached
  Raw::Element convertDerivedToBaseExprToRaw(TDerivedToBaseExpr e) {
    e = TDerivedToBaseExpr(result)
  }

  cached
  Raw::Element convertDestructureTupleExprToRaw(TDestructureTupleExpr e) {
    e = TDestructureTupleExpr(result)
  }

  cached
  Raw::Element convertDictionaryExprToRaw(TDictionaryExpr e) { e = TDictionaryExpr(result) }

  cached
  Raw::Element convertDifferentiableFunctionExprToRaw(TDifferentiableFunctionExpr e) {
    e = TDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element convertDifferentiableFunctionExtractOriginalExprToRaw(
    TDifferentiableFunctionExtractOriginalExpr e
  ) {
    e = TDifferentiableFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element convertDiscardAssignmentExprToRaw(TDiscardAssignmentExpr e) {
    e = TDiscardAssignmentExpr(result)
  }

  cached
  Raw::Element convertDotSelfExprToRaw(TDotSelfExpr e) { e = TDotSelfExpr(result) }

  cached
  Raw::Element convertDotSyntaxBaseIgnoredExprToRaw(TDotSyntaxBaseIgnoredExpr e) {
    e = TDotSyntaxBaseIgnoredExpr(result)
  }

  cached
  Raw::Element convertDotSyntaxCallExprToRaw(TDotSyntaxCallExpr e) {
    e = TDotSyntaxCallExpr(result)
  }

  cached
  Raw::Element convertDynamicMemberRefExprToRaw(TDynamicMemberRefExpr e) {
    e = TDynamicMemberRefExpr(result)
  }

  cached
  Raw::Element convertDynamicSubscriptExprToRaw(TDynamicSubscriptExpr e) {
    e = TDynamicSubscriptExpr(result)
  }

  cached
  Raw::Element convertDynamicTypeExprToRaw(TDynamicTypeExpr e) { e = TDynamicTypeExpr(result) }

  cached
  Raw::Element convertEnumIsCaseExprToRaw(TEnumIsCaseExpr e) { e = TEnumIsCaseExpr(result) }

  cached
  Raw::Element convertErasureExprToRaw(TErasureExpr e) { e = TErasureExpr(result) }

  cached
  Raw::Element convertErrorExprToRaw(TErrorExpr e) { e = TErrorExpr(result) }

  cached
  Raw::Element convertExistentialMetatypeToObjectExprToRaw(TExistentialMetatypeToObjectExpr e) {
    e = TExistentialMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertFloatLiteralExprToRaw(TFloatLiteralExpr e) { e = TFloatLiteralExpr(result) }

  cached
  Raw::Element convertForceTryExprToRaw(TForceTryExpr e) { e = TForceTryExpr(result) }

  cached
  Raw::Element convertForceValueExprToRaw(TForceValueExpr e) { e = TForceValueExpr(result) }

  cached
  Raw::Element convertForcedCheckedCastExprToRaw(TForcedCheckedCastExpr e) {
    e = TForcedCheckedCastExpr(result)
  }

  cached
  Raw::Element convertForeignObjectConversionExprToRaw(TForeignObjectConversionExpr e) {
    e = TForeignObjectConversionExpr(result)
  }

  cached
  Raw::Element convertFunctionConversionExprToRaw(TFunctionConversionExpr e) {
    e = TFunctionConversionExpr(result)
  }

  cached
  Raw::Element convertIfExprToRaw(TIfExpr e) { e = TIfExpr(result) }

  cached
  Raw::Element convertInOutExprToRaw(TInOutExpr e) { e = TInOutExpr(result) }

  cached
  Raw::Element convertInOutToPointerExprToRaw(TInOutToPointerExpr e) {
    e = TInOutToPointerExpr(result)
  }

  cached
  Raw::Element convertInjectIntoOptionalExprToRaw(TInjectIntoOptionalExpr e) {
    e = TInjectIntoOptionalExpr(result)
  }

  cached
  Raw::Element convertIntegerLiteralExprToRaw(TIntegerLiteralExpr e) {
    e = TIntegerLiteralExpr(result)
  }

  cached
  Raw::Element convertInterpolatedStringLiteralExprToRaw(TInterpolatedStringLiteralExpr e) {
    e = TInterpolatedStringLiteralExpr(result)
  }

  cached
  Raw::Element convertIsExprToRaw(TIsExpr e) { e = TIsExpr(result) }

  cached
  Raw::Element convertKeyPathApplicationExprToRaw(TKeyPathApplicationExpr e) {
    e = TKeyPathApplicationExpr(result)
  }

  cached
  Raw::Element convertKeyPathDotExprToRaw(TKeyPathDotExpr e) { e = TKeyPathDotExpr(result) }

  cached
  Raw::Element convertKeyPathExprToRaw(TKeyPathExpr e) { e = TKeyPathExpr(result) }

  cached
  Raw::Element convertLazyInitializerExprToRaw(TLazyInitializerExpr e) {
    e = TLazyInitializerExpr(result)
  }

  cached
  Raw::Element convertLinearFunctionExprToRaw(TLinearFunctionExpr e) {
    e = TLinearFunctionExpr(result)
  }

  cached
  Raw::Element convertLinearFunctionExtractOriginalExprToRaw(TLinearFunctionExtractOriginalExpr e) {
    e = TLinearFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element convertLinearToDifferentiableFunctionExprToRaw(TLinearToDifferentiableFunctionExpr e) {
    e = TLinearToDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element convertLoadExprToRaw(TLoadExpr e) { e = TLoadExpr(result) }

  cached
  Raw::Element convertMagicIdentifierLiteralExprToRaw(TMagicIdentifierLiteralExpr e) {
    e = TMagicIdentifierLiteralExpr(result)
  }

  cached
  Raw::Element convertMakeTemporarilyEscapableExprToRaw(TMakeTemporarilyEscapableExpr e) {
    e = TMakeTemporarilyEscapableExpr(result)
  }

  cached
  Raw::Element convertMemberRefExprToRaw(TMemberRefExpr e) { e = TMemberRefExpr(result) }

  cached
  Raw::Element convertMetatypeConversionExprToRaw(TMetatypeConversionExpr e) {
    e = TMetatypeConversionExpr(result)
  }

  cached
  Raw::Element convertMethodLookupExprToRaw(TMethodLookupExpr e) { e = TMethodLookupExpr(result) }

  cached
  Raw::Element convertNilLiteralExprToRaw(TNilLiteralExpr e) { e = TNilLiteralExpr(result) }

  cached
  Raw::Element convertObjCSelectorExprToRaw(TObjCSelectorExpr e) { e = TObjCSelectorExpr(result) }

  cached
  Raw::Element convertObjectLiteralExprToRaw(TObjectLiteralExpr e) {
    e = TObjectLiteralExpr(result)
  }

  cached
  Raw::Element convertOneWayExprToRaw(TOneWayExpr e) { e = TOneWayExpr(result) }

  cached
  Raw::Element convertOpaqueValueExprToRaw(TOpaqueValueExpr e) { e = TOpaqueValueExpr(result) }

  cached
  Raw::Element convertOpenExistentialExprToRaw(TOpenExistentialExpr e) {
    e = TOpenExistentialExpr(result)
  }

  cached
  Raw::Element convertOptionalEvaluationExprToRaw(TOptionalEvaluationExpr e) {
    e = TOptionalEvaluationExpr(result)
  }

  cached
  Raw::Element convertOptionalTryExprToRaw(TOptionalTryExpr e) { e = TOptionalTryExpr(result) }

  cached
  Raw::Element convertOtherConstructorDeclRefExprToRaw(TOtherConstructorDeclRefExpr e) {
    e = TOtherConstructorDeclRefExpr(result)
  }

  cached
  Raw::Element convertOverloadedDeclRefExprToRaw(TOverloadedDeclRefExpr e) {
    e = TOverloadedDeclRefExpr(result)
  }

  cached
  Raw::Element convertParenExprToRaw(TParenExpr e) { e = TParenExpr(result) }

  cached
  Raw::Element convertPointerToPointerExprToRaw(TPointerToPointerExpr e) {
    e = TPointerToPointerExpr(result)
  }

  cached
  Raw::Element convertPostfixUnaryExprToRaw(TPostfixUnaryExpr e) { e = TPostfixUnaryExpr(result) }

  cached
  Raw::Element convertPrefixUnaryExprToRaw(TPrefixUnaryExpr e) { e = TPrefixUnaryExpr(result) }

  cached
  Raw::Element convertPropertyWrapperValuePlaceholderExprToRaw(
    TPropertyWrapperValuePlaceholderExpr e
  ) {
    e = TPropertyWrapperValuePlaceholderExpr(result)
  }

  cached
  Raw::Element convertProtocolMetatypeToObjectExprToRaw(TProtocolMetatypeToObjectExpr e) {
    e = TProtocolMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertRebindSelfInConstructorExprToRaw(TRebindSelfInConstructorExpr e) {
    e = TRebindSelfInConstructorExpr(result)
  }

  cached
  Raw::Element convertRegexLiteralExprToRaw(TRegexLiteralExpr e) { e = TRegexLiteralExpr(result) }

  cached
  Raw::Element convertSequenceExprToRaw(TSequenceExpr e) { e = TSequenceExpr(result) }

  cached
  Raw::Element convertStringLiteralExprToRaw(TStringLiteralExpr e) {
    e = TStringLiteralExpr(result)
  }

  cached
  Raw::Element convertStringToPointerExprToRaw(TStringToPointerExpr e) {
    e = TStringToPointerExpr(result)
  }

  cached
  Raw::Element convertSubscriptExprToRaw(TSubscriptExpr e) { e = TSubscriptExpr(result) }

  cached
  Raw::Element convertSuperRefExprToRaw(TSuperRefExpr e) { e = TSuperRefExpr(result) }

  cached
  Raw::Element convertTapExprToRaw(TTapExpr e) { e = TTapExpr(result) }

  cached
  Raw::Element convertTryExprToRaw(TTryExpr e) { e = TTryExpr(result) }

  cached
  Raw::Element convertTupleElementExprToRaw(TTupleElementExpr e) { e = TTupleElementExpr(result) }

  cached
  Raw::Element convertTupleExprToRaw(TTupleExpr e) { e = TTupleExpr(result) }

  cached
  Raw::Element convertTypeExprToRaw(TTypeExpr e) { e = TTypeExpr(result) }

  cached
  Raw::Element convertUnderlyingToOpaqueExprToRaw(TUnderlyingToOpaqueExpr e) {
    e = TUnderlyingToOpaqueExpr(result)
  }

  cached
  Raw::Element convertUnevaluatedInstanceExprToRaw(TUnevaluatedInstanceExpr e) {
    e = TUnevaluatedInstanceExpr(result)
  }

  cached
  Raw::Element convertUnresolvedDeclRefExprToRaw(TUnresolvedDeclRefExpr e) {
    e = TUnresolvedDeclRefExpr(result)
  }

  cached
  Raw::Element convertUnresolvedDotExprToRaw(TUnresolvedDotExpr e) {
    e = TUnresolvedDotExpr(result)
  }

  cached
  Raw::Element convertUnresolvedMemberChainResultExprToRaw(TUnresolvedMemberChainResultExpr e) {
    e = TUnresolvedMemberChainResultExpr(result)
  }

  cached
  Raw::Element convertUnresolvedMemberExprToRaw(TUnresolvedMemberExpr e) {
    e = TUnresolvedMemberExpr(result)
  }

  cached
  Raw::Element convertUnresolvedPatternExprToRaw(TUnresolvedPatternExpr e) {
    e = TUnresolvedPatternExpr(result)
  }

  cached
  Raw::Element convertUnresolvedSpecializeExprToRaw(TUnresolvedSpecializeExpr e) {
    e = TUnresolvedSpecializeExpr(result)
  }

  cached
  Raw::Element convertUnresolvedTypeConversionExprToRaw(TUnresolvedTypeConversionExpr e) {
    e = TUnresolvedTypeConversionExpr(result)
  }

  cached
  Raw::Element convertVarargExpansionExprToRaw(TVarargExpansionExpr e) {
    e = TVarargExpansionExpr(result)
  }

  cached
  Raw::Element convertAnyPatternToRaw(TAnyPattern e) { e = TAnyPattern(result) }

  cached
  Raw::Element convertBindingPatternToRaw(TBindingPattern e) { e = TBindingPattern(result) }

  cached
  Raw::Element convertBoolPatternToRaw(TBoolPattern e) { e = TBoolPattern(result) }

  cached
  Raw::Element convertEnumElementPatternToRaw(TEnumElementPattern e) {
    e = TEnumElementPattern(result)
  }

  cached
  Raw::Element convertExprPatternToRaw(TExprPattern e) { e = TExprPattern(result) }

  cached
  Raw::Element convertIsPatternToRaw(TIsPattern e) { e = TIsPattern(result) }

  cached
  Raw::Element convertNamedPatternToRaw(TNamedPattern e) { e = TNamedPattern(result) }

  cached
  Raw::Element convertOptionalSomePatternToRaw(TOptionalSomePattern e) {
    e = TOptionalSomePattern(result)
  }

  cached
  Raw::Element convertParenPatternToRaw(TParenPattern e) { e = TParenPattern(result) }

  cached
  Raw::Element convertTuplePatternToRaw(TTuplePattern e) { e = TTuplePattern(result) }

  cached
  Raw::Element convertTypedPatternToRaw(TTypedPattern e) { e = TTypedPattern(result) }

  cached
  Raw::Element convertBraceStmtToRaw(TBraceStmt e) { e = TBraceStmt(result) }

  cached
  Raw::Element convertBreakStmtToRaw(TBreakStmt e) { e = TBreakStmt(result) }

  cached
  Raw::Element convertCaseLabelItemToRaw(TCaseLabelItem e) { e = TCaseLabelItem(result) }

  cached
  Raw::Element convertCaseStmtToRaw(TCaseStmt e) { e = TCaseStmt(result) }

  cached
  Raw::Element convertConditionElementToRaw(TConditionElement e) { e = TConditionElement(result) }

  cached
  Raw::Element convertContinueStmtToRaw(TContinueStmt e) { e = TContinueStmt(result) }

  cached
  Raw::Element convertDeferStmtToRaw(TDeferStmt e) { e = TDeferStmt(result) }

  cached
  Raw::Element convertDoCatchStmtToRaw(TDoCatchStmt e) { e = TDoCatchStmt(result) }

  cached
  Raw::Element convertDoStmtToRaw(TDoStmt e) { e = TDoStmt(result) }

  cached
  Raw::Element convertFailStmtToRaw(TFailStmt e) { e = TFailStmt(result) }

  cached
  Raw::Element convertFallthroughStmtToRaw(TFallthroughStmt e) { e = TFallthroughStmt(result) }

  cached
  Raw::Element convertForEachStmtToRaw(TForEachStmt e) { e = TForEachStmt(result) }

  cached
  Raw::Element convertGuardStmtToRaw(TGuardStmt e) { e = TGuardStmt(result) }

  cached
  Raw::Element convertIfStmtToRaw(TIfStmt e) { e = TIfStmt(result) }

  cached
  Raw::Element convertPoundAssertStmtToRaw(TPoundAssertStmt e) { e = TPoundAssertStmt(result) }

  cached
  Raw::Element convertRepeatWhileStmtToRaw(TRepeatWhileStmt e) { e = TRepeatWhileStmt(result) }

  cached
  Raw::Element convertReturnStmtToRaw(TReturnStmt e) { e = TReturnStmt(result) }

  cached
  Raw::Element convertStmtConditionToRaw(TStmtCondition e) { e = TStmtCondition(result) }

  cached
  Raw::Element convertSwitchStmtToRaw(TSwitchStmt e) { e = TSwitchStmt(result) }

  cached
  Raw::Element convertThrowStmtToRaw(TThrowStmt e) { e = TThrowStmt(result) }

  cached
  Raw::Element convertWhileStmtToRaw(TWhileStmt e) { e = TWhileStmt(result) }

  cached
  Raw::Element convertYieldStmtToRaw(TYieldStmt e) { e = TYieldStmt(result) }

  cached
  Raw::Element convertArraySliceTypeToRaw(TArraySliceType e) { e = TArraySliceType(result) }

  cached
  Raw::Element convertBoundGenericClassTypeToRaw(TBoundGenericClassType e) {
    e = TBoundGenericClassType(result)
  }

  cached
  Raw::Element convertBoundGenericEnumTypeToRaw(TBoundGenericEnumType e) {
    e = TBoundGenericEnumType(result)
  }

  cached
  Raw::Element convertBoundGenericStructTypeToRaw(TBoundGenericStructType e) {
    e = TBoundGenericStructType(result)
  }

  cached
  Raw::Element convertBuiltinBridgeObjectTypeToRaw(TBuiltinBridgeObjectType e) {
    e = TBuiltinBridgeObjectType(result)
  }

  cached
  Raw::Element convertBuiltinDefaultActorStorageTypeToRaw(TBuiltinDefaultActorStorageType e) {
    e = TBuiltinDefaultActorStorageType(result)
  }

  cached
  Raw::Element convertBuiltinExecutorTypeToRaw(TBuiltinExecutorType e) {
    e = TBuiltinExecutorType(result)
  }

  cached
  Raw::Element convertBuiltinFloatTypeToRaw(TBuiltinFloatType e) { e = TBuiltinFloatType(result) }

  cached
  Raw::Element convertBuiltinIntegerLiteralTypeToRaw(TBuiltinIntegerLiteralType e) {
    e = TBuiltinIntegerLiteralType(result)
  }

  cached
  Raw::Element convertBuiltinIntegerTypeToRaw(TBuiltinIntegerType e) {
    e = TBuiltinIntegerType(result)
  }

  cached
  Raw::Element convertBuiltinJobTypeToRaw(TBuiltinJobType e) { e = TBuiltinJobType(result) }

  cached
  Raw::Element convertBuiltinNativeObjectTypeToRaw(TBuiltinNativeObjectType e) {
    e = TBuiltinNativeObjectType(result)
  }

  cached
  Raw::Element convertBuiltinRawPointerTypeToRaw(TBuiltinRawPointerType e) {
    e = TBuiltinRawPointerType(result)
  }

  cached
  Raw::Element convertBuiltinRawUnsafeContinuationTypeToRaw(TBuiltinRawUnsafeContinuationType e) {
    e = TBuiltinRawUnsafeContinuationType(result)
  }

  cached
  Raw::Element convertBuiltinUnsafeValueBufferTypeToRaw(TBuiltinUnsafeValueBufferType e) {
    e = TBuiltinUnsafeValueBufferType(result)
  }

  cached
  Raw::Element convertBuiltinVectorTypeToRaw(TBuiltinVectorType e) {
    e = TBuiltinVectorType(result)
  }

  cached
  Raw::Element convertClassTypeToRaw(TClassType e) { e = TClassType(result) }

  cached
  Raw::Element convertDependentMemberTypeToRaw(TDependentMemberType e) {
    e = TDependentMemberType(result)
  }

  cached
  Raw::Element convertDictionaryTypeToRaw(TDictionaryType e) { e = TDictionaryType(result) }

  cached
  Raw::Element convertDynamicSelfTypeToRaw(TDynamicSelfType e) { e = TDynamicSelfType(result) }

  cached
  Raw::Element convertEnumTypeToRaw(TEnumType e) { e = TEnumType(result) }

  cached
  Raw::Element convertErrorTypeToRaw(TErrorType e) { e = TErrorType(result) }

  cached
  Raw::Element convertExistentialMetatypeTypeToRaw(TExistentialMetatypeType e) {
    e = TExistentialMetatypeType(result)
  }

  cached
  Raw::Element convertExistentialTypeToRaw(TExistentialType e) { e = TExistentialType(result) }

  cached
  Raw::Element convertFunctionTypeToRaw(TFunctionType e) { e = TFunctionType(result) }

  cached
  Raw::Element convertGenericFunctionTypeToRaw(TGenericFunctionType e) {
    e = TGenericFunctionType(result)
  }

  cached
  Raw::Element convertGenericTypeParamTypeToRaw(TGenericTypeParamType e) {
    e = TGenericTypeParamType(result)
  }

  cached
  Raw::Element convertInOutTypeToRaw(TInOutType e) { e = TInOutType(result) }

  cached
  Raw::Element convertLValueTypeToRaw(TLValueType e) { e = TLValueType(result) }

  cached
  Raw::Element convertMetatypeTypeToRaw(TMetatypeType e) { e = TMetatypeType(result) }

  cached
  Raw::Element convertModuleTypeToRaw(TModuleType e) { e = TModuleType(result) }

  cached
  Raw::Element convertOpaqueTypeArchetypeTypeToRaw(TOpaqueTypeArchetypeType e) {
    e = TOpaqueTypeArchetypeType(result)
  }

  cached
  Raw::Element convertOpenedArchetypeTypeToRaw(TOpenedArchetypeType e) {
    e = TOpenedArchetypeType(result)
  }

  cached
  Raw::Element convertOptionalTypeToRaw(TOptionalType e) { e = TOptionalType(result) }

  cached
  Raw::Element convertParameterizedProtocolTypeToRaw(TParameterizedProtocolType e) {
    e = TParameterizedProtocolType(result)
  }

  cached
  Raw::Element convertParenTypeToRaw(TParenType e) { e = TParenType(result) }

  cached
  Raw::Element convertPrimaryArchetypeTypeToRaw(TPrimaryArchetypeType e) {
    e = TPrimaryArchetypeType(result)
  }

  cached
  Raw::Element convertProtocolCompositionTypeToRaw(TProtocolCompositionType e) {
    e = TProtocolCompositionType(result)
  }

  cached
  Raw::Element convertProtocolTypeToRaw(TProtocolType e) { e = TProtocolType(result) }

  cached
  Raw::Element convertStructTypeToRaw(TStructType e) { e = TStructType(result) }

  cached
  Raw::Element convertTupleTypeToRaw(TTupleType e) { e = TTupleType(result) }

  cached
  Raw::Element convertTypeAliasTypeToRaw(TTypeAliasType e) { e = TTypeAliasType(result) }

  cached
  Raw::Element convertTypeReprToRaw(TTypeRepr e) { e = TTypeRepr(result) }

  cached
  Raw::Element convertUnboundGenericTypeToRaw(TUnboundGenericType e) {
    e = TUnboundGenericType(result)
  }

  cached
  Raw::Element convertUnmanagedStorageTypeToRaw(TUnmanagedStorageType e) {
    e = TUnmanagedStorageType(result)
  }

  cached
  Raw::Element convertUnownedStorageTypeToRaw(TUnownedStorageType e) {
    e = TUnownedStorageType(result)
  }

  cached
  Raw::Element convertUnresolvedTypeToRaw(TUnresolvedType e) { e = TUnresolvedType(result) }

  cached
  Raw::Element convertVariadicSequenceTypeToRaw(TVariadicSequenceType e) {
    e = TVariadicSequenceType(result)
  }

  cached
  Raw::Element convertWeakStorageTypeToRaw(TWeakStorageType e) { e = TWeakStorageType(result) }

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
    result = convertPatternToRaw(e)
    or
    result = convertStmtToRaw(e)
    or
    result = convertStmtConditionToRaw(e)
    or
    result = convertTypeReprToRaw(e)
  }

  cached
  Raw::Element convertAvailabilitySpecToRaw(TAvailabilitySpec e) {
    result = convertOtherAvailabilitySpecToRaw(e)
    or
    result = convertPlatformVersionAvailabilitySpecToRaw(e)
  }

  cached
  Raw::Element convertCallableToRaw(TCallable e) {
    result = convertAbstractClosureExprToRaw(e)
    or
    result = convertAbstractFunctionDeclToRaw(e)
  }

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

  cached
  Raw::Element convertFileToRaw(TFile e) {
    result = convertDbFileToRaw(e)
    or
    result = convertUnknownFileToRaw(e)
  }

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

  cached
  Raw::Element convertLocationToRaw(TLocation e) {
    result = convertDbLocationToRaw(e)
    or
    result = convertUnknownLocationToRaw(e)
  }

  cached
  Raw::Element convertAbstractFunctionDeclToRaw(TAbstractFunctionDecl e) {
    result = convertConstructorDeclToRaw(e)
    or
    result = convertDestructorDeclToRaw(e)
    or
    result = convertFuncDeclToRaw(e)
  }

  cached
  Raw::Element convertAbstractStorageDeclToRaw(TAbstractStorageDecl e) {
    result = convertSubscriptDeclToRaw(e)
    or
    result = convertVarDeclToRaw(e)
  }

  cached
  Raw::Element convertAbstractTypeParamDeclToRaw(TAbstractTypeParamDecl e) {
    result = convertAssociatedTypeDeclToRaw(e)
    or
    result = convertGenericTypeParamDeclToRaw(e)
  }

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

  cached
  Raw::Element convertFuncDeclToRaw(TFuncDecl e) {
    result = convertAccessorDeclToRaw(e)
    or
    result = convertConcreteFuncDeclToRaw(e)
  }

  cached
  Raw::Element convertGenericContextToRaw(TGenericContext e) {
    result = convertAbstractFunctionDeclToRaw(e)
    or
    result = convertExtensionDeclToRaw(e)
    or
    result = convertGenericTypeDeclToRaw(e)
    or
    result = convertSubscriptDeclToRaw(e)
  }

  cached
  Raw::Element convertGenericTypeDeclToRaw(TGenericTypeDecl e) {
    result = convertNominalTypeDeclToRaw(e)
    or
    result = convertOpaqueTypeDeclToRaw(e)
    or
    result = convertTypeAliasDeclToRaw(e)
  }

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

  cached
  Raw::Element convertOperatorDeclToRaw(TOperatorDecl e) {
    result = convertInfixOperatorDeclToRaw(e)
    or
    result = convertPostfixOperatorDeclToRaw(e)
    or
    result = convertPrefixOperatorDeclToRaw(e)
  }

  cached
  Raw::Element convertTypeDeclToRaw(TTypeDecl e) {
    result = convertAbstractTypeParamDeclToRaw(e)
    or
    result = convertGenericTypeDeclToRaw(e)
    or
    result = convertModuleDeclToRaw(e)
  }

  cached
  Raw::Element convertValueDeclToRaw(TValueDecl e) {
    result = convertAbstractFunctionDeclToRaw(e)
    or
    result = convertAbstractStorageDeclToRaw(e)
    or
    result = convertEnumElementDeclToRaw(e)
    or
    result = convertTypeDeclToRaw(e)
  }

  cached
  Raw::Element convertVarDeclToRaw(TVarDecl e) {
    result = convertConcreteVarDeclToRaw(e)
    or
    result = convertParamDeclToRaw(e)
  }

  cached
  Raw::Element convertAbstractClosureExprToRaw(TAbstractClosureExpr e) {
    result = convertAutoClosureExprToRaw(e)
    or
    result = convertClosureExprToRaw(e)
  }

  cached
  Raw::Element convertAnyTryExprToRaw(TAnyTryExpr e) {
    result = convertForceTryExprToRaw(e)
    or
    result = convertOptionalTryExprToRaw(e)
    or
    result = convertTryExprToRaw(e)
  }

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

  cached
  Raw::Element convertCheckedCastExprToRaw(TCheckedCastExpr e) {
    result = convertConditionalCheckedCastExprToRaw(e)
    or
    result = convertForcedCheckedCastExprToRaw(e)
    or
    result = convertIsExprToRaw(e)
  }

  cached
  Raw::Element convertCollectionExprToRaw(TCollectionExpr e) {
    result = convertArrayExprToRaw(e)
    or
    result = convertDictionaryExprToRaw(e)
  }

  cached
  Raw::Element convertDynamicLookupExprToRaw(TDynamicLookupExpr e) {
    result = convertDynamicMemberRefExprToRaw(e)
    or
    result = convertDynamicSubscriptExprToRaw(e)
  }

  cached
  Raw::Element convertExplicitCastExprToRaw(TExplicitCastExpr e) {
    result = convertCheckedCastExprToRaw(e)
    or
    result = convertCoerceExprToRaw(e)
  }

  cached
  Raw::Element convertExprToRaw(TExpr e) {
    result = convertAbstractClosureExprToRaw(e)
    or
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
    result = convertLazyInitializerExprToRaw(e)
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
    result = convertOtherConstructorDeclRefExprToRaw(e)
    or
    result = convertOverloadedDeclRefExprToRaw(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprToRaw(e)
    or
    result = convertRebindSelfInConstructorExprToRaw(e)
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

  cached
  Raw::Element convertNumberLiteralExprToRaw(TNumberLiteralExpr e) {
    result = convertFloatLiteralExprToRaw(e)
    or
    result = convertIntegerLiteralExprToRaw(e)
  }

  cached
  Raw::Element convertSelfApplyExprToRaw(TSelfApplyExpr e) {
    result = convertConstructorRefCallExprToRaw(e)
    or
    result = convertDotSyntaxCallExprToRaw(e)
  }

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

  cached
  Raw::Element convertLabeledConditionalStmtToRaw(TLabeledConditionalStmt e) {
    result = convertGuardStmtToRaw(e)
    or
    result = convertIfStmtToRaw(e)
    or
    result = convertWhileStmtToRaw(e)
  }

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

  cached
  Raw::Element convertAnyBuiltinIntegerTypeToRaw(TAnyBuiltinIntegerType e) {
    result = convertBuiltinIntegerLiteralTypeToRaw(e)
    or
    result = convertBuiltinIntegerTypeToRaw(e)
  }

  cached
  Raw::Element convertAnyFunctionTypeToRaw(TAnyFunctionType e) {
    result = convertFunctionTypeToRaw(e)
    or
    result = convertGenericFunctionTypeToRaw(e)
  }

  cached
  Raw::Element convertAnyGenericTypeToRaw(TAnyGenericType e) {
    result = convertNominalOrBoundGenericNominalTypeToRaw(e)
    or
    result = convertUnboundGenericTypeToRaw(e)
  }

  cached
  Raw::Element convertAnyMetatypeTypeToRaw(TAnyMetatypeType e) {
    result = convertExistentialMetatypeTypeToRaw(e)
    or
    result = convertMetatypeTypeToRaw(e)
  }

  cached
  Raw::Element convertArchetypeTypeToRaw(TArchetypeType e) {
    result = convertOpaqueTypeArchetypeTypeToRaw(e)
    or
    result = convertOpenedArchetypeTypeToRaw(e)
    or
    result = convertPrimaryArchetypeTypeToRaw(e)
  }

  cached
  Raw::Element convertBoundGenericTypeToRaw(TBoundGenericType e) {
    result = convertBoundGenericClassTypeToRaw(e)
    or
    result = convertBoundGenericEnumTypeToRaw(e)
    or
    result = convertBoundGenericStructTypeToRaw(e)
  }

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

  cached
  Raw::Element convertNominalOrBoundGenericNominalTypeToRaw(TNominalOrBoundGenericNominalType e) {
    result = convertBoundGenericTypeToRaw(e)
    or
    result = convertNominalTypeToRaw(e)
  }

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

  cached
  Raw::Element convertReferenceStorageTypeToRaw(TReferenceStorageType e) {
    result = convertUnmanagedStorageTypeToRaw(e)
    or
    result = convertUnownedStorageTypeToRaw(e)
    or
    result = convertWeakStorageTypeToRaw(e)
  }

  cached
  Raw::Element convertSubstitutableTypeToRaw(TSubstitutableType e) {
    result = convertArchetypeTypeToRaw(e)
    or
    result = convertGenericTypeParamTypeToRaw(e)
  }

  cached
  Raw::Element convertSugarTypeToRaw(TSugarType e) {
    result = convertParenTypeToRaw(e)
    or
    result = convertSyntaxSugarTypeToRaw(e)
    or
    result = convertTypeAliasTypeToRaw(e)
  }

  cached
  Raw::Element convertSyntaxSugarTypeToRaw(TSyntaxSugarType e) {
    result = convertDictionaryTypeToRaw(e)
    or
    result = convertUnarySyntaxSugarTypeToRaw(e)
  }

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

  cached
  Raw::Element convertUnarySyntaxSugarTypeToRaw(TUnarySyntaxSugarType e) {
    result = convertArraySliceTypeToRaw(e)
    or
    result = convertOptionalTypeToRaw(e)
    or
    result = convertVariadicSequenceTypeToRaw(e)
  }
}
