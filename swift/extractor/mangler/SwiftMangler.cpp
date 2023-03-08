#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/infra/SwiftDispatcher.h"
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

std::string SwiftMangler::mangleType(const swift::TypeBase& type) {
  // spit out a random ID
  static constexpr auto chrs = "0123456789abcdef";
  static std::mt19937 rg{std::random_device{}()};
  static std::uniform_int_distribution<std::string::size_type> dist(0, sizeof(chrs) - 2);
  std::string ret(16, '\0');
  std::generate_n(ret.begin(), ret.size(), [&] { return chrs[dist(rg)]; });
  return ret;
}

std::string SwiftMangler::mangleType(const swift::ModuleType& type) {
  auto key = type.getModule()->getRealName().str().str();
  if (type.getModule()->isNonSwiftModule()) {
    key += "|clang";
  }
  return key;
}

std::string SwiftMangler::mangleType(const swift::TupleType& type) {
  std::stringstream stream;
  stream << "(";
  for (const auto& element : type.getElements()) {
    auto s2 = dispatcher.fetchLabel(element.getType());
    if (element.hasName()) {
      stream << static_cast<std::string_view>(element.getName().str()) << ':';
    }
    stream << "{" << s2 << "}";
  }
  stream << ")";
  return stream.str();
}

std::string SwiftMangler::mangleType(const swift::BuiltinType& type) {
  llvm::SmallString<32> buffer;
  type.getTypeName(buffer);
  return buffer.str().str();
}
