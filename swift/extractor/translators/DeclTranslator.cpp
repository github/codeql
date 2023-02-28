#include "swift/extractor/translators/DeclTranslator.h"

#include <swift/AST/GenericParamList.h>
#include <swift/AST/ParameterList.h>
#include "swift/extractor/infra/SwiftDiagnosticKind.h"
#include <swift/AST/PropertyWrappers.h>

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

std::optional<codeql::ConcreteFuncDecl> DeclTranslator::translateFuncDecl(
    const swift::FuncDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillAbstractFunctionDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::ConstructorDecl> DeclTranslator::translateConstructorDecl(
    const swift::ConstructorDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillAbstractFunctionDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::DestructorDecl> DeclTranslator::translateDestructorDecl(
    const swift::DestructorDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillAbstractFunctionDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

codeql::PrefixOperatorDecl DeclTranslator::translatePrefixOperatorDecl(
    const swift::PrefixOperatorDecl& decl) {
  auto entry = createEntry(decl);
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::PostfixOperatorDecl DeclTranslator::translatePostfixOperatorDecl(
    const swift::PostfixOperatorDecl& decl) {
  auto entry = createEntry(decl);
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::InfixOperatorDecl DeclTranslator::translateInfixOperatorDecl(
    const swift::InfixOperatorDecl& decl) {
  auto entry = createEntry(decl);
  entry.precedence_group = dispatcher.fetchOptionalLabel(decl.getPrecedenceGroup());
  fillOperatorDecl(decl, entry);
  return entry;
}

codeql::PrecedenceGroupDecl DeclTranslator::translatePrecedenceGroupDecl(
    const swift::PrecedenceGroupDecl& decl) {
  auto entry = createEntry(decl);
  return entry;
}

std::optional<codeql::ParamDecl> DeclTranslator::translateParamDecl(const swift::ParamDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  fillVarDecl(decl, *entry);
  entry->is_inout = decl.isInOut();
  if (auto wrapped = decl.getPropertyWrapperWrappedValueVar()) {
    entry->property_wrapper_local_wrapped_var = dispatcher.fetchLabel(wrapped);
    entry->property_wrapper_local_wrapped_var_binding =
        dispatcher.fetchLabel(wrapped->getParentPatternBinding());
  }
  return entry;
}

codeql::TopLevelCodeDecl DeclTranslator::translateTopLevelCodeDecl(
    const swift::TopLevelCodeDecl& decl) {
  auto entry = createEntry(decl);
  assert(decl.getBody() && "Expect top level code to have body");
  entry.body = dispatcher.fetchLabel(decl.getBody());
  return entry;
}

codeql::PatternBindingDecl DeclTranslator::translatePatternBindingDecl(
    const swift::PatternBindingDecl& decl) {
  auto entry = createEntry(decl);
  for (unsigned i = 0; i < decl.getNumPatternEntries(); ++i) {
    auto pattern = decl.getPattern(i);
    assert(pattern && "Expect pattern binding decl to have all patterns");
    entry.patterns.push_back(dispatcher.fetchLabel(pattern));
    entry.inits.push_back(dispatcher.fetchOptionalLabel(decl.getInit(i)));
  }
  return entry;
}

std::optional<codeql::ConcreteVarDecl> DeclTranslator::translateVarDecl(
    const swift::VarDecl& decl) {
  std::optional<codeql::ConcreteVarDecl> entry;
  // We do not deduplicate variables from non-swift (PCM, clang modules) modules as the mangler
  // crashes sometimes
  if (decl.getDeclContext()->isLocalContext() || decl.getModuleContext()->isNonSwiftModule()) {
    entry = createEntry(decl);
  } else {
    entry = createNamedEntry(decl);
    if (!entry) {
      return std::nullopt;
    }
  }
  entry->introducer_int = static_cast<uint8_t>(decl.getIntroducer());
  fillVarDecl(decl, *entry);
  return entry;
}

std::optional<codeql::StructDecl> DeclTranslator::translateStructDecl(
    const swift::StructDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillNominalTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::ClassDecl> DeclTranslator::translateClassDecl(const swift::ClassDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillNominalTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::EnumDecl> DeclTranslator::translateEnumDecl(const swift::EnumDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillNominalTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::ProtocolDecl> DeclTranslator::translateProtocolDecl(
    const swift::ProtocolDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillNominalTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

codeql::EnumCaseDecl DeclTranslator::translateEnumCaseDecl(const swift::EnumCaseDecl& decl) {
  auto entry = createEntry(decl);
  entry.elements = dispatcher.fetchRepeatedLabels(decl.getElements());
  return entry;
}

std::optional<codeql::EnumElementDecl> DeclTranslator::translateEnumElementDecl(
    const swift::EnumElementDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  entry->name = decl.getNameStr().str();
  if (decl.hasParameterList()) {
    entry->params = dispatcher.fetchRepeatedLabels(*decl.getParameterList());
  }
  fillValueDecl(decl, *entry);
  return entry;
}

codeql::GenericTypeParamDecl DeclTranslator::translateGenericTypeParamDecl(
    const swift::GenericTypeParamDecl& decl) {
  // TODO: deduplicate
  auto entry = createEntry(decl);
  fillTypeDecl(decl, entry);
  return entry;
}

std::optional<codeql::AssociatedTypeDecl> DeclTranslator::translateAssociatedTypeDecl(
    const swift::AssociatedTypeDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::TypeAliasDecl> DeclTranslator::translateTypeAliasDecl(
    const swift::TypeAliasDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillTypeDecl(decl, *entry);
    return entry;
  }
  return std::nullopt;
}

std::optional<codeql::AccessorDecl> DeclTranslator::translateAccessorDecl(
    const swift::AccessorDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  switch (decl.getAccessorKind()) {
    case swift::AccessorKind::Get:
      entry->is_getter = true;
      break;
    case swift::AccessorKind::Set:
      entry->is_setter = true;
      break;
    case swift::AccessorKind::WillSet:
      entry->is_will_set = true;
      break;
    case swift::AccessorKind::DidSet:
      entry->is_did_set = true;
      break;
    case swift::AccessorKind::Read:
      entry->is_read = true;
      break;
    case swift::AccessorKind::Modify:
      entry->is_modify = true;
      break;
    case swift::AccessorKind::Address:
      entry->is_unsafe_address = true;
      break;
    case swift::AccessorKind::MutableAddress:
      entry->is_unsafe_mutable_address = true;
      break;
  }
  fillAbstractFunctionDecl(decl, *entry);
  return entry;
}

std::optional<codeql::SubscriptDecl> DeclTranslator::translateSubscriptDecl(
    const swift::SubscriptDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  entry->element_type = dispatcher.fetchLabel(decl.getElementInterfaceType());
  if (auto indices = decl.getIndices()) {
    entry->params = dispatcher.fetchRepeatedLabels(*indices);
  }
  fillAbstractStorageDecl(decl, *entry);
  return entry;
}

codeql::ExtensionDecl DeclTranslator::translateExtensionDecl(const swift::ExtensionDecl& decl) {
  auto entry = createEntry(decl);
  entry.extended_type_decl = dispatcher.fetchLabel(decl.getExtendedNominal());
  entry.protocols = dispatcher.fetchRepeatedLabels(decl.getLocalProtocols());
  fillGenericContext(decl, entry);
  fillIterableDeclContext(decl, entry);
  return entry;
}

codeql::ImportDecl DeclTranslator::translateImportDecl(const swift::ImportDecl& decl) {
  auto entry = createEntry(decl);
  entry.is_exported = decl.isExported();
  entry.imported_module = dispatcher.fetchOptionalLabel(decl.getModule());
  entry.declarations = dispatcher.fetchRepeatedLabels(decl.getDecls());
  return entry;
}

std::optional<codeql::ModuleDecl> DeclTranslator::translateModuleDecl(
    const swift::ModuleDecl& decl) {
  auto entry = createNamedEntry(decl);
  if (!entry) {
    return std::nullopt;
  }
  entry->is_builtin_module = decl.isBuiltinModule();
  entry->is_system_module = decl.isSystemModule();
  using K = swift::ModuleDecl::ImportFilterKind;
  llvm::SmallVector<swift::ImportedModule> imports;
  decl.getImportedModules(imports, K::Default);
  for (const auto& import : imports) {
    entry->imported_modules.push_back(dispatcher.fetchLabel(import.importedModule));
  }
  imports.clear();
  decl.getImportedModules(imports, K::Exported);
  for (const auto& import : imports) {
    entry->exported_modules.push_back(dispatcher.fetchLabel(import.importedModule));
  }
  fillTypeDecl(decl, *entry);
  return entry;
}

std::string DeclTranslator::mangledName(const swift::ValueDecl& decl) {
  return mangler.mangledName(decl);
}

void DeclTranslator::fillAbstractFunctionDecl(const swift::AbstractFunctionDecl& decl,
                                              codeql::AbstractFunctionDecl& entry) {
  assert(decl.hasParameterList() && "Expect functions to have a parameter list");
  entry.name = !decl.hasName() ? "(unnamed function decl)" : constructName(decl.getName());
  entry.body = dispatcher.fetchOptionalLabel(decl.getBody());
  entry.params = dispatcher.fetchRepeatedLabels(*decl.getParameters());
  auto self = const_cast<swift::ParamDecl* const>(decl.getImplicitSelfDecl());
  entry.self_param = dispatcher.fetchOptionalLabel(self);
  entry.captures = dispatcher.fetchRepeatedLabels(decl.getCaptureInfo().getCaptures());
  fillValueDecl(decl, entry);
  fillGenericContext(decl, entry);
}

void DeclTranslator::fillOperatorDecl(const swift::OperatorDecl& decl,
                                      codeql::OperatorDecl& entry) {
  entry.name = decl.getName().str().str();
}

void DeclTranslator::fillTypeDecl(const swift::TypeDecl& decl, codeql::TypeDecl& entry) {
  entry.name = decl.getNameStr().str();
  for (auto& typeLoc : decl.getInherited()) {
    if (auto type = typeLoc.getType()) {
      entry.base_types.push_back(dispatcher.fetchLabel(type));
    }
  }
  fillValueDecl(decl, entry);
}

void DeclTranslator::fillIterableDeclContext(const swift::IterableDeclContext& decl,
                                             codeql::Decl& entry) {
  entry.members = dispatcher.fetchRepeatedLabels(decl.getAllMembers());
}

void DeclTranslator::fillVarDecl(const swift::VarDecl& decl, codeql::VarDecl& entry) {
  entry.name = decl.getNameStr().str();
  entry.type = dispatcher.fetchLabel(decl.getType());
  entry.parent_pattern = dispatcher.fetchOptionalLabel(decl.getParentPattern());
  entry.parent_initializer = dispatcher.fetchOptionalLabel(decl.getParentInitializer());
  if (decl.hasAttachedPropertyWrapper()) {
    entry.attached_property_wrapper_type =
        dispatcher.fetchOptionalLabel(decl.getPropertyWrapperBackingPropertyType());
  }
  fillAbstractStorageDecl(decl, entry);
  if (auto backing = decl.getPropertyWrapperBackingProperty()) {
    entry.property_wrapper_backing_var = dispatcher.fetchLabel(backing);
    entry.property_wrapper_backing_var_binding =
        dispatcher.fetchLabel(backing->getParentPatternBinding());
  }
  if (auto projection = decl.getPropertyWrapperProjectionVar()) {
    entry.property_wrapper_projection_var = dispatcher.fetchLabel(projection);
    entry.property_wrapper_projection_var_binding =
        dispatcher.fetchLabel(projection->getParentPatternBinding());
  }
}

void DeclTranslator::fillNominalTypeDecl(const swift::NominalTypeDecl& decl,
                                         codeql::NominalTypeDecl& entry) {
  entry.type = dispatcher.fetchLabel(decl.getDeclaredType());
  fillGenericContext(decl, entry);
  fillIterableDeclContext(decl, entry);
  fillTypeDecl(decl, entry);
}

void DeclTranslator::fillGenericContext(const swift::GenericContext& decl,
                                        codeql::GenericContext& entry) {
  if (auto params = decl.getGenericParams()) {
    entry.generic_type_params = dispatcher.fetchRepeatedLabels(*params);
  }
}

void DeclTranslator::fillValueDecl(const swift::ValueDecl& decl, codeql::ValueDecl& entry) {
  assert(decl.getInterfaceType() && "Expect ValueDecl to have InterfaceType");
  entry.interface_type = dispatcher.fetchLabel(decl.getInterfaceType());
}

void DeclTranslator::fillAbstractStorageDecl(const swift::AbstractStorageDecl& decl,
                                             codeql::AbstractStorageDecl& entry) {
  entry.accessor_decls = dispatcher.fetchRepeatedLabels(decl.getAllAccessors());
  fillValueDecl(decl, entry);
}

codeql::IfConfigDecl DeclTranslator::translateIfConfigDecl(const swift::IfConfigDecl& decl) {
  auto entry = createEntry(decl);
  if (auto activeClause = decl.getActiveClause()) {
    entry.active_elements = dispatcher.fetchRepeatedLabels(activeClause->Elements);
  }
  return entry;
}

std::optional<codeql::OpaqueTypeDecl> DeclTranslator::translateOpaqueTypeDecl(
    const swift::OpaqueTypeDecl& decl) {
  if (auto entry = createNamedEntry(decl)) {
    fillTypeDecl(decl, *entry);
    entry->naming_declaration = dispatcher.fetchLabel(decl.getNamingDecl());
    entry->opaque_generic_params = dispatcher.fetchRepeatedLabels(decl.getOpaqueGenericParams());
    return entry;
  }
  return std::nullopt;
}

codeql::PoundDiagnosticDecl DeclTranslator::translatePoundDiagnosticDecl(
    const swift::PoundDiagnosticDecl& decl) {
  auto entry = createEntry(decl);
  entry.kind = translateDiagnosticsKind(decl.getKind());
  entry.message = dispatcher.fetchLabel(decl.getMessage());
  return entry;
}

codeql::MissingMemberDecl DeclTranslator::translateMissingMemberDecl(
    const swift::MissingMemberDecl& decl) {
  auto entry = createEntry(decl);
  entry.name = decl.getName().getBaseName().userFacingName().str();
  return entry;
}

codeql::CapturedDecl DeclTranslator::translateCapturedValue(const swift::CapturedValue& capture) {
  codeql::CapturedDecl entry{dispatcher.template assignNewLabel(capture)};
  auto decl = capture.getDecl();
  entry.decl = dispatcher.fetchLabel(decl);
  entry.module = dispatcher.fetchLabel(decl->getModuleContext());
  entry.is_direct = capture.isDirect();
  entry.is_escaping = !capture.isNoEscape();
  return entry;
}
}  // namespace codeql
