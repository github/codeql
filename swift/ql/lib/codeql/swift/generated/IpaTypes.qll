private import codeql.swift.generated.IpaConstructors
private import codeql.swift.generated.Db

cached
module Cached {
  cached
  newtype TElement =
    TArgument(Db::Argument id) or
    TConditionElement(Db::ConditionElement id) or
    TDbFile(Db::DbFile id) or
    TDbLocation(Db::DbLocation id) or
    TDependentMemberType(Db::DependentMemberType id) or
    TDynamicSelfType(Db::DynamicSelfType id) or
    TErrorType(Db::ErrorType id) or
    TExistentialType(Db::ExistentialType id) or
    TIfConfigClause(Db::IfConfigClause id) or
    TInOutType(Db::InOutType id) or
    TLValueType(Db::LValueType id) or
    TModuleType(Db::ModuleType id) or
    TPlaceholderType(Db::PlaceholderType id) or
    TProtocolCompositionType(Db::ProtocolCompositionType id) or
    TSilBlockStorageType(Db::SilBlockStorageType id) or
    TSilBoxType(Db::SilBoxType id) or
    TSilFunctionType(Db::SilFunctionType id) or
    TSilTokenType(Db::SilTokenType id) or
    TTupleType(Db::TupleType id) or
    TTypeVariableType(Db::TypeVariableType id) or
    TUnknownFile() or
    TUnknownLocation() or
    TUnresolvedType(Db::UnresolvedType id) or
    TBuiltinBridgeObjectType(Db::BuiltinBridgeObjectType id) or
    TBuiltinDefaultActorStorageType(Db::BuiltinDefaultActorStorageType id) or
    TBuiltinExecutorType(Db::BuiltinExecutorType id) or
    TBuiltinFloatType(Db::BuiltinFloatType id) or
    TBuiltinJobType(Db::BuiltinJobType id) or
    TBuiltinNativeObjectType(Db::BuiltinNativeObjectType id) or
    TBuiltinRawPointerType(Db::BuiltinRawPointerType id) or
    TBuiltinRawUnsafeContinuationType(Db::BuiltinRawUnsafeContinuationType id) or
    TBuiltinUnsafeValueBufferType(Db::BuiltinUnsafeValueBufferType id) or
    TBuiltinVectorType(Db::BuiltinVectorType id) or
    TCaseLabelItem(Db::CaseLabelItem id) or
    TExistentialMetatypeType(Db::ExistentialMetatypeType id) or
    TFunctionType(Db::FunctionType id) or
    TGenericFunctionType(Db::GenericFunctionType id) or
    TGenericTypeParamType(Db::GenericTypeParamType id) or
    TMetatypeType(Db::MetatypeType id) or
    TParenType(Db::ParenType id) or
    TStmtCondition(Db::StmtCondition id) or
    TTypeAliasType(Db::TypeAliasType id) or
    TTypeRepr(Db::TypeRepr id) or
    TUnboundGenericType(Db::UnboundGenericType id) or
    TUnmanagedStorageType(Db::UnmanagedStorageType id) or
    TUnownedStorageType(Db::UnownedStorageType id) or
    TWeakStorageType(Db::WeakStorageType id) or
    TAnyPattern(Db::AnyPattern id) or
    TAppliedPropertyWrapperExpr(Db::AppliedPropertyWrapperExpr id) or
    TArrowExpr(Db::ArrowExpr id) or
    TAssignExpr(Db::AssignExpr id) or
    TBindOptionalExpr(Db::BindOptionalExpr id) or
    TBindingPattern(Db::BindingPattern id) or
    TBoolPattern(Db::BoolPattern id) or
    TBraceStmt(Db::BraceStmt id) or
    TBreakStmt(Db::BreakStmt id) or
    TBuiltinIntegerLiteralType(Db::BuiltinIntegerLiteralType id) or
    TBuiltinIntegerType(Db::BuiltinIntegerType id) or
    TCaptureListExpr(Db::CaptureListExpr id) or
    TCaseStmt(Db::CaseStmt id) or
    TCodeCompletionExpr(Db::CodeCompletionExpr id) or
    TContinueStmt(Db::ContinueStmt id) or
    TDeclRefExpr(Db::DeclRefExpr id) or
    TDefaultArgumentExpr(Db::DefaultArgumentExpr id) or
    TDeferStmt(Db::DeferStmt id) or
    TDictionaryType(Db::DictionaryType id) or
    TDiscardAssignmentExpr(Db::DiscardAssignmentExpr id) or
    TDotSyntaxBaseIgnoredExpr(Db::DotSyntaxBaseIgnoredExpr id) or
    TDynamicTypeExpr(Db::DynamicTypeExpr id) or
    TEditorPlaceholderExpr(Db::EditorPlaceholderExpr id) or
    TEnumCaseDecl(Db::EnumCaseDecl id) or
    TEnumElementPattern(Db::EnumElementPattern id) or
    TEnumIsCaseExpr(Db::EnumIsCaseExpr id) or
    TErrorExpr(Db::ErrorExpr id) or
    TExprPattern(Db::ExprPattern id) or
    TExtensionDecl(Db::ExtensionDecl id) or
    TFailStmt(Db::FailStmt id) or
    TFallthroughStmt(Db::FallthroughStmt id) or
    TForceValueExpr(Db::ForceValueExpr id) or
    TIfConfigDecl(Db::IfConfigDecl id) or
    TIfExpr(Db::IfExpr id) or
    TImportDecl(Db::ImportDecl id) or
    TInOutExpr(Db::InOutExpr id) or
    TIsPattern(Db::IsPattern id) or
    TKeyPathApplicationExpr(Db::KeyPathApplicationExpr id) or
    TKeyPathDotExpr(Db::KeyPathDotExpr id) or
    TKeyPathExpr(Db::KeyPathExpr id) or
    TLazyInitializerExpr(Db::LazyInitializerExpr id) or
    TMakeTemporarilyEscapableExpr(Db::MakeTemporarilyEscapableExpr id) or
    TMissingMemberDecl(Db::MissingMemberDecl id) or
    TNamedPattern(Db::NamedPattern id) or
    TNestedArchetypeType(Db::NestedArchetypeType id) or
    TObjCSelectorExpr(Db::ObjCSelectorExpr id) or
    TOneWayExpr(Db::OneWayExpr id) or
    TOpaqueTypeArchetypeType(Db::OpaqueTypeArchetypeType id) or
    TOpaqueValueExpr(Db::OpaqueValueExpr id) or
    TOpenExistentialExpr(Db::OpenExistentialExpr id) or
    TOpenedArchetypeType(Db::OpenedArchetypeType id) or
    TOptionalEvaluationExpr(Db::OptionalEvaluationExpr id) or
    TOptionalSomePattern(Db::OptionalSomePattern id) or
    TOtherConstructorDeclRefExpr(Db::OtherConstructorDeclRefExpr id) or
    TParenPattern(Db::ParenPattern id) or
    TPatternBindingDecl(Db::PatternBindingDecl id) or
    TPoundAssertStmt(Db::PoundAssertStmt id) or
    TPoundDiagnosticDecl(Db::PoundDiagnosticDecl id) or
    TPrecedenceGroupDecl(Db::PrecedenceGroupDecl id) or
    TPrimaryArchetypeType(Db::PrimaryArchetypeType id) or
    TPropertyWrapperValuePlaceholderExpr(Db::PropertyWrapperValuePlaceholderExpr id) or
    TRebindSelfInConstructorExpr(Db::RebindSelfInConstructorExpr id) or
    TReturnStmt(Db::ReturnStmt id) or
    TSequenceArchetypeType(Db::SequenceArchetypeType id) or
    TSequenceExpr(Db::SequenceExpr id) or
    TSuperRefExpr(Db::SuperRefExpr id) or
    TTapExpr(Db::TapExpr id) or
    TThrowStmt(Db::ThrowStmt id) or
    TTopLevelCodeDecl(Db::TopLevelCodeDecl id) or
    TTupleElementExpr(Db::TupleElementExpr id) or
    TTupleExpr(Db::TupleExpr id) or
    TTuplePattern(Db::TuplePattern id) or
    TTypeExpr(Db::TypeExpr id) or
    TTypedPattern(Db::TypedPattern id) or
    TUnresolvedDeclRefExpr(Db::UnresolvedDeclRefExpr id) or
    TUnresolvedDotExpr(Db::UnresolvedDotExpr id) or
    TUnresolvedMemberExpr(Db::UnresolvedMemberExpr id) or
    TUnresolvedPatternExpr(Db::UnresolvedPatternExpr id) or
    TUnresolvedSpecializeExpr(Db::UnresolvedSpecializeExpr id) or
    TVarargExpansionExpr(Db::VarargExpansionExpr id) or
    TYieldStmt(Db::YieldStmt id) or
    TAnyHashableErasureExpr(Db::AnyHashableErasureExpr id) or
    TArchetypeToSuperExpr(Db::ArchetypeToSuperExpr id) or
    TArrayExpr(Db::ArrayExpr id) or
    TArraySliceType(Db::ArraySliceType id) or
    TArrayToPointerExpr(Db::ArrayToPointerExpr id) or
    TAutoClosureExpr(Db::AutoClosureExpr id) or
    TAwaitExpr(Db::AwaitExpr id) or
    TBinaryExpr(Db::BinaryExpr id) or
    TBoundGenericClassType(Db::BoundGenericClassType id) or
    TBoundGenericEnumType(Db::BoundGenericEnumType id) or
    TBoundGenericStructType(Db::BoundGenericStructType id) or
    TBridgeFromObjCExpr(Db::BridgeFromObjCExpr id) or
    TBridgeToObjCExpr(Db::BridgeToObjCExpr id) or
    TCallExpr(Db::CallExpr id) or
    TClassMetatypeToObjectExpr(Db::ClassMetatypeToObjectExpr id) or
    TClassType(Db::ClassType id) or
    TClosureExpr(Db::ClosureExpr id) or
    TCoerceExpr(Db::CoerceExpr id) or
    TCollectionUpcastConversionExpr(Db::CollectionUpcastConversionExpr id) or
    TConditionalBridgeFromObjCExpr(Db::ConditionalBridgeFromObjCExpr id) or
    TCovariantFunctionConversionExpr(Db::CovariantFunctionConversionExpr id) or
    TCovariantReturnConversionExpr(Db::CovariantReturnConversionExpr id) or
    TDerivedToBaseExpr(Db::DerivedToBaseExpr id) or
    TDestructureTupleExpr(Db::DestructureTupleExpr id) or
    TDictionaryExpr(Db::DictionaryExpr id) or
    TDifferentiableFunctionExpr(Db::DifferentiableFunctionExpr id) or
    TDifferentiableFunctionExtractOriginalExpr(Db::DifferentiableFunctionExtractOriginalExpr id) or
    TDoCatchStmt(Db::DoCatchStmt id) or
    TDoStmt(Db::DoStmt id) or
    TDotSelfExpr(Db::DotSelfExpr id) or
    TEnumElementDecl(Db::EnumElementDecl id) or
    TEnumType(Db::EnumType id) or
    TErasureExpr(Db::ErasureExpr id) or
    TExistentialMetatypeToObjectExpr(Db::ExistentialMetatypeToObjectExpr id) or
    TForEachStmt(Db::ForEachStmt id) or
    TForceTryExpr(Db::ForceTryExpr id) or
    TForeignObjectConversionExpr(Db::ForeignObjectConversionExpr id) or
    TFunctionConversionExpr(Db::FunctionConversionExpr id) or
    TInOutToPointerExpr(Db::InOutToPointerExpr id) or
    TInfixOperatorDecl(Db::InfixOperatorDecl id) or
    TInjectIntoOptionalExpr(Db::InjectIntoOptionalExpr id) or
    TInterpolatedStringLiteralExpr(Db::InterpolatedStringLiteralExpr id) or
    TLinearFunctionExpr(Db::LinearFunctionExpr id) or
    TLinearFunctionExtractOriginalExpr(Db::LinearFunctionExtractOriginalExpr id) or
    TLinearToDifferentiableFunctionExpr(Db::LinearToDifferentiableFunctionExpr id) or
    TLoadExpr(Db::LoadExpr id) or
    TMemberRefExpr(Db::MemberRefExpr id) or
    TMetatypeConversionExpr(Db::MetatypeConversionExpr id) or
    TNilLiteralExpr(Db::NilLiteralExpr id) or
    TObjectLiteralExpr(Db::ObjectLiteralExpr id) or
    TOptionalTryExpr(Db::OptionalTryExpr id) or
    TOptionalType(Db::OptionalType id) or
    TOverloadedDeclRefExpr(Db::OverloadedDeclRefExpr id) or
    TParenExpr(Db::ParenExpr id) or
    TPointerToPointerExpr(Db::PointerToPointerExpr id) or
    TPostfixOperatorDecl(Db::PostfixOperatorDecl id) or
    TPostfixUnaryExpr(Db::PostfixUnaryExpr id) or
    TPrefixOperatorDecl(Db::PrefixOperatorDecl id) or
    TPrefixUnaryExpr(Db::PrefixUnaryExpr id) or
    TProtocolMetatypeToObjectExpr(Db::ProtocolMetatypeToObjectExpr id) or
    TProtocolType(Db::ProtocolType id) or
    TRegexLiteralExpr(Db::RegexLiteralExpr id) or
    TRepeatWhileStmt(Db::RepeatWhileStmt id) or
    TStringToPointerExpr(Db::StringToPointerExpr id) or
    TStructType(Db::StructType id) or
    TSubscriptExpr(Db::SubscriptExpr id) or
    TSwitchStmt(Db::SwitchStmt id) or
    TTryExpr(Db::TryExpr id) or
    TUnderlyingToOpaqueExpr(Db::UnderlyingToOpaqueExpr id) or
    TUnevaluatedInstanceExpr(Db::UnevaluatedInstanceExpr id) or
    TUnresolvedMemberChainResultExpr(Db::UnresolvedMemberChainResultExpr id) or
    TUnresolvedTypeConversionExpr(Db::UnresolvedTypeConversionExpr id) or
    TVariadicSequenceType(Db::VariadicSequenceType id) or
    TBooleanLiteralExpr(Db::BooleanLiteralExpr id) or
    TConditionalCheckedCastExpr(Db::ConditionalCheckedCastExpr id) or
    TConstructorDecl(Db::ConstructorDecl id) or
    TConstructorRefCallExpr(Db::ConstructorRefCallExpr id) or
    TDestructorDecl(Db::DestructorDecl id) or
    TDotSyntaxCallExpr(Db::DotSyntaxCallExpr id) or
    TDynamicMemberRefExpr(Db::DynamicMemberRefExpr id) or
    TDynamicSubscriptExpr(Db::DynamicSubscriptExpr id) or
    TForcedCheckedCastExpr(Db::ForcedCheckedCastExpr id) or
    TGuardStmt(Db::GuardStmt id) or
    TIfStmt(Db::IfStmt id) or
    TIsExpr(Db::IsExpr id) or
    TMagicIdentifierLiteralExpr(Db::MagicIdentifierLiteralExpr id) or
    TModuleDecl(Db::ModuleDecl id) or
    TStringLiteralExpr(Db::StringLiteralExpr id) or
    TSubscriptDecl(Db::SubscriptDecl id) or
    TWhileStmt(Db::WhileStmt id) or
    TAccessorDecl(Db::AccessorDecl id) or
    TAssociatedTypeDecl(Db::AssociatedTypeDecl id) or
    TConcreteFuncDecl(Db::ConcreteFuncDecl id) or
    TConcreteVarDecl(Db::ConcreteVarDecl id) or
    TFloatLiteralExpr(Db::FloatLiteralExpr id) or
    TGenericTypeParamDecl(Db::GenericTypeParamDecl id) or
    TIntegerLiteralExpr(Db::IntegerLiteralExpr id) or
    TOpaqueTypeDecl(Db::OpaqueTypeDecl id) or
    TParamDecl(Db::ParamDecl id) or
    TTypeAliasDecl(Db::TypeAliasDecl id) or
    TClassDecl(Db::ClassDecl id) or
    TEnumDecl(Db::EnumDecl id) or
    TProtocolDecl(Db::ProtocolDecl id) or
    TStructDecl(Db::StructDecl id)

  class TCallable = TAbstractClosureExpr or TAbstractFunctionDecl;

  class TFile = TDbFile or TUnknownFile;

  class TGenericContext =
    TAbstractFunctionDecl or TExtensionDecl or TGenericTypeDecl or TSubscriptDecl;

  class TIterableDeclContext = TExtensionDecl or TNominalTypeDecl;

  class TLocatable = TArgument or TAstNode or TConditionElement or TIfConfigClause;

  class TLocation = TDbLocation or TUnknownLocation;

  class TType =
    TAnyFunctionType or TAnyGenericType or TAnyMetatypeType or TBuiltinType or
        TDependentMemberType or TDynamicSelfType or TErrorType or TExistentialType or TInOutType or
        TLValueType or TModuleType or TPlaceholderType or TProtocolCompositionType or
        TReferenceStorageType or TSilBlockStorageType or TSilBoxType or TSilFunctionType or
        TSilTokenType or TSubstitutableType or TSugarType or TTupleType or TTypeVariableType or
        TUnresolvedType;

  class TAnyFunctionType = TFunctionType or TGenericFunctionType;

  class TAnyGenericType = TNominalOrBoundGenericNominalType or TUnboundGenericType;

  class TAnyMetatypeType = TExistentialMetatypeType or TMetatypeType;

  class TAstNode =
    TCaseLabelItem or TDecl or TExpr or TPattern or TStmt or TStmtCondition or TTypeRepr;

  class TBuiltinType =
    TAnyBuiltinIntegerType or TBuiltinBridgeObjectType or TBuiltinDefaultActorStorageType or
        TBuiltinExecutorType or TBuiltinFloatType or TBuiltinJobType or TBuiltinNativeObjectType or
        TBuiltinRawPointerType or TBuiltinRawUnsafeContinuationType or
        TBuiltinUnsafeValueBufferType or TBuiltinVectorType;

  class TReferenceStorageType = TUnmanagedStorageType or TUnownedStorageType or TWeakStorageType;

  class TSubstitutableType = TArchetypeType or TGenericTypeParamType;

  class TSugarType = TParenType or TSyntaxSugarType or TTypeAliasType;

  class TAnyBuiltinIntegerType = TBuiltinIntegerLiteralType or TBuiltinIntegerType;

  class TArchetypeType =
    TNestedArchetypeType or TOpaqueTypeArchetypeType or TOpenedArchetypeType or
        TPrimaryArchetypeType or TSequenceArchetypeType;

  class TDecl =
    TEnumCaseDecl or TExtensionDecl or TIfConfigDecl or TImportDecl or TMissingMemberDecl or
        TOperatorDecl or TPatternBindingDecl or TPoundDiagnosticDecl or TPrecedenceGroupDecl or
        TTopLevelCodeDecl or TValueDecl;

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

  class TNominalOrBoundGenericNominalType = TBoundGenericType or TNominalType;

  class TPattern =
    TAnyPattern or TBindingPattern or TBoolPattern or TEnumElementPattern or TExprPattern or
        TIsPattern or TNamedPattern or TOptionalSomePattern or TParenPattern or TTuplePattern or
        TTypedPattern;

  class TStmt =
    TBraceStmt or TBreakStmt or TCaseStmt or TContinueStmt or TDeferStmt or TFailStmt or
        TFallthroughStmt or TLabeledStmt or TPoundAssertStmt or TReturnStmt or TThrowStmt or
        TYieldStmt;

  class TSyntaxSugarType = TDictionaryType or TUnarySyntaxSugarType;

  class TAbstractClosureExpr = TAutoClosureExpr or TClosureExpr;

  class TAnyTryExpr = TForceTryExpr or TOptionalTryExpr or TTryExpr;

  class TApplyExpr =
    TBinaryExpr or TCallExpr or TPostfixUnaryExpr or TPrefixUnaryExpr or TSelfApplyExpr;

  class TBoundGenericType =
    TBoundGenericClassType or TBoundGenericEnumType or TBoundGenericStructType;

  class TCollectionExpr = TArrayExpr or TDictionaryExpr;

  class TExplicitCastExpr = TCheckedCastExpr or TCoerceExpr;

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

  class TLabeledStmt =
    TDoCatchStmt or TDoStmt or TForEachStmt or TLabeledConditionalStmt or TRepeatWhileStmt or
        TSwitchStmt;

  class TLiteralExpr =
    TBuiltinLiteralExpr or TInterpolatedStringLiteralExpr or TNilLiteralExpr or
        TObjectLiteralExpr or TRegexLiteralExpr;

  class TLookupExpr = TDynamicLookupExpr or TMemberRefExpr or TSubscriptExpr;

  class TNominalType = TClassType or TEnumType or TProtocolType or TStructType;

  class TOperatorDecl = TInfixOperatorDecl or TPostfixOperatorDecl or TPrefixOperatorDecl;

  class TOverloadSetRefExpr = TOverloadedDeclRefExpr;

  class TUnarySyntaxSugarType = TArraySliceType or TOptionalType or TVariadicSequenceType;

  class TValueDecl = TAbstractFunctionDecl or TAbstractStorageDecl or TEnumElementDecl or TTypeDecl;

  class TAbstractFunctionDecl = TConstructorDecl or TDestructorDecl or TFuncDecl;

  class TAbstractStorageDecl = TSubscriptDecl or TVarDecl;

  class TBuiltinLiteralExpr =
    TBooleanLiteralExpr or TMagicIdentifierLiteralExpr or TNumberLiteralExpr or TStringLiteralExpr;

  class TCheckedCastExpr = TConditionalCheckedCastExpr or TForcedCheckedCastExpr or TIsExpr;

  class TDynamicLookupExpr = TDynamicMemberRefExpr or TDynamicSubscriptExpr;

  class TLabeledConditionalStmt = TGuardStmt or TIfStmt or TWhileStmt;

  class TSelfApplyExpr = TConstructorRefCallExpr or TDotSyntaxCallExpr;

  class TTypeDecl = TAbstractTypeParamDecl or TGenericTypeDecl or TModuleDecl;

  class TAbstractTypeParamDecl = TAssociatedTypeDecl or TGenericTypeParamDecl;

  class TFuncDecl = TAccessorDecl or TConcreteFuncDecl;

  class TGenericTypeDecl = TNominalTypeDecl or TOpaqueTypeDecl or TTypeAliasDecl;

  class TNumberLiteralExpr = TFloatLiteralExpr or TIntegerLiteralExpr;

  class TVarDecl = TConcreteVarDecl or TParamDecl;

  class TNominalTypeDecl = TClassDecl or TEnumDecl or TProtocolDecl or TStructDecl;

  cached
  TElement fromDbInstance(Db::Element e) {
    none()
    or
    result = TArgument(e)
    or
    result = TConditionElement(e)
    or
    result = TDbFile(e)
    or
    result = TDbLocation(e)
    or
    result = TDependentMemberType(e)
    or
    result = TDynamicSelfType(e)
    or
    result = TErrorType(e)
    or
    result = TExistentialType(e)
    or
    result = TIfConfigClause(e)
    or
    result = TInOutType(e)
    or
    result = TLValueType(e)
    or
    result = TModuleType(e)
    or
    result = TPlaceholderType(e)
    or
    result = TProtocolCompositionType(e)
    or
    result = TSilBlockStorageType(e)
    or
    result = TSilBoxType(e)
    or
    result = TSilFunctionType(e)
    or
    result = TSilTokenType(e)
    or
    result = TTupleType(e)
    or
    result = TTypeVariableType(e)
    or
    result = TUnresolvedType(e)
    or
    result = TBuiltinBridgeObjectType(e)
    or
    result = TBuiltinDefaultActorStorageType(e)
    or
    result = TBuiltinExecutorType(e)
    or
    result = TBuiltinFloatType(e)
    or
    result = TBuiltinJobType(e)
    or
    result = TBuiltinNativeObjectType(e)
    or
    result = TBuiltinRawPointerType(e)
    or
    result = TBuiltinRawUnsafeContinuationType(e)
    or
    result = TBuiltinUnsafeValueBufferType(e)
    or
    result = TBuiltinVectorType(e)
    or
    result = TCaseLabelItem(e)
    or
    result = TExistentialMetatypeType(e)
    or
    result = TFunctionType(e)
    or
    result = TGenericFunctionType(e)
    or
    result = TGenericTypeParamType(e)
    or
    result = TMetatypeType(e)
    or
    result = TParenType(e)
    or
    result = TStmtCondition(e)
    or
    result = TTypeAliasType(e)
    or
    result = TTypeRepr(e)
    or
    result = TUnboundGenericType(e)
    or
    result = TUnmanagedStorageType(e)
    or
    result = TUnownedStorageType(e)
    or
    result = TWeakStorageType(e)
    or
    result = TAnyPattern(e)
    or
    result = TAppliedPropertyWrapperExpr(e)
    or
    result = TArrowExpr(e)
    or
    result = TAssignExpr(e)
    or
    result = TBindOptionalExpr(e)
    or
    result = TBindingPattern(e)
    or
    result = TBoolPattern(e)
    or
    result = TBraceStmt(e)
    or
    result = TBreakStmt(e)
    or
    result = TBuiltinIntegerLiteralType(e)
    or
    result = TBuiltinIntegerType(e)
    or
    result = TCaptureListExpr(e)
    or
    result = TCaseStmt(e)
    or
    result = TCodeCompletionExpr(e)
    or
    result = TContinueStmt(e)
    or
    result = TDeclRefExpr(e)
    or
    result = TDefaultArgumentExpr(e)
    or
    result = TDeferStmt(e)
    or
    result = TDictionaryType(e)
    or
    result = TDiscardAssignmentExpr(e)
    or
    result = TDotSyntaxBaseIgnoredExpr(e)
    or
    result = TDynamicTypeExpr(e)
    or
    result = TEditorPlaceholderExpr(e)
    or
    result = TEnumCaseDecl(e)
    or
    result = TEnumElementPattern(e)
    or
    result = TEnumIsCaseExpr(e)
    or
    result = TErrorExpr(e)
    or
    result = TExprPattern(e)
    or
    result = TExtensionDecl(e)
    or
    result = TFailStmt(e)
    or
    result = TFallthroughStmt(e)
    or
    result = TForceValueExpr(e)
    or
    result = TIfConfigDecl(e)
    or
    result = TIfExpr(e)
    or
    result = TImportDecl(e)
    or
    result = TInOutExpr(e)
    or
    result = TIsPattern(e)
    or
    result = TKeyPathApplicationExpr(e)
    or
    result = TKeyPathDotExpr(e)
    or
    result = TKeyPathExpr(e)
    or
    result = TLazyInitializerExpr(e)
    or
    result = TMakeTemporarilyEscapableExpr(e)
    or
    result = TMissingMemberDecl(e)
    or
    result = TNamedPattern(e)
    or
    result = TNestedArchetypeType(e)
    or
    result = TObjCSelectorExpr(e)
    or
    result = TOneWayExpr(e)
    or
    result = TOpaqueTypeArchetypeType(e)
    or
    result = TOpaqueValueExpr(e)
    or
    result = TOpenExistentialExpr(e)
    or
    result = TOpenedArchetypeType(e)
    or
    result = TOptionalEvaluationExpr(e)
    or
    result = TOptionalSomePattern(e)
    or
    result = TOtherConstructorDeclRefExpr(e)
    or
    result = TParenPattern(e)
    or
    result = TPatternBindingDecl(e)
    or
    result = TPoundAssertStmt(e)
    or
    result = TPoundDiagnosticDecl(e)
    or
    result = TPrecedenceGroupDecl(e)
    or
    result = TPrimaryArchetypeType(e)
    or
    result = TPropertyWrapperValuePlaceholderExpr(e)
    or
    result = TRebindSelfInConstructorExpr(e)
    or
    result = TReturnStmt(e)
    or
    result = TSequenceArchetypeType(e)
    or
    result = TSequenceExpr(e)
    or
    result = TSuperRefExpr(e)
    or
    result = TTapExpr(e)
    or
    result = TThrowStmt(e)
    or
    result = TTopLevelCodeDecl(e)
    or
    result = TTupleElementExpr(e)
    or
    result = TTupleExpr(e)
    or
    result = TTuplePattern(e)
    or
    result = TTypeExpr(e)
    or
    result = TTypedPattern(e)
    or
    result = TUnresolvedDeclRefExpr(e)
    or
    result = TUnresolvedDotExpr(e)
    or
    result = TUnresolvedMemberExpr(e)
    or
    result = TUnresolvedPatternExpr(e)
    or
    result = TUnresolvedSpecializeExpr(e)
    or
    result = TVarargExpansionExpr(e)
    or
    result = TYieldStmt(e)
    or
    result = TAnyHashableErasureExpr(e)
    or
    result = TArchetypeToSuperExpr(e)
    or
    result = TArrayExpr(e)
    or
    result = TArraySliceType(e)
    or
    result = TArrayToPointerExpr(e)
    or
    result = TAutoClosureExpr(e)
    or
    result = TAwaitExpr(e)
    or
    result = TBinaryExpr(e)
    or
    result = TBoundGenericClassType(e)
    or
    result = TBoundGenericEnumType(e)
    or
    result = TBoundGenericStructType(e)
    or
    result = TBridgeFromObjCExpr(e)
    or
    result = TBridgeToObjCExpr(e)
    or
    result = TCallExpr(e)
    or
    result = TClassMetatypeToObjectExpr(e)
    or
    result = TClassType(e)
    or
    result = TClosureExpr(e)
    or
    result = TCoerceExpr(e)
    or
    result = TCollectionUpcastConversionExpr(e)
    or
    result = TConditionalBridgeFromObjCExpr(e)
    or
    result = TCovariantFunctionConversionExpr(e)
    or
    result = TCovariantReturnConversionExpr(e)
    or
    result = TDerivedToBaseExpr(e)
    or
    result = TDestructureTupleExpr(e)
    or
    result = TDictionaryExpr(e)
    or
    result = TDifferentiableFunctionExpr(e)
    or
    result = TDifferentiableFunctionExtractOriginalExpr(e)
    or
    result = TDoCatchStmt(e)
    or
    result = TDoStmt(e)
    or
    result = TDotSelfExpr(e)
    or
    result = TEnumElementDecl(e)
    or
    result = TEnumType(e)
    or
    result = TErasureExpr(e)
    or
    result = TExistentialMetatypeToObjectExpr(e)
    or
    result = TForEachStmt(e)
    or
    result = TForceTryExpr(e)
    or
    result = TForeignObjectConversionExpr(e)
    or
    result = TFunctionConversionExpr(e)
    or
    result = TInOutToPointerExpr(e)
    or
    result = TInfixOperatorDecl(e)
    or
    result = TInjectIntoOptionalExpr(e)
    or
    result = TInterpolatedStringLiteralExpr(e)
    or
    result = TLinearFunctionExpr(e)
    or
    result = TLinearFunctionExtractOriginalExpr(e)
    or
    result = TLinearToDifferentiableFunctionExpr(e)
    or
    result = TLoadExpr(e)
    or
    result = TMemberRefExpr(e)
    or
    result = TMetatypeConversionExpr(e)
    or
    result = TNilLiteralExpr(e)
    or
    result = TObjectLiteralExpr(e)
    or
    result = TOptionalTryExpr(e)
    or
    result = TOptionalType(e)
    or
    result = TOverloadedDeclRefExpr(e)
    or
    result = TParenExpr(e)
    or
    result = TPointerToPointerExpr(e)
    or
    result = TPostfixOperatorDecl(e)
    or
    result = TPostfixUnaryExpr(e)
    or
    result = TPrefixOperatorDecl(e)
    or
    result = TPrefixUnaryExpr(e)
    or
    result = TProtocolMetatypeToObjectExpr(e)
    or
    result = TProtocolType(e)
    or
    result = TRegexLiteralExpr(e)
    or
    result = TRepeatWhileStmt(e)
    or
    result = TStringToPointerExpr(e)
    or
    result = TStructType(e)
    or
    result = TSubscriptExpr(e)
    or
    result = TSwitchStmt(e)
    or
    result = TTryExpr(e)
    or
    result = TUnderlyingToOpaqueExpr(e)
    or
    result = TUnevaluatedInstanceExpr(e)
    or
    result = TUnresolvedMemberChainResultExpr(e)
    or
    result = TUnresolvedTypeConversionExpr(e)
    or
    result = TVariadicSequenceType(e)
    or
    result = TBooleanLiteralExpr(e)
    or
    result = TConditionalCheckedCastExpr(e)
    or
    result = TConstructorDecl(e)
    or
    result = TConstructorRefCallExpr(e)
    or
    result = TDestructorDecl(e)
    or
    result = TDotSyntaxCallExpr(e)
    or
    result = TDynamicMemberRefExpr(e)
    or
    result = TDynamicSubscriptExpr(e)
    or
    result = TForcedCheckedCastExpr(e)
    or
    result = TGuardStmt(e)
    or
    result = TIfStmt(e)
    or
    result = TIsExpr(e)
    or
    result = TMagicIdentifierLiteralExpr(e)
    or
    result = TModuleDecl(e)
    or
    result = TStringLiteralExpr(e)
    or
    result = TSubscriptDecl(e)
    or
    result = TWhileStmt(e)
    or
    result = TAccessorDecl(e)
    or
    result = TAssociatedTypeDecl(e)
    or
    result = TConcreteFuncDecl(e)
    or
    result = TConcreteVarDecl(e)
    or
    result = TFloatLiteralExpr(e)
    or
    result = TGenericTypeParamDecl(e)
    or
    result = TIntegerLiteralExpr(e)
    or
    result = TOpaqueTypeDecl(e)
    or
    result = TParamDecl(e)
    or
    result = TTypeAliasDecl(e)
    or
    result = TClassDecl(e)
    or
    result = TEnumDecl(e)
    or
    result = TProtocolDecl(e)
    or
    result = TStructDecl(e)
  }
}
