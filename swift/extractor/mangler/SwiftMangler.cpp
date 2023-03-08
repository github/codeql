#include "swift/extractor/mangler/SwiftMangler.h"
#include "swift/extractor/infra/SwiftDispatcher.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"
#include <swift/AST/Module.h>
#include <sstream>

namespace codeql {
namespace {
// streaming labels into a MangledName just appends them
template <typename Tag>
inline MangledName& operator<<(MangledName& name, TrapLabel<Tag> label) {
  name.parts.emplace_back(label);
  return name;
}

// streaming string-like stuff will add a new part it only if strictly required, otherwise it will
// append to the last part if it is a string
template <typename T>
inline MangledName& operator<<(MangledName& name, T&& arg) {
  if (name.parts.empty() || std::holds_alternative<UntypedTrapLabel>(name.parts.back())) {
    name.parts.emplace_back("");
  }
  std::get<std::string>(name.parts.back()) += std::forward<T>(arg);
  return name;
}
}  // namespace
}  // namespace codeql

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

MangledName SwiftMangler::mangleType(const swift::TypeBase& type) {
  // spit out a random ID
  static constexpr auto chrs = "0123456789abcdef";
  static std::mt19937 rg{std::random_device{}()};
  static std::uniform_int_distribution<std::string::size_type> dist(0, sizeof(chrs) - 2);
  std::string ret(16, '\0');
  std::generate_n(ret.begin(), ret.size(), [&] { return chrs[dist(rg)]; });
  return {{ret}};
}

MangledName SwiftMangler::mangleType(const swift::ModuleType& type) {
  auto key = type.getModule()->getRealName().str().str();
  if (type.getModule()->isNonSwiftModule()) {
    key += "|clang";
  }
  return {{key}};
}

MangledName SwiftMangler::mangleType(const swift::TupleType& type) {
  MangledName ret;
  ret << '(';
  for (const auto& element : type.getElements()) {
    if (element.hasName()) {
      ret << element.getName().str() << ':';
    }
    ret << dispatcher.fetchLabel(element.getType());
  }
  ret << ')';
  return ret;
}

MangledName SwiftMangler::mangleType(const swift::BuiltinType& type) {
  llvm::SmallString<32> buffer;
  type.getTypeName(buffer);
  return {{buffer.str().str()}};
}

namespace {
void printPart(std::ostream& out, const std::string& prefix) {
  out << prefix;
}

void printPart(std::ostream& out, UntypedTrapLabel label) {
  out << '{' << label << '}';
}
}  // namespace

std::ostream& codeql::operator<<(std::ostream& out, const MangledName& name) {
  for (const auto& part : name.parts) {
    std::visit([&](const auto& contents) { printPart(out, contents); }, part);
  }
  return out;
}
