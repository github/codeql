private import codeql.swift.generated.SynthConstructors
private import codeql.swift.generated.Db

cached
module Synth {
  cached
  newtype TElement =
    TComment(Db::Comment id) or
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
  TComment convertCommentFromDb(Db::Element e) { result = TComment(e) }

  cached
  TDbFile convertDbFileFromDb(Db::Element e) { result = TDbFile(e) }

  cached
  TDbLocation convertDbLocationFromDb(Db::Element e) { result = TDbLocation(e) }

  cached
  TUnknownFile convertUnknownFileFromDb(Db::Element e) { none() }

  cached
  TUnknownLocation convertUnknownLocationFromDb(Db::Element e) { none() }

  cached
  TAccessorDecl convertAccessorDeclFromDb(Db::Element e) { result = TAccessorDecl(e) }

  cached
  TAssociatedTypeDecl convertAssociatedTypeDeclFromDb(Db::Element e) {
    result = TAssociatedTypeDecl(e)
  }

  cached
  TClassDecl convertClassDeclFromDb(Db::Element e) { result = TClassDecl(e) }

  cached
  TConcreteFuncDecl convertConcreteFuncDeclFromDb(Db::Element e) { result = TConcreteFuncDecl(e) }

  cached
  TConcreteVarDecl convertConcreteVarDeclFromDb(Db::Element e) { result = TConcreteVarDecl(e) }

  cached
  TConstructorDecl convertConstructorDeclFromDb(Db::Element e) { result = TConstructorDecl(e) }

  cached
  TDestructorDecl convertDestructorDeclFromDb(Db::Element e) { result = TDestructorDecl(e) }

  cached
  TEnumCaseDecl convertEnumCaseDeclFromDb(Db::Element e) { result = TEnumCaseDecl(e) }

  cached
  TEnumDecl convertEnumDeclFromDb(Db::Element e) { result = TEnumDecl(e) }

  cached
  TEnumElementDecl convertEnumElementDeclFromDb(Db::Element e) { result = TEnumElementDecl(e) }

  cached
  TExtensionDecl convertExtensionDeclFromDb(Db::Element e) { result = TExtensionDecl(e) }

  cached
  TGenericTypeParamDecl convertGenericTypeParamDeclFromDb(Db::Element e) {
    result = TGenericTypeParamDecl(e)
  }

  cached
  TIfConfigClause convertIfConfigClauseFromDb(Db::Element e) { result = TIfConfigClause(e) }

  cached
  TIfConfigDecl convertIfConfigDeclFromDb(Db::Element e) { result = TIfConfigDecl(e) }

  cached
  TImportDecl convertImportDeclFromDb(Db::Element e) { result = TImportDecl(e) }

  cached
  TInfixOperatorDecl convertInfixOperatorDeclFromDb(Db::Element e) {
    result = TInfixOperatorDecl(e)
  }

  cached
  TMissingMemberDecl convertMissingMemberDeclFromDb(Db::Element e) {
    result = TMissingMemberDecl(e)
  }

  cached
  TModuleDecl convertModuleDeclFromDb(Db::Element e) { result = TModuleDecl(e) }

  cached
  TOpaqueTypeDecl convertOpaqueTypeDeclFromDb(Db::Element e) { result = TOpaqueTypeDecl(e) }

  cached
  TParamDecl convertParamDeclFromDb(Db::Element e) { result = TParamDecl(e) }

  cached
  TPatternBindingDecl convertPatternBindingDeclFromDb(Db::Element e) {
    result = TPatternBindingDecl(e)
  }

  cached
  TPostfixOperatorDecl convertPostfixOperatorDeclFromDb(Db::Element e) {
    result = TPostfixOperatorDecl(e)
  }

  cached
  TPoundDiagnosticDecl convertPoundDiagnosticDeclFromDb(Db::Element e) {
    result = TPoundDiagnosticDecl(e)
  }

  cached
  TPrecedenceGroupDecl convertPrecedenceGroupDeclFromDb(Db::Element e) {
    result = TPrecedenceGroupDecl(e)
  }

  cached
  TPrefixOperatorDecl convertPrefixOperatorDeclFromDb(Db::Element e) {
    result = TPrefixOperatorDecl(e)
  }

  cached
  TProtocolDecl convertProtocolDeclFromDb(Db::Element e) { result = TProtocolDecl(e) }

  cached
  TStructDecl convertStructDeclFromDb(Db::Element e) { result = TStructDecl(e) }

  cached
  TSubscriptDecl convertSubscriptDeclFromDb(Db::Element e) { result = TSubscriptDecl(e) }

  cached
  TTopLevelCodeDecl convertTopLevelCodeDeclFromDb(Db::Element e) { result = TTopLevelCodeDecl(e) }

  cached
  TTypeAliasDecl convertTypeAliasDeclFromDb(Db::Element e) { result = TTypeAliasDecl(e) }

  cached
  TAnyHashableErasureExpr convertAnyHashableErasureExprFromDb(Db::Element e) {
    result = TAnyHashableErasureExpr(e)
  }

  cached
  TAppliedPropertyWrapperExpr convertAppliedPropertyWrapperExprFromDb(Db::Element e) {
    result = TAppliedPropertyWrapperExpr(e)
  }

  cached
  TArchetypeToSuperExpr convertArchetypeToSuperExprFromDb(Db::Element e) {
    result = TArchetypeToSuperExpr(e)
  }

  cached
  TArgument convertArgumentFromDb(Db::Element e) { result = TArgument(e) }

  cached
  TArrayExpr convertArrayExprFromDb(Db::Element e) { result = TArrayExpr(e) }

  cached
  TArrayToPointerExpr convertArrayToPointerExprFromDb(Db::Element e) {
    result = TArrayToPointerExpr(e)
  }

  cached
  TArrowExpr convertArrowExprFromDb(Db::Element e) { result = TArrowExpr(e) }

  cached
  TAssignExpr convertAssignExprFromDb(Db::Element e) { result = TAssignExpr(e) }

  cached
  TAutoClosureExpr convertAutoClosureExprFromDb(Db::Element e) { result = TAutoClosureExpr(e) }

  cached
  TAwaitExpr convertAwaitExprFromDb(Db::Element e) { result = TAwaitExpr(e) }

  cached
  TBinaryExpr convertBinaryExprFromDb(Db::Element e) { result = TBinaryExpr(e) }

  cached
  TBindOptionalExpr convertBindOptionalExprFromDb(Db::Element e) { result = TBindOptionalExpr(e) }

  cached
  TBooleanLiteralExpr convertBooleanLiteralExprFromDb(Db::Element e) {
    result = TBooleanLiteralExpr(e)
  }

  cached
  TBridgeFromObjCExpr convertBridgeFromObjCExprFromDb(Db::Element e) {
    result = TBridgeFromObjCExpr(e)
  }

  cached
  TBridgeToObjCExpr convertBridgeToObjCExprFromDb(Db::Element e) { result = TBridgeToObjCExpr(e) }

  cached
  TCallExpr convertCallExprFromDb(Db::Element e) { result = TCallExpr(e) }

  cached
  TCaptureListExpr convertCaptureListExprFromDb(Db::Element e) { result = TCaptureListExpr(e) }

  cached
  TClassMetatypeToObjectExpr convertClassMetatypeToObjectExprFromDb(Db::Element e) {
    result = TClassMetatypeToObjectExpr(e)
  }

  cached
  TClosureExpr convertClosureExprFromDb(Db::Element e) { result = TClosureExpr(e) }

  cached
  TCodeCompletionExpr convertCodeCompletionExprFromDb(Db::Element e) {
    result = TCodeCompletionExpr(e)
  }

  cached
  TCoerceExpr convertCoerceExprFromDb(Db::Element e) { result = TCoerceExpr(e) }

  cached
  TCollectionUpcastConversionExpr convertCollectionUpcastConversionExprFromDb(Db::Element e) {
    result = TCollectionUpcastConversionExpr(e)
  }

  cached
  TConditionalBridgeFromObjCExpr convertConditionalBridgeFromObjCExprFromDb(Db::Element e) {
    result = TConditionalBridgeFromObjCExpr(e)
  }

  cached
  TConditionalCheckedCastExpr convertConditionalCheckedCastExprFromDb(Db::Element e) {
    result = TConditionalCheckedCastExpr(e)
  }

  cached
  TConstructorRefCallExpr convertConstructorRefCallExprFromDb(Db::Element e) {
    result = TConstructorRefCallExpr(e)
  }

  cached
  TCovariantFunctionConversionExpr convertCovariantFunctionConversionExprFromDb(Db::Element e) {
    result = TCovariantFunctionConversionExpr(e)
  }

  cached
  TCovariantReturnConversionExpr convertCovariantReturnConversionExprFromDb(Db::Element e) {
    result = TCovariantReturnConversionExpr(e)
  }

  cached
  TDeclRefExpr convertDeclRefExprFromDb(Db::Element e) { result = TDeclRefExpr(e) }

  cached
  TDefaultArgumentExpr convertDefaultArgumentExprFromDb(Db::Element e) {
    result = TDefaultArgumentExpr(e)
  }

  cached
  TDerivedToBaseExpr convertDerivedToBaseExprFromDb(Db::Element e) {
    result = TDerivedToBaseExpr(e)
  }

  cached
  TDestructureTupleExpr convertDestructureTupleExprFromDb(Db::Element e) {
    result = TDestructureTupleExpr(e)
  }

  cached
  TDictionaryExpr convertDictionaryExprFromDb(Db::Element e) { result = TDictionaryExpr(e) }

  cached
  TDifferentiableFunctionExpr convertDifferentiableFunctionExprFromDb(Db::Element e) {
    result = TDifferentiableFunctionExpr(e)
  }

  cached
  TDifferentiableFunctionExtractOriginalExpr convertDifferentiableFunctionExtractOriginalExprFromDb(
    Db::Element e
  ) {
    result = TDifferentiableFunctionExtractOriginalExpr(e)
  }

  cached
  TDiscardAssignmentExpr convertDiscardAssignmentExprFromDb(Db::Element e) {
    result = TDiscardAssignmentExpr(e)
  }

  cached
  TDotSelfExpr convertDotSelfExprFromDb(Db::Element e) { result = TDotSelfExpr(e) }

  cached
  TDotSyntaxBaseIgnoredExpr convertDotSyntaxBaseIgnoredExprFromDb(Db::Element e) {
    result = TDotSyntaxBaseIgnoredExpr(e)
  }

  cached
  TDotSyntaxCallExpr convertDotSyntaxCallExprFromDb(Db::Element e) {
    result = TDotSyntaxCallExpr(e)
  }

  cached
  TDynamicMemberRefExpr convertDynamicMemberRefExprFromDb(Db::Element e) {
    result = TDynamicMemberRefExpr(e)
  }

  cached
  TDynamicSubscriptExpr convertDynamicSubscriptExprFromDb(Db::Element e) {
    result = TDynamicSubscriptExpr(e)
  }

  cached
  TDynamicTypeExpr convertDynamicTypeExprFromDb(Db::Element e) { result = TDynamicTypeExpr(e) }

  cached
  TEditorPlaceholderExpr convertEditorPlaceholderExprFromDb(Db::Element e) {
    result = TEditorPlaceholderExpr(e)
  }

  cached
  TEnumIsCaseExpr convertEnumIsCaseExprFromDb(Db::Element e) { result = TEnumIsCaseExpr(e) }

  cached
  TErasureExpr convertErasureExprFromDb(Db::Element e) { result = TErasureExpr(e) }

  cached
  TErrorExpr convertErrorExprFromDb(Db::Element e) { result = TErrorExpr(e) }

  cached
  TExistentialMetatypeToObjectExpr convertExistentialMetatypeToObjectExprFromDb(Db::Element e) {
    result = TExistentialMetatypeToObjectExpr(e)
  }

  cached
  TFloatLiteralExpr convertFloatLiteralExprFromDb(Db::Element e) { result = TFloatLiteralExpr(e) }

  cached
  TForceTryExpr convertForceTryExprFromDb(Db::Element e) { result = TForceTryExpr(e) }

  cached
  TForceValueExpr convertForceValueExprFromDb(Db::Element e) { result = TForceValueExpr(e) }

  cached
  TForcedCheckedCastExpr convertForcedCheckedCastExprFromDb(Db::Element e) {
    result = TForcedCheckedCastExpr(e)
  }

  cached
  TForeignObjectConversionExpr convertForeignObjectConversionExprFromDb(Db::Element e) {
    result = TForeignObjectConversionExpr(e)
  }

  cached
  TFunctionConversionExpr convertFunctionConversionExprFromDb(Db::Element e) {
    result = TFunctionConversionExpr(e)
  }

  cached
  TIfExpr convertIfExprFromDb(Db::Element e) { result = TIfExpr(e) }

  cached
  TInOutExpr convertInOutExprFromDb(Db::Element e) { result = TInOutExpr(e) }

  cached
  TInOutToPointerExpr convertInOutToPointerExprFromDb(Db::Element e) {
    result = TInOutToPointerExpr(e)
  }

  cached
  TInjectIntoOptionalExpr convertInjectIntoOptionalExprFromDb(Db::Element e) {
    result = TInjectIntoOptionalExpr(e)
  }

  cached
  TIntegerLiteralExpr convertIntegerLiteralExprFromDb(Db::Element e) {
    result = TIntegerLiteralExpr(e)
  }

  cached
  TInterpolatedStringLiteralExpr convertInterpolatedStringLiteralExprFromDb(Db::Element e) {
    result = TInterpolatedStringLiteralExpr(e)
  }

  cached
  TIsExpr convertIsExprFromDb(Db::Element e) { result = TIsExpr(e) }

  cached
  TKeyPathApplicationExpr convertKeyPathApplicationExprFromDb(Db::Element e) {
    result = TKeyPathApplicationExpr(e)
  }

  cached
  TKeyPathDotExpr convertKeyPathDotExprFromDb(Db::Element e) { result = TKeyPathDotExpr(e) }

  cached
  TKeyPathExpr convertKeyPathExprFromDb(Db::Element e) { result = TKeyPathExpr(e) }

  cached
  TLazyInitializerExpr convertLazyInitializerExprFromDb(Db::Element e) {
    result = TLazyInitializerExpr(e)
  }

  cached
  TLinearFunctionExpr convertLinearFunctionExprFromDb(Db::Element e) {
    result = TLinearFunctionExpr(e)
  }

  cached
  TLinearFunctionExtractOriginalExpr convertLinearFunctionExtractOriginalExprFromDb(Db::Element e) {
    result = TLinearFunctionExtractOriginalExpr(e)
  }

  cached
  TLinearToDifferentiableFunctionExpr convertLinearToDifferentiableFunctionExprFromDb(Db::Element e) {
    result = TLinearToDifferentiableFunctionExpr(e)
  }

  cached
  TLoadExpr convertLoadExprFromDb(Db::Element e) { result = TLoadExpr(e) }

  cached
  TMagicIdentifierLiteralExpr convertMagicIdentifierLiteralExprFromDb(Db::Element e) {
    result = TMagicIdentifierLiteralExpr(e)
  }

  cached
  TMakeTemporarilyEscapableExpr convertMakeTemporarilyEscapableExprFromDb(Db::Element e) {
    result = TMakeTemporarilyEscapableExpr(e)
  }

  cached
  TMemberRefExpr convertMemberRefExprFromDb(Db::Element e) { result = TMemberRefExpr(e) }

  cached
  TMetatypeConversionExpr convertMetatypeConversionExprFromDb(Db::Element e) {
    result = TMetatypeConversionExpr(e)
  }

  cached
  TNilLiteralExpr convertNilLiteralExprFromDb(Db::Element e) { result = TNilLiteralExpr(e) }

  cached
  TObjCSelectorExpr convertObjCSelectorExprFromDb(Db::Element e) { result = TObjCSelectorExpr(e) }

  cached
  TObjectLiteralExpr convertObjectLiteralExprFromDb(Db::Element e) {
    result = TObjectLiteralExpr(e)
  }

  cached
  TOneWayExpr convertOneWayExprFromDb(Db::Element e) { result = TOneWayExpr(e) }

  cached
  TOpaqueValueExpr convertOpaqueValueExprFromDb(Db::Element e) { result = TOpaqueValueExpr(e) }

  cached
  TOpenExistentialExpr convertOpenExistentialExprFromDb(Db::Element e) {
    result = TOpenExistentialExpr(e)
  }

  cached
  TOptionalEvaluationExpr convertOptionalEvaluationExprFromDb(Db::Element e) {
    result = TOptionalEvaluationExpr(e)
  }

  cached
  TOptionalTryExpr convertOptionalTryExprFromDb(Db::Element e) { result = TOptionalTryExpr(e) }

  cached
  TOtherConstructorDeclRefExpr convertOtherConstructorDeclRefExprFromDb(Db::Element e) {
    result = TOtherConstructorDeclRefExpr(e)
  }

  cached
  TOverloadedDeclRefExpr convertOverloadedDeclRefExprFromDb(Db::Element e) {
    result = TOverloadedDeclRefExpr(e)
  }

  cached
  TParenExpr convertParenExprFromDb(Db::Element e) { result = TParenExpr(e) }

  cached
  TPointerToPointerExpr convertPointerToPointerExprFromDb(Db::Element e) {
    result = TPointerToPointerExpr(e)
  }

  cached
  TPostfixUnaryExpr convertPostfixUnaryExprFromDb(Db::Element e) { result = TPostfixUnaryExpr(e) }

  cached
  TPrefixUnaryExpr convertPrefixUnaryExprFromDb(Db::Element e) { result = TPrefixUnaryExpr(e) }

  cached
  TPropertyWrapperValuePlaceholderExpr convertPropertyWrapperValuePlaceholderExprFromDb(
    Db::Element e
  ) {
    result = TPropertyWrapperValuePlaceholderExpr(e)
  }

  cached
  TProtocolMetatypeToObjectExpr convertProtocolMetatypeToObjectExprFromDb(Db::Element e) {
    result = TProtocolMetatypeToObjectExpr(e)
  }

  cached
  TRebindSelfInConstructorExpr convertRebindSelfInConstructorExprFromDb(Db::Element e) {
    result = TRebindSelfInConstructorExpr(e)
  }

  cached
  TRegexLiteralExpr convertRegexLiteralExprFromDb(Db::Element e) { result = TRegexLiteralExpr(e) }

  cached
  TSequenceExpr convertSequenceExprFromDb(Db::Element e) { result = TSequenceExpr(e) }

  cached
  TStringLiteralExpr convertStringLiteralExprFromDb(Db::Element e) {
    result = TStringLiteralExpr(e)
  }

  cached
  TStringToPointerExpr convertStringToPointerExprFromDb(Db::Element e) {
    result = TStringToPointerExpr(e)
  }

  cached
  TSubscriptExpr convertSubscriptExprFromDb(Db::Element e) { result = TSubscriptExpr(e) }

  cached
  TSuperRefExpr convertSuperRefExprFromDb(Db::Element e) { result = TSuperRefExpr(e) }

  cached
  TTapExpr convertTapExprFromDb(Db::Element e) { result = TTapExpr(e) }

  cached
  TTryExpr convertTryExprFromDb(Db::Element e) { result = TTryExpr(e) }

  cached
  TTupleElementExpr convertTupleElementExprFromDb(Db::Element e) { result = TTupleElementExpr(e) }

  cached
  TTupleExpr convertTupleExprFromDb(Db::Element e) { result = TTupleExpr(e) }

  cached
  TTypeExpr convertTypeExprFromDb(Db::Element e) { result = TTypeExpr(e) }

  cached
  TUnderlyingToOpaqueExpr convertUnderlyingToOpaqueExprFromDb(Db::Element e) {
    result = TUnderlyingToOpaqueExpr(e)
  }

  cached
  TUnevaluatedInstanceExpr convertUnevaluatedInstanceExprFromDb(Db::Element e) {
    result = TUnevaluatedInstanceExpr(e)
  }

  cached
  TUnresolvedDeclRefExpr convertUnresolvedDeclRefExprFromDb(Db::Element e) {
    result = TUnresolvedDeclRefExpr(e)
  }

  cached
  TUnresolvedDotExpr convertUnresolvedDotExprFromDb(Db::Element e) {
    result = TUnresolvedDotExpr(e)
  }

  cached
  TUnresolvedMemberChainResultExpr convertUnresolvedMemberChainResultExprFromDb(Db::Element e) {
    result = TUnresolvedMemberChainResultExpr(e)
  }

  cached
  TUnresolvedMemberExpr convertUnresolvedMemberExprFromDb(Db::Element e) {
    result = TUnresolvedMemberExpr(e)
  }

  cached
  TUnresolvedPatternExpr convertUnresolvedPatternExprFromDb(Db::Element e) {
    result = TUnresolvedPatternExpr(e)
  }

  cached
  TUnresolvedSpecializeExpr convertUnresolvedSpecializeExprFromDb(Db::Element e) {
    result = TUnresolvedSpecializeExpr(e)
  }

  cached
  TUnresolvedTypeConversionExpr convertUnresolvedTypeConversionExprFromDb(Db::Element e) {
    result = TUnresolvedTypeConversionExpr(e)
  }

  cached
  TVarargExpansionExpr convertVarargExpansionExprFromDb(Db::Element e) {
    result = TVarargExpansionExpr(e)
  }

  cached
  TAnyPattern convertAnyPatternFromDb(Db::Element e) { result = TAnyPattern(e) }

  cached
  TBindingPattern convertBindingPatternFromDb(Db::Element e) { result = TBindingPattern(e) }

  cached
  TBoolPattern convertBoolPatternFromDb(Db::Element e) { result = TBoolPattern(e) }

  cached
  TEnumElementPattern convertEnumElementPatternFromDb(Db::Element e) {
    result = TEnumElementPattern(e)
  }

  cached
  TExprPattern convertExprPatternFromDb(Db::Element e) { result = TExprPattern(e) }

  cached
  TIsPattern convertIsPatternFromDb(Db::Element e) { result = TIsPattern(e) }

  cached
  TNamedPattern convertNamedPatternFromDb(Db::Element e) { result = TNamedPattern(e) }

  cached
  TOptionalSomePattern convertOptionalSomePatternFromDb(Db::Element e) {
    result = TOptionalSomePattern(e)
  }

  cached
  TParenPattern convertParenPatternFromDb(Db::Element e) { result = TParenPattern(e) }

  cached
  TTuplePattern convertTuplePatternFromDb(Db::Element e) { result = TTuplePattern(e) }

  cached
  TTypedPattern convertTypedPatternFromDb(Db::Element e) { result = TTypedPattern(e) }

  cached
  TBraceStmt convertBraceStmtFromDb(Db::Element e) { result = TBraceStmt(e) }

  cached
  TBreakStmt convertBreakStmtFromDb(Db::Element e) { result = TBreakStmt(e) }

  cached
  TCaseLabelItem convertCaseLabelItemFromDb(Db::Element e) { result = TCaseLabelItem(e) }

  cached
  TCaseStmt convertCaseStmtFromDb(Db::Element e) { result = TCaseStmt(e) }

  cached
  TConditionElement convertConditionElementFromDb(Db::Element e) { result = TConditionElement(e) }

  cached
  TContinueStmt convertContinueStmtFromDb(Db::Element e) { result = TContinueStmt(e) }

  cached
  TDeferStmt convertDeferStmtFromDb(Db::Element e) { result = TDeferStmt(e) }

  cached
  TDoCatchStmt convertDoCatchStmtFromDb(Db::Element e) { result = TDoCatchStmt(e) }

  cached
  TDoStmt convertDoStmtFromDb(Db::Element e) { result = TDoStmt(e) }

  cached
  TFailStmt convertFailStmtFromDb(Db::Element e) { result = TFailStmt(e) }

  cached
  TFallthroughStmt convertFallthroughStmtFromDb(Db::Element e) { result = TFallthroughStmt(e) }

  cached
  TForEachStmt convertForEachStmtFromDb(Db::Element e) { result = TForEachStmt(e) }

  cached
  TGuardStmt convertGuardStmtFromDb(Db::Element e) { result = TGuardStmt(e) }

  cached
  TIfStmt convertIfStmtFromDb(Db::Element e) { result = TIfStmt(e) }

  cached
  TPoundAssertStmt convertPoundAssertStmtFromDb(Db::Element e) { result = TPoundAssertStmt(e) }

  cached
  TRepeatWhileStmt convertRepeatWhileStmtFromDb(Db::Element e) { result = TRepeatWhileStmt(e) }

  cached
  TReturnStmt convertReturnStmtFromDb(Db::Element e) { result = TReturnStmt(e) }

  cached
  TStmtCondition convertStmtConditionFromDb(Db::Element e) { result = TStmtCondition(e) }

  cached
  TSwitchStmt convertSwitchStmtFromDb(Db::Element e) { result = TSwitchStmt(e) }

  cached
  TThrowStmt convertThrowStmtFromDb(Db::Element e) { result = TThrowStmt(e) }

  cached
  TWhileStmt convertWhileStmtFromDb(Db::Element e) { result = TWhileStmt(e) }

  cached
  TYieldStmt convertYieldStmtFromDb(Db::Element e) { result = TYieldStmt(e) }

  cached
  TArraySliceType convertArraySliceTypeFromDb(Db::Element e) { result = TArraySliceType(e) }

  cached
  TBoundGenericClassType convertBoundGenericClassTypeFromDb(Db::Element e) {
    result = TBoundGenericClassType(e)
  }

  cached
  TBoundGenericEnumType convertBoundGenericEnumTypeFromDb(Db::Element e) {
    result = TBoundGenericEnumType(e)
  }

  cached
  TBoundGenericStructType convertBoundGenericStructTypeFromDb(Db::Element e) {
    result = TBoundGenericStructType(e)
  }

  cached
  TBuiltinBridgeObjectType convertBuiltinBridgeObjectTypeFromDb(Db::Element e) {
    result = TBuiltinBridgeObjectType(e)
  }

  cached
  TBuiltinDefaultActorStorageType convertBuiltinDefaultActorStorageTypeFromDb(Db::Element e) {
    result = TBuiltinDefaultActorStorageType(e)
  }

  cached
  TBuiltinExecutorType convertBuiltinExecutorTypeFromDb(Db::Element e) {
    result = TBuiltinExecutorType(e)
  }

  cached
  TBuiltinFloatType convertBuiltinFloatTypeFromDb(Db::Element e) { result = TBuiltinFloatType(e) }

  cached
  TBuiltinIntegerLiteralType convertBuiltinIntegerLiteralTypeFromDb(Db::Element e) {
    result = TBuiltinIntegerLiteralType(e)
  }

  cached
  TBuiltinIntegerType convertBuiltinIntegerTypeFromDb(Db::Element e) {
    result = TBuiltinIntegerType(e)
  }

  cached
  TBuiltinJobType convertBuiltinJobTypeFromDb(Db::Element e) { result = TBuiltinJobType(e) }

  cached
  TBuiltinNativeObjectType convertBuiltinNativeObjectTypeFromDb(Db::Element e) {
    result = TBuiltinNativeObjectType(e)
  }

  cached
  TBuiltinRawPointerType convertBuiltinRawPointerTypeFromDb(Db::Element e) {
    result = TBuiltinRawPointerType(e)
  }

  cached
  TBuiltinRawUnsafeContinuationType convertBuiltinRawUnsafeContinuationTypeFromDb(Db::Element e) {
    result = TBuiltinRawUnsafeContinuationType(e)
  }

  cached
  TBuiltinUnsafeValueBufferType convertBuiltinUnsafeValueBufferTypeFromDb(Db::Element e) {
    result = TBuiltinUnsafeValueBufferType(e)
  }

  cached
  TBuiltinVectorType convertBuiltinVectorTypeFromDb(Db::Element e) {
    result = TBuiltinVectorType(e)
  }

  cached
  TClassType convertClassTypeFromDb(Db::Element e) { result = TClassType(e) }

  cached
  TDependentMemberType convertDependentMemberTypeFromDb(Db::Element e) {
    result = TDependentMemberType(e)
  }

  cached
  TDictionaryType convertDictionaryTypeFromDb(Db::Element e) { result = TDictionaryType(e) }

  cached
  TDynamicSelfType convertDynamicSelfTypeFromDb(Db::Element e) { result = TDynamicSelfType(e) }

  cached
  TEnumType convertEnumTypeFromDb(Db::Element e) { result = TEnumType(e) }

  cached
  TErrorType convertErrorTypeFromDb(Db::Element e) { result = TErrorType(e) }

  cached
  TExistentialMetatypeType convertExistentialMetatypeTypeFromDb(Db::Element e) {
    result = TExistentialMetatypeType(e)
  }

  cached
  TExistentialType convertExistentialTypeFromDb(Db::Element e) { result = TExistentialType(e) }

  cached
  TFunctionType convertFunctionTypeFromDb(Db::Element e) { result = TFunctionType(e) }

  cached
  TGenericFunctionType convertGenericFunctionTypeFromDb(Db::Element e) {
    result = TGenericFunctionType(e)
  }

  cached
  TGenericTypeParamType convertGenericTypeParamTypeFromDb(Db::Element e) {
    result = TGenericTypeParamType(e)
  }

  cached
  TInOutType convertInOutTypeFromDb(Db::Element e) { result = TInOutType(e) }

  cached
  TLValueType convertLValueTypeFromDb(Db::Element e) { result = TLValueType(e) }

  cached
  TMetatypeType convertMetatypeTypeFromDb(Db::Element e) { result = TMetatypeType(e) }

  cached
  TModuleType convertModuleTypeFromDb(Db::Element e) { result = TModuleType(e) }

  cached
  TNestedArchetypeType convertNestedArchetypeTypeFromDb(Db::Element e) {
    result = TNestedArchetypeType(e)
  }

  cached
  TOpaqueTypeArchetypeType convertOpaqueTypeArchetypeTypeFromDb(Db::Element e) {
    result = TOpaqueTypeArchetypeType(e)
  }

  cached
  TOpenedArchetypeType convertOpenedArchetypeTypeFromDb(Db::Element e) {
    result = TOpenedArchetypeType(e)
  }

  cached
  TOptionalType convertOptionalTypeFromDb(Db::Element e) { result = TOptionalType(e) }

  cached
  TParenType convertParenTypeFromDb(Db::Element e) { result = TParenType(e) }

  cached
  TPlaceholderType convertPlaceholderTypeFromDb(Db::Element e) { result = TPlaceholderType(e) }

  cached
  TPrimaryArchetypeType convertPrimaryArchetypeTypeFromDb(Db::Element e) {
    result = TPrimaryArchetypeType(e)
  }

  cached
  TProtocolCompositionType convertProtocolCompositionTypeFromDb(Db::Element e) {
    result = TProtocolCompositionType(e)
  }

  cached
  TProtocolType convertProtocolTypeFromDb(Db::Element e) { result = TProtocolType(e) }

  cached
  TSequenceArchetypeType convertSequenceArchetypeTypeFromDb(Db::Element e) {
    result = TSequenceArchetypeType(e)
  }

  cached
  TSilBlockStorageType convertSilBlockStorageTypeFromDb(Db::Element e) {
    result = TSilBlockStorageType(e)
  }

  cached
  TSilBoxType convertSilBoxTypeFromDb(Db::Element e) { result = TSilBoxType(e) }

  cached
  TSilFunctionType convertSilFunctionTypeFromDb(Db::Element e) { result = TSilFunctionType(e) }

  cached
  TSilTokenType convertSilTokenTypeFromDb(Db::Element e) { result = TSilTokenType(e) }

  cached
  TStructType convertStructTypeFromDb(Db::Element e) { result = TStructType(e) }

  cached
  TTupleType convertTupleTypeFromDb(Db::Element e) { result = TTupleType(e) }

  cached
  TTypeAliasType convertTypeAliasTypeFromDb(Db::Element e) { result = TTypeAliasType(e) }

  cached
  TTypeRepr convertTypeReprFromDb(Db::Element e) { result = TTypeRepr(e) }

  cached
  TTypeVariableType convertTypeVariableTypeFromDb(Db::Element e) { result = TTypeVariableType(e) }

  cached
  TUnboundGenericType convertUnboundGenericTypeFromDb(Db::Element e) {
    result = TUnboundGenericType(e)
  }

  cached
  TUnmanagedStorageType convertUnmanagedStorageTypeFromDb(Db::Element e) {
    result = TUnmanagedStorageType(e)
  }

  cached
  TUnownedStorageType convertUnownedStorageTypeFromDb(Db::Element e) {
    result = TUnownedStorageType(e)
  }

  cached
  TUnresolvedType convertUnresolvedTypeFromDb(Db::Element e) { result = TUnresolvedType(e) }

  cached
  TVariadicSequenceType convertVariadicSequenceTypeFromDb(Db::Element e) {
    result = TVariadicSequenceType(e)
  }

  cached
  TWeakStorageType convertWeakStorageTypeFromDb(Db::Element e) { result = TWeakStorageType(e) }

  cached
  TAstNode convertAstNodeFromDb(Db::Element e) {
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
  TCallable convertCallableFromDb(Db::Element e) {
    result = convertAbstractClosureExprFromDb(e)
    or
    result = convertAbstractFunctionDeclFromDb(e)
  }

  cached
  TElement convertElementFromDb(Db::Element e) {
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
  TFile convertFileFromDb(Db::Element e) {
    result = convertDbFileFromDb(e)
    or
    result = convertUnknownFileFromDb(e)
  }

  cached
  TLocatable convertLocatableFromDb(Db::Element e) {
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
  TLocation convertLocationFromDb(Db::Element e) {
    result = convertDbLocationFromDb(e)
    or
    result = convertUnknownLocationFromDb(e)
  }

  cached
  TAbstractFunctionDecl convertAbstractFunctionDeclFromDb(Db::Element e) {
    result = convertConstructorDeclFromDb(e)
    or
    result = convertDestructorDeclFromDb(e)
    or
    result = convertFuncDeclFromDb(e)
  }

  cached
  TAbstractStorageDecl convertAbstractStorageDeclFromDb(Db::Element e) {
    result = convertSubscriptDeclFromDb(e)
    or
    result = convertVarDeclFromDb(e)
  }

  cached
  TAbstractTypeParamDecl convertAbstractTypeParamDeclFromDb(Db::Element e) {
    result = convertAssociatedTypeDeclFromDb(e)
    or
    result = convertGenericTypeParamDeclFromDb(e)
  }

  cached
  TDecl convertDeclFromDb(Db::Element e) {
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
  TFuncDecl convertFuncDeclFromDb(Db::Element e) {
    result = convertAccessorDeclFromDb(e)
    or
    result = convertConcreteFuncDeclFromDb(e)
  }

  cached
  TGenericContext convertGenericContextFromDb(Db::Element e) {
    result = convertAbstractFunctionDeclFromDb(e)
    or
    result = convertExtensionDeclFromDb(e)
    or
    result = convertGenericTypeDeclFromDb(e)
    or
    result = convertSubscriptDeclFromDb(e)
  }

  cached
  TGenericTypeDecl convertGenericTypeDeclFromDb(Db::Element e) {
    result = convertNominalTypeDeclFromDb(e)
    or
    result = convertOpaqueTypeDeclFromDb(e)
    or
    result = convertTypeAliasDeclFromDb(e)
  }

  cached
  TIterableDeclContext convertIterableDeclContextFromDb(Db::Element e) {
    result = convertExtensionDeclFromDb(e)
    or
    result = convertNominalTypeDeclFromDb(e)
  }

  cached
  TNominalTypeDecl convertNominalTypeDeclFromDb(Db::Element e) {
    result = convertClassDeclFromDb(e)
    or
    result = convertEnumDeclFromDb(e)
    or
    result = convertProtocolDeclFromDb(e)
    or
    result = convertStructDeclFromDb(e)
  }

  cached
  TOperatorDecl convertOperatorDeclFromDb(Db::Element e) {
    result = convertInfixOperatorDeclFromDb(e)
    or
    result = convertPostfixOperatorDeclFromDb(e)
    or
    result = convertPrefixOperatorDeclFromDb(e)
  }

  cached
  TTypeDecl convertTypeDeclFromDb(Db::Element e) {
    result = convertAbstractTypeParamDeclFromDb(e)
    or
    result = convertGenericTypeDeclFromDb(e)
    or
    result = convertModuleDeclFromDb(e)
  }

  cached
  TValueDecl convertValueDeclFromDb(Db::Element e) {
    result = convertAbstractFunctionDeclFromDb(e)
    or
    result = convertAbstractStorageDeclFromDb(e)
    or
    result = convertEnumElementDeclFromDb(e)
    or
    result = convertTypeDeclFromDb(e)
  }

  cached
  TVarDecl convertVarDeclFromDb(Db::Element e) {
    result = convertConcreteVarDeclFromDb(e)
    or
    result = convertParamDeclFromDb(e)
  }

  cached
  TAbstractClosureExpr convertAbstractClosureExprFromDb(Db::Element e) {
    result = convertAutoClosureExprFromDb(e)
    or
    result = convertClosureExprFromDb(e)
  }

  cached
  TAnyTryExpr convertAnyTryExprFromDb(Db::Element e) {
    result = convertForceTryExprFromDb(e)
    or
    result = convertOptionalTryExprFromDb(e)
    or
    result = convertTryExprFromDb(e)
  }

  cached
  TApplyExpr convertApplyExprFromDb(Db::Element e) {
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
  TBuiltinLiteralExpr convertBuiltinLiteralExprFromDb(Db::Element e) {
    result = convertBooleanLiteralExprFromDb(e)
    or
    result = convertMagicIdentifierLiteralExprFromDb(e)
    or
    result = convertNumberLiteralExprFromDb(e)
    or
    result = convertStringLiteralExprFromDb(e)
  }

  cached
  TCheckedCastExpr convertCheckedCastExprFromDb(Db::Element e) {
    result = convertConditionalCheckedCastExprFromDb(e)
    or
    result = convertForcedCheckedCastExprFromDb(e)
    or
    result = convertIsExprFromDb(e)
  }

  cached
  TCollectionExpr convertCollectionExprFromDb(Db::Element e) {
    result = convertArrayExprFromDb(e)
    or
    result = convertDictionaryExprFromDb(e)
  }

  cached
  TDynamicLookupExpr convertDynamicLookupExprFromDb(Db::Element e) {
    result = convertDynamicMemberRefExprFromDb(e)
    or
    result = convertDynamicSubscriptExprFromDb(e)
  }

  cached
  TExplicitCastExpr convertExplicitCastExprFromDb(Db::Element e) {
    result = convertCheckedCastExprFromDb(e)
    or
    result = convertCoerceExprFromDb(e)
  }

  cached
  TExpr convertExprFromDb(Db::Element e) {
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
  TIdentityExpr convertIdentityExprFromDb(Db::Element e) {
    result = convertAwaitExprFromDb(e)
    or
    result = convertDotSelfExprFromDb(e)
    or
    result = convertParenExprFromDb(e)
    or
    result = convertUnresolvedMemberChainResultExprFromDb(e)
  }

  cached
  TImplicitConversionExpr convertImplicitConversionExprFromDb(Db::Element e) {
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
  TLiteralExpr convertLiteralExprFromDb(Db::Element e) {
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
  TLookupExpr convertLookupExprFromDb(Db::Element e) {
    result = convertDynamicLookupExprFromDb(e)
    or
    result = convertMemberRefExprFromDb(e)
    or
    result = convertSubscriptExprFromDb(e)
  }

  cached
  TNumberLiteralExpr convertNumberLiteralExprFromDb(Db::Element e) {
    result = convertFloatLiteralExprFromDb(e)
    or
    result = convertIntegerLiteralExprFromDb(e)
  }

  cached
  TOverloadSetRefExpr convertOverloadSetRefExprFromDb(Db::Element e) {
    result = convertOverloadedDeclRefExprFromDb(e)
  }

  cached
  TSelfApplyExpr convertSelfApplyExprFromDb(Db::Element e) {
    result = convertConstructorRefCallExprFromDb(e)
    or
    result = convertDotSyntaxCallExprFromDb(e)
  }

  cached
  TPattern convertPatternFromDb(Db::Element e) {
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
  TLabeledConditionalStmt convertLabeledConditionalStmtFromDb(Db::Element e) {
    result = convertGuardStmtFromDb(e)
    or
    result = convertIfStmtFromDb(e)
    or
    result = convertWhileStmtFromDb(e)
  }

  cached
  TLabeledStmt convertLabeledStmtFromDb(Db::Element e) {
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
  TStmt convertStmtFromDb(Db::Element e) {
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
  TAnyBuiltinIntegerType convertAnyBuiltinIntegerTypeFromDb(Db::Element e) {
    result = convertBuiltinIntegerLiteralTypeFromDb(e)
    or
    result = convertBuiltinIntegerTypeFromDb(e)
  }

  cached
  TAnyFunctionType convertAnyFunctionTypeFromDb(Db::Element e) {
    result = convertFunctionTypeFromDb(e)
    or
    result = convertGenericFunctionTypeFromDb(e)
  }

  cached
  TAnyGenericType convertAnyGenericTypeFromDb(Db::Element e) {
    result = convertNominalOrBoundGenericNominalTypeFromDb(e)
    or
    result = convertUnboundGenericTypeFromDb(e)
  }

  cached
  TAnyMetatypeType convertAnyMetatypeTypeFromDb(Db::Element e) {
    result = convertExistentialMetatypeTypeFromDb(e)
    or
    result = convertMetatypeTypeFromDb(e)
  }

  cached
  TArchetypeType convertArchetypeTypeFromDb(Db::Element e) {
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
  TBoundGenericType convertBoundGenericTypeFromDb(Db::Element e) {
    result = convertBoundGenericClassTypeFromDb(e)
    or
    result = convertBoundGenericEnumTypeFromDb(e)
    or
    result = convertBoundGenericStructTypeFromDb(e)
  }

  cached
  TBuiltinType convertBuiltinTypeFromDb(Db::Element e) {
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
  TNominalOrBoundGenericNominalType convertNominalOrBoundGenericNominalTypeFromDb(Db::Element e) {
    result = convertBoundGenericTypeFromDb(e)
    or
    result = convertNominalTypeFromDb(e)
  }

  cached
  TNominalType convertNominalTypeFromDb(Db::Element e) {
    result = convertClassTypeFromDb(e)
    or
    result = convertEnumTypeFromDb(e)
    or
    result = convertProtocolTypeFromDb(e)
    or
    result = convertStructTypeFromDb(e)
  }

  cached
  TReferenceStorageType convertReferenceStorageTypeFromDb(Db::Element e) {
    result = convertUnmanagedStorageTypeFromDb(e)
    or
    result = convertUnownedStorageTypeFromDb(e)
    or
    result = convertWeakStorageTypeFromDb(e)
  }

  cached
  TSubstitutableType convertSubstitutableTypeFromDb(Db::Element e) {
    result = convertArchetypeTypeFromDb(e)
    or
    result = convertGenericTypeParamTypeFromDb(e)
  }

  cached
  TSugarType convertSugarTypeFromDb(Db::Element e) {
    result = convertParenTypeFromDb(e)
    or
    result = convertSyntaxSugarTypeFromDb(e)
    or
    result = convertTypeAliasTypeFromDb(e)
  }

  cached
  TSyntaxSugarType convertSyntaxSugarTypeFromDb(Db::Element e) {
    result = convertDictionaryTypeFromDb(e)
    or
    result = convertUnarySyntaxSugarTypeFromDb(e)
  }

  cached
  TType convertTypeFromDb(Db::Element e) {
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
  TUnarySyntaxSugarType convertUnarySyntaxSugarTypeFromDb(Db::Element e) {
    result = convertArraySliceTypeFromDb(e)
    or
    result = convertOptionalTypeFromDb(e)
    or
    result = convertVariadicSequenceTypeFromDb(e)
  }

  cached
  Db::Element convertCommentToDb(TComment e) { e = TComment(result) }

  cached
  Db::Element convertDbFileToDb(TDbFile e) { e = TDbFile(result) }

  cached
  Db::Element convertDbLocationToDb(TDbLocation e) { e = TDbLocation(result) }

  cached
  Db::Element convertUnknownFileToDb(TUnknownFile e) { none() }

  cached
  Db::Element convertUnknownLocationToDb(TUnknownLocation e) { none() }

  cached
  Db::Element convertAccessorDeclToDb(TAccessorDecl e) { e = TAccessorDecl(result) }

  cached
  Db::Element convertAssociatedTypeDeclToDb(TAssociatedTypeDecl e) {
    e = TAssociatedTypeDecl(result)
  }

  cached
  Db::Element convertClassDeclToDb(TClassDecl e) { e = TClassDecl(result) }

  cached
  Db::Element convertConcreteFuncDeclToDb(TConcreteFuncDecl e) { e = TConcreteFuncDecl(result) }

  cached
  Db::Element convertConcreteVarDeclToDb(TConcreteVarDecl e) { e = TConcreteVarDecl(result) }

  cached
  Db::Element convertConstructorDeclToDb(TConstructorDecl e) { e = TConstructorDecl(result) }

  cached
  Db::Element convertDestructorDeclToDb(TDestructorDecl e) { e = TDestructorDecl(result) }

  cached
  Db::Element convertEnumCaseDeclToDb(TEnumCaseDecl e) { e = TEnumCaseDecl(result) }

  cached
  Db::Element convertEnumDeclToDb(TEnumDecl e) { e = TEnumDecl(result) }

  cached
  Db::Element convertEnumElementDeclToDb(TEnumElementDecl e) { e = TEnumElementDecl(result) }

  cached
  Db::Element convertExtensionDeclToDb(TExtensionDecl e) { e = TExtensionDecl(result) }

  cached
  Db::Element convertGenericTypeParamDeclToDb(TGenericTypeParamDecl e) {
    e = TGenericTypeParamDecl(result)
  }

  cached
  Db::Element convertIfConfigClauseToDb(TIfConfigClause e) { e = TIfConfigClause(result) }

  cached
  Db::Element convertIfConfigDeclToDb(TIfConfigDecl e) { e = TIfConfigDecl(result) }

  cached
  Db::Element convertImportDeclToDb(TImportDecl e) { e = TImportDecl(result) }

  cached
  Db::Element convertInfixOperatorDeclToDb(TInfixOperatorDecl e) { e = TInfixOperatorDecl(result) }

  cached
  Db::Element convertMissingMemberDeclToDb(TMissingMemberDecl e) { e = TMissingMemberDecl(result) }

  cached
  Db::Element convertModuleDeclToDb(TModuleDecl e) { e = TModuleDecl(result) }

  cached
  Db::Element convertOpaqueTypeDeclToDb(TOpaqueTypeDecl e) { e = TOpaqueTypeDecl(result) }

  cached
  Db::Element convertParamDeclToDb(TParamDecl e) { e = TParamDecl(result) }

  cached
  Db::Element convertPatternBindingDeclToDb(TPatternBindingDecl e) {
    e = TPatternBindingDecl(result)
  }

  cached
  Db::Element convertPostfixOperatorDeclToDb(TPostfixOperatorDecl e) {
    e = TPostfixOperatorDecl(result)
  }

  cached
  Db::Element convertPoundDiagnosticDeclToDb(TPoundDiagnosticDecl e) {
    e = TPoundDiagnosticDecl(result)
  }

  cached
  Db::Element convertPrecedenceGroupDeclToDb(TPrecedenceGroupDecl e) {
    e = TPrecedenceGroupDecl(result)
  }

  cached
  Db::Element convertPrefixOperatorDeclToDb(TPrefixOperatorDecl e) {
    e = TPrefixOperatorDecl(result)
  }

  cached
  Db::Element convertProtocolDeclToDb(TProtocolDecl e) { e = TProtocolDecl(result) }

  cached
  Db::Element convertStructDeclToDb(TStructDecl e) { e = TStructDecl(result) }

  cached
  Db::Element convertSubscriptDeclToDb(TSubscriptDecl e) { e = TSubscriptDecl(result) }

  cached
  Db::Element convertTopLevelCodeDeclToDb(TTopLevelCodeDecl e) { e = TTopLevelCodeDecl(result) }

  cached
  Db::Element convertTypeAliasDeclToDb(TTypeAliasDecl e) { e = TTypeAliasDecl(result) }

  cached
  Db::Element convertAnyHashableErasureExprToDb(TAnyHashableErasureExpr e) {
    e = TAnyHashableErasureExpr(result)
  }

  cached
  Db::Element convertAppliedPropertyWrapperExprToDb(TAppliedPropertyWrapperExpr e) {
    e = TAppliedPropertyWrapperExpr(result)
  }

  cached
  Db::Element convertArchetypeToSuperExprToDb(TArchetypeToSuperExpr e) {
    e = TArchetypeToSuperExpr(result)
  }

  cached
  Db::Element convertArgumentToDb(TArgument e) { e = TArgument(result) }

  cached
  Db::Element convertArrayExprToDb(TArrayExpr e) { e = TArrayExpr(result) }

  cached
  Db::Element convertArrayToPointerExprToDb(TArrayToPointerExpr e) {
    e = TArrayToPointerExpr(result)
  }

  cached
  Db::Element convertArrowExprToDb(TArrowExpr e) { e = TArrowExpr(result) }

  cached
  Db::Element convertAssignExprToDb(TAssignExpr e) { e = TAssignExpr(result) }

  cached
  Db::Element convertAutoClosureExprToDb(TAutoClosureExpr e) { e = TAutoClosureExpr(result) }

  cached
  Db::Element convertAwaitExprToDb(TAwaitExpr e) { e = TAwaitExpr(result) }

  cached
  Db::Element convertBinaryExprToDb(TBinaryExpr e) { e = TBinaryExpr(result) }

  cached
  Db::Element convertBindOptionalExprToDb(TBindOptionalExpr e) { e = TBindOptionalExpr(result) }

  cached
  Db::Element convertBooleanLiteralExprToDb(TBooleanLiteralExpr e) {
    e = TBooleanLiteralExpr(result)
  }

  cached
  Db::Element convertBridgeFromObjCExprToDb(TBridgeFromObjCExpr e) {
    e = TBridgeFromObjCExpr(result)
  }

  cached
  Db::Element convertBridgeToObjCExprToDb(TBridgeToObjCExpr e) { e = TBridgeToObjCExpr(result) }

  cached
  Db::Element convertCallExprToDb(TCallExpr e) { e = TCallExpr(result) }

  cached
  Db::Element convertCaptureListExprToDb(TCaptureListExpr e) { e = TCaptureListExpr(result) }

  cached
  Db::Element convertClassMetatypeToObjectExprToDb(TClassMetatypeToObjectExpr e) {
    e = TClassMetatypeToObjectExpr(result)
  }

  cached
  Db::Element convertClosureExprToDb(TClosureExpr e) { e = TClosureExpr(result) }

  cached
  Db::Element convertCodeCompletionExprToDb(TCodeCompletionExpr e) {
    e = TCodeCompletionExpr(result)
  }

  cached
  Db::Element convertCoerceExprToDb(TCoerceExpr e) { e = TCoerceExpr(result) }

  cached
  Db::Element convertCollectionUpcastConversionExprToDb(TCollectionUpcastConversionExpr e) {
    e = TCollectionUpcastConversionExpr(result)
  }

  cached
  Db::Element convertConditionalBridgeFromObjCExprToDb(TConditionalBridgeFromObjCExpr e) {
    e = TConditionalBridgeFromObjCExpr(result)
  }

  cached
  Db::Element convertConditionalCheckedCastExprToDb(TConditionalCheckedCastExpr e) {
    e = TConditionalCheckedCastExpr(result)
  }

  cached
  Db::Element convertConstructorRefCallExprToDb(TConstructorRefCallExpr e) {
    e = TConstructorRefCallExpr(result)
  }

  cached
  Db::Element convertCovariantFunctionConversionExprToDb(TCovariantFunctionConversionExpr e) {
    e = TCovariantFunctionConversionExpr(result)
  }

  cached
  Db::Element convertCovariantReturnConversionExprToDb(TCovariantReturnConversionExpr e) {
    e = TCovariantReturnConversionExpr(result)
  }

  cached
  Db::Element convertDeclRefExprToDb(TDeclRefExpr e) { e = TDeclRefExpr(result) }

  cached
  Db::Element convertDefaultArgumentExprToDb(TDefaultArgumentExpr e) {
    e = TDefaultArgumentExpr(result)
  }

  cached
  Db::Element convertDerivedToBaseExprToDb(TDerivedToBaseExpr e) { e = TDerivedToBaseExpr(result) }

  cached
  Db::Element convertDestructureTupleExprToDb(TDestructureTupleExpr e) {
    e = TDestructureTupleExpr(result)
  }

  cached
  Db::Element convertDictionaryExprToDb(TDictionaryExpr e) { e = TDictionaryExpr(result) }

  cached
  Db::Element convertDifferentiableFunctionExprToDb(TDifferentiableFunctionExpr e) {
    e = TDifferentiableFunctionExpr(result)
  }

  cached
  Db::Element convertDifferentiableFunctionExtractOriginalExprToDb(
    TDifferentiableFunctionExtractOriginalExpr e
  ) {
    e = TDifferentiableFunctionExtractOriginalExpr(result)
  }

  cached
  Db::Element convertDiscardAssignmentExprToDb(TDiscardAssignmentExpr e) {
    e = TDiscardAssignmentExpr(result)
  }

  cached
  Db::Element convertDotSelfExprToDb(TDotSelfExpr e) { e = TDotSelfExpr(result) }

  cached
  Db::Element convertDotSyntaxBaseIgnoredExprToDb(TDotSyntaxBaseIgnoredExpr e) {
    e = TDotSyntaxBaseIgnoredExpr(result)
  }

  cached
  Db::Element convertDotSyntaxCallExprToDb(TDotSyntaxCallExpr e) { e = TDotSyntaxCallExpr(result) }

  cached
  Db::Element convertDynamicMemberRefExprToDb(TDynamicMemberRefExpr e) {
    e = TDynamicMemberRefExpr(result)
  }

  cached
  Db::Element convertDynamicSubscriptExprToDb(TDynamicSubscriptExpr e) {
    e = TDynamicSubscriptExpr(result)
  }

  cached
  Db::Element convertDynamicTypeExprToDb(TDynamicTypeExpr e) { e = TDynamicTypeExpr(result) }

  cached
  Db::Element convertEditorPlaceholderExprToDb(TEditorPlaceholderExpr e) {
    e = TEditorPlaceholderExpr(result)
  }

  cached
  Db::Element convertEnumIsCaseExprToDb(TEnumIsCaseExpr e) { e = TEnumIsCaseExpr(result) }

  cached
  Db::Element convertErasureExprToDb(TErasureExpr e) { e = TErasureExpr(result) }

  cached
  Db::Element convertErrorExprToDb(TErrorExpr e) { e = TErrorExpr(result) }

  cached
  Db::Element convertExistentialMetatypeToObjectExprToDb(TExistentialMetatypeToObjectExpr e) {
    e = TExistentialMetatypeToObjectExpr(result)
  }

  cached
  Db::Element convertFloatLiteralExprToDb(TFloatLiteralExpr e) { e = TFloatLiteralExpr(result) }

  cached
  Db::Element convertForceTryExprToDb(TForceTryExpr e) { e = TForceTryExpr(result) }

  cached
  Db::Element convertForceValueExprToDb(TForceValueExpr e) { e = TForceValueExpr(result) }

  cached
  Db::Element convertForcedCheckedCastExprToDb(TForcedCheckedCastExpr e) {
    e = TForcedCheckedCastExpr(result)
  }

  cached
  Db::Element convertForeignObjectConversionExprToDb(TForeignObjectConversionExpr e) {
    e = TForeignObjectConversionExpr(result)
  }

  cached
  Db::Element convertFunctionConversionExprToDb(TFunctionConversionExpr e) {
    e = TFunctionConversionExpr(result)
  }

  cached
  Db::Element convertIfExprToDb(TIfExpr e) { e = TIfExpr(result) }

  cached
  Db::Element convertInOutExprToDb(TInOutExpr e) { e = TInOutExpr(result) }

  cached
  Db::Element convertInOutToPointerExprToDb(TInOutToPointerExpr e) {
    e = TInOutToPointerExpr(result)
  }

  cached
  Db::Element convertInjectIntoOptionalExprToDb(TInjectIntoOptionalExpr e) {
    e = TInjectIntoOptionalExpr(result)
  }

  cached
  Db::Element convertIntegerLiteralExprToDb(TIntegerLiteralExpr e) {
    e = TIntegerLiteralExpr(result)
  }

  cached
  Db::Element convertInterpolatedStringLiteralExprToDb(TInterpolatedStringLiteralExpr e) {
    e = TInterpolatedStringLiteralExpr(result)
  }

  cached
  Db::Element convertIsExprToDb(TIsExpr e) { e = TIsExpr(result) }

  cached
  Db::Element convertKeyPathApplicationExprToDb(TKeyPathApplicationExpr e) {
    e = TKeyPathApplicationExpr(result)
  }

  cached
  Db::Element convertKeyPathDotExprToDb(TKeyPathDotExpr e) { e = TKeyPathDotExpr(result) }

  cached
  Db::Element convertKeyPathExprToDb(TKeyPathExpr e) { e = TKeyPathExpr(result) }

  cached
  Db::Element convertLazyInitializerExprToDb(TLazyInitializerExpr e) {
    e = TLazyInitializerExpr(result)
  }

  cached
  Db::Element convertLinearFunctionExprToDb(TLinearFunctionExpr e) {
    e = TLinearFunctionExpr(result)
  }

  cached
  Db::Element convertLinearFunctionExtractOriginalExprToDb(TLinearFunctionExtractOriginalExpr e) {
    e = TLinearFunctionExtractOriginalExpr(result)
  }

  cached
  Db::Element convertLinearToDifferentiableFunctionExprToDb(TLinearToDifferentiableFunctionExpr e) {
    e = TLinearToDifferentiableFunctionExpr(result)
  }

  cached
  Db::Element convertLoadExprToDb(TLoadExpr e) { e = TLoadExpr(result) }

  cached
  Db::Element convertMagicIdentifierLiteralExprToDb(TMagicIdentifierLiteralExpr e) {
    e = TMagicIdentifierLiteralExpr(result)
  }

  cached
  Db::Element convertMakeTemporarilyEscapableExprToDb(TMakeTemporarilyEscapableExpr e) {
    e = TMakeTemporarilyEscapableExpr(result)
  }

  cached
  Db::Element convertMemberRefExprToDb(TMemberRefExpr e) { e = TMemberRefExpr(result) }

  cached
  Db::Element convertMetatypeConversionExprToDb(TMetatypeConversionExpr e) {
    e = TMetatypeConversionExpr(result)
  }

  cached
  Db::Element convertNilLiteralExprToDb(TNilLiteralExpr e) { e = TNilLiteralExpr(result) }

  cached
  Db::Element convertObjCSelectorExprToDb(TObjCSelectorExpr e) { e = TObjCSelectorExpr(result) }

  cached
  Db::Element convertObjectLiteralExprToDb(TObjectLiteralExpr e) { e = TObjectLiteralExpr(result) }

  cached
  Db::Element convertOneWayExprToDb(TOneWayExpr e) { e = TOneWayExpr(result) }

  cached
  Db::Element convertOpaqueValueExprToDb(TOpaqueValueExpr e) { e = TOpaqueValueExpr(result) }

  cached
  Db::Element convertOpenExistentialExprToDb(TOpenExistentialExpr e) {
    e = TOpenExistentialExpr(result)
  }

  cached
  Db::Element convertOptionalEvaluationExprToDb(TOptionalEvaluationExpr e) {
    e = TOptionalEvaluationExpr(result)
  }

  cached
  Db::Element convertOptionalTryExprToDb(TOptionalTryExpr e) { e = TOptionalTryExpr(result) }

  cached
  Db::Element convertOtherConstructorDeclRefExprToDb(TOtherConstructorDeclRefExpr e) {
    e = TOtherConstructorDeclRefExpr(result)
  }

  cached
  Db::Element convertOverloadedDeclRefExprToDb(TOverloadedDeclRefExpr e) {
    e = TOverloadedDeclRefExpr(result)
  }

  cached
  Db::Element convertParenExprToDb(TParenExpr e) { e = TParenExpr(result) }

  cached
  Db::Element convertPointerToPointerExprToDb(TPointerToPointerExpr e) {
    e = TPointerToPointerExpr(result)
  }

  cached
  Db::Element convertPostfixUnaryExprToDb(TPostfixUnaryExpr e) { e = TPostfixUnaryExpr(result) }

  cached
  Db::Element convertPrefixUnaryExprToDb(TPrefixUnaryExpr e) { e = TPrefixUnaryExpr(result) }

  cached
  Db::Element convertPropertyWrapperValuePlaceholderExprToDb(TPropertyWrapperValuePlaceholderExpr e) {
    e = TPropertyWrapperValuePlaceholderExpr(result)
  }

  cached
  Db::Element convertProtocolMetatypeToObjectExprToDb(TProtocolMetatypeToObjectExpr e) {
    e = TProtocolMetatypeToObjectExpr(result)
  }

  cached
  Db::Element convertRebindSelfInConstructorExprToDb(TRebindSelfInConstructorExpr e) {
    e = TRebindSelfInConstructorExpr(result)
  }

  cached
  Db::Element convertRegexLiteralExprToDb(TRegexLiteralExpr e) { e = TRegexLiteralExpr(result) }

  cached
  Db::Element convertSequenceExprToDb(TSequenceExpr e) { e = TSequenceExpr(result) }

  cached
  Db::Element convertStringLiteralExprToDb(TStringLiteralExpr e) { e = TStringLiteralExpr(result) }

  cached
  Db::Element convertStringToPointerExprToDb(TStringToPointerExpr e) {
    e = TStringToPointerExpr(result)
  }

  cached
  Db::Element convertSubscriptExprToDb(TSubscriptExpr e) { e = TSubscriptExpr(result) }

  cached
  Db::Element convertSuperRefExprToDb(TSuperRefExpr e) { e = TSuperRefExpr(result) }

  cached
  Db::Element convertTapExprToDb(TTapExpr e) { e = TTapExpr(result) }

  cached
  Db::Element convertTryExprToDb(TTryExpr e) { e = TTryExpr(result) }

  cached
  Db::Element convertTupleElementExprToDb(TTupleElementExpr e) { e = TTupleElementExpr(result) }

  cached
  Db::Element convertTupleExprToDb(TTupleExpr e) { e = TTupleExpr(result) }

  cached
  Db::Element convertTypeExprToDb(TTypeExpr e) { e = TTypeExpr(result) }

  cached
  Db::Element convertUnderlyingToOpaqueExprToDb(TUnderlyingToOpaqueExpr e) {
    e = TUnderlyingToOpaqueExpr(result)
  }

  cached
  Db::Element convertUnevaluatedInstanceExprToDb(TUnevaluatedInstanceExpr e) {
    e = TUnevaluatedInstanceExpr(result)
  }

  cached
  Db::Element convertUnresolvedDeclRefExprToDb(TUnresolvedDeclRefExpr e) {
    e = TUnresolvedDeclRefExpr(result)
  }

  cached
  Db::Element convertUnresolvedDotExprToDb(TUnresolvedDotExpr e) { e = TUnresolvedDotExpr(result) }

  cached
  Db::Element convertUnresolvedMemberChainResultExprToDb(TUnresolvedMemberChainResultExpr e) {
    e = TUnresolvedMemberChainResultExpr(result)
  }

  cached
  Db::Element convertUnresolvedMemberExprToDb(TUnresolvedMemberExpr e) {
    e = TUnresolvedMemberExpr(result)
  }

  cached
  Db::Element convertUnresolvedPatternExprToDb(TUnresolvedPatternExpr e) {
    e = TUnresolvedPatternExpr(result)
  }

  cached
  Db::Element convertUnresolvedSpecializeExprToDb(TUnresolvedSpecializeExpr e) {
    e = TUnresolvedSpecializeExpr(result)
  }

  cached
  Db::Element convertUnresolvedTypeConversionExprToDb(TUnresolvedTypeConversionExpr e) {
    e = TUnresolvedTypeConversionExpr(result)
  }

  cached
  Db::Element convertVarargExpansionExprToDb(TVarargExpansionExpr e) {
    e = TVarargExpansionExpr(result)
  }

  cached
  Db::Element convertAnyPatternToDb(TAnyPattern e) { e = TAnyPattern(result) }

  cached
  Db::Element convertBindingPatternToDb(TBindingPattern e) { e = TBindingPattern(result) }

  cached
  Db::Element convertBoolPatternToDb(TBoolPattern e) { e = TBoolPattern(result) }

  cached
  Db::Element convertEnumElementPatternToDb(TEnumElementPattern e) {
    e = TEnumElementPattern(result)
  }

  cached
  Db::Element convertExprPatternToDb(TExprPattern e) { e = TExprPattern(result) }

  cached
  Db::Element convertIsPatternToDb(TIsPattern e) { e = TIsPattern(result) }

  cached
  Db::Element convertNamedPatternToDb(TNamedPattern e) { e = TNamedPattern(result) }

  cached
  Db::Element convertOptionalSomePatternToDb(TOptionalSomePattern e) {
    e = TOptionalSomePattern(result)
  }

  cached
  Db::Element convertParenPatternToDb(TParenPattern e) { e = TParenPattern(result) }

  cached
  Db::Element convertTuplePatternToDb(TTuplePattern e) { e = TTuplePattern(result) }

  cached
  Db::Element convertTypedPatternToDb(TTypedPattern e) { e = TTypedPattern(result) }

  cached
  Db::Element convertBraceStmtToDb(TBraceStmt e) { e = TBraceStmt(result) }

  cached
  Db::Element convertBreakStmtToDb(TBreakStmt e) { e = TBreakStmt(result) }

  cached
  Db::Element convertCaseLabelItemToDb(TCaseLabelItem e) { e = TCaseLabelItem(result) }

  cached
  Db::Element convertCaseStmtToDb(TCaseStmt e) { e = TCaseStmt(result) }

  cached
  Db::Element convertConditionElementToDb(TConditionElement e) { e = TConditionElement(result) }

  cached
  Db::Element convertContinueStmtToDb(TContinueStmt e) { e = TContinueStmt(result) }

  cached
  Db::Element convertDeferStmtToDb(TDeferStmt e) { e = TDeferStmt(result) }

  cached
  Db::Element convertDoCatchStmtToDb(TDoCatchStmt e) { e = TDoCatchStmt(result) }

  cached
  Db::Element convertDoStmtToDb(TDoStmt e) { e = TDoStmt(result) }

  cached
  Db::Element convertFailStmtToDb(TFailStmt e) { e = TFailStmt(result) }

  cached
  Db::Element convertFallthroughStmtToDb(TFallthroughStmt e) { e = TFallthroughStmt(result) }

  cached
  Db::Element convertForEachStmtToDb(TForEachStmt e) { e = TForEachStmt(result) }

  cached
  Db::Element convertGuardStmtToDb(TGuardStmt e) { e = TGuardStmt(result) }

  cached
  Db::Element convertIfStmtToDb(TIfStmt e) { e = TIfStmt(result) }

  cached
  Db::Element convertPoundAssertStmtToDb(TPoundAssertStmt e) { e = TPoundAssertStmt(result) }

  cached
  Db::Element convertRepeatWhileStmtToDb(TRepeatWhileStmt e) { e = TRepeatWhileStmt(result) }

  cached
  Db::Element convertReturnStmtToDb(TReturnStmt e) { e = TReturnStmt(result) }

  cached
  Db::Element convertStmtConditionToDb(TStmtCondition e) { e = TStmtCondition(result) }

  cached
  Db::Element convertSwitchStmtToDb(TSwitchStmt e) { e = TSwitchStmt(result) }

  cached
  Db::Element convertThrowStmtToDb(TThrowStmt e) { e = TThrowStmt(result) }

  cached
  Db::Element convertWhileStmtToDb(TWhileStmt e) { e = TWhileStmt(result) }

  cached
  Db::Element convertYieldStmtToDb(TYieldStmt e) { e = TYieldStmt(result) }

  cached
  Db::Element convertArraySliceTypeToDb(TArraySliceType e) { e = TArraySliceType(result) }

  cached
  Db::Element convertBoundGenericClassTypeToDb(TBoundGenericClassType e) {
    e = TBoundGenericClassType(result)
  }

  cached
  Db::Element convertBoundGenericEnumTypeToDb(TBoundGenericEnumType e) {
    e = TBoundGenericEnumType(result)
  }

  cached
  Db::Element convertBoundGenericStructTypeToDb(TBoundGenericStructType e) {
    e = TBoundGenericStructType(result)
  }

  cached
  Db::Element convertBuiltinBridgeObjectTypeToDb(TBuiltinBridgeObjectType e) {
    e = TBuiltinBridgeObjectType(result)
  }

  cached
  Db::Element convertBuiltinDefaultActorStorageTypeToDb(TBuiltinDefaultActorStorageType e) {
    e = TBuiltinDefaultActorStorageType(result)
  }

  cached
  Db::Element convertBuiltinExecutorTypeToDb(TBuiltinExecutorType e) {
    e = TBuiltinExecutorType(result)
  }

  cached
  Db::Element convertBuiltinFloatTypeToDb(TBuiltinFloatType e) { e = TBuiltinFloatType(result) }

  cached
  Db::Element convertBuiltinIntegerLiteralTypeToDb(TBuiltinIntegerLiteralType e) {
    e = TBuiltinIntegerLiteralType(result)
  }

  cached
  Db::Element convertBuiltinIntegerTypeToDb(TBuiltinIntegerType e) {
    e = TBuiltinIntegerType(result)
  }

  cached
  Db::Element convertBuiltinJobTypeToDb(TBuiltinJobType e) { e = TBuiltinJobType(result) }

  cached
  Db::Element convertBuiltinNativeObjectTypeToDb(TBuiltinNativeObjectType e) {
    e = TBuiltinNativeObjectType(result)
  }

  cached
  Db::Element convertBuiltinRawPointerTypeToDb(TBuiltinRawPointerType e) {
    e = TBuiltinRawPointerType(result)
  }

  cached
  Db::Element convertBuiltinRawUnsafeContinuationTypeToDb(TBuiltinRawUnsafeContinuationType e) {
    e = TBuiltinRawUnsafeContinuationType(result)
  }

  cached
  Db::Element convertBuiltinUnsafeValueBufferTypeToDb(TBuiltinUnsafeValueBufferType e) {
    e = TBuiltinUnsafeValueBufferType(result)
  }

  cached
  Db::Element convertBuiltinVectorTypeToDb(TBuiltinVectorType e) { e = TBuiltinVectorType(result) }

  cached
  Db::Element convertClassTypeToDb(TClassType e) { e = TClassType(result) }

  cached
  Db::Element convertDependentMemberTypeToDb(TDependentMemberType e) {
    e = TDependentMemberType(result)
  }

  cached
  Db::Element convertDictionaryTypeToDb(TDictionaryType e) { e = TDictionaryType(result) }

  cached
  Db::Element convertDynamicSelfTypeToDb(TDynamicSelfType e) { e = TDynamicSelfType(result) }

  cached
  Db::Element convertEnumTypeToDb(TEnumType e) { e = TEnumType(result) }

  cached
  Db::Element convertErrorTypeToDb(TErrorType e) { e = TErrorType(result) }

  cached
  Db::Element convertExistentialMetatypeTypeToDb(TExistentialMetatypeType e) {
    e = TExistentialMetatypeType(result)
  }

  cached
  Db::Element convertExistentialTypeToDb(TExistentialType e) { e = TExistentialType(result) }

  cached
  Db::Element convertFunctionTypeToDb(TFunctionType e) { e = TFunctionType(result) }

  cached
  Db::Element convertGenericFunctionTypeToDb(TGenericFunctionType e) {
    e = TGenericFunctionType(result)
  }

  cached
  Db::Element convertGenericTypeParamTypeToDb(TGenericTypeParamType e) {
    e = TGenericTypeParamType(result)
  }

  cached
  Db::Element convertInOutTypeToDb(TInOutType e) { e = TInOutType(result) }

  cached
  Db::Element convertLValueTypeToDb(TLValueType e) { e = TLValueType(result) }

  cached
  Db::Element convertMetatypeTypeToDb(TMetatypeType e) { e = TMetatypeType(result) }

  cached
  Db::Element convertModuleTypeToDb(TModuleType e) { e = TModuleType(result) }

  cached
  Db::Element convertNestedArchetypeTypeToDb(TNestedArchetypeType e) {
    e = TNestedArchetypeType(result)
  }

  cached
  Db::Element convertOpaqueTypeArchetypeTypeToDb(TOpaqueTypeArchetypeType e) {
    e = TOpaqueTypeArchetypeType(result)
  }

  cached
  Db::Element convertOpenedArchetypeTypeToDb(TOpenedArchetypeType e) {
    e = TOpenedArchetypeType(result)
  }

  cached
  Db::Element convertOptionalTypeToDb(TOptionalType e) { e = TOptionalType(result) }

  cached
  Db::Element convertParenTypeToDb(TParenType e) { e = TParenType(result) }

  cached
  Db::Element convertPlaceholderTypeToDb(TPlaceholderType e) { e = TPlaceholderType(result) }

  cached
  Db::Element convertPrimaryArchetypeTypeToDb(TPrimaryArchetypeType e) {
    e = TPrimaryArchetypeType(result)
  }

  cached
  Db::Element convertProtocolCompositionTypeToDb(TProtocolCompositionType e) {
    e = TProtocolCompositionType(result)
  }

  cached
  Db::Element convertProtocolTypeToDb(TProtocolType e) { e = TProtocolType(result) }

  cached
  Db::Element convertSequenceArchetypeTypeToDb(TSequenceArchetypeType e) {
    e = TSequenceArchetypeType(result)
  }

  cached
  Db::Element convertSilBlockStorageTypeToDb(TSilBlockStorageType e) {
    e = TSilBlockStorageType(result)
  }

  cached
  Db::Element convertSilBoxTypeToDb(TSilBoxType e) { e = TSilBoxType(result) }

  cached
  Db::Element convertSilFunctionTypeToDb(TSilFunctionType e) { e = TSilFunctionType(result) }

  cached
  Db::Element convertSilTokenTypeToDb(TSilTokenType e) { e = TSilTokenType(result) }

  cached
  Db::Element convertStructTypeToDb(TStructType e) { e = TStructType(result) }

  cached
  Db::Element convertTupleTypeToDb(TTupleType e) { e = TTupleType(result) }

  cached
  Db::Element convertTypeAliasTypeToDb(TTypeAliasType e) { e = TTypeAliasType(result) }

  cached
  Db::Element convertTypeReprToDb(TTypeRepr e) { e = TTypeRepr(result) }

  cached
  Db::Element convertTypeVariableTypeToDb(TTypeVariableType e) { e = TTypeVariableType(result) }

  cached
  Db::Element convertUnboundGenericTypeToDb(TUnboundGenericType e) {
    e = TUnboundGenericType(result)
  }

  cached
  Db::Element convertUnmanagedStorageTypeToDb(TUnmanagedStorageType e) {
    e = TUnmanagedStorageType(result)
  }

  cached
  Db::Element convertUnownedStorageTypeToDb(TUnownedStorageType e) {
    e = TUnownedStorageType(result)
  }

  cached
  Db::Element convertUnresolvedTypeToDb(TUnresolvedType e) { e = TUnresolvedType(result) }

  cached
  Db::Element convertVariadicSequenceTypeToDb(TVariadicSequenceType e) {
    e = TVariadicSequenceType(result)
  }

  cached
  Db::Element convertWeakStorageTypeToDb(TWeakStorageType e) { e = TWeakStorageType(result) }

  cached
  Db::Element convertAstNodeToDb(TAstNode e) {
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
  Db::Element convertCallableToDb(TCallable e) {
    result = convertAbstractClosureExprToDb(e)
    or
    result = convertAbstractFunctionDeclToDb(e)
  }

  cached
  Db::Element convertElementToDb(TElement e) {
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
  Db::Element convertFileToDb(TFile e) {
    result = convertDbFileToDb(e)
    or
    result = convertUnknownFileToDb(e)
  }

  cached
  Db::Element convertLocatableToDb(TLocatable e) {
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
  Db::Element convertLocationToDb(TLocation e) {
    result = convertDbLocationToDb(e)
    or
    result = convertUnknownLocationToDb(e)
  }

  cached
  Db::Element convertAbstractFunctionDeclToDb(TAbstractFunctionDecl e) {
    result = convertConstructorDeclToDb(e)
    or
    result = convertDestructorDeclToDb(e)
    or
    result = convertFuncDeclToDb(e)
  }

  cached
  Db::Element convertAbstractStorageDeclToDb(TAbstractStorageDecl e) {
    result = convertSubscriptDeclToDb(e)
    or
    result = convertVarDeclToDb(e)
  }

  cached
  Db::Element convertAbstractTypeParamDeclToDb(TAbstractTypeParamDecl e) {
    result = convertAssociatedTypeDeclToDb(e)
    or
    result = convertGenericTypeParamDeclToDb(e)
  }

  cached
  Db::Element convertDeclToDb(TDecl e) {
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
  Db::Element convertFuncDeclToDb(TFuncDecl e) {
    result = convertAccessorDeclToDb(e)
    or
    result = convertConcreteFuncDeclToDb(e)
  }

  cached
  Db::Element convertGenericContextToDb(TGenericContext e) {
    result = convertAbstractFunctionDeclToDb(e)
    or
    result = convertExtensionDeclToDb(e)
    or
    result = convertGenericTypeDeclToDb(e)
    or
    result = convertSubscriptDeclToDb(e)
  }

  cached
  Db::Element convertGenericTypeDeclToDb(TGenericTypeDecl e) {
    result = convertNominalTypeDeclToDb(e)
    or
    result = convertOpaqueTypeDeclToDb(e)
    or
    result = convertTypeAliasDeclToDb(e)
  }

  cached
  Db::Element convertIterableDeclContextToDb(TIterableDeclContext e) {
    result = convertExtensionDeclToDb(e)
    or
    result = convertNominalTypeDeclToDb(e)
  }

  cached
  Db::Element convertNominalTypeDeclToDb(TNominalTypeDecl e) {
    result = convertClassDeclToDb(e)
    or
    result = convertEnumDeclToDb(e)
    or
    result = convertProtocolDeclToDb(e)
    or
    result = convertStructDeclToDb(e)
  }

  cached
  Db::Element convertOperatorDeclToDb(TOperatorDecl e) {
    result = convertInfixOperatorDeclToDb(e)
    or
    result = convertPostfixOperatorDeclToDb(e)
    or
    result = convertPrefixOperatorDeclToDb(e)
  }

  cached
  Db::Element convertTypeDeclToDb(TTypeDecl e) {
    result = convertAbstractTypeParamDeclToDb(e)
    or
    result = convertGenericTypeDeclToDb(e)
    or
    result = convertModuleDeclToDb(e)
  }

  cached
  Db::Element convertValueDeclToDb(TValueDecl e) {
    result = convertAbstractFunctionDeclToDb(e)
    or
    result = convertAbstractStorageDeclToDb(e)
    or
    result = convertEnumElementDeclToDb(e)
    or
    result = convertTypeDeclToDb(e)
  }

  cached
  Db::Element convertVarDeclToDb(TVarDecl e) {
    result = convertConcreteVarDeclToDb(e)
    or
    result = convertParamDeclToDb(e)
  }

  cached
  Db::Element convertAbstractClosureExprToDb(TAbstractClosureExpr e) {
    result = convertAutoClosureExprToDb(e)
    or
    result = convertClosureExprToDb(e)
  }

  cached
  Db::Element convertAnyTryExprToDb(TAnyTryExpr e) {
    result = convertForceTryExprToDb(e)
    or
    result = convertOptionalTryExprToDb(e)
    or
    result = convertTryExprToDb(e)
  }

  cached
  Db::Element convertApplyExprToDb(TApplyExpr e) {
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
  Db::Element convertBuiltinLiteralExprToDb(TBuiltinLiteralExpr e) {
    result = convertBooleanLiteralExprToDb(e)
    or
    result = convertMagicIdentifierLiteralExprToDb(e)
    or
    result = convertNumberLiteralExprToDb(e)
    or
    result = convertStringLiteralExprToDb(e)
  }

  cached
  Db::Element convertCheckedCastExprToDb(TCheckedCastExpr e) {
    result = convertConditionalCheckedCastExprToDb(e)
    or
    result = convertForcedCheckedCastExprToDb(e)
    or
    result = convertIsExprToDb(e)
  }

  cached
  Db::Element convertCollectionExprToDb(TCollectionExpr e) {
    result = convertArrayExprToDb(e)
    or
    result = convertDictionaryExprToDb(e)
  }

  cached
  Db::Element convertDynamicLookupExprToDb(TDynamicLookupExpr e) {
    result = convertDynamicMemberRefExprToDb(e)
    or
    result = convertDynamicSubscriptExprToDb(e)
  }

  cached
  Db::Element convertExplicitCastExprToDb(TExplicitCastExpr e) {
    result = convertCheckedCastExprToDb(e)
    or
    result = convertCoerceExprToDb(e)
  }

  cached
  Db::Element convertExprToDb(TExpr e) {
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
  Db::Element convertIdentityExprToDb(TIdentityExpr e) {
    result = convertAwaitExprToDb(e)
    or
    result = convertDotSelfExprToDb(e)
    or
    result = convertParenExprToDb(e)
    or
    result = convertUnresolvedMemberChainResultExprToDb(e)
  }

  cached
  Db::Element convertImplicitConversionExprToDb(TImplicitConversionExpr e) {
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
  Db::Element convertLiteralExprToDb(TLiteralExpr e) {
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
  Db::Element convertLookupExprToDb(TLookupExpr e) {
    result = convertDynamicLookupExprToDb(e)
    or
    result = convertMemberRefExprToDb(e)
    or
    result = convertSubscriptExprToDb(e)
  }

  cached
  Db::Element convertNumberLiteralExprToDb(TNumberLiteralExpr e) {
    result = convertFloatLiteralExprToDb(e)
    or
    result = convertIntegerLiteralExprToDb(e)
  }

  cached
  Db::Element convertOverloadSetRefExprToDb(TOverloadSetRefExpr e) {
    result = convertOverloadedDeclRefExprToDb(e)
  }

  cached
  Db::Element convertSelfApplyExprToDb(TSelfApplyExpr e) {
    result = convertConstructorRefCallExprToDb(e)
    or
    result = convertDotSyntaxCallExprToDb(e)
  }

  cached
  Db::Element convertPatternToDb(TPattern e) {
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
  Db::Element convertLabeledConditionalStmtToDb(TLabeledConditionalStmt e) {
    result = convertGuardStmtToDb(e)
    or
    result = convertIfStmtToDb(e)
    or
    result = convertWhileStmtToDb(e)
  }

  cached
  Db::Element convertLabeledStmtToDb(TLabeledStmt e) {
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
  Db::Element convertStmtToDb(TStmt e) {
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
  Db::Element convertAnyBuiltinIntegerTypeToDb(TAnyBuiltinIntegerType e) {
    result = convertBuiltinIntegerLiteralTypeToDb(e)
    or
    result = convertBuiltinIntegerTypeToDb(e)
  }

  cached
  Db::Element convertAnyFunctionTypeToDb(TAnyFunctionType e) {
    result = convertFunctionTypeToDb(e)
    or
    result = convertGenericFunctionTypeToDb(e)
  }

  cached
  Db::Element convertAnyGenericTypeToDb(TAnyGenericType e) {
    result = convertNominalOrBoundGenericNominalTypeToDb(e)
    or
    result = convertUnboundGenericTypeToDb(e)
  }

  cached
  Db::Element convertAnyMetatypeTypeToDb(TAnyMetatypeType e) {
    result = convertExistentialMetatypeTypeToDb(e)
    or
    result = convertMetatypeTypeToDb(e)
  }

  cached
  Db::Element convertArchetypeTypeToDb(TArchetypeType e) {
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
  Db::Element convertBoundGenericTypeToDb(TBoundGenericType e) {
    result = convertBoundGenericClassTypeToDb(e)
    or
    result = convertBoundGenericEnumTypeToDb(e)
    or
    result = convertBoundGenericStructTypeToDb(e)
  }

  cached
  Db::Element convertBuiltinTypeToDb(TBuiltinType e) {
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
  Db::Element convertNominalOrBoundGenericNominalTypeToDb(TNominalOrBoundGenericNominalType e) {
    result = convertBoundGenericTypeToDb(e)
    or
    result = convertNominalTypeToDb(e)
  }

  cached
  Db::Element convertNominalTypeToDb(TNominalType e) {
    result = convertClassTypeToDb(e)
    or
    result = convertEnumTypeToDb(e)
    or
    result = convertProtocolTypeToDb(e)
    or
    result = convertStructTypeToDb(e)
  }

  cached
  Db::Element convertReferenceStorageTypeToDb(TReferenceStorageType e) {
    result = convertUnmanagedStorageTypeToDb(e)
    or
    result = convertUnownedStorageTypeToDb(e)
    or
    result = convertWeakStorageTypeToDb(e)
  }

  cached
  Db::Element convertSubstitutableTypeToDb(TSubstitutableType e) {
    result = convertArchetypeTypeToDb(e)
    or
    result = convertGenericTypeParamTypeToDb(e)
  }

  cached
  Db::Element convertSugarTypeToDb(TSugarType e) {
    result = convertParenTypeToDb(e)
    or
    result = convertSyntaxSugarTypeToDb(e)
    or
    result = convertTypeAliasTypeToDb(e)
  }

  cached
  Db::Element convertSyntaxSugarTypeToDb(TSyntaxSugarType e) {
    result = convertDictionaryTypeToDb(e)
    or
    result = convertUnarySyntaxSugarTypeToDb(e)
  }

  cached
  Db::Element convertTypeToDb(TType e) {
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
  Db::Element convertUnarySyntaxSugarTypeToDb(TUnarySyntaxSugarType e) {
    result = convertArraySliceTypeToDb(e)
    or
    result = convertOptionalTypeToDb(e)
    or
    result = convertVariadicSequenceTypeToDb(e)
  }
}
