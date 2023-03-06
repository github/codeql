#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"
#include <swift/AST/Module.h>
#include <sstream>

using namespace codeql;

std::string SwiftMangler::mangledName(const swift::Decl& decl) {
  assert(llvm::isa<swift::ValueDecl>(decl));
  auto& valueDecl = llvm::cast<swift::ValueDecl>(decl);
  std::string_view moduleName = decl.getModuleContext()->getRealName().str();
  // ASTMangler::mangleAnyDecl crashes when called on `ModuleDecl`
  if (decl.getKind() == swift::DeclKind::Module) {
    return std::string{moduleName};
  }
  std::ostringstream ret;
  // stamp all declarations with an id-ref of the containing module
  ret << '{' << ModuleDeclTag::prefix << '_' << moduleName << '}';
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
  return ret.str();
}
