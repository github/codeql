#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"
#include <swift/AST/Module.h>
#include <sstream>

using namespace codeql;

namespace {
SwiftMangledName initMangled(const swift::TypeBase* type) {
  switch (type->getKind()) {
#define TYPE(ID, PARENT)    \
  case swift::TypeKind::ID: \
    return {{#ID "Type_"}};
#include <swift/AST/TypeNodes.def>
    default:
      return {};
  }
}

SwiftMangledName initMangled(const swift::Decl* decl) {
  SwiftMangledName ret;
  ret << swift::Decl::getKindName(decl->getKind()) << "Decl_";
  return ret;
}

}  // namespace

SwiftMangledName SwiftMangler::mangleModuleName(std::string_view name) {
  SwiftMangledName ret = {{"ModuleDecl_"}};
  ret << name;
  return ret;
}

SwiftMangledName SwiftMangler::visitValueDecl(const swift::ValueDecl* decl) {
  // We do not deduplicate local variables, but for the moment also non-local vars from non-swift
  // (PCM, clang modules) modules as the mangler crashes sometimes
  if (decl->getKind() == swift::DeclKind::Var &&
      (decl->getDeclContext()->isLocalContext() || decl->getModuleContext()->isNonSwiftModule())) {
    return {};
  }

  // we do not deduplicate GenericTypeParamDecl of extensions yet, as their mangling is ambiguous
  if (decl->getKind() == swift::DeclKind::GenericTypeParam &&
      decl->getDeclContext()->getContextKind() == swift::DeclContextKind::ExtensionDecl) {
    return {};
  }

  auto ret = initMangled(decl);
  // stamp all declarations with an id-ref of the containing module
  auto moduleLabel = dispatcher.fetchLabel(decl->getModuleContext());
  ret << moduleLabel;
  if (decl->getKind() == swift::DeclKind::TypeAlias) {
    // In cases like this (when coming from PCM)
    //  typealias CFXMLTree = CFTree
    //  typealias CFXMLTreeRef = CFXMLTree
    // mangleAnyDecl mangles both CFXMLTree and CFXMLTreeRef into 'So12CFXMLTreeRefa'
    // which is not correct and causes inconsistencies. mangleEntity makes these two distinct
    // prefix adds a couple of special symbols, we don't necessary need them
    ret << mangler.mangleEntity(decl);
  } else {
    // prefix adds a couple of special symbols, we don't necessary need them
    ret << mangler.mangleAnyDecl(decl, /* prefix = */ false);
  }
  return ret;
}

SwiftMangledName SwiftMangler::visitModuleDecl(const swift::ModuleDecl* decl) {
  return mangleModuleName(decl->getRealName().str());
}

SwiftMangledName SwiftMangler::visitTypeDecl(const swift::TypeDecl* decl) {
  auto context = decl->getDeclContext();
  if (context->isLocalContext()) {
    return {};
  }
  auto parent = (context->getContextKind() == swift::DeclContextKind::FileUnit)
                    ? decl->getModuleContext()
                    : context->getAsDecl();
  auto ret = initMangled(decl);
  ret << dispatcher.fetchLabel(parent);
  ret << decl->getNameStr();
  return ret;
}

SwiftMangledName SwiftMangler::visitModuleType(const swift::ModuleType* type) {
  auto ret = initMangled(type);
  ret << type->getModule()->getRealName().str();
  if (type->getModule()->isNonSwiftModule()) {
    ret << "|clang";
  }
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
  type->getTypeName(buffer);
  ret << buffer.str();
  return ret;
}

SwiftMangledName SwiftMangler::visitAnyGenericType(const swift::AnyGenericType* type) {
  auto ret = initMangled(type);
  ret << dispatcher.fetchLabel(type->getDecl());
  return ret;
}

SwiftMangledName SwiftMangler::visitType(const swift::TypeBase* type) {
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
    ret << dispatcher.fetchLabel(param.getOldType());
  }
  ret << "->" << dispatcher.fetchLabel(type->getResult());
  if (type->isAsync()) {
    ret << "_async";
  }
  if (type->isThrowing()) {
    ret << "_throws";
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
  ret << dispatcher.fetchLabel(type->getAssocType());
  return ret;
}
