#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"
#include <swift/AST/Module.h>
#include <swift/AST/ParameterList.h>
#include <swift/AST/ASTContext.h>
#include <swift/AST/GenericParamList.h>
#include <sstream>

using namespace codeql;

namespace {
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

template <typename E>
UntypedTrapLabel SwiftMangler::fetch(E&& e) {
  return dispatcher.fetchLabel(std::forward<E>(e));
}

SwiftMangledName SwiftMangler::initMangled(const swift::TypeBase* type) {
  return SwiftMangledName() << getTypeKindStr(type) << '_';
}

SwiftMangledName SwiftMangler::initMangled(const swift::Decl* decl) {
  return SwiftMangledName() << swift::Decl::getKindName(decl->getKind()) << "Decl_"
                            << fetch(getParent(decl));
}

SwiftMangledName SwiftMangler::mangleModuleName(std::string_view name) {
  return SwiftMangledName() << "ModuleDecl_" << name;
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
  return initMangled(decl) << fetch(parent) << getExtensionIndex(decl, parent);
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
    assert(false && "non-local context must be module or iterable decl context");
  }
  auto found = preloadedExtensionIndexes.extract(decl);
  assert(found && "extension not found within parent");
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

SwiftMangledName SwiftMangler::visitGenericTypeDecl(const swift::GenericTypeDecl* decl) {
  auto ret = visitValueDecl(decl);
  if (!ret) {
    return {};
  }
  if (auto genericParams = decl->getParsedGenericParams()) {
    ret << '<' << genericParams->size() << '>';
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitAbstractTypeParamDecl(
    const swift::AbstractTypeParamDecl* decl) {
  return visitValueDecl(decl, /* force */ true);
}

SwiftMangledName SwiftMangler::visitGenericTypeParamDecl(const swift::GenericTypeParamDecl* decl) {
  auto ret = visitAbstractTypeParamDecl(decl);
  ret << '_' << decl->getDepth() << '_' << decl->getIndex();
  return ret;
}

SwiftMangledName SwiftMangler::visitModuleType(const swift::ModuleType* type) {
  auto ret = initMangled(type);
  ret << fetch(type->getModule());
  return ret;
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
  dispatcher.emitDebugInfo("no name for ", getTypeKindStr(type));
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
    if (param.isInOut()) {
      ret << "_inout";
    }
    if (param.isOwned()) {
      ret << "_owned";
    }
    if (param.isShared()) {
      ret << "_shared";
    }
    if (param.isIsolated()) {
      ret << "_isolated";
    }
    if (param.isVariadic()) {
      ret << "...";
    }
  }
  ret << "->" << fetch(type->getResult());
  if (type->isAsync()) {
    ret << "_async";
  }
  if (type->isThrowing()) {
    ret << "_throws";
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
  // TODO: see if this needs to be used in identifying types, if not it needs to be removed from
  // type printing
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
  return initMangled(type) << fetch(type->getInterfaceType());
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
