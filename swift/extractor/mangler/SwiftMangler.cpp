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

}  // namespace

SwiftMangledName SwiftMangler::initMangled(const swift::TypeBase* type) {
  switch (type->getKind()) {
#define TYPE(ID, PARENT)    \
  case swift::TypeKind::ID: \
    return {{#ID "Type_"}};
#include <swift/AST/TypeNodes.def>
    default:
      return {};
  }
}

SwiftMangledName SwiftMangler::initMangled(const swift::Decl* decl) {
  SwiftMangledName ret;
  ret << swift::Decl::getKindName(decl->getKind()) << "Decl_";
  ret << dispatcher.fetchLabel(getParent(decl));
  return ret;
}

SwiftMangledName SwiftMangler::mangleModuleName(std::string_view name) {
  SwiftMangledName ret = {{"ModuleDecl_"}};
  ret << name;
  return ret;
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
    ret << dispatcher.fetchLabel(decl->getInterfaceType()->getCanonicalType());
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
  auto extended = decl->getExtendedNominal();
  if (!extended) {
    // may happen in incomplete ASTs
    return {};
  }
  auto ret = initMangled(decl);
  ret << dispatcher.fetchLabel(extended);
  // get the index of all extensions of the same nominal type within this decl's module
  auto index = 0u;
  bool found = false;
  for (auto ext : extended->getExtensions()) {
    if (ext == decl) {
      found = true;
      break;
    }
    if (ext->getModuleContext() == decl->getModuleContext()) ++index;
  }
  assert(found && "extension not found within extended nominal type decl");
  ret << index;
  return ret;
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
  ret << dispatcher.fetchLabel(type->getModule());
  return ret;
}

SwiftMangledName SwiftMangler::visitTupleType(const swift::TupleType* type) {
  auto ret = initMangled(type);
  for (const auto& element : type->getElements()) {
    if (element.hasName()) {
      ret << element.getName().str();
    }
    ret << dispatcher.fetchLabel(element.getType());
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitBuiltinType(const swift::BuiltinType* type) {
  auto ret = initMangled(type);
  llvm::SmallString<32> buffer;
  ret << type->getTypeName(buffer, /* prependBuiltinNamespace= */ false);
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyGenericType(const swift::AnyGenericType* type) {
  auto ret = initMangled(type);
  auto decl = type->getDecl();
  ret << dispatcher.fetchLabel(decl);
  if (auto parent = type->getParent()) {
    ret << dispatcher.fetchLabel(parent);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitType(const swift::TypeBase* type) {
  dispatcher.emitDebugInfo(initMangled(type).str());
  return {};
}

SwiftMangledName SwiftMangler::visitBoundGenericType(const swift::BoundGenericType* type) {
  auto ret = visitAnyGenericType(type);
  for (const auto param : type->getGenericArgs()) {
    ret << dispatcher.fetchLabel(param);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyFunctionType(const swift::AnyFunctionType* type) {
  auto ret = initMangled(type);
  for (const auto& param : type->getParams()) {
    ret << dispatcher.fetchLabel(param.getPlainType());
    if (param.isInOut()) {
      ret << "_inout";
    }
    if (param.isOwned()) {
      ret << "_owned";
    }
    if (param.isShared()) {
      ret << "_shared";
    }
    if (param.isVariadic()) {
      ret << "...";
    }
  }
  ret << "->" << dispatcher.fetchLabel(type->getResult());
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
  // TODO: see if this needs to be used in identifying types, if not it needs to be removed from
  // type printing
  assert(type->hasExtInfo() && "type must have ext info");
  auto convention = type->getExtInfo().getSILRepresentation();
  if (convention != swift::SILFunctionTypeRepresentation::Thick) {
    ret << "_convention" << static_cast<unsigned>(convention);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitGenericFunctionType(const swift::GenericFunctionType* type) {
  auto ret = visitAnyFunctionType(type);
  ret << '<';
  for (auto paramType : type->getGenericParams()) {
    ret << dispatcher.fetchLabel(paramType);
  }
  ret << '>';
  if (!type->getRequirements().empty()) {
    ret << "where_";
    for (const auto& req : type->getRequirements()) {
      ret << dispatcher.fetchLabel(req.getFirstType().getPointer());
      ret << (req.getKind() == swift::RequirementKind::SameType ? '=' : ':');
      if (req.getKind() == swift::RequirementKind::Layout) {
        ret << '(' << req.getLayoutConstraint().getString() << ')';
      } else {
        ret << dispatcher.fetchLabel(req.getSecondType());
      }
    }
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitGenericTypeParamType(const swift::GenericTypeParamType* type) {
  auto ret = initMangled(type);
  if (auto decl = type->getDecl()) {
    ret << dispatcher.fetchLabel(decl);
  } else {
    // type parameter is canonicalized to a depth/index coordinate
    ret << type->getDepth() << '_' << type->getIndex();
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyMetatypeType(const swift::AnyMetatypeType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getInstanceType());
  return ret;
}

SwiftMangledName SwiftMangler::visitDependentMemberType(const swift::DependentMemberType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getBase());
  ret << dispatcher.fetchLabel(type->getAssocType());
  return ret;
}

SwiftMangledName SwiftMangler::visitInOutType(const swift::InOutType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getObjectType());
  return ret;
}

SwiftMangledName SwiftMangler::visitExistentialType(const swift::ExistentialType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getConstraintType());
  return ret;
}

SwiftMangledName SwiftMangler::visitUnarySyntaxSugarType(const swift::UnarySyntaxSugarType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getBaseType());
  return ret;
}

SwiftMangledName SwiftMangler::visitDictionaryType(const swift::DictionaryType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getKeyType());
  ret << dispatcher.fetchLabel(type->getValueType());
  return ret;
}

SwiftMangledName SwiftMangler::visitTypeAliasType(const swift::TypeAliasType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getDecl());
  if (auto parent = type->getParent()) {
    ret << dispatcher.fetchLabel(parent);
  }
  ret << '<';
  for (auto replacement : type->getSubstitutionMap().getReplacementTypes()) {
    ret << dispatcher.fetchLabel(replacement);
  }
  ret << '>';
  return ret;
}

SwiftMangledName SwiftMangler::visitArchetypeType(const swift::ArchetypeType* type) {
  auto ret = initMangled(type);
  // TODO double-check this
  ret << dispatcher.fetchLabel(type->getInterfaceType());
  return ret;
}

SwiftMangledName SwiftMangler::visitOpaqueTypeArchetypeType(
    const swift::OpaqueTypeArchetypeType* type) {
  auto ret = visitArchetypeType(type);
  ret << dispatcher.fetchLabel(type->getDecl());
  return ret;
}

SwiftMangledName SwiftMangler::visitProtocolCompositionType(
    const swift::ProtocolCompositionType* type) {
  auto ret = initMangled(type);
  for (auto composed : type->getMembers()) {
    ret << dispatcher.fetchLabel(composed);
  }
  if (type->hasExplicitAnyObject()) {
    ret << "&AnyObject";
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitParenType(const swift::ParenType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getUnderlyingType());
  return ret;
}

SwiftMangledName SwiftMangler::visitLValueType(const swift::LValueType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getObjectType());
  return ret;
}

SwiftMangledName SwiftMangler::visitDynamicSelfType(const swift::DynamicSelfType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getSelfType());
  return ret;
}

SwiftMangledName SwiftMangler::visitUnboundGenericType(const swift::UnboundGenericType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getDecl());
  return ret;
}

SwiftMangledName SwiftMangler::visitReferenceStorageType(const swift::ReferenceStorageType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getReferentType());
  return ret;
}
