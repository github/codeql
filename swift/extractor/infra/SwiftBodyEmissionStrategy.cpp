#include "swift/extractor/infra/SwiftBodyEmissionStrategy.h"

using namespace codeql;

// In order to not emit duplicated entries for declarations, we restrict emission to only
// Decls declared within the current "scope".
// Depending on the whether we are extracting a primary source file or not the scope is defined as
// follows:
//  - not extracting a primary source file (`currentPrimarySourceFile == nullptr`): the current
//    scope means the current module. This is used in the case of system or builtin modules.
//  - extracting a primary source file: in this mode, we extract several files belonging to the
//    same module one by one. In this mode, we restrict emission only to the same file ignoring
//    all the other files.
bool SwiftBodyEmissionStrategy::shouldEmitDeclBody(const swift::Decl& decl) {
  auto module = decl.getModuleContext();
  if (module != &currentModule) {
    return false;
  }
  if (currentLazyDeclaration && currentLazyDeclaration != &decl) {
    return false;
  }
  // ModuleDecl is a special case: if it passed the previous test, it is the current module
  // but it never has a source file, so we short circuit to emit it in any case
  if (!currentPrimarySourceFile || decl.getKind() == swift::DeclKind::Module) {
    return true;
  }
  if (auto context = decl.getDeclContext()) {
    return currentPrimarySourceFile == context->getParentSourceFile();
  }
  return false;
}
