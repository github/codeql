private import codeql.swift.generated.SynthConstructors
private import codeql.swift.generated.Raw

cached
module Synth {
  cached
  newtype TElement =
    TComment(Raw::Comment id) { constructComment(id) } or
    TDbFile(Raw::DbFile id) { constructDbFile(id) } or
    TDbLocation(Raw::DbLocation id) { constructDbLocation(id) } or
    TUnknownFile() or
    TUnknownLocation() or
    TAccessorDecl(Raw::AccessorDecl id) { constructAccessorDecl(id) } or
    TAssociatedTypeDecl(Raw::AssociatedTypeDecl id) { constructAssociatedTypeDecl(id) } or
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
    TIfConfigClause(Raw::IfConfigClause id) { constructIfConfigClause(id) } or
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
    TAnyHashableErasureExpr(Raw::AnyHashableErasureExpr id) { constructAnyHashableErasureExpr(id) } or
    TAppliedPropertyWrapperExpr(Raw::AppliedPropertyWrapperExpr id) {
      constructAppliedPropertyWrapperExpr(id)
    } or
    TArchetypeToSuperExpr(Raw::ArchetypeToSuperExpr id) { constructArchetypeToSuperExpr(id) } or
    TArgument(Raw::Argument id) { constructArgument(id) } or
    TArrayExpr(Raw::ArrayExpr id) { constructArrayExpr(id) } or
    TArrayToPointerExpr(Raw::ArrayToPointerExpr id) { constructArrayToPointerExpr(id) } or
    TArrowExpr(Raw::ArrowExpr id) { constructArrowExpr(id) } or
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
    TCodeCompletionExpr(Raw::CodeCompletionExpr id) { constructCodeCompletionExpr(id) } or
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
    TEditorPlaceholderExpr(Raw::EditorPlaceholderExpr id) { constructEditorPlaceholderExpr(id) } or
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
    TNestedArchetypeType(Raw::NestedArchetypeType id) { constructNestedArchetypeType(id) } or
    TOpaqueTypeArchetypeType(Raw::OpaqueTypeArchetypeType id) {
      constructOpaqueTypeArchetypeType(id)
    } or
    TOpenedArchetypeType(Raw::OpenedArchetypeType id) { constructOpenedArchetypeType(id) } or
    TOptionalType(Raw::OptionalType id) { constructOptionalType(id) } or
    TParenType(Raw::ParenType id) { constructParenType(id) } or
    TPlaceholderType(Raw::PlaceholderType id) { constructPlaceholderType(id) } or
    TPrimaryArchetypeType(Raw::PrimaryArchetypeType id) { constructPrimaryArchetypeType(id) } or
    TProtocolCompositionType(Raw::ProtocolCompositionType id) {
      constructProtocolCompositionType(id)
    } or
    TProtocolType(Raw::ProtocolType id) { constructProtocolType(id) } or
    TSequenceArchetypeType(Raw::SequenceArchetypeType id) { constructSequenceArchetypeType(id) } or
    TSilBlockStorageType(Raw::SilBlockStorageType id) { constructSilBlockStorageType(id) } or
    TSilBoxType(Raw::SilBoxType id) { constructSilBoxType(id) } or
    TSilFunctionType(Raw::SilFunctionType id) { constructSilFunctionType(id) } or
    TSilTokenType(Raw::SilTokenType id) { constructSilTokenType(id) } or
    TStructType(Raw::StructType id) { constructStructType(id) } or
    TTupleType(Raw::TupleType id) { constructTupleType(id) } or
    TTypeAliasType(Raw::TypeAliasType id) { constructTypeAliasType(id) } or
    TTypeRepr(Raw::TypeRepr id) { constructTypeRepr(id) } or
    TTypeVariableType(Raw::TypeVariableType id) { constructTypeVariableType(id) } or
    TUnboundGenericType(Raw::UnboundGenericType id) { constructUnboundGenericType(id) } or
    TUnmanagedStorageType(Raw::UnmanagedStorageType id) { constructUnmanagedStorageType(id) } or
    TUnownedStorageType(Raw::UnownedStorageType id) { constructUnownedStorageType(id) } or
    TUnresolvedType(Raw::UnresolvedType id) { constructUnresolvedType(id) } or
    TVariadicSequenceType(Raw::VariadicSequenceType id) { constructVariadicSequenceType(id) } or
    TWeakStorageType(Raw::WeakStorageType id) { constructWeakStorageType(id) }

  class TAstNode =
    TCaseLabelItem or TDecl or TExpr or TPattern or TStmt or TStmtCondition or TTypeRepr;

  class TCallable = TAbstractClosureExpr or TAbstractFunctionDecl;

  class TFile = TDbFile or TUnknownFile;

  class TLocatable = TArgument or TAstNode or TComment or TConditionElement or TIfConfigClause;

  class TLocation = TDbLocation or TUnknownLocation;

  class TAbstractFunctionDecl = TConstructorDecl or TDestructorDecl or TFuncDecl;

  class TAbstractStorageDecl = TSubscriptDecl or TVarDecl;

  class TAbstractTypeParamDecl = TAssociatedTypeDecl or TGenericTypeParamDecl;

  class TDecl =
    TEnumCaseDecl or TExtensionDecl or TIfConfigDecl or TImportDecl or TMissingMemberDecl or
        TOperatorDecl or TPatternBindingDecl or TPoundDiagnosticDecl or TPrecedenceGroupDecl or
        TTopLevelCodeDecl or TValueDecl;

  class TFuncDecl = TAccessorDecl or TConcreteFuncDecl;

  class TGenericContext =
    TAbstractFunctionDecl or TExtensionDecl or TGenericTypeDecl or TSubscriptDecl;

  class TGenericTypeDecl = TNominalTypeDecl or TOpaqueTypeDecl or TTypeAliasDecl;

  class TIterableDeclContext = TExtensionDecl or TNominalTypeDecl;

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
        TArrowExpr or TAssignExpr or TBindOptionalExpr or TCaptureListExpr or TCodeCompletionExpr or
        TCollectionExpr or TDeclRefExpr or TDefaultArgumentExpr or TDiscardAssignmentExpr or
        TDotSyntaxBaseIgnoredExpr or TDynamicTypeExpr or TEditorPlaceholderExpr or
        TEnumIsCaseExpr or TErrorExpr or TExplicitCastExpr or TForceValueExpr or TIdentityExpr or
        TIfExpr or TImplicitConversionExpr or TInOutExpr or TKeyPathApplicationExpr or
        TKeyPathDotExpr or TKeyPathExpr or TLazyInitializerExpr or TLiteralExpr or TLookupExpr or
        TMakeTemporarilyEscapableExpr or TObjCSelectorExpr or TOneWayExpr or TOpaqueValueExpr or
        TOpenExistentialExpr or TOptionalEvaluationExpr or TOtherConstructorDeclRefExpr or
        TOverloadSetRefExpr or TPropertyWrapperValuePlaceholderExpr or
        TRebindSelfInConstructorExpr or TSequenceExpr or TSuperRefExpr or TTapExpr or
        TTupleElementExpr or TTupleExpr or TTypeExpr or TUnresolvedDeclRefExpr or
        TUnresolvedDotExpr or TUnresolvedMemberExpr or TUnresolvedPatternExpr or
        TUnresolvedSpecializeExpr or TVarargExpansionExpr;

  class TIdentityExpr =
    TAwaitExpr or TDotSelfExpr or TParenExpr or TUnresolvedMemberChainResultExpr;

  class TImplicitConversionExpr =
    TAnyHashableErasureExpr or TArchetypeToSuperExpr or TArrayToPointerExpr or
        TBridgeFromObjCExpr or TBridgeToObjCExpr or TClassMetatypeToObjectExpr or
        TCollectionUpcastConversionExpr or TConditionalBridgeFromObjCExpr or
        TCovariantFunctionConversionExpr or TCovariantReturnConversionExpr or TDerivedToBaseExpr or
        TDestructureTupleExpr or TDifferentiableFunctionExpr or
        TDifferentiableFunctionExtractOriginalExpr or TErasureExpr or
        TExistentialMetatypeToObjectExpr or TForeignObjectConversionExpr or
        TFunctionConversionExpr or TInOutToPointerExpr or TInjectIntoOptionalExpr or
        TLinearFunctionExpr or TLinearFunctionExtractOriginalExpr or
        TLinearToDifferentiableFunctionExpr or TLoadExpr or TMetatypeConversionExpr or
        TPointerToPointerExpr or TProtocolMetatypeToObjectExpr or TStringToPointerExpr or
        TUnderlyingToOpaqueExpr or TUnevaluatedInstanceExpr or TUnresolvedTypeConversionExpr;

  class TLiteralExpr =
    TBuiltinLiteralExpr or TInterpolatedStringLiteralExpr or TNilLiteralExpr or
        TObjectLiteralExpr or TRegexLiteralExpr;

  class TLookupExpr = TDynamicLookupExpr or TMemberRefExpr or TSubscriptExpr;

  class TNumberLiteralExpr = TFloatLiteralExpr or TIntegerLiteralExpr;

  class TOverloadSetRefExpr = TOverloadedDeclRefExpr;

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

  class TArchetypeType =
    TNestedArchetypeType or TOpaqueTypeArchetypeType or TOpenedArchetypeType or
        TPrimaryArchetypeType or TSequenceArchetypeType;

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
        TLValueType or TModuleType or TPlaceholderType or TProtocolCompositionType or
        TReferenceStorageType or TSilBlockStorageType or TSilBoxType or TSilFunctionType or
        TSilTokenType or TSubstitutableType or TSugarType or TTupleType or TTypeVariableType or
        TUnresolvedType;

  class TUnarySyntaxSugarType = TArraySliceType or TOptionalType or TVariadicSequenceType;

  cached
  TComment fromRawComment(Raw::Element e) { result = TComment(e) }

  cached
  TDbFile fromRawDbFile(Raw::Element e) { result = TDbFile(e) }

  cached
  TDbLocation fromRawDbLocation(Raw::Element e) { result = TDbLocation(e) }

  cached
  TUnknownFile fromRawUnknownFile(Raw::Element e) { none() }

  cached
  TUnknownLocation fromRawUnknownLocation(Raw::Element e) { none() }

  cached
  TAccessorDecl fromRawAccessorDecl(Raw::Element e) { result = TAccessorDecl(e) }

  cached
  TAssociatedTypeDecl fromRawAssociatedTypeDecl(Raw::Element e) { result = TAssociatedTypeDecl(e) }

  cached
  TClassDecl fromRawClassDecl(Raw::Element e) { result = TClassDecl(e) }

  cached
  TConcreteFuncDecl fromRawConcreteFuncDecl(Raw::Element e) { result = TConcreteFuncDecl(e) }

  cached
  TConcreteVarDecl fromRawConcreteVarDecl(Raw::Element e) { result = TConcreteVarDecl(e) }

  cached
  TConstructorDecl fromRawConstructorDecl(Raw::Element e) { result = TConstructorDecl(e) }

  cached
  TDestructorDecl fromRawDestructorDecl(Raw::Element e) { result = TDestructorDecl(e) }

  cached
  TEnumCaseDecl fromRawEnumCaseDecl(Raw::Element e) { result = TEnumCaseDecl(e) }

  cached
  TEnumDecl fromRawEnumDecl(Raw::Element e) { result = TEnumDecl(e) }

  cached
  TEnumElementDecl fromRawEnumElementDecl(Raw::Element e) { result = TEnumElementDecl(e) }

  cached
  TExtensionDecl fromRawExtensionDecl(Raw::Element e) { result = TExtensionDecl(e) }

  cached
  TGenericTypeParamDecl fromRawGenericTypeParamDecl(Raw::Element e) {
    result = TGenericTypeParamDecl(e)
  }

  cached
  TIfConfigClause fromRawIfConfigClause(Raw::Element e) { result = TIfConfigClause(e) }

  cached
  TIfConfigDecl fromRawIfConfigDecl(Raw::Element e) { result = TIfConfigDecl(e) }

  cached
  TImportDecl fromRawImportDecl(Raw::Element e) { result = TImportDecl(e) }

  cached
  TInfixOperatorDecl fromRawInfixOperatorDecl(Raw::Element e) { result = TInfixOperatorDecl(e) }

  cached
  TMissingMemberDecl fromRawMissingMemberDecl(Raw::Element e) { result = TMissingMemberDecl(e) }

  cached
  TModuleDecl fromRawModuleDecl(Raw::Element e) { result = TModuleDecl(e) }

  cached
  TOpaqueTypeDecl fromRawOpaqueTypeDecl(Raw::Element e) { result = TOpaqueTypeDecl(e) }

  cached
  TParamDecl fromRawParamDecl(Raw::Element e) { result = TParamDecl(e) }

  cached
  TPatternBindingDecl fromRawPatternBindingDecl(Raw::Element e) { result = TPatternBindingDecl(e) }

  cached
  TPostfixOperatorDecl fromRawPostfixOperatorDecl(Raw::Element e) {
    result = TPostfixOperatorDecl(e)
  }

  cached
  TPoundDiagnosticDecl fromRawPoundDiagnosticDecl(Raw::Element e) {
    result = TPoundDiagnosticDecl(e)
  }

  cached
  TPrecedenceGroupDecl fromRawPrecedenceGroupDecl(Raw::Element e) {
    result = TPrecedenceGroupDecl(e)
  }

  cached
  TPrefixOperatorDecl fromRawPrefixOperatorDecl(Raw::Element e) { result = TPrefixOperatorDecl(e) }

  cached
  TProtocolDecl fromRawProtocolDecl(Raw::Element e) { result = TProtocolDecl(e) }

  cached
  TStructDecl fromRawStructDecl(Raw::Element e) { result = TStructDecl(e) }

  cached
  TSubscriptDecl fromRawSubscriptDecl(Raw::Element e) { result = TSubscriptDecl(e) }

  cached
  TTopLevelCodeDecl fromRawTopLevelCodeDecl(Raw::Element e) { result = TTopLevelCodeDecl(e) }

  cached
  TTypeAliasDecl fromRawTypeAliasDecl(Raw::Element e) { result = TTypeAliasDecl(e) }

  cached
  TAnyHashableErasureExpr fromRawAnyHashableErasureExpr(Raw::Element e) {
    result = TAnyHashableErasureExpr(e)
  }

  cached
  TAppliedPropertyWrapperExpr fromRawAppliedPropertyWrapperExpr(Raw::Element e) {
    result = TAppliedPropertyWrapperExpr(e)
  }

  cached
  TArchetypeToSuperExpr fromRawArchetypeToSuperExpr(Raw::Element e) {
    result = TArchetypeToSuperExpr(e)
  }

  cached
  TArgument fromRawArgument(Raw::Element e) { result = TArgument(e) }

  cached
  TArrayExpr fromRawArrayExpr(Raw::Element e) { result = TArrayExpr(e) }

  cached
  TArrayToPointerExpr fromRawArrayToPointerExpr(Raw::Element e) { result = TArrayToPointerExpr(e) }

  cached
  TArrowExpr fromRawArrowExpr(Raw::Element e) { result = TArrowExpr(e) }

  cached
  TAssignExpr fromRawAssignExpr(Raw::Element e) { result = TAssignExpr(e) }

  cached
  TAutoClosureExpr fromRawAutoClosureExpr(Raw::Element e) { result = TAutoClosureExpr(e) }

  cached
  TAwaitExpr fromRawAwaitExpr(Raw::Element e) { result = TAwaitExpr(e) }

  cached
  TBinaryExpr fromRawBinaryExpr(Raw::Element e) { result = TBinaryExpr(e) }

  cached
  TBindOptionalExpr fromRawBindOptionalExpr(Raw::Element e) { result = TBindOptionalExpr(e) }

  cached
  TBooleanLiteralExpr fromRawBooleanLiteralExpr(Raw::Element e) { result = TBooleanLiteralExpr(e) }

  cached
  TBridgeFromObjCExpr fromRawBridgeFromObjCExpr(Raw::Element e) { result = TBridgeFromObjCExpr(e) }

  cached
  TBridgeToObjCExpr fromRawBridgeToObjCExpr(Raw::Element e) { result = TBridgeToObjCExpr(e) }

  cached
  TCallExpr fromRawCallExpr(Raw::Element e) { result = TCallExpr(e) }

  cached
  TCaptureListExpr fromRawCaptureListExpr(Raw::Element e) { result = TCaptureListExpr(e) }

  cached
  TClassMetatypeToObjectExpr fromRawClassMetatypeToObjectExpr(Raw::Element e) {
    result = TClassMetatypeToObjectExpr(e)
  }

  cached
  TClosureExpr fromRawClosureExpr(Raw::Element e) { result = TClosureExpr(e) }

  cached
  TCodeCompletionExpr fromRawCodeCompletionExpr(Raw::Element e) { result = TCodeCompletionExpr(e) }

  cached
  TCoerceExpr fromRawCoerceExpr(Raw::Element e) { result = TCoerceExpr(e) }

  cached
  TCollectionUpcastConversionExpr fromRawCollectionUpcastConversionExpr(Raw::Element e) {
    result = TCollectionUpcastConversionExpr(e)
  }

  cached
  TConditionalBridgeFromObjCExpr fromRawConditionalBridgeFromObjCExpr(Raw::Element e) {
    result = TConditionalBridgeFromObjCExpr(e)
  }

  cached
  TConditionalCheckedCastExpr fromRawConditionalCheckedCastExpr(Raw::Element e) {
    result = TConditionalCheckedCastExpr(e)
  }

  cached
  TConstructorRefCallExpr fromRawConstructorRefCallExpr(Raw::Element e) {
    result = TConstructorRefCallExpr(e)
  }

  cached
  TCovariantFunctionConversionExpr fromRawCovariantFunctionConversionExpr(Raw::Element e) {
    result = TCovariantFunctionConversionExpr(e)
  }

  cached
  TCovariantReturnConversionExpr fromRawCovariantReturnConversionExpr(Raw::Element e) {
    result = TCovariantReturnConversionExpr(e)
  }

  cached
  TDeclRefExpr fromRawDeclRefExpr(Raw::Element e) { result = TDeclRefExpr(e) }

  cached
  TDefaultArgumentExpr fromRawDefaultArgumentExpr(Raw::Element e) {
    result = TDefaultArgumentExpr(e)
  }

  cached
  TDerivedToBaseExpr fromRawDerivedToBaseExpr(Raw::Element e) { result = TDerivedToBaseExpr(e) }

  cached
  TDestructureTupleExpr fromRawDestructureTupleExpr(Raw::Element e) {
    result = TDestructureTupleExpr(e)
  }

  cached
  TDictionaryExpr fromRawDictionaryExpr(Raw::Element e) { result = TDictionaryExpr(e) }

  cached
  TDifferentiableFunctionExpr fromRawDifferentiableFunctionExpr(Raw::Element e) {
    result = TDifferentiableFunctionExpr(e)
  }

  cached
  TDifferentiableFunctionExtractOriginalExpr fromRawDifferentiableFunctionExtractOriginalExpr(
    Raw::Element e
  ) {
    result = TDifferentiableFunctionExtractOriginalExpr(e)
  }

  cached
  TDiscardAssignmentExpr fromRawDiscardAssignmentExpr(Raw::Element e) {
    result = TDiscardAssignmentExpr(e)
  }

  cached
  TDotSelfExpr fromRawDotSelfExpr(Raw::Element e) { result = TDotSelfExpr(e) }

  cached
  TDotSyntaxBaseIgnoredExpr fromRawDotSyntaxBaseIgnoredExpr(Raw::Element e) {
    result = TDotSyntaxBaseIgnoredExpr(e)
  }

  cached
  TDotSyntaxCallExpr fromRawDotSyntaxCallExpr(Raw::Element e) { result = TDotSyntaxCallExpr(e) }

  cached
  TDynamicMemberRefExpr fromRawDynamicMemberRefExpr(Raw::Element e) {
    result = TDynamicMemberRefExpr(e)
  }

  cached
  TDynamicSubscriptExpr fromRawDynamicSubscriptExpr(Raw::Element e) {
    result = TDynamicSubscriptExpr(e)
  }

  cached
  TDynamicTypeExpr fromRawDynamicTypeExpr(Raw::Element e) { result = TDynamicTypeExpr(e) }

  cached
  TEditorPlaceholderExpr fromRawEditorPlaceholderExpr(Raw::Element e) {
    result = TEditorPlaceholderExpr(e)
  }

  cached
  TEnumIsCaseExpr fromRawEnumIsCaseExpr(Raw::Element e) { result = TEnumIsCaseExpr(e) }

  cached
  TErasureExpr fromRawErasureExpr(Raw::Element e) { result = TErasureExpr(e) }

  cached
  TErrorExpr fromRawErrorExpr(Raw::Element e) { result = TErrorExpr(e) }

  cached
  TExistentialMetatypeToObjectExpr fromRawExistentialMetatypeToObjectExpr(Raw::Element e) {
    result = TExistentialMetatypeToObjectExpr(e)
  }

  cached
  TFloatLiteralExpr fromRawFloatLiteralExpr(Raw::Element e) { result = TFloatLiteralExpr(e) }

  cached
  TForceTryExpr fromRawForceTryExpr(Raw::Element e) { result = TForceTryExpr(e) }

  cached
  TForceValueExpr fromRawForceValueExpr(Raw::Element e) { result = TForceValueExpr(e) }

  cached
  TForcedCheckedCastExpr fromRawForcedCheckedCastExpr(Raw::Element e) {
    result = TForcedCheckedCastExpr(e)
  }

  cached
  TForeignObjectConversionExpr fromRawForeignObjectConversionExpr(Raw::Element e) {
    result = TForeignObjectConversionExpr(e)
  }

  cached
  TFunctionConversionExpr fromRawFunctionConversionExpr(Raw::Element e) {
    result = TFunctionConversionExpr(e)
  }

  cached
  TIfExpr fromRawIfExpr(Raw::Element e) { result = TIfExpr(e) }

  cached
  TInOutExpr fromRawInOutExpr(Raw::Element e) { result = TInOutExpr(e) }

  cached
  TInOutToPointerExpr fromRawInOutToPointerExpr(Raw::Element e) { result = TInOutToPointerExpr(e) }

  cached
  TInjectIntoOptionalExpr fromRawInjectIntoOptionalExpr(Raw::Element e) {
    result = TInjectIntoOptionalExpr(e)
  }

  cached
  TIntegerLiteralExpr fromRawIntegerLiteralExpr(Raw::Element e) { result = TIntegerLiteralExpr(e) }

  cached
  TInterpolatedStringLiteralExpr fromRawInterpolatedStringLiteralExpr(Raw::Element e) {
    result = TInterpolatedStringLiteralExpr(e)
  }

  cached
  TIsExpr fromRawIsExpr(Raw::Element e) { result = TIsExpr(e) }

  cached
  TKeyPathApplicationExpr fromRawKeyPathApplicationExpr(Raw::Element e) {
    result = TKeyPathApplicationExpr(e)
  }

  cached
  TKeyPathDotExpr fromRawKeyPathDotExpr(Raw::Element e) { result = TKeyPathDotExpr(e) }

  cached
  TKeyPathExpr fromRawKeyPathExpr(Raw::Element e) { result = TKeyPathExpr(e) }

  cached
  TLazyInitializerExpr fromRawLazyInitializerExpr(Raw::Element e) {
    result = TLazyInitializerExpr(e)
  }

  cached
  TLinearFunctionExpr fromRawLinearFunctionExpr(Raw::Element e) { result = TLinearFunctionExpr(e) }

  cached
  TLinearFunctionExtractOriginalExpr fromRawLinearFunctionExtractOriginalExpr(Raw::Element e) {
    result = TLinearFunctionExtractOriginalExpr(e)
  }

  cached
  TLinearToDifferentiableFunctionExpr fromRawLinearToDifferentiableFunctionExpr(Raw::Element e) {
    result = TLinearToDifferentiableFunctionExpr(e)
  }

  cached
  TLoadExpr fromRawLoadExpr(Raw::Element e) { result = TLoadExpr(e) }

  cached
  TMagicIdentifierLiteralExpr fromRawMagicIdentifierLiteralExpr(Raw::Element e) {
    result = TMagicIdentifierLiteralExpr(e)
  }

  cached
  TMakeTemporarilyEscapableExpr fromRawMakeTemporarilyEscapableExpr(Raw::Element e) {
    result = TMakeTemporarilyEscapableExpr(e)
  }

  cached
  TMemberRefExpr fromRawMemberRefExpr(Raw::Element e) { result = TMemberRefExpr(e) }

  cached
  TMetatypeConversionExpr fromRawMetatypeConversionExpr(Raw::Element e) {
    result = TMetatypeConversionExpr(e)
  }

  cached
  TNilLiteralExpr fromRawNilLiteralExpr(Raw::Element e) { result = TNilLiteralExpr(e) }

  cached
  TObjCSelectorExpr fromRawObjCSelectorExpr(Raw::Element e) { result = TObjCSelectorExpr(e) }

  cached
  TObjectLiteralExpr fromRawObjectLiteralExpr(Raw::Element e) { result = TObjectLiteralExpr(e) }

  cached
  TOneWayExpr fromRawOneWayExpr(Raw::Element e) { result = TOneWayExpr(e) }

  cached
  TOpaqueValueExpr fromRawOpaqueValueExpr(Raw::Element e) { result = TOpaqueValueExpr(e) }

  cached
  TOpenExistentialExpr fromRawOpenExistentialExpr(Raw::Element e) {
    result = TOpenExistentialExpr(e)
  }

  cached
  TOptionalEvaluationExpr fromRawOptionalEvaluationExpr(Raw::Element e) {
    result = TOptionalEvaluationExpr(e)
  }

  cached
  TOptionalTryExpr fromRawOptionalTryExpr(Raw::Element e) { result = TOptionalTryExpr(e) }

  cached
  TOtherConstructorDeclRefExpr fromRawOtherConstructorDeclRefExpr(Raw::Element e) {
    result = TOtherConstructorDeclRefExpr(e)
  }

  cached
  TOverloadedDeclRefExpr fromRawOverloadedDeclRefExpr(Raw::Element e) {
    result = TOverloadedDeclRefExpr(e)
  }

  cached
  TParenExpr fromRawParenExpr(Raw::Element e) { result = TParenExpr(e) }

  cached
  TPointerToPointerExpr fromRawPointerToPointerExpr(Raw::Element e) {
    result = TPointerToPointerExpr(e)
  }

  cached
  TPostfixUnaryExpr fromRawPostfixUnaryExpr(Raw::Element e) { result = TPostfixUnaryExpr(e) }

  cached
  TPrefixUnaryExpr fromRawPrefixUnaryExpr(Raw::Element e) { result = TPrefixUnaryExpr(e) }

  cached
  TPropertyWrapperValuePlaceholderExpr fromRawPropertyWrapperValuePlaceholderExpr(Raw::Element e) {
    result = TPropertyWrapperValuePlaceholderExpr(e)
  }

  cached
  TProtocolMetatypeToObjectExpr fromRawProtocolMetatypeToObjectExpr(Raw::Element e) {
    result = TProtocolMetatypeToObjectExpr(e)
  }

  cached
  TRebindSelfInConstructorExpr fromRawRebindSelfInConstructorExpr(Raw::Element e) {
    result = TRebindSelfInConstructorExpr(e)
  }

  cached
  TRegexLiteralExpr fromRawRegexLiteralExpr(Raw::Element e) { result = TRegexLiteralExpr(e) }

  cached
  TSequenceExpr fromRawSequenceExpr(Raw::Element e) { result = TSequenceExpr(e) }

  cached
  TStringLiteralExpr fromRawStringLiteralExpr(Raw::Element e) { result = TStringLiteralExpr(e) }

  cached
  TStringToPointerExpr fromRawStringToPointerExpr(Raw::Element e) {
    result = TStringToPointerExpr(e)
  }

  cached
  TSubscriptExpr fromRawSubscriptExpr(Raw::Element e) { result = TSubscriptExpr(e) }

  cached
  TSuperRefExpr fromRawSuperRefExpr(Raw::Element e) { result = TSuperRefExpr(e) }

  cached
  TTapExpr fromRawTapExpr(Raw::Element e) { result = TTapExpr(e) }

  cached
  TTryExpr fromRawTryExpr(Raw::Element e) { result = TTryExpr(e) }

  cached
  TTupleElementExpr fromRawTupleElementExpr(Raw::Element e) { result = TTupleElementExpr(e) }

  cached
  TTupleExpr fromRawTupleExpr(Raw::Element e) { result = TTupleExpr(e) }

  cached
  TTypeExpr fromRawTypeExpr(Raw::Element e) { result = TTypeExpr(e) }

  cached
  TUnderlyingToOpaqueExpr fromRawUnderlyingToOpaqueExpr(Raw::Element e) {
    result = TUnderlyingToOpaqueExpr(e)
  }

  cached
  TUnevaluatedInstanceExpr fromRawUnevaluatedInstanceExpr(Raw::Element e) {
    result = TUnevaluatedInstanceExpr(e)
  }

  cached
  TUnresolvedDeclRefExpr fromRawUnresolvedDeclRefExpr(Raw::Element e) {
    result = TUnresolvedDeclRefExpr(e)
  }

  cached
  TUnresolvedDotExpr fromRawUnresolvedDotExpr(Raw::Element e) { result = TUnresolvedDotExpr(e) }

  cached
  TUnresolvedMemberChainResultExpr fromRawUnresolvedMemberChainResultExpr(Raw::Element e) {
    result = TUnresolvedMemberChainResultExpr(e)
  }

  cached
  TUnresolvedMemberExpr fromRawUnresolvedMemberExpr(Raw::Element e) {
    result = TUnresolvedMemberExpr(e)
  }

  cached
  TUnresolvedPatternExpr fromRawUnresolvedPatternExpr(Raw::Element e) {
    result = TUnresolvedPatternExpr(e)
  }

  cached
  TUnresolvedSpecializeExpr fromRawUnresolvedSpecializeExpr(Raw::Element e) {
    result = TUnresolvedSpecializeExpr(e)
  }

  cached
  TUnresolvedTypeConversionExpr fromRawUnresolvedTypeConversionExpr(Raw::Element e) {
    result = TUnresolvedTypeConversionExpr(e)
  }

  cached
  TVarargExpansionExpr fromRawVarargExpansionExpr(Raw::Element e) {
    result = TVarargExpansionExpr(e)
  }

  cached
  TAnyPattern fromRawAnyPattern(Raw::Element e) { result = TAnyPattern(e) }

  cached
  TBindingPattern fromRawBindingPattern(Raw::Element e) { result = TBindingPattern(e) }

  cached
  TBoolPattern fromRawBoolPattern(Raw::Element e) { result = TBoolPattern(e) }

  cached
  TEnumElementPattern fromRawEnumElementPattern(Raw::Element e) { result = TEnumElementPattern(e) }

  cached
  TExprPattern fromRawExprPattern(Raw::Element e) { result = TExprPattern(e) }

  cached
  TIsPattern fromRawIsPattern(Raw::Element e) { result = TIsPattern(e) }

  cached
  TNamedPattern fromRawNamedPattern(Raw::Element e) { result = TNamedPattern(e) }

  cached
  TOptionalSomePattern fromRawOptionalSomePattern(Raw::Element e) {
    result = TOptionalSomePattern(e)
  }

  cached
  TParenPattern fromRawParenPattern(Raw::Element e) { result = TParenPattern(e) }

  cached
  TTuplePattern fromRawTuplePattern(Raw::Element e) { result = TTuplePattern(e) }

  cached
  TTypedPattern fromRawTypedPattern(Raw::Element e) { result = TTypedPattern(e) }

  cached
  TBraceStmt fromRawBraceStmt(Raw::Element e) { result = TBraceStmt(e) }

  cached
  TBreakStmt fromRawBreakStmt(Raw::Element e) { result = TBreakStmt(e) }

  cached
  TCaseLabelItem fromRawCaseLabelItem(Raw::Element e) { result = TCaseLabelItem(e) }

  cached
  TCaseStmt fromRawCaseStmt(Raw::Element e) { result = TCaseStmt(e) }

  cached
  TConditionElement fromRawConditionElement(Raw::Element e) { result = TConditionElement(e) }

  cached
  TContinueStmt fromRawContinueStmt(Raw::Element e) { result = TContinueStmt(e) }

  cached
  TDeferStmt fromRawDeferStmt(Raw::Element e) { result = TDeferStmt(e) }

  cached
  TDoCatchStmt fromRawDoCatchStmt(Raw::Element e) { result = TDoCatchStmt(e) }

  cached
  TDoStmt fromRawDoStmt(Raw::Element e) { result = TDoStmt(e) }

  cached
  TFailStmt fromRawFailStmt(Raw::Element e) { result = TFailStmt(e) }

  cached
  TFallthroughStmt fromRawFallthroughStmt(Raw::Element e) { result = TFallthroughStmt(e) }

  cached
  TForEachStmt fromRawForEachStmt(Raw::Element e) { result = TForEachStmt(e) }

  cached
  TGuardStmt fromRawGuardStmt(Raw::Element e) { result = TGuardStmt(e) }

  cached
  TIfStmt fromRawIfStmt(Raw::Element e) { result = TIfStmt(e) }

  cached
  TPoundAssertStmt fromRawPoundAssertStmt(Raw::Element e) { result = TPoundAssertStmt(e) }

  cached
  TRepeatWhileStmt fromRawRepeatWhileStmt(Raw::Element e) { result = TRepeatWhileStmt(e) }

  cached
  TReturnStmt fromRawReturnStmt(Raw::Element e) { result = TReturnStmt(e) }

  cached
  TStmtCondition fromRawStmtCondition(Raw::Element e) { result = TStmtCondition(e) }

  cached
  TSwitchStmt fromRawSwitchStmt(Raw::Element e) { result = TSwitchStmt(e) }

  cached
  TThrowStmt fromRawThrowStmt(Raw::Element e) { result = TThrowStmt(e) }

  cached
  TWhileStmt fromRawWhileStmt(Raw::Element e) { result = TWhileStmt(e) }

  cached
  TYieldStmt fromRawYieldStmt(Raw::Element e) { result = TYieldStmt(e) }

  cached
  TArraySliceType fromRawArraySliceType(Raw::Element e) { result = TArraySliceType(e) }

  cached
  TBoundGenericClassType fromRawBoundGenericClassType(Raw::Element e) {
    result = TBoundGenericClassType(e)
  }

  cached
  TBoundGenericEnumType fromRawBoundGenericEnumType(Raw::Element e) {
    result = TBoundGenericEnumType(e)
  }

  cached
  TBoundGenericStructType fromRawBoundGenericStructType(Raw::Element e) {
    result = TBoundGenericStructType(e)
  }

  cached
  TBuiltinBridgeObjectType fromRawBuiltinBridgeObjectType(Raw::Element e) {
    result = TBuiltinBridgeObjectType(e)
  }

  cached
  TBuiltinDefaultActorStorageType fromRawBuiltinDefaultActorStorageType(Raw::Element e) {
    result = TBuiltinDefaultActorStorageType(e)
  }

  cached
  TBuiltinExecutorType fromRawBuiltinExecutorType(Raw::Element e) {
    result = TBuiltinExecutorType(e)
  }

  cached
  TBuiltinFloatType fromRawBuiltinFloatType(Raw::Element e) { result = TBuiltinFloatType(e) }

  cached
  TBuiltinIntegerLiteralType fromRawBuiltinIntegerLiteralType(Raw::Element e) {
    result = TBuiltinIntegerLiteralType(e)
  }

  cached
  TBuiltinIntegerType fromRawBuiltinIntegerType(Raw::Element e) { result = TBuiltinIntegerType(e) }

  cached
  TBuiltinJobType fromRawBuiltinJobType(Raw::Element e) { result = TBuiltinJobType(e) }

  cached
  TBuiltinNativeObjectType fromRawBuiltinNativeObjectType(Raw::Element e) {
    result = TBuiltinNativeObjectType(e)
  }

  cached
  TBuiltinRawPointerType fromRawBuiltinRawPointerType(Raw::Element e) {
    result = TBuiltinRawPointerType(e)
  }

  cached
  TBuiltinRawUnsafeContinuationType fromRawBuiltinRawUnsafeContinuationType(Raw::Element e) {
    result = TBuiltinRawUnsafeContinuationType(e)
  }

  cached
  TBuiltinUnsafeValueBufferType fromRawBuiltinUnsafeValueBufferType(Raw::Element e) {
    result = TBuiltinUnsafeValueBufferType(e)
  }

  cached
  TBuiltinVectorType fromRawBuiltinVectorType(Raw::Element e) { result = TBuiltinVectorType(e) }

  cached
  TClassType fromRawClassType(Raw::Element e) { result = TClassType(e) }

  cached
  TDependentMemberType fromRawDependentMemberType(Raw::Element e) {
    result = TDependentMemberType(e)
  }

  cached
  TDictionaryType fromRawDictionaryType(Raw::Element e) { result = TDictionaryType(e) }

  cached
  TDynamicSelfType fromRawDynamicSelfType(Raw::Element e) { result = TDynamicSelfType(e) }

  cached
  TEnumType fromRawEnumType(Raw::Element e) { result = TEnumType(e) }

  cached
  TErrorType fromRawErrorType(Raw::Element e) { result = TErrorType(e) }

  cached
  TExistentialMetatypeType fromRawExistentialMetatypeType(Raw::Element e) {
    result = TExistentialMetatypeType(e)
  }

  cached
  TExistentialType fromRawExistentialType(Raw::Element e) { result = TExistentialType(e) }

  cached
  TFunctionType fromRawFunctionType(Raw::Element e) { result = TFunctionType(e) }

  cached
  TGenericFunctionType fromRawGenericFunctionType(Raw::Element e) {
    result = TGenericFunctionType(e)
  }

  cached
  TGenericTypeParamType fromRawGenericTypeParamType(Raw::Element e) {
    result = TGenericTypeParamType(e)
  }

  cached
  TInOutType fromRawInOutType(Raw::Element e) { result = TInOutType(e) }

  cached
  TLValueType fromRawLValueType(Raw::Element e) { result = TLValueType(e) }

  cached
  TMetatypeType fromRawMetatypeType(Raw::Element e) { result = TMetatypeType(e) }

  cached
  TModuleType fromRawModuleType(Raw::Element e) { result = TModuleType(e) }

  cached
  TNestedArchetypeType fromRawNestedArchetypeType(Raw::Element e) {
    result = TNestedArchetypeType(e)
  }

  cached
  TOpaqueTypeArchetypeType fromRawOpaqueTypeArchetypeType(Raw::Element e) {
    result = TOpaqueTypeArchetypeType(e)
  }

  cached
  TOpenedArchetypeType fromRawOpenedArchetypeType(Raw::Element e) {
    result = TOpenedArchetypeType(e)
  }

  cached
  TOptionalType fromRawOptionalType(Raw::Element e) { result = TOptionalType(e) }

  cached
  TParenType fromRawParenType(Raw::Element e) { result = TParenType(e) }

  cached
  TPlaceholderType fromRawPlaceholderType(Raw::Element e) { result = TPlaceholderType(e) }

  cached
  TPrimaryArchetypeType fromRawPrimaryArchetypeType(Raw::Element e) {
    result = TPrimaryArchetypeType(e)
  }

  cached
  TProtocolCompositionType fromRawProtocolCompositionType(Raw::Element e) {
    result = TProtocolCompositionType(e)
  }

  cached
  TProtocolType fromRawProtocolType(Raw::Element e) { result = TProtocolType(e) }

  cached
  TSequenceArchetypeType fromRawSequenceArchetypeType(Raw::Element e) {
    result = TSequenceArchetypeType(e)
  }

  cached
  TSilBlockStorageType fromRawSilBlockStorageType(Raw::Element e) {
    result = TSilBlockStorageType(e)
  }

  cached
  TSilBoxType fromRawSilBoxType(Raw::Element e) { result = TSilBoxType(e) }

  cached
  TSilFunctionType fromRawSilFunctionType(Raw::Element e) { result = TSilFunctionType(e) }

  cached
  TSilTokenType fromRawSilTokenType(Raw::Element e) { result = TSilTokenType(e) }

  cached
  TStructType fromRawStructType(Raw::Element e) { result = TStructType(e) }

  cached
  TTupleType fromRawTupleType(Raw::Element e) { result = TTupleType(e) }

  cached
  TTypeAliasType fromRawTypeAliasType(Raw::Element e) { result = TTypeAliasType(e) }

  cached
  TTypeRepr fromRawTypeRepr(Raw::Element e) { result = TTypeRepr(e) }

  cached
  TTypeVariableType fromRawTypeVariableType(Raw::Element e) { result = TTypeVariableType(e) }

  cached
  TUnboundGenericType fromRawUnboundGenericType(Raw::Element e) { result = TUnboundGenericType(e) }

  cached
  TUnmanagedStorageType fromRawUnmanagedStorageType(Raw::Element e) {
    result = TUnmanagedStorageType(e)
  }

  cached
  TUnownedStorageType fromRawUnownedStorageType(Raw::Element e) { result = TUnownedStorageType(e) }

  cached
  TUnresolvedType fromRawUnresolvedType(Raw::Element e) { result = TUnresolvedType(e) }

  cached
  TVariadicSequenceType fromRawVariadicSequenceType(Raw::Element e) {
    result = TVariadicSequenceType(e)
  }

  cached
  TWeakStorageType fromRawWeakStorageType(Raw::Element e) { result = TWeakStorageType(e) }

  cached
  TAstNode fromRawAstNode(Raw::Element e) {
    result = fromRawCaseLabelItem(e)
    or
    result = fromRawDecl(e)
    or
    result = fromRawExpr(e)
    or
    result = fromRawPattern(e)
    or
    result = fromRawStmt(e)
    or
    result = fromRawStmtCondition(e)
    or
    result = fromRawTypeRepr(e)
  }

  cached
  TCallable fromRawCallable(Raw::Element e) {
    result = fromRawAbstractClosureExpr(e)
    or
    result = fromRawAbstractFunctionDecl(e)
  }

  cached
  TElement fromRawElement(Raw::Element e) {
    result = fromRawCallable(e)
    or
    result = fromRawFile(e)
    or
    result = fromRawGenericContext(e)
    or
    result = fromRawIterableDeclContext(e)
    or
    result = fromRawLocatable(e)
    or
    result = fromRawLocation(e)
    or
    result = fromRawType(e)
  }

  cached
  TFile fromRawFile(Raw::Element e) {
    result = fromRawDbFile(e)
    or
    result = fromRawUnknownFile(e)
  }

  cached
  TLocatable fromRawLocatable(Raw::Element e) {
    result = fromRawArgument(e)
    or
    result = fromRawAstNode(e)
    or
    result = fromRawComment(e)
    or
    result = fromRawConditionElement(e)
    or
    result = fromRawIfConfigClause(e)
  }

  cached
  TLocation fromRawLocation(Raw::Element e) {
    result = fromRawDbLocation(e)
    or
    result = fromRawUnknownLocation(e)
  }

  cached
  TAbstractFunctionDecl fromRawAbstractFunctionDecl(Raw::Element e) {
    result = fromRawConstructorDecl(e)
    or
    result = fromRawDestructorDecl(e)
    or
    result = fromRawFuncDecl(e)
  }

  cached
  TAbstractStorageDecl fromRawAbstractStorageDecl(Raw::Element e) {
    result = fromRawSubscriptDecl(e)
    or
    result = fromRawVarDecl(e)
  }

  cached
  TAbstractTypeParamDecl fromRawAbstractTypeParamDecl(Raw::Element e) {
    result = fromRawAssociatedTypeDecl(e)
    or
    result = fromRawGenericTypeParamDecl(e)
  }

  cached
  TDecl fromRawDecl(Raw::Element e) {
    result = fromRawEnumCaseDecl(e)
    or
    result = fromRawExtensionDecl(e)
    or
    result = fromRawIfConfigDecl(e)
    or
    result = fromRawImportDecl(e)
    or
    result = fromRawMissingMemberDecl(e)
    or
    result = fromRawOperatorDecl(e)
    or
    result = fromRawPatternBindingDecl(e)
    or
    result = fromRawPoundDiagnosticDecl(e)
    or
    result = fromRawPrecedenceGroupDecl(e)
    or
    result = fromRawTopLevelCodeDecl(e)
    or
    result = fromRawValueDecl(e)
  }

  cached
  TFuncDecl fromRawFuncDecl(Raw::Element e) {
    result = fromRawAccessorDecl(e)
    or
    result = fromRawConcreteFuncDecl(e)
  }

  cached
  TGenericContext fromRawGenericContext(Raw::Element e) {
    result = fromRawAbstractFunctionDecl(e)
    or
    result = fromRawExtensionDecl(e)
    or
    result = fromRawGenericTypeDecl(e)
    or
    result = fromRawSubscriptDecl(e)
  }

  cached
  TGenericTypeDecl fromRawGenericTypeDecl(Raw::Element e) {
    result = fromRawNominalTypeDecl(e)
    or
    result = fromRawOpaqueTypeDecl(e)
    or
    result = fromRawTypeAliasDecl(e)
  }

  cached
  TIterableDeclContext fromRawIterableDeclContext(Raw::Element e) {
    result = fromRawExtensionDecl(e)
    or
    result = fromRawNominalTypeDecl(e)
  }

  cached
  TNominalTypeDecl fromRawNominalTypeDecl(Raw::Element e) {
    result = fromRawClassDecl(e)
    or
    result = fromRawEnumDecl(e)
    or
    result = fromRawProtocolDecl(e)
    or
    result = fromRawStructDecl(e)
  }

  cached
  TOperatorDecl fromRawOperatorDecl(Raw::Element e) {
    result = fromRawInfixOperatorDecl(e)
    or
    result = fromRawPostfixOperatorDecl(e)
    or
    result = fromRawPrefixOperatorDecl(e)
  }

  cached
  TTypeDecl fromRawTypeDecl(Raw::Element e) {
    result = fromRawAbstractTypeParamDecl(e)
    or
    result = fromRawGenericTypeDecl(e)
    or
    result = fromRawModuleDecl(e)
  }

  cached
  TValueDecl fromRawValueDecl(Raw::Element e) {
    result = fromRawAbstractFunctionDecl(e)
    or
    result = fromRawAbstractStorageDecl(e)
    or
    result = fromRawEnumElementDecl(e)
    or
    result = fromRawTypeDecl(e)
  }

  cached
  TVarDecl fromRawVarDecl(Raw::Element e) {
    result = fromRawConcreteVarDecl(e)
    or
    result = fromRawParamDecl(e)
  }

  cached
  TAbstractClosureExpr fromRawAbstractClosureExpr(Raw::Element e) {
    result = fromRawAutoClosureExpr(e)
    or
    result = fromRawClosureExpr(e)
  }

  cached
  TAnyTryExpr fromRawAnyTryExpr(Raw::Element e) {
    result = fromRawForceTryExpr(e)
    or
    result = fromRawOptionalTryExpr(e)
    or
    result = fromRawTryExpr(e)
  }

  cached
  TApplyExpr fromRawApplyExpr(Raw::Element e) {
    result = fromRawBinaryExpr(e)
    or
    result = fromRawCallExpr(e)
    or
    result = fromRawPostfixUnaryExpr(e)
    or
    result = fromRawPrefixUnaryExpr(e)
    or
    result = fromRawSelfApplyExpr(e)
  }

  cached
  TBuiltinLiteralExpr fromRawBuiltinLiteralExpr(Raw::Element e) {
    result = fromRawBooleanLiteralExpr(e)
    or
    result = fromRawMagicIdentifierLiteralExpr(e)
    or
    result = fromRawNumberLiteralExpr(e)
    or
    result = fromRawStringLiteralExpr(e)
  }

  cached
  TCheckedCastExpr fromRawCheckedCastExpr(Raw::Element e) {
    result = fromRawConditionalCheckedCastExpr(e)
    or
    result = fromRawForcedCheckedCastExpr(e)
    or
    result = fromRawIsExpr(e)
  }

  cached
  TCollectionExpr fromRawCollectionExpr(Raw::Element e) {
    result = fromRawArrayExpr(e)
    or
    result = fromRawDictionaryExpr(e)
  }

  cached
  TDynamicLookupExpr fromRawDynamicLookupExpr(Raw::Element e) {
    result = fromRawDynamicMemberRefExpr(e)
    or
    result = fromRawDynamicSubscriptExpr(e)
  }

  cached
  TExplicitCastExpr fromRawExplicitCastExpr(Raw::Element e) {
    result = fromRawCheckedCastExpr(e)
    or
    result = fromRawCoerceExpr(e)
  }

  cached
  TExpr fromRawExpr(Raw::Element e) {
    result = fromRawAbstractClosureExpr(e)
    or
    result = fromRawAnyTryExpr(e)
    or
    result = fromRawAppliedPropertyWrapperExpr(e)
    or
    result = fromRawApplyExpr(e)
    or
    result = fromRawArrowExpr(e)
    or
    result = fromRawAssignExpr(e)
    or
    result = fromRawBindOptionalExpr(e)
    or
    result = fromRawCaptureListExpr(e)
    or
    result = fromRawCodeCompletionExpr(e)
    or
    result = fromRawCollectionExpr(e)
    or
    result = fromRawDeclRefExpr(e)
    or
    result = fromRawDefaultArgumentExpr(e)
    or
    result = fromRawDiscardAssignmentExpr(e)
    or
    result = fromRawDotSyntaxBaseIgnoredExpr(e)
    or
    result = fromRawDynamicTypeExpr(e)
    or
    result = fromRawEditorPlaceholderExpr(e)
    or
    result = fromRawEnumIsCaseExpr(e)
    or
    result = fromRawErrorExpr(e)
    or
    result = fromRawExplicitCastExpr(e)
    or
    result = fromRawForceValueExpr(e)
    or
    result = fromRawIdentityExpr(e)
    or
    result = fromRawIfExpr(e)
    or
    result = fromRawImplicitConversionExpr(e)
    or
    result = fromRawInOutExpr(e)
    or
    result = fromRawKeyPathApplicationExpr(e)
    or
    result = fromRawKeyPathDotExpr(e)
    or
    result = fromRawKeyPathExpr(e)
    or
    result = fromRawLazyInitializerExpr(e)
    or
    result = fromRawLiteralExpr(e)
    or
    result = fromRawLookupExpr(e)
    or
    result = fromRawMakeTemporarilyEscapableExpr(e)
    or
    result = fromRawObjCSelectorExpr(e)
    or
    result = fromRawOneWayExpr(e)
    or
    result = fromRawOpaqueValueExpr(e)
    or
    result = fromRawOpenExistentialExpr(e)
    or
    result = fromRawOptionalEvaluationExpr(e)
    or
    result = fromRawOtherConstructorDeclRefExpr(e)
    or
    result = fromRawOverloadSetRefExpr(e)
    or
    result = fromRawPropertyWrapperValuePlaceholderExpr(e)
    or
    result = fromRawRebindSelfInConstructorExpr(e)
    or
    result = fromRawSequenceExpr(e)
    or
    result = fromRawSuperRefExpr(e)
    or
    result = fromRawTapExpr(e)
    or
    result = fromRawTupleElementExpr(e)
    or
    result = fromRawTupleExpr(e)
    or
    result = fromRawTypeExpr(e)
    or
    result = fromRawUnresolvedDeclRefExpr(e)
    or
    result = fromRawUnresolvedDotExpr(e)
    or
    result = fromRawUnresolvedMemberExpr(e)
    or
    result = fromRawUnresolvedPatternExpr(e)
    or
    result = fromRawUnresolvedSpecializeExpr(e)
    or
    result = fromRawVarargExpansionExpr(e)
  }

  cached
  TIdentityExpr fromRawIdentityExpr(Raw::Element e) {
    result = fromRawAwaitExpr(e)
    or
    result = fromRawDotSelfExpr(e)
    or
    result = fromRawParenExpr(e)
    or
    result = fromRawUnresolvedMemberChainResultExpr(e)
  }

  cached
  TImplicitConversionExpr fromRawImplicitConversionExpr(Raw::Element e) {
    result = fromRawAnyHashableErasureExpr(e)
    or
    result = fromRawArchetypeToSuperExpr(e)
    or
    result = fromRawArrayToPointerExpr(e)
    or
    result = fromRawBridgeFromObjCExpr(e)
    or
    result = fromRawBridgeToObjCExpr(e)
    or
    result = fromRawClassMetatypeToObjectExpr(e)
    or
    result = fromRawCollectionUpcastConversionExpr(e)
    or
    result = fromRawConditionalBridgeFromObjCExpr(e)
    or
    result = fromRawCovariantFunctionConversionExpr(e)
    or
    result = fromRawCovariantReturnConversionExpr(e)
    or
    result = fromRawDerivedToBaseExpr(e)
    or
    result = fromRawDestructureTupleExpr(e)
    or
    result = fromRawDifferentiableFunctionExpr(e)
    or
    result = fromRawDifferentiableFunctionExtractOriginalExpr(e)
    or
    result = fromRawErasureExpr(e)
    or
    result = fromRawExistentialMetatypeToObjectExpr(e)
    or
    result = fromRawForeignObjectConversionExpr(e)
    or
    result = fromRawFunctionConversionExpr(e)
    or
    result = fromRawInOutToPointerExpr(e)
    or
    result = fromRawInjectIntoOptionalExpr(e)
    or
    result = fromRawLinearFunctionExpr(e)
    or
    result = fromRawLinearFunctionExtractOriginalExpr(e)
    or
    result = fromRawLinearToDifferentiableFunctionExpr(e)
    or
    result = fromRawLoadExpr(e)
    or
    result = fromRawMetatypeConversionExpr(e)
    or
    result = fromRawPointerToPointerExpr(e)
    or
    result = fromRawProtocolMetatypeToObjectExpr(e)
    or
    result = fromRawStringToPointerExpr(e)
    or
    result = fromRawUnderlyingToOpaqueExpr(e)
    or
    result = fromRawUnevaluatedInstanceExpr(e)
    or
    result = fromRawUnresolvedTypeConversionExpr(e)
  }

  cached
  TLiteralExpr fromRawLiteralExpr(Raw::Element e) {
    result = fromRawBuiltinLiteralExpr(e)
    or
    result = fromRawInterpolatedStringLiteralExpr(e)
    or
    result = fromRawNilLiteralExpr(e)
    or
    result = fromRawObjectLiteralExpr(e)
    or
    result = fromRawRegexLiteralExpr(e)
  }

  cached
  TLookupExpr fromRawLookupExpr(Raw::Element e) {
    result = fromRawDynamicLookupExpr(e)
    or
    result = fromRawMemberRefExpr(e)
    or
    result = fromRawSubscriptExpr(e)
  }

  cached
  TNumberLiteralExpr fromRawNumberLiteralExpr(Raw::Element e) {
    result = fromRawFloatLiteralExpr(e)
    or
    result = fromRawIntegerLiteralExpr(e)
  }

  cached
  TOverloadSetRefExpr fromRawOverloadSetRefExpr(Raw::Element e) {
    result = fromRawOverloadedDeclRefExpr(e)
  }

  cached
  TSelfApplyExpr fromRawSelfApplyExpr(Raw::Element e) {
    result = fromRawConstructorRefCallExpr(e)
    or
    result = fromRawDotSyntaxCallExpr(e)
  }

  cached
  TPattern fromRawPattern(Raw::Element e) {
    result = fromRawAnyPattern(e)
    or
    result = fromRawBindingPattern(e)
    or
    result = fromRawBoolPattern(e)
    or
    result = fromRawEnumElementPattern(e)
    or
    result = fromRawExprPattern(e)
    or
    result = fromRawIsPattern(e)
    or
    result = fromRawNamedPattern(e)
    or
    result = fromRawOptionalSomePattern(e)
    or
    result = fromRawParenPattern(e)
    or
    result = fromRawTuplePattern(e)
    or
    result = fromRawTypedPattern(e)
  }

  cached
  TLabeledConditionalStmt fromRawLabeledConditionalStmt(Raw::Element e) {
    result = fromRawGuardStmt(e)
    or
    result = fromRawIfStmt(e)
    or
    result = fromRawWhileStmt(e)
  }

  cached
  TLabeledStmt fromRawLabeledStmt(Raw::Element e) {
    result = fromRawDoCatchStmt(e)
    or
    result = fromRawDoStmt(e)
    or
    result = fromRawForEachStmt(e)
    or
    result = fromRawLabeledConditionalStmt(e)
    or
    result = fromRawRepeatWhileStmt(e)
    or
    result = fromRawSwitchStmt(e)
  }

  cached
  TStmt fromRawStmt(Raw::Element e) {
    result = fromRawBraceStmt(e)
    or
    result = fromRawBreakStmt(e)
    or
    result = fromRawCaseStmt(e)
    or
    result = fromRawContinueStmt(e)
    or
    result = fromRawDeferStmt(e)
    or
    result = fromRawFailStmt(e)
    or
    result = fromRawFallthroughStmt(e)
    or
    result = fromRawLabeledStmt(e)
    or
    result = fromRawPoundAssertStmt(e)
    or
    result = fromRawReturnStmt(e)
    or
    result = fromRawThrowStmt(e)
    or
    result = fromRawYieldStmt(e)
  }

  cached
  TAnyBuiltinIntegerType fromRawAnyBuiltinIntegerType(Raw::Element e) {
    result = fromRawBuiltinIntegerLiteralType(e)
    or
    result = fromRawBuiltinIntegerType(e)
  }

  cached
  TAnyFunctionType fromRawAnyFunctionType(Raw::Element e) {
    result = fromRawFunctionType(e)
    or
    result = fromRawGenericFunctionType(e)
  }

  cached
  TAnyGenericType fromRawAnyGenericType(Raw::Element e) {
    result = fromRawNominalOrBoundGenericNominalType(e)
    or
    result = fromRawUnboundGenericType(e)
  }

  cached
  TAnyMetatypeType fromRawAnyMetatypeType(Raw::Element e) {
    result = fromRawExistentialMetatypeType(e)
    or
    result = fromRawMetatypeType(e)
  }

  cached
  TArchetypeType fromRawArchetypeType(Raw::Element e) {
    result = fromRawNestedArchetypeType(e)
    or
    result = fromRawOpaqueTypeArchetypeType(e)
    or
    result = fromRawOpenedArchetypeType(e)
    or
    result = fromRawPrimaryArchetypeType(e)
    or
    result = fromRawSequenceArchetypeType(e)
  }

  cached
  TBoundGenericType fromRawBoundGenericType(Raw::Element e) {
    result = fromRawBoundGenericClassType(e)
    or
    result = fromRawBoundGenericEnumType(e)
    or
    result = fromRawBoundGenericStructType(e)
  }

  cached
  TBuiltinType fromRawBuiltinType(Raw::Element e) {
    result = fromRawAnyBuiltinIntegerType(e)
    or
    result = fromRawBuiltinBridgeObjectType(e)
    or
    result = fromRawBuiltinDefaultActorStorageType(e)
    or
    result = fromRawBuiltinExecutorType(e)
    or
    result = fromRawBuiltinFloatType(e)
    or
    result = fromRawBuiltinJobType(e)
    or
    result = fromRawBuiltinNativeObjectType(e)
    or
    result = fromRawBuiltinRawPointerType(e)
    or
    result = fromRawBuiltinRawUnsafeContinuationType(e)
    or
    result = fromRawBuiltinUnsafeValueBufferType(e)
    or
    result = fromRawBuiltinVectorType(e)
  }

  cached
  TNominalOrBoundGenericNominalType fromRawNominalOrBoundGenericNominalType(Raw::Element e) {
    result = fromRawBoundGenericType(e)
    or
    result = fromRawNominalType(e)
  }

  cached
  TNominalType fromRawNominalType(Raw::Element e) {
    result = fromRawClassType(e)
    or
    result = fromRawEnumType(e)
    or
    result = fromRawProtocolType(e)
    or
    result = fromRawStructType(e)
  }

  cached
  TReferenceStorageType fromRawReferenceStorageType(Raw::Element e) {
    result = fromRawUnmanagedStorageType(e)
    or
    result = fromRawUnownedStorageType(e)
    or
    result = fromRawWeakStorageType(e)
  }

  cached
  TSubstitutableType fromRawSubstitutableType(Raw::Element e) {
    result = fromRawArchetypeType(e)
    or
    result = fromRawGenericTypeParamType(e)
  }

  cached
  TSugarType fromRawSugarType(Raw::Element e) {
    result = fromRawParenType(e)
    or
    result = fromRawSyntaxSugarType(e)
    or
    result = fromRawTypeAliasType(e)
  }

  cached
  TSyntaxSugarType fromRawSyntaxSugarType(Raw::Element e) {
    result = fromRawDictionaryType(e)
    or
    result = fromRawUnarySyntaxSugarType(e)
  }

  cached
  TType fromRawType(Raw::Element e) {
    result = fromRawAnyFunctionType(e)
    or
    result = fromRawAnyGenericType(e)
    or
    result = fromRawAnyMetatypeType(e)
    or
    result = fromRawBuiltinType(e)
    or
    result = fromRawDependentMemberType(e)
    or
    result = fromRawDynamicSelfType(e)
    or
    result = fromRawErrorType(e)
    or
    result = fromRawExistentialType(e)
    or
    result = fromRawInOutType(e)
    or
    result = fromRawLValueType(e)
    or
    result = fromRawModuleType(e)
    or
    result = fromRawPlaceholderType(e)
    or
    result = fromRawProtocolCompositionType(e)
    or
    result = fromRawReferenceStorageType(e)
    or
    result = fromRawSilBlockStorageType(e)
    or
    result = fromRawSilBoxType(e)
    or
    result = fromRawSilFunctionType(e)
    or
    result = fromRawSilTokenType(e)
    or
    result = fromRawSubstitutableType(e)
    or
    result = fromRawSugarType(e)
    or
    result = fromRawTupleType(e)
    or
    result = fromRawTypeVariableType(e)
    or
    result = fromRawUnresolvedType(e)
  }

  cached
  TUnarySyntaxSugarType fromRawUnarySyntaxSugarType(Raw::Element e) {
    result = fromRawArraySliceType(e)
    or
    result = fromRawOptionalType(e)
    or
    result = fromRawVariadicSequenceType(e)
  }

  cached
  Raw::Element toRawComment(TComment e) { e = TComment(result) }

  cached
  Raw::Element toRawDbFile(TDbFile e) { e = TDbFile(result) }

  cached
  Raw::Element toRawDbLocation(TDbLocation e) { e = TDbLocation(result) }

  cached
  Raw::Element toRawUnknownFile(TUnknownFile e) { none() }

  cached
  Raw::Element toRawUnknownLocation(TUnknownLocation e) { none() }

  cached
  Raw::Element toRawAccessorDecl(TAccessorDecl e) { e = TAccessorDecl(result) }

  cached
  Raw::Element toRawAssociatedTypeDecl(TAssociatedTypeDecl e) { e = TAssociatedTypeDecl(result) }

  cached
  Raw::Element toRawClassDecl(TClassDecl e) { e = TClassDecl(result) }

  cached
  Raw::Element toRawConcreteFuncDecl(TConcreteFuncDecl e) { e = TConcreteFuncDecl(result) }

  cached
  Raw::Element toRawConcreteVarDecl(TConcreteVarDecl e) { e = TConcreteVarDecl(result) }

  cached
  Raw::Element toRawConstructorDecl(TConstructorDecl e) { e = TConstructorDecl(result) }

  cached
  Raw::Element toRawDestructorDecl(TDestructorDecl e) { e = TDestructorDecl(result) }

  cached
  Raw::Element toRawEnumCaseDecl(TEnumCaseDecl e) { e = TEnumCaseDecl(result) }

  cached
  Raw::Element toRawEnumDecl(TEnumDecl e) { e = TEnumDecl(result) }

  cached
  Raw::Element toRawEnumElementDecl(TEnumElementDecl e) { e = TEnumElementDecl(result) }

  cached
  Raw::Element toRawExtensionDecl(TExtensionDecl e) { e = TExtensionDecl(result) }

  cached
  Raw::Element toRawGenericTypeParamDecl(TGenericTypeParamDecl e) {
    e = TGenericTypeParamDecl(result)
  }

  cached
  Raw::Element toRawIfConfigClause(TIfConfigClause e) { e = TIfConfigClause(result) }

  cached
  Raw::Element toRawIfConfigDecl(TIfConfigDecl e) { e = TIfConfigDecl(result) }

  cached
  Raw::Element toRawImportDecl(TImportDecl e) { e = TImportDecl(result) }

  cached
  Raw::Element toRawInfixOperatorDecl(TInfixOperatorDecl e) { e = TInfixOperatorDecl(result) }

  cached
  Raw::Element toRawMissingMemberDecl(TMissingMemberDecl e) { e = TMissingMemberDecl(result) }

  cached
  Raw::Element toRawModuleDecl(TModuleDecl e) { e = TModuleDecl(result) }

  cached
  Raw::Element toRawOpaqueTypeDecl(TOpaqueTypeDecl e) { e = TOpaqueTypeDecl(result) }

  cached
  Raw::Element toRawParamDecl(TParamDecl e) { e = TParamDecl(result) }

  cached
  Raw::Element toRawPatternBindingDecl(TPatternBindingDecl e) { e = TPatternBindingDecl(result) }

  cached
  Raw::Element toRawPostfixOperatorDecl(TPostfixOperatorDecl e) { e = TPostfixOperatorDecl(result) }

  cached
  Raw::Element toRawPoundDiagnosticDecl(TPoundDiagnosticDecl e) { e = TPoundDiagnosticDecl(result) }

  cached
  Raw::Element toRawPrecedenceGroupDecl(TPrecedenceGroupDecl e) { e = TPrecedenceGroupDecl(result) }

  cached
  Raw::Element toRawPrefixOperatorDecl(TPrefixOperatorDecl e) { e = TPrefixOperatorDecl(result) }

  cached
  Raw::Element toRawProtocolDecl(TProtocolDecl e) { e = TProtocolDecl(result) }

  cached
  Raw::Element toRawStructDecl(TStructDecl e) { e = TStructDecl(result) }

  cached
  Raw::Element toRawSubscriptDecl(TSubscriptDecl e) { e = TSubscriptDecl(result) }

  cached
  Raw::Element toRawTopLevelCodeDecl(TTopLevelCodeDecl e) { e = TTopLevelCodeDecl(result) }

  cached
  Raw::Element toRawTypeAliasDecl(TTypeAliasDecl e) { e = TTypeAliasDecl(result) }

  cached
  Raw::Element toRawAnyHashableErasureExpr(TAnyHashableErasureExpr e) {
    e = TAnyHashableErasureExpr(result)
  }

  cached
  Raw::Element toRawAppliedPropertyWrapperExpr(TAppliedPropertyWrapperExpr e) {
    e = TAppliedPropertyWrapperExpr(result)
  }

  cached
  Raw::Element toRawArchetypeToSuperExpr(TArchetypeToSuperExpr e) {
    e = TArchetypeToSuperExpr(result)
  }

  cached
  Raw::Element toRawArgument(TArgument e) { e = TArgument(result) }

  cached
  Raw::Element toRawArrayExpr(TArrayExpr e) { e = TArrayExpr(result) }

  cached
  Raw::Element toRawArrayToPointerExpr(TArrayToPointerExpr e) { e = TArrayToPointerExpr(result) }

  cached
  Raw::Element toRawArrowExpr(TArrowExpr e) { e = TArrowExpr(result) }

  cached
  Raw::Element toRawAssignExpr(TAssignExpr e) { e = TAssignExpr(result) }

  cached
  Raw::Element toRawAutoClosureExpr(TAutoClosureExpr e) { e = TAutoClosureExpr(result) }

  cached
  Raw::Element toRawAwaitExpr(TAwaitExpr e) { e = TAwaitExpr(result) }

  cached
  Raw::Element toRawBinaryExpr(TBinaryExpr e) { e = TBinaryExpr(result) }

  cached
  Raw::Element toRawBindOptionalExpr(TBindOptionalExpr e) { e = TBindOptionalExpr(result) }

  cached
  Raw::Element toRawBooleanLiteralExpr(TBooleanLiteralExpr e) { e = TBooleanLiteralExpr(result) }

  cached
  Raw::Element toRawBridgeFromObjCExpr(TBridgeFromObjCExpr e) { e = TBridgeFromObjCExpr(result) }

  cached
  Raw::Element toRawBridgeToObjCExpr(TBridgeToObjCExpr e) { e = TBridgeToObjCExpr(result) }

  cached
  Raw::Element toRawCallExpr(TCallExpr e) { e = TCallExpr(result) }

  cached
  Raw::Element toRawCaptureListExpr(TCaptureListExpr e) { e = TCaptureListExpr(result) }

  cached
  Raw::Element toRawClassMetatypeToObjectExpr(TClassMetatypeToObjectExpr e) {
    e = TClassMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element toRawClosureExpr(TClosureExpr e) { e = TClosureExpr(result) }

  cached
  Raw::Element toRawCodeCompletionExpr(TCodeCompletionExpr e) { e = TCodeCompletionExpr(result) }

  cached
  Raw::Element toRawCoerceExpr(TCoerceExpr e) { e = TCoerceExpr(result) }

  cached
  Raw::Element toRawCollectionUpcastConversionExpr(TCollectionUpcastConversionExpr e) {
    e = TCollectionUpcastConversionExpr(result)
  }

  cached
  Raw::Element toRawConditionalBridgeFromObjCExpr(TConditionalBridgeFromObjCExpr e) {
    e = TConditionalBridgeFromObjCExpr(result)
  }

  cached
  Raw::Element toRawConditionalCheckedCastExpr(TConditionalCheckedCastExpr e) {
    e = TConditionalCheckedCastExpr(result)
  }

  cached
  Raw::Element toRawConstructorRefCallExpr(TConstructorRefCallExpr e) {
    e = TConstructorRefCallExpr(result)
  }

  cached
  Raw::Element toRawCovariantFunctionConversionExpr(TCovariantFunctionConversionExpr e) {
    e = TCovariantFunctionConversionExpr(result)
  }

  cached
  Raw::Element toRawCovariantReturnConversionExpr(TCovariantReturnConversionExpr e) {
    e = TCovariantReturnConversionExpr(result)
  }

  cached
  Raw::Element toRawDeclRefExpr(TDeclRefExpr e) { e = TDeclRefExpr(result) }

  cached
  Raw::Element toRawDefaultArgumentExpr(TDefaultArgumentExpr e) { e = TDefaultArgumentExpr(result) }

  cached
  Raw::Element toRawDerivedToBaseExpr(TDerivedToBaseExpr e) { e = TDerivedToBaseExpr(result) }

  cached
  Raw::Element toRawDestructureTupleExpr(TDestructureTupleExpr e) {
    e = TDestructureTupleExpr(result)
  }

  cached
  Raw::Element toRawDictionaryExpr(TDictionaryExpr e) { e = TDictionaryExpr(result) }

  cached
  Raw::Element toRawDifferentiableFunctionExpr(TDifferentiableFunctionExpr e) {
    e = TDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element toRawDifferentiableFunctionExtractOriginalExpr(
    TDifferentiableFunctionExtractOriginalExpr e
  ) {
    e = TDifferentiableFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element toRawDiscardAssignmentExpr(TDiscardAssignmentExpr e) {
    e = TDiscardAssignmentExpr(result)
  }

  cached
  Raw::Element toRawDotSelfExpr(TDotSelfExpr e) { e = TDotSelfExpr(result) }

  cached
  Raw::Element toRawDotSyntaxBaseIgnoredExpr(TDotSyntaxBaseIgnoredExpr e) {
    e = TDotSyntaxBaseIgnoredExpr(result)
  }

  cached
  Raw::Element toRawDotSyntaxCallExpr(TDotSyntaxCallExpr e) { e = TDotSyntaxCallExpr(result) }

  cached
  Raw::Element toRawDynamicMemberRefExpr(TDynamicMemberRefExpr e) {
    e = TDynamicMemberRefExpr(result)
  }

  cached
  Raw::Element toRawDynamicSubscriptExpr(TDynamicSubscriptExpr e) {
    e = TDynamicSubscriptExpr(result)
  }

  cached
  Raw::Element toRawDynamicTypeExpr(TDynamicTypeExpr e) { e = TDynamicTypeExpr(result) }

  cached
  Raw::Element toRawEditorPlaceholderExpr(TEditorPlaceholderExpr e) {
    e = TEditorPlaceholderExpr(result)
  }

  cached
  Raw::Element toRawEnumIsCaseExpr(TEnumIsCaseExpr e) { e = TEnumIsCaseExpr(result) }

  cached
  Raw::Element toRawErasureExpr(TErasureExpr e) { e = TErasureExpr(result) }

  cached
  Raw::Element toRawErrorExpr(TErrorExpr e) { e = TErrorExpr(result) }

  cached
  Raw::Element toRawExistentialMetatypeToObjectExpr(TExistentialMetatypeToObjectExpr e) {
    e = TExistentialMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element toRawFloatLiteralExpr(TFloatLiteralExpr e) { e = TFloatLiteralExpr(result) }

  cached
  Raw::Element toRawForceTryExpr(TForceTryExpr e) { e = TForceTryExpr(result) }

  cached
  Raw::Element toRawForceValueExpr(TForceValueExpr e) { e = TForceValueExpr(result) }

  cached
  Raw::Element toRawForcedCheckedCastExpr(TForcedCheckedCastExpr e) {
    e = TForcedCheckedCastExpr(result)
  }

  cached
  Raw::Element toRawForeignObjectConversionExpr(TForeignObjectConversionExpr e) {
    e = TForeignObjectConversionExpr(result)
  }

  cached
  Raw::Element toRawFunctionConversionExpr(TFunctionConversionExpr e) {
    e = TFunctionConversionExpr(result)
  }

  cached
  Raw::Element toRawIfExpr(TIfExpr e) { e = TIfExpr(result) }

  cached
  Raw::Element toRawInOutExpr(TInOutExpr e) { e = TInOutExpr(result) }

  cached
  Raw::Element toRawInOutToPointerExpr(TInOutToPointerExpr e) { e = TInOutToPointerExpr(result) }

  cached
  Raw::Element toRawInjectIntoOptionalExpr(TInjectIntoOptionalExpr e) {
    e = TInjectIntoOptionalExpr(result)
  }

  cached
  Raw::Element toRawIntegerLiteralExpr(TIntegerLiteralExpr e) { e = TIntegerLiteralExpr(result) }

  cached
  Raw::Element toRawInterpolatedStringLiteralExpr(TInterpolatedStringLiteralExpr e) {
    e = TInterpolatedStringLiteralExpr(result)
  }

  cached
  Raw::Element toRawIsExpr(TIsExpr e) { e = TIsExpr(result) }

  cached
  Raw::Element toRawKeyPathApplicationExpr(TKeyPathApplicationExpr e) {
    e = TKeyPathApplicationExpr(result)
  }

  cached
  Raw::Element toRawKeyPathDotExpr(TKeyPathDotExpr e) { e = TKeyPathDotExpr(result) }

  cached
  Raw::Element toRawKeyPathExpr(TKeyPathExpr e) { e = TKeyPathExpr(result) }

  cached
  Raw::Element toRawLazyInitializerExpr(TLazyInitializerExpr e) { e = TLazyInitializerExpr(result) }

  cached
  Raw::Element toRawLinearFunctionExpr(TLinearFunctionExpr e) { e = TLinearFunctionExpr(result) }

  cached
  Raw::Element toRawLinearFunctionExtractOriginalExpr(TLinearFunctionExtractOriginalExpr e) {
    e = TLinearFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element toRawLinearToDifferentiableFunctionExpr(TLinearToDifferentiableFunctionExpr e) {
    e = TLinearToDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element toRawLoadExpr(TLoadExpr e) { e = TLoadExpr(result) }

  cached
  Raw::Element toRawMagicIdentifierLiteralExpr(TMagicIdentifierLiteralExpr e) {
    e = TMagicIdentifierLiteralExpr(result)
  }

  cached
  Raw::Element toRawMakeTemporarilyEscapableExpr(TMakeTemporarilyEscapableExpr e) {
    e = TMakeTemporarilyEscapableExpr(result)
  }

  cached
  Raw::Element toRawMemberRefExpr(TMemberRefExpr e) { e = TMemberRefExpr(result) }

  cached
  Raw::Element toRawMetatypeConversionExpr(TMetatypeConversionExpr e) {
    e = TMetatypeConversionExpr(result)
  }

  cached
  Raw::Element toRawNilLiteralExpr(TNilLiteralExpr e) { e = TNilLiteralExpr(result) }

  cached
  Raw::Element toRawObjCSelectorExpr(TObjCSelectorExpr e) { e = TObjCSelectorExpr(result) }

  cached
  Raw::Element toRawObjectLiteralExpr(TObjectLiteralExpr e) { e = TObjectLiteralExpr(result) }

  cached
  Raw::Element toRawOneWayExpr(TOneWayExpr e) { e = TOneWayExpr(result) }

  cached
  Raw::Element toRawOpaqueValueExpr(TOpaqueValueExpr e) { e = TOpaqueValueExpr(result) }

  cached
  Raw::Element toRawOpenExistentialExpr(TOpenExistentialExpr e) { e = TOpenExistentialExpr(result) }

  cached
  Raw::Element toRawOptionalEvaluationExpr(TOptionalEvaluationExpr e) {
    e = TOptionalEvaluationExpr(result)
  }

  cached
  Raw::Element toRawOptionalTryExpr(TOptionalTryExpr e) { e = TOptionalTryExpr(result) }

  cached
  Raw::Element toRawOtherConstructorDeclRefExpr(TOtherConstructorDeclRefExpr e) {
    e = TOtherConstructorDeclRefExpr(result)
  }

  cached
  Raw::Element toRawOverloadedDeclRefExpr(TOverloadedDeclRefExpr e) {
    e = TOverloadedDeclRefExpr(result)
  }

  cached
  Raw::Element toRawParenExpr(TParenExpr e) { e = TParenExpr(result) }

  cached
  Raw::Element toRawPointerToPointerExpr(TPointerToPointerExpr e) {
    e = TPointerToPointerExpr(result)
  }

  cached
  Raw::Element toRawPostfixUnaryExpr(TPostfixUnaryExpr e) { e = TPostfixUnaryExpr(result) }

  cached
  Raw::Element toRawPrefixUnaryExpr(TPrefixUnaryExpr e) { e = TPrefixUnaryExpr(result) }

  cached
  Raw::Element toRawPropertyWrapperValuePlaceholderExpr(TPropertyWrapperValuePlaceholderExpr e) {
    e = TPropertyWrapperValuePlaceholderExpr(result)
  }

  cached
  Raw::Element toRawProtocolMetatypeToObjectExpr(TProtocolMetatypeToObjectExpr e) {
    e = TProtocolMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element toRawRebindSelfInConstructorExpr(TRebindSelfInConstructorExpr e) {
    e = TRebindSelfInConstructorExpr(result)
  }

  cached
  Raw::Element toRawRegexLiteralExpr(TRegexLiteralExpr e) { e = TRegexLiteralExpr(result) }

  cached
  Raw::Element toRawSequenceExpr(TSequenceExpr e) { e = TSequenceExpr(result) }

  cached
  Raw::Element toRawStringLiteralExpr(TStringLiteralExpr e) { e = TStringLiteralExpr(result) }

  cached
  Raw::Element toRawStringToPointerExpr(TStringToPointerExpr e) { e = TStringToPointerExpr(result) }

  cached
  Raw::Element toRawSubscriptExpr(TSubscriptExpr e) { e = TSubscriptExpr(result) }

  cached
  Raw::Element toRawSuperRefExpr(TSuperRefExpr e) { e = TSuperRefExpr(result) }

  cached
  Raw::Element toRawTapExpr(TTapExpr e) { e = TTapExpr(result) }

  cached
  Raw::Element toRawTryExpr(TTryExpr e) { e = TTryExpr(result) }

  cached
  Raw::Element toRawTupleElementExpr(TTupleElementExpr e) { e = TTupleElementExpr(result) }

  cached
  Raw::Element toRawTupleExpr(TTupleExpr e) { e = TTupleExpr(result) }

  cached
  Raw::Element toRawTypeExpr(TTypeExpr e) { e = TTypeExpr(result) }

  cached
  Raw::Element toRawUnderlyingToOpaqueExpr(TUnderlyingToOpaqueExpr e) {
    e = TUnderlyingToOpaqueExpr(result)
  }

  cached
  Raw::Element toRawUnevaluatedInstanceExpr(TUnevaluatedInstanceExpr e) {
    e = TUnevaluatedInstanceExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedDeclRefExpr(TUnresolvedDeclRefExpr e) {
    e = TUnresolvedDeclRefExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedDotExpr(TUnresolvedDotExpr e) { e = TUnresolvedDotExpr(result) }

  cached
  Raw::Element toRawUnresolvedMemberChainResultExpr(TUnresolvedMemberChainResultExpr e) {
    e = TUnresolvedMemberChainResultExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedMemberExpr(TUnresolvedMemberExpr e) {
    e = TUnresolvedMemberExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedPatternExpr(TUnresolvedPatternExpr e) {
    e = TUnresolvedPatternExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedSpecializeExpr(TUnresolvedSpecializeExpr e) {
    e = TUnresolvedSpecializeExpr(result)
  }

  cached
  Raw::Element toRawUnresolvedTypeConversionExpr(TUnresolvedTypeConversionExpr e) {
    e = TUnresolvedTypeConversionExpr(result)
  }

  cached
  Raw::Element toRawVarargExpansionExpr(TVarargExpansionExpr e) { e = TVarargExpansionExpr(result) }

  cached
  Raw::Element toRawAnyPattern(TAnyPattern e) { e = TAnyPattern(result) }

  cached
  Raw::Element toRawBindingPattern(TBindingPattern e) { e = TBindingPattern(result) }

  cached
  Raw::Element toRawBoolPattern(TBoolPattern e) { e = TBoolPattern(result) }

  cached
  Raw::Element toRawEnumElementPattern(TEnumElementPattern e) { e = TEnumElementPattern(result) }

  cached
  Raw::Element toRawExprPattern(TExprPattern e) { e = TExprPattern(result) }

  cached
  Raw::Element toRawIsPattern(TIsPattern e) { e = TIsPattern(result) }

  cached
  Raw::Element toRawNamedPattern(TNamedPattern e) { e = TNamedPattern(result) }

  cached
  Raw::Element toRawOptionalSomePattern(TOptionalSomePattern e) { e = TOptionalSomePattern(result) }

  cached
  Raw::Element toRawParenPattern(TParenPattern e) { e = TParenPattern(result) }

  cached
  Raw::Element toRawTuplePattern(TTuplePattern e) { e = TTuplePattern(result) }

  cached
  Raw::Element toRawTypedPattern(TTypedPattern e) { e = TTypedPattern(result) }

  cached
  Raw::Element toRawBraceStmt(TBraceStmt e) { e = TBraceStmt(result) }

  cached
  Raw::Element toRawBreakStmt(TBreakStmt e) { e = TBreakStmt(result) }

  cached
  Raw::Element toRawCaseLabelItem(TCaseLabelItem e) { e = TCaseLabelItem(result) }

  cached
  Raw::Element toRawCaseStmt(TCaseStmt e) { e = TCaseStmt(result) }

  cached
  Raw::Element toRawConditionElement(TConditionElement e) { e = TConditionElement(result) }

  cached
  Raw::Element toRawContinueStmt(TContinueStmt e) { e = TContinueStmt(result) }

  cached
  Raw::Element toRawDeferStmt(TDeferStmt e) { e = TDeferStmt(result) }

  cached
  Raw::Element toRawDoCatchStmt(TDoCatchStmt e) { e = TDoCatchStmt(result) }

  cached
  Raw::Element toRawDoStmt(TDoStmt e) { e = TDoStmt(result) }

  cached
  Raw::Element toRawFailStmt(TFailStmt e) { e = TFailStmt(result) }

  cached
  Raw::Element toRawFallthroughStmt(TFallthroughStmt e) { e = TFallthroughStmt(result) }

  cached
  Raw::Element toRawForEachStmt(TForEachStmt e) { e = TForEachStmt(result) }

  cached
  Raw::Element toRawGuardStmt(TGuardStmt e) { e = TGuardStmt(result) }

  cached
  Raw::Element toRawIfStmt(TIfStmt e) { e = TIfStmt(result) }

  cached
  Raw::Element toRawPoundAssertStmt(TPoundAssertStmt e) { e = TPoundAssertStmt(result) }

  cached
  Raw::Element toRawRepeatWhileStmt(TRepeatWhileStmt e) { e = TRepeatWhileStmt(result) }

  cached
  Raw::Element toRawReturnStmt(TReturnStmt e) { e = TReturnStmt(result) }

  cached
  Raw::Element toRawStmtCondition(TStmtCondition e) { e = TStmtCondition(result) }

  cached
  Raw::Element toRawSwitchStmt(TSwitchStmt e) { e = TSwitchStmt(result) }

  cached
  Raw::Element toRawThrowStmt(TThrowStmt e) { e = TThrowStmt(result) }

  cached
  Raw::Element toRawWhileStmt(TWhileStmt e) { e = TWhileStmt(result) }

  cached
  Raw::Element toRawYieldStmt(TYieldStmt e) { e = TYieldStmt(result) }

  cached
  Raw::Element toRawArraySliceType(TArraySliceType e) { e = TArraySliceType(result) }

  cached
  Raw::Element toRawBoundGenericClassType(TBoundGenericClassType e) {
    e = TBoundGenericClassType(result)
  }

  cached
  Raw::Element toRawBoundGenericEnumType(TBoundGenericEnumType e) {
    e = TBoundGenericEnumType(result)
  }

  cached
  Raw::Element toRawBoundGenericStructType(TBoundGenericStructType e) {
    e = TBoundGenericStructType(result)
  }

  cached
  Raw::Element toRawBuiltinBridgeObjectType(TBuiltinBridgeObjectType e) {
    e = TBuiltinBridgeObjectType(result)
  }

  cached
  Raw::Element toRawBuiltinDefaultActorStorageType(TBuiltinDefaultActorStorageType e) {
    e = TBuiltinDefaultActorStorageType(result)
  }

  cached
  Raw::Element toRawBuiltinExecutorType(TBuiltinExecutorType e) { e = TBuiltinExecutorType(result) }

  cached
  Raw::Element toRawBuiltinFloatType(TBuiltinFloatType e) { e = TBuiltinFloatType(result) }

  cached
  Raw::Element toRawBuiltinIntegerLiteralType(TBuiltinIntegerLiteralType e) {
    e = TBuiltinIntegerLiteralType(result)
  }

  cached
  Raw::Element toRawBuiltinIntegerType(TBuiltinIntegerType e) { e = TBuiltinIntegerType(result) }

  cached
  Raw::Element toRawBuiltinJobType(TBuiltinJobType e) { e = TBuiltinJobType(result) }

  cached
  Raw::Element toRawBuiltinNativeObjectType(TBuiltinNativeObjectType e) {
    e = TBuiltinNativeObjectType(result)
  }

  cached
  Raw::Element toRawBuiltinRawPointerType(TBuiltinRawPointerType e) {
    e = TBuiltinRawPointerType(result)
  }

  cached
  Raw::Element toRawBuiltinRawUnsafeContinuationType(TBuiltinRawUnsafeContinuationType e) {
    e = TBuiltinRawUnsafeContinuationType(result)
  }

  cached
  Raw::Element toRawBuiltinUnsafeValueBufferType(TBuiltinUnsafeValueBufferType e) {
    e = TBuiltinUnsafeValueBufferType(result)
  }

  cached
  Raw::Element toRawBuiltinVectorType(TBuiltinVectorType e) { e = TBuiltinVectorType(result) }

  cached
  Raw::Element toRawClassType(TClassType e) { e = TClassType(result) }

  cached
  Raw::Element toRawDependentMemberType(TDependentMemberType e) { e = TDependentMemberType(result) }

  cached
  Raw::Element toRawDictionaryType(TDictionaryType e) { e = TDictionaryType(result) }

  cached
  Raw::Element toRawDynamicSelfType(TDynamicSelfType e) { e = TDynamicSelfType(result) }

  cached
  Raw::Element toRawEnumType(TEnumType e) { e = TEnumType(result) }

  cached
  Raw::Element toRawErrorType(TErrorType e) { e = TErrorType(result) }

  cached
  Raw::Element toRawExistentialMetatypeType(TExistentialMetatypeType e) {
    e = TExistentialMetatypeType(result)
  }

  cached
  Raw::Element toRawExistentialType(TExistentialType e) { e = TExistentialType(result) }

  cached
  Raw::Element toRawFunctionType(TFunctionType e) { e = TFunctionType(result) }

  cached
  Raw::Element toRawGenericFunctionType(TGenericFunctionType e) { e = TGenericFunctionType(result) }

  cached
  Raw::Element toRawGenericTypeParamType(TGenericTypeParamType e) {
    e = TGenericTypeParamType(result)
  }

  cached
  Raw::Element toRawInOutType(TInOutType e) { e = TInOutType(result) }

  cached
  Raw::Element toRawLValueType(TLValueType e) { e = TLValueType(result) }

  cached
  Raw::Element toRawMetatypeType(TMetatypeType e) { e = TMetatypeType(result) }

  cached
  Raw::Element toRawModuleType(TModuleType e) { e = TModuleType(result) }

  cached
  Raw::Element toRawNestedArchetypeType(TNestedArchetypeType e) { e = TNestedArchetypeType(result) }

  cached
  Raw::Element toRawOpaqueTypeArchetypeType(TOpaqueTypeArchetypeType e) {
    e = TOpaqueTypeArchetypeType(result)
  }

  cached
  Raw::Element toRawOpenedArchetypeType(TOpenedArchetypeType e) { e = TOpenedArchetypeType(result) }

  cached
  Raw::Element toRawOptionalType(TOptionalType e) { e = TOptionalType(result) }

  cached
  Raw::Element toRawParenType(TParenType e) { e = TParenType(result) }

  cached
  Raw::Element toRawPlaceholderType(TPlaceholderType e) { e = TPlaceholderType(result) }

  cached
  Raw::Element toRawPrimaryArchetypeType(TPrimaryArchetypeType e) {
    e = TPrimaryArchetypeType(result)
  }

  cached
  Raw::Element toRawProtocolCompositionType(TProtocolCompositionType e) {
    e = TProtocolCompositionType(result)
  }

  cached
  Raw::Element toRawProtocolType(TProtocolType e) { e = TProtocolType(result) }

  cached
  Raw::Element toRawSequenceArchetypeType(TSequenceArchetypeType e) {
    e = TSequenceArchetypeType(result)
  }

  cached
  Raw::Element toRawSilBlockStorageType(TSilBlockStorageType e) { e = TSilBlockStorageType(result) }

  cached
  Raw::Element toRawSilBoxType(TSilBoxType e) { e = TSilBoxType(result) }

  cached
  Raw::Element toRawSilFunctionType(TSilFunctionType e) { e = TSilFunctionType(result) }

  cached
  Raw::Element toRawSilTokenType(TSilTokenType e) { e = TSilTokenType(result) }

  cached
  Raw::Element toRawStructType(TStructType e) { e = TStructType(result) }

  cached
  Raw::Element toRawTupleType(TTupleType e) { e = TTupleType(result) }

  cached
  Raw::Element toRawTypeAliasType(TTypeAliasType e) { e = TTypeAliasType(result) }

  cached
  Raw::Element toRawTypeRepr(TTypeRepr e) { e = TTypeRepr(result) }

  cached
  Raw::Element toRawTypeVariableType(TTypeVariableType e) { e = TTypeVariableType(result) }

  cached
  Raw::Element toRawUnboundGenericType(TUnboundGenericType e) { e = TUnboundGenericType(result) }

  cached
  Raw::Element toRawUnmanagedStorageType(TUnmanagedStorageType e) {
    e = TUnmanagedStorageType(result)
  }

  cached
  Raw::Element toRawUnownedStorageType(TUnownedStorageType e) { e = TUnownedStorageType(result) }

  cached
  Raw::Element toRawUnresolvedType(TUnresolvedType e) { e = TUnresolvedType(result) }

  cached
  Raw::Element toRawVariadicSequenceType(TVariadicSequenceType e) {
    e = TVariadicSequenceType(result)
  }

  cached
  Raw::Element toRawWeakStorageType(TWeakStorageType e) { e = TWeakStorageType(result) }

  cached
  Raw::Element toRawAstNode(TAstNode e) {
    result = toRawCaseLabelItem(e)
    or
    result = toRawDecl(e)
    or
    result = toRawExpr(e)
    or
    result = toRawPattern(e)
    or
    result = toRawStmt(e)
    or
    result = toRawStmtCondition(e)
    or
    result = toRawTypeRepr(e)
  }

  cached
  Raw::Element toRawCallable(TCallable e) {
    result = toRawAbstractClosureExpr(e)
    or
    result = toRawAbstractFunctionDecl(e)
  }

  cached
  Raw::Element toRawElement(TElement e) {
    result = toRawCallable(e)
    or
    result = toRawFile(e)
    or
    result = toRawGenericContext(e)
    or
    result = toRawIterableDeclContext(e)
    or
    result = toRawLocatable(e)
    or
    result = toRawLocation(e)
    or
    result = toRawType(e)
  }

  cached
  Raw::Element toRawFile(TFile e) {
    result = toRawDbFile(e)
    or
    result = toRawUnknownFile(e)
  }

  cached
  Raw::Element toRawLocatable(TLocatable e) {
    result = toRawArgument(e)
    or
    result = toRawAstNode(e)
    or
    result = toRawComment(e)
    or
    result = toRawConditionElement(e)
    or
    result = toRawIfConfigClause(e)
  }

  cached
  Raw::Element toRawLocation(TLocation e) {
    result = toRawDbLocation(e)
    or
    result = toRawUnknownLocation(e)
  }

  cached
  Raw::Element toRawAbstractFunctionDecl(TAbstractFunctionDecl e) {
    result = toRawConstructorDecl(e)
    or
    result = toRawDestructorDecl(e)
    or
    result = toRawFuncDecl(e)
  }

  cached
  Raw::Element toRawAbstractStorageDecl(TAbstractStorageDecl e) {
    result = toRawSubscriptDecl(e)
    or
    result = toRawVarDecl(e)
  }

  cached
  Raw::Element toRawAbstractTypeParamDecl(TAbstractTypeParamDecl e) {
    result = toRawAssociatedTypeDecl(e)
    or
    result = toRawGenericTypeParamDecl(e)
  }

  cached
  Raw::Element toRawDecl(TDecl e) {
    result = toRawEnumCaseDecl(e)
    or
    result = toRawExtensionDecl(e)
    or
    result = toRawIfConfigDecl(e)
    or
    result = toRawImportDecl(e)
    or
    result = toRawMissingMemberDecl(e)
    or
    result = toRawOperatorDecl(e)
    or
    result = toRawPatternBindingDecl(e)
    or
    result = toRawPoundDiagnosticDecl(e)
    or
    result = toRawPrecedenceGroupDecl(e)
    or
    result = toRawTopLevelCodeDecl(e)
    or
    result = toRawValueDecl(e)
  }

  cached
  Raw::Element toRawFuncDecl(TFuncDecl e) {
    result = toRawAccessorDecl(e)
    or
    result = toRawConcreteFuncDecl(e)
  }

  cached
  Raw::Element toRawGenericContext(TGenericContext e) {
    result = toRawAbstractFunctionDecl(e)
    or
    result = toRawExtensionDecl(e)
    or
    result = toRawGenericTypeDecl(e)
    or
    result = toRawSubscriptDecl(e)
  }

  cached
  Raw::Element toRawGenericTypeDecl(TGenericTypeDecl e) {
    result = toRawNominalTypeDecl(e)
    or
    result = toRawOpaqueTypeDecl(e)
    or
    result = toRawTypeAliasDecl(e)
  }

  cached
  Raw::Element toRawIterableDeclContext(TIterableDeclContext e) {
    result = toRawExtensionDecl(e)
    or
    result = toRawNominalTypeDecl(e)
  }

  cached
  Raw::Element toRawNominalTypeDecl(TNominalTypeDecl e) {
    result = toRawClassDecl(e)
    or
    result = toRawEnumDecl(e)
    or
    result = toRawProtocolDecl(e)
    or
    result = toRawStructDecl(e)
  }

  cached
  Raw::Element toRawOperatorDecl(TOperatorDecl e) {
    result = toRawInfixOperatorDecl(e)
    or
    result = toRawPostfixOperatorDecl(e)
    or
    result = toRawPrefixOperatorDecl(e)
  }

  cached
  Raw::Element toRawTypeDecl(TTypeDecl e) {
    result = toRawAbstractTypeParamDecl(e)
    or
    result = toRawGenericTypeDecl(e)
    or
    result = toRawModuleDecl(e)
  }

  cached
  Raw::Element toRawValueDecl(TValueDecl e) {
    result = toRawAbstractFunctionDecl(e)
    or
    result = toRawAbstractStorageDecl(e)
    or
    result = toRawEnumElementDecl(e)
    or
    result = toRawTypeDecl(e)
  }

  cached
  Raw::Element toRawVarDecl(TVarDecl e) {
    result = toRawConcreteVarDecl(e)
    or
    result = toRawParamDecl(e)
  }

  cached
  Raw::Element toRawAbstractClosureExpr(TAbstractClosureExpr e) {
    result = toRawAutoClosureExpr(e)
    or
    result = toRawClosureExpr(e)
  }

  cached
  Raw::Element toRawAnyTryExpr(TAnyTryExpr e) {
    result = toRawForceTryExpr(e)
    or
    result = toRawOptionalTryExpr(e)
    or
    result = toRawTryExpr(e)
  }

  cached
  Raw::Element toRawApplyExpr(TApplyExpr e) {
    result = toRawBinaryExpr(e)
    or
    result = toRawCallExpr(e)
    or
    result = toRawPostfixUnaryExpr(e)
    or
    result = toRawPrefixUnaryExpr(e)
    or
    result = toRawSelfApplyExpr(e)
  }

  cached
  Raw::Element toRawBuiltinLiteralExpr(TBuiltinLiteralExpr e) {
    result = toRawBooleanLiteralExpr(e)
    or
    result = toRawMagicIdentifierLiteralExpr(e)
    or
    result = toRawNumberLiteralExpr(e)
    or
    result = toRawStringLiteralExpr(e)
  }

  cached
  Raw::Element toRawCheckedCastExpr(TCheckedCastExpr e) {
    result = toRawConditionalCheckedCastExpr(e)
    or
    result = toRawForcedCheckedCastExpr(e)
    or
    result = toRawIsExpr(e)
  }

  cached
  Raw::Element toRawCollectionExpr(TCollectionExpr e) {
    result = toRawArrayExpr(e)
    or
    result = toRawDictionaryExpr(e)
  }

  cached
  Raw::Element toRawDynamicLookupExpr(TDynamicLookupExpr e) {
    result = toRawDynamicMemberRefExpr(e)
    or
    result = toRawDynamicSubscriptExpr(e)
  }

  cached
  Raw::Element toRawExplicitCastExpr(TExplicitCastExpr e) {
    result = toRawCheckedCastExpr(e)
    or
    result = toRawCoerceExpr(e)
  }

  cached
  Raw::Element toRawExpr(TExpr e) {
    result = toRawAbstractClosureExpr(e)
    or
    result = toRawAnyTryExpr(e)
    or
    result = toRawAppliedPropertyWrapperExpr(e)
    or
    result = toRawApplyExpr(e)
    or
    result = toRawArrowExpr(e)
    or
    result = toRawAssignExpr(e)
    or
    result = toRawBindOptionalExpr(e)
    or
    result = toRawCaptureListExpr(e)
    or
    result = toRawCodeCompletionExpr(e)
    or
    result = toRawCollectionExpr(e)
    or
    result = toRawDeclRefExpr(e)
    or
    result = toRawDefaultArgumentExpr(e)
    or
    result = toRawDiscardAssignmentExpr(e)
    or
    result = toRawDotSyntaxBaseIgnoredExpr(e)
    or
    result = toRawDynamicTypeExpr(e)
    or
    result = toRawEditorPlaceholderExpr(e)
    or
    result = toRawEnumIsCaseExpr(e)
    or
    result = toRawErrorExpr(e)
    or
    result = toRawExplicitCastExpr(e)
    or
    result = toRawForceValueExpr(e)
    or
    result = toRawIdentityExpr(e)
    or
    result = toRawIfExpr(e)
    or
    result = toRawImplicitConversionExpr(e)
    or
    result = toRawInOutExpr(e)
    or
    result = toRawKeyPathApplicationExpr(e)
    or
    result = toRawKeyPathDotExpr(e)
    or
    result = toRawKeyPathExpr(e)
    or
    result = toRawLazyInitializerExpr(e)
    or
    result = toRawLiteralExpr(e)
    or
    result = toRawLookupExpr(e)
    or
    result = toRawMakeTemporarilyEscapableExpr(e)
    or
    result = toRawObjCSelectorExpr(e)
    or
    result = toRawOneWayExpr(e)
    or
    result = toRawOpaqueValueExpr(e)
    or
    result = toRawOpenExistentialExpr(e)
    or
    result = toRawOptionalEvaluationExpr(e)
    or
    result = toRawOtherConstructorDeclRefExpr(e)
    or
    result = toRawOverloadSetRefExpr(e)
    or
    result = toRawPropertyWrapperValuePlaceholderExpr(e)
    or
    result = toRawRebindSelfInConstructorExpr(e)
    or
    result = toRawSequenceExpr(e)
    or
    result = toRawSuperRefExpr(e)
    or
    result = toRawTapExpr(e)
    or
    result = toRawTupleElementExpr(e)
    or
    result = toRawTupleExpr(e)
    or
    result = toRawTypeExpr(e)
    or
    result = toRawUnresolvedDeclRefExpr(e)
    or
    result = toRawUnresolvedDotExpr(e)
    or
    result = toRawUnresolvedMemberExpr(e)
    or
    result = toRawUnresolvedPatternExpr(e)
    or
    result = toRawUnresolvedSpecializeExpr(e)
    or
    result = toRawVarargExpansionExpr(e)
  }

  cached
  Raw::Element toRawIdentityExpr(TIdentityExpr e) {
    result = toRawAwaitExpr(e)
    or
    result = toRawDotSelfExpr(e)
    or
    result = toRawParenExpr(e)
    or
    result = toRawUnresolvedMemberChainResultExpr(e)
  }

  cached
  Raw::Element toRawImplicitConversionExpr(TImplicitConversionExpr e) {
    result = toRawAnyHashableErasureExpr(e)
    or
    result = toRawArchetypeToSuperExpr(e)
    or
    result = toRawArrayToPointerExpr(e)
    or
    result = toRawBridgeFromObjCExpr(e)
    or
    result = toRawBridgeToObjCExpr(e)
    or
    result = toRawClassMetatypeToObjectExpr(e)
    or
    result = toRawCollectionUpcastConversionExpr(e)
    or
    result = toRawConditionalBridgeFromObjCExpr(e)
    or
    result = toRawCovariantFunctionConversionExpr(e)
    or
    result = toRawCovariantReturnConversionExpr(e)
    or
    result = toRawDerivedToBaseExpr(e)
    or
    result = toRawDestructureTupleExpr(e)
    or
    result = toRawDifferentiableFunctionExpr(e)
    or
    result = toRawDifferentiableFunctionExtractOriginalExpr(e)
    or
    result = toRawErasureExpr(e)
    or
    result = toRawExistentialMetatypeToObjectExpr(e)
    or
    result = toRawForeignObjectConversionExpr(e)
    or
    result = toRawFunctionConversionExpr(e)
    or
    result = toRawInOutToPointerExpr(e)
    or
    result = toRawInjectIntoOptionalExpr(e)
    or
    result = toRawLinearFunctionExpr(e)
    or
    result = toRawLinearFunctionExtractOriginalExpr(e)
    or
    result = toRawLinearToDifferentiableFunctionExpr(e)
    or
    result = toRawLoadExpr(e)
    or
    result = toRawMetatypeConversionExpr(e)
    or
    result = toRawPointerToPointerExpr(e)
    or
    result = toRawProtocolMetatypeToObjectExpr(e)
    or
    result = toRawStringToPointerExpr(e)
    or
    result = toRawUnderlyingToOpaqueExpr(e)
    or
    result = toRawUnevaluatedInstanceExpr(e)
    or
    result = toRawUnresolvedTypeConversionExpr(e)
  }

  cached
  Raw::Element toRawLiteralExpr(TLiteralExpr e) {
    result = toRawBuiltinLiteralExpr(e)
    or
    result = toRawInterpolatedStringLiteralExpr(e)
    or
    result = toRawNilLiteralExpr(e)
    or
    result = toRawObjectLiteralExpr(e)
    or
    result = toRawRegexLiteralExpr(e)
  }

  cached
  Raw::Element toRawLookupExpr(TLookupExpr e) {
    result = toRawDynamicLookupExpr(e)
    or
    result = toRawMemberRefExpr(e)
    or
    result = toRawSubscriptExpr(e)
  }

  cached
  Raw::Element toRawNumberLiteralExpr(TNumberLiteralExpr e) {
    result = toRawFloatLiteralExpr(e)
    or
    result = toRawIntegerLiteralExpr(e)
  }

  cached
  Raw::Element toRawOverloadSetRefExpr(TOverloadSetRefExpr e) {
    result = toRawOverloadedDeclRefExpr(e)
  }

  cached
  Raw::Element toRawSelfApplyExpr(TSelfApplyExpr e) {
    result = toRawConstructorRefCallExpr(e)
    or
    result = toRawDotSyntaxCallExpr(e)
  }

  cached
  Raw::Element toRawPattern(TPattern e) {
    result = toRawAnyPattern(e)
    or
    result = toRawBindingPattern(e)
    or
    result = toRawBoolPattern(e)
    or
    result = toRawEnumElementPattern(e)
    or
    result = toRawExprPattern(e)
    or
    result = toRawIsPattern(e)
    or
    result = toRawNamedPattern(e)
    or
    result = toRawOptionalSomePattern(e)
    or
    result = toRawParenPattern(e)
    or
    result = toRawTuplePattern(e)
    or
    result = toRawTypedPattern(e)
  }

  cached
  Raw::Element toRawLabeledConditionalStmt(TLabeledConditionalStmt e) {
    result = toRawGuardStmt(e)
    or
    result = toRawIfStmt(e)
    or
    result = toRawWhileStmt(e)
  }

  cached
  Raw::Element toRawLabeledStmt(TLabeledStmt e) {
    result = toRawDoCatchStmt(e)
    or
    result = toRawDoStmt(e)
    or
    result = toRawForEachStmt(e)
    or
    result = toRawLabeledConditionalStmt(e)
    or
    result = toRawRepeatWhileStmt(e)
    or
    result = toRawSwitchStmt(e)
  }

  cached
  Raw::Element toRawStmt(TStmt e) {
    result = toRawBraceStmt(e)
    or
    result = toRawBreakStmt(e)
    or
    result = toRawCaseStmt(e)
    or
    result = toRawContinueStmt(e)
    or
    result = toRawDeferStmt(e)
    or
    result = toRawFailStmt(e)
    or
    result = toRawFallthroughStmt(e)
    or
    result = toRawLabeledStmt(e)
    or
    result = toRawPoundAssertStmt(e)
    or
    result = toRawReturnStmt(e)
    or
    result = toRawThrowStmt(e)
    or
    result = toRawYieldStmt(e)
  }

  cached
  Raw::Element toRawAnyBuiltinIntegerType(TAnyBuiltinIntegerType e) {
    result = toRawBuiltinIntegerLiteralType(e)
    or
    result = toRawBuiltinIntegerType(e)
  }

  cached
  Raw::Element toRawAnyFunctionType(TAnyFunctionType e) {
    result = toRawFunctionType(e)
    or
    result = toRawGenericFunctionType(e)
  }

  cached
  Raw::Element toRawAnyGenericType(TAnyGenericType e) {
    result = toRawNominalOrBoundGenericNominalType(e)
    or
    result = toRawUnboundGenericType(e)
  }

  cached
  Raw::Element toRawAnyMetatypeType(TAnyMetatypeType e) {
    result = toRawExistentialMetatypeType(e)
    or
    result = toRawMetatypeType(e)
  }

  cached
  Raw::Element toRawArchetypeType(TArchetypeType e) {
    result = toRawNestedArchetypeType(e)
    or
    result = toRawOpaqueTypeArchetypeType(e)
    or
    result = toRawOpenedArchetypeType(e)
    or
    result = toRawPrimaryArchetypeType(e)
    or
    result = toRawSequenceArchetypeType(e)
  }

  cached
  Raw::Element toRawBoundGenericType(TBoundGenericType e) {
    result = toRawBoundGenericClassType(e)
    or
    result = toRawBoundGenericEnumType(e)
    or
    result = toRawBoundGenericStructType(e)
  }

  cached
  Raw::Element toRawBuiltinType(TBuiltinType e) {
    result = toRawAnyBuiltinIntegerType(e)
    or
    result = toRawBuiltinBridgeObjectType(e)
    or
    result = toRawBuiltinDefaultActorStorageType(e)
    or
    result = toRawBuiltinExecutorType(e)
    or
    result = toRawBuiltinFloatType(e)
    or
    result = toRawBuiltinJobType(e)
    or
    result = toRawBuiltinNativeObjectType(e)
    or
    result = toRawBuiltinRawPointerType(e)
    or
    result = toRawBuiltinRawUnsafeContinuationType(e)
    or
    result = toRawBuiltinUnsafeValueBufferType(e)
    or
    result = toRawBuiltinVectorType(e)
  }

  cached
  Raw::Element toRawNominalOrBoundGenericNominalType(TNominalOrBoundGenericNominalType e) {
    result = toRawBoundGenericType(e)
    or
    result = toRawNominalType(e)
  }

  cached
  Raw::Element toRawNominalType(TNominalType e) {
    result = toRawClassType(e)
    or
    result = toRawEnumType(e)
    or
    result = toRawProtocolType(e)
    or
    result = toRawStructType(e)
  }

  cached
  Raw::Element toRawReferenceStorageType(TReferenceStorageType e) {
    result = toRawUnmanagedStorageType(e)
    or
    result = toRawUnownedStorageType(e)
    or
    result = toRawWeakStorageType(e)
  }

  cached
  Raw::Element toRawSubstitutableType(TSubstitutableType e) {
    result = toRawArchetypeType(e)
    or
    result = toRawGenericTypeParamType(e)
  }

  cached
  Raw::Element toRawSugarType(TSugarType e) {
    result = toRawParenType(e)
    or
    result = toRawSyntaxSugarType(e)
    or
    result = toRawTypeAliasType(e)
  }

  cached
  Raw::Element toRawSyntaxSugarType(TSyntaxSugarType e) {
    result = toRawDictionaryType(e)
    or
    result = toRawUnarySyntaxSugarType(e)
  }

  cached
  Raw::Element toRawType(TType e) {
    result = toRawAnyFunctionType(e)
    or
    result = toRawAnyGenericType(e)
    or
    result = toRawAnyMetatypeType(e)
    or
    result = toRawBuiltinType(e)
    or
    result = toRawDependentMemberType(e)
    or
    result = toRawDynamicSelfType(e)
    or
    result = toRawErrorType(e)
    or
    result = toRawExistentialType(e)
    or
    result = toRawInOutType(e)
    or
    result = toRawLValueType(e)
    or
    result = toRawModuleType(e)
    or
    result = toRawPlaceholderType(e)
    or
    result = toRawProtocolCompositionType(e)
    or
    result = toRawReferenceStorageType(e)
    or
    result = toRawSilBlockStorageType(e)
    or
    result = toRawSilBoxType(e)
    or
    result = toRawSilFunctionType(e)
    or
    result = toRawSilTokenType(e)
    or
    result = toRawSubstitutableType(e)
    or
    result = toRawSugarType(e)
    or
    result = toRawTupleType(e)
    or
    result = toRawTypeVariableType(e)
    or
    result = toRawUnresolvedType(e)
  }

  cached
  Raw::Element toRawUnarySyntaxSugarType(TUnarySyntaxSugarType e) {
    result = toRawArraySliceType(e)
    or
    result = toRawOptionalType(e)
    or
    result = toRawVariadicSequenceType(e)
  }
}
