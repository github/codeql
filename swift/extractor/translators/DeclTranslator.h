#pragma once

#include <swift/AST/Decl.h>
#include <swift/AST/ASTMangler.h>
#include <swift/AST/Module.h>

#include "swift/extractor/translators/TranslatorBase.h"
#include "swift/extractor/trap/generated/decl/TrapClasses.h"

namespace codeql {

// `swift::Decl` visitor
// TODO all `std::variant` here should really be `std::optional`, but we need those kinds of
// "forward declarations" while our extraction is incomplete
class DeclTranslator : public AstTranslatorBase<DeclTranslator> {
 public:
  static constexpr std::string_view name = "decl";

  using AstTranslatorBase<DeclTranslator>::AstTranslatorBase;

  codeql::NamedFunction translateFuncDecl(const swift::FuncDecl& decl);
  codeql::Initializer translateConstructorDecl(const swift::ConstructorDecl& decl);
  codeql::Deinitializer translateDestructorDecl(const swift::DestructorDecl& decl);
  codeql::PrefixOperatorDecl translatePrefixOperatorDecl(const swift::PrefixOperatorDecl& decl);
  codeql::PostfixOperatorDecl translatePostfixOperatorDecl(const swift::PostfixOperatorDecl& decl);
  codeql::InfixOperatorDecl translateInfixOperatorDecl(const swift::InfixOperatorDecl& decl);
  codeql::PrecedenceGroupDecl translatePrecedenceGroupDecl(const swift::PrecedenceGroupDecl& decl);
  codeql::ParamDecl translateParamDecl(const swift::ParamDecl& decl);
  codeql::TopLevelCodeDecl translateTopLevelCodeDecl(const swift::TopLevelCodeDecl& decl);
  codeql::PatternBindingDecl translatePatternBindingDecl(const swift::PatternBindingDecl& decl);
  codeql::ConcreteVarDecl translateVarDecl(const swift::VarDecl& decl);
  codeql::StructDecl translateStructDecl(const swift::StructDecl& decl);
  codeql::ClassDecl translateClassDecl(const swift::ClassDecl& decl);
  codeql::EnumDecl translateEnumDecl(const swift::EnumDecl& decl);
  codeql::ProtocolDecl translateProtocolDecl(const swift::ProtocolDecl& decl);
  codeql::EnumCaseDecl translateEnumCaseDecl(const swift::EnumCaseDecl& decl);
  codeql::EnumElementDecl translateEnumElementDecl(const swift::EnumElementDecl& decl);
  codeql::GenericTypeParamDecl translateGenericTypeParamDecl(
      const swift::GenericTypeParamDecl& decl);
  codeql::AssociatedTypeDecl translateAssociatedTypeDecl(const swift::AssociatedTypeDecl& decl);
  codeql::TypeAliasDecl translateTypeAliasDecl(const swift::TypeAliasDecl& decl);
  codeql::Accessor translateAccessorDecl(const swift::AccessorDecl& decl);
  codeql::SubscriptDecl translateSubscriptDecl(const swift::SubscriptDecl& decl);
  codeql::ExtensionDecl translateExtensionDecl(const swift::ExtensionDecl& decl);
  codeql::ImportDecl translateImportDecl(const swift::ImportDecl& decl);
  codeql::ModuleDecl translateModuleDecl(const swift::ModuleDecl& decl);
  codeql::IfConfigDecl translateIfConfigDecl(const swift::IfConfigDecl& decl);
  codeql::OpaqueTypeDecl translateOpaqueTypeDecl(const swift::OpaqueTypeDecl& decl);
  codeql::PoundDiagnosticDecl translatePoundDiagnosticDecl(const swift::PoundDiagnosticDecl& decl);
  codeql::MissingMemberDecl translateMissingMemberDecl(const swift::MissingMemberDecl& decl);
  codeql::CapturedDecl translateCapturedValue(const swift::CapturedValue& capture);
  codeql::MacroDecl translateMacroDecl(const swift::MacroDecl& decl);
  codeql::MacroRole translateMacroRoleAttr(const swift::MacroRoleAttr& attr);

 private:
  void fillFunction(const swift::AbstractFunctionDecl& decl, codeql::Function& entry);
  void fillOperatorDecl(const swift::OperatorDecl& decl, codeql::OperatorDecl& entry);
  void fillTypeDecl(const swift::TypeDecl& decl, codeql::TypeDecl& entry);
  void fillIterableDeclContext(const swift::IterableDeclContext& decl, codeql::Decl& entry);
  void fillVarDecl(const swift::VarDecl& decl, codeql::VarDecl& entry);
  void fillNominalTypeDecl(const swift::NominalTypeDecl& decl, codeql::NominalTypeDecl& entry);
  void fillGenericContext(const swift::GenericContext& decl, codeql::GenericContext& entry);
  void fillValueDecl(const swift::ValueDecl& decl, codeql::ValueDecl& entry);
  void fillAbstractStorageDecl(const swift::AbstractStorageDecl& decl,
                               codeql::AbstractStorageDecl& entry);

  template <typename D>
  auto createEntry(const D& decl) {
    auto entry = dispatcher.createEntry(decl);
    fillDecl(decl, entry);
    return entry;
  }

  void fillDecl(const swift::Decl& decl, codeql::Decl& entry) {
    entry.module = dispatcher.fetchLabel(decl.getModuleContext());
  }
};

}  // namespace codeql
