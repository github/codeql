#pragma once

// This file implements the mapping needed by the API defined in the TrapTagTraits.h, so that
// TrapTagOf/TrapLabelOf/TrapClassOf provide the tags/labels for specific swift entity types.
#include <filesystem>
#include "swift/extractor/trap/TrapTagTraits.h"
#include "swift/extractor/trap/generated/TrapTags.h"
#include <swift/AST/ASTNode.h>
#include <swift/AST/Decl.h>
#include <swift/AST/Expr.h>
#include <swift/AST/Stmt.h>
#include <swift/AST/Pattern.h>
#include <swift/AST/TypeRepr.h>
#include <swift/AST/Type.h>
#include <swift/CodeQLSwiftVersion.h>

namespace codeql {

#define MAP(TYPE, TAG)                \
  template <>                         \
  struct detail::ToTagFunctor<TYPE> { \
    using type = TAG;                 \
  };
#define MAP_CONCRETE(TYPE, TAG)                \
  template <>                                  \
  struct detail::ToTagConcreteOverride<TYPE> { \
    using type = TAG;                          \
  };

#define CODEQL_SWIFT_VERSION_GE(MAJOR, MINOR)                                         \
  (CODEQL_SWIFT_VERSION_MAJOR == (MAJOR) && CODEQL_SWIFT_VERSION_MINOR >= (MINOR)) || \
      CODEQL_SWIFT_VERSION_MAJOR > (MAJOR)

// clang-format off
// use indentation to recreate all involved type hierarchies
MAP(std::filesystem::path, DbFileTag)
MAP(swift::StmtCondition, StmtConditionTag)
MAP(swift::StmtConditionElement, ConditionElementTag)
MAP(swift::CaseLabelItem, CaseLabelItemTag)
MAP(swift::CapturedValue, CapturedDeclTag)

MAP(swift::Stmt, StmtTag)
  MAP(swift::BraceStmt, BraceStmtTag)
  MAP(swift::ReturnStmt, ReturnStmtTag)
  MAP(swift::YieldStmt, YieldStmtTag)
  MAP(swift::ThenStmt, ThenStmtTag)
  MAP(swift::DeferStmt, DeferStmtTag)
  MAP(swift::LabeledStmt, LabeledStmtTag)
    MAP(swift::LabeledConditionalStmt, LabeledConditionalStmtTag)
      MAP(swift::IfStmt, IfStmtTag)
      MAP(swift::GuardStmt, GuardStmtTag)
      MAP(swift::WhileStmt, WhileStmtTag)
    MAP(swift::DoStmt, DoStmtTag)
    MAP(swift::DoCatchStmt, DoCatchStmtTag)
    MAP(swift::RepeatWhileStmt, RepeatWhileStmtTag)
    MAP(swift::ForEachStmt, ForEachStmtTag)
    MAP(swift::SwitchStmt, SwitchStmtTag)
  MAP(swift::CaseStmt, CaseStmtTag)
  MAP(swift::BreakStmt, BreakStmtTag)
  MAP(swift::ContinueStmt, ContinueStmtTag)
  MAP(swift::FallthroughStmt, FallthroughStmtTag)
  MAP(swift::FailStmt, FailStmtTag)
  MAP(swift::ThrowStmt, ThrowStmtTag)
  MAP(swift::PoundAssertStmt, PoundAssertStmtTag)
  MAP(swift::DiscardStmt, DiscardStmtTag)

MAP(swift::Argument, ArgumentTag)
MAP(swift::KeyPathExpr::Component, KeyPathComponentTag)
MAP(swift::Expr, ExprTag)
  MAP(swift::ErrorExpr, ErrorExprTag)
  MAP(swift::LiteralExpr, LiteralExprTag)
    MAP(swift::NilLiteralExpr, NilLiteralExprTag)
    MAP(swift::BuiltinLiteralExpr, BuiltinLiteralExprTag)
      MAP(swift::BooleanLiteralExpr, BooleanLiteralExprTag)
      MAP(swift::NumberLiteralExpr, NumberLiteralExprTag)
        MAP(swift::IntegerLiteralExpr, IntegerLiteralExprTag)
        MAP(swift::FloatLiteralExpr, FloatLiteralExprTag)
      MAP(swift::StringLiteralExpr, StringLiteralExprTag)
      MAP(swift::MagicIdentifierLiteralExpr, MagicIdentifierLiteralExprTag)
    MAP(swift::InterpolatedStringLiteralExpr, InterpolatedStringLiteralExprTag)
    MAP(swift::RegexLiteralExpr, RegexLiteralExprTag)
    MAP(swift::ObjectLiteralExpr, ObjectLiteralExprTag)
  MAP(swift::DiscardAssignmentExpr, DiscardAssignmentExprTag)
  MAP(swift::DeclRefExpr, DeclRefExprTag)
  MAP(swift::SuperRefExpr, SuperRefExprTag)
  MAP(swift::TypeExpr, TypeExprTag)
  MAP(swift::OtherConstructorDeclRefExpr, OtherInitializerRefExprTag)
  MAP(swift::DotSyntaxBaseIgnoredExpr, DotSyntaxBaseIgnoredExprTag)
  MAP(swift::OverloadSetRefExpr, OverloadedDeclRefExprTag)  // collapsed with its only derived class OverloadedDeclRefExpr
    MAP(swift::OverloadedDeclRefExpr, OverloadedDeclRefExprTag)
  MAP(swift::UnresolvedDeclRefExpr, UnresolvedDeclRefExprTag)
  MAP(swift::LookupExpr, LookupExprTag)
    MAP(swift::MemberRefExpr, MemberRefExprTag)
    MAP(swift::SubscriptExpr, SubscriptExprTag)
    MAP(swift::DynamicLookupExpr, DynamicLookupExprTag)
      MAP(swift::DynamicMemberRefExpr, DynamicMemberRefExprTag)
      MAP(swift::DynamicSubscriptExpr, DynamicSubscriptExprTag)
  MAP(swift::UnresolvedSpecializeExpr, UnresolvedSpecializeExprTag)
  MAP(swift::UnresolvedMemberExpr, UnresolvedMemberExprTag)
  MAP(swift::UnresolvedDotExpr, UnresolvedDotExprTag)
  MAP(swift::SequenceExpr, SequenceExprTag)
  MAP(swift::IdentityExpr, IdentityExprTag)
    MAP(swift::ParenExpr, ParenExprTag)
    MAP(swift::DotSelfExpr, DotSelfExprTag)
    MAP(swift::BorrowExpr, BorrowExprTag)
    MAP(swift::AwaitExpr, AwaitExprTag)
    MAP(swift::UnresolvedMemberChainResultExpr, UnresolvedMemberChainResultExprTag)
  MAP(swift::AnyTryExpr, AnyTryExprTag)
    MAP(swift::TryExpr, TryExprTag)
    MAP(swift::ForceTryExpr, ForceTryExprTag)
    MAP(swift::OptionalTryExpr, OptionalTryExprTag)
  MAP(swift::TupleExpr, TupleExprTag)
  MAP(swift::CollectionExpr, CollectionExprTag)
    MAP(swift::ArrayExpr, ArrayExprTag)
    MAP(swift::DictionaryExpr, DictionaryExprTag)
  MAP(swift::KeyPathApplicationExpr, KeyPathApplicationExprTag)
  MAP(swift::TupleElementExpr, TupleElementExprTag)
  MAP(swift::CaptureListExpr, CaptureListExprTag)
  MAP(swift::AbstractClosureExpr, ClosureExprTag)
    MAP(swift::ClosureExpr, ExplicitClosureExprTag)
    MAP(swift::AutoClosureExpr, AutoClosureExprTag)
  MAP(swift::InOutExpr, InOutExprTag)
  MAP(swift::VarargExpansionExpr, VarargExpansionExprTag)
  MAP(swift::PackExpansionExpr, PackExpansionExprTag)
  MAP(swift::PackElementExpr, PackElementExprTag)
  MAP(swift::DynamicTypeExpr, DynamicTypeExprTag)
  MAP(swift::RebindSelfInConstructorExpr, RebindSelfInInitializerExprTag)
  MAP(swift::OpaqueValueExpr, OpaqueValueExprTag)
  MAP(swift::PropertyWrapperValuePlaceholderExpr, PropertyWrapperValuePlaceholderExprTag)
  MAP(swift::AppliedPropertyWrapperExpr, AppliedPropertyWrapperExprTag)
  MAP(swift::DefaultArgumentExpr, DefaultArgumentExprTag)
  MAP(swift::BindOptionalExpr, BindOptionalExprTag)
  MAP(swift::OptionalEvaluationExpr, OptionalEvaluationExprTag)
  MAP(swift::ForceValueExpr, ForceValueExprTag)
  MAP(swift::OpenExistentialExpr, OpenExistentialExprTag)
  MAP(swift::MakeTemporarilyEscapableExpr, MakeTemporarilyEscapableExprTag)
  MAP(swift::ApplyExpr, ApplyExprTag)
    MAP(swift::CallExpr, CallExprTag)
    MAP(swift::PrefixUnaryExpr, PrefixUnaryExprTag)
    MAP(swift::PostfixUnaryExpr, PostfixUnaryExprTag)
    MAP(swift::BinaryExpr, BinaryExprTag)
    MAP(swift::SelfApplyExpr, SelfApplyExprTag)
      MAP(swift::DotSyntaxCallExpr, DotSyntaxCallExprTag)
      MAP(swift::ConstructorRefCallExpr, InitializerRefCallExprTag)
  MAP(swift::ImplicitConversionExpr, ImplicitConversionExprTag)
    MAP(swift::LoadExpr, LoadExprTag)
    MAP(swift::DestructureTupleExpr, DestructureTupleExprTag)
    MAP(swift::UnresolvedTypeConversionExpr, UnresolvedTypeConversionExprTag)
    MAP(swift::FunctionConversionExpr, FunctionConversionExprTag)
    MAP(swift::CovariantFunctionConversionExpr, CovariantFunctionConversionExprTag)
    MAP(swift::CovariantReturnConversionExpr, CovariantReturnConversionExprTag)
    MAP(swift::MetatypeConversionExpr, MetatypeConversionExprTag)
    MAP(swift::CollectionUpcastConversionExpr, CollectionUpcastConversionExprTag)
    MAP(swift::ErasureExpr, ErasureExprTag)
    MAP(swift::AnyHashableErasureExpr, AnyHashableErasureExprTag)
    MAP(swift::BridgeToObjCExpr, BridgeToObjCExprTag)
    MAP(swift::BridgeFromObjCExpr, BridgeFromObjCExprTag)
    MAP(swift::ConditionalBridgeFromObjCExpr, ConditionalBridgeFromObjCExprTag)
    MAP(swift::DerivedToBaseExpr, DerivedToBaseExprTag)
    MAP(swift::ArchetypeToSuperExpr, ArchetypeToSuperExprTag)
    MAP(swift::InjectIntoOptionalExpr, InjectIntoOptionalExprTag)
    MAP(swift::ClassMetatypeToObjectExpr, ClassMetatypeToObjectExprTag)
    MAP(swift::ExistentialMetatypeToObjectExpr, ExistentialMetatypeToObjectExprTag)
    MAP(swift::ProtocolMetatypeToObjectExpr, ProtocolMetatypeToObjectExprTag)
    MAP(swift::InOutToPointerExpr, InOutToPointerExprTag)
    MAP(swift::ArrayToPointerExpr, ArrayToPointerExprTag)
    MAP(swift::StringToPointerExpr, StringToPointerExprTag)
    MAP(swift::PointerToPointerExpr, PointerToPointerExprTag)
    MAP(swift::ForeignObjectConversionExpr, ForeignObjectConversionExprTag)
    MAP(swift::UnevaluatedInstanceExpr, UnevaluatedInstanceExprTag)
    MAP(swift::UnderlyingToOpaqueExpr, UnderlyingToOpaqueExprTag)
    MAP(swift::DifferentiableFunctionExpr, DifferentiableFunctionExprTag)
    MAP(swift::LinearFunctionExpr, LinearFunctionExprTag)
    MAP(swift::DifferentiableFunctionExtractOriginalExpr, DifferentiableFunctionExtractOriginalExprTag)
    MAP(swift::LinearFunctionExtractOriginalExpr, LinearFunctionExtractOriginalExprTag)
    MAP(swift::LinearToDifferentiableFunctionExpr, LinearToDifferentiableFunctionExprTag)
    MAP(swift::ABISafeConversionExpr, AbiSafeConversionExprTag)  // different acronym convention
    MAP(swift::ActorIsolationErasureExpr, void)  // TODO swift 6.0
    MAP(swift::UnreachableExpr, void)  // TODO swift 6.0
  MAP(swift::ExplicitCastExpr, ExplicitCastExprTag)
    MAP(swift::CheckedCastExpr, CheckedCastExprTag)
      MAP(swift::ForcedCheckedCastExpr, ForcedCheckedCastExprTag)
      MAP(swift::ConditionalCheckedCastExpr, ConditionalCheckedCastExprTag)
      MAP(swift::IsExpr, IsExprTag)
    MAP(swift::CoerceExpr, CoerceExprTag)
  MAP(swift::ArrowExpr, void)  // not present after the Sema phase
  MAP(swift::TernaryExpr, IfExprTag)
  MAP(swift::EnumIsCaseExpr, EnumIsCaseExprTag)
  MAP(swift::AssignExpr, AssignExprTag)
  MAP(swift::CodeCompletionExpr, void) // only generated for code editing
  MAP(swift::UnresolvedPatternExpr, UnresolvedPatternExprTag)
  MAP(swift::LazyInitializerExpr, LazyInitializationExprTag)
  MAP(swift::EditorPlaceholderExpr, void)  // only generated for code editing
  MAP(swift::ObjCSelectorExpr, ObjCSelectorExprTag)
  MAP(swift::KeyPathExpr, KeyPathExprTag)
  MAP(swift::KeyPathDotExpr, KeyPathDotExprTag)
  MAP(swift::OneWayExpr, OneWayExprTag)
  MAP(swift::TapExpr, TapExprTag)
  MAP(swift::TypeJoinExpr, void)  // does not appear in a visible AST, skipping
  MAP(swift::MacroExpansionExpr, void) // unexpanded macro in an expr context, skipping
  MAP(swift::CopyExpr, CopyExprTag)
  MAP(swift::ConsumeExpr, ConsumeExprTag)
  MAP(swift::MaterializePackExpr, MaterializePackExprTag)
  MAP(swift::SingleValueStmtExpr, SingleValueStmtExprTag)
  MAP(swift::ExtractFunctionIsolationExpr, void)  // TODO swift 6.0
  MAP(swift::CurrentContextIsolationExpr, void)  // TODO swift 6.0
MAP(swift::Decl, DeclTag)
  MAP(swift::ValueDecl, ValueDeclTag)
    MAP(swift::TypeDecl, TypeDeclTag)
      MAP(swift::GenericTypeDecl, GenericTypeDeclTag)
        MAP(swift::NominalTypeDecl, NominalTypeDeclTag)
          MAP(swift::EnumDecl, EnumDeclTag)
          MAP(swift::StructDecl, StructDeclTag)
          MAP(swift::ClassDecl, ClassDeclTag)
          MAP(swift::ProtocolDecl, ProtocolDeclTag)
          MAP(swift::BuiltinTupleDecl, void)  // TODO, experimental
        MAP(swift::OpaqueTypeDecl, OpaqueTypeDeclTag)
        MAP(swift::TypeAliasDecl, TypeAliasDeclTag)
      MAP(swift::GenericTypeParamDecl, GenericTypeParamDeclTag)
      MAP(swift::AssociatedTypeDecl, AssociatedTypeDeclTag)
      MAP(swift::ModuleDecl, ModuleDeclTag)
    MAP(swift::AbstractStorageDecl, AbstractStorageDeclTag)
      MAP(swift::VarDecl, VarDeclTag)
        MAP_CONCRETE(swift::VarDecl, ConcreteVarDeclTag)
        MAP(swift::ParamDecl, ParamDeclTag)
      MAP(swift::SubscriptDecl, SubscriptDeclTag)
    MAP(swift::AbstractFunctionDecl, FunctionTag)
      MAP(swift::ConstructorDecl, InitializerTag)
      MAP(swift::DestructorDecl, DeinitializerTag)
      MAP(swift::FuncDecl, AccessorOrNamedFunctionTag)
        MAP_CONCRETE(swift::FuncDecl, NamedFunctionTag)
        MAP(swift::AccessorDecl, AccessorTag)
    MAP(swift::MacroDecl, MacroDeclTag)
    MAP(swift::EnumElementDecl, EnumElementDeclTag)
  MAP(swift::ExtensionDecl, ExtensionDeclTag)
  MAP(swift::TopLevelCodeDecl, TopLevelCodeDeclTag)
  MAP(swift::ImportDecl, ImportDeclTag)
  MAP(swift::IfConfigDecl, IfConfigDeclTag)
  MAP(swift::PoundDiagnosticDecl, PoundDiagnosticDeclTag)
  MAP(swift::PrecedenceGroupDecl, PrecedenceGroupDeclTag)
  MAP(swift::MissingMemberDecl, MissingMemberDeclTag)
  MAP(swift::PatternBindingDecl, PatternBindingDeclTag)
  MAP(swift::EnumCaseDecl, EnumCaseDeclTag)
  MAP(swift::OperatorDecl, OperatorDeclTag)
    MAP(swift::InfixOperatorDecl, InfixOperatorDeclTag)
    MAP(swift::PrefixOperatorDecl, PrefixOperatorDeclTag)
    MAP(swift::PostfixOperatorDecl, PostfixOperatorDeclTag)
  MAP(swift::MacroExpansionDecl, void) // unexpanded macro in a decl context, skipping
  MAP(swift::MissingDecl, void) // appears around an unexpanded macro, skipping

MAP(swift::Pattern, PatternTag)
  MAP(swift::ParenPattern, ParenPatternTag)
  MAP(swift::TuplePattern, TuplePatternTag)
  MAP(swift::NamedPattern, NamedPatternTag)
  MAP(swift::AnyPattern, AnyPatternTag)
  MAP(swift::TypedPattern, TypedPatternTag)
  MAP(swift::BindingPattern, BindingPatternTag)
  MAP(swift::IsPattern, IsPatternTag)
  MAP(swift::EnumElementPattern, EnumElementPatternTag)
  MAP(swift::OptionalSomePattern, OptionalSomePatternTag)
  MAP(swift::BoolPattern, BoolPatternTag)
  MAP(swift::ExprPattern, ExprPatternTag)

MAP(swift::TypeRepr, TypeReprTag)

MAP(swift::Type, TypeTag)
MAP(swift::TypeBase, TypeTag)
  MAP(swift::ErrorType, ErrorTypeTag)
  MAP(swift::UnresolvedType, UnresolvedTypeTag)
  MAP(swift::PlaceholderType, void)  // appears in ambiguous types but are then transformed to UnresolvedType
  MAP(swift::BuiltinType, BuiltinTypeTag)
    MAP(swift::AnyBuiltinIntegerType, AnyBuiltinIntegerTypeTag)
      MAP(swift::BuiltinIntegerType, BuiltinIntegerTypeTag)
      MAP(swift::BuiltinIntegerLiteralType, BuiltinIntegerLiteralTypeTag)
    MAP(swift::BuiltinExecutorType, BuiltinExecutorTypeTag)
    MAP(swift::BuiltinFloatType, BuiltinFloatTypeTag)
    MAP(swift::BuiltinJobType, BuiltinJobTypeTag)
    MAP(swift::BuiltinRawPointerType, BuiltinRawPointerTypeTag)
    MAP(swift::BuiltinRawUnsafeContinuationType, BuiltinRawUnsafeContinuationTypeTag)
    MAP(swift::BuiltinNativeObjectType, BuiltinNativeObjectTypeTag)
    MAP(swift::BuiltinBridgeObjectType, BuiltinBridgeObjectTypeTag)
    MAP(swift::BuiltinUnsafeValueBufferType, BuiltinUnsafeValueBufferTypeTag)
    MAP(swift::BuiltinDefaultActorStorageType, BuiltinDefaultActorStorageTypeTag)
    MAP(swift::BuiltinVectorType, BuiltinVectorTypeTag)
    MAP(swift::BuiltinPackIndexType, void)  // SIL type, cannot really appear in the frontend run
    MAP(swift::BuiltinNonDefaultDistributedActorStorageType, void)  // Does not appear in AST/SIL, only used during IRGen
  MAP(swift::TupleType, TupleTypeTag)
  MAP(swift::ReferenceStorageType, ReferenceStorageTypeTag)
  MAP(swift::WeakStorageType, WeakStorageTypeTag)
  MAP(swift::UnownedStorageType, UnownedStorageTypeTag)
  MAP(swift::UnmanagedStorageType, UnmanagedStorageTypeTag)
  MAP(swift::AnyGenericType, AnyGenericTypeTag)
    MAP(swift::NominalOrBoundGenericNominalType, NominalOrBoundGenericNominalTypeTag)
      MAP(swift::NominalType, NominalTypeTag)
        MAP(swift::EnumType, EnumTypeTag)
        MAP(swift::StructType, StructTypeTag)
        MAP(swift::ClassType, ClassTypeTag)
        MAP(swift::ProtocolType, ProtocolTypeTag)
        MAP(swift::BuiltinTupleType, void)  // TODO, experimental
      MAP(swift::BoundGenericType, BoundGenericTypeTag)
        MAP(swift::BoundGenericClassType, BoundGenericClassTypeTag)
        MAP(swift::BoundGenericEnumType, BoundGenericEnumTypeTag)
        MAP(swift::BoundGenericStructType, BoundGenericStructTypeTag)
    MAP(swift::UnboundGenericType, UnboundGenericTypeTag)
  MAP(swift::AnyMetatypeType, AnyMetatypeTypeTag)
    MAP(swift::MetatypeType, MetatypeTypeTag)
    MAP(swift::ExistentialMetatypeType, ExistentialMetatypeTypeTag)
  MAP(swift::ModuleType, ModuleTypeTag)
  MAP(swift::DynamicSelfType, DynamicSelfTypeTag)
  MAP(swift::SubstitutableType, SubstitutableTypeTag)
    MAP(swift::ArchetypeType, ArchetypeTypeTag)
      MAP(swift::PrimaryArchetypeType, PrimaryArchetypeTypeTag)
      MAP(swift::OpaqueTypeArchetypeType, OpaqueTypeArchetypeTypeTag)
      MAP(swift::LocalArchetypeType, LocalArchetypeTypeTag)
        MAP(swift::OpenedArchetypeType, OpenedArchetypeTypeTag)
        MAP(swift::ElementArchetypeType, ElementArchetypeTypeTag)
      MAP(swift::PackArchetypeType, PackArchetypeTypeTag)
    MAP(swift::GenericTypeParamType, GenericTypeParamTypeTag)
  MAP(swift::DependentMemberType, DependentMemberTypeTag)
  MAP(swift::AnyFunctionType, AnyFunctionTypeTag)
    MAP(swift::FunctionType, FunctionTypeTag)
    MAP(swift::GenericFunctionType, GenericFunctionTypeTag)
  MAP(swift::SILFunctionType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::SILBlockStorageType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::SILBoxType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::SILMoveOnlyWrappedType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::SILTokenType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::SILPackType, void)  // SIL types cannot really appear in the frontend run
  MAP(swift::ProtocolCompositionType, ProtocolCompositionTypeTag)
  MAP(swift::ParameterizedProtocolType, ParameterizedProtocolTypeTag)
  MAP(swift::ExistentialType, ExistentialTypeTag)
  MAP(swift::LValueType, LValueTypeTag)
  MAP(swift::InOutType, InOutTypeTag)
  MAP(swift::PackType, PackTypeTag)
  MAP(swift::PackExpansionType, PackExpansionTypeTag)
  MAP(swift::PackElementType, PackElementTypeTag)
  MAP(swift::TypeVariableType, void)  // created during type checking and only used for constraint checking
  MAP(swift::ErrorUnionType, void)  // TODO swift 6.0
  MAP(swift::SugarType, SugarTypeTag)
    MAP(swift::ParenType, ParenTypeTag)
    MAP(swift::TypeAliasType, TypeAliasTypeTag)
    MAP(swift::SyntaxSugarType, SyntaxSugarTypeTag)
      MAP(swift::UnarySyntaxSugarType, UnarySyntaxSugarTypeTag)
        MAP(swift::ArraySliceType, ArraySliceTypeTag)
        MAP(swift::OptionalType, OptionalTypeTag)
        MAP(swift::VariadicSequenceType, VariadicSequenceTypeTag)
      MAP(swift::DictionaryType, DictionaryTypeTag)

MAP(swift::AvailabilitySpec, AvailabilitySpecTag)
  MAP(swift::PlatformVersionConstraintAvailabilitySpec, PlatformVersionAvailabilitySpecTag)
  MAP(swift::OtherPlatformAvailabilitySpec, OtherAvailabilitySpecTag)

MAP(swift::PoundAvailableInfo, AvailabilityInfoTag)
MAP(swift::MacroRoleAttr, MacroRoleTag)

// clang-format on
#undef MAP
#undef MAP_CONCRETE
}  // namespace codeql
