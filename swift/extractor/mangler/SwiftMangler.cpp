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

SwiftMangledName SwiftMangler::mangleDecl(const swift::Decl& decl) {
  if (!llvm::isa<swift::ValueDecl>(decl)) {
    return {};
  }
  // We do not deduplicate local variables, but for the moment also non-local vars from non-swift
  // (PCM, clang modules) modules as the mangler crashes sometimes
  if (decl.getKind() == swift::DeclKind::Var &&
      (decl.getDeclContext()->isLocalContext() || decl.getModuleContext()->isNonSwiftModule())) {
    return {};
  }

  // we do not deduplicate GenericTypeParamDecl, as their mangling is ambiguous in the presence of
  // extensions
  if (decl.getKind() == swift::DeclKind::GenericTypeParam) {
    return {};
  }

  if (decl.getKind() == swift::DeclKind::Module) {
    return mangleModuleName(llvm::cast<swift::ModuleDecl>(decl).getRealName().str());
  }

  auto ret = initMangled(&decl);
  const auto& valueDecl = llvm::cast<swift::ValueDecl>(decl);
  // stamp all declarations with an id-ref of the containing module
  auto moduleLabel = dispatcher.fetchLabel(decl.getModuleContext());
  ret << moduleLabel;
  if (decl.getKind() == swift::DeclKind::TypeAlias) {
    // In cases like this (when coming from PCM)
    //  typealias CFXMLTree = CFTree
    //  typealias CFXMLTreeRef = CFXMLTree
    // mangleAnyDecl mangles both CFXMLTree and CFXMLTreeRef into 'So12CFXMLTreeRefa'
    // which is not correct and causes inconsistencies. mangleEntity makes these two distinct
    // prefix adds a couple of special symbols, we don't necessary need them
    ret << mangler.mangleEntity(&valueDecl);
  } else {
    // prefix adds a couple of special symbols, we don't necessary need them
    ret << mangler.mangleAnyDecl(&valueDecl, /* prefix = */ false);
  }
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

SwiftMangledName SwiftMangler::visitBuiltinType(const swift::BuiltinType* type) {
  auto ret = initMangled(type);
  llvm::SmallString<32> buffer;
  ret << type->getTypeName(buffer, /* prependBuiltinNamespace= */ false);
  return ret;
}
