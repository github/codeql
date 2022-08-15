private import codeql.swift.generated.SynthConstructors
private import codeql.swift.generated.Raw

cached
module Synth {
  cached
  newtype TElement =
    TComment(Raw::Comment id) or
    TDbFile(Raw::DbFile id) or
    TDbLocation(Raw::DbLocation id) or
    TUnknownFile() or
    TUnknownLocation() or
    TAccessorDecl(Raw::AccessorDecl id) or
    TAssociatedTypeDecl(Raw::AssociatedTypeDecl id) or
    TClassDecl(Raw::ClassDecl id) or
    TConcreteFuncDecl(Raw::ConcreteFuncDecl id) or
    TConcreteVarDecl(Raw::ConcreteVarDecl id) or
    TConstructorDecl(Raw::ConstructorDecl id) or
    TDestructorDecl(Raw::DestructorDecl id) or
    TEnumCaseDecl(Raw::EnumCaseDecl id) or
    TEnumDecl(Raw::EnumDecl id) or
    TEnumElementDecl(Raw::EnumElementDecl id) or
    TExtensionDecl(Raw::ExtensionDecl id) or
    TGenericTypeParamDecl(Raw::GenericTypeParamDecl id) or
    TIfConfigClause(Raw::IfConfigClause id) or
    TIfConfigDecl(Raw::IfConfigDecl id) or
    TImportDecl(Raw::ImportDecl id) or
    TInfixOperatorDecl(Raw::InfixOperatorDecl id) or
    TMissingMemberDecl(Raw::MissingMemberDecl id) or
    TModuleDecl(Raw::ModuleDecl id) or
    TOpaqueTypeDecl(Raw::OpaqueTypeDecl id) or
    TParamDecl(Raw::ParamDecl id) or
    TPatternBindingDecl(Raw::PatternBindingDecl id) or
    TPostfixOperatorDecl(Raw::PostfixOperatorDecl id) or
    TPoundDiagnosticDecl(Raw::PoundDiagnosticDecl id) or
    TPrecedenceGroupDecl(Raw::PrecedenceGroupDecl id) or
    TPrefixOperatorDecl(Raw::PrefixOperatorDecl id) or
    TProtocolDecl(Raw::ProtocolDecl id) or
    TStructDecl(Raw::StructDecl id) or
    TSubscriptDecl(Raw::SubscriptDecl id) or
    TTopLevelCodeDecl(Raw::TopLevelCodeDecl id) or
    TTypeAliasDecl(Raw::TypeAliasDecl id) or
    TAnyHashableErasureExpr(Raw::AnyHashableErasureExpr id) or
    TAppliedPropertyWrapperExpr(Raw::AppliedPropertyWrapperExpr id) or
    TArchetypeToSuperExpr(Raw::ArchetypeToSuperExpr id) or
    TArgument(Raw::Argument id) or
    TArrayExpr(Raw::ArrayExpr id) or
    TArrayToPointerExpr(Raw::ArrayToPointerExpr id) or
    TArrowExpr(Raw::ArrowExpr id) or
    TAssignExpr(Raw::AssignExpr id) or
    TAutoClosureExpr(Raw::AutoClosureExpr id) or
    TAwaitExpr(Raw::AwaitExpr id) or
    TBinaryExpr(Raw::BinaryExpr id) or
    TBindOptionalExpr(Raw::BindOptionalExpr id) or
    TBooleanLiteralExpr(Raw::BooleanLiteralExpr id) or
    TBridgeFromObjCExpr(Raw::BridgeFromObjCExpr id) or
    TBridgeToObjCExpr(Raw::BridgeToObjCExpr id) or
    TCallExpr(Raw::CallExpr id) or
    TCaptureListExpr(Raw::CaptureListExpr id) or
    TClassMetatypeToObjectExpr(Raw::ClassMetatypeToObjectExpr id) or
    TClosureExpr(Raw::ClosureExpr id) or
    TCodeCompletionExpr(Raw::CodeCompletionExpr id) or
    TCoerceExpr(Raw::CoerceExpr id) or
    TCollectionUpcastConversionExpr(Raw::CollectionUpcastConversionExpr id) or
    TConditionalBridgeFromObjCExpr(Raw::ConditionalBridgeFromObjCExpr id) or
    TConditionalCheckedCastExpr(Raw::ConditionalCheckedCastExpr id) or
    TConstructorRefCallExpr(Raw::ConstructorRefCallExpr id) or
    TCovariantFunctionConversionExpr(Raw::CovariantFunctionConversionExpr id) or
    TCovariantReturnConversionExpr(Raw::CovariantReturnConversionExpr id) or
    TDeclRefExpr(Raw::DeclRefExpr id) or
    TDefaultArgumentExpr(Raw::DefaultArgumentExpr id) or
    TDerivedToBaseExpr(Raw::DerivedToBaseExpr id) or
    TDestructureTupleExpr(Raw::DestructureTupleExpr id) or
    TDictionaryExpr(Raw::DictionaryExpr id) or
    TDifferentiableFunctionExpr(Raw::DifferentiableFunctionExpr id) or
    TDifferentiableFunctionExtractOriginalExpr(Raw::DifferentiableFunctionExtractOriginalExpr id) or
    TDiscardAssignmentExpr(Raw::DiscardAssignmentExpr id) or
    TDotSelfExpr(Raw::DotSelfExpr id) or
    TDotSyntaxBaseIgnoredExpr(Raw::DotSyntaxBaseIgnoredExpr id) or
    TDotSyntaxCallExpr(Raw::DotSyntaxCallExpr id) or
    TDynamicMemberRefExpr(Raw::DynamicMemberRefExpr id) or
    TDynamicSubscriptExpr(Raw::DynamicSubscriptExpr id) or
    TDynamicTypeExpr(Raw::DynamicTypeExpr id) or
    TEditorPlaceholderExpr(Raw::EditorPlaceholderExpr id) or
    TEnumIsCaseExpr(Raw::EnumIsCaseExpr id) or
    TErasureExpr(Raw::ErasureExpr id) or
    TErrorExpr(Raw::ErrorExpr id) or
    TExistentialMetatypeToObjectExpr(Raw::ExistentialMetatypeToObjectExpr id) or
    TFloatLiteralExpr(Raw::FloatLiteralExpr id) or
    TForceTryExpr(Raw::ForceTryExpr id) or
    TForceValueExpr(Raw::ForceValueExpr id) or
    TForcedCheckedCastExpr(Raw::ForcedCheckedCastExpr id) or
    TForeignObjectConversionExpr(Raw::ForeignObjectConversionExpr id) or
    TFunctionConversionExpr(Raw::FunctionConversionExpr id) or
    TIfExpr(Raw::IfExpr id) or
    TInOutExpr(Raw::InOutExpr id) or
    TInOutToPointerExpr(Raw::InOutToPointerExpr id) or
    TInjectIntoOptionalExpr(Raw::InjectIntoOptionalExpr id) or
    TIntegerLiteralExpr(Raw::IntegerLiteralExpr id) or
    TInterpolatedStringLiteralExpr(Raw::InterpolatedStringLiteralExpr id) or
    TIsExpr(Raw::IsExpr id) or
    TKeyPathApplicationExpr(Raw::KeyPathApplicationExpr id) or
    TKeyPathDotExpr(Raw::KeyPathDotExpr id) or
    TKeyPathExpr(Raw::KeyPathExpr id) or
    TLazyInitializerExpr(Raw::LazyInitializerExpr id) or
    TLinearFunctionExpr(Raw::LinearFunctionExpr id) or
    TLinearFunctionExtractOriginalExpr(Raw::LinearFunctionExtractOriginalExpr id) or
    TLinearToDifferentiableFunctionExpr(Raw::LinearToDifferentiableFunctionExpr id) or
    TLoadExpr(Raw::LoadExpr id) or
    TMagicIdentifierLiteralExpr(Raw::MagicIdentifierLiteralExpr id) or
    TMakeTemporarilyEscapableExpr(Raw::MakeTemporarilyEscapableExpr id) or
    TMemberRefExpr(Raw::MemberRefExpr id) or
    TMetatypeConversionExpr(Raw::MetatypeConversionExpr id) or
    TNilLiteralExpr(Raw::NilLiteralExpr id) or
    TObjCSelectorExpr(Raw::ObjCSelectorExpr id) or
    TObjectLiteralExpr(Raw::ObjectLiteralExpr id) or
    TOneWayExpr(Raw::OneWayExpr id) or
    TOpaqueValueExpr(Raw::OpaqueValueExpr id) or
    TOpenExistentialExpr(Raw::OpenExistentialExpr id) or
    TOptionalEvaluationExpr(Raw::OptionalEvaluationExpr id) or
    TOptionalTryExpr(Raw::OptionalTryExpr id) or
    TOtherConstructorDeclRefExpr(Raw::OtherConstructorDeclRefExpr id) or
    TOverloadedDeclRefExpr(Raw::OverloadedDeclRefExpr id) or
    TParenExpr(Raw::ParenExpr id) or
    TPointerToPointerExpr(Raw::PointerToPointerExpr id) or
    TPostfixUnaryExpr(Raw::PostfixUnaryExpr id) or
    TPrefixUnaryExpr(Raw::PrefixUnaryExpr id) or
    TPropertyWrapperValuePlaceholderExpr(Raw::PropertyWrapperValuePlaceholderExpr id) or
    TProtocolMetatypeToObjectExpr(Raw::ProtocolMetatypeToObjectExpr id) or
    TRebindSelfInConstructorExpr(Raw::RebindSelfInConstructorExpr id) or
    TRegexLiteralExpr(Raw::RegexLiteralExpr id) or
    TSequenceExpr(Raw::SequenceExpr id) or
    TStringLiteralExpr(Raw::StringLiteralExpr id) or
    TStringToPointerExpr(Raw::StringToPointerExpr id) or
    TSubscriptExpr(Raw::SubscriptExpr id) or
    TSuperRefExpr(Raw::SuperRefExpr id) or
    TTapExpr(Raw::TapExpr id) or
    TTryExpr(Raw::TryExpr id) or
    TTupleElementExpr(Raw::TupleElementExpr id) or
    TTupleExpr(Raw::TupleExpr id) or
    TTypeExpr(Raw::TypeExpr id) or
    TUnderlyingToOpaqueExpr(Raw::UnderlyingToOpaqueExpr id) or
    TUnevaluatedInstanceExpr(Raw::UnevaluatedInstanceExpr id) or
    TUnresolvedDeclRefExpr(Raw::UnresolvedDeclRefExpr id) or
    TUnresolvedDotExpr(Raw::UnresolvedDotExpr id) or
    TUnresolvedMemberChainResultExpr(Raw::UnresolvedMemberChainResultExpr id) or
    TUnresolvedMemberExpr(Raw::UnresolvedMemberExpr id) or
    TUnresolvedPatternExpr(Raw::UnresolvedPatternExpr id) or
    TUnresolvedSpecializeExpr(Raw::UnresolvedSpecializeExpr id) or
    TUnresolvedTypeConversionExpr(Raw::UnresolvedTypeConversionExpr id) or
    TVarargExpansionExpr(Raw::VarargExpansionExpr id) or
    TAnyPattern(Raw::AnyPattern id) or
    TBindingPattern(Raw::BindingPattern id) or
    TBoolPattern(Raw::BoolPattern id) or
    TEnumElementPattern(Raw::EnumElementPattern id) or
    TExprPattern(Raw::ExprPattern id) or
    TIsPattern(Raw::IsPattern id) or
    TNamedPattern(Raw::NamedPattern id) or
    TOptionalSomePattern(Raw::OptionalSomePattern id) or
    TParenPattern(Raw::ParenPattern id) or
    TTuplePattern(Raw::TuplePattern id) or
    TTypedPattern(Raw::TypedPattern id) or
    TBraceStmt(Raw::BraceStmt id) or
    TBreakStmt(Raw::BreakStmt id) or
    TCaseLabelItem(Raw::CaseLabelItem id) or
    TCaseStmt(Raw::CaseStmt id) or
    TConditionElement(Raw::ConditionElement id) or
    TContinueStmt(Raw::ContinueStmt id) or
    TDeferStmt(Raw::DeferStmt id) or
    TDoCatchStmt(Raw::DoCatchStmt id) or
    TDoStmt(Raw::DoStmt id) or
    TFailStmt(Raw::FailStmt id) or
    TFallthroughStmt(Raw::FallthroughStmt id) or
    TForEachStmt(Raw::ForEachStmt id) or
    TGuardStmt(Raw::GuardStmt id) or
    TIfStmt(Raw::IfStmt id) or
    TPoundAssertStmt(Raw::PoundAssertStmt id) or
    TRepeatWhileStmt(Raw::RepeatWhileStmt id) or
    TReturnStmt(Raw::ReturnStmt id) or
    TStmtCondition(Raw::StmtCondition id) or
    TSwitchStmt(Raw::SwitchStmt id) or
    TThrowStmt(Raw::ThrowStmt id) or
    TWhileStmt(Raw::WhileStmt id) or
    TYieldStmt(Raw::YieldStmt id) or
    TArraySliceType(Raw::ArraySliceType id) or
    TBoundGenericClassType(Raw::BoundGenericClassType id) or
    TBoundGenericEnumType(Raw::BoundGenericEnumType id) or
    TBoundGenericStructType(Raw::BoundGenericStructType id) or
    TBuiltinBridgeObjectType(Raw::BuiltinBridgeObjectType id) or
    TBuiltinDefaultActorStorageType(Raw::BuiltinDefaultActorStorageType id) or
    TBuiltinExecutorType(Raw::BuiltinExecutorType id) or
    TBuiltinFloatType(Raw::BuiltinFloatType id) or
    TBuiltinIntegerLiteralType(Raw::BuiltinIntegerLiteralType id) or
    TBuiltinIntegerType(Raw::BuiltinIntegerType id) or
    TBuiltinJobType(Raw::BuiltinJobType id) or
    TBuiltinNativeObjectType(Raw::BuiltinNativeObjectType id) or
    TBuiltinRawPointerType(Raw::BuiltinRawPointerType id) or
    TBuiltinRawUnsafeContinuationType(Raw::BuiltinRawUnsafeContinuationType id) or
    TBuiltinUnsafeValueBufferType(Raw::BuiltinUnsafeValueBufferType id) or
    TBuiltinVectorType(Raw::BuiltinVectorType id) or
    TClassType(Raw::ClassType id) or
    TDependentMemberType(Raw::DependentMemberType id) or
    TDictionaryType(Raw::DictionaryType id) or
    TDynamicSelfType(Raw::DynamicSelfType id) or
    TEnumType(Raw::EnumType id) or
    TErrorType(Raw::ErrorType id) or
    TExistentialMetatypeType(Raw::ExistentialMetatypeType id) or
    TExistentialType(Raw::ExistentialType id) or
    TFunctionType(Raw::FunctionType id) or
    TGenericFunctionType(Raw::GenericFunctionType id) or
    TGenericTypeParamType(Raw::GenericTypeParamType id) or
    TInOutType(Raw::InOutType id) or
    TLValueType(Raw::LValueType id) or
    TMetatypeType(Raw::MetatypeType id) or
    TModuleType(Raw::ModuleType id) or
    TNestedArchetypeType(Raw::NestedArchetypeType id) or
    TOpaqueTypeArchetypeType(Raw::OpaqueTypeArchetypeType id) or
    TOpenedArchetypeType(Raw::OpenedArchetypeType id) or
    TOptionalType(Raw::OptionalType id) or
    TParenType(Raw::ParenType id) or
    TPlaceholderType(Raw::PlaceholderType id) or
    TPrimaryArchetypeType(Raw::PrimaryArchetypeType id) or
    TProtocolCompositionType(Raw::ProtocolCompositionType id) or
    TProtocolType(Raw::ProtocolType id) or
    TSequenceArchetypeType(Raw::SequenceArchetypeType id) or
    TSilBlockStorageType(Raw::SilBlockStorageType id) or
    TSilBoxType(Raw::SilBoxType id) or
    TSilFunctionType(Raw::SilFunctionType id) or
    TSilTokenType(Raw::SilTokenType id) or
    TStructType(Raw::StructType id) or
    TTupleType(Raw::TupleType id) or
    TTypeAliasType(Raw::TypeAliasType id) or
    TTypeRepr(Raw::TypeRepr id) or
    TTypeVariableType(Raw::TypeVariableType id) or
    TUnboundGenericType(Raw::UnboundGenericType id) or
    TUnmanagedStorageType(Raw::UnmanagedStorageType id) or
    TUnownedStorageType(Raw::UnownedStorageType id) or
    TUnresolvedType(Raw::UnresolvedType id) or
    TVariadicSequenceType(Raw::VariadicSequenceType id) or
    TWeakStorageType(Raw::WeakStorageType id)

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
  TComment convertCommentFromDb(Raw::Element e) { result = TComment(e) }

  cached
  TDbFile convertDbFileFromDb(Raw::Element e) { result = TDbFile(e) }

  cached
  TDbLocation convertDbLocationFromDb(Raw::Element e) { result = TDbLocation(e) }

  cached
  TUnknownFile convertUnknownFileFromDb(Raw::Element e) { none() }

  cached
  TUnknownLocation convertUnknownLocationFromDb(Raw::Element e) { none() }

  cached
  TAccessorDecl convertAccessorDeclFromDb(Raw::Element e) { result = TAccessorDecl(e) }

  cached
  TAssociatedTypeDecl convertAssociatedTypeDeclFromDb(Raw::Element e) {
    result = TAssociatedTypeDecl(e)
  }

  cached
  TClassDecl convertClassDeclFromDb(Raw::Element e) { result = TClassDecl(e) }

  cached
  TConcreteFuncDecl convertConcreteFuncDeclFromDb(Raw::Element e) { result = TConcreteFuncDecl(e) }

  cached
  TConcreteVarDecl convertConcreteVarDeclFromDb(Raw::Element e) { result = TConcreteVarDecl(e) }

  cached
  TConstructorDecl convertConstructorDeclFromDb(Raw::Element e) { result = TConstructorDecl(e) }

  cached
  TDestructorDecl convertDestructorDeclFromDb(Raw::Element e) { result = TDestructorDecl(e) }

  cached
  TEnumCaseDecl convertEnumCaseDeclFromDb(Raw::Element e) { result = TEnumCaseDecl(e) }

  cached
  TEnumDecl convertEnumDeclFromDb(Raw::Element e) { result = TEnumDecl(e) }

  cached
  TEnumElementDecl convertEnumElementDeclFromDb(Raw::Element e) { result = TEnumElementDecl(e) }

  cached
  TExtensionDecl convertExtensionDeclFromDb(Raw::Element e) { result = TExtensionDecl(e) }

  cached
  TGenericTypeParamDecl convertGenericTypeParamDeclFromDb(Raw::Element e) {
    result = TGenericTypeParamDecl(e)
  }

  cached
  TIfConfigClause convertIfConfigClauseFromDb(Raw::Element e) { result = TIfConfigClause(e) }

  cached
  TIfConfigDecl convertIfConfigDeclFromDb(Raw::Element e) { result = TIfConfigDecl(e) }

  cached
  TImportDecl convertImportDeclFromDb(Raw::Element e) { result = TImportDecl(e) }

  cached
  TInfixOperatorDecl convertInfixOperatorDeclFromDb(Raw::Element e) {
    result = TInfixOperatorDecl(e)
  }

  cached
  TMissingMemberDecl convertMissingMemberDeclFromDb(Raw::Element e) {
    result = TMissingMemberDecl(e)
  }

  cached
  TModuleDecl convertModuleDeclFromDb(Raw::Element e) { result = TModuleDecl(e) }

  cached
  TOpaqueTypeDecl convertOpaqueTypeDeclFromDb(Raw::Element e) { result = TOpaqueTypeDecl(e) }

  cached
  TParamDecl convertParamDeclFromDb(Raw::Element e) { result = TParamDecl(e) }

  cached
  TPatternBindingDecl convertPatternBindingDeclFromDb(Raw::Element e) {
    result = TPatternBindingDecl(e)
  }

  cached
  TPostfixOperatorDecl convertPostfixOperatorDeclFromDb(Raw::Element e) {
    result = TPostfixOperatorDecl(e)
  }

  cached
  TPoundDiagnosticDecl convertPoundDiagnosticDeclFromDb(Raw::Element e) {
    result = TPoundDiagnosticDecl(e)
  }

  cached
  TPrecedenceGroupDecl convertPrecedenceGroupDeclFromDb(Raw::Element e) {
    result = TPrecedenceGroupDecl(e)
  }

  cached
  TPrefixOperatorDecl convertPrefixOperatorDeclFromDb(Raw::Element e) {
    result = TPrefixOperatorDecl(e)
  }

  cached
  TProtocolDecl convertProtocolDeclFromDb(Raw::Element e) { result = TProtocolDecl(e) }

  cached
  TStructDecl convertStructDeclFromDb(Raw::Element e) { result = TStructDecl(e) }

  cached
  TSubscriptDecl convertSubscriptDeclFromDb(Raw::Element e) { result = TSubscriptDecl(e) }

  cached
  TTopLevelCodeDecl convertTopLevelCodeDeclFromDb(Raw::Element e) { result = TTopLevelCodeDecl(e) }

  cached
  TTypeAliasDecl convertTypeAliasDeclFromDb(Raw::Element e) { result = TTypeAliasDecl(e) }

  cached
  TAnyHashableErasureExpr convertAnyHashableErasureExprFromDb(Raw::Element e) {
    result = TAnyHashableErasureExpr(e)
  }

  cached
  TAppliedPropertyWrapperExpr convertAppliedPropertyWrapperExprFromDb(Raw::Element e) {
    result = TAppliedPropertyWrapperExpr(e)
  }

  cached
  TArchetypeToSuperExpr convertArchetypeToSuperExprFromDb(Raw::Element e) {
    result = TArchetypeToSuperExpr(e)
  }

  cached
  TArgument convertArgumentFromDb(Raw::Element e) { result = TArgument(e) }

  cached
  TArrayExpr convertArrayExprFromDb(Raw::Element e) { result = TArrayExpr(e) }

  cached
  TArrayToPointerExpr convertArrayToPointerExprFromDb(Raw::Element e) {
    result = TArrayToPointerExpr(e)
  }

  cached
  TArrowExpr convertArrowExprFromDb(Raw::Element e) { result = TArrowExpr(e) }

  cached
  TAssignExpr convertAssignExprFromDb(Raw::Element e) { result = TAssignExpr(e) }

  cached
  TAutoClosureExpr convertAutoClosureExprFromDb(Raw::Element e) { result = TAutoClosureExpr(e) }

  cached
  TAwaitExpr convertAwaitExprFromDb(Raw::Element e) { result = TAwaitExpr(e) }

  cached
  TBinaryExpr convertBinaryExprFromDb(Raw::Element e) { result = TBinaryExpr(e) }

  cached
  TBindOptionalExpr convertBindOptionalExprFromDb(Raw::Element e) { result = TBindOptionalExpr(e) }

  cached
  TBooleanLiteralExpr convertBooleanLiteralExprFromDb(Raw::Element e) {
    result = TBooleanLiteralExpr(e)
  }

  cached
  TBridgeFromObjCExpr convertBridgeFromObjCExprFromDb(Raw::Element e) {
    result = TBridgeFromObjCExpr(e)
  }

  cached
  TBridgeToObjCExpr convertBridgeToObjCExprFromDb(Raw::Element e) { result = TBridgeToObjCExpr(e) }

  cached
  TCallExpr convertCallExprFromDb(Raw::Element e) { result = TCallExpr(e) }

  cached
  TCaptureListExpr convertCaptureListExprFromDb(Raw::Element e) { result = TCaptureListExpr(e) }

  cached
  TClassMetatypeToObjectExpr convertClassMetatypeToObjectExprFromDb(Raw::Element e) {
    result = TClassMetatypeToObjectExpr(e)
  }

  cached
  TClosureExpr convertClosureExprFromDb(Raw::Element e) { result = TClosureExpr(e) }

  cached
  TCodeCompletionExpr convertCodeCompletionExprFromDb(Raw::Element e) {
    result = TCodeCompletionExpr(e)
  }

  cached
  TCoerceExpr convertCoerceExprFromDb(Raw::Element e) { result = TCoerceExpr(e) }

  cached
  TCollectionUpcastConversionExpr convertCollectionUpcastConversionExprFromDb(Raw::Element e) {
    result = TCollectionUpcastConversionExpr(e)
  }

  cached
  TConditionalBridgeFromObjCExpr convertConditionalBridgeFromObjCExprFromDb(Raw::Element e) {
    result = TConditionalBridgeFromObjCExpr(e)
  }

  cached
  TConditionalCheckedCastExpr convertConditionalCheckedCastExprFromDb(Raw::Element e) {
    result = TConditionalCheckedCastExpr(e)
  }

  cached
  TConstructorRefCallExpr convertConstructorRefCallExprFromDb(Raw::Element e) {
    result = TConstructorRefCallExpr(e)
  }

  cached
  TCovariantFunctionConversionExpr convertCovariantFunctionConversionExprFromDb(Raw::Element e) {
    result = TCovariantFunctionConversionExpr(e)
  }

  cached
  TCovariantReturnConversionExpr convertCovariantReturnConversionExprFromDb(Raw::Element e) {
    result = TCovariantReturnConversionExpr(e)
  }

  cached
  TDeclRefExpr convertDeclRefExprFromDb(Raw::Element e) { result = TDeclRefExpr(e) }

  cached
  TDefaultArgumentExpr convertDefaultArgumentExprFromDb(Raw::Element e) {
    result = TDefaultArgumentExpr(e)
  }

  cached
  TDerivedToBaseExpr convertDerivedToBaseExprFromDb(Raw::Element e) {
    result = TDerivedToBaseExpr(e)
  }

  cached
  TDestructureTupleExpr convertDestructureTupleExprFromDb(Raw::Element e) {
    result = TDestructureTupleExpr(e)
  }

  cached
  TDictionaryExpr convertDictionaryExprFromDb(Raw::Element e) { result = TDictionaryExpr(e) }

  cached
  TDifferentiableFunctionExpr convertDifferentiableFunctionExprFromDb(Raw::Element e) {
    result = TDifferentiableFunctionExpr(e)
  }

  cached
  TDifferentiableFunctionExtractOriginalExpr convertDifferentiableFunctionExtractOriginalExprFromDb(
    Raw::Element e
  ) {
    result = TDifferentiableFunctionExtractOriginalExpr(e)
  }

  cached
  TDiscardAssignmentExpr convertDiscardAssignmentExprFromDb(Raw::Element e) {
    result = TDiscardAssignmentExpr(e)
  }

  cached
  TDotSelfExpr convertDotSelfExprFromDb(Raw::Element e) { result = TDotSelfExpr(e) }

  cached
  TDotSyntaxBaseIgnoredExpr convertDotSyntaxBaseIgnoredExprFromDb(Raw::Element e) {
    result = TDotSyntaxBaseIgnoredExpr(e)
  }

  cached
  TDotSyntaxCallExpr convertDotSyntaxCallExprFromDb(Raw::Element e) {
    result = TDotSyntaxCallExpr(e)
  }

  cached
  TDynamicMemberRefExpr convertDynamicMemberRefExprFromDb(Raw::Element e) {
    result = TDynamicMemberRefExpr(e)
  }

  cached
  TDynamicSubscriptExpr convertDynamicSubscriptExprFromDb(Raw::Element e) {
    result = TDynamicSubscriptExpr(e)
  }

  cached
  TDynamicTypeExpr convertDynamicTypeExprFromDb(Raw::Element e) { result = TDynamicTypeExpr(e) }

  cached
  TEditorPlaceholderExpr convertEditorPlaceholderExprFromDb(Raw::Element e) {
    result = TEditorPlaceholderExpr(e)
  }

  cached
  TEnumIsCaseExpr convertEnumIsCaseExprFromDb(Raw::Element e) { result = TEnumIsCaseExpr(e) }

  cached
  TErasureExpr convertErasureExprFromDb(Raw::Element e) { result = TErasureExpr(e) }

  cached
  TErrorExpr convertErrorExprFromDb(Raw::Element e) { result = TErrorExpr(e) }

  cached
  TExistentialMetatypeToObjectExpr convertExistentialMetatypeToObjectExprFromDb(Raw::Element e) {
    result = TExistentialMetatypeToObjectExpr(e)
  }

  cached
  TFloatLiteralExpr convertFloatLiteralExprFromDb(Raw::Element e) { result = TFloatLiteralExpr(e) }

  cached
  TForceTryExpr convertForceTryExprFromDb(Raw::Element e) { result = TForceTryExpr(e) }

  cached
  TForceValueExpr convertForceValueExprFromDb(Raw::Element e) { result = TForceValueExpr(e) }

  cached
  TForcedCheckedCastExpr convertForcedCheckedCastExprFromDb(Raw::Element e) {
    result = TForcedCheckedCastExpr(e)
  }

  cached
  TForeignObjectConversionExpr convertForeignObjectConversionExprFromDb(Raw::Element e) {
    result = TForeignObjectConversionExpr(e)
  }

  cached
  TFunctionConversionExpr convertFunctionConversionExprFromDb(Raw::Element e) {
    result = TFunctionConversionExpr(e)
  }

  cached
  TIfExpr convertIfExprFromDb(Raw::Element e) { result = TIfExpr(e) }

  cached
  TInOutExpr convertInOutExprFromDb(Raw::Element e) { result = TInOutExpr(e) }

  cached
  TInOutToPointerExpr convertInOutToPointerExprFromDb(Raw::Element e) {
    result = TInOutToPointerExpr(e)
  }

  cached
  TInjectIntoOptionalExpr convertInjectIntoOptionalExprFromDb(Raw::Element e) {
    result = TInjectIntoOptionalExpr(e)
  }

  cached
  TIntegerLiteralExpr convertIntegerLiteralExprFromDb(Raw::Element e) {
    result = TIntegerLiteralExpr(e)
  }

  cached
  TInterpolatedStringLiteralExpr convertInterpolatedStringLiteralExprFromDb(Raw::Element e) {
    result = TInterpolatedStringLiteralExpr(e)
  }

  cached
  TIsExpr convertIsExprFromDb(Raw::Element e) { result = TIsExpr(e) }

  cached
  TKeyPathApplicationExpr convertKeyPathApplicationExprFromDb(Raw::Element e) {
    result = TKeyPathApplicationExpr(e)
  }

  cached
  TKeyPathDotExpr convertKeyPathDotExprFromDb(Raw::Element e) { result = TKeyPathDotExpr(e) }

  cached
  TKeyPathExpr convertKeyPathExprFromDb(Raw::Element e) { result = TKeyPathExpr(e) }

  cached
  TLazyInitializerExpr convertLazyInitializerExprFromDb(Raw::Element e) {
    result = TLazyInitializerExpr(e)
  }

  cached
  TLinearFunctionExpr convertLinearFunctionExprFromDb(Raw::Element e) {
    result = TLinearFunctionExpr(e)
  }

  cached
  TLinearFunctionExtractOriginalExpr convertLinearFunctionExtractOriginalExprFromDb(Raw::Element e) {
    result = TLinearFunctionExtractOriginalExpr(e)
  }

  cached
  TLinearToDifferentiableFunctionExpr convertLinearToDifferentiableFunctionExprFromDb(Raw::Element e) {
    result = TLinearToDifferentiableFunctionExpr(e)
  }

  cached
  TLoadExpr convertLoadExprFromDb(Raw::Element e) { result = TLoadExpr(e) }

  cached
  TMagicIdentifierLiteralExpr convertMagicIdentifierLiteralExprFromDb(Raw::Element e) {
    result = TMagicIdentifierLiteralExpr(e)
  }

  cached
  TMakeTemporarilyEscapableExpr convertMakeTemporarilyEscapableExprFromDb(Raw::Element e) {
    result = TMakeTemporarilyEscapableExpr(e)
  }

  cached
  TMemberRefExpr convertMemberRefExprFromDb(Raw::Element e) { result = TMemberRefExpr(e) }

  cached
  TMetatypeConversionExpr convertMetatypeConversionExprFromDb(Raw::Element e) {
    result = TMetatypeConversionExpr(e)
  }

  cached
  TNilLiteralExpr convertNilLiteralExprFromDb(Raw::Element e) { result = TNilLiteralExpr(e) }

  cached
  TObjCSelectorExpr convertObjCSelectorExprFromDb(Raw::Element e) { result = TObjCSelectorExpr(e) }

  cached
  TObjectLiteralExpr convertObjectLiteralExprFromDb(Raw::Element e) {
    result = TObjectLiteralExpr(e)
  }

  cached
  TOneWayExpr convertOneWayExprFromDb(Raw::Element e) { result = TOneWayExpr(e) }

  cached
  TOpaqueValueExpr convertOpaqueValueExprFromDb(Raw::Element e) { result = TOpaqueValueExpr(e) }

  cached
  TOpenExistentialExpr convertOpenExistentialExprFromDb(Raw::Element e) {
    result = TOpenExistentialExpr(e)
  }

  cached
  TOptionalEvaluationExpr convertOptionalEvaluationExprFromDb(Raw::Element e) {
    result = TOptionalEvaluationExpr(e)
  }

  cached
  TOptionalTryExpr convertOptionalTryExprFromDb(Raw::Element e) { result = TOptionalTryExpr(e) }

  cached
  TOtherConstructorDeclRefExpr convertOtherConstructorDeclRefExprFromDb(Raw::Element e) {
    result = TOtherConstructorDeclRefExpr(e)
  }

  cached
  TOverloadedDeclRefExpr convertOverloadedDeclRefExprFromDb(Raw::Element e) {
    result = TOverloadedDeclRefExpr(e)
  }

  cached
  TParenExpr convertParenExprFromDb(Raw::Element e) { result = TParenExpr(e) }

  cached
  TPointerToPointerExpr convertPointerToPointerExprFromDb(Raw::Element e) {
    result = TPointerToPointerExpr(e)
  }

  cached
  TPostfixUnaryExpr convertPostfixUnaryExprFromDb(Raw::Element e) { result = TPostfixUnaryExpr(e) }

  cached
  TPrefixUnaryExpr convertPrefixUnaryExprFromDb(Raw::Element e) { result = TPrefixUnaryExpr(e) }

  cached
  TPropertyWrapperValuePlaceholderExpr convertPropertyWrapperValuePlaceholderExprFromDb(
    Raw::Element e
  ) {
    result = TPropertyWrapperValuePlaceholderExpr(e)
  }

  cached
  TProtocolMetatypeToObjectExpr convertProtocolMetatypeToObjectExprFromDb(Raw::Element e) {
    result = TProtocolMetatypeToObjectExpr(e)
  }

  cached
  TRebindSelfInConstructorExpr convertRebindSelfInConstructorExprFromDb(Raw::Element e) {
    result = TRebindSelfInConstructorExpr(e)
  }

  cached
  TRegexLiteralExpr convertRegexLiteralExprFromDb(Raw::Element e) { result = TRegexLiteralExpr(e) }

  cached
  TSequenceExpr convertSequenceExprFromDb(Raw::Element e) { result = TSequenceExpr(e) }

  cached
  TStringLiteralExpr convertStringLiteralExprFromDb(Raw::Element e) {
    result = TStringLiteralExpr(e)
  }

  cached
  TStringToPointerExpr convertStringToPointerExprFromDb(Raw::Element e) {
    result = TStringToPointerExpr(e)
  }

  cached
  TSubscriptExpr convertSubscriptExprFromDb(Raw::Element e) { result = TSubscriptExpr(e) }

  cached
  TSuperRefExpr convertSuperRefExprFromDb(Raw::Element e) { result = TSuperRefExpr(e) }

  cached
  TTapExpr convertTapExprFromDb(Raw::Element e) { result = TTapExpr(e) }

  cached
  TTryExpr convertTryExprFromDb(Raw::Element e) { result = TTryExpr(e) }

  cached
  TTupleElementExpr convertTupleElementExprFromDb(Raw::Element e) { result = TTupleElementExpr(e) }

  cached
  TTupleExpr convertTupleExprFromDb(Raw::Element e) { result = TTupleExpr(e) }

  cached
  TTypeExpr convertTypeExprFromDb(Raw::Element e) { result = TTypeExpr(e) }

  cached
  TUnderlyingToOpaqueExpr convertUnderlyingToOpaqueExprFromDb(Raw::Element e) {
    result = TUnderlyingToOpaqueExpr(e)
  }

  cached
  TUnevaluatedInstanceExpr convertUnevaluatedInstanceExprFromDb(Raw::Element e) {
    result = TUnevaluatedInstanceExpr(e)
  }

  cached
  TUnresolvedDeclRefExpr convertUnresolvedDeclRefExprFromDb(Raw::Element e) {
    result = TUnresolvedDeclRefExpr(e)
  }

  cached
  TUnresolvedDotExpr convertUnresolvedDotExprFromDb(Raw::Element e) {
    result = TUnresolvedDotExpr(e)
  }

  cached
  TUnresolvedMemberChainResultExpr convertUnresolvedMemberChainResultExprFromDb(Raw::Element e) {
    result = TUnresolvedMemberChainResultExpr(e)
  }

  cached
  TUnresolvedMemberExpr convertUnresolvedMemberExprFromDb(Raw::Element e) {
    result = TUnresolvedMemberExpr(e)
  }

  cached
  TUnresolvedPatternExpr convertUnresolvedPatternExprFromDb(Raw::Element e) {
    result = TUnresolvedPatternExpr(e)
  }

  cached
  TUnresolvedSpecializeExpr convertUnresolvedSpecializeExprFromDb(Raw::Element e) {
    result = TUnresolvedSpecializeExpr(e)
  }

  cached
  TUnresolvedTypeConversionExpr convertUnresolvedTypeConversionExprFromDb(Raw::Element e) {
    result = TUnresolvedTypeConversionExpr(e)
  }

  cached
  TVarargExpansionExpr convertVarargExpansionExprFromDb(Raw::Element e) {
    result = TVarargExpansionExpr(e)
  }

  cached
  TAnyPattern convertAnyPatternFromDb(Raw::Element e) { result = TAnyPattern(e) }

  cached
  TBindingPattern convertBindingPatternFromDb(Raw::Element e) { result = TBindingPattern(e) }

  cached
  TBoolPattern convertBoolPatternFromDb(Raw::Element e) { result = TBoolPattern(e) }

  cached
  TEnumElementPattern convertEnumElementPatternFromDb(Raw::Element e) {
    result = TEnumElementPattern(e)
  }

  cached
  TExprPattern convertExprPatternFromDb(Raw::Element e) { result = TExprPattern(e) }

  cached
  TIsPattern convertIsPatternFromDb(Raw::Element e) { result = TIsPattern(e) }

  cached
  TNamedPattern convertNamedPatternFromDb(Raw::Element e) { result = TNamedPattern(e) }

  cached
  TOptionalSomePattern convertOptionalSomePatternFromDb(Raw::Element e) {
    result = TOptionalSomePattern(e)
  }

  cached
  TParenPattern convertParenPatternFromDb(Raw::Element e) { result = TParenPattern(e) }

  cached
  TTuplePattern convertTuplePatternFromDb(Raw::Element e) { result = TTuplePattern(e) }

  cached
  TTypedPattern convertTypedPatternFromDb(Raw::Element e) { result = TTypedPattern(e) }

  cached
  TBraceStmt convertBraceStmtFromDb(Raw::Element e) { result = TBraceStmt(e) }

  cached
  TBreakStmt convertBreakStmtFromDb(Raw::Element e) { result = TBreakStmt(e) }

  cached
  TCaseLabelItem convertCaseLabelItemFromDb(Raw::Element e) { result = TCaseLabelItem(e) }

  cached
  TCaseStmt convertCaseStmtFromDb(Raw::Element e) { result = TCaseStmt(e) }

  cached
  TConditionElement convertConditionElementFromDb(Raw::Element e) { result = TConditionElement(e) }

  cached
  TContinueStmt convertContinueStmtFromDb(Raw::Element e) { result = TContinueStmt(e) }

  cached
  TDeferStmt convertDeferStmtFromDb(Raw::Element e) { result = TDeferStmt(e) }

  cached
  TDoCatchStmt convertDoCatchStmtFromDb(Raw::Element e) { result = TDoCatchStmt(e) }

  cached
  TDoStmt convertDoStmtFromDb(Raw::Element e) { result = TDoStmt(e) }

  cached
  TFailStmt convertFailStmtFromDb(Raw::Element e) { result = TFailStmt(e) }

  cached
  TFallthroughStmt convertFallthroughStmtFromDb(Raw::Element e) { result = TFallthroughStmt(e) }

  cached
  TForEachStmt convertForEachStmtFromDb(Raw::Element e) { result = TForEachStmt(e) }

  cached
  TGuardStmt convertGuardStmtFromDb(Raw::Element e) { result = TGuardStmt(e) }

  cached
  TIfStmt convertIfStmtFromDb(Raw::Element e) { result = TIfStmt(e) }

  cached
  TPoundAssertStmt convertPoundAssertStmtFromDb(Raw::Element e) { result = TPoundAssertStmt(e) }

  cached
  TRepeatWhileStmt convertRepeatWhileStmtFromDb(Raw::Element e) { result = TRepeatWhileStmt(e) }

  cached
  TReturnStmt convertReturnStmtFromDb(Raw::Element e) { result = TReturnStmt(e) }

  cached
  TStmtCondition convertStmtConditionFromDb(Raw::Element e) { result = TStmtCondition(e) }

  cached
  TSwitchStmt convertSwitchStmtFromDb(Raw::Element e) { result = TSwitchStmt(e) }

  cached
  TThrowStmt convertThrowStmtFromDb(Raw::Element e) { result = TThrowStmt(e) }

  cached
  TWhileStmt convertWhileStmtFromDb(Raw::Element e) { result = TWhileStmt(e) }

  cached
  TYieldStmt convertYieldStmtFromDb(Raw::Element e) { result = TYieldStmt(e) }

  cached
  TArraySliceType convertArraySliceTypeFromDb(Raw::Element e) { result = TArraySliceType(e) }

  cached
  TBoundGenericClassType convertBoundGenericClassTypeFromDb(Raw::Element e) {
    result = TBoundGenericClassType(e)
  }

  cached
  TBoundGenericEnumType convertBoundGenericEnumTypeFromDb(Raw::Element e) {
    result = TBoundGenericEnumType(e)
  }

  cached
  TBoundGenericStructType convertBoundGenericStructTypeFromDb(Raw::Element e) {
    result = TBoundGenericStructType(e)
  }

  cached
  TBuiltinBridgeObjectType convertBuiltinBridgeObjectTypeFromDb(Raw::Element e) {
    result = TBuiltinBridgeObjectType(e)
  }

  cached
  TBuiltinDefaultActorStorageType convertBuiltinDefaultActorStorageTypeFromDb(Raw::Element e) {
    result = TBuiltinDefaultActorStorageType(e)
  }

  cached
  TBuiltinExecutorType convertBuiltinExecutorTypeFromDb(Raw::Element e) {
    result = TBuiltinExecutorType(e)
  }

  cached
  TBuiltinFloatType convertBuiltinFloatTypeFromDb(Raw::Element e) { result = TBuiltinFloatType(e) }

  cached
  TBuiltinIntegerLiteralType convertBuiltinIntegerLiteralTypeFromDb(Raw::Element e) {
    result = TBuiltinIntegerLiteralType(e)
  }

  cached
  TBuiltinIntegerType convertBuiltinIntegerTypeFromDb(Raw::Element e) {
    result = TBuiltinIntegerType(e)
  }

  cached
  TBuiltinJobType convertBuiltinJobTypeFromDb(Raw::Element e) { result = TBuiltinJobType(e) }

  cached
  TBuiltinNativeObjectType convertBuiltinNativeObjectTypeFromDb(Raw::Element e) {
    result = TBuiltinNativeObjectType(e)
  }

  cached
  TBuiltinRawPointerType convertBuiltinRawPointerTypeFromDb(Raw::Element e) {
    result = TBuiltinRawPointerType(e)
  }

  cached
  TBuiltinRawUnsafeContinuationType convertBuiltinRawUnsafeContinuationTypeFromDb(Raw::Element e) {
    result = TBuiltinRawUnsafeContinuationType(e)
  }

  cached
  TBuiltinUnsafeValueBufferType convertBuiltinUnsafeValueBufferTypeFromDb(Raw::Element e) {
    result = TBuiltinUnsafeValueBufferType(e)
  }

  cached
  TBuiltinVectorType convertBuiltinVectorTypeFromDb(Raw::Element e) {
    result = TBuiltinVectorType(e)
  }

  cached
  TClassType convertClassTypeFromDb(Raw::Element e) { result = TClassType(e) }

  cached
  TDependentMemberType convertDependentMemberTypeFromDb(Raw::Element e) {
    result = TDependentMemberType(e)
  }

  cached
  TDictionaryType convertDictionaryTypeFromDb(Raw::Element e) { result = TDictionaryType(e) }

  cached
  TDynamicSelfType convertDynamicSelfTypeFromDb(Raw::Element e) { result = TDynamicSelfType(e) }

  cached
  TEnumType convertEnumTypeFromDb(Raw::Element e) { result = TEnumType(e) }

  cached
  TErrorType convertErrorTypeFromDb(Raw::Element e) { result = TErrorType(e) }

  cached
  TExistentialMetatypeType convertExistentialMetatypeTypeFromDb(Raw::Element e) {
    result = TExistentialMetatypeType(e)
  }

  cached
  TExistentialType convertExistentialTypeFromDb(Raw::Element e) { result = TExistentialType(e) }

  cached
  TFunctionType convertFunctionTypeFromDb(Raw::Element e) { result = TFunctionType(e) }

  cached
  TGenericFunctionType convertGenericFunctionTypeFromDb(Raw::Element e) {
    result = TGenericFunctionType(e)
  }

  cached
  TGenericTypeParamType convertGenericTypeParamTypeFromDb(Raw::Element e) {
    result = TGenericTypeParamType(e)
  }

  cached
  TInOutType convertInOutTypeFromDb(Raw::Element e) { result = TInOutType(e) }

  cached
  TLValueType convertLValueTypeFromDb(Raw::Element e) { result = TLValueType(e) }

  cached
  TMetatypeType convertMetatypeTypeFromDb(Raw::Element e) { result = TMetatypeType(e) }

  cached
  TModuleType convertModuleTypeFromDb(Raw::Element e) { result = TModuleType(e) }

  cached
  TNestedArchetypeType convertNestedArchetypeTypeFromDb(Raw::Element e) {
    result = TNestedArchetypeType(e)
  }

  cached
  TOpaqueTypeArchetypeType convertOpaqueTypeArchetypeTypeFromDb(Raw::Element e) {
    result = TOpaqueTypeArchetypeType(e)
  }

  cached
  TOpenedArchetypeType convertOpenedArchetypeTypeFromDb(Raw::Element e) {
    result = TOpenedArchetypeType(e)
  }

  cached
  TOptionalType convertOptionalTypeFromDb(Raw::Element e) { result = TOptionalType(e) }

  cached
  TParenType convertParenTypeFromDb(Raw::Element e) { result = TParenType(e) }

  cached
  TPlaceholderType convertPlaceholderTypeFromDb(Raw::Element e) { result = TPlaceholderType(e) }

  cached
  TPrimaryArchetypeType convertPrimaryArchetypeTypeFromDb(Raw::Element e) {
    result = TPrimaryArchetypeType(e)
  }

  cached
  TProtocolCompositionType convertProtocolCompositionTypeFromDb(Raw::Element e) {
    result = TProtocolCompositionType(e)
  }

  cached
  TProtocolType convertProtocolTypeFromDb(Raw::Element e) { result = TProtocolType(e) }

  cached
  TSequenceArchetypeType convertSequenceArchetypeTypeFromDb(Raw::Element e) {
    result = TSequenceArchetypeType(e)
  }

  cached
  TSilBlockStorageType convertSilBlockStorageTypeFromDb(Raw::Element e) {
    result = TSilBlockStorageType(e)
  }

  cached
  TSilBoxType convertSilBoxTypeFromDb(Raw::Element e) { result = TSilBoxType(e) }

  cached
  TSilFunctionType convertSilFunctionTypeFromDb(Raw::Element e) { result = TSilFunctionType(e) }

  cached
  TSilTokenType convertSilTokenTypeFromDb(Raw::Element e) { result = TSilTokenType(e) }

  cached
  TStructType convertStructTypeFromDb(Raw::Element e) { result = TStructType(e) }

  cached
  TTupleType convertTupleTypeFromDb(Raw::Element e) { result = TTupleType(e) }

  cached
  TTypeAliasType convertTypeAliasTypeFromDb(Raw::Element e) { result = TTypeAliasType(e) }

  cached
  TTypeRepr convertTypeReprFromDb(Raw::Element e) { result = TTypeRepr(e) }

  cached
  TTypeVariableType convertTypeVariableTypeFromDb(Raw::Element e) { result = TTypeVariableType(e) }

  cached
  TUnboundGenericType convertUnboundGenericTypeFromDb(Raw::Element e) {
    result = TUnboundGenericType(e)
  }

  cached
  TUnmanagedStorageType convertUnmanagedStorageTypeFromDb(Raw::Element e) {
    result = TUnmanagedStorageType(e)
  }

  cached
  TUnownedStorageType convertUnownedStorageTypeFromDb(Raw::Element e) {
    result = TUnownedStorageType(e)
  }

  cached
  TUnresolvedType convertUnresolvedTypeFromDb(Raw::Element e) { result = TUnresolvedType(e) }

  cached
  TVariadicSequenceType convertVariadicSequenceTypeFromDb(Raw::Element e) {
    result = TVariadicSequenceType(e)
  }

  cached
  TWeakStorageType convertWeakStorageTypeFromDb(Raw::Element e) { result = TWeakStorageType(e) }

  cached
  TAstNode convertAstNodeFromDb(Raw::Element e) {
    result = convertCaseLabelItemFromDb(e)
    or
    result = convertDeclFromDb(e)
    or
    result = convertExprFromDb(e)
    or
    result = convertPatternFromDb(e)
    or
    result = convertStmtFromDb(e)
    or
    result = convertStmtConditionFromDb(e)
    or
    result = convertTypeReprFromDb(e)
  }

  cached
  TCallable convertCallableFromDb(Raw::Element e) {
    result = convertAbstractClosureExprFromDb(e)
    or
    result = convertAbstractFunctionDeclFromDb(e)
  }

  cached
  TElement convertElementFromDb(Raw::Element e) {
    result = convertCallableFromDb(e)
    or
    result = convertFileFromDb(e)
    or
    result = convertGenericContextFromDb(e)
    or
    result = convertIterableDeclContextFromDb(e)
    or
    result = convertLocatableFromDb(e)
    or
    result = convertLocationFromDb(e)
    or
    result = convertTypeFromDb(e)
  }

  cached
  TFile convertFileFromDb(Raw::Element e) {
    result = convertDbFileFromDb(e)
    or
    result = convertUnknownFileFromDb(e)
  }

  cached
  TLocatable convertLocatableFromDb(Raw::Element e) {
    result = convertArgumentFromDb(e)
    or
    result = convertAstNodeFromDb(e)
    or
    result = convertCommentFromDb(e)
    or
    result = convertConditionElementFromDb(e)
    or
    result = convertIfConfigClauseFromDb(e)
  }

  cached
  TLocation convertLocationFromDb(Raw::Element e) {
    result = convertDbLocationFromDb(e)
    or
    result = convertUnknownLocationFromDb(e)
  }

  cached
  TAbstractFunctionDecl convertAbstractFunctionDeclFromDb(Raw::Element e) {
    result = convertConstructorDeclFromDb(e)
    or
    result = convertDestructorDeclFromDb(e)
    or
    result = convertFuncDeclFromDb(e)
  }

  cached
  TAbstractStorageDecl convertAbstractStorageDeclFromDb(Raw::Element e) {
    result = convertSubscriptDeclFromDb(e)
    or
    result = convertVarDeclFromDb(e)
  }

  cached
  TAbstractTypeParamDecl convertAbstractTypeParamDeclFromDb(Raw::Element e) {
    result = convertAssociatedTypeDeclFromDb(e)
    or
    result = convertGenericTypeParamDeclFromDb(e)
  }

  cached
  TDecl convertDeclFromDb(Raw::Element e) {
    result = convertEnumCaseDeclFromDb(e)
    or
    result = convertExtensionDeclFromDb(e)
    or
    result = convertIfConfigDeclFromDb(e)
    or
    result = convertImportDeclFromDb(e)
    or
    result = convertMissingMemberDeclFromDb(e)
    or
    result = convertOperatorDeclFromDb(e)
    or
    result = convertPatternBindingDeclFromDb(e)
    or
    result = convertPoundDiagnosticDeclFromDb(e)
    or
    result = convertPrecedenceGroupDeclFromDb(e)
    or
    result = convertTopLevelCodeDeclFromDb(e)
    or
    result = convertValueDeclFromDb(e)
  }

  cached
  TFuncDecl convertFuncDeclFromDb(Raw::Element e) {
    result = convertAccessorDeclFromDb(e)
    or
    result = convertConcreteFuncDeclFromDb(e)
  }

  cached
  TGenericContext convertGenericContextFromDb(Raw::Element e) {
    result = convertAbstractFunctionDeclFromDb(e)
    or
    result = convertExtensionDeclFromDb(e)
    or
    result = convertGenericTypeDeclFromDb(e)
    or
    result = convertSubscriptDeclFromDb(e)
  }

  cached
  TGenericTypeDecl convertGenericTypeDeclFromDb(Raw::Element e) {
    result = convertNominalTypeDeclFromDb(e)
    or
    result = convertOpaqueTypeDeclFromDb(e)
    or
    result = convertTypeAliasDeclFromDb(e)
  }

  cached
  TIterableDeclContext convertIterableDeclContextFromDb(Raw::Element e) {
    result = convertExtensionDeclFromDb(e)
    or
    result = convertNominalTypeDeclFromDb(e)
  }

  cached
  TNominalTypeDecl convertNominalTypeDeclFromDb(Raw::Element e) {
    result = convertClassDeclFromDb(e)
    or
    result = convertEnumDeclFromDb(e)
    or
    result = convertProtocolDeclFromDb(e)
    or
    result = convertStructDeclFromDb(e)
  }

  cached
  TOperatorDecl convertOperatorDeclFromDb(Raw::Element e) {
    result = convertInfixOperatorDeclFromDb(e)
    or
    result = convertPostfixOperatorDeclFromDb(e)
    or
    result = convertPrefixOperatorDeclFromDb(e)
  }

  cached
  TTypeDecl convertTypeDeclFromDb(Raw::Element e) {
    result = convertAbstractTypeParamDeclFromDb(e)
    or
    result = convertGenericTypeDeclFromDb(e)
    or
    result = convertModuleDeclFromDb(e)
  }

  cached
  TValueDecl convertValueDeclFromDb(Raw::Element e) {
    result = convertAbstractFunctionDeclFromDb(e)
    or
    result = convertAbstractStorageDeclFromDb(e)
    or
    result = convertEnumElementDeclFromDb(e)
    or
    result = convertTypeDeclFromDb(e)
  }

  cached
  TVarDecl convertVarDeclFromDb(Raw::Element e) {
    result = convertConcreteVarDeclFromDb(e)
    or
    result = convertParamDeclFromDb(e)
  }

  cached
  TAbstractClosureExpr convertAbstractClosureExprFromDb(Raw::Element e) {
    result = convertAutoClosureExprFromDb(e)
    or
    result = convertClosureExprFromDb(e)
  }

  cached
  TAnyTryExpr convertAnyTryExprFromDb(Raw::Element e) {
    result = convertForceTryExprFromDb(e)
    or
    result = convertOptionalTryExprFromDb(e)
    or
    result = convertTryExprFromDb(e)
  }

  cached
  TApplyExpr convertApplyExprFromDb(Raw::Element e) {
    result = convertBinaryExprFromDb(e)
    or
    result = convertCallExprFromDb(e)
    or
    result = convertPostfixUnaryExprFromDb(e)
    or
    result = convertPrefixUnaryExprFromDb(e)
    or
    result = convertSelfApplyExprFromDb(e)
  }

  cached
  TBuiltinLiteralExpr convertBuiltinLiteralExprFromDb(Raw::Element e) {
    result = convertBooleanLiteralExprFromDb(e)
    or
    result = convertMagicIdentifierLiteralExprFromDb(e)
    or
    result = convertNumberLiteralExprFromDb(e)
    or
    result = convertStringLiteralExprFromDb(e)
  }

  cached
  TCheckedCastExpr convertCheckedCastExprFromDb(Raw::Element e) {
    result = convertConditionalCheckedCastExprFromDb(e)
    or
    result = convertForcedCheckedCastExprFromDb(e)
    or
    result = convertIsExprFromDb(e)
  }

  cached
  TCollectionExpr convertCollectionExprFromDb(Raw::Element e) {
    result = convertArrayExprFromDb(e)
    or
    result = convertDictionaryExprFromDb(e)
  }

  cached
  TDynamicLookupExpr convertDynamicLookupExprFromDb(Raw::Element e) {
    result = convertDynamicMemberRefExprFromDb(e)
    or
    result = convertDynamicSubscriptExprFromDb(e)
  }

  cached
  TExplicitCastExpr convertExplicitCastExprFromDb(Raw::Element e) {
    result = convertCheckedCastExprFromDb(e)
    or
    result = convertCoerceExprFromDb(e)
  }

  cached
  TExpr convertExprFromDb(Raw::Element e) {
    result = convertAbstractClosureExprFromDb(e)
    or
    result = convertAnyTryExprFromDb(e)
    or
    result = convertAppliedPropertyWrapperExprFromDb(e)
    or
    result = convertApplyExprFromDb(e)
    or
    result = convertArrowExprFromDb(e)
    or
    result = convertAssignExprFromDb(e)
    or
    result = convertBindOptionalExprFromDb(e)
    or
    result = convertCaptureListExprFromDb(e)
    or
    result = convertCodeCompletionExprFromDb(e)
    or
    result = convertCollectionExprFromDb(e)
    or
    result = convertDeclRefExprFromDb(e)
    or
    result = convertDefaultArgumentExprFromDb(e)
    or
    result = convertDiscardAssignmentExprFromDb(e)
    or
    result = convertDotSyntaxBaseIgnoredExprFromDb(e)
    or
    result = convertDynamicTypeExprFromDb(e)
    or
    result = convertEditorPlaceholderExprFromDb(e)
    or
    result = convertEnumIsCaseExprFromDb(e)
    or
    result = convertErrorExprFromDb(e)
    or
    result = convertExplicitCastExprFromDb(e)
    or
    result = convertForceValueExprFromDb(e)
    or
    result = convertIdentityExprFromDb(e)
    or
    result = convertIfExprFromDb(e)
    or
    result = convertImplicitConversionExprFromDb(e)
    or
    result = convertInOutExprFromDb(e)
    or
    result = convertKeyPathApplicationExprFromDb(e)
    or
    result = convertKeyPathDotExprFromDb(e)
    or
    result = convertKeyPathExprFromDb(e)
    or
    result = convertLazyInitializerExprFromDb(e)
    or
    result = convertLiteralExprFromDb(e)
    or
    result = convertLookupExprFromDb(e)
    or
    result = convertMakeTemporarilyEscapableExprFromDb(e)
    or
    result = convertObjCSelectorExprFromDb(e)
    or
    result = convertOneWayExprFromDb(e)
    or
    result = convertOpaqueValueExprFromDb(e)
    or
    result = convertOpenExistentialExprFromDb(e)
    or
    result = convertOptionalEvaluationExprFromDb(e)
    or
    result = convertOtherConstructorDeclRefExprFromDb(e)
    or
    result = convertOverloadSetRefExprFromDb(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprFromDb(e)
    or
    result = convertRebindSelfInConstructorExprFromDb(e)
    or
    result = convertSequenceExprFromDb(e)
    or
    result = convertSuperRefExprFromDb(e)
    or
    result = convertTapExprFromDb(e)
    or
    result = convertTupleElementExprFromDb(e)
    or
    result = convertTupleExprFromDb(e)
    or
    result = convertTypeExprFromDb(e)
    or
    result = convertUnresolvedDeclRefExprFromDb(e)
    or
    result = convertUnresolvedDotExprFromDb(e)
    or
    result = convertUnresolvedMemberExprFromDb(e)
    or
    result = convertUnresolvedPatternExprFromDb(e)
    or
    result = convertUnresolvedSpecializeExprFromDb(e)
    or
    result = convertVarargExpansionExprFromDb(e)
  }

  cached
  TIdentityExpr convertIdentityExprFromDb(Raw::Element e) {
    result = convertAwaitExprFromDb(e)
    or
    result = convertDotSelfExprFromDb(e)
    or
    result = convertParenExprFromDb(e)
    or
    result = convertUnresolvedMemberChainResultExprFromDb(e)
  }

  cached
  TImplicitConversionExpr convertImplicitConversionExprFromDb(Raw::Element e) {
    result = convertAnyHashableErasureExprFromDb(e)
    or
    result = convertArchetypeToSuperExprFromDb(e)
    or
    result = convertArrayToPointerExprFromDb(e)
    or
    result = convertBridgeFromObjCExprFromDb(e)
    or
    result = convertBridgeToObjCExprFromDb(e)
    or
    result = convertClassMetatypeToObjectExprFromDb(e)
    or
    result = convertCollectionUpcastConversionExprFromDb(e)
    or
    result = convertConditionalBridgeFromObjCExprFromDb(e)
    or
    result = convertCovariantFunctionConversionExprFromDb(e)
    or
    result = convertCovariantReturnConversionExprFromDb(e)
    or
    result = convertDerivedToBaseExprFromDb(e)
    or
    result = convertDestructureTupleExprFromDb(e)
    or
    result = convertDifferentiableFunctionExprFromDb(e)
    or
    result = convertDifferentiableFunctionExtractOriginalExprFromDb(e)
    or
    result = convertErasureExprFromDb(e)
    or
    result = convertExistentialMetatypeToObjectExprFromDb(e)
    or
    result = convertForeignObjectConversionExprFromDb(e)
    or
    result = convertFunctionConversionExprFromDb(e)
    or
    result = convertInOutToPointerExprFromDb(e)
    or
    result = convertInjectIntoOptionalExprFromDb(e)
    or
    result = convertLinearFunctionExprFromDb(e)
    or
    result = convertLinearFunctionExtractOriginalExprFromDb(e)
    or
    result = convertLinearToDifferentiableFunctionExprFromDb(e)
    or
    result = convertLoadExprFromDb(e)
    or
    result = convertMetatypeConversionExprFromDb(e)
    or
    result = convertPointerToPointerExprFromDb(e)
    or
    result = convertProtocolMetatypeToObjectExprFromDb(e)
    or
    result = convertStringToPointerExprFromDb(e)
    or
    result = convertUnderlyingToOpaqueExprFromDb(e)
    or
    result = convertUnevaluatedInstanceExprFromDb(e)
    or
    result = convertUnresolvedTypeConversionExprFromDb(e)
  }

  cached
  TLiteralExpr convertLiteralExprFromDb(Raw::Element e) {
    result = convertBuiltinLiteralExprFromDb(e)
    or
    result = convertInterpolatedStringLiteralExprFromDb(e)
    or
    result = convertNilLiteralExprFromDb(e)
    or
    result = convertObjectLiteralExprFromDb(e)
    or
    result = convertRegexLiteralExprFromDb(e)
  }

  cached
  TLookupExpr convertLookupExprFromDb(Raw::Element e) {
    result = convertDynamicLookupExprFromDb(e)
    or
    result = convertMemberRefExprFromDb(e)
    or
    result = convertSubscriptExprFromDb(e)
  }

  cached
  TNumberLiteralExpr convertNumberLiteralExprFromDb(Raw::Element e) {
    result = convertFloatLiteralExprFromDb(e)
    or
    result = convertIntegerLiteralExprFromDb(e)
  }

  cached
  TOverloadSetRefExpr convertOverloadSetRefExprFromDb(Raw::Element e) {
    result = convertOverloadedDeclRefExprFromDb(e)
  }

  cached
  TSelfApplyExpr convertSelfApplyExprFromDb(Raw::Element e) {
    result = convertConstructorRefCallExprFromDb(e)
    or
    result = convertDotSyntaxCallExprFromDb(e)
  }

  cached
  TPattern convertPatternFromDb(Raw::Element e) {
    result = convertAnyPatternFromDb(e)
    or
    result = convertBindingPatternFromDb(e)
    or
    result = convertBoolPatternFromDb(e)
    or
    result = convertEnumElementPatternFromDb(e)
    or
    result = convertExprPatternFromDb(e)
    or
    result = convertIsPatternFromDb(e)
    or
    result = convertNamedPatternFromDb(e)
    or
    result = convertOptionalSomePatternFromDb(e)
    or
    result = convertParenPatternFromDb(e)
    or
    result = convertTuplePatternFromDb(e)
    or
    result = convertTypedPatternFromDb(e)
  }

  cached
  TLabeledConditionalStmt convertLabeledConditionalStmtFromDb(Raw::Element e) {
    result = convertGuardStmtFromDb(e)
    or
    result = convertIfStmtFromDb(e)
    or
    result = convertWhileStmtFromDb(e)
  }

  cached
  TLabeledStmt convertLabeledStmtFromDb(Raw::Element e) {
    result = convertDoCatchStmtFromDb(e)
    or
    result = convertDoStmtFromDb(e)
    or
    result = convertForEachStmtFromDb(e)
    or
    result = convertLabeledConditionalStmtFromDb(e)
    or
    result = convertRepeatWhileStmtFromDb(e)
    or
    result = convertSwitchStmtFromDb(e)
  }

  cached
  TStmt convertStmtFromDb(Raw::Element e) {
    result = convertBraceStmtFromDb(e)
    or
    result = convertBreakStmtFromDb(e)
    or
    result = convertCaseStmtFromDb(e)
    or
    result = convertContinueStmtFromDb(e)
    or
    result = convertDeferStmtFromDb(e)
    or
    result = convertFailStmtFromDb(e)
    or
    result = convertFallthroughStmtFromDb(e)
    or
    result = convertLabeledStmtFromDb(e)
    or
    result = convertPoundAssertStmtFromDb(e)
    or
    result = convertReturnStmtFromDb(e)
    or
    result = convertThrowStmtFromDb(e)
    or
    result = convertYieldStmtFromDb(e)
  }

  cached
  TAnyBuiltinIntegerType convertAnyBuiltinIntegerTypeFromDb(Raw::Element e) {
    result = convertBuiltinIntegerLiteralTypeFromDb(e)
    or
    result = convertBuiltinIntegerTypeFromDb(e)
  }

  cached
  TAnyFunctionType convertAnyFunctionTypeFromDb(Raw::Element e) {
    result = convertFunctionTypeFromDb(e)
    or
    result = convertGenericFunctionTypeFromDb(e)
  }

  cached
  TAnyGenericType convertAnyGenericTypeFromDb(Raw::Element e) {
    result = convertNominalOrBoundGenericNominalTypeFromDb(e)
    or
    result = convertUnboundGenericTypeFromDb(e)
  }

  cached
  TAnyMetatypeType convertAnyMetatypeTypeFromDb(Raw::Element e) {
    result = convertExistentialMetatypeTypeFromDb(e)
    or
    result = convertMetatypeTypeFromDb(e)
  }

  cached
  TArchetypeType convertArchetypeTypeFromDb(Raw::Element e) {
    result = convertNestedArchetypeTypeFromDb(e)
    or
    result = convertOpaqueTypeArchetypeTypeFromDb(e)
    or
    result = convertOpenedArchetypeTypeFromDb(e)
    or
    result = convertPrimaryArchetypeTypeFromDb(e)
    or
    result = convertSequenceArchetypeTypeFromDb(e)
  }

  cached
  TBoundGenericType convertBoundGenericTypeFromDb(Raw::Element e) {
    result = convertBoundGenericClassTypeFromDb(e)
    or
    result = convertBoundGenericEnumTypeFromDb(e)
    or
    result = convertBoundGenericStructTypeFromDb(e)
  }

  cached
  TBuiltinType convertBuiltinTypeFromDb(Raw::Element e) {
    result = convertAnyBuiltinIntegerTypeFromDb(e)
    or
    result = convertBuiltinBridgeObjectTypeFromDb(e)
    or
    result = convertBuiltinDefaultActorStorageTypeFromDb(e)
    or
    result = convertBuiltinExecutorTypeFromDb(e)
    or
    result = convertBuiltinFloatTypeFromDb(e)
    or
    result = convertBuiltinJobTypeFromDb(e)
    or
    result = convertBuiltinNativeObjectTypeFromDb(e)
    or
    result = convertBuiltinRawPointerTypeFromDb(e)
    or
    result = convertBuiltinRawUnsafeContinuationTypeFromDb(e)
    or
    result = convertBuiltinUnsafeValueBufferTypeFromDb(e)
    or
    result = convertBuiltinVectorTypeFromDb(e)
  }

  cached
  TNominalOrBoundGenericNominalType convertNominalOrBoundGenericNominalTypeFromDb(Raw::Element e) {
    result = convertBoundGenericTypeFromDb(e)
    or
    result = convertNominalTypeFromDb(e)
  }

  cached
  TNominalType convertNominalTypeFromDb(Raw::Element e) {
    result = convertClassTypeFromDb(e)
    or
    result = convertEnumTypeFromDb(e)
    or
    result = convertProtocolTypeFromDb(e)
    or
    result = convertStructTypeFromDb(e)
  }

  cached
  TReferenceStorageType convertReferenceStorageTypeFromDb(Raw::Element e) {
    result = convertUnmanagedStorageTypeFromDb(e)
    or
    result = convertUnownedStorageTypeFromDb(e)
    or
    result = convertWeakStorageTypeFromDb(e)
  }

  cached
  TSubstitutableType convertSubstitutableTypeFromDb(Raw::Element e) {
    result = convertArchetypeTypeFromDb(e)
    or
    result = convertGenericTypeParamTypeFromDb(e)
  }

  cached
  TSugarType convertSugarTypeFromDb(Raw::Element e) {
    result = convertParenTypeFromDb(e)
    or
    result = convertSyntaxSugarTypeFromDb(e)
    or
    result = convertTypeAliasTypeFromDb(e)
  }

  cached
  TSyntaxSugarType convertSyntaxSugarTypeFromDb(Raw::Element e) {
    result = convertDictionaryTypeFromDb(e)
    or
    result = convertUnarySyntaxSugarTypeFromDb(e)
  }

  cached
  TType convertTypeFromDb(Raw::Element e) {
    result = convertAnyFunctionTypeFromDb(e)
    or
    result = convertAnyGenericTypeFromDb(e)
    or
    result = convertAnyMetatypeTypeFromDb(e)
    or
    result = convertBuiltinTypeFromDb(e)
    or
    result = convertDependentMemberTypeFromDb(e)
    or
    result = convertDynamicSelfTypeFromDb(e)
    or
    result = convertErrorTypeFromDb(e)
    or
    result = convertExistentialTypeFromDb(e)
    or
    result = convertInOutTypeFromDb(e)
    or
    result = convertLValueTypeFromDb(e)
    or
    result = convertModuleTypeFromDb(e)
    or
    result = convertPlaceholderTypeFromDb(e)
    or
    result = convertProtocolCompositionTypeFromDb(e)
    or
    result = convertReferenceStorageTypeFromDb(e)
    or
    result = convertSilBlockStorageTypeFromDb(e)
    or
    result = convertSilBoxTypeFromDb(e)
    or
    result = convertSilFunctionTypeFromDb(e)
    or
    result = convertSilTokenTypeFromDb(e)
    or
    result = convertSubstitutableTypeFromDb(e)
    or
    result = convertSugarTypeFromDb(e)
    or
    result = convertTupleTypeFromDb(e)
    or
    result = convertTypeVariableTypeFromDb(e)
    or
    result = convertUnresolvedTypeFromDb(e)
  }

  cached
  TUnarySyntaxSugarType convertUnarySyntaxSugarTypeFromDb(Raw::Element e) {
    result = convertArraySliceTypeFromDb(e)
    or
    result = convertOptionalTypeFromDb(e)
    or
    result = convertVariadicSequenceTypeFromDb(e)
  }

  cached
  Raw::Element convertCommentToDb(TComment e) { e = TComment(result) }

  cached
  Raw::Element convertDbFileToDb(TDbFile e) { e = TDbFile(result) }

  cached
  Raw::Element convertDbLocationToDb(TDbLocation e) { e = TDbLocation(result) }

  cached
  Raw::Element convertUnknownFileToDb(TUnknownFile e) { none() }

  cached
  Raw::Element convertUnknownLocationToDb(TUnknownLocation e) { none() }

  cached
  Raw::Element convertAccessorDeclToDb(TAccessorDecl e) { e = TAccessorDecl(result) }

  cached
  Raw::Element convertAssociatedTypeDeclToDb(TAssociatedTypeDecl e) {
    e = TAssociatedTypeDecl(result)
  }

  cached
  Raw::Element convertClassDeclToDb(TClassDecl e) { e = TClassDecl(result) }

  cached
  Raw::Element convertConcreteFuncDeclToDb(TConcreteFuncDecl e) { e = TConcreteFuncDecl(result) }

  cached
  Raw::Element convertConcreteVarDeclToDb(TConcreteVarDecl e) { e = TConcreteVarDecl(result) }

  cached
  Raw::Element convertConstructorDeclToDb(TConstructorDecl e) { e = TConstructorDecl(result) }

  cached
  Raw::Element convertDestructorDeclToDb(TDestructorDecl e) { e = TDestructorDecl(result) }

  cached
  Raw::Element convertEnumCaseDeclToDb(TEnumCaseDecl e) { e = TEnumCaseDecl(result) }

  cached
  Raw::Element convertEnumDeclToDb(TEnumDecl e) { e = TEnumDecl(result) }

  cached
  Raw::Element convertEnumElementDeclToDb(TEnumElementDecl e) { e = TEnumElementDecl(result) }

  cached
  Raw::Element convertExtensionDeclToDb(TExtensionDecl e) { e = TExtensionDecl(result) }

  cached
  Raw::Element convertGenericTypeParamDeclToDb(TGenericTypeParamDecl e) {
    e = TGenericTypeParamDecl(result)
  }

  cached
  Raw::Element convertIfConfigClauseToDb(TIfConfigClause e) { e = TIfConfigClause(result) }

  cached
  Raw::Element convertIfConfigDeclToDb(TIfConfigDecl e) { e = TIfConfigDecl(result) }

  cached
  Raw::Element convertImportDeclToDb(TImportDecl e) { e = TImportDecl(result) }

  cached
  Raw::Element convertInfixOperatorDeclToDb(TInfixOperatorDecl e) { e = TInfixOperatorDecl(result) }

  cached
  Raw::Element convertMissingMemberDeclToDb(TMissingMemberDecl e) { e = TMissingMemberDecl(result) }

  cached
  Raw::Element convertModuleDeclToDb(TModuleDecl e) { e = TModuleDecl(result) }

  cached
  Raw::Element convertOpaqueTypeDeclToDb(TOpaqueTypeDecl e) { e = TOpaqueTypeDecl(result) }

  cached
  Raw::Element convertParamDeclToDb(TParamDecl e) { e = TParamDecl(result) }

  cached
  Raw::Element convertPatternBindingDeclToDb(TPatternBindingDecl e) {
    e = TPatternBindingDecl(result)
  }

  cached
  Raw::Element convertPostfixOperatorDeclToDb(TPostfixOperatorDecl e) {
    e = TPostfixOperatorDecl(result)
  }

  cached
  Raw::Element convertPoundDiagnosticDeclToDb(TPoundDiagnosticDecl e) {
    e = TPoundDiagnosticDecl(result)
  }

  cached
  Raw::Element convertPrecedenceGroupDeclToDb(TPrecedenceGroupDecl e) {
    e = TPrecedenceGroupDecl(result)
  }

  cached
  Raw::Element convertPrefixOperatorDeclToDb(TPrefixOperatorDecl e) {
    e = TPrefixOperatorDecl(result)
  }

  cached
  Raw::Element convertProtocolDeclToDb(TProtocolDecl e) { e = TProtocolDecl(result) }

  cached
  Raw::Element convertStructDeclToDb(TStructDecl e) { e = TStructDecl(result) }

  cached
  Raw::Element convertSubscriptDeclToDb(TSubscriptDecl e) { e = TSubscriptDecl(result) }

  cached
  Raw::Element convertTopLevelCodeDeclToDb(TTopLevelCodeDecl e) { e = TTopLevelCodeDecl(result) }

  cached
  Raw::Element convertTypeAliasDeclToDb(TTypeAliasDecl e) { e = TTypeAliasDecl(result) }

  cached
  Raw::Element convertAnyHashableErasureExprToDb(TAnyHashableErasureExpr e) {
    e = TAnyHashableErasureExpr(result)
  }

  cached
  Raw::Element convertAppliedPropertyWrapperExprToDb(TAppliedPropertyWrapperExpr e) {
    e = TAppliedPropertyWrapperExpr(result)
  }

  cached
  Raw::Element convertArchetypeToSuperExprToDb(TArchetypeToSuperExpr e) {
    e = TArchetypeToSuperExpr(result)
  }

  cached
  Raw::Element convertArgumentToDb(TArgument e) { e = TArgument(result) }

  cached
  Raw::Element convertArrayExprToDb(TArrayExpr e) { e = TArrayExpr(result) }

  cached
  Raw::Element convertArrayToPointerExprToDb(TArrayToPointerExpr e) {
    e = TArrayToPointerExpr(result)
  }

  cached
  Raw::Element convertArrowExprToDb(TArrowExpr e) { e = TArrowExpr(result) }

  cached
  Raw::Element convertAssignExprToDb(TAssignExpr e) { e = TAssignExpr(result) }

  cached
  Raw::Element convertAutoClosureExprToDb(TAutoClosureExpr e) { e = TAutoClosureExpr(result) }

  cached
  Raw::Element convertAwaitExprToDb(TAwaitExpr e) { e = TAwaitExpr(result) }

  cached
  Raw::Element convertBinaryExprToDb(TBinaryExpr e) { e = TBinaryExpr(result) }

  cached
  Raw::Element convertBindOptionalExprToDb(TBindOptionalExpr e) { e = TBindOptionalExpr(result) }

  cached
  Raw::Element convertBooleanLiteralExprToDb(TBooleanLiteralExpr e) {
    e = TBooleanLiteralExpr(result)
  }

  cached
  Raw::Element convertBridgeFromObjCExprToDb(TBridgeFromObjCExpr e) {
    e = TBridgeFromObjCExpr(result)
  }

  cached
  Raw::Element convertBridgeToObjCExprToDb(TBridgeToObjCExpr e) { e = TBridgeToObjCExpr(result) }

  cached
  Raw::Element convertCallExprToDb(TCallExpr e) { e = TCallExpr(result) }

  cached
  Raw::Element convertCaptureListExprToDb(TCaptureListExpr e) { e = TCaptureListExpr(result) }

  cached
  Raw::Element convertClassMetatypeToObjectExprToDb(TClassMetatypeToObjectExpr e) {
    e = TClassMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertClosureExprToDb(TClosureExpr e) { e = TClosureExpr(result) }

  cached
  Raw::Element convertCodeCompletionExprToDb(TCodeCompletionExpr e) {
    e = TCodeCompletionExpr(result)
  }

  cached
  Raw::Element convertCoerceExprToDb(TCoerceExpr e) { e = TCoerceExpr(result) }

  cached
  Raw::Element convertCollectionUpcastConversionExprToDb(TCollectionUpcastConversionExpr e) {
    e = TCollectionUpcastConversionExpr(result)
  }

  cached
  Raw::Element convertConditionalBridgeFromObjCExprToDb(TConditionalBridgeFromObjCExpr e) {
    e = TConditionalBridgeFromObjCExpr(result)
  }

  cached
  Raw::Element convertConditionalCheckedCastExprToDb(TConditionalCheckedCastExpr e) {
    e = TConditionalCheckedCastExpr(result)
  }

  cached
  Raw::Element convertConstructorRefCallExprToDb(TConstructorRefCallExpr e) {
    e = TConstructorRefCallExpr(result)
  }

  cached
  Raw::Element convertCovariantFunctionConversionExprToDb(TCovariantFunctionConversionExpr e) {
    e = TCovariantFunctionConversionExpr(result)
  }

  cached
  Raw::Element convertCovariantReturnConversionExprToDb(TCovariantReturnConversionExpr e) {
    e = TCovariantReturnConversionExpr(result)
  }

  cached
  Raw::Element convertDeclRefExprToDb(TDeclRefExpr e) { e = TDeclRefExpr(result) }

  cached
  Raw::Element convertDefaultArgumentExprToDb(TDefaultArgumentExpr e) {
    e = TDefaultArgumentExpr(result)
  }

  cached
  Raw::Element convertDerivedToBaseExprToDb(TDerivedToBaseExpr e) { e = TDerivedToBaseExpr(result) }

  cached
  Raw::Element convertDestructureTupleExprToDb(TDestructureTupleExpr e) {
    e = TDestructureTupleExpr(result)
  }

  cached
  Raw::Element convertDictionaryExprToDb(TDictionaryExpr e) { e = TDictionaryExpr(result) }

  cached
  Raw::Element convertDifferentiableFunctionExprToDb(TDifferentiableFunctionExpr e) {
    e = TDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element convertDifferentiableFunctionExtractOriginalExprToDb(
    TDifferentiableFunctionExtractOriginalExpr e
  ) {
    e = TDifferentiableFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element convertDiscardAssignmentExprToDb(TDiscardAssignmentExpr e) {
    e = TDiscardAssignmentExpr(result)
  }

  cached
  Raw::Element convertDotSelfExprToDb(TDotSelfExpr e) { e = TDotSelfExpr(result) }

  cached
  Raw::Element convertDotSyntaxBaseIgnoredExprToDb(TDotSyntaxBaseIgnoredExpr e) {
    e = TDotSyntaxBaseIgnoredExpr(result)
  }

  cached
  Raw::Element convertDotSyntaxCallExprToDb(TDotSyntaxCallExpr e) { e = TDotSyntaxCallExpr(result) }

  cached
  Raw::Element convertDynamicMemberRefExprToDb(TDynamicMemberRefExpr e) {
    e = TDynamicMemberRefExpr(result)
  }

  cached
  Raw::Element convertDynamicSubscriptExprToDb(TDynamicSubscriptExpr e) {
    e = TDynamicSubscriptExpr(result)
  }

  cached
  Raw::Element convertDynamicTypeExprToDb(TDynamicTypeExpr e) { e = TDynamicTypeExpr(result) }

  cached
  Raw::Element convertEditorPlaceholderExprToDb(TEditorPlaceholderExpr e) {
    e = TEditorPlaceholderExpr(result)
  }

  cached
  Raw::Element convertEnumIsCaseExprToDb(TEnumIsCaseExpr e) { e = TEnumIsCaseExpr(result) }

  cached
  Raw::Element convertErasureExprToDb(TErasureExpr e) { e = TErasureExpr(result) }

  cached
  Raw::Element convertErrorExprToDb(TErrorExpr e) { e = TErrorExpr(result) }

  cached
  Raw::Element convertExistentialMetatypeToObjectExprToDb(TExistentialMetatypeToObjectExpr e) {
    e = TExistentialMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertFloatLiteralExprToDb(TFloatLiteralExpr e) { e = TFloatLiteralExpr(result) }

  cached
  Raw::Element convertForceTryExprToDb(TForceTryExpr e) { e = TForceTryExpr(result) }

  cached
  Raw::Element convertForceValueExprToDb(TForceValueExpr e) { e = TForceValueExpr(result) }

  cached
  Raw::Element convertForcedCheckedCastExprToDb(TForcedCheckedCastExpr e) {
    e = TForcedCheckedCastExpr(result)
  }

  cached
  Raw::Element convertForeignObjectConversionExprToDb(TForeignObjectConversionExpr e) {
    e = TForeignObjectConversionExpr(result)
  }

  cached
  Raw::Element convertFunctionConversionExprToDb(TFunctionConversionExpr e) {
    e = TFunctionConversionExpr(result)
  }

  cached
  Raw::Element convertIfExprToDb(TIfExpr e) { e = TIfExpr(result) }

  cached
  Raw::Element convertInOutExprToDb(TInOutExpr e) { e = TInOutExpr(result) }

  cached
  Raw::Element convertInOutToPointerExprToDb(TInOutToPointerExpr e) {
    e = TInOutToPointerExpr(result)
  }

  cached
  Raw::Element convertInjectIntoOptionalExprToDb(TInjectIntoOptionalExpr e) {
    e = TInjectIntoOptionalExpr(result)
  }

  cached
  Raw::Element convertIntegerLiteralExprToDb(TIntegerLiteralExpr e) {
    e = TIntegerLiteralExpr(result)
  }

  cached
  Raw::Element convertInterpolatedStringLiteralExprToDb(TInterpolatedStringLiteralExpr e) {
    e = TInterpolatedStringLiteralExpr(result)
  }

  cached
  Raw::Element convertIsExprToDb(TIsExpr e) { e = TIsExpr(result) }

  cached
  Raw::Element convertKeyPathApplicationExprToDb(TKeyPathApplicationExpr e) {
    e = TKeyPathApplicationExpr(result)
  }

  cached
  Raw::Element convertKeyPathDotExprToDb(TKeyPathDotExpr e) { e = TKeyPathDotExpr(result) }

  cached
  Raw::Element convertKeyPathExprToDb(TKeyPathExpr e) { e = TKeyPathExpr(result) }

  cached
  Raw::Element convertLazyInitializerExprToDb(TLazyInitializerExpr e) {
    e = TLazyInitializerExpr(result)
  }

  cached
  Raw::Element convertLinearFunctionExprToDb(TLinearFunctionExpr e) {
    e = TLinearFunctionExpr(result)
  }

  cached
  Raw::Element convertLinearFunctionExtractOriginalExprToDb(TLinearFunctionExtractOriginalExpr e) {
    e = TLinearFunctionExtractOriginalExpr(result)
  }

  cached
  Raw::Element convertLinearToDifferentiableFunctionExprToDb(TLinearToDifferentiableFunctionExpr e) {
    e = TLinearToDifferentiableFunctionExpr(result)
  }

  cached
  Raw::Element convertLoadExprToDb(TLoadExpr e) { e = TLoadExpr(result) }

  cached
  Raw::Element convertMagicIdentifierLiteralExprToDb(TMagicIdentifierLiteralExpr e) {
    e = TMagicIdentifierLiteralExpr(result)
  }

  cached
  Raw::Element convertMakeTemporarilyEscapableExprToDb(TMakeTemporarilyEscapableExpr e) {
    e = TMakeTemporarilyEscapableExpr(result)
  }

  cached
  Raw::Element convertMemberRefExprToDb(TMemberRefExpr e) { e = TMemberRefExpr(result) }

  cached
  Raw::Element convertMetatypeConversionExprToDb(TMetatypeConversionExpr e) {
    e = TMetatypeConversionExpr(result)
  }

  cached
  Raw::Element convertNilLiteralExprToDb(TNilLiteralExpr e) { e = TNilLiteralExpr(result) }

  cached
  Raw::Element convertObjCSelectorExprToDb(TObjCSelectorExpr e) { e = TObjCSelectorExpr(result) }

  cached
  Raw::Element convertObjectLiteralExprToDb(TObjectLiteralExpr e) { e = TObjectLiteralExpr(result) }

  cached
  Raw::Element convertOneWayExprToDb(TOneWayExpr e) { e = TOneWayExpr(result) }

  cached
  Raw::Element convertOpaqueValueExprToDb(TOpaqueValueExpr e) { e = TOpaqueValueExpr(result) }

  cached
  Raw::Element convertOpenExistentialExprToDb(TOpenExistentialExpr e) {
    e = TOpenExistentialExpr(result)
  }

  cached
  Raw::Element convertOptionalEvaluationExprToDb(TOptionalEvaluationExpr e) {
    e = TOptionalEvaluationExpr(result)
  }

  cached
  Raw::Element convertOptionalTryExprToDb(TOptionalTryExpr e) { e = TOptionalTryExpr(result) }

  cached
  Raw::Element convertOtherConstructorDeclRefExprToDb(TOtherConstructorDeclRefExpr e) {
    e = TOtherConstructorDeclRefExpr(result)
  }

  cached
  Raw::Element convertOverloadedDeclRefExprToDb(TOverloadedDeclRefExpr e) {
    e = TOverloadedDeclRefExpr(result)
  }

  cached
  Raw::Element convertParenExprToDb(TParenExpr e) { e = TParenExpr(result) }

  cached
  Raw::Element convertPointerToPointerExprToDb(TPointerToPointerExpr e) {
    e = TPointerToPointerExpr(result)
  }

  cached
  Raw::Element convertPostfixUnaryExprToDb(TPostfixUnaryExpr e) { e = TPostfixUnaryExpr(result) }

  cached
  Raw::Element convertPrefixUnaryExprToDb(TPrefixUnaryExpr e) { e = TPrefixUnaryExpr(result) }

  cached
  Raw::Element convertPropertyWrapperValuePlaceholderExprToDb(TPropertyWrapperValuePlaceholderExpr e) {
    e = TPropertyWrapperValuePlaceholderExpr(result)
  }

  cached
  Raw::Element convertProtocolMetatypeToObjectExprToDb(TProtocolMetatypeToObjectExpr e) {
    e = TProtocolMetatypeToObjectExpr(result)
  }

  cached
  Raw::Element convertRebindSelfInConstructorExprToDb(TRebindSelfInConstructorExpr e) {
    e = TRebindSelfInConstructorExpr(result)
  }

  cached
  Raw::Element convertRegexLiteralExprToDb(TRegexLiteralExpr e) { e = TRegexLiteralExpr(result) }

  cached
  Raw::Element convertSequenceExprToDb(TSequenceExpr e) { e = TSequenceExpr(result) }

  cached
  Raw::Element convertStringLiteralExprToDb(TStringLiteralExpr e) { e = TStringLiteralExpr(result) }

  cached
  Raw::Element convertStringToPointerExprToDb(TStringToPointerExpr e) {
    e = TStringToPointerExpr(result)
  }

  cached
  Raw::Element convertSubscriptExprToDb(TSubscriptExpr e) { e = TSubscriptExpr(result) }

  cached
  Raw::Element convertSuperRefExprToDb(TSuperRefExpr e) { e = TSuperRefExpr(result) }

  cached
  Raw::Element convertTapExprToDb(TTapExpr e) { e = TTapExpr(result) }

  cached
  Raw::Element convertTryExprToDb(TTryExpr e) { e = TTryExpr(result) }

  cached
  Raw::Element convertTupleElementExprToDb(TTupleElementExpr e) { e = TTupleElementExpr(result) }

  cached
  Raw::Element convertTupleExprToDb(TTupleExpr e) { e = TTupleExpr(result) }

  cached
  Raw::Element convertTypeExprToDb(TTypeExpr e) { e = TTypeExpr(result) }

  cached
  Raw::Element convertUnderlyingToOpaqueExprToDb(TUnderlyingToOpaqueExpr e) {
    e = TUnderlyingToOpaqueExpr(result)
  }

  cached
  Raw::Element convertUnevaluatedInstanceExprToDb(TUnevaluatedInstanceExpr e) {
    e = TUnevaluatedInstanceExpr(result)
  }

  cached
  Raw::Element convertUnresolvedDeclRefExprToDb(TUnresolvedDeclRefExpr e) {
    e = TUnresolvedDeclRefExpr(result)
  }

  cached
  Raw::Element convertUnresolvedDotExprToDb(TUnresolvedDotExpr e) { e = TUnresolvedDotExpr(result) }

  cached
  Raw::Element convertUnresolvedMemberChainResultExprToDb(TUnresolvedMemberChainResultExpr e) {
    e = TUnresolvedMemberChainResultExpr(result)
  }

  cached
  Raw::Element convertUnresolvedMemberExprToDb(TUnresolvedMemberExpr e) {
    e = TUnresolvedMemberExpr(result)
  }

  cached
  Raw::Element convertUnresolvedPatternExprToDb(TUnresolvedPatternExpr e) {
    e = TUnresolvedPatternExpr(result)
  }

  cached
  Raw::Element convertUnresolvedSpecializeExprToDb(TUnresolvedSpecializeExpr e) {
    e = TUnresolvedSpecializeExpr(result)
  }

  cached
  Raw::Element convertUnresolvedTypeConversionExprToDb(TUnresolvedTypeConversionExpr e) {
    e = TUnresolvedTypeConversionExpr(result)
  }

  cached
  Raw::Element convertVarargExpansionExprToDb(TVarargExpansionExpr e) {
    e = TVarargExpansionExpr(result)
  }

  cached
  Raw::Element convertAnyPatternToDb(TAnyPattern e) { e = TAnyPattern(result) }

  cached
  Raw::Element convertBindingPatternToDb(TBindingPattern e) { e = TBindingPattern(result) }

  cached
  Raw::Element convertBoolPatternToDb(TBoolPattern e) { e = TBoolPattern(result) }

  cached
  Raw::Element convertEnumElementPatternToDb(TEnumElementPattern e) {
    e = TEnumElementPattern(result)
  }

  cached
  Raw::Element convertExprPatternToDb(TExprPattern e) { e = TExprPattern(result) }

  cached
  Raw::Element convertIsPatternToDb(TIsPattern e) { e = TIsPattern(result) }

  cached
  Raw::Element convertNamedPatternToDb(TNamedPattern e) { e = TNamedPattern(result) }

  cached
  Raw::Element convertOptionalSomePatternToDb(TOptionalSomePattern e) {
    e = TOptionalSomePattern(result)
  }

  cached
  Raw::Element convertParenPatternToDb(TParenPattern e) { e = TParenPattern(result) }

  cached
  Raw::Element convertTuplePatternToDb(TTuplePattern e) { e = TTuplePattern(result) }

  cached
  Raw::Element convertTypedPatternToDb(TTypedPattern e) { e = TTypedPattern(result) }

  cached
  Raw::Element convertBraceStmtToDb(TBraceStmt e) { e = TBraceStmt(result) }

  cached
  Raw::Element convertBreakStmtToDb(TBreakStmt e) { e = TBreakStmt(result) }

  cached
  Raw::Element convertCaseLabelItemToDb(TCaseLabelItem e) { e = TCaseLabelItem(result) }

  cached
  Raw::Element convertCaseStmtToDb(TCaseStmt e) { e = TCaseStmt(result) }

  cached
  Raw::Element convertConditionElementToDb(TConditionElement e) { e = TConditionElement(result) }

  cached
  Raw::Element convertContinueStmtToDb(TContinueStmt e) { e = TContinueStmt(result) }

  cached
  Raw::Element convertDeferStmtToDb(TDeferStmt e) { e = TDeferStmt(result) }

  cached
  Raw::Element convertDoCatchStmtToDb(TDoCatchStmt e) { e = TDoCatchStmt(result) }

  cached
  Raw::Element convertDoStmtToDb(TDoStmt e) { e = TDoStmt(result) }

  cached
  Raw::Element convertFailStmtToDb(TFailStmt e) { e = TFailStmt(result) }

  cached
  Raw::Element convertFallthroughStmtToDb(TFallthroughStmt e) { e = TFallthroughStmt(result) }

  cached
  Raw::Element convertForEachStmtToDb(TForEachStmt e) { e = TForEachStmt(result) }

  cached
  Raw::Element convertGuardStmtToDb(TGuardStmt e) { e = TGuardStmt(result) }

  cached
  Raw::Element convertIfStmtToDb(TIfStmt e) { e = TIfStmt(result) }

  cached
  Raw::Element convertPoundAssertStmtToDb(TPoundAssertStmt e) { e = TPoundAssertStmt(result) }

  cached
  Raw::Element convertRepeatWhileStmtToDb(TRepeatWhileStmt e) { e = TRepeatWhileStmt(result) }

  cached
  Raw::Element convertReturnStmtToDb(TReturnStmt e) { e = TReturnStmt(result) }

  cached
  Raw::Element convertStmtConditionToDb(TStmtCondition e) { e = TStmtCondition(result) }

  cached
  Raw::Element convertSwitchStmtToDb(TSwitchStmt e) { e = TSwitchStmt(result) }

  cached
  Raw::Element convertThrowStmtToDb(TThrowStmt e) { e = TThrowStmt(result) }

  cached
  Raw::Element convertWhileStmtToDb(TWhileStmt e) { e = TWhileStmt(result) }

  cached
  Raw::Element convertYieldStmtToDb(TYieldStmt e) { e = TYieldStmt(result) }

  cached
  Raw::Element convertArraySliceTypeToDb(TArraySliceType e) { e = TArraySliceType(result) }

  cached
  Raw::Element convertBoundGenericClassTypeToDb(TBoundGenericClassType e) {
    e = TBoundGenericClassType(result)
  }

  cached
  Raw::Element convertBoundGenericEnumTypeToDb(TBoundGenericEnumType e) {
    e = TBoundGenericEnumType(result)
  }

  cached
  Raw::Element convertBoundGenericStructTypeToDb(TBoundGenericStructType e) {
    e = TBoundGenericStructType(result)
  }

  cached
  Raw::Element convertBuiltinBridgeObjectTypeToDb(TBuiltinBridgeObjectType e) {
    e = TBuiltinBridgeObjectType(result)
  }

  cached
  Raw::Element convertBuiltinDefaultActorStorageTypeToDb(TBuiltinDefaultActorStorageType e) {
    e = TBuiltinDefaultActorStorageType(result)
  }

  cached
  Raw::Element convertBuiltinExecutorTypeToDb(TBuiltinExecutorType e) {
    e = TBuiltinExecutorType(result)
  }

  cached
  Raw::Element convertBuiltinFloatTypeToDb(TBuiltinFloatType e) { e = TBuiltinFloatType(result) }

  cached
  Raw::Element convertBuiltinIntegerLiteralTypeToDb(TBuiltinIntegerLiteralType e) {
    e = TBuiltinIntegerLiteralType(result)
  }

  cached
  Raw::Element convertBuiltinIntegerTypeToDb(TBuiltinIntegerType e) {
    e = TBuiltinIntegerType(result)
  }

  cached
  Raw::Element convertBuiltinJobTypeToDb(TBuiltinJobType e) { e = TBuiltinJobType(result) }

  cached
  Raw::Element convertBuiltinNativeObjectTypeToDb(TBuiltinNativeObjectType e) {
    e = TBuiltinNativeObjectType(result)
  }

  cached
  Raw::Element convertBuiltinRawPointerTypeToDb(TBuiltinRawPointerType e) {
    e = TBuiltinRawPointerType(result)
  }

  cached
  Raw::Element convertBuiltinRawUnsafeContinuationTypeToDb(TBuiltinRawUnsafeContinuationType e) {
    e = TBuiltinRawUnsafeContinuationType(result)
  }

  cached
  Raw::Element convertBuiltinUnsafeValueBufferTypeToDb(TBuiltinUnsafeValueBufferType e) {
    e = TBuiltinUnsafeValueBufferType(result)
  }

  cached
  Raw::Element convertBuiltinVectorTypeToDb(TBuiltinVectorType e) { e = TBuiltinVectorType(result) }

  cached
  Raw::Element convertClassTypeToDb(TClassType e) { e = TClassType(result) }

  cached
  Raw::Element convertDependentMemberTypeToDb(TDependentMemberType e) {
    e = TDependentMemberType(result)
  }

  cached
  Raw::Element convertDictionaryTypeToDb(TDictionaryType e) { e = TDictionaryType(result) }

  cached
  Raw::Element convertDynamicSelfTypeToDb(TDynamicSelfType e) { e = TDynamicSelfType(result) }

  cached
  Raw::Element convertEnumTypeToDb(TEnumType e) { e = TEnumType(result) }

  cached
  Raw::Element convertErrorTypeToDb(TErrorType e) { e = TErrorType(result) }

  cached
  Raw::Element convertExistentialMetatypeTypeToDb(TExistentialMetatypeType e) {
    e = TExistentialMetatypeType(result)
  }

  cached
  Raw::Element convertExistentialTypeToDb(TExistentialType e) { e = TExistentialType(result) }

  cached
  Raw::Element convertFunctionTypeToDb(TFunctionType e) { e = TFunctionType(result) }

  cached
  Raw::Element convertGenericFunctionTypeToDb(TGenericFunctionType e) {
    e = TGenericFunctionType(result)
  }

  cached
  Raw::Element convertGenericTypeParamTypeToDb(TGenericTypeParamType e) {
    e = TGenericTypeParamType(result)
  }

  cached
  Raw::Element convertInOutTypeToDb(TInOutType e) { e = TInOutType(result) }

  cached
  Raw::Element convertLValueTypeToDb(TLValueType e) { e = TLValueType(result) }

  cached
  Raw::Element convertMetatypeTypeToDb(TMetatypeType e) { e = TMetatypeType(result) }

  cached
  Raw::Element convertModuleTypeToDb(TModuleType e) { e = TModuleType(result) }

  cached
  Raw::Element convertNestedArchetypeTypeToDb(TNestedArchetypeType e) {
    e = TNestedArchetypeType(result)
  }

  cached
  Raw::Element convertOpaqueTypeArchetypeTypeToDb(TOpaqueTypeArchetypeType e) {
    e = TOpaqueTypeArchetypeType(result)
  }

  cached
  Raw::Element convertOpenedArchetypeTypeToDb(TOpenedArchetypeType e) {
    e = TOpenedArchetypeType(result)
  }

  cached
  Raw::Element convertOptionalTypeToDb(TOptionalType e) { e = TOptionalType(result) }

  cached
  Raw::Element convertParenTypeToDb(TParenType e) { e = TParenType(result) }

  cached
  Raw::Element convertPlaceholderTypeToDb(TPlaceholderType e) { e = TPlaceholderType(result) }

  cached
  Raw::Element convertPrimaryArchetypeTypeToDb(TPrimaryArchetypeType e) {
    e = TPrimaryArchetypeType(result)
  }

  cached
  Raw::Element convertProtocolCompositionTypeToDb(TProtocolCompositionType e) {
    e = TProtocolCompositionType(result)
  }

  cached
  Raw::Element convertProtocolTypeToDb(TProtocolType e) { e = TProtocolType(result) }

  cached
  Raw::Element convertSequenceArchetypeTypeToDb(TSequenceArchetypeType e) {
    e = TSequenceArchetypeType(result)
  }

  cached
  Raw::Element convertSilBlockStorageTypeToDb(TSilBlockStorageType e) {
    e = TSilBlockStorageType(result)
  }

  cached
  Raw::Element convertSilBoxTypeToDb(TSilBoxType e) { e = TSilBoxType(result) }

  cached
  Raw::Element convertSilFunctionTypeToDb(TSilFunctionType e) { e = TSilFunctionType(result) }

  cached
  Raw::Element convertSilTokenTypeToDb(TSilTokenType e) { e = TSilTokenType(result) }

  cached
  Raw::Element convertStructTypeToDb(TStructType e) { e = TStructType(result) }

  cached
  Raw::Element convertTupleTypeToDb(TTupleType e) { e = TTupleType(result) }

  cached
  Raw::Element convertTypeAliasTypeToDb(TTypeAliasType e) { e = TTypeAliasType(result) }

  cached
  Raw::Element convertTypeReprToDb(TTypeRepr e) { e = TTypeRepr(result) }

  cached
  Raw::Element convertTypeVariableTypeToDb(TTypeVariableType e) { e = TTypeVariableType(result) }

  cached
  Raw::Element convertUnboundGenericTypeToDb(TUnboundGenericType e) {
    e = TUnboundGenericType(result)
  }

  cached
  Raw::Element convertUnmanagedStorageTypeToDb(TUnmanagedStorageType e) {
    e = TUnmanagedStorageType(result)
  }

  cached
  Raw::Element convertUnownedStorageTypeToDb(TUnownedStorageType e) {
    e = TUnownedStorageType(result)
  }

  cached
  Raw::Element convertUnresolvedTypeToDb(TUnresolvedType e) { e = TUnresolvedType(result) }

  cached
  Raw::Element convertVariadicSequenceTypeToDb(TVariadicSequenceType e) {
    e = TVariadicSequenceType(result)
  }

  cached
  Raw::Element convertWeakStorageTypeToDb(TWeakStorageType e) { e = TWeakStorageType(result) }

  cached
  Raw::Element convertAstNodeToDb(TAstNode e) {
    result = convertCaseLabelItemToDb(e)
    or
    result = convertDeclToDb(e)
    or
    result = convertExprToDb(e)
    or
    result = convertPatternToDb(e)
    or
    result = convertStmtToDb(e)
    or
    result = convertStmtConditionToDb(e)
    or
    result = convertTypeReprToDb(e)
  }

  cached
  Raw::Element convertCallableToDb(TCallable e) {
    result = convertAbstractClosureExprToDb(e)
    or
    result = convertAbstractFunctionDeclToDb(e)
  }

  cached
  Raw::Element convertElementToDb(TElement e) {
    result = convertCallableToDb(e)
    or
    result = convertFileToDb(e)
    or
    result = convertGenericContextToDb(e)
    or
    result = convertIterableDeclContextToDb(e)
    or
    result = convertLocatableToDb(e)
    or
    result = convertLocationToDb(e)
    or
    result = convertTypeToDb(e)
  }

  cached
  Raw::Element convertFileToDb(TFile e) {
    result = convertDbFileToDb(e)
    or
    result = convertUnknownFileToDb(e)
  }

  cached
  Raw::Element convertLocatableToDb(TLocatable e) {
    result = convertArgumentToDb(e)
    or
    result = convertAstNodeToDb(e)
    or
    result = convertCommentToDb(e)
    or
    result = convertConditionElementToDb(e)
    or
    result = convertIfConfigClauseToDb(e)
  }

  cached
  Raw::Element convertLocationToDb(TLocation e) {
    result = convertDbLocationToDb(e)
    or
    result = convertUnknownLocationToDb(e)
  }

  cached
  Raw::Element convertAbstractFunctionDeclToDb(TAbstractFunctionDecl e) {
    result = convertConstructorDeclToDb(e)
    or
    result = convertDestructorDeclToDb(e)
    or
    result = convertFuncDeclToDb(e)
  }

  cached
  Raw::Element convertAbstractStorageDeclToDb(TAbstractStorageDecl e) {
    result = convertSubscriptDeclToDb(e)
    or
    result = convertVarDeclToDb(e)
  }

  cached
  Raw::Element convertAbstractTypeParamDeclToDb(TAbstractTypeParamDecl e) {
    result = convertAssociatedTypeDeclToDb(e)
    or
    result = convertGenericTypeParamDeclToDb(e)
  }

  cached
  Raw::Element convertDeclToDb(TDecl e) {
    result = convertEnumCaseDeclToDb(e)
    or
    result = convertExtensionDeclToDb(e)
    or
    result = convertIfConfigDeclToDb(e)
    or
    result = convertImportDeclToDb(e)
    or
    result = convertMissingMemberDeclToDb(e)
    or
    result = convertOperatorDeclToDb(e)
    or
    result = convertPatternBindingDeclToDb(e)
    or
    result = convertPoundDiagnosticDeclToDb(e)
    or
    result = convertPrecedenceGroupDeclToDb(e)
    or
    result = convertTopLevelCodeDeclToDb(e)
    or
    result = convertValueDeclToDb(e)
  }

  cached
  Raw::Element convertFuncDeclToDb(TFuncDecl e) {
    result = convertAccessorDeclToDb(e)
    or
    result = convertConcreteFuncDeclToDb(e)
  }

  cached
  Raw::Element convertGenericContextToDb(TGenericContext e) {
    result = convertAbstractFunctionDeclToDb(e)
    or
    result = convertExtensionDeclToDb(e)
    or
    result = convertGenericTypeDeclToDb(e)
    or
    result = convertSubscriptDeclToDb(e)
  }

  cached
  Raw::Element convertGenericTypeDeclToDb(TGenericTypeDecl e) {
    result = convertNominalTypeDeclToDb(e)
    or
    result = convertOpaqueTypeDeclToDb(e)
    or
    result = convertTypeAliasDeclToDb(e)
  }

  cached
  Raw::Element convertIterableDeclContextToDb(TIterableDeclContext e) {
    result = convertExtensionDeclToDb(e)
    or
    result = convertNominalTypeDeclToDb(e)
  }

  cached
  Raw::Element convertNominalTypeDeclToDb(TNominalTypeDecl e) {
    result = convertClassDeclToDb(e)
    or
    result = convertEnumDeclToDb(e)
    or
    result = convertProtocolDeclToDb(e)
    or
    result = convertStructDeclToDb(e)
  }

  cached
  Raw::Element convertOperatorDeclToDb(TOperatorDecl e) {
    result = convertInfixOperatorDeclToDb(e)
    or
    result = convertPostfixOperatorDeclToDb(e)
    or
    result = convertPrefixOperatorDeclToDb(e)
  }

  cached
  Raw::Element convertTypeDeclToDb(TTypeDecl e) {
    result = convertAbstractTypeParamDeclToDb(e)
    or
    result = convertGenericTypeDeclToDb(e)
    or
    result = convertModuleDeclToDb(e)
  }

  cached
  Raw::Element convertValueDeclToDb(TValueDecl e) {
    result = convertAbstractFunctionDeclToDb(e)
    or
    result = convertAbstractStorageDeclToDb(e)
    or
    result = convertEnumElementDeclToDb(e)
    or
    result = convertTypeDeclToDb(e)
  }

  cached
  Raw::Element convertVarDeclToDb(TVarDecl e) {
    result = convertConcreteVarDeclToDb(e)
    or
    result = convertParamDeclToDb(e)
  }

  cached
  Raw::Element convertAbstractClosureExprToDb(TAbstractClosureExpr e) {
    result = convertAutoClosureExprToDb(e)
    or
    result = convertClosureExprToDb(e)
  }

  cached
  Raw::Element convertAnyTryExprToDb(TAnyTryExpr e) {
    result = convertForceTryExprToDb(e)
    or
    result = convertOptionalTryExprToDb(e)
    or
    result = convertTryExprToDb(e)
  }

  cached
  Raw::Element convertApplyExprToDb(TApplyExpr e) {
    result = convertBinaryExprToDb(e)
    or
    result = convertCallExprToDb(e)
    or
    result = convertPostfixUnaryExprToDb(e)
    or
    result = convertPrefixUnaryExprToDb(e)
    or
    result = convertSelfApplyExprToDb(e)
  }

  cached
  Raw::Element convertBuiltinLiteralExprToDb(TBuiltinLiteralExpr e) {
    result = convertBooleanLiteralExprToDb(e)
    or
    result = convertMagicIdentifierLiteralExprToDb(e)
    or
    result = convertNumberLiteralExprToDb(e)
    or
    result = convertStringLiteralExprToDb(e)
  }

  cached
  Raw::Element convertCheckedCastExprToDb(TCheckedCastExpr e) {
    result = convertConditionalCheckedCastExprToDb(e)
    or
    result = convertForcedCheckedCastExprToDb(e)
    or
    result = convertIsExprToDb(e)
  }

  cached
  Raw::Element convertCollectionExprToDb(TCollectionExpr e) {
    result = convertArrayExprToDb(e)
    or
    result = convertDictionaryExprToDb(e)
  }

  cached
  Raw::Element convertDynamicLookupExprToDb(TDynamicLookupExpr e) {
    result = convertDynamicMemberRefExprToDb(e)
    or
    result = convertDynamicSubscriptExprToDb(e)
  }

  cached
  Raw::Element convertExplicitCastExprToDb(TExplicitCastExpr e) {
    result = convertCheckedCastExprToDb(e)
    or
    result = convertCoerceExprToDb(e)
  }

  cached
  Raw::Element convertExprToDb(TExpr e) {
    result = convertAbstractClosureExprToDb(e)
    or
    result = convertAnyTryExprToDb(e)
    or
    result = convertAppliedPropertyWrapperExprToDb(e)
    or
    result = convertApplyExprToDb(e)
    or
    result = convertArrowExprToDb(e)
    or
    result = convertAssignExprToDb(e)
    or
    result = convertBindOptionalExprToDb(e)
    or
    result = convertCaptureListExprToDb(e)
    or
    result = convertCodeCompletionExprToDb(e)
    or
    result = convertCollectionExprToDb(e)
    or
    result = convertDeclRefExprToDb(e)
    or
    result = convertDefaultArgumentExprToDb(e)
    or
    result = convertDiscardAssignmentExprToDb(e)
    or
    result = convertDotSyntaxBaseIgnoredExprToDb(e)
    or
    result = convertDynamicTypeExprToDb(e)
    or
    result = convertEditorPlaceholderExprToDb(e)
    or
    result = convertEnumIsCaseExprToDb(e)
    or
    result = convertErrorExprToDb(e)
    or
    result = convertExplicitCastExprToDb(e)
    or
    result = convertForceValueExprToDb(e)
    or
    result = convertIdentityExprToDb(e)
    or
    result = convertIfExprToDb(e)
    or
    result = convertImplicitConversionExprToDb(e)
    or
    result = convertInOutExprToDb(e)
    or
    result = convertKeyPathApplicationExprToDb(e)
    or
    result = convertKeyPathDotExprToDb(e)
    or
    result = convertKeyPathExprToDb(e)
    or
    result = convertLazyInitializerExprToDb(e)
    or
    result = convertLiteralExprToDb(e)
    or
    result = convertLookupExprToDb(e)
    or
    result = convertMakeTemporarilyEscapableExprToDb(e)
    or
    result = convertObjCSelectorExprToDb(e)
    or
    result = convertOneWayExprToDb(e)
    or
    result = convertOpaqueValueExprToDb(e)
    or
    result = convertOpenExistentialExprToDb(e)
    or
    result = convertOptionalEvaluationExprToDb(e)
    or
    result = convertOtherConstructorDeclRefExprToDb(e)
    or
    result = convertOverloadSetRefExprToDb(e)
    or
    result = convertPropertyWrapperValuePlaceholderExprToDb(e)
    or
    result = convertRebindSelfInConstructorExprToDb(e)
    or
    result = convertSequenceExprToDb(e)
    or
    result = convertSuperRefExprToDb(e)
    or
    result = convertTapExprToDb(e)
    or
    result = convertTupleElementExprToDb(e)
    or
    result = convertTupleExprToDb(e)
    or
    result = convertTypeExprToDb(e)
    or
    result = convertUnresolvedDeclRefExprToDb(e)
    or
    result = convertUnresolvedDotExprToDb(e)
    or
    result = convertUnresolvedMemberExprToDb(e)
    or
    result = convertUnresolvedPatternExprToDb(e)
    or
    result = convertUnresolvedSpecializeExprToDb(e)
    or
    result = convertVarargExpansionExprToDb(e)
  }

  cached
  Raw::Element convertIdentityExprToDb(TIdentityExpr e) {
    result = convertAwaitExprToDb(e)
    or
    result = convertDotSelfExprToDb(e)
    or
    result = convertParenExprToDb(e)
    or
    result = convertUnresolvedMemberChainResultExprToDb(e)
  }

  cached
  Raw::Element convertImplicitConversionExprToDb(TImplicitConversionExpr e) {
    result = convertAnyHashableErasureExprToDb(e)
    or
    result = convertArchetypeToSuperExprToDb(e)
    or
    result = convertArrayToPointerExprToDb(e)
    or
    result = convertBridgeFromObjCExprToDb(e)
    or
    result = convertBridgeToObjCExprToDb(e)
    or
    result = convertClassMetatypeToObjectExprToDb(e)
    or
    result = convertCollectionUpcastConversionExprToDb(e)
    or
    result = convertConditionalBridgeFromObjCExprToDb(e)
    or
    result = convertCovariantFunctionConversionExprToDb(e)
    or
    result = convertCovariantReturnConversionExprToDb(e)
    or
    result = convertDerivedToBaseExprToDb(e)
    or
    result = convertDestructureTupleExprToDb(e)
    or
    result = convertDifferentiableFunctionExprToDb(e)
    or
    result = convertDifferentiableFunctionExtractOriginalExprToDb(e)
    or
    result = convertErasureExprToDb(e)
    or
    result = convertExistentialMetatypeToObjectExprToDb(e)
    or
    result = convertForeignObjectConversionExprToDb(e)
    or
    result = convertFunctionConversionExprToDb(e)
    or
    result = convertInOutToPointerExprToDb(e)
    or
    result = convertInjectIntoOptionalExprToDb(e)
    or
    result = convertLinearFunctionExprToDb(e)
    or
    result = convertLinearFunctionExtractOriginalExprToDb(e)
    or
    result = convertLinearToDifferentiableFunctionExprToDb(e)
    or
    result = convertLoadExprToDb(e)
    or
    result = convertMetatypeConversionExprToDb(e)
    or
    result = convertPointerToPointerExprToDb(e)
    or
    result = convertProtocolMetatypeToObjectExprToDb(e)
    or
    result = convertStringToPointerExprToDb(e)
    or
    result = convertUnderlyingToOpaqueExprToDb(e)
    or
    result = convertUnevaluatedInstanceExprToDb(e)
    or
    result = convertUnresolvedTypeConversionExprToDb(e)
  }

  cached
  Raw::Element convertLiteralExprToDb(TLiteralExpr e) {
    result = convertBuiltinLiteralExprToDb(e)
    or
    result = convertInterpolatedStringLiteralExprToDb(e)
    or
    result = convertNilLiteralExprToDb(e)
    or
    result = convertObjectLiteralExprToDb(e)
    or
    result = convertRegexLiteralExprToDb(e)
  }

  cached
  Raw::Element convertLookupExprToDb(TLookupExpr e) {
    result = convertDynamicLookupExprToDb(e)
    or
    result = convertMemberRefExprToDb(e)
    or
    result = convertSubscriptExprToDb(e)
  }

  cached
  Raw::Element convertNumberLiteralExprToDb(TNumberLiteralExpr e) {
    result = convertFloatLiteralExprToDb(e)
    or
    result = convertIntegerLiteralExprToDb(e)
  }

  cached
  Raw::Element convertOverloadSetRefExprToDb(TOverloadSetRefExpr e) {
    result = convertOverloadedDeclRefExprToDb(e)
  }

  cached
  Raw::Element convertSelfApplyExprToDb(TSelfApplyExpr e) {
    result = convertConstructorRefCallExprToDb(e)
    or
    result = convertDotSyntaxCallExprToDb(e)
  }

  cached
  Raw::Element convertPatternToDb(TPattern e) {
    result = convertAnyPatternToDb(e)
    or
    result = convertBindingPatternToDb(e)
    or
    result = convertBoolPatternToDb(e)
    or
    result = convertEnumElementPatternToDb(e)
    or
    result = convertExprPatternToDb(e)
    or
    result = convertIsPatternToDb(e)
    or
    result = convertNamedPatternToDb(e)
    or
    result = convertOptionalSomePatternToDb(e)
    or
    result = convertParenPatternToDb(e)
    or
    result = convertTuplePatternToDb(e)
    or
    result = convertTypedPatternToDb(e)
  }

  cached
  Raw::Element convertLabeledConditionalStmtToDb(TLabeledConditionalStmt e) {
    result = convertGuardStmtToDb(e)
    or
    result = convertIfStmtToDb(e)
    or
    result = convertWhileStmtToDb(e)
  }

  cached
  Raw::Element convertLabeledStmtToDb(TLabeledStmt e) {
    result = convertDoCatchStmtToDb(e)
    or
    result = convertDoStmtToDb(e)
    or
    result = convertForEachStmtToDb(e)
    or
    result = convertLabeledConditionalStmtToDb(e)
    or
    result = convertRepeatWhileStmtToDb(e)
    or
    result = convertSwitchStmtToDb(e)
  }

  cached
  Raw::Element convertStmtToDb(TStmt e) {
    result = convertBraceStmtToDb(e)
    or
    result = convertBreakStmtToDb(e)
    or
    result = convertCaseStmtToDb(e)
    or
    result = convertContinueStmtToDb(e)
    or
    result = convertDeferStmtToDb(e)
    or
    result = convertFailStmtToDb(e)
    or
    result = convertFallthroughStmtToDb(e)
    or
    result = convertLabeledStmtToDb(e)
    or
    result = convertPoundAssertStmtToDb(e)
    or
    result = convertReturnStmtToDb(e)
    or
    result = convertThrowStmtToDb(e)
    or
    result = convertYieldStmtToDb(e)
  }

  cached
  Raw::Element convertAnyBuiltinIntegerTypeToDb(TAnyBuiltinIntegerType e) {
    result = convertBuiltinIntegerLiteralTypeToDb(e)
    or
    result = convertBuiltinIntegerTypeToDb(e)
  }

  cached
  Raw::Element convertAnyFunctionTypeToDb(TAnyFunctionType e) {
    result = convertFunctionTypeToDb(e)
    or
    result = convertGenericFunctionTypeToDb(e)
  }

  cached
  Raw::Element convertAnyGenericTypeToDb(TAnyGenericType e) {
    result = convertNominalOrBoundGenericNominalTypeToDb(e)
    or
    result = convertUnboundGenericTypeToDb(e)
  }

  cached
  Raw::Element convertAnyMetatypeTypeToDb(TAnyMetatypeType e) {
    result = convertExistentialMetatypeTypeToDb(e)
    or
    result = convertMetatypeTypeToDb(e)
  }

  cached
  Raw::Element convertArchetypeTypeToDb(TArchetypeType e) {
    result = convertNestedArchetypeTypeToDb(e)
    or
    result = convertOpaqueTypeArchetypeTypeToDb(e)
    or
    result = convertOpenedArchetypeTypeToDb(e)
    or
    result = convertPrimaryArchetypeTypeToDb(e)
    or
    result = convertSequenceArchetypeTypeToDb(e)
  }

  cached
  Raw::Element convertBoundGenericTypeToDb(TBoundGenericType e) {
    result = convertBoundGenericClassTypeToDb(e)
    or
    result = convertBoundGenericEnumTypeToDb(e)
    or
    result = convertBoundGenericStructTypeToDb(e)
  }

  cached
  Raw::Element convertBuiltinTypeToDb(TBuiltinType e) {
    result = convertAnyBuiltinIntegerTypeToDb(e)
    or
    result = convertBuiltinBridgeObjectTypeToDb(e)
    or
    result = convertBuiltinDefaultActorStorageTypeToDb(e)
    or
    result = convertBuiltinExecutorTypeToDb(e)
    or
    result = convertBuiltinFloatTypeToDb(e)
    or
    result = convertBuiltinJobTypeToDb(e)
    or
    result = convertBuiltinNativeObjectTypeToDb(e)
    or
    result = convertBuiltinRawPointerTypeToDb(e)
    or
    result = convertBuiltinRawUnsafeContinuationTypeToDb(e)
    or
    result = convertBuiltinUnsafeValueBufferTypeToDb(e)
    or
    result = convertBuiltinVectorTypeToDb(e)
  }

  cached
  Raw::Element convertNominalOrBoundGenericNominalTypeToDb(TNominalOrBoundGenericNominalType e) {
    result = convertBoundGenericTypeToDb(e)
    or
    result = convertNominalTypeToDb(e)
  }

  cached
  Raw::Element convertNominalTypeToDb(TNominalType e) {
    result = convertClassTypeToDb(e)
    or
    result = convertEnumTypeToDb(e)
    or
    result = convertProtocolTypeToDb(e)
    or
    result = convertStructTypeToDb(e)
  }

  cached
  Raw::Element convertReferenceStorageTypeToDb(TReferenceStorageType e) {
    result = convertUnmanagedStorageTypeToDb(e)
    or
    result = convertUnownedStorageTypeToDb(e)
    or
    result = convertWeakStorageTypeToDb(e)
  }

  cached
  Raw::Element convertSubstitutableTypeToDb(TSubstitutableType e) {
    result = convertArchetypeTypeToDb(e)
    or
    result = convertGenericTypeParamTypeToDb(e)
  }

  cached
  Raw::Element convertSugarTypeToDb(TSugarType e) {
    result = convertParenTypeToDb(e)
    or
    result = convertSyntaxSugarTypeToDb(e)
    or
    result = convertTypeAliasTypeToDb(e)
  }

  cached
  Raw::Element convertSyntaxSugarTypeToDb(TSyntaxSugarType e) {
    result = convertDictionaryTypeToDb(e)
    or
    result = convertUnarySyntaxSugarTypeToDb(e)
  }

  cached
  Raw::Element convertTypeToDb(TType e) {
    result = convertAnyFunctionTypeToDb(e)
    or
    result = convertAnyGenericTypeToDb(e)
    or
    result = convertAnyMetatypeTypeToDb(e)
    or
    result = convertBuiltinTypeToDb(e)
    or
    result = convertDependentMemberTypeToDb(e)
    or
    result = convertDynamicSelfTypeToDb(e)
    or
    result = convertErrorTypeToDb(e)
    or
    result = convertExistentialTypeToDb(e)
    or
    result = convertInOutTypeToDb(e)
    or
    result = convertLValueTypeToDb(e)
    or
    result = convertModuleTypeToDb(e)
    or
    result = convertPlaceholderTypeToDb(e)
    or
    result = convertProtocolCompositionTypeToDb(e)
    or
    result = convertReferenceStorageTypeToDb(e)
    or
    result = convertSilBlockStorageTypeToDb(e)
    or
    result = convertSilBoxTypeToDb(e)
    or
    result = convertSilFunctionTypeToDb(e)
    or
    result = convertSilTokenTypeToDb(e)
    or
    result = convertSubstitutableTypeToDb(e)
    or
    result = convertSugarTypeToDb(e)
    or
    result = convertTupleTypeToDb(e)
    or
    result = convertTypeVariableTypeToDb(e)
    or
    result = convertUnresolvedTypeToDb(e)
  }

  cached
  Raw::Element convertUnarySyntaxSugarTypeToDb(TUnarySyntaxSugarType e) {
    result = convertArraySliceTypeToDb(e)
    or
    result = convertOptionalTypeToDb(e)
    or
    result = convertVariadicSequenceTypeToDb(e)
  }
}
