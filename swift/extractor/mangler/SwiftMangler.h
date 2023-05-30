#pragma once

#include <swift/AST/ASTMangler.h>
#include <swift/AST/Types.h>
#include <swift/AST/ASTVisitor.h>
#include <swift/AST/TypeVisitor.h>

#include <variant>

#include "swift/extractor/trap/TrapLabel.h"
#include "swift/extractor/infra/SwiftMangledName.h"

#include <optional>

namespace codeql {

class SwiftDispatcher;

// This class is tasked with assigning unique names to entities that need it (non-local
// declarations and types), to be used as trap keys.
// When the identity depends on some other entity (like the parent of a declaration, or the
// declaration introducing a user type) a [trap id-ref][1] is used, using the dispatcher to give us
// a label reference to that entity. Because that entity will also generally have a mangled name,
// it is important that this does not lead to any recursive loop (which is checked at runtime
// within the dispatcher).
//
// [1]: https://github.com/github/codeql-core/blob/main/wiki/extractors/trap.md#ids
//
// * all names are prefixed with the name of the entity class (for example `ParamDecl_`)
// * declarations usually use a reference to their declaration context as first element, followed
//   by whatever distinguishes them within that context (the name, or the signature for function)
// * user defined types have a name that is a simple wrapper around a reference to their declaration
class SwiftMangler : private swift::TypeVisitor<SwiftMangler, SwiftMangledName>,
                     private swift::DeclVisitor<SwiftMangler, SwiftMangledName> {
  using TypeVisitor = swift::TypeVisitor<SwiftMangler, SwiftMangledName>;
  using DeclVisitor = swift::DeclVisitor<SwiftMangler, SwiftMangledName>;

 public:
  explicit SwiftMangler(SwiftDispatcher& dispatcher) : dispatcher(dispatcher) {}

  static SwiftMangledName mangleModuleName(std::string_view name);

  SwiftMangledName mangleDecl(const swift::Decl& decl) {
    return DeclVisitor::visit(const_cast<swift::Decl*>(&decl));
  }

  SwiftMangledName mangleType(const swift::TypeBase& type) {
    return TypeVisitor::visit(const_cast<swift::TypeBase*>(&type));
  }

 private:
  friend TypeVisitor;
  friend DeclVisitor;

  // assign no name by default
  static SwiftMangledName visitDecl(const swift::Decl* decl) { return {}; }

  // current default, falling back to internal mangling
  SwiftMangledName visitValueDecl(const swift::ValueDecl* decl, bool force = false);

  SwiftMangledName visitModuleDecl(const swift::ModuleDecl* decl);
  SwiftMangledName visitExtensionDecl(const swift::ExtensionDecl* decl);
  SwiftMangledName visitAbstractFunctionDecl(const swift::AbstractFunctionDecl* decl);
  SwiftMangledName visitSubscriptDecl(const swift::SubscriptDecl* decl);
  SwiftMangledName visitVarDecl(const swift::VarDecl* decl);
  SwiftMangledName visitAbstractTypeParamDecl(const swift::AbstractTypeParamDecl* decl);
  SwiftMangledName visitGenericTypeParamDecl(const swift::GenericTypeParamDecl* decl);

  // default fallback for non mangled types. This covers types that should not appear in normal
  // successful extractor runs, like ErrorType
  SwiftMangledName visitType(const swift::TypeBase* type);

  SwiftMangledName visitModuleType(const swift::ModuleType* type);
  SwiftMangledName visitTupleType(const swift::TupleType* type);
  SwiftMangledName visitBuiltinType(const swift::BuiltinType* type);
  SwiftMangledName visitAnyGenericType(const swift::AnyGenericType* type);

  // shouldn't be required, but they forgot to link `NominalType` to its direct superclass
  // in swift/AST/TypeNodes.def, so we need to chain the call manually
  SwiftMangledName visitNominalType(const swift::NominalType* type) {
    return visitAnyGenericType(type);
  }

  SwiftMangledName visitBoundGenericType(const swift::BoundGenericType* type);
  SwiftMangledName visitAnyFunctionType(const swift::AnyFunctionType* type);
  SwiftMangledName visitGenericFunctionType(const swift::GenericFunctionType* type);
  SwiftMangledName visitGenericTypeParamType(const swift::GenericTypeParamType* type);
  SwiftMangledName visitAnyMetatypeType(const swift::AnyMetatypeType* type);
  SwiftMangledName visitDependentMemberType(const swift::DependentMemberType* type);
  SwiftMangledName visitInOutType(const swift::InOutType* type);
  SwiftMangledName visitExistentialType(const swift::ExistentialType* type);
  SwiftMangledName visitUnarySyntaxSugarType(const swift::UnarySyntaxSugarType* type);
  SwiftMangledName visitDictionaryType(const swift::DictionaryType* type);
  SwiftMangledName visitTypeAliasType(const swift::TypeAliasType* type);
  SwiftMangledName visitArchetypeType(const swift::ArchetypeType* type);
  SwiftMangledName visitOpaqueTypeArchetypeType(const swift::OpaqueTypeArchetypeType* type);
  SwiftMangledName visitOpenedArchetypeType(const swift::OpenedArchetypeType* type);
  SwiftMangledName visitProtocolCompositionType(const swift::ProtocolCompositionType* type);
  SwiftMangledName visitParenType(const swift::ParenType* type);
  SwiftMangledName visitLValueType(const swift::LValueType* type);
  SwiftMangledName visitDynamicSelfType(const swift::DynamicSelfType* type);
  SwiftMangledName visitUnboundGenericType(const swift::UnboundGenericType* type);
  SwiftMangledName visitReferenceStorageType(const swift::ReferenceStorageType* type);
  SwiftMangledName visitParametrizedProtocolType(const swift::ParameterizedProtocolType* type);

 private:
  template <typename E>
  UntypedTrapLabel fetch(E&& e);

  static SwiftMangledName initMangled(const swift::TypeBase* type);
  SwiftMangledName initMangled(const swift::Decl* decl);
  SwiftMangledName visitTypeDiscriminatedValueDecl(const swift::ValueDecl* decl);

  swift::Mangle::ASTMangler mangler;
  SwiftDispatcher& dispatcher;
  std::unordered_map<const swift::Decl*, unsigned> preloadedExtensionIndexes;
  void indexExtensions(llvm::ArrayRef<swift::Decl*> siblings);
  unsigned int getExtensionIndex(const swift::ExtensionDecl* decl, const swift::Decl* parent);
};

}  // namespace codeql
