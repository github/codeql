private import codeql.swift.generated.IpaConstructors
private import codeql.swift.generated.Db

cached
module Ipa {
  cached
  newtype TElement =
    TDbFile(Db::DbFile id) or
    TDbLocation(Db::DbLocation id) or
    TUnknownFile() or
    TUnknownLocation() or
    TAccessorDecl(Db::AccessorDecl id) or
    TAssociatedTypeDecl(Db::AssociatedTypeDecl id) or
    TClassDecl(Db::ClassDecl id) or
    TConcreteFuncDecl(Db::ConcreteFuncDecl id) or
    TConcreteVarDecl(Db::ConcreteVarDecl id) or
    TConstructorDecl(Db::ConstructorDecl id) or
    TDestructorDecl(Db::DestructorDecl id) or
    TEnumCaseDecl(Db::EnumCaseDecl id) or
    TEnumDecl(Db::EnumDecl id) or
    TEnumElementDecl(Db::EnumElementDecl id) or
    TExtensionDecl(Db::ExtensionDecl id) or
    TGenericTypeParamDecl(Db::GenericTypeParamDecl id) or
    TIfConfigClause(Db::IfConfigClause id) or
    TIfConfigDecl(Db::IfConfigDecl id) or
    TImportDecl(Db::ImportDecl id) or
    TInfixOperatorDecl(Db::InfixOperatorDecl id) or
    TMissingMemberDecl(Db::MissingMemberDecl id) or
    TModuleDecl(Db::ModuleDecl id) or
    TOpaqueTypeDecl(Db::OpaqueTypeDecl id) or
    TParamDecl(Db::ParamDecl id) or
    TPatternBindingDecl(Db::PatternBindingDecl id) or
    TPostfixOperatorDecl(Db::PostfixOperatorDecl id) or
    TPoundDiagnosticDecl(Db::PoundDiagnosticDecl id) or
    TPrecedenceGroupDecl(Db::PrecedenceGroupDecl id) or
    TPrefixOperatorDecl(Db::PrefixOperatorDecl id) or
    TProtocolDecl(Db::ProtocolDecl id) or
    TStructDecl(Db::StructDecl id) or
    TSubscriptDecl(Db::SubscriptDecl id) or
    TTopLevelCodeDecl(Db::TopLevelCodeDecl id) or
    TTypeAliasDecl(Db::TypeAliasDecl id) or
    TAnyHashableErasureExpr(Db::AnyHashableErasureExpr id) or
    TAppliedPropertyWrapperExpr(Db::AppliedPropertyWrapperExpr id) or
    TArchetypeToSuperExpr(Db::ArchetypeToSuperExpr id) or
    TArgument(Db::Argument id) or
    TArrayExpr(Db::ArrayExpr id) or
    TArrayToPointerExpr(Db::ArrayToPointerExpr id) or
    TArrowExpr(Db::ArrowExpr id) or
    TAssignExpr(Db::AssignExpr id) or
    TAutoClosureExpr(Db::AutoClosureExpr id) or
    TAwaitExpr(Db::AwaitExpr id) or
    TBinaryExpr(Db::BinaryExpr id) or
    TBindOptionalExpr(Db::BindOptionalExpr id) or
    TBooleanLiteralExpr(Db::BooleanLiteralExpr id) or
    TBridgeFromObjCExpr(Db::BridgeFromObjCExpr id) or
    TBridgeToObjCExpr(Db::BridgeToObjCExpr id) or
    TCallExpr(Db::CallExpr id) or
    TCaptureListExpr(Db::CaptureListExpr id) or
    TClassMetatypeToObjectExpr(Db::ClassMetatypeToObjectExpr id) or
    TClosureExpr(Db::ClosureExpr id) or
    TCodeCompletionExpr(Db::CodeCompletionExpr id) or
    TCoerceExpr(Db::CoerceExpr id) or
    TCollectionUpcastConversionExpr(Db::CollectionUpcastConversionExpr id) or
    TConditionalBridgeFromObjCExpr(Db::ConditionalBridgeFromObjCExpr id) or
    TConditionalCheckedCastExpr(Db::ConditionalCheckedCastExpr id) or
    TConstructorRefCallExpr(Db::ConstructorRefCallExpr id) or
    TCovariantFunctionConversionExpr(Db::CovariantFunctionConversionExpr id) or
    TCovariantReturnConversionExpr(Db::CovariantReturnConversionExpr id) or
    TDeclRefExpr(Db::DeclRefExpr id) or
    TDefaultArgumentExpr(Db::DefaultArgumentExpr id) or
    TDerivedToBaseExpr(Db::DerivedToBaseExpr id) or
    TDestructureTupleExpr(Db::DestructureTupleExpr id) or
    TDictionaryExpr(Db::DictionaryExpr id) or
    TDifferentiableFunctionExpr(Db::DifferentiableFunctionExpr id) or
    TDifferentiableFunctionExtractOriginalExpr(Db::DifferentiableFunctionExtractOriginalExpr id) or
    TDiscardAssignmentExpr(Db::DiscardAssignmentExpr id) or
    TDotSelfExpr(Db::DotSelfExpr id) or
    TDotSyntaxBaseIgnoredExpr(Db::DotSyntaxBaseIgnoredExpr id) or
    TDotSyntaxCallExpr(Db::DotSyntaxCallExpr id) or
    TDynamicMemberRefExpr(Db::DynamicMemberRefExpr id) or
    TDynamicSubscriptExpr(Db::DynamicSubscriptExpr id) or
    TDynamicTypeExpr(Db::DynamicTypeExpr id) or
    TEditorPlaceholderExpr(Db::EditorPlaceholderExpr id) or
    TEnumIsCaseExpr(Db::EnumIsCaseExpr id) or
    TErasureExpr(Db::ErasureExpr id) or
    TErrorExpr(Db::ErrorExpr id) or
    TExistentialMetatypeToObjectExpr(Db::ExistentialMetatypeToObjectExpr id) or
    TFloatLiteralExpr(Db::FloatLiteralExpr id) or
    TForceTryExpr(Db::ForceTryExpr id) or
    TForceValueExpr(Db::ForceValueExpr id) or
    TForcedCheckedCastExpr(Db::ForcedCheckedCastExpr id) or
    TForeignObjectConversionExpr(Db::ForeignObjectConversionExpr id) or
    TFunctionConversionExpr(Db::FunctionConversionExpr id) or
    TIfExpr(Db::IfExpr id) or
    TInOutExpr(Db::InOutExpr id) or
    TInOutToPointerExpr(Db::InOutToPointerExpr id) or
    TInjectIntoOptionalExpr(Db::InjectIntoOptionalExpr id) or
    TIntegerLiteralExpr(Db::IntegerLiteralExpr id) or
    TInterpolatedStringLiteralExpr(Db::InterpolatedStringLiteralExpr id) or
    TIsExpr(Db::IsExpr id) or
    TKeyPathApplicationExpr(Db::KeyPathApplicationExpr id) or
    TKeyPathDotExpr(Db::KeyPathDotExpr id) or
    TKeyPathExpr(Db::KeyPathExpr id) or
    TLazyInitializerExpr(Db::LazyInitializerExpr id) or
    TLinearFunctionExpr(Db::LinearFunctionExpr id) or
    TLinearFunctionExtractOriginalExpr(Db::LinearFunctionExtractOriginalExpr id) or
    TLinearToDifferentiableFunctionExpr(Db::LinearToDifferentiableFunctionExpr id) or
    TLoadExpr(Db::LoadExpr id) or
    TMagicIdentifierLiteralExpr(Db::MagicIdentifierLiteralExpr id) or
    TMakeTemporarilyEscapableExpr(Db::MakeTemporarilyEscapableExpr id) or
    TMemberRefExpr(Db::MemberRefExpr id) or
    TMetatypeConversionExpr(Db::MetatypeConversionExpr id) or
    TNilLiteralExpr(Db::NilLiteralExpr id) or
    TObjCSelectorExpr(Db::ObjCSelectorExpr id) or
    TObjectLiteralExpr(Db::ObjectLiteralExpr id) or
    TOneWayExpr(Db::OneWayExpr id) or
    TOpaqueValueExpr(Db::OpaqueValueExpr id) or
    TOpenExistentialExpr(Db::OpenExistentialExpr id) or
    TOptionalEvaluationExpr(Db::OptionalEvaluationExpr id) or
    TOptionalTryExpr(Db::OptionalTryExpr id) or
    TOtherConstructorDeclRefExpr(Db::OtherConstructorDeclRefExpr id) or
    TOverloadedDeclRefExpr(Db::OverloadedDeclRefExpr id) or
    TParenExpr(Db::ParenExpr id) or
    TPointerToPointerExpr(Db::PointerToPointerExpr id) or
    TPostfixUnaryExpr(Db::PostfixUnaryExpr id) or
    TPrefixUnaryExpr(Db::PrefixUnaryExpr id) or
    TPropertyWrapperValuePlaceholderExpr(Db::PropertyWrapperValuePlaceholderExpr id) or
    TProtocolMetatypeToObjectExpr(Db::ProtocolMetatypeToObjectExpr id) or
    TRebindSelfInConstructorExpr(Db::RebindSelfInConstructorExpr id) or
    TRegexLiteralExpr(Db::RegexLiteralExpr id) or
    TSequenceExpr(Db::SequenceExpr id) or
    TStringLiteralExpr(Db::StringLiteralExpr id) or
    TStringToPointerExpr(Db::StringToPointerExpr id) or
    TSubscriptExpr(Db::SubscriptExpr id) or
    TSuperRefExpr(Db::SuperRefExpr id) or
    TTapExpr(Db::TapExpr id) or
    TTryExpr(Db::TryExpr id) or
    TTupleElementExpr(Db::TupleElementExpr id) or
    TTupleExpr(Db::TupleExpr id) or
    TTypeExpr(Db::TypeExpr id) or
    TUnderlyingToOpaqueExpr(Db::UnderlyingToOpaqueExpr id) or
    TUnevaluatedInstanceExpr(Db::UnevaluatedInstanceExpr id) or
    TUnresolvedDeclRefExpr(Db::UnresolvedDeclRefExpr id) or
    TUnresolvedDotExpr(Db::UnresolvedDotExpr id) or
    TUnresolvedMemberChainResultExpr(Db::UnresolvedMemberChainResultExpr id) or
    TUnresolvedMemberExpr(Db::UnresolvedMemberExpr id) or
    TUnresolvedPatternExpr(Db::UnresolvedPatternExpr id) or
    TUnresolvedSpecializeExpr(Db::UnresolvedSpecializeExpr id) or
    TUnresolvedTypeConversionExpr(Db::UnresolvedTypeConversionExpr id) or
    TVarargExpansionExpr(Db::VarargExpansionExpr id) or
    TAnyPattern(Db::AnyPattern id) or
    TBindingPattern(Db::BindingPattern id) or
    TBoolPattern(Db::BoolPattern id) or
    TEnumElementPattern(Db::EnumElementPattern id) or
    TExprPattern(Db::ExprPattern id) or
    TIsPattern(Db::IsPattern id) or
    TNamedPattern(Db::NamedPattern id) or
    TOptionalSomePattern(Db::OptionalSomePattern id) or
    TParenPattern(Db::ParenPattern id) or
    TTuplePattern(Db::TuplePattern id) or
    TTypedPattern(Db::TypedPattern id) or
    TBraceStmt(Db::BraceStmt id) or
    TBreakStmt(Db::BreakStmt id) or
    TCaseLabelItem(Db::CaseLabelItem id) or
    TCaseStmt(Db::CaseStmt id) or
    TConditionElement(Db::ConditionElement id) or
    TContinueStmt(Db::ContinueStmt id) or
    TDeferStmt(Db::DeferStmt id) or
    TDoCatchStmt(Db::DoCatchStmt id) or
    TDoStmt(Db::DoStmt id) or
    TFailStmt(Db::FailStmt id) or
    TFallthroughStmt(Db::FallthroughStmt id) or
    TForEachStmt(Db::ForEachStmt id) or
    TGuardStmt(Db::GuardStmt id) or
    TIfStmt(Db::IfStmt id) or
    TPoundAssertStmt(Db::PoundAssertStmt id) or
    TRepeatWhileStmt(Db::RepeatWhileStmt id) or
    TReturnStmt(Db::ReturnStmt id) or
    TStmtCondition(Db::StmtCondition id) or
    TSwitchStmt(Db::SwitchStmt id) or
    TThrowStmt(Db::ThrowStmt id) or
    TWhileStmt(Db::WhileStmt id) or
    TYieldStmt(Db::YieldStmt id) or
    TArraySliceType(Db::ArraySliceType id) or
    TBoundGenericClassType(Db::BoundGenericClassType id) or
    TBoundGenericEnumType(Db::BoundGenericEnumType id) or
    TBoundGenericStructType(Db::BoundGenericStructType id) or
    TBuiltinBridgeObjectType(Db::BuiltinBridgeObjectType id) or
    TBuiltinDefaultActorStorageType(Db::BuiltinDefaultActorStorageType id) or
    TBuiltinExecutorType(Db::BuiltinExecutorType id) or
    TBuiltinFloatType(Db::BuiltinFloatType id) or
    TBuiltinIntegerLiteralType(Db::BuiltinIntegerLiteralType id) or
    TBuiltinIntegerType(Db::BuiltinIntegerType id) or
    TBuiltinJobType(Db::BuiltinJobType id) or
    TBuiltinNativeObjectType(Db::BuiltinNativeObjectType id) or
    TBuiltinRawPointerType(Db::BuiltinRawPointerType id) or
    TBuiltinRawUnsafeContinuationType(Db::BuiltinRawUnsafeContinuationType id) or
    TBuiltinUnsafeValueBufferType(Db::BuiltinUnsafeValueBufferType id) or
    TBuiltinVectorType(Db::BuiltinVectorType id) or
    TClassType(Db::ClassType id) or
    TDependentMemberType(Db::DependentMemberType id) or
    TDictionaryType(Db::DictionaryType id) or
    TDynamicSelfType(Db::DynamicSelfType id) or
    TEnumType(Db::EnumType id) or
    TErrorType(Db::ErrorType id) or
    TExistentialMetatypeType(Db::ExistentialMetatypeType id) or
    TExistentialType(Db::ExistentialType id) or
    TFunctionType(Db::FunctionType id) or
    TGenericFunctionType(Db::GenericFunctionType id) or
    TGenericTypeParamType(Db::GenericTypeParamType id) or
    TInOutType(Db::InOutType id) or
    TLValueType(Db::LValueType id) or
    TMetatypeType(Db::MetatypeType id) or
    TModuleType(Db::ModuleType id) or
    TNestedArchetypeType(Db::NestedArchetypeType id) or
    TOpaqueTypeArchetypeType(Db::OpaqueTypeArchetypeType id) or
    TOpenedArchetypeType(Db::OpenedArchetypeType id) or
    TOptionalType(Db::OptionalType id) or
    TParenType(Db::ParenType id) or
    TPlaceholderType(Db::PlaceholderType id) or
    TPrimaryArchetypeType(Db::PrimaryArchetypeType id) or
    TProtocolCompositionType(Db::ProtocolCompositionType id) or
    TProtocolType(Db::ProtocolType id) or
    TSequenceArchetypeType(Db::SequenceArchetypeType id) or
    TSilBlockStorageType(Db::SilBlockStorageType id) or
    TSilBoxType(Db::SilBoxType id) or
    TSilFunctionType(Db::SilFunctionType id) or
    TSilTokenType(Db::SilTokenType id) or
    TStructType(Db::StructType id) or
    TTupleType(Db::TupleType id) or
    TTypeAliasType(Db::TypeAliasType id) or
    TTypeRepr(Db::TypeRepr id) or
    TTypeVariableType(Db::TypeVariableType id) or
    TUnboundGenericType(Db::UnboundGenericType id) or
    TUnmanagedStorageType(Db::UnmanagedStorageType id) or
    TUnownedStorageType(Db::UnownedStorageType id) or
    TUnresolvedType(Db::UnresolvedType id) or
    TVariadicSequenceType(Db::VariadicSequenceType id) or
    TWeakStorageType(Db::WeakStorageType id)

  class TAstNode =
    TCaseLabelItem or TDecl or TExpr or TPattern or TStmt or TStmtCondition or TTypeRepr;

  class TCallable = TAbstractClosureExpr or TAbstractFunctionDecl;

  class TFile = TDbFile or TUnknownFile;

  class TLocatable = TArgument or TAstNode or TConditionElement or TIfConfigClause;

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
  TElement fromDbInstance(Db::Element e) {
    none()
    or
    result = TDbFile(e)
    or
    result = TDbLocation(e)
    or
    result = TAccessorDecl(e)
    or
    result = TAssociatedTypeDecl(e)
    or
    result = TClassDecl(e)
    or
    result = TConcreteFuncDecl(e)
    or
    result = TConcreteVarDecl(e)
    or
    result = TConstructorDecl(e)
    or
    result = TDestructorDecl(e)
    or
    result = TEnumCaseDecl(e)
    or
    result = TEnumDecl(e)
    or
    result = TEnumElementDecl(e)
    or
    result = TExtensionDecl(e)
    or
    result = TGenericTypeParamDecl(e)
    or
    result = TIfConfigClause(e)
    or
    result = TIfConfigDecl(e)
    or
    result = TImportDecl(e)
    or
    result = TInfixOperatorDecl(e)
    or
    result = TMissingMemberDecl(e)
    or
    result = TModuleDecl(e)
    or
    result = TOpaqueTypeDecl(e)
    or
    result = TParamDecl(e)
    or
    result = TPatternBindingDecl(e)
    or
    result = TPostfixOperatorDecl(e)
    or
    result = TPoundDiagnosticDecl(e)
    or
    result = TPrecedenceGroupDecl(e)
    or
    result = TPrefixOperatorDecl(e)
    or
    result = TProtocolDecl(e)
    or
    result = TStructDecl(e)
    or
    result = TSubscriptDecl(e)
    or
    result = TTopLevelCodeDecl(e)
    or
    result = TTypeAliasDecl(e)
    or
    result = TAnyHashableErasureExpr(e)
    or
    result = TAppliedPropertyWrapperExpr(e)
    or
    result = TArchetypeToSuperExpr(e)
    or
    result = TArgument(e)
    or
    result = TArrayExpr(e)
    or
    result = TArrayToPointerExpr(e)
    or
    result = TArrowExpr(e)
    or
    result = TAssignExpr(e)
    or
    result = TAutoClosureExpr(e)
    or
    result = TAwaitExpr(e)
    or
    result = TBinaryExpr(e)
    or
    result = TBindOptionalExpr(e)
    or
    result = TBooleanLiteralExpr(e)
    or
    result = TBridgeFromObjCExpr(e)
    or
    result = TBridgeToObjCExpr(e)
    or
    result = TCallExpr(e)
    or
    result = TCaptureListExpr(e)
    or
    result = TClassMetatypeToObjectExpr(e)
    or
    result = TClosureExpr(e)
    or
    result = TCodeCompletionExpr(e)
    or
    result = TCoerceExpr(e)
    or
    result = TCollectionUpcastConversionExpr(e)
    or
    result = TConditionalBridgeFromObjCExpr(e)
    or
    result = TConditionalCheckedCastExpr(e)
    or
    result = TConstructorRefCallExpr(e)
    or
    result = TCovariantFunctionConversionExpr(e)
    or
    result = TCovariantReturnConversionExpr(e)
    or
    result = TDeclRefExpr(e)
    or
    result = TDefaultArgumentExpr(e)
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
    result = TDiscardAssignmentExpr(e)
    or
    result = TDotSelfExpr(e)
    or
    result = TDotSyntaxBaseIgnoredExpr(e)
    or
    result = TDotSyntaxCallExpr(e)
    or
    result = TDynamicMemberRefExpr(e)
    or
    result = TDynamicSubscriptExpr(e)
    or
    result = TDynamicTypeExpr(e)
    or
    result = TEditorPlaceholderExpr(e)
    or
    result = TEnumIsCaseExpr(e)
    or
    result = TErasureExpr(e)
    or
    result = TErrorExpr(e)
    or
    result = TExistentialMetatypeToObjectExpr(e)
    or
    result = TFloatLiteralExpr(e)
    or
    result = TForceTryExpr(e)
    or
    result = TForceValueExpr(e)
    or
    result = TForcedCheckedCastExpr(e)
    or
    result = TForeignObjectConversionExpr(e)
    or
    result = TFunctionConversionExpr(e)
    or
    result = TIfExpr(e)
    or
    result = TInOutExpr(e)
    or
    result = TInOutToPointerExpr(e)
    or
    result = TInjectIntoOptionalExpr(e)
    or
    result = TIntegerLiteralExpr(e)
    or
    result = TInterpolatedStringLiteralExpr(e)
    or
    result = TIsExpr(e)
    or
    result = TKeyPathApplicationExpr(e)
    or
    result = TKeyPathDotExpr(e)
    or
    result = TKeyPathExpr(e)
    or
    result = TLazyInitializerExpr(e)
    or
    result = TLinearFunctionExpr(e)
    or
    result = TLinearFunctionExtractOriginalExpr(e)
    or
    result = TLinearToDifferentiableFunctionExpr(e)
    or
    result = TLoadExpr(e)
    or
    result = TMagicIdentifierLiteralExpr(e)
    or
    result = TMakeTemporarilyEscapableExpr(e)
    or
    result = TMemberRefExpr(e)
    or
    result = TMetatypeConversionExpr(e)
    or
    result = TNilLiteralExpr(e)
    or
    result = TObjCSelectorExpr(e)
    or
    result = TObjectLiteralExpr(e)
    or
    result = TOneWayExpr(e)
    or
    result = TOpaqueValueExpr(e)
    or
    result = TOpenExistentialExpr(e)
    or
    result = TOptionalEvaluationExpr(e)
    or
    result = TOptionalTryExpr(e)
    or
    result = TOtherConstructorDeclRefExpr(e)
    or
    result = TOverloadedDeclRefExpr(e)
    or
    result = TParenExpr(e)
    or
    result = TPointerToPointerExpr(e)
    or
    result = TPostfixUnaryExpr(e)
    or
    result = TPrefixUnaryExpr(e)
    or
    result = TPropertyWrapperValuePlaceholderExpr(e)
    or
    result = TProtocolMetatypeToObjectExpr(e)
    or
    result = TRebindSelfInConstructorExpr(e)
    or
    result = TRegexLiteralExpr(e)
    or
    result = TSequenceExpr(e)
    or
    result = TStringLiteralExpr(e)
    or
    result = TStringToPointerExpr(e)
    or
    result = TSubscriptExpr(e)
    or
    result = TSuperRefExpr(e)
    or
    result = TTapExpr(e)
    or
    result = TTryExpr(e)
    or
    result = TTupleElementExpr(e)
    or
    result = TTupleExpr(e)
    or
    result = TTypeExpr(e)
    or
    result = TUnderlyingToOpaqueExpr(e)
    or
    result = TUnevaluatedInstanceExpr(e)
    or
    result = TUnresolvedDeclRefExpr(e)
    or
    result = TUnresolvedDotExpr(e)
    or
    result = TUnresolvedMemberChainResultExpr(e)
    or
    result = TUnresolvedMemberExpr(e)
    or
    result = TUnresolvedPatternExpr(e)
    or
    result = TUnresolvedSpecializeExpr(e)
    or
    result = TUnresolvedTypeConversionExpr(e)
    or
    result = TVarargExpansionExpr(e)
    or
    result = TAnyPattern(e)
    or
    result = TBindingPattern(e)
    or
    result = TBoolPattern(e)
    or
    result = TEnumElementPattern(e)
    or
    result = TExprPattern(e)
    or
    result = TIsPattern(e)
    or
    result = TNamedPattern(e)
    or
    result = TOptionalSomePattern(e)
    or
    result = TParenPattern(e)
    or
    result = TTuplePattern(e)
    or
    result = TTypedPattern(e)
    or
    result = TBraceStmt(e)
    or
    result = TBreakStmt(e)
    or
    result = TCaseLabelItem(e)
    or
    result = TCaseStmt(e)
    or
    result = TConditionElement(e)
    or
    result = TContinueStmt(e)
    or
    result = TDeferStmt(e)
    or
    result = TDoCatchStmt(e)
    or
    result = TDoStmt(e)
    or
    result = TFailStmt(e)
    or
    result = TFallthroughStmt(e)
    or
    result = TForEachStmt(e)
    or
    result = TGuardStmt(e)
    or
    result = TIfStmt(e)
    or
    result = TPoundAssertStmt(e)
    or
    result = TRepeatWhileStmt(e)
    or
    result = TReturnStmt(e)
    or
    result = TStmtCondition(e)
    or
    result = TSwitchStmt(e)
    or
    result = TThrowStmt(e)
    or
    result = TWhileStmt(e)
    or
    result = TYieldStmt(e)
    or
    result = TArraySliceType(e)
    or
    result = TBoundGenericClassType(e)
    or
    result = TBoundGenericEnumType(e)
    or
    result = TBoundGenericStructType(e)
    or
    result = TBuiltinBridgeObjectType(e)
    or
    result = TBuiltinDefaultActorStorageType(e)
    or
    result = TBuiltinExecutorType(e)
    or
    result = TBuiltinFloatType(e)
    or
    result = TBuiltinIntegerLiteralType(e)
    or
    result = TBuiltinIntegerType(e)
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
    result = TClassType(e)
    or
    result = TDependentMemberType(e)
    or
    result = TDictionaryType(e)
    or
    result = TDynamicSelfType(e)
    or
    result = TEnumType(e)
    or
    result = TErrorType(e)
    or
    result = TExistentialMetatypeType(e)
    or
    result = TExistentialType(e)
    or
    result = TFunctionType(e)
    or
    result = TGenericFunctionType(e)
    or
    result = TGenericTypeParamType(e)
    or
    result = TInOutType(e)
    or
    result = TLValueType(e)
    or
    result = TMetatypeType(e)
    or
    result = TModuleType(e)
    or
    result = TNestedArchetypeType(e)
    or
    result = TOpaqueTypeArchetypeType(e)
    or
    result = TOpenedArchetypeType(e)
    or
    result = TOptionalType(e)
    or
    result = TParenType(e)
    or
    result = TPlaceholderType(e)
    or
    result = TPrimaryArchetypeType(e)
    or
    result = TProtocolCompositionType(e)
    or
    result = TProtocolType(e)
    or
    result = TSequenceArchetypeType(e)
    or
    result = TSilBlockStorageType(e)
    or
    result = TSilBoxType(e)
    or
    result = TSilFunctionType(e)
    or
    result = TSilTokenType(e)
    or
    result = TStructType(e)
    or
    result = TTupleType(e)
    or
    result = TTypeAliasType(e)
    or
    result = TTypeRepr(e)
    or
    result = TTypeVariableType(e)
    or
    result = TUnboundGenericType(e)
    or
    result = TUnmanagedStorageType(e)
    or
    result = TUnownedStorageType(e)
    or
    result = TUnresolvedType(e)
    or
    result = TVariadicSequenceType(e)
    or
    result = TWeakStorageType(e)
  }

  cached
  Db::Element toDbInstance(TElement e) { e = fromDbInstance(result) }
}
