#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"
#include "swift/logging/SwiftLogging.h"

#include <swift/AST/Module.h>
#include <swift/AST/ParameterList.h>
#include <swift/AST/ASTContext.h>
#include <swift/AST/GenericParamList.h>
#include <sstream>

using namespace codeql;

namespace {
Logger& logger() {
  static Logger ret{"mangler"};
  return ret;
}

const swift::Decl* getParent(const swift::Decl* decl) {
  auto context = decl->getDeclContext();
  if (context->getContextKind() == swift::DeclContextKind::FileUnit) {
    return decl->getModuleContext();
  }
  return context->getAsDecl();
}

std::string_view getTypeKindStr(const swift::TypeBase* type) {
  switch (type->getKind()) {
#define TYPE(ID, PARENT)    \
  case swift::TypeKind::ID: \
    return #ID "Type";
#include <swift/AST/TypeNodes.def>
    default:
      return {};
  }
}

}  // namespace

SwiftMangledName SwiftMangler::initMangled(const swift::TypeBase* type) {
  return {getTypeKindStr(type), '_'};
}

SwiftMangledName SwiftMangler::initMangled(const swift::Decl* decl) {
  return {swift::Decl::getKindName(decl->getKind()), "Decl_", fetch(getParent(decl))};
}

SwiftMangledName SwiftMangler::mangleModuleName(std::string_view name) {
  return {"ModuleDecl_", name};
}

SwiftMangledName SwiftMangler::visitModuleDecl(const swift::ModuleDecl* decl) {
  auto ret = mangleModuleName(decl->getRealName().str());
  if (decl->isNonSwiftModule()) {
    ret << "|clang";
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitValueDecl(const swift::ValueDecl* decl, bool force) {
  if (!force && (!decl->hasName() || decl->getDeclContext()->isLocalContext())) {
    return {};
  }
  auto ret = initMangled(decl);
  std::string name;
  llvm::raw_string_ostream oss{name};
  decl->getName().print(oss);
  ret << name;
  if (decl->isStatic()) {
    ret << "|static";
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitTypeDiscriminatedValueDecl(const swift::ValueDecl* decl) {
  if (auto ret = visitValueDecl(decl)) {
    ret << fetch(decl->getInterfaceType()->getCanonicalType());
    return ret;
  }
  return {};
}

SwiftMangledName SwiftMangler::visitAbstractFunctionDecl(const swift::AbstractFunctionDecl* decl) {
  return visitTypeDiscriminatedValueDecl(decl);
}

SwiftMangledName SwiftMangler::visitSubscriptDecl(const swift::SubscriptDecl* decl) {
  return visitTypeDiscriminatedValueDecl(decl);
}

SwiftMangledName SwiftMangler::visitVarDecl(const swift::VarDecl* decl) {
  return visitTypeDiscriminatedValueDecl(decl);
}

SwiftMangledName SwiftMangler::visitExtensionDecl(const swift::ExtensionDecl* decl) {
  if (decl->getDeclContext()->isLocalContext()) {
    return {};
  }

  auto parent = getParent(decl);
  auto target = decl->getExtendedType();
  return initMangled(decl) << fetch(target) << getExtensionIndex(decl, parent);
}

unsigned SwiftMangler::getExtensionIndex(const swift::ExtensionDecl* decl,
                                         const swift::Decl* parent) {
  // to avoid iterating multiple times on the parent of multiple extensions, we preload extension
  // indexes once for each encountered parent into the `preloadedExtensionIndexes` mapping.
  // Because we mangle declarations only once in a given trap/dispatcher context, we can safely
  // discard preloaded indexes on use
  if (auto found = preloadedExtensionIndexes.extract(decl)) {
    return found.mapped();
  }
  if (auto parentModule = llvm::dyn_cast<swift::ModuleDecl>(parent)) {
    llvm::SmallVector<swift::Decl*> siblings;
    parentModule->getTopLevelDecls(siblings);
    indexExtensions(siblings);
  } else if (auto iterableParent = llvm::dyn_cast<swift::IterableDeclContext>(parent)) {
    indexExtensions(iterableParent->getAllMembers());
  } else {
    // TODO use a generic logging handle for Swift entities here, once it's available
    CODEQL_ASSERT(false, "non-local context must be module or iterable decl context");
  }
  auto found = preloadedExtensionIndexes.extract(decl);
  // TODO use a generic logging handle for Swift entities here, once it's available
  CODEQL_ASSERT(found, "extension not found within parent");
  return found.mapped();
}

void SwiftMangler::indexExtensions(llvm::ArrayRef<swift::Decl*> siblings) {
  auto index = 0u;
  for (auto sibling : siblings) {
    if (sibling->getKind() == swift::DeclKind::Extension) {
      preloadedExtensionIndexes.emplace(sibling, index);
    }
    ++index;
  }
}

SwiftMangledName SwiftMangler::visitGenericTypeParamDecl(const swift::GenericTypeParamDecl* decl) {
  auto ret = visitValueDecl(decl, /*force=*/true);
  if (decl->isParameterPack()) {
    ret << "each_";
  }
  ret << '_' << decl->getDepth() << '_' << decl->getIndex();
  return ret;
}

SwiftMangledName SwiftMangler::visitAssociatedTypeDecl(const swift::AssociatedTypeDecl* decl) {
  return visitValueDecl(decl, /*force=*/true);
}

SwiftMangledName SwiftMangler::visitModuleType(const swift::ModuleType* type) {
  return initMangled(type) << fetch(type->getModule());
}

SwiftMangledName SwiftMangler::visitTupleType(const swift::TupleType* type) {
  auto ret = initMangled(type);
  for (const auto& element : type->getElements()) {
    if (element.hasName()) {
      ret << element.getName().str();
    }
    ret << fetch(element.getType());
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitBuiltinType(const swift::BuiltinType* type) {
  llvm::SmallString<32> buffer;
  return initMangled(type) << type->getTypeName(buffer, /* prependBuiltinNamespace= */ false);
}

SwiftMangledName SwiftMangler::visitAnyGenericType(const swift::AnyGenericType* type) {
  auto ret = initMangled(type);
  auto decl = type->getDecl();
  ret << fetch(decl);
  if (auto parent = type->getParent()) {
    ret << fetch(parent);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitType(const swift::TypeBase* type) {
  LOG_WARNING("encountered {} for which we give no name", getTypeKindStr(type));
  return {};
}

SwiftMangledName SwiftMangler::visitBoundGenericType(const swift::BoundGenericType* type) {
  auto ret = visitAnyGenericType(type);
  for (const auto param : type->getGenericArgs()) {
    ret << fetch(param);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyFunctionType(const swift::AnyFunctionType* type) {
  auto ret = initMangled(type);
  for (const auto& param : type->getParams()) {
    ret << fetch(param.getPlainType());
    auto flags = param.getParameterFlags();
    ret << "_" << getNameForParamSpecifier(flags.getOwnershipSpecifier());
    if (flags.isIsolated()) {
      ret << "_isolated";
    }
    if (flags.isAutoClosure()) {
      ret << "_autoclosure";
    }
    if (flags.isNonEphemeral()) {
      ret << "_nonephermeral";
    }
    if (flags.isIsolated()) {
      ret << "_isolated";
    }
    if (flags.isSending()) {
      ret << "_sending";
    }
    if (flags.isCompileTimeConst()) {
      ret << "_compiletimeconst";
    }
    if (flags.isNoDerivative()) {
      ret << "_noderivative";
    }
    if (flags.isVariadic()) {
      ret << "...";
    }
  }
  ret << "->" << fetch(type->getResult());
  if (type->isAsync()) {
    ret << "_async";
  }
  if (type->isThrowing()) {
    ret << "_throws";
    if (type->hasThrownError()) {
      ret << "(" << fetch(type->getThrownError()) << ")";
    }
  }
  if (type->isSendable()) {
    ret << "_sendable";
  }
  if (type->isNoEscape()) {
    ret << "_noescape";
  }
  if (type->hasGlobalActor()) {
    ret << "_actor" << fetch(type->getGlobalActor());
  }
  if (type->getIsolation().isErased()) {
    ret << "_isolated";
  }
  // TODO: see if this needs to be used in identifying types, if not it needs to be removed from
  // type printing in the Swift compiler code
  assert(type->hasExtInfo() && "type must have ext info");
  auto info = type->getExtInfo();
  auto convention = info.getSILRepresentation();
  if (convention != swift::SILFunctionTypeRepresentation::Thick) {
    ret << "_convention" << static_cast<unsigned>(convention);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitGenericFunctionType(const swift::GenericFunctionType* type) {
  auto ret = visitAnyFunctionType(type);
  ret << '<';
  for (auto paramType : type->getGenericParams()) {
    ret << fetch(paramType);
  }
  ret << '>';
  if (!type->getRequirements().empty()) {
    ret << "where_";
    for (const auto& req : type->getRequirements()) {
      ret << fetch(req.getFirstType().getPointer());
      ret << (req.getKind() == swift::RequirementKind::SameType ? '=' : ':');
      if (req.getKind() == swift::RequirementKind::Layout) {
        ret << '(' << req.getLayoutConstraint().getString() << ')';
      } else {
        ret << fetch(req.getSecondType());
      }
    }
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitGenericTypeParamType(const swift::GenericTypeParamType* type) {
  auto ret = initMangled(type);
  if (type->isParameterPack()) {
    ret << "each_";
  }
  if (auto decl = type->getDecl()) {
    ret << fetch(decl);
  } else {
    // type parameter is canonicalized to a depth/index coordinate
    ret << type->getDepth() << '_' << type->getIndex();
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyMetatypeType(const swift::AnyMetatypeType* type) {
  return initMangled(type) << fetch(type->getInstanceType());
}

SwiftMangledName SwiftMangler::visitDependentMemberType(const swift::DependentMemberType* type) {
  return initMangled(type) << fetch(type->getBase()) << fetch(type->getAssocType());
}

SwiftMangledName SwiftMangler::visitInOutType(const swift::InOutType* type) {
  return initMangled(type) << fetch(type->getObjectType());
}

SwiftMangledName SwiftMangler::visitExistentialType(const swift::ExistentialType* type) {
  return initMangled(type) << fetch(type->getConstraintType());
}

SwiftMangledName SwiftMangler::visitUnarySyntaxSugarType(const swift::UnarySyntaxSugarType* type) {
  return initMangled(type) << fetch(type->getBaseType());
}

SwiftMangledName SwiftMangler::visitDictionaryType(const swift::DictionaryType* type) {
  return initMangled(type) << fetch(type->getKeyType()) << fetch(type->getValueType());
}

SwiftMangledName SwiftMangler::visitTypeAliasType(const swift::TypeAliasType* type) {
  auto ret = initMangled(type);
  ret << fetch(type->getDecl());
  if (auto parent = type->getParent()) {
    ret << fetch(parent);
  }
  ret << '<';
  for (auto replacement : type->getSubstitutionMap().getReplacementTypes()) {
    ret << fetch(replacement);
  }
  ret << '>';
  return ret;
}

SwiftMangledName SwiftMangler::visitArchetypeType(const swift::ArchetypeType* type) {
  auto ret = initMangled(type) << fetch(type->getInterfaceType());
  if (const auto super = type->getSuperclass()) {
    ret << ':' << fetch(super);
  }
  for (const auto* protocol : type->getConformsTo()) {
    // Including the protocols in the mangled name allows us to distinguish the "same" type in
    // different extensions, where it might have different constraints. Mangling the context (i.e.
    // which ExtensionDecl or ValueDecl it's mentioned in) might be more robust, but there doesn't
    // seem to be a clean way to get it.
    ret << ':' << fetch(protocol);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitOpaqueTypeArchetypeType(
    const swift::OpaqueTypeArchetypeType* type) {
  return visitArchetypeType(type) << fetch(type->getDecl());
}

SwiftMangledName SwiftMangler::visitOpenedArchetypeType(const swift::OpenedArchetypeType* type) {
  llvm::SmallVector<char> uuid;
  type->getOpenedExistentialID().toString(uuid);
  return visitArchetypeType(type) << std::string_view(uuid.data(), uuid.size());
}

SwiftMangledName SwiftMangler::visitProtocolCompositionType(
    const swift::ProtocolCompositionType* type) {
  auto ret = initMangled(type);
  for (auto composed : type->getMembers()) {
    ret << fetch(composed);
  }
  if (type->hasExplicitAnyObject()) {
    ret << "&AnyObject";
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitParenType(const swift::ParenType* type) {
  return initMangled(type) << fetch(type->getUnderlyingType());
}

SwiftMangledName SwiftMangler::visitLValueType(const swift::LValueType* type) {
  return initMangled(type) << fetch(type->getObjectType());
}

SwiftMangledName SwiftMangler::visitDynamicSelfType(const swift::DynamicSelfType* type) {
  return initMangled(type) << fetch(type->getSelfType());
}

SwiftMangledName SwiftMangler::visitUnboundGenericType(const swift::UnboundGenericType* type) {
  return initMangled(type) << fetch(type->getDecl());
}

SwiftMangledName SwiftMangler::visitReferenceStorageType(const swift::ReferenceStorageType* type) {
  return initMangled(type) << fetch(type->getReferentType());
}

SwiftMangledName SwiftMangler::visitParametrizedProtocolType(
    const swift::ParameterizedProtocolType* type) {
  auto ret = initMangled(type);
  ret << fetch(type->getBaseType());
  ret << '<';
  for (auto arg : type->getArgs()) {
    ret << fetch(arg);
  }
  ret << '>';
  return ret;
}

SwiftMangledName SwiftMangler::visitPackArchetypeType(const swift::PackArchetypeType* type) {
  return visitArchetypeType(type) << "...";
}

SwiftMangledName SwiftMangler::visitPackType(const swift::PackType* type) {
  auto ret = initMangled(type);
  for (auto element : type->getElementTypes()) {
    ret << fetch(element);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitPackElementType(const swift::PackElementType* type) {
  auto ret = initMangled(type);
  ret << fetch(type->getPackType());
  ret << '_' << type->getLevel();
  return ret;
}

SwiftMangledName SwiftMangler::visitPackExpansionType(const swift::PackExpansionType* type) {
  auto ret = initMangled(type);
  ret << fetch(type->getPatternType());
  ret << '_';
  ret << fetch(type->getCountType());
  return ret;
}

namespace {
template <typename E>
UntypedTrapLabel fetchLabel(SwiftDispatcher& dispatcher, const E* e) {
  auto ret = dispatcher.fetchLabel(e);
  // TODO use a generic logging handle for Swift entities here, once it's available
  CODEQL_ASSERT(ret.valid(), "using an undefined label in mangling");
  return ret;
}
}  // namespace

SwiftMangledName SwiftTrapMangler::fetch(const swift::Decl* decl) {
  return {fetchLabel(dispatcher, decl)};
}

SwiftMangledName SwiftTrapMangler::fetch(const swift::TypeBase* type) {
  return {fetchLabel(dispatcher, type)};
}

SwiftMangledName SwiftRecursiveMangler::fetch(const swift::Decl* decl) {
  return mangleDecl(*decl).hash();
}

SwiftMangledName SwiftRecursiveMangler::fetch(const swift::TypeBase* type) {
  return mangleType(*type).hash();
}
