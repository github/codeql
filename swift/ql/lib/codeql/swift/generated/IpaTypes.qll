private import codeql.swift.elements.IpaConstructors

cached
module Cached {
  cached
  newtype TElement =
    TFile(@file id) or
    TLocation(@location id) or
    TAccessorDecl(@accessor_decl id) or
    TAssociatedTypeDecl(@associated_type_decl id) or
    TClassDecl(@class_decl id) or
    TConcreteFuncDecl(@concrete_func_decl id) or
    TConcreteVarDecl(@concrete_var_decl id) or
    TConstructorDecl(@constructor_decl id) or
    TDestructorDecl(@destructor_decl id) or
    TEnumCaseDecl(@enum_case_decl id) or
    TEnumDecl(@enum_decl id) or
    TEnumElementDecl(@enum_element_decl id) or
    TExtensionDecl(@extension_decl id) or
    TGenericTypeParamDecl(@generic_type_param_decl id) or
    TIfConfigClause(@if_config_clause id) or
    TIfConfigDecl(@if_config_decl id) or
    TImportDecl(@import_decl id) or
    TInfixOperatorDecl(@infix_operator_decl id) or
    TMissingMemberDecl(@missing_member_decl id) or
    TModuleDecl(@module_decl id) or
    TOpaqueTypeDecl(@opaque_type_decl id) or
    TParamDecl(@param_decl id) or
    TPatternBindingDecl(@pattern_binding_decl id) or
    TPostfixOperatorDecl(@postfix_operator_decl id) or
    TPoundDiagnosticDecl(@pound_diagnostic_decl id) or
    TPrecedenceGroupDecl(@precedence_group_decl id) or
    TPrefixOperatorDecl(@prefix_operator_decl id) or
    TProtocolDecl(@protocol_decl id) or
    TStructDecl(@struct_decl id) or
    TSubscriptDecl(@subscript_decl id) or
    TTopLevelCodeDecl(@top_level_code_decl id) or
    TTypeAliasDecl(@type_alias_decl id) or
    TAnyHashableErasureExpr(@any_hashable_erasure_expr id) or
    TAppliedPropertyWrapperExpr(@applied_property_wrapper_expr id) or
    TArchetypeToSuperExpr(@archetype_to_super_expr id) or
    TArgument(@argument id) or
    TArrayExpr(@array_expr id) or
    TArrayToPointerExpr(@array_to_pointer_expr id) or
    TArrowExpr(@arrow_expr id) or
    TAssignExpr(@assign_expr id) or
    TAutoClosureExpr(@auto_closure_expr id) or
    TAwaitExpr(@await_expr id) or
    TBinaryExpr(@binary_expr id) or
    TBindOptionalExpr(@bind_optional_expr id) or
    TBooleanLiteralExpr(@boolean_literal_expr id) or
    TBridgeFromObjCExpr(@bridge_from_obj_c_expr id) or
    TBridgeToObjCExpr(@bridge_to_obj_c_expr id) or
    TCallExpr(@call_expr id) { not constructMethodCallExpr(id) } or
    TCaptureListExpr(@capture_list_expr id) or
    TClassMetatypeToObjectExpr(@class_metatype_to_object_expr id) or
    TClosureExpr(@closure_expr id) or
    TCodeCompletionExpr(@code_completion_expr id) or
    TCoerceExpr(@coerce_expr id) or
    TCollectionUpcastConversionExpr(@collection_upcast_conversion_expr id) or
    TConditionalBridgeFromObjCExpr(@conditional_bridge_from_obj_c_expr id) or
    TConditionalCheckedCastExpr(@conditional_checked_cast_expr id) or
    TConstructorRefCallExpr(@constructor_ref_call_expr id) or
    TCovariantFunctionConversionExpr(@covariant_function_conversion_expr id) or
    TCovariantReturnConversionExpr(@covariant_return_conversion_expr id) or
    TDeclRefExpr(@decl_ref_expr id) or
    TDefaultArgumentExpr(@default_argument_expr id) or
    TDerivedToBaseExpr(@derived_to_base_expr id) or
    TDestructureTupleExpr(@destructure_tuple_expr id) or
    TDictionaryExpr(@dictionary_expr id) or
    TDifferentiableFunctionExpr(@differentiable_function_expr id) or
    TDifferentiableFunctionExtractOriginalExpr(@differentiable_function_extract_original_expr id) or
    TDiscardAssignmentExpr(@discard_assignment_expr id) or
    TDotSelfExpr(@dot_self_expr id) or
    TDotSyntaxBaseIgnoredExpr(@dot_syntax_base_ignored_expr id) or
    TDotSyntaxCallExpr(@dot_syntax_call_expr id) or
    TDynamicMemberRefExpr(@dynamic_member_ref_expr id) or
    TDynamicSubscriptExpr(@dynamic_subscript_expr id) or
    TDynamicTypeExpr(@dynamic_type_expr id) or
    TEditorPlaceholderExpr(@editor_placeholder_expr id) or
    TEnumIsCaseExpr(@enum_is_case_expr id) or
    TErasureExpr(@erasure_expr id) or
    TErrorExpr(@error_expr id) or
    TExistentialMetatypeToObjectExpr(@existential_metatype_to_object_expr id) or
    TFloatLiteralExpr(@float_literal_expr id) or
    TForceTryExpr(@force_try_expr id) or
    TForceValueExpr(@force_value_expr id) or
    TForcedCheckedCastExpr(@forced_checked_cast_expr id) or
    TForeignObjectConversionExpr(@foreign_object_conversion_expr id) or
    TFunctionConversionExpr(@function_conversion_expr id) or
    TIfExpr(@if_expr id) or
    TInOutExpr(@in_out_expr id) or
    TInOutToPointerExpr(@in_out_to_pointer_expr id) or
    TInjectIntoOptionalExpr(@inject_into_optional_expr id) or
    TIntegerLiteralExpr(@integer_literal_expr id) or
    TInterpolatedStringLiteralExpr(@interpolated_string_literal_expr id) or
    TIsExpr(@is_expr id) or
    TKeyPathApplicationExpr(@key_path_application_expr id) or
    TKeyPathDotExpr(@key_path_dot_expr id) or
    TKeyPathExpr(@key_path_expr id) or
    TLazyInitializerExpr(@lazy_initializer_expr id) or
    TLinearFunctionExpr(@linear_function_expr id) or
    TLinearFunctionExtractOriginalExpr(@linear_function_extract_original_expr id) or
    TLinearToDifferentiableFunctionExpr(@linear_to_differentiable_function_expr id) or
    TLoadExpr(@load_expr id) or
    TMagicIdentifierLiteralExpr(@magic_identifier_literal_expr id) or
    TMakeTemporarilyEscapableExpr(@make_temporarily_escapable_expr id) or
    TMemberRefExpr(@member_ref_expr id) or
    TMetatypeConversionExpr(@metatype_conversion_expr id) or
    TMethodCallExpr(@call_expr id) { constructMethodCallExpr(id) } or
    TNilLiteralExpr(@nil_literal_expr id) or
    TObjCSelectorExpr(@obj_c_selector_expr id) or
    TObjectLiteralExpr(@object_literal_expr id) or
    TOneWayExpr(@one_way_expr id) or
    TOpaqueValueExpr(@opaque_value_expr id) or
    TOpenExistentialExpr(@open_existential_expr id) or
    TOptionalEvaluationExpr(@optional_evaluation_expr id) or
    TOptionalTryExpr(@optional_try_expr id) or
    TOtherConstructorDeclRefExpr(@other_constructor_decl_ref_expr id) or
    TOverloadedDeclRefExpr(@overloaded_decl_ref_expr id) or
    TParenExpr(@paren_expr id) or
    TPointerToPointerExpr(@pointer_to_pointer_expr id) or
    TPostfixUnaryExpr(@postfix_unary_expr id) or
    TPrefixUnaryExpr(@prefix_unary_expr id) or
    TPropertyWrapperValuePlaceholderExpr(@property_wrapper_value_placeholder_expr id) or
    TProtocolMetatypeToObjectExpr(@protocol_metatype_to_object_expr id) or
    TRebindSelfInConstructorExpr(@rebind_self_in_constructor_expr id) or
    TRegexLiteralExpr(@regex_literal_expr id) or
    TSequenceExpr(@sequence_expr id) or
    TStringLiteralExpr(@string_literal_expr id) or
    TStringToPointerExpr(@string_to_pointer_expr id) or
    TSubscriptExpr(@subscript_expr id) or
    TSuperRefExpr(@super_ref_expr id) or
    TTapExpr(@tap_expr id) or
    TTryExpr(@try_expr id) or
    TTupleElementExpr(@tuple_element_expr id) or
    TTupleExpr(@tuple_expr id) or
    TTypeExpr(@type_expr id) or
    TUnderlyingToOpaqueExpr(@underlying_to_opaque_expr id) or
    TUnevaluatedInstanceExpr(@unevaluated_instance_expr id) or
    TUnresolvedDeclRefExpr(@unresolved_decl_ref_expr id) or
    TUnresolvedDotExpr(@unresolved_dot_expr id) or
    TUnresolvedMemberChainResultExpr(@unresolved_member_chain_result_expr id) or
    TUnresolvedMemberExpr(@unresolved_member_expr id) or
    TUnresolvedPatternExpr(@unresolved_pattern_expr id) or
    TUnresolvedSpecializeExpr(@unresolved_specialize_expr id) or
    TUnresolvedTypeConversionExpr(@unresolved_type_conversion_expr id) or
    TVarargExpansionExpr(@vararg_expansion_expr id) or
    TAnyPattern(@any_pattern id) or
    TBindingPattern(@binding_pattern id) or
    TBoolPattern(@bool_pattern id) or
    TEnumElementPattern(@enum_element_pattern id) or
    TExprPattern(@expr_pattern id) or
    TIsPattern(@is_pattern id) or
    TNamedPattern(@named_pattern id) or
    TOptionalSomePattern(@optional_some_pattern id) or
    TParenPattern(@paren_pattern id) or
    TTuplePattern(@tuple_pattern id) or
    TTypedPattern(@typed_pattern id) or
    TBraceStmt(@brace_stmt id) or
    TBreakStmt(@break_stmt id) or
    TCaseLabelItem(@case_label_item id) or
    TCaseStmt(@case_stmt id) or
    TConditionElement(@condition_element id) or
    TContinueStmt(@continue_stmt id) or
    TDeferStmt(@defer_stmt id) or
    TDoCatchStmt(@do_catch_stmt id) or
    TDoStmt(@do_stmt id) or
    TFailStmt(@fail_stmt id) or
    TFallthroughStmt(@fallthrough_stmt id) or
    TForEachStmt(@for_each_stmt id) or
    TGuardStmt(@guard_stmt id) or
    TIfStmt(@if_stmt id) or
    TPoundAssertStmt(@pound_assert_stmt id) or
    TRepeatWhileStmt(@repeat_while_stmt id) or
    TReturnStmt(@return_stmt id) or
    TStmtCondition(@stmt_condition id) or
    TSwitchStmt(@switch_stmt id) or
    TThrowStmt(@throw_stmt id) or
    TWhileStmt(@while_stmt id) or
    TYieldStmt(@yield_stmt id) or
    TArraySliceType(@array_slice_type id) or
    TBoundGenericClassType(@bound_generic_class_type id) or
    TBoundGenericEnumType(@bound_generic_enum_type id) or
    TBoundGenericStructType(@bound_generic_struct_type id) or
    TBuiltinBridgeObjectType(@builtin_bridge_object_type id) or
    TBuiltinDefaultActorStorageType(@builtin_default_actor_storage_type id) or
    TBuiltinExecutorType(@builtin_executor_type id) or
    TBuiltinFloatType(@builtin_float_type id) or
    TBuiltinIntegerLiteralType(@builtin_integer_literal_type id) or
    TBuiltinIntegerType(@builtin_integer_type id) or
    TBuiltinJobType(@builtin_job_type id) or
    TBuiltinNativeObjectType(@builtin_native_object_type id) or
    TBuiltinRawPointerType(@builtin_raw_pointer_type id) or
    TBuiltinRawUnsafeContinuationType(@builtin_raw_unsafe_continuation_type id) or
    TBuiltinUnsafeValueBufferType(@builtin_unsafe_value_buffer_type id) or
    TBuiltinVectorType(@builtin_vector_type id) or
    TClassType(@class_type id) or
    TDependentMemberType(@dependent_member_type id) or
    TDictionaryType(@dictionary_type id) or
    TDynamicSelfType(@dynamic_self_type id) or
    TEnumType(@enum_type id) or
    TErrorType(@error_type id) or
    TExistentialMetatypeType(@existential_metatype_type id) or
    TExistentialType(@existential_type id) or
    TFunctionType(@function_type id) or
    TGenericFunctionType(@generic_function_type id) or
    TGenericTypeParamType(@generic_type_param_type id) or
    TInOutType(@in_out_type id) or
    TLValueType(@l_value_type id) or
    TMetatypeType(@metatype_type id) or
    TModuleType(@module_type id) or
    TNestedArchetypeType(@nested_archetype_type id) or
    TOpaqueTypeArchetypeType(@opaque_type_archetype_type id) or
    TOpenedArchetypeType(@opened_archetype_type id) or
    TOptionalType(@optional_type id) or
    TParenType(@paren_type id) or
    TPlaceholderType(@placeholder_type id) or
    TPrimaryArchetypeType(@primary_archetype_type id) or
    TProtocolCompositionType(@protocol_composition_type id) or
    TProtocolType(@protocol_type id) or
    TSequenceArchetypeType(@sequence_archetype_type id) or
    TSilBlockStorageType(@sil_block_storage_type id) or
    TSilBoxType(@sil_box_type id) or
    TSilFunctionType(@sil_function_type id) or
    TSilTokenType(@sil_token_type id) or
    TStructType(@struct_type id) or
    TTupleType(@tuple_type id) or
    TTypeAliasType(@type_alias_type id) or
    TTypeVariableType(@type_variable_type id) or
    TUnboundGenericType(@unbound_generic_type id) or
    TUnmanagedStorageType(@unmanaged_storage_type id) or
    TUnownedStorageType(@unowned_storage_type id) or
    TUnresolvedType(@unresolved_type id) or
    TVariadicSequenceType(@variadic_sequence_type id) or
    TWeakStorageType(@weak_storage_type id) or
    TArrayTypeRepr(@array_type_repr id) or
    TAttributedTypeRepr(@attributed_type_repr id) or
    TCompileTimeConstTypeRepr(@compile_time_const_type_repr id) or
    TCompositionTypeRepr(@composition_type_repr id) or
    TCompoundIdentTypeRepr(@compound_ident_type_repr id) or
    TDictionaryTypeRepr(@dictionary_type_repr id) or
    TErrorTypeRepr(@error_type_repr id) or
    TExistentialTypeRepr(@existential_type_repr id) or
    TFixedTypeRepr(@fixed_type_repr id) or
    TFunctionTypeRepr(@function_type_repr id) or
    TGenericIdentTypeRepr(@generic_ident_type_repr id) or
    TImplicitlyUnwrappedOptionalTypeRepr(@implicitly_unwrapped_optional_type_repr id) or
    TInOutTypeRepr(@in_out_type_repr id) or
    TIsolatedTypeRepr(@isolated_type_repr id) or
    TMetatypeTypeRepr(@metatype_type_repr id) or
    TNamedOpaqueReturnTypeRepr(@named_opaque_return_type_repr id) or
    TOpaqueReturnTypeRepr(@opaque_return_type_repr id) or
    TOptionalTypeRepr(@optional_type_repr id) or
    TOwnedTypeRepr(@owned_type_repr id) or
    TPlaceholderTypeRepr(@placeholder_type_repr id) or
    TProtocolTypeRepr(@protocol_type_repr id) or
    TSharedTypeRepr(@shared_type_repr id) or
    TSilBoxTypeRepr(@sil_box_type_repr id) or
    TSimpleIdentTypeRepr(@simple_ident_type_repr id) or
    TTupleTypeRepr(@tuple_type_repr id)

  class TAstNode =
    TCaseLabelItem or TDecl or TExpr or TPattern or TStmt or TStmtCondition or TTypeRepr;

  class TCallable = TAbstractClosureExpr or TAbstractFunctionDecl;

  class TElement =
    TCallable or TFile or TGenericContext or TIterableDeclContext or TLocatable or TLocation or
        TType;

  class TLocatable = TArgument or TAstNode or TConditionElement or TIfConfigClause;

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
    TBinaryExpr or TCallExpr or TMethodCallExpr or TPostfixUnaryExpr or TPrefixUnaryExpr or
        TSelfApplyExpr;

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

  class TComponentIdentTypeRepr = TGenericIdentTypeRepr or TSimpleIdentTypeRepr;

  class TIdentTypeRepr = TComponentIdentTypeRepr or TCompoundIdentTypeRepr;

  class TSpecifierTypeRepr =
    TCompileTimeConstTypeRepr or TInOutTypeRepr or TIsolatedTypeRepr or TOwnedTypeRepr or
        TSharedTypeRepr;

  class TTypeRepr =
    TArrayTypeRepr or TAttributedTypeRepr or TCompositionTypeRepr or TDictionaryTypeRepr or
        TErrorTypeRepr or TExistentialTypeRepr or TFixedTypeRepr or TFunctionTypeRepr or
        TIdentTypeRepr or TImplicitlyUnwrappedOptionalTypeRepr or TMetatypeTypeRepr or
        TNamedOpaqueReturnTypeRepr or TOpaqueReturnTypeRepr or TOptionalTypeRepr or
        TPlaceholderTypeRepr or TProtocolTypeRepr or TSilBoxTypeRepr or TSpecifierTypeRepr or
        TTupleTypeRepr;
}
