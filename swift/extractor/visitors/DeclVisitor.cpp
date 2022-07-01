#include "swift/extractor/visitors/DeclVisitor.h"

#include <swift/AST/GenericParamList.h>
#include <swift/AST/ParameterList.h>

namespace codeql {
namespace {
// Constructs a `std::string` of the form `f(x:y:)` for a declaration
// like `func f(x first: Int, y second: Int) {  }`
std::string constructName(const swift::DeclName& declName) {
  std::string name = declName.getBaseName().userFacingName().str();
  name += "(";
  for (const auto& argName : declName.getArgumentNames()) {
    if (argName.empty()) {
      name += "_:";
    } else {
      name += argName.str().str() + ":";
    }
  }
  name += ")";
  return name;
}
}  // namespace

std::variant<codeql::ConcreteFuncDecl, codeql::ConcreteFuncDeclsTrap>
DeclVisitor::translateFuncDecl(const swift::FuncDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return ConcreteFuncDeclsTrap{id};
  }
  ConcreteFuncDecl entry{id};
  fillAbstractFunctionDecl(decl, entry);
  return entry;
}

std::variant<codeql::ConstructorDecl, codeql::ConstructorDeclsTrap>
DeclVisitor::translateConstructorDecl(const swift::ConstructorDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return ConstructorDeclsTrap{id};
  }
  ConstructorDecl entry{id};
  fillAbstractFunctionDecl(decl, entry);
  return entry;
}

std::variant<codeql::DestructorDecl, codeql::DestructorDeclsTrap>
DeclVisitor::translateDestructorDecl(const swift::DestructorDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return DestructorDeclsTrap{id};
  }
  DestructorDecl entry{id};
  fillAbstractFunctionDecl(decl, entry);
  return entry;
}

codeql::PrefixOperatorDecl DeclVisitor::translatePrefixOperatorDecl(
    const swift::PrefixOperatorDecl& decl) {
  PrefixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::PostfixOperatorDecl DeclVisitor::translatePostfixOperatorDecl(
    const swift::PostfixOperatorDecl& decl) {
  PostfixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::InfixOperatorDecl DeclVisitor::translateInfixOperatorDecl(
    const swift::InfixOperatorDecl& decl) {
  InfixOperatorDecl entry{dispatcher_.assignNewLabel(decl)};
  entry.precedence_group = dispatcher_.fetchOptionalLabel(decl.getPrecedenceGroup());
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::PrecedenceGroupDecl DeclVisitor::translatePrecedenceGroupDecl(
    const swift::PrecedenceGroupDecl& decl) {
  PrecedenceGroupDecl entry{dispatcher_.assignNewLabel(decl)};
  return entry;
}

codeql::ParamDecl DeclVisitor::translateParamDecl(const swift::ParamDecl& decl) {
  // TODO: deduplicate
  ParamDecl entry{dispatcher_.assignNewLabel(decl)};
  fillVarDecl(decl, entry);
  entry.is_inout = decl.isInOut();
  return entry;
}

codeql::TopLevelCodeDecl DeclVisitor::translateTopLevelCodeDecl(
    const swift::TopLevelCodeDecl& decl) {
  TopLevelCodeDecl entry{dispatcher_.assignNewLabel(decl)};
  assert(decl.getBody() && "Expect top level code to have body");
  entry.body = dispatcher_.fetchLabel(decl.getBody());
  return entry;
}

codeql::PatternBindingDecl DeclVisitor::translatePatternBindingDecl(
    const swift::PatternBindingDecl& decl) {
  PatternBindingDecl entry{dispatcher_.assignNewLabel(decl)};
  for (unsigned i = 0; i < decl.getNumPatternEntries(); ++i) {
    auto pattern = decl.getPattern(i);
    assert(pattern && "Expect pattern binding decl to have all patterns");
    entry.patterns.push_back(dispatcher_.fetchLabel(pattern));
    entry.inits.push_back(dispatcher_.fetchOptionalLabel(decl.getInit(i)));
  }
  return entry;
}

codeql::ConcreteVarDecl DeclVisitor::translateVarDecl(const swift::VarDecl& decl) {
  // TODO: deduplicate all non-local variables
  ConcreteVarDecl entry{dispatcher_.assignNewLabel(decl)};
  entry.introducer_int = static_cast<uint8_t>(decl.getIntroducer());
  fillVarDecl(decl, entry);
  return entry;
}

std::variant<codeql::StructDecl, codeql::StructDeclsTrap> DeclVisitor::translateStructDecl(
    const swift::StructDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return StructDeclsTrap{id};
  }
  StructDecl entry{id};
  fillNominalTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::ClassDecl, codeql::ClassDeclsTrap> DeclVisitor::translateClassDecl(
    const swift::ClassDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return ClassDeclsTrap{id};
  }
  ClassDecl entry{id};
  fillNominalTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::EnumDecl, codeql::EnumDeclsTrap> DeclVisitor::translateEnumDecl(
    const swift::EnumDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return EnumDeclsTrap{id};
  }
  EnumDecl entry{id};
  fillNominalTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::ProtocolDecl, codeql::ProtocolDeclsTrap> DeclVisitor::translateProtocolDecl(
    const swift::ProtocolDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return ProtocolDeclsTrap{id};
  }
  ProtocolDecl entry{id};
  fillNominalTypeDecl(decl, entry);
  return entry;
}

codeql::EnumCaseDecl DeclVisitor::translateEnumCaseDecl(const swift::EnumCaseDecl& decl) {
  EnumCaseDecl entry{dispatcher_.assignNewLabel(decl)};
  entry.elements = dispatcher_.fetchRepeatedLabels(decl.getElements());
  return entry;
}

std::variant<codeql::EnumElementDecl, codeql::EnumElementDeclsTrap>
DeclVisitor::translateEnumElementDecl(const swift::EnumElementDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return EnumElementDeclsTrap{id, decl.getNameStr().str()};
  }
  EnumElementDecl entry{id};
  entry.name = decl.getNameStr().str();
  if (decl.hasParameterList()) {
    entry.params = dispatcher_.fetchRepeatedLabels(*decl.getParameterList());
  }
  fillValueDecl(decl, entry);
  return entry;
}

codeql::GenericTypeParamDecl DeclVisitor::translateGenericTypeParamDecl(
    const swift::GenericTypeParamDecl& decl) {
  // TODO: deduplicate
  GenericTypeParamDecl entry{dispatcher_.assignNewLabel(decl)};
  fillTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::AssociatedTypeDecl, codeql::AssociatedTypeDeclsTrap>
DeclVisitor::translateAssociatedTypeDecl(const swift::AssociatedTypeDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return AssociatedTypeDeclsTrap{id};
  }
  AssociatedTypeDecl entry{id};
  fillTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::TypeAliasDecl, codeql::TypeAliasDeclsTrap> DeclVisitor::translateTypeAliasDecl(
    const swift::TypeAliasDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return TypeAliasDeclsTrap{id};
  }
  TypeAliasDecl entry{id};
  fillTypeDecl(decl, entry);
  return entry;
}

std::variant<codeql::AccessorDecl, codeql::AccessorDeclsTrap> DeclVisitor::translateAccessorDecl(
    const swift::AccessorDecl& decl) {
  auto id = dispatcher_.assignNewLabel(decl, mangledName(decl));
  if (!dispatcher_.shouldEmitDeclBody(decl)) {
    return AccessorDeclsTrap{id};
  }
  AccessorDecl entry{id};
  switch (decl.getAccessorKind()) {
    case swift::AccessorKind::Get:
      entry.is_getter = true;
      break;
    case swift::AccessorKind::Set:
      entry.is_setter = true;
      break;
    case swift::AccessorKind::WillSet:
      entry.is_will_set = true;
      break;
    case swift::AccessorKind::DidSet:
      entry.is_did_set = true;
      break;
  }
  fillAbstractFunctionDecl(decl, entry);
  return entry;
}

std::optional<codeql::SubscriptDecl> DeclVisitor::translateSubscriptDecl(
    const swift::SubscriptDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  entry->element_type = dispatcher_.fetchLabel(decl.getElementInterfaceType());
  if (auto indices = decl.getIndices()) {
    entry->params = dispatcher_.fetchRepeatedLabels(*indices);
  }
  fillAbstractStorageDecl(decl, *entry);
  return entry;
}

codeql::ExtensionDecl DeclVisitor::translateExtensionDecl(const swift::ExtensionDecl& decl) {
  ExtensionDecl entry{dispatcher_.assignNewLabel(decl)};
  entry.extended_type_decl = dispatcher_.fetchLabel(decl.getExtendedNominal());
  fillGenericContext(decl, entry);
  fillIterableDeclContext(decl, entry);
  return entry;
}

codeql::ImportDecl DeclVisitor::translateImportDecl(const swift::ImportDecl& decl) {
  auto entry = dispatcher_.createEntry(decl);
  entry.is_exported = decl.isExported();
  entry.module = dispatcher_.fetchLabel(decl.getModule());
  entry.declarations = dispatcher_.fetchRepeatedLabels(decl.getDecls());
  return entry;
}

std::optional<codeql::ModuleDecl> DeclVisitor::translateModuleDecl(const swift::ModuleDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  entry->is_builtin_module = decl.isBuiltinModule();
  entry->is_system_module = decl.isSystemModule();
  fillTypeDecl(decl, *entry);
  return entry;
}

std::string DeclVisitor::mangledName(const swift::ValueDecl& decl) {
  // ASTMangler::mangleAnyDecl crashes when called on `ModuleDecl`
  // TODO find a more unique string working also when different modules are compiled with the same
  // name
  if (decl.getKind() == swift::DeclKind::Module) {
    return static_cast<const swift::ModuleDecl&>(decl).getRealName().str().str();
  }
  // prefix adds a couple of special symbols, we don't necessary need them
  return mangler.mangleAnyDecl(&decl, /* prefix = */ false);
}

void DeclVisitor::fillAbstractFunctionDecl(const swift::AbstractFunctionDecl& decl,
                                           codeql::AbstractFunctionDecl& entry) {
  assert(decl.hasParameterList() && "Expect functions to have a parameter list");
  entry.name = !decl.hasName() ? "(unnamed function decl)" : constructName(decl.getName());
  entry.body = dispatcher_.fetchOptionalLabel(decl.getBody());
  entry.params = dispatcher_.fetchRepeatedLabels(*decl.getParameters());
  fillValueDecl(decl, entry);
  fillGenericContext(decl, entry);
}

void DeclVisitor::fillOperatorDecl(const swift::OperatorDecl& decl, codeql::OperatorDecl& entry) {
  entry.name = decl.getName().str().str();
}

void DeclVisitor::fillTypeDecl(const swift::TypeDecl& decl, codeql::TypeDecl& entry) {
  entry.name = decl.getNameStr().str();
  for (auto& typeLoc : decl.getInherited()) {
    if (auto type = typeLoc.getType()) {
      entry.base_types.push_back(dispatcher_.fetchLabel(type));
    }
  }
  fillValueDecl(decl, entry);
}

void DeclVisitor::fillIterableDeclContext(const swift::IterableDeclContext& decl,
                                          codeql::IterableDeclContext& entry) {
  entry.members = dispatcher_.fetchRepeatedLabels(decl.getAllMembers());
}

void DeclVisitor::fillVarDecl(const swift::VarDecl& decl, codeql::VarDecl& entry) {
  entry.name = decl.getNameStr().str();
  entry.type = dispatcher_.fetchLabel(decl.getType());
  entry.parent_pattern = dispatcher_.fetchOptionalLabel(decl.getParentPattern());
  entry.parent_initializer = dispatcher_.fetchOptionalLabel(decl.getParentInitializer());
  if (decl.hasAttachedPropertyWrapper()) {
    entry.attached_property_wrapper_type =
        dispatcher_.fetchOptionalLabel(decl.getPropertyWrapperBackingPropertyType());
  }
  fillAbstractStorageDecl(decl, entry);
}

void DeclVisitor::fillNominalTypeDecl(const swift::NominalTypeDecl& decl,
                                      codeql::NominalTypeDecl& entry) {
  entry.type = dispatcher_.fetchLabel(decl.getDeclaredType());
  fillGenericContext(decl, entry);
  fillIterableDeclContext(decl, entry);
  fillTypeDecl(decl, entry);
}

void DeclVisitor::fillGenericContext(const swift::GenericContext& decl,
                                     codeql::GenericContext& entry) {
  if (auto params = decl.getGenericParams()) {
    entry.generic_type_params = dispatcher_.fetchRepeatedLabels(*params);
  }
}

void DeclVisitor::fillValueDecl(const swift::ValueDecl& decl, codeql::ValueDecl& entry) {
  assert(decl.getInterfaceType() && "Expect ValueDecl to have InterfaceType");
  entry.interface_type = dispatcher_.fetchLabel(decl.getInterfaceType());
}

void DeclVisitor::fillAbstractStorageDecl(const swift::AbstractStorageDecl& decl,
                                          codeql::AbstractStorageDecl& entry) {
  entry.accessor_decls = dispatcher_.fetchRepeatedLabels(decl.getAllAccessors());
  fillValueDecl(decl, entry);
}

}  // namespace codeql
